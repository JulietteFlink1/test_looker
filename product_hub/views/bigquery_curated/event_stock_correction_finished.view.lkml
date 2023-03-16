view: event_stock_correction_finished {
  sql_table_name: `flink-data-prod.curated.event_stock_correction_finished`
    ;;
  view_label: "Stock Correction Started/ Finished"

  # This is the curated table for Stock Correction Finished event coming from Hub One

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Sets          ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  set: to_include_dimensions {
    fields: [
      product_sku,
      shelf_number,
      quantity_before_correction,
      quantity_damaged,
      quantity_expired,
      quantity_corrected,
      quantity_tgtg,
      quantity_after_correction,
      screen_name
    ]
  }

  set: to_include_measures {
    fields: [
      number_of_events
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
    description: "Language code | Country, region code"
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

  dimension_group: original_timestamp {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.original_timestamp ;;
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

  dimension: shelf_number {
    type: string
    group_label: "Stock Correction Finished Dimensions"
    description: "Unique identifier of the shelf where the SKU is stored in the hub.
    Number of the shelf (from 0 to 86) followed by a letter which indicates
    the level within the shelf."
    sql: ${TABLE}.shelf_number ;;
  }

  dimension: product_sku {
    type: string
    group_label: "Stock Correction Finished Dimensions"
    description: "SKU of the product, as available in the backend."
    sql: ${TABLE}.product_sku ;;
  }

  dimension: quantity_after_correction {
    type: number
    group_label: "Stock Correction Finished Dimensions"
    description: "Quantity after the correction."
    sql: ${TABLE}.quantity_after_correction ;;
  }

  dimension: quantity_before_correction {
    type: number
    group_label: "Stock Correction Finished Dimensions"
    description: "Quantity expected when started the correction."
    sql: ${TABLE}.quantity_before_correction ;;
  }

  dimension: quantity_corrected {
    type: number
    group_label: "Stock Correction Finished Dimensions"
    description: "Quantity reported as corrected."
    sql: ${TABLE}.quantity_corrected ;;
  }

  dimension: quantity_damaged {
    type: number
    group_label: "Stock Correction Finished Dimensions"
    description: "Quantity reported as damaged."
    sql: ${TABLE}.quantity_damaged ;;
  }

  dimension: quantity_expired {
    type: number
    group_label: "Stock Correction Finished Dimensions"
    description: "Quantity reported as expired."
    sql: ${TABLE}.quantity_expired ;;
  }

  dimension: quantity_tgtg {
    type: number
    group_label: "Stock Correction Finished Dimensions"
    description: "Quantity reported as too good to go."
    sql: ${TABLE}.quantity_tgtg ;;
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

  # =========  Total Metrics   =========

  measure: number_of_events {
    group_label: "Stock Correction Finished Measures"
    label: "# Stock Correction Finished"
    description: "Number of events triggered"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }

}
