# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-08-31


view: daily_hub_staff_events {
  sql_table_name: `flink-data-dev.dbt_falvarez.daily_hub_staff_events`
    ;;
  view_label: "Daily Hub Staff Events"

  # This is the curated layer of the events coming from Hub One app

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
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.event_uuid ;;
  }

  # =========  Location Attributes   =========

  dimension: country_iso {
    type: string
    group_label: "1 Location Dimensions"
    label: "Country ISO"
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    group_label: "1 Location Dimensions"
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

    # =========  Employee Attributes   =========

  dimension: anonymous_id {
    type: string
    hidden: yes
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: quinyx_badge_number {
    type: string
    sql: ${TABLE}.quinyx_badge_number ;;
  }

  dimension: user_id {
    type: string
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  # =========  Event Attributes   =========

  dimension_group: received {
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
    sql: ${TABLE}.received_at ;;
  }

  dimension_group: event {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension_group: event_timestamp {
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
    sql: ${TABLE}.event_timestamp ;;
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: event_text {
    type: string
    sql: ${TABLE}.event_text ;;
  }

  dimension: screen_name {
    type: string
    sql: ${TABLE}.screen_name ;;
  }

  dimension: component_name {
    type: string
    sql: ${TABLE}.component_name ;;
  }

  dimension: component_value {
    type: string
    sql: ${TABLE}.component_value ;;
  }

  # =========  Other Attributes   =========

  dimension: context_ip {
    type: string
    sql: ${TABLE}.context_ip ;;
  }

  dimension: locale {
    type: string
    sql: ${TABLE}.locale ;;
  }

  dimension: page_path {
    type: string
    sql: ${TABLE}.page_path ;;
  }

  dimension: page_title {
    type: string
    sql: ${TABLE}.page_title ;;
  }

  dimension: page_url {
    type: string
    sql: ${TABLE}.page_url ;;
  }

  dimension: user_agent {
    type: string
    sql: ${TABLE}.user_agent ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Total Metrics  =========

  measure: count {
    type: count
    drill_fields: [component_name, screen_name, event_name]
  }

    # =========  Rate Metrics  =========
}
