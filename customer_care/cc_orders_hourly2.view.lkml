view: cc_orders_hourly2 {
  sql_table_name: `flink-data-prod.reporting.cc_orders_hourly`
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

  dimension: number_of_cc_discounted_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_cc_discounted_orders ;;
  }

  dimension: number_of_refunded_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_refunded_orders ;;
  }

  dimension: number_of_refunded_orders_over_5 {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_refunded_orders_over_5 ;;
  }

  dimension_group: order_timestamp {
    hidden: yes
    type: time
    timeframes: [
      hour,
      time,
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

  measure: sum_number_of_refunded_orders {
    label: "# CC Refunded Orders"
    type: sum
    sql: ${number_of_refunded_orders} ;;
  }

  measure: sum_number_of_refunded_orders_over_5 {
    label: "# CC Refunded Orders >5 euros"
    type: sum
    sql: ${number_of_refunded_orders_over_5} ;;
  }

  measure: sum_number_of_cc_discounted_orders {
    label: "# CC Discounted Orders"
    type: sum
    sql: ${number_of_cc_discounted_orders} ;;
  }

  measure: contact_rate {
    label: "% Contact Rate"
    description: "# Contacts / # Orders "
    type: number
    value_format: "0.0%"
    sql:  safe_divide(${cc_contacts.number_of_contacts},${sum_number_of_orders})  ;;
  }

  measure: cc_refunded_order_rate {
    label: "% Refunded Orders"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_refunded_orders},${sum_number_of_orders}) ;;
  }

  measure: cc_refunded_order_over_5_rate {
    label: "% Refunded Orders over 5euros / Refunded Orders"
    description: "# Refunded Orders over 5euros / # Refunded Orders"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_refunded_orders_over_5},${sum_number_of_refunded_orders}) ;;
  }

  measure: cc_refunded_order_over_5_contact_rate {
    label: "% Refunded Orders over 5euros / Contacts"
    description: "# Refunded Orders over 5euros / # Contacts"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_refunded_orders_over_5},${cc_contacts.number_of_contacts}) ;;
  }



  measure: cc_discounted_order_rate {
    label: "% CC Discounted Orders"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_cc_discounted_orders},${sum_number_of_orders}) ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
