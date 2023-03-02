# Owner: Andreas Stueber
# Created Date: 2023-02-08
# Related Ticket: https://goflink.atlassian.net/browse/DATA-5007
# Purpose: Give the finance team a source of truth for inventory valuation over define periods of time
#explore: sdt_inventory_valuation {hidden:yes}

view: sdt_inventory_valuation {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql:

with
vars as (
    select
        --date('2023-01-01') as start_date,
        {% date_start select_timeframe %} as start_date,
        --date('2023-01-31') as end_date

        -- needed, as the range-filter say "before date" but the date_end field is the actually entered date
        date_sub({% date_end select_timeframe %}, interval 1 day)   as end_date
),



base_data as (
    select
        inv.report_date                       as report_date,
        inv.country_iso                       as country_iso,
        inv.hub_code                          as hub_code,
        inv.sku                               as sku,
        erp_data.supplier_id                  as supplier_id,
        erp_data.supplier_name                as supplier_name,
        inv.quantity_from                     as quantity_from,
        inv.quantity_to                       as quantity_to,
        inv.quantity_to - quantity_from       as quantity_change,
        inv.number_of_total_inbound           as number_of_total_inbound,
        inv.number_of_total_correction        as number_of_total_correction,
        inv.number_of_total_outbound          as number_of_total_outbound,
        inv.number_of_unspecified             as number_of_unspecified,
        inv.number_of_total_inbound
        + inv.number_of_total_correction
        + inv.number_of_total_outbound
        + inv.number_of_unspecified           as number_of_change_reasons,
        coalesce(
            price.amt_buying_price_weighted_rolling_average_net_eur,
            -- currently only gross - aligning with Brandon if we should add net prices
            -- to curated.product_prices
            price.avg_amt_selling_price_gross_eur
        )                                     as amt_buying_price_weighted_rolling_average_net_eur

    from flink-data-prod.reporting.inventory_daily
    as inv

    left join flink-data-prod.reporting.product_prices_daily
    as price
    on
        price.reporting_date = inv.report_date and
        price.hub_code       = inv.hub_code    and
        price.sku            = inv.sku

    left join flink-data-prod.curated.erp_product_hub_vendor_assignment_unfiltered
    as erp_data
    on
        erp_data.report_date = inv.report_date and
        erp_data.hub_code    = inv.hub_code    and
        erp_data.sku         = inv.sku
    where
        true
        and inv.report_date between (select start_date from vars) and (select end_date from vars)

        -- filter hub_code
        and {% condition select_hub %} inv.hub_code {% endcondition %}

        -- filter sku
        and {% condition select_sku %} inv.sku {% endcondition %}
),

base_data_with_prices as (
    select
        *,
        quantity_from * amt_buying_price_weighted_rolling_average_net_eur               as amt_quantity_from,
        quantity_to * amt_buying_price_weighted_rolling_average_net_eur                 as amt_quantity_to,
        quantity_change * amt_buying_price_weighted_rolling_average_net_eur             as amt_quantity_change,
        number_of_total_inbound * amt_buying_price_weighted_rolling_average_net_eur     as amt_number_of_total_inbound,
        number_of_total_correction * amt_buying_price_weighted_rolling_average_net_eur  as amt_number_of_total_correction,
        number_of_total_outbound * amt_buying_price_weighted_rolling_average_net_eur    as amt_number_of_total_outbound,
        number_of_unspecified * amt_buying_price_weighted_rolling_average_net_eur       as amt_number_of_unspecified,
        number_of_change_reasons * amt_buying_price_weighted_rolling_average_net_eur    as amt_number_of_change_reasons

    from base_data
),

start_data as (

    select

        country_iso,
        hub_code,
        sku,
        report_date             as start_date,
        cast(null as date)      as end_date,
        string_agg(distinct supplier_id, ', ' order by supplier_id)     as supplier_id,
        string_agg(distinct supplier_name, ', ' order by supplier_name) as supplier_name,
        sum(quantity_from)      as start_stock_level,
        sum(amt_quantity_from)  as amt_start_stock_level,
        sum(0)                  as end_stock_level,
        sum(0)                  as amt_end_stock_level,
        sum(0)                  as number_of_quantity_change,
        sum(0)                  as number_of_change_reasons,
        sum(0)                  as number_of_number_of_total_inbound,
        sum(0)                  as number_of_number_of_total_correction,
        sum(0)                  as number_of_number_of_total_outbound,
        sum(0)                  as number_of_number_of_unspecified,
        sum(0)                  as amt_number_of_quantity_change,
        sum(0)                  as amt_number_of_change_reasons,
        sum(0)                  as amt_number_of_number_of_total_inbound,
        sum(0)                  as amt_number_of_number_of_total_correction,
        sum(0)                  as amt_number_of_number_of_total_outbound,
        sum(0)                  as amt_number_of_number_of_unspecified

    from base_data_with_prices

    where report_date = (select start_date from vars)

    group by 1,2,3,4,5
),

end_data as (

    select

        country_iso,
        hub_code,
        sku,
        cast(null as date)      as start_date,
        report_date             as end_date,
        string_agg(distinct supplier_id, ', ' order by supplier_id)     as supplier_id,
        string_agg(distinct supplier_name, ', ' order by supplier_name) as supplier_name,
        sum(0)                  as start_stock_level,
        sum(0)                  as amt_start_stock_level,
        sum(quantity_to)        as end_stock_level,
        sum(amt_quantity_to)    as amt_end_stock_level,
        sum(0)                  as number_of_quantity_change,
        sum(0)                  as number_of_change_reasons,
        sum(0)                  as number_of_number_of_total_inbound,
        sum(0)                  as number_of_number_of_total_correction,
        sum(0)                  as number_of_number_of_total_outbound,
        sum(0)                  as number_of_number_of_unspecified,
        sum(0)                  as amt_number_of_quantity_change,
        sum(0)                  as amt_number_of_change_reasons,
        sum(0)                  as amt_number_of_number_of_total_inbound,
        sum(0)                  as amt_number_of_number_of_total_correction,
        sum(0)                  as amt_number_of_number_of_total_outbound,
        sum(0)                  as amt_number_of_number_of_unspecified

    from base_data_with_prices

    where report_date = (select end_date from vars)

    group by 1,2,3,4,5
),

changes_data as (

    select

        country_iso,
        hub_code,
        sku,
        cast(null as date)                  as start_date,
        cast(null as date)                  as end_date,
        string_agg(distinct supplier_id, ', ' order by supplier_id)     as supplier_id,
        string_agg(distinct supplier_name, ', ' order by supplier_name) as supplier_name,
        sum(0)                              as start_stock_level,
        sum(0)                              as amt_start_stock_level,
        sum(0)                              as end_stock_level,
        sum(0)                              as amt_end_stock_level,
        sum(quantity_change)                as number_of_quantity_change,
        sum(number_of_change_reasons)       as number_of_change_reasons,
        sum(number_of_total_inbound)        as number_of_number_of_total_inbound,
        sum(number_of_total_correction)     as number_of_number_of_total_correction,
        sum(number_of_total_outbound)       as number_of_number_of_total_outbound,
        sum(number_of_unspecified)          as number_of_number_of_unspecified,
        sum(amt_quantity_change)            as amt_number_of_quantity_change,
        sum(amt_number_of_change_reasons)   as amt_number_of_change_reasons,
        sum(amt_number_of_total_inbound)    as amt_number_of_number_of_total_inbound,
        sum(amt_number_of_total_correction) as amt_number_of_number_of_total_correction,
        sum(amt_number_of_total_outbound)   as amt_number_of_number_of_total_outbound,
        sum(amt_number_of_unspecified)      as amt_number_of_number_of_unspecified,

    from base_data_with_prices

    group by 1,2,3,4,5
),

aggregated_data as (

    select
        country_iso,
        hub_code,
        sku,
        string_agg(distinct supplier_id, ', ' order by supplier_id)     as supplier_id,
        string_agg(distinct supplier_name, ', ' order by supplier_name) as supplier_name,
        min(start_date)                                 as start_date,
        max(end_date)                                   as end_date,
        sum(coalesce(start_stock_level, 0))                          as start_stock_level,
        sum(coalesce(amt_start_stock_level, 0))                      as amt_start_stock_level,
        sum(coalesce(end_stock_level, 0))                            as end_stock_level,
        sum(coalesce(amt_end_stock_level, 0))                        as amt_end_stock_level,
        sum(coalesce(number_of_quantity_change, 0))                  as number_of_quantity_change,
        sum(coalesce(number_of_change_reasons, 0))                   as number_of_change_reasons,
        sum(coalesce(number_of_number_of_total_inbound, 0))          as number_of_number_of_total_inbound,
        sum(coalesce(number_of_number_of_total_correction, 0))       as number_of_number_of_total_correction,
        sum(coalesce(number_of_number_of_total_outbound, 0))         as number_of_number_of_total_outbound,
        sum(coalesce(number_of_number_of_unspecified, 0))            as number_of_number_of_unspecified,
        sum(coalesce(amt_number_of_quantity_change, 0))              as amt_number_of_quantity_change,
        sum(coalesce(amt_number_of_change_reasons, 0))               as amt_number_of_change_reasons,
        sum(coalesce(amt_number_of_number_of_total_inbound, 0))      as amt_number_of_number_of_total_inbound,
        sum(coalesce(amt_number_of_number_of_total_correction, 0))   as amt_number_of_number_of_total_correction,
        sum(coalesce(amt_number_of_number_of_total_outbound, 0))     as amt_number_of_number_of_total_outbound,
        sum(coalesce(amt_number_of_number_of_unspecified, 0))        as amt_number_of_number_of_unspecified,

    from(

    (select * from start_data)
    union all
    (select * from end_data)
    union all
    (select * from changes_data))

    group by 1,2,3

)
select * from aggregated_data

;;
}

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Filter
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  filter: select_timeframe {
    group_label: "> Filter"
    datatype: date
    type: date
    default_value: "last 2 days"
  }

  filter: select_hub {
    group_label: "> Filter"
    type: string
    suggest_dimension: hub_code
  }

  filter: select_sku {
    group_label: "> Filter"
    type: string
    suggest_dimension: sku
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Main Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: hub_code {hidden:yes}
  dimension: country_iso {hidden:yes}
  dimension: sku {hidden:yes}

  dimension: start_date {
    label: "Start Date"
    description: "The first date of the filtered timeframe"
    type: date
    datatype: date
  }

  dimension: end_date {
    label: "End Date"
    description: "The last date of the filtered timeframe"
    type: date
    datatype: date
  }

  dimension: supplier_id {
    label: "Supplier ID"
    type: string
  }

  dimension: supplier_name {
    label: "Supplier Name"
    type: string
  }

  dimension: is_change_reason_explain_change_quantity {
    type: yesno
    sql: ${number_of_change_reasons} = ${number_of_quantity_change} ;;
  }

  dimension: is_filter_too_high_stock_level {
    label: "Filter Too High Stock (< 999)"
    description: "This filter is intended to filter unnaturall high stock levels in hubs (e,g, 999.999 Ukraine Donations in de_ber_alex)"
    type: yesno
    sql: not (coalesce(${start_stock_level},0) > 999 or coalesce(${end_stock_level}, 0) > 999) ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: check_diff {
    # this field is used to investigate not matching differences in the stock-changelogs
    type: string
    group_label: "Debugging"
    sql: concat("select * from `flink-data-prod`.curated.inventory_changes where {% condition select_timeframe %} date(inventory_change_timestamp) {% endcondition %} and hub_code = '"
      , ${hub_code}, "'", " and sku = '", ${sku}, "' order by inventory_change_timestamp");;
    hidden: no
  }

  dimension: start_stock_level {
    type: number
    hidden: yes
  }
  dimension: end_stock_level {
    type: number
    hidden: yes
  }

  dimension: number_of_quantity_change {
    type: number
    hidden: yes
  }
  dimension: number_of_change_reasons {
    type: number
    hidden: yes
  }
  dimension: number_of_number_of_total_inbound {
    type: number
    hidden: yes
  }
  dimension: number_of_number_of_total_correction {
    type: number
    hidden: yes
  }
  dimension: number_of_number_of_total_outbound {
    type: number
    hidden: yes
  }
  dimension: number_of_number_of_unspecified {
    type: number
    hidden: yes
  }
  dimension: amt_start_stock_level {
    required_access_grants: [can_view_buying_information]
    type: number
    hidden: yes
  }
  dimension: amt_end_stock_level {
    required_access_grants: [can_view_buying_information]
    type: number
    hidden: yes
  }
  dimension: amt_number_of_quantity_change {
    required_access_grants: [can_view_buying_information]
    type: number
    hidden: yes
  }
  dimension: amt_number_of_change_reasons {
    required_access_grants: [can_view_buying_information]
    type: number
    hidden: yes
  }
  dimension: amt_number_of_number_of_total_inbound {
    required_access_grants: [can_view_buying_information]
    type: number
    hidden: yes
  }
  dimension: amt_number_of_number_of_total_correction {
    required_access_grants: [can_view_buying_information]
    type: number
    hidden: yes
  }
  dimension: amt_number_of_number_of_total_outbound {
    required_access_grants: [can_view_buying_information]
    type: number
    hidden: yes
  }
  dimension: amt_number_of_number_of_unspecified {
    required_access_grants: [can_view_buying_information]
    type: number
    hidden: yes
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Measures - Quantities
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  measure: sum_of_start_stock_level {
    label: "# Stock Level (Start)"
    description: "The total stock level at the start of the selected timeframe"
    group_label: "> Absolute Metrics"
    type: sum
    sql: ${start_stock_level} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_end_stock_level {
    label: "# Stock Level (End)"
    description: "The total stock level at the start of the selected timeframe"
    group_label: "> Absolute Metrics"
    type: sum
    sql: ${end_stock_level} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_number_of_quantity_change {
    label: "# Quantity Change"
    description: "The sum of all inventory movements defined by the different between quantity before and quantity after the change"
    group_label: "> Absolute Metrics"
    type: sum
    sql: ${number_of_quantity_change} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_number_of_change_reasons {
    label: "# Total Change Reasons"
    description: "The sum of all inventory movements defined by the sum of all change reason types (inbounds, outbounds, corrections and unspecific)"
    group_label: "> Absolute Metrics"
    type: sum
    sql: ${number_of_change_reasons} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_number_of_number_of_total_correction {
    label: "# Corrected Items"
    description: "The sum of all inventory corrections in the defined timeframe"
    group_label: "> Absolute Metrics"
    type: sum
    sql: ${number_of_number_of_total_correction} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_number_of_number_of_total_inbound {
    label: "# Inbounded Items"
    description: "The sum of all inventory inbounds in the defined timeframe"
    group_label: "> Absolute Metrics"
    type: sum
    sql: ${number_of_number_of_total_inbound} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_number_of_number_of_total_outbound {
    label: "# Outbounded Items"
    description: "The sum of all inventory outbounds (sales and too-good-to-go) in the defined timeframe"
    group_label: "> Absolute Metrics"
    type: sum
    sql: ${number_of_number_of_total_outbound} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_number_of_number_of_unspecified {
    label: "# Items With Unspecified Inventory Movements"
    description: "The sum of all unspecified inventory in the defined timeframe"
    group_label: "> Absolute Metrics"
    type: sum
    sql: ${number_of_number_of_unspecified} ;;
    value_format_name: decimal_0
  }

  measure: cnt {
    label: "# Rows"
    group_label: "> Absolute Metrics"
    type: count
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Measures - Monetary
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  measure: sum_of_amt_start_stock_level {
    required_access_grants: [can_view_buying_information]
    label: "€ Stock Level (Start)"
    description: "The total monetary value of the stock level at the start of the selected timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_start_stock_level} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_end_stock_level {
    required_access_grants: [can_view_buying_information]
    label: "€ Stock Level (End)"
    description: "The total monetary value of the stock level at the start of the selected timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_end_stock_level} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_quantity_change {
    required_access_grants: [can_view_buying_information]
    label: "€ Quantity Change"
    description: "The monetary value of all inventory movements defined by the different between quantity before and quantity after the change (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_quantity_change} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_change_reasons {
    required_access_grants: [can_view_buying_information]
    label: "€ Total Change Reasons"
    description: "The monetary value of all inventory movements defined by the sum of all change reason types (inbounds, outbounds, corrections and unspecific)   (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_change_reasons} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_number_of_total_correction {
    required_access_grants: [can_view_buying_information]
    label: "€ Corrected Items"
    description: "The monetary value of all inventory corrections in the defined timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_number_of_total_correction} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_number_of_total_inbound {
    required_access_grants: [can_view_buying_information]
    label: "€ Inbounded Items"
    description: "The monetary value of all inventory inbounds in the defined timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_number_of_total_inbound} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_number_of_total_outbound {
    required_access_grants: [can_view_buying_information]
    label: "€ Outbounded Items"
    description: "The monetary value of all inventory outbounds (sales and too-good-to-go) in the defined timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_number_of_total_outbound} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_number_of_unspecified {
    required_access_grants: [can_view_buying_information]
    label: "€ Items With Unspecified Inventory Movements"
    description: "The monetary value of all unspecified inventory in the defined timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_number_of_unspecified} ;;
    value_format_name: eur
  }

}
