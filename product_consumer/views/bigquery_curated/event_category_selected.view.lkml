view: event_category_selected {
  sql_table_name: `flink-data-prod.curated.event_category_selected`;;
  view_label:  "Category Selected"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: event_uuid {
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    type: string
    sql: ${TABLE}.event_uuid ;;
  }
  dimension: user_id {
    group_label: "IDs"
    label: "User ID"
    description: "User ID generated upon user registration"
    type: string
    sql: ${TABLE}.user_id ;;
  }
  dimension: anonymous_id {
    group_label: "IDs"
    label: "Anonymous ID"
    description: "User ID set by Segment"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: device_id {
    group_label: "IDs"
    label: "Device ID"
    description: "ID of an device"
    type: string
    sql: ${TABLE}.device_id ;;
  }
  dimension: category_id {
    group_label: "IDs"
    label: "Category ID"
    description: "ID of product's category"
    type: string
    sql: ${TABLE}.category_id ;;
  }
  dimension: sub_category_id {
    group_label: "IDs"
    label: "Subcategory ID"
    description: "ID of product's subcategory"
    type: string
    sql: ${TABLE}.sub_category_id ;;
  }

  # ======= Generic Dimensions ======= #

  dimension: is_user_logged_in {
    group_label: "Generic Dimensions"
    label: "Is User Logged-in"
    description: "Whether a user was logged-in when an event was triggered"
    type: yesno
    sql: ${TABLE}.is_user_logged_in ;;
  }
  dimension: has_selected_address {
    group_label: "Generic Dimensions"
    label: "Is Address Selected"
    description: "Whether a user had selected address when an event was triggered"
    type: yesno
    sql: ${TABLE}.has_selected_address ;;
  }
  dimension: event_name {
    group_label: "Generic Dimensions"
    label: "Event Name"
    description: "Name of the event triggered"
    type: string
    sql: ${TABLE}.event_name ;;
  }
  dimension: page_path {
    group_label: "Generic Dimensions"
    label: "Page Path"
    description: "Page path on web"
    type: string
    sql: ${TABLE}.page_path ;;
  }

  # ======= Device Dimensions ======= #

  dimension: platform {
    group_label: "Device Dimensions"
    label: "Platform"
    description: "Platform is either iOS, Android or Web"
    type: string
    sql: ${TABLE}.platform ;;
  }
  dimension: device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "Device type is one of: ios, android, windows, macintosh, linux or other"
    type: string
    sql: ${TABLE}.device_type ;;
  }
  dimension: device_model {
    group_label: "Device Dimensions"
    label: "Device Model"
    description: "Model of the device"
    type: string
    sql: ${TABLE}.device_model ;;
  }
  dimension: os_version {
    group_label: "Device Dimensions"
    label: "OS Version"
    description: "Version of the operating system"
    type: string
    sql: ${TABLE}.os_version ;;
  }
  dimension: app_version {
    group_label: "Device Dimensions"
    label: "App Version"
    description: "Version of the app"
    type: string
    sql: ${TABLE}.app_version ;;
  }
  dimension: full_app_version {
    group_label: "Device Dimensions"
    type: string
    description: "Concatenation of device_type and app_version"
    sql: case when ${TABLE}.device_type in ('ios','android') then  (${TABLE}.device_type || '-' || ${TABLE}.app_version ) end ;;
  }

  # ======= Location Dimension ======= #

  dimension: locale {
    group_label: "Location Dimensions"
    label: "Locale"
    description: "Language code | Coutnry, region code"
    type: string
    sql: ${TABLE}.locale ;;
  }
  dimension: timezone {
    group_label: "Location Dimensions"
    label: "Timezone"
    description: "Timezone of user's device"
    type: string
    sql: ${TABLE}.timezone ;;
  }
  dimension: hub_code {
    group_label: "Location Dimensions"
    label: "Hub Code"
    description: "Hub Code"
    type: string
    sql: ${TABLE}.hub_code ;;
  }
  dimension: country_iso {
    group_label: "Location Dimensions"
    label: "Country ISO"
    description: "ISO country"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  # ======= Event Dimensions =======

  dimension: category_name {
    group_label: "Event Dimensions"
    label: "Category Name"
    description: "Name of product's category"
    type: string
    sql: ${TABLE}.category_name ;;
  }
  dimension: subcategory_name {
    group_label: "Event Dimensions"
    label: "Subcategory Name"
    description: "Name of product's subcategory"
    type: string
    sql: ${TABLE}.sub_category_name ;;
  }
  dimension: screen_name {
    group_label: "Event Dimensions"
    label: "Screen Name"
    description: "Name of the screen"
    type: string
    sql: case
      when ${TABLE}.origin_screen in ('categoriesGridViewed','categoriesMainViewed','CategoryViewed') then 'category'
      when ${TABLE}.origin_screen in ('HomeViewed','homeViewed') then 'home'
      when ${TABLE}.origin_screen is null and ${platform} = 'web' then 'category'
      else ${TABLE}.origin_screen
      end ;;
  }

  # ======= Dates / Timestamps =======

  dimension_group: event {
    group_label: "Date / Timestamp"
    label: "Event"
    description: "Timestamp of when an event happened"
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.event_timestamp ;;
    datatype: timestamp
  }

  # ======= HIDDEN Dimension ======= #

  dimension_group: received_at {
    hidden: yes
    type: time
    timeframes: [
      date
    ]
    sql: ${TABLE}.received_at ;;
    datatype: timestamp
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
    label: "# Registered Users"
    description: "Number of users who logged-in during a day"
    type: count_distinct
    sql: ${TABLE}.user_id ;;
  }
  measure: logged_in_anonymous_users {
    label: "# All Users"
    description: "Number of all users regardless of their login status."
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }
}
