view: web_checkout_analysis {
  derived_table: {
    sql:
WITH payment_started AS (
SELECT date(timestamp) as event_date
    , anonymous_id
    , event_text
    , payment_method
    , step
 FROM `flink-data-prod.flink_website_production.checkout_step_completed`
 WHERE DATE(_PARTITIONTIME) >= "2021-11-20"
 and step = 4
group by 1,2,3,4,5
 order by anonymous_id, event_date
)

, errors AS (
SELECT date(timestamp) as event_date
    , anonymous_id
    , event_text
    , error
 FROM `flink-data-prod.flink_website_production.payment_failed`
 WHERE DATE(_PARTITIONTIME) >= "2021-11-20"
group by 1,2,3,4
 order by anonymous_id, event_date
)

, order_completed AS (
SELECT date(timestamp) as event_date
    , anonymous_id
    , event_text
 FROM `flink-data-prod.flink_website_production.order_completed`
 WHERE DATE(_PARTITIONTIME) >= "2021-11-20"
group by 1,2,3
 order by anonymous_id, event_date
)

SELECT payment_started.event_date
    , payment_method
    , count(distinct payment_started.anonymous_id) as count_users_payment_started
    , count(distinct errors.anonymous_id) as count_users_errors
    , count(distinct order_completed.anonymous_id) as count_users_order_completed
from payment_started
LEFT JOIN errors
on payment_started.event_date  = errors.event_date
LEFT JOIN order_completed
on payment_started.event_date  = order_completed.event_date
group by 1,2
 ;;
  }


  dimension_group: event_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.event_date AS DATE) ;;
    datatype: date
  }

  dimension: payment_method {
      type: string
      sql: ${TABLE}.payment_method ;;
    }

  measure: count_users_payment_started {
    type: sum
    sql: ${TABLE}.count_users_payment_started ;;
  }

  measure: count_users_errors {
    type: sum
    sql: ${TABLE}.count_users_errors ;;
  }

  measure: count_users_order_completed {
    type: sum
    sql: ${TABLE}.count_users_order_completed ;;
  }


}
