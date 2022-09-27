view: orders_aggregated {
  sql_table_name: `flink-data-prod.reporting.orders_aggregated`
    ;;

  dimension: unique_id {
    type: string
    hidden: yes
    primary_key: yes
    sql: concat(${TABLE}.city,${TABLE}.start_period,${TABLE}.end_period) ;;

  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: end_period {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.end_period ;;
  }

  dimension: orders {
    type: number
    sql: ${TABLE}.orders ;;
  }

  dimension_group: start_period {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.start_period ;;
  }

  measure: total_orders {
    label: "# orders"
    type:sum
    sql: ${orders};;
    value_format_name: decimal_0
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
