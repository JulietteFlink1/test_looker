view: web_checkout_errors {
  derived_table: {
  sql:  WITH errors AS (
SELECT date(timestamp) as event_date
    , anonymous_id
    , event_text
    , error
 FROM `flink-data-prod.flink_website_production.payment_failed`
 WHERE DATE(_PARTITIONTIME) >= "2021-11-01"
group by 1,2,3,4
 order by anonymous_id, event_date
)

SELECT event_date
    , error
    , count(distinct anonymous_id) as count_users
from errors
group by 1,2 ;;
 }

  measure: count_users {
    type: sum
    sql: ${TABLE}.count_users ;;
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

  dimension: error {
    type: string
    sql: ${TABLE}.error ;;
  }

}
