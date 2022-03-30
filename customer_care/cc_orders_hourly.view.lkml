view: cc_orders_hourly {
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

  dimension: number_of_cc_discounted_orders_free_delivery {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_cc_discounted_orders_free_delivery ;;
  }

  dimension: number_of_cc_discounted_orders_5_euros {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_cc_discounted_orders_5_euros ;;
  }

  dimension: amt_cc_discount_value {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_cc_discount_value ;;
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
    group_label: "* Refunds *"
    label: "# CC Refunded Orders"
    type: sum
    sql: ${number_of_refunded_orders} ;;
  }

  measure: sum_number_of_refunded_orders_over_5 {
    group_label: "* Refunds *"
    label: "# CC Refunded Orders >5 euros"
    type: sum
    sql: ${number_of_refunded_orders_over_5} ;;
  }

  measure: sum_number_of_cc_discounted_orders {
    group_label: "* Discounts *"
    label: "# CC Discounted Orders"
    type: sum
    sql: ${number_of_cc_discounted_orders} ;;
  }

  measure: sum_number_of_cc_discounted_orders_free_delivery {
    group_label: "* Discounts *"
    label: "# Free Delivery CC Discounted Orders"
    type: sum
    sql: ${number_of_cc_discounted_orders_free_delivery} ;;
  }

  measure: sum_number_of_cc_discounted_orders_5_euros {
    group_label: "* Discounts *"
    label: "# 5euros CC Discounted Orders"
    type: sum
    sql: ${number_of_cc_discounted_orders_5_euros} ;;
  }

  measure: sum_amt_cc_discount_value {
    label: "Total CC Discount Value"
    group_label: "* Discounts *"
    type: sum
    sql: ${amt_cc_discount_value} ;;
  }

  measure: contact_rate {
    label: "% Contact Rate"
    description: "# Conversations / # Orders "
    type: number
    value_format: "0.0%"
    sql:  safe_divide(${cc_conversations.number_of_conversations},${sum_number_of_orders})  ;;
  }

  measure: cc_refunded_order_rate {
    group_label: "* Refunds *"
    label: "% Refunded Orders"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_refunded_orders},${sum_number_of_orders}) ;;
  }

  measure: cc_refunded_order_over_5_rate {
    label: "% Refunded Orders over 5euros / Refunded Orders"
    description: "# Refunded Orders over 5euros / # Refunded Orders"
    type: number
    group_label: "* Refunds *"
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_refunded_orders_over_5},${sum_number_of_refunded_orders}) ;;
  }

  measure: cc_refunded_order_over_5_contact_rate {
    group_label: "* Refunds *"
    label: "% Refunded Orders over 5euros / Contacts"
    description: "# Refunded Orders over 5euros / # Contacts"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_refunded_orders_over_5},${cc_conversations.number_of_conversations}) ;;
  }

  measure: cc_discounted_order_rate {
    group_label: "* Discounts *"
    label: "% CC Discounted Orders"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_cc_discounted_orders},${sum_number_of_orders}) ;;
  }

  measure: cc_discounted_orders_free_delivery {
    group_label: "* Discounts *"
    label: "% Free Delivery Discounts"
    description: "# CC Free Delivery Discounts Used / # CC Discounts Used"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_cc_discounted_orders_free_delivery},${sum_number_of_cc_discounted_orders}) ;;
  }

  measure: cc_discounted_orders_5_euros {
    group_label: "* Discounts *"
    label: "% 5euros Discounts"
    description: "# CC 5euros Discounts Used / # CC Discounts Used"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_cc_discounted_orders_5_euros},${sum_number_of_cc_discounted_orders}) ;;
  }

  measure: avg_discount_value {
    group_label: "* Discounts *"
    label: "AVG CC discount Value per Contact"
    description: "Total CC Discount Value / Contact"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_amt_cc_discount_value},${cc_conversations.number_of_conversations}) ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
