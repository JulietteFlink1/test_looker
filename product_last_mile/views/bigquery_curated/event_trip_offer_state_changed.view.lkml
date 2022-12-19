# Owner: Bastian Gerstner
# Created: 2022-12-12
# Stakeholder: Last Mile Product & Rider Ops

# This view contains information about trip offers from auto assign. The events are emitted from the order fulfillment service

view: event_trip_offer_state_changed {
  sql_table_name: `flink-data-prod.curated.event_trip_offer_state_changed`;;
  view_label: "Event Trip Offer State Changed"

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
  dimension: offer_id {
    group_label: "IDs"
    label: "Offer ID"
    description: "A unique identifier of each offer."
    type: string
    sql: ${TABLE}.offer_id ;;
  }

  # ======= Generic Dimensions ======= #

  dimension: trip_offer_state {
    group_label: "Generic Dimension"
    label: "Trip Offer State"
    type: string
    description: "A state a given order can be in when offered to a rider."
    sql: ${TABLE}.trip_offer_state ;;
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
  dimension: expires_at_timestamp {
    type: string
    hidden: yes
    description: "Timestamp at which an trip offer expires."
    sql: ${TABLE}.expires_at_timestamp ;;
  }

  dimension_group: event_timestamp {
    hidden:  yes
    group_label: "Timestamps"
    label: "Event Timestamp"
    type: time
    description: "Timestamp when an event was triggered"
    timeframes: [
      time,
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.event_timestamp ;;
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
  measure: number_distinct_offers {
    group_label: "Count Measures"
    label: "# Offers"
    description: "Number of Offers"
    type: count_distinct
    sql: ${TABLE}.offer_id ;;
  }
  measure: number_distinct_riders {
    group_label: "Count Measures"
    label: "# Riders"
    description: "Number of Distinct Riders"
    type: count_distinct
    sql: ${TABLE}.rider_id ;;
  }
  measure: total_number_offers_created {
    group_label: "Count Measures"
    label: "# Offer Created Events"
    description: "Number of Created Offer Events"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [trip_offer_state: "CREATED"]
  }
  measure: total_number_offers_expired {
    group_label: "Count Measures"
    label: "# Offer Expired Events"
    description: "Number of Offer Expired Events"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [trip_offer_state: "EXPIRED"]
  }
  measure: total_number_declined_events {
    group_label: "Count Measures"
    label: "# Offers Declined Events"
    description: "Number of Offer Declined Events"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [trip_offer_state: "DECLINED"]
  }
  measure: expired_offers_rate {
    group_label: "% Rate Measures"
    label: "% Offers Expired"
    description: "% of Offers Expired"
    type: number
    sql:  ${total_number_offers_expired}/nullif(${total_number_offers_created},2) ;;
    value_format_name: percent_1
  }
  measure: declined_offers_rate {
    group_label: "% Rate Measures"
    label: "% Offers Declined"
    description: "% of Offers Declined"
    type: number
    sql: ${total_number_declined_events}/nullif(${total_number_offers_created},2) ;;
    value_format_name: percent_1
  }
}
