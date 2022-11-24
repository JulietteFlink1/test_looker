# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-11-24

view: hub_one_picking_times {
  sql_table_name: `flink-data-prod.reporting.hub_one_picking_times`
    ;;

  view_label: "Picking Times"

  # This is a table from the reporting layer that calculates the picking times

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

  dimension: table_uuid {
    type: string
    description: "Concatenation of event_date and order_id."
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: order_id {
    type: string
    description: "Unique identifier generated by back-end when an order is placed."
    sql: ${TABLE}.order_id ;;
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

  # =========  Employee Attributes   =========

  dimension: picker_quinyx_badge_number {
    type: string
    description: "Quinyx Badge number of the employee who started the picking process first."
    sql: ${TABLE}.picker_quinyx_badge_number ;;
  }

  # =========  Dates and Timestamps   =========

  dimension_group: event {
    type: time
    description: "Date when an event was triggered."
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
    sql: ${TABLE}.event_date ;;
  }

  dimension_group: order_picked {
    type: time
    description: "Timestamp for when the order is selected by the picker (state= picked)."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_picked_at ;;
  }

  dimension_group: order_picking_finished {
    type: time
    description: "Timestamp for when the picker finished picking the items (state= picking_finished)."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_picking_finished_at ;;
  }

  dimension_group: order_packed {
    type: time
    description: "Timestamp for when the order is ready for the rider (state= packed)."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_packed_at ;;
  }

  dimension: time_picking_items_minutes {
    type: number
    description: "Time spent picking items in minutes (difference between order_picked and order_picking_finished)."
    sql: ${TABLE}.time_picking_items_minutes ;;
  }

  dimension: time_picking_items_seconds {
    type: number
    description: "Time spent picking items in seconds (difference between order_picked and order_picking_finished)."
    sql: ${TABLE}.time_picking_items_seconds ;;
  }

  dimension: time_assigning_containers_minutes {
    type: number
    description: "Time spent assigning containers and shelfs in minutes (difference between order_picking_finished_at and order_packed_at)."
    sql: ${TABLE}.time_assigning_containers_minutes ;;
  }

  dimension: time_assigning_containers_seconds {
    type: number
    description: "Time spent assigning containers and shelfs in seconds (difference between order_picking_finished_at and order_packed_at)."
    sql: ${TABLE}.time_assigning_containers_seconds ;;
  }

  dimension: time_picking_process_minutes {
    type: number
    description: "Time spent picking an order from order picked to order ready for rider in minutes (difference between order_picked_at and order_packed_at)."
    sql: ${TABLE}.time_picking_process_minutes ;;
  }

  dimension: time_picking_process_seconds {
    type: number
    description: "Time spent picking an order from order picked to order ready for rider in seconds (difference between order_picked_at and order_packed_at)."
    sql: ${TABLE}.time_picking_process_seconds ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Total Metrics  =========

}
