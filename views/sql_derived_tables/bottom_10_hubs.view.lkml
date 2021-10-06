view: bottom_10_hubs {
  derived_table: {
    sql: with hubs_kpis as (
    select order_date
    , hub_code
    , country_iso
    , sum(number_of_orders_delayed_under_0_min) as sum_of_orders_delayed_under_0_min
    , sum(number_of_orders_with_delivery_eta_available) as sum_of_orders_with_delivery_eta
    , (sum(number_of_orders_delayed_under_0_min)/nullif(sum(number_of_orders_with_delivery_eta_available),0)*100) as pct_delivery_in_time
    , sum(number_of_orders_with_issues)/(nullif(sum(number_of_orders),0)*100) as issue_rate
from `flink-data-prod.reporting.hub_level_kpis`
group by 1, 2, 3
),

ranked as (
    select *
    , row_number() OVER (PARTITION BY order_date ORDER BY pct_delivery_in_time asc) as delivery_rank
    , row_number() OVER (PARTITION BY order_date ORDER BY issue_rate desc) as issues_rank
from hubs_kpis
where pct_delivery_in_time is not null
)

select hub_code
    , country_iso
    , order_date
    , if(r.delivery_rank<=10, 1, 0) as is_bottom_10_delivery
    , if(r.issues_rank<=10, 1, 0) as is_bottom_10_issues
from ranked r

       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: uuid {
    type: string
    sql: concat(${TABLE}.hub_code, cast(${TABLE}.order_date as string))
    ;;
    primary_key: yes
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: order_date {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: is_bottom_10_delivery {
    type: number
    sql: ${TABLE}.is_bottom_10_delivery ;;
  }

  dimension: is_bottom_10_issues {
    type: number
    sql: ${TABLE}.is_bottom_10_issues ;;
  }

  measure: cnt_bottom_10_delivery {
    label: "# Bottom 10 Orders Delivered in Time"
    description: "The total number of times at bottom 10 for orders delivered in time"
    type: sum
    sql: ${is_bottom_10_delivery} ;;
      }

  measure: cnt_is_bottom_10_issues {
    label: "# Bottom 10 Issue Rate"
    description: "The total number of times at bottom 10 for issue rate"
    type: sum
    sql: ${is_bottom_10_issues} ;;
      }

  set: detail {
    fields: [hub_code, order_date, is_bottom_10_delivery, is_bottom_10_issues]
  }
}
