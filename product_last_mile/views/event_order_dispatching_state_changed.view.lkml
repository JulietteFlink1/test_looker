# Owner: Bastian Gerstner
# Created: 2022-09-01

# This view contains data coming from the dispatching service about picker queue and respective order status

view: event_order_dispatching_state_changed {
  sql_table_name: `flink-data-prod.curated.event_order_dispatching_state_changed`;;
  view_label: "Event Order Dispatching State Change"

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

  dimension: message_id {
    group_label: "IDs"
    label: "Message ID"
    description: "Message ID represents the unique identifer per event send from dispatching service. One event can contain multiple orders if they were stacked"
    type: string
    sql: ${TABLE}.message_id ;;
  }

  dimension: order_id {
    group_label: "IDs"
    label: "Order ID"
    description: "Order ID for respective order"
    type: string
    sql: ${TABLE}.order_id ;;
  }

  # ======= Picker Queue State Dimensions ======= #

  dimension: picker_queue_state {
    group_label: "Picker Queue State Dimension"
    label: "Picker Queue State"
    description: "State of the order in picker queue"
    type: string
    sql: ${TABLE}.picker_queue_state ;;
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

  # ======= Dates / Timestamps =======

  dimension_group: event_timestamp {
    group_label: "Timestamps"
    label: "Event Timestamp"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.event_timestamp ;;
  }
  dimension_group: published_at_timestamp {
    group_label: "Timestamps"
    label: "Published At Timestamp"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.published_at_timestamp ;;
  }

  # ======= HIDDEN =======

  dimension: attributes {
    hidden: yes
    type: string
    sql: ${TABLE}.attributes ;;
  }

  dimension: subscription_name {
    hidden: yes
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
    label: "# Distinct Orders"
    description: "Number of orders in picker queue"
    type: count_distinct
    sql: ${TABLE}.order_id ;;
  }
  measure: messages {
    group_label: "Measures"
    label: "# Messages"
    description: "Number of messages from dispatching service"
    type: count_distinct
    sql: ${TABLE}.message_id ;;
  }
}
