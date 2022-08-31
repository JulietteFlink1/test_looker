# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-08-31

view: event_order_progressed {
  sql_table_name: `flink-data-dev.dbt_falvarez.event_order_progressed`
    ;;

  view_label: "Order Progressed"

  # This is the curated table for Order Progressed event coming from Hub One

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Sets          ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

  dimension: action {
    description: "The action performed. It can be item_picked, item_skipped, item_refunded or item_reset."
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension: ean {
    description: "An array that contains the ean/ eans of the sku."
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: method {
    description: "The used method to pick an item. It can be scanned, clicked or reported."
    type: string
    sql: ${TABLE}.method ;;
  }

  dimension: order_id {
    description: "A unique identifier generated by back-end when an order is placed."
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    description: "A unique identifier generated by back-end when an order is placed that is more human-readable than the order_id."
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: product_sku {
    description: "The sku of the product, as available in the backend."
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: quantity {
    description: "The quantity affected."
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: reason {
    description: "The reason an item has been reported. It can be code_wrong or code_damaged."
    type: string
    sql: ${TABLE}.reason ;;
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
    description: "Number of events trigegred"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
}
