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

  dimension: number_of_orders_all {
    hidden:  yes
    type:  number
    sql: ${TABLE}.number_of_orders_all ;;
  }

  dimension: amt_gmv_gross {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
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

  dimension: amt_discount_value {
    hidden: yes
    type:  number
    sql: ${TABLE}.amt_discount_value ;;
  }

  dimension: number_of_refunded_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_refunded_orders_post_issues ;;
  }

  dimension: number_of_refunded_orders_over_5 {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_refunded_orders_post_issues_over_5 ;;
  }

  dimension: number_of_fully_cc_cancelled_orders {
    hidden:  yes
    type:  number
    sql: ${TABLE}.number_of_fully_cc_cancelled_orders ;;
  }

  dimension: number_of_partially_cancelled_orders {
    hidden:  yes
    type:  number
    sql: ${TABLE}.number_of_partially_cancelled_orders ;;
  }

  dimension: number_of_refunded_orders_perished_light {
    hidden:  yes
    type:  number
    sql: ${TABLE}.number_of_refunded_orders_perished_light ;;
  }

  dimension: number_of_orders_no_return_reason_but_items_returned {
    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_orders_no_return_reason_but_items_returned ;;
  }

  dimension: amt_refunded_post_issues {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_refunded_post_issues ;;
  }

  dimension: amt_refunded_fully_cc_cancelled {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_refunded_fully_cc_cancelled ;;
  }

  dimension: amt_refunded_partially_cancelled {
    hidden:  yes
    type:  number
    sql: ${TABLE}.amt_refunded_partially_cancelled ;;
  }

  dimension: amt_refunded_perished_light {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_refunded_perished_light ;;
  }

  dimension: amt_refund_orders_no_return_reason_but_items_returned {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_orders_no_return_reason_but_items_returned ;;
  }

  dimension: amt_refund_total {
    hidden: yes
    type:  number
    sql: ${TABLE}.amt_refund_total ;;
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
    label: "# Successful Orders"
    description: "Number of successful orders"
    type: sum
    sql: ${number_of_orders} ;;
  }

  measure: sum_number_of_orders_all{
    label:  "# Orders"
    description: "Number of orders, includes unsuccessful ones."
    type: sum
    sql: ${number_of_orders_all} ;;
  }

  measure: sum_amt_gmv_gross {
    label: "GMV (Gross)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    type: sum
    sql: ${amt_gmv_gross} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_number_of_refunded_orders {
    group_label: "* Refunds *"
    label: "# CC Refunded Orders (Post Issues)"
    description: "Number of orders that had a post delivery issue leading to a refund by a CC agent.
    Includes Perished Light issues. Excludes fully refunded orders."
    type: sum
    sql: ${number_of_refunded_orders} ;;
  }

  measure: sum_number_of_refunded_orders_over_5 {
    group_label: "* Refunds *"
    label: "# CC Refunded Orders >5 euros (Post Issues)"
    description: "Number of orders that had a post delivery issue leading to a refund > 5 euros by a CC agent"
    type: sum
    sql: ${number_of_refunded_orders_over_5} ;;
  }

  measure: sum_number_of_fully_cc_cancelled_orders {
    group_label: "* Refunds *"
    label: "# CC Fully Cancelled Orders"
    description: "Number of orders that were fully cancelled and refunded by CC Agents"
    type: sum
    sql: ${number_of_fully_cc_cancelled_orders} ;;
  }

  measure: sum_number_of_partially_cancelled_orders {
    group_label: "* Refunds *"
    label: "# CC Partially Cancelled Orders"
    description: "Number of orders that had some items cancelled by CC Agents.
      Excludes orders with all products returned but only some marked as cancelled."
    type: sum
    sql: ${number_of_partially_cancelled_orders} ;;
  }

  measure: sum_number_of_refunded_orders_perished_light {
    group_label: "* Refunds *"
    label: "# CC Refunded Orders Perished Light"
    description: "Number of orders that had some items refunded by CC Agents due to perished light issues."
    type: sum
    sql: ${number_of_refunded_orders_perished_light} ;;
  }

  measure: sum_number_of_orders_no_return_reason_but_items_returned {
    group_label: "* Refunds *"
    label: "# CC Refunded Orders No Return Reason"
    description: "Number of orders that had some items refunded by CC Agents but had no return reason."
    type: sum
    sql: ${number_of_orders_no_return_reason_but_items_returned} ;;
  }

  measure: sum_amt_refunded_post_issues {
    group_label: "* Refunds *"
    label: "SUM Refunds Post Issues"
    description: "Sum of refunds issued by CC agents due to post delivery issues. Includes deposit."
    type: sum
    sql: ${amt_refunded_post_issues} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_amt_refunded_fully_cc_cancelled {
    group_label: "* Refunds *"
    label: "SUM Refunds Fully Cancelled"
    description: "Sum of refunds issued by CC agents for fully cancelled orders.
    Includes deposit, rider tip, delivery fees."
    type: sum
    sql: ${amt_refunded_fully_cc_cancelled} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_amt_refunded_partially_cancelled {
    group_label: "* Refunds *"
    label: "SUM Refunds Partially Cancelled"
    description: "Sum of refund amounts issued by CC agents for orders with some items cancelled.
    Includes deposit."
    type: sum
    sql: ${amt_refunded_partially_cancelled} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_amt_refunded_perished_light {
    group_label: "* Refunds *"
    label: "SUM Refunds Perished Light"
    description: "Sum of refund amounts issued by CC agents due to perished light issues. Includes deposit"
    type: sum
    sql: ${amt_refunded_perished_light} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_amt_refund_orders_no_return_reason_but_items_returned {
    group_label: "* Refunds *"
    label: "SUM Refunds Orders No Return Reason"
    description: "Sum of refund amounts issued by CC agents for items returned with no return reason. Includes deposit"
    type: sum
    sql: ${amt_refund_orders_no_return_reason_but_items_returned} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_amt_refund_total {
    group_label: "* Refunds *"
    label: "SUM CC Refunds"
    description: "Sum of refunds issued by CC agents. Includes Fully cancelled orders.
    Excludes Pre delivery issues refunds and self cancelled orders."
    type: sum
    sql: ${amt_refund_total} ;;
    value_format_name: euro_accounting_0_precision
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
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_amt_discount_value {
    label: "Total Discount Value"
    group_label: "* Discounts *"
    type: sum
    sql: ${amt_discount_value} ;;
    value_format_name: euro_accounting_0_precision
  }

  measure: cc_discounts_share {
    label: "% CC Discounts / all Discounts"
    group_label: "* Discounts *"
    description: "amt cc discounts / all discounts. CC Discounts as share of all Discounts"
    type: number
    value_format: "0.0%"
    sql:  safe_divide(${sum_amt_cc_discount_value},${sum_amt_discount_value})  ;;
  }

  measure: cc_discounts_gmv_share {
    label: "% CC Discounts / GMV"
    group_label: "* Discounts *"
    description: "amt cc discounts / GMV. CC Discounts as share of GMV"
    type: number
    value_format: "0.0%"
    sql:  safe_divide(${sum_amt_cc_discount_value},${sum_amt_gmv_gross})  ;;
  }

  measure: contact_rate {
    label: "% Contact Rate"
    description: "# Contacts / # Orders "
    type: number
    value_format: "0.0%"
    sql:  safe_divide(${cc_contacts.number_of_contacts},${sum_number_of_orders})  ;;
  }

  measure: contact_rate_without_deflection {
    label: "% Contact Rate (Excl. Deflection)"
    description: "# Contacts without Bot Deflection / # Orders "
    type: number
    value_format: "0.0%"
    sql:  safe_divide(${cc_contacts.number_of_non_deflected_contacts},${sum_number_of_orders})  ;;
  }

  measure: cc_refunded_order_rate {
    group_label: "* Refunds *"
    label: "% Refunded Orders (Post Issues)"
    description: "# orders with post delivery issue (that led to a CC refund) / # successful orders"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_refunded_orders},${sum_number_of_orders}) ;;
  }

  measure: cc_refunded_order_over_5_rate {
    label: "% Refunded Orders over 5euros (Post Issues) / Refunded Orders (Post Issues)"
    description: "# Refunded Orders over 5euros / # Refunded Orders"
    type: number
    group_label: "* Refunds *"
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_refunded_orders_over_5},${sum_number_of_refunded_orders}) ;;
  }

  measure: cc_refunded_order_over_5_contact_rate {
    group_label: "* Refunds *"
    label: "% Refunded Orders over 5euros (Post Issues) / Contacts"
    description: "# Refunded Orders over 5euros / # Contacts"
    type: number
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_refunded_orders_over_5},${cc_contacts.number_of_contacts}) ;;
  }

  measure: cc_fully_refunded_orders_rate {
    label: "% CC Fully Cancelled Orders / Orders"
    description: "# Fully Cancelled Orders / # Orders (successful + unsuccessful)"
    type: number
    group_label: "* Refunds *"
    value_format: "0.0%"
    sql: safe_divide(${sum_number_of_fully_cc_cancelled_orders},${sum_number_of_orders_all}) ;;
  }

  measure: cc_refunds_gmv_share {
    label: "% CC Refunds / GMV"
    description: "CC Refunds as Share of GMV"
    type: number
    group_label: "* Refunds *"
    value_format: "0.0%"
    sql: safe_divide(${sum_amt_refund_total},${sum_amt_gmv_gross}) ;;
  }

  measure: cc_perished_light_refunded_share {
    label: "% Perished Light Refunds"
    description: "Perished Light Refunds as share of CC Refunds (excluding
    Self cancelled and refunds due to pre-order issues)"
    type: number
    group_label: "* Refunds *"
    value_format: "0.0%"
    sql: safe_divide(${sum_amt_refunded_perished_light},${sum_amt_refund_total}) ;;
  }

  measure: cc_no_return_refunded_share {
    label: "% No Return Reason Refunds"
    description: "Refunds for Orders with No Return Reason as share of CC Refunds (excluding
    Self cancelled and refunds due to pre-order issues)"
    type: number
    group_label: "* Refunds *"
    value_format: "0.0%"
    sql: safe_divide(${sum_amt_refund_orders_no_return_reason_but_items_returned},${sum_amt_refund_total}) ;;
  }

  measure: cc_partially_cancelled_refunded_share {
    label: "% CC Partially Cancelled Orders Refunds"
    description: "Partially Cancelled Orders Refunds as share of CC Refunds (excluding
    Self cancelled and refunds due to pre-order issues)"
    type: number
    group_label: "* Refunds *"
    value_format: "0.0%"
    sql: safe_divide(${sum_amt_refunded_partially_cancelled},${sum_amt_refund_total}) ;;
  }

  measure: avg_refund_value {
    group_label: "* Refunds *"
    label: "AVG CC Refund Value per Contact"
    description: "Total CC Refund Value / Contact"
    type: number
    value_format_name: euro_accounting_2_precision
    sql: safe_divide(${sum_amt_refund_total},${cc_contacts.number_of_contacts}) ;;
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
    label: "AVG CC Discount Value per Contact"
    description: "Total CC Discount Value / Contact"
    type: number
    value_format_name: euro_accounting_2_precision
    sql: safe_divide(${sum_amt_cc_discount_value},${cc_contacts.number_of_contacts}) ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
