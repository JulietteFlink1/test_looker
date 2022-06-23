view: event_cart_viewed {
  sql_table_name: `flink-data-prod.curated.event_cart_viewed`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: event_uuid {
    type: string
    sql: ${TABLE}.event_uuid ;;
  }

  dimension: cart_id {
    type: string
    sql: ${TABLE}.cart_id ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: device_id {
    type: string
    sql: ${TABLE}.device_id ;;
  }

# ======= Generic Dimensions ======= #

  dimension: has_selected_address {
    group_label: "Generic Dimensions"
    type: yesno
    sql: ${TABLE}.has_selected_address ;;
  }

  dimension: is_user_logged_in {
    group_label: "Generic Dimensions"
    type: yesno
    sql: ${TABLE}.is_user_logged_in ;;
  }

  dimension: event_name {
    group_label: "Generic Dimensions"
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: rank_of_daily_cart_views {
    group_label: "Measure Dimensions"
    type: number
    description: "Number of daily cart views on a user level basis"
    sql: ${TABLE}.rank_of_daily_cart_views ;;
  }

# ======= Location Dimension ======= #

  dimension: country_iso {
    group_label: "Location Dimensions"
    type: string
    description: "Country of User"
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    group_label: "Location Dimensions"
    type: string
    description: "Hub assigned to User"
    sql: ${TABLE}.hub_code ;;
  }

  dimension: locale {
    group_label: "Location Dimensions"
    type: string
    hidden: yes
    sql: ${TABLE}.locale ;;
  }

  dimension: timezone {
    group_label: "Location Dimensions"
    type: string
    description: "Timezone of User"
    sql: ${TABLE}.timezone ;;
  }

# ======= Device Dimensions ======= #

  dimension: app_version {
    group_label: "Device Dimensions"
    type: string
    description: "App_version of the device"
    sql: ${TABLE}.app_version ;;
  }

  dimension: device_model {
    group_label: "Device Dimensions"
    type: string
    description: "Device Model"
    sql: ${TABLE}.device_model ;;
  }

  dimension: device_type {
    group_label: "Device Dimensions"
    type: string
    description: "Device Type"
    sql: ${TABLE}.device_type ;;
  }

  dimension: os_version {
    group_label: "Device Dimensions"
    type: string
    description: "OS Version of the device used"
    sql: ${TABLE}.os_version ;;
  }

  dimension: platform {
    group_label: "Device Dimensions"
    type: string
    description: "Platform is either iOS, Android or Web"
    sql: ${TABLE}.platform ;;
  }

# ======= Dynamic Delivery Fee Dimensions ======= #

  dimension: delivery_fee {
    group_label: "DDF Dimensions"
    type: number
    description: "Dynamic Delivery fee displayed upon entering cart"
    sql: ${TABLE}.delivery_fee ;;
  }

  dimension: sub_total {
    group_label: "DDF Dimensions"
    type: number
    description: "the sub total value of the cart upon firing the event"
    sql: ${TABLE}.sub_total ;;
  }

  dimension: message_displayed {
    group_label: "DDF Dimensions"
    type: string
    description: "corresponding message displayed to user based on ddf"
    sql: ${TABLE}.message_displayed ;;
  }

# ======= Dates / Timestamps =======

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


# ======= Hidden =======

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
    hidden:  yes
    sql: ${TABLE}.event_timestamp ;;
  }

  dimension: page_path {
    type: string
    hidden: yes
    sql: ${TABLE}.page_path ;;
  }

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
    hidden: yes
    sql: ${TABLE}.received_at ;;
  }

  dimension: screen_name {
    type: string
    hidden: yes
    sql: ${TABLE}.screen_name ;;
  }

# ======= Measures ======= #

  measure: avg_daily_cart_events {
    group_label: "Measure Dimensions"
    type: average
    description: "AVG number of daily cart visits per user"
    sql: ${TABLE}.rank_of_daily_cart_views ;;
  }

  measure: all_users {
    group_label: "Measure Dimensions"
    description: "Number of all users regardless of their login status."
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }

  measure: count {
    group_label: "Measure Dimensions"
    type: count
    drill_fields: [screen_name, event_name]
  }
}
