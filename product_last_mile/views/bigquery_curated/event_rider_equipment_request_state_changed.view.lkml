# Owner: Bastian Gerstner
# Created: 2023-02-14

# This view contains data about requested rider equipment and the respective state of the request

view: event_rider_equipment_request_state_changed {
  sql_table_name: `flink-data-prod.curated.event_rider_equipment_request_state_changed`;;
  view_label: "1 Rider Equipment Request State Changed"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: actor_id {
    group_label: "IDs"
    label: "Actor ID"
    type: string
    description: "Unique identifier for a hub employee performing a given action."
    sql: ${TABLE}.actor_id ;;
  }
  dimension: event_uuid {
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique event ID"
    type: string
    sql: ${TABLE}.event_uuid ;;
  }
  dimension: message_id {
    group_label: "IDs"
    label: "Message ID"
    description: "Message ID represents the unique identifer per event send from dispatching service. One event can contain multiple orders if they were stacked"
    type: string
    sql: ${TABLE}.message_id ;;
  }
  dimension: rider_id {
    group_label: "IDs"
    label: "Rider ID"
    type: string
    description: "Unique identifier of each rider."
    sql: ${TABLE}.rider_id ;;
  }
  dimension: variation_id {
    group_label: "IDs"
    label: "Variation ID"
    type: string
    description: "SKU of the bundle requested."
    sql: ${TABLE}.variation_id ;;
  }

  # ======= Generic Dimensions ======= #

  dimension: rejected_reason {
    group_label: "Generic Dimension"
    label: "Rejected Reason"
    type: string
    description: "Reason why the rider equipment request was rejected."
    sql: ${TABLE}.rejected_reason ;;
  }
  dimension: rider_equipment_bundle_key {
    group_label: "Generic Dimension"
    label: "Rider Equipment Bundle Key"
    type: string
    description: "Equipment bundle key represents the rider equipment bundle requested by the rider."
    sql: ${TABLE}.rider_equipment_bundle_key ;;
  }
  dimension: rider_equipment_state {
    group_label: "Generic Dimension"
    label: "Rider Equipment State"
    type: string
    description: "Represents the state the requested rider equipment is in i.e. requested or claimed."
    sql: ${TABLE}.rider_equipment_state ;;
  }

  # ======= Location Dimensions ======= #

  dimension: country_iso {
    group_label: "Location Dimension"
    label: "Country ISO"
    description: "Country order will be fulfilled in"
    type: string
    sql: ${TABLE}.country_iso ;;
  }
  dimension: hub_code {
    group_label: "Location Dimension"
    label: "Hub Code"
    description: "Respective hub order was fulfilled in"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  # ======= Dates / Timestamps ======= #

  dimension_group: event_timestamp {
    group_label: "Timestamps"
    label: "Event Timestamp"
    type: time
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

  # ======= Hidden ======= #

  dimension: attribute_name {
    hidden:  yes
    type: string
    sql: ${TABLE}.attribute_name ;;
  }
  dimension: event_request_id {
    hidden: yes
    type: string
    sql: ${TABLE}.event_request_id ;;
  }
  dimension_group: published_at_timestamp {
    type: time
    hidden:  yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.published_at_timestamp ;;
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
    label: "# Distinct Events"
    description: "Number of events triggerd by dispatching service"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: orders {
    group_label: "Measures"
    label: "# Distinct Riders"
    description: "Number of riders"
    type: count_distinct
    sql: ${TABLE}.rider_id ;;
  }
}
