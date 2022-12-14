# Owner: Bastian Gerstner
# Created: 2022-12-01
# Stakeholder: Last Mile Product & Rider Ops

# This view contains information about trips and the time differences between each state a trip can be in.

view: trip_state_changed_times {
  sql_table_name: `flink-data-prod.reporting.trip_state_changed_times` ;;
  view_label: "Trip State Changed Times"


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: actor_id {
    type: string
    description: "Unique identifier for a hub employee performing a given action."
    sql: ${TABLE}.actor_id ;;
  }
  dimension: rider_id {
    group_label: "IDs"
    label: "Rider ID"
    type: string
    description: "A unique identifier of each rider."
    sql: ${TABLE}.rider_id ;;
  }
  dimension: trip_id {
    group_label: "IDs"
    label: "Trip ID"
    description: "A unique identifier of each trip."
    type: string
    sql: ${TABLE}.trip_id ;;
  }
  dimension: table_uuid {
    group_label: "IDs"
    label: " Table UUId"
    type: string
    description: "Concatenation of event_date, order_id and rider_id to create unique row identifer"
    sql: ${TABLE}.table_uuid ;;
  }

  # ======= Generic Dimension ======= #

  dimension: order_type {
    group_label: "Generic Dimension"
    label: "Order Type"
    description: "Indicates if an order was stacked or not"
    type: string
    sql: ${TABLE}.order_type ;;
  }

  # ======= Location Dimensions ======= #

  dimension: country_iso {
    group_label: "Location Dimension"
    label: "Country Iso"
    type: string
    description: "Country Iso based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }
  dimension: hub_code {
    group_label: "Location Dimension"
    label: "Hub Code"
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  # ======= Dates / Timestamps ======= #

  dimension_group: event_date {
    group_label: "Dates & Timestamps"
    label: "Event Timeframe"
    type: time
    description: "Date when an event was triggered."
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }
  dimension_group: trip_completed_at_timestamp {
    group_label: "Dates & Timestamps"
    type: time
    description: "Timestamp for when a rider has completed the trip (state= trip_completed)."
    timeframes: [
      raw
    ]
    sql: ${TABLE}.trip_completed_at_timestamp ;;
  }
  dimension_group: trip_on_route_at_timestamp {
    group_label: "Dates & Timestamps"
    type: time
    description: "Timestamp for when a trip is on route meaning the rider actually started riding (state= trip_on_route)."
    timeframes: [
      raw
    ]
    sql: ${TABLE}.trip_on_route_at_timestamp ;;
  }
  dimension_group: trip_rejected_at_timestamp {
    group_label: "Dates & Timestamps"
    type: time
    description: "Timestamp for when a rider rejected the trip (state= trip_rejected)."
    timeframes: [
      raw
    ]
    sql: ${TABLE}.trip_rejected_at_timestamp ;;
  }
  dimension_group: trip_returning_at_timestamp {
    group_label: "Dates & Timestamps"
    type: time
    description: "Timestamp for when a rider is returning (state= trip_returning)."
    timeframes: [
      raw
    ]
    sql: ${TABLE}.trip_returning_at_timestamp ;;
  }
  dimension_group: trip_started_at_timestamp {
    group_label: "Dates & Timestamps"
    type: time
    description: "Timestamp for when a trip is started by the rider (state= trip_started)."
    timeframes: [
      raw
    ]
    sql: ${TABLE}.trip_started_at_timestamp ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: sum_rider_delivery_time_minutes {
    group_label: "Measures"
    label: "SUM Delivery Time (minutes)"
    type: sum
    description: "Time a rider spent delivering an order in minutes (difference between trip on route and trip returning)."
    sql: ${TABLE}.rider_delivery_time_minutes ;;
    value_format: "0.0"
  }
  measure: sum_rider_delivery_time_seconds {
    group_label: "Measures"
    label: "SUM Delivery Time (seconds)"
    type: sum
    description: "Time a rider spent delivering an order in seconds (difference between trip on route and trip returning)."
    sql: ${TABLE}.rider_delivery_time_seconds ;;
    value_format: "0.00"
  }
  measure: sum_rider_pickup_time_minutes {
    group_label: "Measures"
    label: "SUM Pickup Time (minutes)"
    type: sum
    description: "Time a rider spent picking up the order in minutes (difference between trip started and trip on route)."
    sql: ${TABLE}.rider_pickup_time_minutes ;;
    value_format: "0.0"
  }
  measure: sum_rider_pickup_time_seconds {
    group_label: "Measures"
    label: "SUM Pickup Time (seconds)"
    type: sum
    description: "Time a rider spent picking up the order in seconds (difference between trip started and trip on route)."
    sql: ${TABLE}.rider_pickup_time_seconds ;;
    value_format: "0.00"
  }
  measure: sum_rider_return_time_minutes {
    group_label: "Measures"
    label: "SUM Return Time (minutes)"
    type: sum
    sql: ${TABLE}.rider_return_time_minutes ;;
    value_format: "0.0"
  }
  measure: sum_rider_return_time_seconds {
    group_label: "Measures"
    label: "SUM Return Time (seconds)"
    type: sum
    description: "Time a rider spent returning to hub in minutes (difference between trip returning and trip completed)."
    sql: ${TABLE}.rider_return_time_seconds ;;
    value_format: "0.00"
  }
  measure: avg_rider_delivery_time_minutes {
    group_label: "Measures"
    label: "AVG Delivery Time (minutes)"
    type: average
    description: "Time a rider spent delivering an order in minutes (difference between trip on route and trip returning)."
    sql: ${TABLE}.rider_delivery_time_minutes ;;
    value_format: "0.0"
  }
  measure: avg_rider_delivery_time_seconds {
    group_label: "Measures"
    label: "AVG Delivery Time (seconds)"
    type: average
    description: "Time a rider spent delivering an order in seconds (difference between trip on route and trip returning)."
    sql: ${TABLE}.rider_delivery_time_seconds ;;
    value_format: "0.00"
  }
  measure: avg_rider_pickup_time_minutes {
    group_label: "Measures"
    label: "AVG Pickup Time (minutes)"
    type: average
    description: "Time a rider spent picking up the order in minutes (difference between trip started and trip on route)."
    sql: ${TABLE}.rider_pickup_time_minutes ;;
    value_format: "0.0"
  }
  measure: avg_rider_pickup_time_seconds {
    group_label: "Measures"
    label: "AVG Pickup Time (seconds)"
    type: average
    description: "Time a rider spent picking up the order in seconds (difference between trip started and trip on route)."
    sql: ${TABLE}.rider_pickup_time_seconds ;;
    value_format: "0.00"
  }
  measure: avg_rider_return_time_minutes {
    group_label: "Measures"
    label: "AVG Return Time (minutes)"
    type: average
    sql: ${TABLE}.rider_return_time_minutes ;;
    value_format: "0.0"
  }
  measure: avg_rider_return_time_seconds {
    group_label: "Measures"
    label: "AVG Return Time (seconds)"
    type: average
    description: "Time a rider spent returning to hub in minutes (difference between trip returning and trip completed)."
    sql: ${TABLE}.rider_return_time_seconds ;;
    value_format: "0.00"
  }
  measure: trip_id_count {
    group_label: "Measures"
    label: "Total # Distinct Trips "
    type: count_distinct
    description: "Total count of distinct trips"
    sql: ${TABLE}.trip_id ;;
  }
}
