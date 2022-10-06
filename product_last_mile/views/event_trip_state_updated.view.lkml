# Owner: Bastian Gerstner
# Created: 2022-10-05
# Stakeholder: Last Mile Product & Rider Ops

# This view contains information about trips. The events are emitted from the order fulfillment service

view: event_trip_state_updated {
  sql_table_name: `flink-data-prod.curated.event_trip_state_updated`;;
  view_label: "Event Trip State Updated"

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
    label: "Tip ID"
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

  # ======= Location Dimensions ======= #

  dimension: country_iso {
    group_label: "Location Dimension"
    label: "Country ISO"
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

  dimension_group: event_timestamp {
    group_label: "Timestamps"
    label: "Event Timestamp"
    type: time
    description: "Timestamp when an event was triggered within the app / web."
    timeframes: [
      time,
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.event_timestamp ;;
  }
  dimension_group: published_at_timestamp {
    group_label: "Timestamps"
    label: "Published Timestamp"
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


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: events {
    group_label: "Measures"
    label: "# Events"
    description: "Number of events triggerd by dispatching service"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: number_distinct_trips {
    group_label: "Measures"
    label: "# Trips"
    description: "Number of trips"
    type: count_distinct
    sql: ${TABLE}.trip_id ;;
  }
  measure: number_distinct_riders {
    group_label: "Measures"
    label: "# Riders"
    description: "Number of distinct riders"
    type: count_distinct
    sql: ${TABLE}.rider_id ;;
  }
  measure: number_distinct_actors {
    group_label: "Measures"
    label: "# Actors"
    description: "Number of distinct Actors"
    type: count_distinct
    sql: ${TABLE}.actor_id ;;
  }
}
