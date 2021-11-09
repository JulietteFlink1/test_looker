view: gorillas_promise_time {
  sql_table_name: `flink-data-dev.gorillas_v2.promise_time`
    ;;

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: message {
    type: string
    sql: ${TABLE}.message ;;
  }

  dimension: promise_time {
    type: number
    sql: ${TABLE}.promiseTime ;;
  }

  dimension_group: time_scraped {
    type: time
    description: "bq-datetime"
    timeframes: [
      raw,
      minute,
      minute10,
      minute15,
      minute30,
      hour,
      hour2,
      hour4,
      hour6,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.time_scraped ;;
  }

  measure: avg_promise_time {
    type: average
    sql: ${promise_time} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
