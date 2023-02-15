# Owner: Bastian Gerstner
# Created: 2023-02-03
# Stakeholder: Last Mile Product & Rider Ops

# This view contains information about offers made by auto assign service
# and the time calculations between each offer and respective trip.

view: auto_assign_trip_state_changed_aggregates {
  sql_table_name: `flink-data-prod.reporting.auto_assign_trip_state_changed_aggregates`;;
  view_label: "Auto Assign Aggregates"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: offer_id {
    group_label: "IDs"
    label: "Offer ID"
    type: string
    description: "Unique identifer for a given offer made by the auto assign dispatching service. Per offer created we have a unique offer ID emitted by the system."
    sql: ${TABLE}.offer_id ;;
  }
  dimension: rider_id {
    group_label: "IDs"
    label: "Rider ID"
    type: string
    description: "Unique identifier of each rider."
    sql: ${TABLE}.rider_id ;;
  }
  dimension: trip_id {
    group_label: "IDs"
    label: "Trip ID"
    type: string
    description: "Unique identifer for a given trip. One trip can contain multiple orders."
    sql: ${TABLE}.trip_id ;;
  }

  # ======= Generic Dimension ======= #

  dimension: trip_completed_by {
    group_label: "Generic Dimension"
    label: "Trip Completed By"
    type: string
    description: "This field indicates if a trip was completed by the rider or a by hub staff member from the dashboard (can be null due not all offers were completed)"
    sql: ${TABLE}.trip_completed_by ;;
  }
  dimension: trip_started_by {
    group_label: "Generic Dimension"
    label: "Trip Started By"
    type: string
    description: "This field indicates if a trip was started by the rider or by a hub staff member from the dashboard (can be null due not all offers were started)"
    sql: ${TABLE}.trip_started_by ;;
  }

  # ======= Location Dimensions ======= #

  dimension: country_iso {
    group_label: "Location Dimension"
    label: "Country Iso"
    type: string
    description: "Country ISO based on 'hub_code'."
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

  dimension_group: event {
    group_label: "Dates & Timestamps"
    label: "Event"
    type: time
    description: "Date when an event was triggered."
    timeframes: [
      raw,
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }
  dimension_group: offer_created_at_timestamp {
    group_label: "Dates & Timestamps"
    label: "Offer Created At"
    type: time
    timeframes: [
      raw,
      time,
      hour,
      hour_of_day,
      date,
      week
    ]
    sql: ${TABLE}.offer_created_at_timestamp ;;
  }

  # ======= Hidden ======= #

  dimension: custom_trip_id {
    hidden:  yes
    type: string
    sql: ${TABLE}.custom_trip_id ;;
  }
  dimension_group: offer_declined_at_timestamp {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week
    ]
    sql: ${TABLE}.offer_declined_at_timestamp ;;
  }
  dimension_group: offer_expired_at_timestamp {
    hidden:  yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week
    ]
    sql: ${TABLE}.offer_expired_at_timestamp ;;
  }
  dimension_group: offer_invalidated_at_timestamp {
    hidden:  yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week
    ]
    sql: ${TABLE}.offer_invalidated_at_timestamp ;;
  }
  dimension_group: trip_completed_at_timestamp {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week
    ]
    sql: ${TABLE}.trip_completed_at_timestamp ;;
  }
  dimension_group: trip_on_route_at_timestamp {
    hidden:  yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.trip_on_route_at_timestamp ;;
  }
  dimension_group: trip_rejected_at_timestamp {
    hidden:  yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.trip_rejected_at_timestamp ;;
  }
  dimension_group: trip_returning_at_timestamp {
    hidden:  yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.trip_returning_at_timestamp ;;
  }
  dimension_group: trip_started_at_timestamp {
    hidden:  yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.trip_started_at_timestamp ;;
  }
  dimension: table_uuid {
    hidden: yes
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= Total Numbers of Events ======= #

  measure: total_distinct_rider_id {
    group_label: "Total Number"
    label: "Total Number of Distinct Riders"
    type: count_distinct
    description: "Total number of distinct rider IDs"
    sql: ${TABLE}.rider_id ;;
  }
  measure: total_distinct_trip_id {
    group_label: "Total Number"
    label: "Total Number of Distinct Trips"
    type: count_distinct
    description: "Total number of distinct trip IDs"
    sql: ${TABLE}.trip_id ;;
  }

  # ======= Total Numbers of Events ======= #

  measure: number_of_offers_created {
    group_label: "Total Number"
    label: "Total Number of Offers Created Events"
    type: sum
    description: "The total number of offers created for a given order (from auto assign)."
    sql: ${TABLE}.number_of_offers_created ;;
  }
  measure: number_of_offers_declined {
    group_label: "Total Number"
    label: "Total Number of Offers Declined Events"
    type: sum
    description: "The total number of offers declined for a given order (from auto assign)."
    sql: ${TABLE}.number_of_offers_declined ;;
  }
  measure: number_of_offers_expired {
    group_label: "Total Number"
    label: "Total Number of Offers Expired Events"
    type: sum
    description: "The total number of offers expired for a given order (from auto assign)."
    sql: ${TABLE}.number_of_offers_expired ;;
  }
  measure: number_of_offers_invalidated {
    group_label: "Total Number"
    label: "Total Number of Offers Invalidated Events"
    type: sum
    description: "The total number of offers invalidated for a given order (from auto assign)."
    sql: ${TABLE}.number_of_offers_invalidated ;;
  }
  measure: number_of_orders {
    group_label: "Total Number"
    label: "Total Number of Orders"
    type: sum
    description: "The total number of orders within a given offer If > 1 then stacked order."
    sql: ${TABLE}.number_of_orders ;;
  }
  measure: number_of_trip_started_events {
    group_label: "Total Number"
    label: "Total Number of Trip Started Events"
    type: sum
    description: "The total number of trips started events for a given order (emitted by order fulfillment service)."
    sql: ${TABLE}.number_of_trip_started_events ;;
  }
  measure: number_of_trips_completed_events {
    group_label: "Total Number"
    label: "Total Number of Trip Completed Events"
    type: sum
    description: "The total number of trips completed events for a given order (emitted by order fulfillment service)."
    sql: ${TABLE}.number_of_trips_completed_events ;;
  }
  measure: number_of_trips_on_route_events {
    group_label: "Total Number"
    label: "Total Number of Trip On Route Events"
    type: sum
    description: "The total number of trips en route events for a given order (emitted by order fulfillment service)."
    sql: ${TABLE}.number_of_trips_on_route_events ;;
  }
  measure: number_of_trips_rejections_events {
    group_label: "Total Number"
    label: "Total Number of Trip Rejected Events"
    type: sum
    description: "The total number of trips rejected events for a given order (emitted by order fulfillment service)."
    sql: ${TABLE}.number_of_trips_rejections_events ;;
  }
  measure: number_of_trips_returning_events {
    group_label: "Total Number"
    label: "Total Number of Trip Returning Events"
    type: sum
    description: "The total number of trips returning evnets for a given order (emitted by order fulfillment service)."
    sql: ${TABLE}.number_of_trips_returning_events ;;
  }

  # ======= Averages Time Calculations ======= #

  measure: avg_rider_accepted_offer_time_minutes {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Acceptance Time (Minutes)"
    type: average
    description: "Time it took a rider to accept the trip offered to them by auto assign."
    sql: ${TABLE}.rider_accepted_offer_time_minutes ;;
    value_format: "0.0"
  }
  measure: avg_rider_accepted_offer_time_seconds {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Acceptance Time (Seconds)"
    type: average
    description: "Time it took a rider to accept the trip offered to them by auto assign."
    sql: ${TABLE}.rider_accepted_offer_time_seconds ;;
    value_format: "0.00"
  }
  measure: avg_rider_delivery_time_minutes {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Delivery Time (Minutes)"
    type: average
    description: "Time a rider spent delivering an order in seconds/minutes (difference between trip on route and trip returning)."
    sql: ${TABLE}.rider_delivery_time_minutes ;;
    value_format: "0.0"
  }
  measure: avg_rider_delivery_time_seconds {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Delivery Time (Seconds)"
    type: average
    description: "Time a rider spent delivering an order in seconds/minutes (difference between trip on route and trip returning)."
    sql: ${TABLE}.rider_delivery_time_seconds ;;
    value_format: "0.00"
  }
  measure: avg_rider_pickup_time_minutes {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Pickup Time (Minutes)"
    type: average
    description: "Time a rider spent picking up the order in seconds/minutes (difference between trip started and trip on route)."
    sql: ${TABLE}.rider_pickup_time_minutes ;;
    value_format: "0.0"
  }
  measure: avg_rider_pickup_time_seconds {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Pickup Time (Seconds)"
    type: average
    description: "Time a rider spent picking up the order in seconds/minutes (difference between trip started and trip on route)."
    sql: ${TABLE}.rider_pickup_time_seconds ;;
    value_format: "0.00"
  }
  measure: avg_rider_return_time_minutes {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Return Time (Minutes)"
    type: average
    description: "Time a rider spent returning to hub in seconds/minutes (difference between trip returning and trip completed)."
    sql: ${TABLE}.rider_return_time_minutes ;;
    value_format: "0.0"
  }
  measure: avg_rider_return_time_seconds {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Return Time (Seconds)"
    type: average
    description: "Time a rider spent returning to hub in seconds/minutes (difference between trip returning and trip completed)."
    sql: ${TABLE}.rider_return_time_seconds ;;
    value_format: "0.00"
  }
  measure: avg_rider_trip_time_minutes {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Trip Time (Minutes)"
    type: average
    description: "Time a rider spent for the entire trip in seconds/minutes (difference between trip started and trip completed)."
    sql: ${TABLE}.rider_trip_time_minutes ;;
    value_format: "0.0"
  }
  measure: avg_rider_trip_time_seconds {
    group_label: "AVG Time Calculations"
    label: "AVG Rider Trip Time (Seconds)"
    type: average
    description: "Time a rider spent for the entire trip in seconds/minutes (difference between trip started and trip completed)."
    sql: ${TABLE}.rider_trip_time_seconds ;;
    value_format: "0.00"
  }
}
