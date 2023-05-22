view: event_sponsored_product_impressions {
  sql_table_name: `flink-data-prod.curated.event_sponsored_product_impressions`
    ;;
  view_label:  "Sponsored Product Impression"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: event_id {
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    type: string
    sql: ${TABLE}.event_id ;;
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

  dimension: ad_decision_id {
    group_label: "IDs"
    label: "Ad Decision ID"
    description: "Ad Decision ID generated by Kevel"
    type: string
    sql: ${TABLE}.ad_decision_id ;;
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

# ======= Dates / Timestamps =======

  dimension_group: event_timestamp {
    group_label: "Date / Timestamp"
    label: "Event"
    description: "Timestamp of when an event happened"
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
    datatype: timestamp
  }

  # ======= Event Dimensions =======

  dimension: category_id {
    group_label: "Event Dimensions"
    label: "Category ID"
    description: "Category ID generated by Commerce Tools"
    type: string
    sql: ${TABLE}.category_id ;;
  }

  dimension: category_name {
    group_label: "Event Dimensions"
    label: "Category Name"
    description: "Category Name as shown to the user"
    type: string
    sql: ${TABLE}.category_name ;;
  }

  dimension: product_placement {
    group_label: "Event Dimensions"
    label: "Product Placement"
    description: "The UI where the product was seen"
    type: string
    sql: ${TABLE}.product_placement ;;
  }

  dimension: product_position {
    group_label: "Event Dimensions"
    label: "Product Position"
    description: "The position in the list of products where the product was shown. 1 is the first position on the top left of the UI component."
    type: number
    sql: ${TABLE}.product_position ;;
  }

  dimension: product_sku {
    group_label: "Event Dimensions"
    label: "Product SKU"
    description: "SKU as per Commerce Tools"
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: categories_with_reco_highlights {
    description: "Lists categories in which recommendation highlights occur"
    type: string
    sql: CASE WHEN NOT ${is_sponsored_product} THEN ${category_name} ELSE NULL END ;;

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
    sql: ${TABLE}.received_at ;;
  }

  dimension: screen_name {
    group_label: "Event Dimensions"
    label: "Screen Name"
    description: "The screen where the impression occurred"
    type: string
    sql: ${TABLE}.screen_name ;;
  }

  dimension: sub_category_name {
    group_label: "Event Dimensions"
    label: "Subcategory Name"
    description: "The name of the subcategory as shown to the user"
    type: string
    sql: ${TABLE}.sub_category_name ;;
  }

  dimension: is_sponsored_product {
    group_label: "Event Dimensions"
    label: "Is Sponsored Product"
    description: "Whether or not the product shown was a sponsored product"
    type: yesno
    sql: ${TABLE}.is_sponsored_product ;;

  }

  # ======= Hidden Dimension ======= #


  dimension: list_category {
    type: string
    hidden: yes
    sql: ${TABLE}.list_category ;;
  }

  dimension: product_context {
    type: string
    hidden: yes
    sql: ${TABLE}.product_context ;;
  }

  dimension: product_impression_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.product_impression_uuid ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: count {
    label: "Count"
    description: "Generic row count"
    type: count
    drill_fields: [event_name]
  }

  measure: events {
    group_label: "Measures"
    label: "# Impression Events"
    description: "Number of events triggered by users"
    type: count_distinct
    sql: ${TABLE}.product_impression_uuid ;;
  }
  measure: logged_in_users {
    group_label: "Measures"
    label: "# Registered Users"
    description: "Number of users who logged-in during a day"
    type: count_distinct
    sql: ${TABLE}.user_id ;;
  }
  measure: all_users {
    group_label: "Measures"
    label: "# All Users"
    description: "Number of all users regardless of their login status."
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }
  measure: number_of_ad_decisions_ids {
    group_label: "Measures"
    label: "# Distinct Ad Decision Ids"
    description: "Number of distinct Ad Decision Ids recorded."
    type: count_distinct
    sql: ${TABLE}.ad_decision_id ;;
  }

}
