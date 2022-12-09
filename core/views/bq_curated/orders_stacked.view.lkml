include: "/**/*.view"

# this view adds fields to the regular orders.view
# extracted these fields into a separate file for better readability
view: +orders {

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: stack_uuid {
    label: "Stack ID"
    description: "Orders in the same Stack share this Stack ID."
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.stack_uuid ;;
    type: string
  }

  dimension: is_stacked_order {
    label: "Is Stacked Order"
    description: "Indicates whether an order was part of a stacked order."
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.is_stacked_order ;;
    type: yesno
  }

  dimension: number_of_stacked_orders {
    label: "# Orders in Stack"
    description: "Indicates how many orders were part of one stack (one trip)."
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.number_of_stacked_orders ;;
    type: number
  }

  dimension: stacking_sequence {
    label: "Stacking Sequence"
    description: "The order in which the orders of the stack were delivered."
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.stacking_sequence ;;
    type: number
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_riding_time_from_previous_customer_minutes {
    alias: [avg_delivery_time_from_prev_customer_minutes]
    label: "AVG Riding Time From Previous Customer (Min)"
    description: "Indicates how long it took for the rider to ride from the previous customer."
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.delivery_time_from_prev_customer_minutes ;;
    type: average
    value_format_name: decimal_1
  }

  measure: cnt_stacked_orders {
    label: "# Stacked Orders"
    description: "The number of orders that were part of a stacked delivery."
    group_label: "* Stacked Orders *"
    type: count
    filters: [is_stacked_order: "Yes"]
    value_format: "0"
  }

  measure: cnt_stacked_orders_double_stack {
    label: "# Double-Stacked Orders"
    description: "The number of orders that were part of a 2-order stacked delivery."
    group_label: "* Stacked Orders *"
    type: count
    filters: [is_stacked_order: "Yes", number_of_stacked_orders: "2"]
    value_format: "0"
  }

  measure: cnt_stacked_orders_triple_stack {
    label: "# Triple-Stacked Orders"
    description: "The number of orders that were part of a 3-order stacked delivery."
    group_label: "* Stacked Orders *"
    type: count
    filters: [is_stacked_order: "Yes", number_of_stacked_orders: "3"]
    value_format: "0"
  }

  measure: avg_riding_time_2nd_order_in_stack {
    alias: [avg_delivery_time_2nd_order_in_stack]
    label: "AVG Riding Time: Hub to 2nd Customer (min)"
    description: "The time it took a rider to deliver from the hub to the 2nd customer in a stacked order."
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.riding_time_minutes ;;
    filters: [stacking_sequence: "2"]
    type: average
    hidden: yes
    value_format_name: decimal_1
  }

  measure: avg_fulfillment_time_2nd_order_in_stack {
    label: "AVG Fulfillment time 2nd Customer (min)"
    description: "The time it took to deliver the order to the 2nd customer from order-creation until delivery in a stacked order."
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.fulfillment_time_minutes ;;
    filters: [stacking_sequence: "2"]
    type: average
    value_format_name: decimal_1
  }

  measure: avg_fulfillment_time_1st_order_in_stack {
    label: "AVG Fulfillment time 1st Customer (min)"
    description: "The time it took to deliver the order to the 1st customer from order-creation until delivery in a stacked order."
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.fulfillment_time_minutes ;;
    filters: [stacking_sequence: "1"]
    type: average
    value_format_name: decimal_1
  }

  measure: avg_riding_time_1st_order_in_stack {
    alias: [avg_delivery_time_1st_order_in_stack]
    label: "AVG Riding time to 1st Customer (min)"
    description: "The time it took a rider to deliver from the hub to the 1st customer in a stacked order."
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.riding_time_minutes ;;
    filters: [stacking_sequence: "1"]
    type: average
    hidden: yes
    value_format_name: decimal_1
  }

  measure: pct_stacked_orders {
    label: "% Stacked Orders"
    description: "The % of orders that were part of a stacked delivery. (Share of internal orders only)"
    group_label: "* Stacked Orders *"
    sql: ${cnt_stacked_orders} / nullif(${cnt_internal_orders}-${cnt_click_and_collect_orders} ,0) ;;
    type: number
    value_format_name: percent_1
  }

  measure: pct_double_stacked_orders {
    label: "% Double-Stacked Orders"
    description: "The % of orders that were part of a 2-order stacked delivery. (Share of internal orders only)"
    group_label: "* Stacked Orders *"
    sql: ${cnt_stacked_orders_double_stack} / nullif(${cnt_internal_orders}-${cnt_click_and_collect_orders} ,0) ;;
    type: number
    value_format_name: percent_1
  }

  measure: pct_triple_stacked_orders {
    label: "% Triple-Stacked Orders"
    description: "The % of orders that were part of a 3-order stacked delivery. (Share of internal orders only)"
    group_label: "* Stacked Orders *"
    sql: ${cnt_stacked_orders_triple_stack} / nullif(${cnt_internal_orders}-${cnt_click_and_collect_orders} ,0) ;;
    type: number
    value_format_name: percent_1
  }

  measure: pct_stacked_orders_with_triple_stacks {
    label: "% Stacked Orders With Triple-Stacking"
    description: "The % of stacked orders that were part of 3-order stacks."
    group_label: "* Stacked Orders *"
    sql: ${cnt_stacked_orders_triple_stack} / nullif(${cnt_stacked_orders} ,0) ;;
    type: number
    value_format_name: percent_1
  }





}
