include: "/views/**/*.view"

# this view adds fields to the regular orders.view
# extracted these fields into a separate file for better readability
view: +orders {

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: stack_uuid {
    label: "Stack ID"
    description: "Orders in the same Stack share this Stack ID"
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.stack_uuid ;;
    type: string
  }

  dimension: is_stacked_order {
    label: "Is Stacked Order"
    description: "Indicates, whether an order was part of a stacked order"
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.is_stacked_order ;;
    type: yesno
  }

  dimension: number_of_stacked_orders {
    label: "# Orders in Stack"
    description: "Indicates, how many orders were part of one stack"
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.number_of_stacked_orders ;;
    type: number
  }

  dimension: stacking_sequence {
    label: "Stacking Sequence"
    description: "The order, in which the orders of the stack were delivered"
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.stacking_sequence ;;
    type: number
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_delivery_time_from_prev_customer_minutes {
    label: "AVG Delvery Time since prev customer (min)"
    description: "Indicates, how long it took for our rider to arrive from one to a following customer of a stacked order"
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.delivery_time_from_prev_customer_minutes ;;
    type: average
    value_format_name: decimal_1
  }

  measure: cnt_stacked_orders {
    label: "# Orders - Stacked Order"
    description: "The number of orders, that were part of a stacked delivery"
    group_label: "* Stacked Orders *"
    type: count
    filters: [is_stacked_order: "Yes"]
    value_format: "0"
  }

  measure: avg_delivery_time_2nd_order_in_stack {
    label: "AVG Delivery Time to 2nd customer"
    description: "The time it took a ride to deliver to the 2nd customer in a stacked order"
    group_label: "* Stacked Orders *"
    sql: ${TABLE}.delivery_time_minutes ;;
    filters: [stacking_sequence: "2"]
    type: average
    value_format_name: decimal_1
  }

  measure: pct_stacked_orders {
    label: "% Stacked Orders"
    description: "The % of orders, that were part of a stacked delivery"
    group_label: "* Stacked Orders *"
    sql: ${cnt_stacked_orders} / nullif(${cnt_orders} ,0) ;;
    type: number
    value_format_name: percent_1
  }







}
