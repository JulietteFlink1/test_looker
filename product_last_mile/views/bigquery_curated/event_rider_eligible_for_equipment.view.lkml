# Owner: Bastian Gerstner
# Created: 2023-02-14

# This view contains data about rider equipment and the respective state a request is in

view: event_rider_eligible_for_equipment {
  sql_table_name: `flink-data-dev.curated.event_rider_eligible_for_equipment`;;
  view_label: "Rider Eligible For Equipment"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: event_uuid {
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique event ID"
    type: string
    sql: ${TABLE}.event_uuid ;;
  }
  dimension: rider_id {
    group_label: "IDs"
    label: "Rider ID"
    type: string
    description: "Unique identifier of each rider."
    sql: ${TABLE}.rider_id ;;
  }

  # ======= Generic Dimensions ======= #

  dimension: rider_equipment_bundle_key {
    group_label: "Generic Dimension"
    label: "Rider Equipment Bundle Key"
    type: string
    description: "Equipment bundle key represents the rider equipment bundle requested by the rider."
    sql: ${TABLE}.rider_equipment_bundle_key ;;
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
