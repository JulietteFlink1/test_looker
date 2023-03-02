# Owner: Bastian Gerstner
# Created: 2022-10-05
# Stakeholder: Last Mile Product & Rider Ops

# This view contains information about individual deliveries. The events are emitted from the order fulfillment service

view: event_delivery_state_updated {
  sql_table_name: `flink-data-prod.curated.event_delivery_state_updated`;;
  view_label: "1 Event Delivery State Updated"

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
  dimension: delivery_id {
    group_label: "IDs"
    label: "Delivery ID"
    description: "A unique identifier for a delivery"
    type: string
    sql: ${TABLE}.delivery_id ;;
  }
  dimension: event_uuid {
    group_label: "IDs"
    label: "Event UUID"
    type: string
    description: "A unique ID for each event defined by Segment."
    sql: ${TABLE}.event_uuid ;;
  }
  dimension: order_id {
    group_label: "IDs"
    label: "Order ID"
    type: string
    description: "A unique identifier generated by back-end when an order is placed."
    sql: ${TABLE}.order_id ;;
  }
  dimension: rider_id {
    group_label: "IDs"
    label: "Rider ID"
    type: string
    description: "A unique identifier of each rider."
    sql: ${TABLE}.rider_id ;;
  }

  # ======= Generic Dimension ======= #

  dimension: event_name {
    group_label: "Generic Dimension"
    label: "Event Name"
    type: string
    description: "Name of an event triggered."
    sql: ${TABLE}.event_name ;;
  }

  # ======= Location Dimension ======= #

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

  # ======= Timestamps ======= #

  dimension_group: event_timestamp {
    group_label: "Timestamps"
    label: "Event Timestamp"
    type: time
    description: "Timestamp when an event was triggered within the app / web."
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

  # ======= Hidden Dimension ======= #

  dimension: attribute_name {
    hidden:  yes
    type: string
    sql: ${TABLE}.attribute_name ;;
  }
  dimension: subscription_name {
    type: string
    sql: ${TABLE}.subscription_name ;;
  }
  dimension_group: published_at_timestamp {
    group_label: "Timestamps"
    hidden:  yes
    label: "Published At Timestamp"
    type: time
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
    group_label: "Measures"
    label: "# Events"
    description: "Number of unique events"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: orders {
    group_label: "Measures"
    label: "# Distinct Orders"
    description: "Number of distinct orders"
    type: count_distinct
    sql: ${TABLE}.order_id ;;
  }
  measure: messages {
    group_label: "Measures"
    label: "# Delivers"
    description: "Number of unique delivers "
    type: count_distinct
    sql: ${TABLE}.delivery_id ;;
  }
  measure: number_of_actors {
    group_label: "Measures"
    label: "# Actors"
    description: "Number of unique Actors "
    type: count_distinct
    sql: ${TABLE}.actor_id ;;
  }
  measure: number_of_riders {
    group_label: "Measures"
    label: "# Riders"
    description: "Number of unique Riders "
    type: count_distinct
    sql: ${TABLE}.rider_id ;;
  }
}
