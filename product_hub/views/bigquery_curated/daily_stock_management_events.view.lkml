# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-09-09

view: daily_stock_management_events {
  sql_table_name: `flink-data-dev.curated.daily_stock_management_events`
    ;;
  view_label: "Daily Stock Management Events"

  # This is the curated layer of the events coming from Stock Management app

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Sets          ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

  # =========  Location Dimensions   =========

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
    description: "Language code | Country, region code"
    type: string
    sql: ${TABLE}.locale ;;
  }

# =========  Employee Attributes   =========

  dimension: employee_id {
    type: string
    group_label: "Employee Attributes"
    label: "Employee Id"
    sql: ${TABLE}.employee_id ;;
  }

  # =========  Dates and Timestamps   =========

  dimension_group: event_received {
    type: time
    hidden: yes
    sql: ${TABLE}.event_received_at ;;
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

  dimension: inventory_movement_id {
    group_label: "Generic Dimensions"
    label: "Inventory Movement Id"
    description: "A unique identifier generated by back-end when an inventory movement is started (inbound, outbound or correction)."
    type: string
    sql: ${TABLE}.inventory_movement_id ;;
  }

  dimension: action {
    group_label: "Generic Dimensions"
    label: "Action"
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension: direction {
    group_label: "Generic Dimensions"
    label: "Direction"
    type: string
    sql: ${TABLE}.direction ;;
  }

  dimension: is_handling_unit {
    group_label: "Generic Dimensions"
    label: "Is Handling Unit"
    type: yesno
    sql: ${TABLE}.is_handling_unit ;;
  }

  dimension: is_scanned_item {
    group_label: "Generic Dimensions"
    label: "Is Scanned Item"
    type: yesno
    sql: ${TABLE}.is_scanned_item ;;
  }

  dimension: quantity {
    group_label: "Generic Dimensions"
    label: "Quantity"
    type: number
    sql: cast(${TABLE}.quantity as int64) ;;
  }

  dimension: reason {
    group_label: "Generic Dimensions"
    label: "Reason"
    type: string
    sql: ${TABLE}.reason ;;
  }

  dimension: sku {
    group_label: "Generic Dimensions"
    label: "Sku"
    type: string
    sql: ${TABLE}.sku ;;
  }

  # =========  Other Dimensions   =========

  dimension: ip_address {
    hidden: yes
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Total Metrics  =========

  measure: number_of_events {
    label: "# Events"
    description: "Number of events trigegred"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }

  measure: number_of_inventory_movements {
    label: "# Inventory Movements"
    description: "Number of Inventory Movements"
    type: count_distinct
    filters: [event_name: "inventory_progress, inventory_state_updated"]
    sql: ${TABLE}.inventory_movement_id ;;
  }

  measure: sum_quantity_inbounded_stock_changed {
    group_label: "Total Metrics"
    label: "Quantity Stock Changed Inbounded"
    description: "Sum of quantity inbounded by old flow."
    type: sum
    filters: [event_name: "stock_changed", direction: "inbounding"]
    sql: ${quantity} ;;
  }

  measure: sum_quantity_dropped {
    group_label: "Total Metrics"
    label: "Quantity Dropped"
    description: "Sum of quantity dropped."
    type: sum
    filters: [event_name: "inventory_progress", action: "item_dropped"]
    sql: ${quantity} ;;
  }

  measure: sum_quantity_added_to_cart {
    group_label: "Total Metrics"
    label: "Quantity Added To Cart"
    description: "Sum of quantity added to cart."
    type: sum
    filters: [event_name: "inventory_progress", action: "item_added_to_cart"]
    sql: ${quantity} ;;
  }

  measure: sum_quantity_removed_from_cart {
    group_label: "Total Metrics"
    label: "Quantity Removed From Cart"
    description: "Sum of quantity removed from cart."
    type: sum
    filters: [event_name: "inventory_progress", action: "item_removed_from_cart"]
    sql: ${quantity} ;;
  }

  measure: item_added_to_cart_time {
    group_label: "Total Metrics"
    label: "Item Added To Cart Time"
    description: "Timestamp from when the item has been added to cart."
    type: max
    filters: [event_name: "inventory_progress", action: "item_added_to_cart"]
    sql: ${TABLE}.event_timestamp ;;
  }

  measure: item_removed_from_cart_time {
    group_label: "Total Metrics"
    label: "Item Removed From Cart Time"
    description: "Timestamp from when the item has been removed from cart."
    type: max
    filters: [event_name: "inventory_progress", action: "item_removed_from_cart"]
    sql: ${TABLE}.event_timestamp ;;
  }

# =========  Rate Metrics  =========

# =========  Time Metrics  =========

  measure: cart_created_time {
    hidden: yes
    label: "Cart Created Time"
    description: "Timestamp for when the cart has been created."
    type: max
    filters: [event_name: "inventory_state_updated", action: "cart_created"]
    sql: ${TABLE}.event_timestamp ;;
  }

  measure: dropping_list_created_time {
    hidden: yes
    label: "Dropping List Created Time"
    description: "Timestamp for when the dropping list has been created."
    type: max
    filters: [event_name: "inventory_state_updated", action: "dropping_list_created"]
    sql: ${TABLE}.event_timestamp ;;
  }

  measure: dropping_list_finished_time {
    hidden: yes
    label: "Dropping List Finished Time"
    description: "Timestamp for when the dropping list has been finished."
    type: max
    filters: [event_name: "inventory_state_updated", action: "dropping_list_finished"]
    sql: ${TABLE}.event_timestamp ;;
  }

  measure: cart_to_drop_list_seconds {
    hidden: yes
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list timestamps"
    sql: DATETIME_DIFF(${dropping_list_created_time},${cart_created_time}, SECOND);;
  }

  measure: drop_list_created_to_finished_seconds {
    hidden: yes
    description: "Difference in seconds between time_to_dropping_list_created and time_to_dropping_list_finished timestamps"
    sql: DATETIME_DIFF(${dropping_list_finished_time}, ${dropping_list_created_time}, SECOND) ;;
  }
  measure: cart_to_finished_seconds {
    hidden: yes
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list_finished timestamps"
    sql: DATETIME_DIFF(${dropping_list_finished_time}, ${cart_created_time}, SECOND) ;;
  }
}
