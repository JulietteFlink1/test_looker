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
    type: string
    sql: ${TABLE}.quantity ;;
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
    label: "# Events"
    description: "Number of Inventory Movements"
    type: count_distinct
    sql: ${TABLE}.inventory_movement_id ;;
  }

  measure: sum_quantity_inbounded_stock_changed {
    group_label: "Total Metrics"
    label: "Quantity Stock Changed Inbounded"
    description: "Sum of quantity inbounded by old flow."
    type: sum
    filters: [event_name: "stock_changed", direction: "inbounding"]
    sql: ${TABLE}.quantity ;;
  }

  measure: sum_quantity_inbounded {
    group_label: "Total Metrics"
    label: "Quantity Inbounded"
    description: "Sum of quantity inbounded by new flow."
    type: sum
    filters: [event_name: "inventory_progress", action: "item_dropped"]
    sql: ${TABLE}.quantity ;;
  }

  measure: sum_quantity_ {
    group_label: "Total Metrics"
    label: "Quantity Inbounded"
    description: "Sum of quantity inbounded by new flow."
    type: sum
    filters: [event_name: "inventory_progress", action: "item_dropped"]
    sql: ${TABLE}.quantity ;;
  }
  # =========  Rate Metrics  =========
}
