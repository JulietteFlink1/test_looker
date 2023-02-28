# Owner: Bastian Gerstner
# Created: 2023-02-16
# Stakeholder: Last Mile Product & Rider Ops

# This view contains information rider states of a given rider and the respective changes.

view: event_rider_state_changed {
  sql_table_name: `flink-data-prod.curated.event_rider_state_changed`;;
  view_label: "Event Rider State Changed"

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

  # ======= Generic Dimensions ======= #

  dimension: rider_action {
    group_label: "Generic Dimension"
    label: "Rider Action"
    type: string
    description: "Indicates the action performed by a rider."
    sql: ${TABLE}.rider_action ;;
  }
  dimension: rider_availability {
    group_label: "Generic Dimension"
    label: "Rider Availability"
    type: string
    description: "Indicates if a rider is available to accept orders."
    sql: ${TABLE}.rider_availability ;;
  }
  dimension: rider_latitude {
    group_label: "Generic Dimension"
    label: "Rider Latitude"
    type: number
    description: "Describes the latitude of a riders position"
    sql: ${TABLE}.rider_latitude ;;
  }
  dimension: rider_longitude {
    group_label: "Generic Dimension"
    label: "Rider Longitude"
    type: number
    description: "Describes the longitude of a riders position"
    sql: ${TABLE}.rider_longitude ;;
  }
  dimension: rider_state {
    group_label: "Generic Dimension"
    label: "Rider State"
    type: string
    description: "Indicates the state a rider is in at a given point in time."
    sql: ${TABLE}.rider_state ;;
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
    description: "Timestamp when an event was fired"
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
  dimension_group: published_at_timestamp  {
    group_label: "Timestamps"
    label: "Event Timestamp"
    hidden: yes
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
  measure: distinct_count_riders {
    group_label: "Count Measures"
    label: "# Riders"
    description: "Number of distinct riders"
    type: count_distinct
    sql: ${TABLE}.rider_id ;;
  }
}
