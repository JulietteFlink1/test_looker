# Owner: Andreas Stueber
# Created Date: 2023-02-08
# Related Ticket: https://goflink.atlassian.net/browse/DATA-5007
# Purpose: Give the finance team a source of truth for inventory valuation over define periods of time
#explore: sdt_inventory_valuation {hidden:yes}

view: sdt_inventory_valuation {
  required_access_grants: [can_view_buying_information]
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql:

with
base_data as (
    select
        inv.report_date,
        first_value(inv.report_date) over w   as start_date,
        last_value(inv.report_date)  over w   as end_date,
        inv.country_iso                       as country_iso,
        inv.hub_code                          as hub_code,
        inv.sku                               as sku,
        inv.quantity_from                     as quantity_from,
        inv.quantity_to                       as quantity_to,
        inv.quantity_to - quantity_from       as quantity_change,
        inv.number_of_total_inbound           as number_of_total_inbound,
        inv.number_of_total_correction        as number_of_total_correction,
        inv.number_of_total_outbound          as number_of_total_outbound,
        inv.number_of_unspecified             as number_of_unspecified,
        coalesce(
            price.amt_buying_price_weighted_rolling_average_net_eur,
            -- currently only gross - aligning with Brandon if we should add net prices
            -- to curated.product_prices
            price.avg_amt_selling_price_gross_eur
        )                                     as amt_buying_price_weighted_rolling_average_net_eur,
        first_value(inv.quantity_from) over w as start_stock_level,
        first_value(
            coalesce(
                price.amt_buying_price_weighted_rolling_average_net_eur,
                price.avg_amt_selling_price_gross_eur
            )
        ) over w                              as amt_start_stock_level_buying_price_weighted_rolling_average_net_eur,
        last_value(inv.quantity_to)    over w as end_stock_level,
        last_value(
            coalesce(
                price.amt_buying_price_weighted_rolling_average_net_eur,
                price.avg_amt_selling_price_gross_eur
            )
        )    over w                           as amt_end_stock_level_buying_price_weighted_rolling_average_net_eur

    from `flink-data-prod`.reporting.inventory_daily
    as inv

    left join `flink-data-prod`.reporting.product_prices_daily
    as price
    on
        price.reporting_date = inv.report_date and
        price.hub_code       = inv.hub_code    and
        price.sku            = inv.sku
    where
        true
        and {% condition select_timeframe %} inv.report_date {% endcondition %}
        and {% condition select_timeframe %} price.reporting_date {% endcondition %}
        -- and inv.report_date between '2022-11-01' and '2022-11-05'
        -- and price.reporting_date between '2022-11-01' and '2022-11-05'

        -- filter hub_code
        and {% condition select_hub %} price.hub_code {% endcondition %}
        and {% condition select_hub %} inv.hub_code {% endcondition %}

        -- filter sku
        and {% condition select_sku %} price.sku {% endcondition %}
        and {% condition select_sku %} inv.sku {% endcondition %}

    window w as (
        partition by
            inv.hub_code,
            inv.sku
        order by
            inv.report_date
        rows between
            unbounded preceding and
            unbounded following
        )
),
aggregated_data as (
    select
        country_iso,
        hub_code,
        sku,
        start_date,
        start_stock_level,
        start_stock_level
            * amt_start_stock_level_buying_price_weighted_rolling_average_net_eur as amt_start_stock_level,
        end_stock_level,
        end_stock_level
            * amt_end_stock_level_buying_price_weighted_rolling_average_net_eur   as amt_end_stock_level,
        end_date,
        # quantities
        sum(quantity_change)            as number_of_quantity_change,
        sum(number_of_total_inbound)
        + sum(number_of_total_correction)
        + sum(number_of_total_outbound)
        + sum(number_of_unspecified)    as number_of_change_reasons,
        sum(number_of_total_inbound)    as number_of_number_of_total_inbound,
        sum(number_of_total_correction) as number_of_number_of_total_correction,
        sum(number_of_total_outbound)   as number_of_number_of_total_outbound,
        sum(number_of_unspecified)      as number_of_number_of_unspecified,
        # monetary values
        sum(quantity_change
            * amt_buying_price_weighted_rolling_average_net_eur)    as amt_number_of_quantity_change,
        sum(number_of_total_inbound
            * amt_buying_price_weighted_rolling_average_net_eur)
        + sum(number_of_total_correction
            * amt_buying_price_weighted_rolling_average_net_eur)
        + sum(number_of_total_outbound
            * amt_buying_price_weighted_rolling_average_net_eur)
        + sum(number_of_unspecified
            * amt_buying_price_weighted_rolling_average_net_eur)    as amt_number_of_change_reasons,
        sum(number_of_total_inbound
            * amt_buying_price_weighted_rolling_average_net_eur)    as amt_number_of_number_of_total_inbound,
        sum(number_of_total_correction
            * amt_buying_price_weighted_rolling_average_net_eur)    as amt_number_of_number_of_total_correction,
        sum(number_of_total_outbound
            * amt_buying_price_weighted_rolling_average_net_eur)    as amt_number_of_number_of_total_outbound,
        sum(number_of_unspecified
            * amt_buying_price_weighted_rolling_average_net_eur)    as amt_number_of_number_of_unspecified

    from base_data

    group by
      1,2,3,4,5,6,7,8,9
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

  dimension: is_change_reason_explain_change_quantity {
    type: yesno
    sql: ${number_of_change_reasons} = ${number_of_quantity_change} ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: check_diff {
    # this field is used to investigate not matching differences in the stock-changelogs
    type: string
    sql: concat("select * from `flink-data-prod`.curated.inventory_changes where {% condition select_timeframe %} date(inventory_change_timestamp) {% endcondition %} and hub_code = '"
      , ${hub_code}, "'", " and sku = '", ${sku}, "' order by inventory_change_timestamp");;
    hidden: yes
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
    type: number
    hidden: yes
  }
  dimension: amt_end_stock_level {
    type: number
    hidden: yes
  }
  dimension: amt_number_of_quantity_change {
    type: number
    hidden: yes
  }
  dimension: amt_number_of_change_reasons {
    type: number
    hidden: yes
  }
  dimension: amt_number_of_number_of_total_inbound {
    type: number
    hidden: yes
  }
  dimension: amt_number_of_number_of_total_correction {
    type: number
    hidden: yes
  }
  dimension: amt_number_of_number_of_total_outbound {
    type: number
    hidden: yes
  }
  dimension: amt_number_of_number_of_unspecified {
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
  #  - - - - - - - - - -    Measures - Quantities
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  measure: sum_of_amt_start_stock_level {
    label: "€ Stock Level (Start)"
    description: "The total monetary value of the stock level at the start of the selected timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_start_stock_level} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_end_stock_level {
    label: "€ Stock Level (End)"
    description: "The total monetary value of the stock level at the start of the selected timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_end_stock_level} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_quantity_change {
    label: "€ Quantity Change"
    description: "The monetary value of all inventory movements defined by the different between quantity before and quantity after the change (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_quantity_change} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_change_reasons {
    label: "€ Total Change Reasons"
    description: "The monetary value of all inventory movements defined by the sum of all change reason types (inbounds, outbounds, corrections and unspecific)   (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_change_reasons} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_number_of_total_correction {
    label: "€ Corrected Items"
    description: "The monetary value of all inventory corrections in the defined timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_number_of_total_correction} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_number_of_total_inbound {
    label: "€ Inbounded Items"
    description: "The monetary value of all inventory inbounds in the defined timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_number_of_total_inbound} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_number_of_total_outbound {
    label: "€ Outbounded Items"
    description: "The monetary value of all inventory outbounds (sales and too-good-to-go) in the defined timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_number_of_total_outbound} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_number_of_number_of_unspecified {
    label: "€ Items With Unspecified Inventory Movements"
    description: "The monetary value of all unspecified inventory in the defined timeframe (valued by weighted average cost and substitute with the selling price, in case the cost does not exist)"
    group_label: "> Monetary Metrics"
    type: sum
    sql: ${amt_number_of_number_of_unspecified} ;;
    value_format_name: eur
  }

}
