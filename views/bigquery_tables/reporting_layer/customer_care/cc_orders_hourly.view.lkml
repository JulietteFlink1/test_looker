view: cc_orders_hourly {
  sql_table_name: `flink-data-dev.reporting.cc_orders_hourly`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: number_of_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension_group: order_timestamp {
    type: time
    timeframes: [
      hour,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.order_hour_timestamp ;;
  }

  dimension: orders_hourly_uuid {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.orders_hourly_uuid ;;
  }

  measure: sum_number_of_orders {
    label: "# Orders"
    type: sum
    sql: ${number_of_orders} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
