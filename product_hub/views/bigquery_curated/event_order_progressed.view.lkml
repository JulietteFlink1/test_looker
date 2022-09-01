# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-08-31

view: event_order_progressed {
  sql_table_name: `flink-data-dev.dbt_falvarez.event_order_progressed`
    ;;

  view_label: "Event: Order Progressed"

  # This is the curated table for Order Progressed event coming from Hub One

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Sets          ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  set: to_include_dimensions {
    fields: [
      action,
      ean,
      method,
      order_id,
      order_number,
      product_sku,
      quantity,
      reason
    ]
  }

  set: to_include_measures {
    fields: [
      sum_of_quantity,
      number_of_orders,
      sum_quantity_picked,
      sum_quantity_reported,
      sum_quantity_refunded,
      sum_quantity_skipped,
      qty_reported_per_total_qty,
      qty_refunded_per_total_qty,
      qty_skipped_per_total_qty,
      qty_scanned_per_qty_picked
    ]
  }

  set: to_include_set {
    fields: [to_include_dimensions*, to_include_measures*]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  IDs   =========

  dimension: event_uuid {
    type: string
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.event_uuid ;;
  }

  dimension: anonymous_id {
    type: string
    group_label: "IDs"
    label: "Anonymous ID"
    description: "User ID set by Segment"
    hidden: yes
    sql: ${TABLE}.anonymous_id ;;
  }

# =========  Location Attributes   =========

  dimension: country_iso {
    type: string
    group_label: "Location Dimensions"
    label: "Country ISO"
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    group_label: "Location Dimensions"
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: locale {
    group_label: "Location Dimensions"
    label: "Locale"
    description: "Language code | Coutnry, region code"
    type: string
    sql: ${TABLE}.locale ;;
  }

  # =========  Employee Attributes   =========

  dimension: quinyx_badge_number {
    type: string
    group_label: "Employee Attributes"
    label: "Quinyx Badge Number"
    sql: ${TABLE}.quinyx_badge_number ;;
  }

  dimension: user_id {
    type: string
    group_label: "Employee Attributes"
    label: "Auth0 id" #Not yet but it should be
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  # =========  Dates and Timestamps   =========

  dimension_group: received {
    type: time
    hidden: yes
    sql: ${TABLE}.received_at ;;
  }

  dimension_group: event {
    type: time
    hidden: yes
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension_group: event_timestamp {
    group_label: "Date / Timestamp"
    label: "Event"
    description: "Timestamp of when an event happened"
    type: time
    timeframes: [
      time,
      date,
      week,
      hour_of_day,
      quarter
    ]
    sql: ${TABLE}.event_timestamp ;;
  }

  # =========  Generic Dimensions   =========

  dimension: event_name {
    group_label: "Generic Dimensions"
    label: "Event Name"
    description: "Name of the event triggered"
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: event_text {
    group_label: "Generic Dimensions"
    label: "Event Text"
    description: "event_name in camel case"
    type: string
    hidden: yes
    sql: ${TABLE}.event_text ;;
  }

  dimension: screen_name {
    group_label: "Generic Dimensions"
    label: "Screen Name"
    description: "Screen name where the event was triggered"
    type: string
    sql: ${TABLE}.screen_name ;;
  }

# =========  Event Dimensions   =========

  dimension: action {
    description: "The action performed. It can be item_picked, item_skipped, item_refunded or item_reset."
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension: ean {
    description: "An array that contains the ean/ eans of the sku."
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: method {
    description: "The used method to pick an item. It can be scanned, clicked or reported."
    type: string
    sql: ${TABLE}.method ;;
  }

  dimension: order_id {
    description: "A unique identifier generated by back-end when an order is placed."
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    description: "A unique identifier generated by back-end when an order is placed that is more human-readable than the order_id."
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: product_sku {
    description: "The sku of the product, as available in the backend."
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: quantity {
    description: "The quantity affected."
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: reason {
    description: "The reason an item has been reported. It can be code_wrong or code_damaged."
    type: string
    sql: ${TABLE}.reason ;;
  }

  # =========  Other Dimensions   =========

  dimension: context_ip {
    type: string
    hidden: yes
    sql: ${TABLE}.context_ip ;;
  }

  dimension: page_path {
    type: string
    hidden: yes
    sql: ${TABLE}.page_path ;;
  }

  dimension: page_title {
    type: string
    hidden: yes
    sql: ${TABLE}.page_title ;;
  }

  dimension: page_url {
    type: string
    hidden: yes
    sql: ${TABLE}.page_url ;;
  }

  dimension: user_agent {
    type: string
    hidden: yes
    sql: ${TABLE}.user_agent ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # =========  Total Metrics   =========

  measure: number_of_events {
    group_label: "Total Metrics"
    label: "# Events"
    description: "Number of events trigegred"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }

  measure: number_of_orders {
    group_label: "Total Metrics"
    label: "# Orders"
    description: "Number of Orders."
    type: count_distinct
    sql: ${TABLE}.order_id ;;
  }

  measure: sum_of_quantity {
    group_label: "Total Metrics"
    label: "Total Quantity"
    description: "Sum of quantity."
    type: sum
    sql: ${TABLE}.quantity ;;
  }

  measure: sum_quantity_picked {
    group_label: "Total Metrics"
    label: "Quantity Picked"
    description: "Sum of quantity picked (includes reported items)."
    type: sum
    filters: [action: "item_picked"]
    sql: ${TABLE}.quantity ;;
  }

  measure: sum_quantity_picked_scanned {
    group_label: "Total Metrics"
    label: "Quantity Picked by Scan"
    description: "Sum of quantity picked by scanning."
    type: sum
    filters: [action: "item_picked", method: "scanned"]
    sql: ${TABLE}.quantity ;;
  }

  measure: sum_quantity_picked_clicked {
    group_label: "Total Metrics"
    label: "Quantity Picked by Click"
    description: "Sum of quantity picked by clicking."
    type: sum
    filters: [action: "item_picked", method: "clicked"]
    sql: ${TABLE}.quantity ;;
  }

  measure: sum_quantity_reported {
    group_label: "Total Metrics"
    label: "Quantity Reported"
    description: "Sum of quantity reported."
    type: sum
    filters: [action: "item_picked", method: "reported"]
    sql: ${TABLE}.quantity ;;
  }

  measure: sum_quantity_refunded {
    group_label: "Total Metrics"
    label: "Quantity Refunded"
    description: "Sum of quantity refunded."
    type: sum
    filters: [action: "item_refunded"]
    sql: ${TABLE}.quantity ;;
  }

  measure: sum_quantity_skipped {
    group_label: "Total Metrics"
    label: "Quantity Skipped"
    description: "Sum of quantity skipped."
    type: sum
    filters: [action: "item_skipped"]
    sql: ${TABLE}.quantity ;;
  }

  # =========  Rate Metrics   =========

  measure: qty_refunded_per_total_qty {
    group_label: "Rate Metrics"
    label: "% Refunded Items"
    description: "Quantity Refunded / Total Quantity"
    type: number
    value_format_name: percent_1
    sql: ${sum_quantity_refunded} / nullif(${sum_of_quantity},0) ;;
  }

  measure: qty_skipped_per_total_qty {
    group_label: "Rate Metrics"
    label: "% Skipped Items"
    description: "Quantity Skipped / Total Quantity"
    type: number
    value_format_name: percent_1
    sql: ${sum_quantity_skipped} / nullif(${sum_of_quantity},0) ;;
  }

  measure: qty_reported_per_total_qty {
    group_label: "Rate Metrics"
    label: "% Reported Items"
    description: "Quantity Reported / Total Quantity"
    type: number
    value_format_name: percent_1
    sql: ${sum_quantity_reported} / nullif(${sum_of_quantity},0) ;;
  }

  measure: qty_scanned_per_qty_picked {
    group_label: "Rate Metrics"
    label: "% Scanned Items"
    description: "Quantity Picked by Scan / (Quantity Picked by Scan + Quantity Picked by Click)"
    type: number
    value_format_name: percent_1
    sql: ${sum_quantity_picked_scanned} / nullif(${sum_quantity_picked_scanned}+${sum_quantity_picked_clicked},0) ;;
  }

}
