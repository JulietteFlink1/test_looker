view: mktg_exit_poll {
  sql_table_name: `flink-data-prod.curated.exit_poll`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: last_order_number {
    type: string
    sql: ${TABLE}.last_order_number ;;
  }

  dimension_group: last_order {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_order_timestamp ;;
  }

  dimension: poll_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.poll_uuid ;;
  }

  dimension: response {
    type: string
    sql: ${TABLE}.response ;;
  }

  dimension: shipping_city {
    type: string
    sql: ${TABLE}.shipping_city ;;
  }

  dimension_group: submit {
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
    sql: ${TABLE}.submit_date ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
