# Owner: Andreas Stueber
# Created Date: 2023-02-08
# Related Ticket: https://goflink.atlassian.net/browse/DATA-5007
# Purpose: Give the finance team a source of truth for inventory valuation over define periods of time

explore: sdt_inventory_valuation {
  hidden: yes
}

view: sdt_inventory_valuation {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql:

with
base_data as (
    select
        inv.report_date,
        first_value(inv.report_date) over w   as start_date,
        last_value(inv.report_date)  over w   as end_date,
        inv.hub_code                          as hub_code,
        inv.sku                               as sku,
        inv.quantity_from                     as quantity_from,
        inv.quantity_to                       as quantity_to,
        inv.quantity_to - quantity_from       as quantity_change,
        inv.number_of_total_inbound           as number_of_total_inbound,
        inv.number_of_total_correction        as number_of_total_correction,
        inv.number_of_total_outbound          as number_of_total_outbound,
        inv.number_of_unspecified             as number_of_unspecified,
        first_value(inv.quantity_from) over w as start_stock_level,
        last_value(inv.quantity_to)    over w as end_stock_level
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
        hub_code,
        sku,
        start_date,
        start_stock_level,
        end_stock_level,
        end_date,
        sum(quantity_change)            as sum_of_quantity_change,
        sum(number_of_total_inbound)
        + sum(number_of_total_correction)
        + sum(number_of_total_outbound)
        + sum(number_of_unspecified)    as sum_of_change_reasons,
        sum(number_of_total_inbound)    as sum_of_number_of_total_inbound,
        sum(number_of_total_correction) as sum_of_number_of_total_correction,
        sum(number_of_total_outbound)   as sum_of_number_of_total_outbound,
        sum(number_of_unspecified)      as sum_of_number_of_unspecified

    from base_data

    group by
      1,2,3,4,5,6
)
select * from aggregated_data

;;}

  filter: select_timeframe {
    datatype: date
    type: date
  }

  dimension: hub_code {}
  dimension: sku {}
  dimension: start_date {
    type: date
    datatype: date
  }
  dimension: start_stock_level {
    type: number
  }
  dimension: end_stock_level {
    type: number
  }
  dimension: end_date {
    type: date
    datatype: date
  }
  dimension: sum_of_quantity_change {
    type: number
  }
  dimension: sum_of_change_reasons {
    type: number
  }
  dimension: sum_of_number_of_total_inbound {
    type: number
  }
  dimension: sum_of_number_of_total_correction {
    type: number
  }
  dimension: sum_of_number_of_total_outbound {
    type: number
  }
  dimension: sum_of_number_of_unspecified {
    type: number
  }

  dimension: is_change_reason_explain_change_quantity {
    type: yesno
    sql: ${sum_of_change_reasons} = ${sum_of_quantity_change} ;;
  }

  dimension: check_diff {
    type: string
    sql: concat("select * from `flink-data-prod`.curated.inventory_changes where {% condition select_timeframe %} date(inventory_change_timestamp) {% endcondition %} and hub_code = '"
    , ${hub_code}, "'", " and sku = '", ${sku}, "' order by inventory_change_timestamp");;
  }

  measure: cnt {
    type: count
  }
}
