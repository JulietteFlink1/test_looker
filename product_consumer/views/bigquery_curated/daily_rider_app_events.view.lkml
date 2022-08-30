# Owner: Bastian Gerstner
# Created: 2022-08-26

# This view contains all behavioural events coming from the rider app

view: daily_rider_app_events {
  sql_table_name: `flink-data-prod.curated.daily_rider_app_events`;;
  view_label: "Daily Rider App Events "

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: anonymous_id {
    group_label: "IDs"
    label: "Anonymous ID"
    description: "User ID set by Segment"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: auth_zero_id {
    group_label: "IDs"
    label: "Auth0 ID"
    description: "Auth0 ID set by Auth0 Platform"
    type: string
    sql: ${TABLE}.auth_zero_id ;;
  }
  dimension: event_uuid {
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    type: string
    sql: ${TABLE}.event_uuid ;;
  }
  dimension: quiniyx_badge_number {
    group_label: "IDs"
    label: "Quiniyx Badge Number"
    description: "Quiniyx Badge Number is the Employment ID"
    type: string
    sql: ${TABLE}.quiniyx_badge_number ;;
  }

  # ======= Generic Dimensions ======= #


  dimension: event_name {
    group_label: "Generic Dimensions"
    label: "Event Name"
    description: "Name of the event triggered"
    type: string
    sql: ${TABLE}.event_name ;;
  }
  dimension: component_content {
    group_label: "Generic Dimensions"
    label: "Component Content"
    description: "Component content where the event was triggered"
    type: string
    sql: ${TABLE}.component_content ;;
  }
  dimension: component_name {
    group_label: "Generic Dimensions"
    label: "Component Name"
    description: "Component name where the event was triggered"
    type: string
    sql: ${TABLE}.component_name ;;
  }
  dimension: component_variant {
    group_label: "Generic Dimensions"
    label: "Component Variant"
    description: "Variation of the component if multiple variants exist"
    type: string
    sql: ${TABLE}.component_variant ;;
  }

  # ======= Device Dimensions ======= #

  dimension: app_build {
    group_label: "Device Dimensions"
    label: "App Build"
    description: "Build of the app"
    type: string
    sql: ${TABLE}.app_build ;;
  }
  dimension: app_version {
    group_label: "Device Dimensions"
    label: "App Version"
    description: "Version of the app"
    type: string
    sql: ${TABLE}.app_version ;;
  }
  dimension: device_model {
    group_label: "Device Dimensions"
    label: "Device Model"
    description: "Device model the rider uses"
    type: string
    sql: ${TABLE}.device_model ;;
  }
  dimension: device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "Device type is either iOS or Android"
    type: string
    sql: ${TABLE}.device_type ;;
  }
  dimension: os_version {
    group_label: "Device Dimensions"
    label: "OS Version"
    description: "Version of the operating system"
    type: string
    sql: ${TABLE}.os_version ;;
  }

  # ======= Location Dimensions ======= #

  dimension: locale {
    group_label: "Location Dimensions"
    label: "Locale"
    description: "Language code | Coutnry, region code"
    type: string
    sql: ${TABLE}.locale ;;
  }


  # ======= Dates / Timestamps =======

  dimension_group: event_timestamp {
    group_label: "Date / Timestamp"
    label: "Event"
    description: "Timestamp of event being fired"
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



  # ======= HIDDEN Dimensions ======= #

  dimension_group: received {
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
    sql: ${TABLE}.received_at ;;
  }
  dimension: ip_address {
    hidden: yes
    type: string
    sql: ${TABLE}.ip_address ;;
  }
  dimension: is_network_cellular {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_network_cellular ;;
  }
  dimension: is_network_wifi {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_network_wifi ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: events {
    label: "# Events"
    description: "Number of events trigegred by users"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: logged_in_users {
    label: "# Logged in Users"
    description: "Number of users who logged-in during a day"
    type: count_distinct
    sql: ${TABLE}.auth_zero_id ;;
  }
  measure: logged_in_anonymous_users {
    label: "# All Users"
    description: "Number of all users regardless of their login status."
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }
}
