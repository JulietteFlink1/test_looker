# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-08-31

view: event_order_state_updated {
  sql_table_name: `flink-data-prod.curated.event_order_state_updated`
    ;;

  view_label: "Event: Order State Updated"

  # This is the curated table for Order State Updated event coming from Hub One

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Sets          ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  set: to_include_dimensions {
    fields: [
      order_id,
      order_number,
      origin,
      state
    ]
    }

  set: to_include_measures {
    fields: [
      order_picked_time,
      order_picking_finished_time,
      order_packed_time,
      picked_to_picking_finished_seconds,
      picking_finished_to_packed_seconds,
      picked_to_packed_seconds,
      number_of_orders
    ]
  }

  set: to_include_set {
    fields: [to_include_dimensions*, to_include_measures*]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  IDs   =========

  dimension: event_uuid {
    type: string
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.event_uuid ;;
  }

  dimension: anonymous_id {
    type: string
    group_label: "IDs"
    label: "Anonymous ID"
    description: "User ID set by Segment"
    hidden: yes
    sql: ${TABLE}.anonymous_id ;;
  }

# =========  Location Attributes   =========

  dimension: country_iso {
    type: string
    group_label: "Location Dimensions"
    label: "Country ISO"
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    group_label: "Location Dimensions"
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: locale {
    group_label: "Location Dimensions"
    label: "Locale"
    description: "Language code | Coutnry, region code"
    type: string
    sql: ${TABLE}.locale ;;
  }

  # =========  Employee Attributes   =========

  dimension: quinyx_badge_number {
    type: string
    group_label: "Employee Attributes"
    label: "Quinyx Badge Number"
    sql: ${TABLE}.quinyx_badge_number ;;
  }

  dimension: user_id {
    type: string
    group_label: "Employee Attributes"
    label: "Auth0 id" #Not yet but it should be
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  # =========  Dates and Timestamps   =========

  dimension_group: received {
    type: time
    hidden: yes
    sql: ${TABLE}.received_at ;;
  }

  dimension_group: event {
    type: time
    hidden: yes
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension_group: event_timestamp {
    group_label: "Date / Timestamp"
    label: "Event"
    description: "Timestamp of when an event happened"
    type: time
    timeframes: [
      time,
      date,
      week,
      hour_of_day,
      quarter
    ]
    sql: ${TABLE}.event_timestamp ;;
  }

  # =========  Generic Dimensions   =========

  dimension: event_name {
    group_label: "Generic Dimensions"
    label: "Event Name"
    description: "Name of the event triggered"
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: event_text {
    group_label: "Generic Dimensions"
    label: "Event Text"
    description: "event_name in camel case"
    type: string
    hidden: yes
    sql: ${TABLE}.event_text ;;
  }

  dimension: screen_name {
    group_label: "Generic Dimensions"
    label: "Screen Name"
    description: "Screen name where the event was triggered"
    type: string
    sql: ${TABLE}.screen_name ;;
  }

# =========  Event Dimensions   =========

  dimension: order_id {
    group_label: "Event Properties"
    description: "A unique identifier generated by back-end when an order is placed."
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    group_label: "Event Properties"
    description: "A unique identifier generated by back-end when an order is placed that is more human-readable than the order_id."
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: origin {
    group_label: "Event Properties"
    description: "From where the order has been accepted. It can be picking_screen or qr_code."
    type: string
    sql: ${TABLE}.origin ;;
  }

  dimension: state {
    group_label: "Event Properties"
    description: "State to which the order has been updates. It can be received, picked or packed."
    type: string
    sql: ${TABLE}.state ;;
  }

# =========  Other Dimensions   =========

  dimension: context_ip {
    type: string
    hidden: yes
    sql: ${TABLE}.context_ip ;;
  }

  dimension: page_path {
    type: string
    hidden: yes
    sql: ${TABLE}.page_path ;;
  }

  dimension: page_title {
    type: string
    hidden: yes
    sql: ${TABLE}.page_title ;;
  }

  dimension: page_url {
    type: string
    hidden: yes
    sql: ${TABLE}.page_url ;;
  }

  dimension: user_agent {
    type: string
    hidden: yes
    sql: ${TABLE}.user_agent ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: number_of_events {
    label: "# Events"
    description: "Number of events triggered"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }

  measure: number_of_orders {
    group_label: "Total Metrics"
    label: "# Orders"
    description: "Number of Orders."
    type: count_distinct
    sql: ${TABLE}.order_id ;;
  }

  measure: count_distinct_picking_hours {
    label: "Count distinct picking hours"
    description: "Count distint hour_of_day with an order_state_updated event."
    type: count_distinct
    sql: concat(${event_date},${quinyx_badge_number},${event_timestamp_hour_of_day}) ;;
  }

  # =========  Picking times Dimensions   =========

  measure: order_picked_time {
    group_label: "Picking Times"
    label: "Order Picked Time"
    description: "Timestamp for when the order changed to picked."
    hidden: yes
    sql: MIN(IF(${state}='picked', ${TABLE}.event_timestamp,null)) ;;
  }
  measure: order_packed_time {
    group_label: "Picking Times"
    label: "Order Packed Time"
    description: "Timestamp for when the order changed to packed."
    hidden: yes
    sql: MAX(IF(${state}='packed', ${TABLE}.event_timestamp,null)) ;;
  }

  measure: order_picking_finished_time {
    group_label: "Picking Times"
    label: "Order Picking Finished Time"
    description: "Timestamp for when the order changed to picking_finished."
    hidden: yes
    sql: MIN(IF(${state}='picking_finished', ${TABLE}.event_timestamp,null)) ;;
  }

  measure: picked_to_picking_finished_seconds {
    group_label: "Picking Times"
    label: "Picked to Picking Finisheds"
    description: "Difference in seconds between picked and picking_finished timestamps."
    hidden: yes
    sql: DATETIME_DIFF(${order_picking_finished_time}, ${order_picked_time}, SECOND);;
  }

  measure: picking_finished_to_packed_seconds {
    group_label: "Picking Times"
    label: "Picking Finished to Packed Seconds"
    description: "Difference in seconds between picking_finished and packed timestamps."
    hidden: yes
    sql: DATETIME_DIFF(${order_packed_time}, ${order_picking_finished_time}, SECOND);;
  }

  measure: picked_to_packed_seconds {
    group_label: "Picking Times"
    label: "Picked to Packed Seconds"
    description: "Difference in seconds between picked and packed timestamps."
    hidden: yes
    sql: DATETIME_DIFF(${order_packed_time}, ${order_picked_time}, SECOND);;
  }
}
