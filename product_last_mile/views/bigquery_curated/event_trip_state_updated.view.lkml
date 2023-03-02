# Owner: Bastian Gerstner
# Created: 2022-10-05
# Stakeholder: Last Mile Product & Rider Ops

# This view contains information about trips. The events are emitted from the order fulfillment service

view: event_trip_state_updated {
  sql_table_name: `flink-data-prod.curated.event_trip_state_updated`;;
  view_label: "1 Event Trip State Updated"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Sets          ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  set: to_include_dimensions {
    fields: [
      actor_id,
      rider_id,
      trip_id,
      event_name,
      is_force_action,
      event_timestamp_date,
      event_timestamp_hour_of_day,
      event_timestamp_month,
      event_timestamp_quarter,
      event_timestamp_time,
      event_timestamp_week
    ]
  }
  set: to_include_measures {
    fields: [
      events,
      number_distinct_trips,
      number_distinct_riders,
      number_distinct_actors,
      total_trip_completed_events,
      number_of_force_complete_events,
      total_trip_rejected_events,
      number_of_force_unassignments_from_dashboard_events,
      total_trip_started_events,
      number_of_force_assignments_from_dashboard_events
    ]
  }

  set: to_include_set {
    fields: [to_include_dimensions*, to_include_measures*]
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: actor_id {
    group_label: "IDs"
    label: "Actor ID"
    type: string
    description: "A unique identifier for a hub employee performing a given action."
    sql: ${TABLE}.actor_id ;;
  }
  dimension: event_uuid {
    group_label: "IDs"
    label: "Event UUID"
    type: string
    description: "A unique ID for each event defined by Segment."
    sql: ${TABLE}.event_uuid ;;
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

  # ======= Generic Dimensions ======= #

  dimension: event_name {
    group_label: "Generic Dimension"
    label: "Event Name"
    type: string
    description: "Name of an event triggered."
    sql: ${TABLE}.event_name ;;
  }
  dimension: is_force_action {
    group_label: "Generic Dimension"
    label: "Force Complete"
    type: yesno
    description: "Actor ID is not the same as the Rider ID"
    sql: ${event_trip_state_updated.actor_id} != ${event_trip_state_updated.rider_id}  ;;
  }
  dimension: generic_value {
    group_label: "Generic Dimension"
    label: "Generic Value"
    type: string
    description: "Generic value specify a int value corresponding with the generic context."
    sql: ${TABLE}.generic_value ;;
  }
  dimension: generic_context {
    group_label: "Generic Dimension"
    label: "Generic Context"
    type: string
    description: "Generic field specifiying a passed value e.g. entered geofence area."
    sql: ${TABLE}.generic_context ;;
  }
  dimension: delivery_provider {
    group_label: "Generic Dimension"
    label: "Delivery Provider "
    type: string
    description: "Delivery provider executing the delivery of the trip."
    sql: ${TABLE}.delivery_provider ;;
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

  dimension_group: event_timestamp {
    group_label: "Timestamps"
    label: "Event Timestamp"
    type: time
    description: "Timestamp when an event was triggered"
    timeframes: [
      time,
      hour_of_day,
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.event_timestamp ;;
  }

  # ======= HIDDEN Dimensions ======= #

  dimension: attribute_name {
    hidden:  yes
    type: string
    sql: ${TABLE}.attribute_name ;;
  }
  dimension: subscription_name {
    hidden:  yes
    type: string
    sql: ${TABLE}.subscription_name ;;
  }
  dimension_group: published_at_timestamp {
    group_label: "Timestamps"
    label: "Published Timestamp"
    hidden: yes
    type: time
    description: "Timestamp when an event was published"
    timeframes: [
      time,
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.published_at_timestamp ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: events {
    group_label: "Count Measures"
    label: "# Events"
    description: "Number of events triggerd by dispatching service"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: number_distinct_trips {
    group_label: "Count Measures"
    label: "# Trips"
    description: "Number of trips"
    type: count_distinct
    sql: ${TABLE}.trip_id ;;
  }
  measure: number_distinct_riders {
    group_label: "Count Measures"
    label: "# Riders"
    description: "Number of distinct riders"
    type: count_distinct
    sql: ${TABLE}.rider_id ;;
  }
  measure: number_distinct_actors {
    group_label: "Count Measures"
    label: "# Actors"
    description: "Number of distinct Actors"
    type: count_distinct
    sql: ${TABLE}.actor_id ;;
  }
  measure: total_trip_completed_events {
    group_label: "Count Measures"
    label: "# Trip Completed Events"
    description: "Number of Trip Completed Events"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [event_name: "trip_completed"]
  }
  measure: number_of_force_complete_events {
    group_label: "Forced Measures"
    label: "# of Force Complete Events"
    description: "Number of Force Complete events triggerd"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [is_force_action: "yes", event_name: "trip_completed"]
  }
  measure: total_trip_rejected_events {
    group_label: "Count Measures"
    label: "# Trip Rejected Events"
    description: "Number of Trip Rejected Events"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [event_name: "trip_rejected"]
    }
  measure: number_of_force_unassignments_from_dashboard_events {
    group_label: "Forced Measures"
    label: "# of Rejections from Dashboard Events"
    description: "Number of Force Unassigments performed from Hub Dashboard"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [is_force_action: "yes", event_name: "trip_rejected"]
  }
  measure: total_trip_started_events {
    group_label: "Count Measures"
    label: "# Trip Started Events"
    description: "Number of Trip Started Events"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [event_name: "trip_started"]
    }
  measure: number_of_force_assignments_from_dashboard_events {
    group_label: "Forced Measures"
    label: "# of Trips Started from Dashboard"
    description: "Number of Force Assignments From Hub Dashboard"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [is_force_action: "yes", event_name: "trip_started"]
      }
}
