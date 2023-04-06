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
    description: "Number of distinct events triggerd by rider equipment service"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: riders {
    group_label: "Measures"
    label: "# Distinct Riders"
    description: "Number of distinct riders"
    type: count_distinct
    sql: ${TABLE}.rider_id ;;
  }
  measure: total_number_requested_events {
    group_label: "Measures"
    label: "# Requested Events"
    description: "Total number of equipment requested events. Equipment is requested by the rider once they are eligble."
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [rider_equipment_state: "requested"]
  }
  measure: total_number_returned_events {
    group_label: "Measures"
    label: "# Returned Events"
    description: "Total number of equipment returned events. Equipment is returned by the rider once they leave Flink"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [rider_equipment_state: "returned"]
  }
  measure: total_number_delivered_events {
    group_label: "Measures"
    label: "# Delivered Events"
    description: "Total number of equipment delivered events. Equipment is considered delivered when the bundle arrived at the hub."
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [rider_equipment_state: "delivered"]
  }
  measure: total_number_claimed_events {
    group_label: "Measures"
    label: "# Claimed Events"
    description: "Total number of equipment claimed events. Equipment is considered claimed once the rider claimed the bundle."
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [rider_equipment_state: "claimed"]
  }
  measure: total_number_rejected_events {
    group_label: "Measures"
    label: "# Rejected Events"
    description: "Total number of equipment rejected events. Equipment can be rejected due to being damaged or delivered in the wrong size."
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [rider_equipment_state: "rejected"]
  }
  measure: total_number_confirmed_events {
    group_label: "Measures"
    label: "# Confirmed Events"
    description: "Total number of equipment confirmed events. After rider claimed the bundle, HM marks this bundle as confirmed."
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [rider_equipment_state: "confirmed"]
  }
  measure: total_number_unclaimed_events {
    group_label: "Measures"
    label: "# Unclaimed Events"
    description: "Total number of equipment unclaimed events. Bundle arrived at hub but hasn't been claimed by the rider."
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [rider_equipment_state: "unclaimed"]
  }
  measure: claimed_equipment_rate {
    group_label: "% Rate Measures"
    label: "% Equipment Claimed"
    description: "% of Equipment Claimed"
    type: number
    sql:  ${total_number_claimed_events}/nullif(${total_number_requested_events},0) ;;
    value_format_name: percent_1
  }
  measure: rejected_equipment_rate {
    group_label: "% Rate Measures"
    label: "% Equipment Requests Rejected"
    description: "% of Equipment Requests Rejected"
    type: number
    sql:  ${total_number_rejected_events}/nullif(${total_number_requested_events},0) ;;
    value_format_name: percent_1
  }
  measure: delivered_equipment_rate {
    group_label: "% Rate Measures"
    label: "% Equipment Requests Delivered"
    description: "% of Equipment Requests Delivered"
    type: number
    sql:  ${total_number_delivered_events}/nullif(${total_number_requested_events},0) ;;
    value_format_name: percent_1
  }
}
