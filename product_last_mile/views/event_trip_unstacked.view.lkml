# Owner: Bastian Gerstner
# Created: 2022-09-01

# This view contains data coming from the dispatching service orders being manually unstacked

view: event_trip_unstacked {
  sql_table_name: `flink-data-prod.curated.event_trip_unstacked`;;
  view_label: "Event Order Trip Unstacked"


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

  dimension: auth_zero_id {
    group_label: "IDs"
    label: "Auth0 ID"
    description: "Used to identify user via auth0 service"
    type: string
    sql: ${TABLE}.auth_zero_id ;;
  }

  dimension: trip_order_ids {
    group_label: "IDs"
    label: "Order ID"
    description: "Order ID for respective order"
    type: string
    sql: ${TABLE}.trip_order_ids ;;
  }

  # ======= Location Dimension ======= #

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

  # ======= Dates / Timestamps =======

  dimension_group: event_timestamp {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.event_timestamp ;;
  }

  # ======= HIDDEN ======= #

  dimension: attributes {
    hidden: yes
    type: string
    sql: ${TABLE}.attributes ;;
  }

  dimension: message_id {
    hidden:  yes
    type: string
    sql: ${TABLE}.message_id ;;
  }

  dimension_group: published_at_timestamp {
    hidden:  yes
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.published_at_timestamp ;;
  }

  dimension: subscription_name {
    hidden:  yes
    type: string
    sql: ${TABLE}.subscription_name ;;
  }

  dimension: type {
    hidden:  yes
    type: string
    sql: ${TABLE}.type ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: events {
    label: "# Events"
    description: "Number of events triggerd by dispatching service"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: orders {
    label: "# Distinct Orders"
    description: "Number of orders in picker queue"
    type: count_distinct
    sql: ${TABLE}.trip_order_ids ;;
  }


}
