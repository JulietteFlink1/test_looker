# Owner: Product Analytics

# Main Stakeholder:
# - Consumer Product

# Questions that can be answered
# - How many traces were started?

view: event_load_trace_started {
  sql_table_name: `flink-data-prod.curated.event_load_trace_started`
    ;;

  dimension: action_id {
    type: string
    description: "Unique identifier for an action that triggers a latency tracking event. E.g. if user clicks on cart and it results in a request to load cart page, an action id is assigned that differentiates this load from other loads."
    sql: ${TABLE}.action_id ;;
  }

  dimension: anonymous_id {
    type: string
    description: "Unique ID for each user set by Segement."
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: app_version {
    type: string
    description: "Version of the app released, available for apps only."
    sql: ${TABLE}.app_version ;;
  }

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: device_id {
    required_access_grants: [can_access_pii_customers]
    type: string
    description: "Unique ID for each device."
    sql: ${TABLE}.device_id ;;
  }

  dimension: device_model {
    type: string
    description: "Model of the device, available for apps only."
    sql: ${TABLE}.device_model ;;
  }

  dimension: device_type {
    type: string
    description: "Type of the device used, e.i. ios, android, windows, etc."
    sql: ${TABLE}.device_type ;;
  }

  dimension_group: event {
    type: time
    description: "Date when an event was triggered."
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

  dimension: event_name {
    type: string
    description: "Name of an event triggered."
    sql: ${TABLE}.event_name ;;
  }

  dimension_group: event_timestamp {
    type: time
    description: "Timestamp when an event was triggered within the app / web."
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

  dimension: event_uuid {
    type: string
    description: "Unique ID for each event defined by Segment."
    sql: ${TABLE}.event_uuid ;;
  }

  dimension: has_selected_address {
    type: yesno
    description: "TRUE if upon launch the user had a previously confirmed address."
    sql: ${TABLE}.has_selected_address ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_user_logged_in {
    type: yesno
    description: "TRUE if a user was logged during browsing."
    sql: ${TABLE}.is_user_logged_in ;;
  }

  dimension: locale {
    type: string
    description: "Locale on the device."
    sql: ${TABLE}.locale ;;
  }

  dimension: os_version {
    type: string
    description: "Version of the operating system, avaialble for apps only."
    sql: ${TABLE}.os_version ;;
  }

  dimension: page_path {
    type: string
    description: "Page path of users' page view. Page path does not contain domain information nor query parameters."
    sql: ${TABLE}.page_path ;;
  }

  dimension: platform {
    type: string
    description: "Platform which user used, can be 'web' or 'app'."
    sql: ${TABLE}.platform ;;
  }

  dimension_group: received {
    type: time
    description: "Timestamp when an event was received on the server, used for data laod."
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

  dimension_group: start_timestamp {
    type: time
    description: "At which timestamp latency tracking started"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.start_timestamp ;;
  }

  dimension: timezone {
    type: string
    description: "Timezone of the device located."
    sql: ${TABLE}.timezone ;;
  }

  dimension: trace_name {
    type: string
    description: "Name identifying which load was traced. Possible values: load_cart, load_checkout"
    sql: ${TABLE}.trace_name ;;
  }

  dimension: user_id {
    type: string
    description: "Unique ID for each user set upon account creation. This ID is passed under all behaviorual events when a user is logged in and is identical to the External ID under back-end models such as \"orders\"."
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [trace_name, event_name]
  }
}
