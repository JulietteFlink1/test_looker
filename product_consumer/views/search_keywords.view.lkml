view: search_keywords {
  sql_table_name: `flink-data-prod.reporting.search_keywords`
  ;;
  view_label: "Search Keywords"

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
    description: "Platform of a device: app or web"
    type: string
    sql: ${TABLE}.platform ;;
  }
  dimension: device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "Type of the device used"
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
    sql: ${device_type} || '-' || ${app_version} ;;
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

    # ======= Search Dimensions =======

  dimension: search_query {
    group_label: "Search Dimensions"
    label: "Search Query"
    description: "Search query / word types by user int he search bar"
    type: string
    sql: ${TABLE}.search_query ;;

  }
  dimension: is_search_label_used {
    group_label: "Search Dimensions"
    label: "Is Search Label Used"
    description: "Whether predefined search label was used"
    type: yesno
    sql: ${TABLE}.is_search_label_used ;;
  }

  dimension: is_added_to_cart_after_search {
    group_label: "Search Dimensions"
    label: "Is Add-to-cart after Search"
    description: "Whether an add-to-cart event followed after a search query"
    type: yesno
    sql: ${TABLE}.is_added_to_cart_after_search ;;
  }
  dimension: is_pdp_after_search {
    group_label: "Search Dimensions"
    label: "Is PDP after Search"
    description: "Whether an PDP event followed after a search query"
    type: yesno
    sql: ${TABLE}.is_pdp_after_search ;;
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
  dimension: dim_number_of_available_results {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_available_results ;;
  }
  dimension: dim_number_of_all_results {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_all_results ;;
  }
  dimension: dim_number_of_unavailable_results {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_unavailable_results ;;
  }
  dimension: dim_search_query_id {
    type: string
    hidden: yes
    sql: ${TABLE}.search_query_id ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures      ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: cnt_unique_anonymousid {
    group_label: "Search Measures"
    label: "# Users"
    description: "# Unique Users as identified via Anonymous ID from Segment"
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }
  measure: cnt_unique_userid {
    group_label: "Search Measures"
    label: "# Logged-in Users"
    description: "# Unique Users as identified via User ID upon login"
    type: count_distinct
    sql: ${user_id};;
    value_format_name: decimal_0
  }
  measure: number_of_all_searches {
    group_label: "Search Measures"
    label: "# Searches"
    description: "Total number of times Search was executed"
    type: count_distinct
    hidden: no
    sql: ${event_uuid} ;;
  }
  measure: number_of_add_to_cart_after_search {
    group_label: "Search Measures"
    label: "# Add-to-Cart after Search"
    description: "Total number of Add-to-Cart events after Search was executed"
    type: count_distinct
    hidden: no
    sql: ${event_uuid} ;;
    filters: [is_added_to_cart_after_search: "yes"]
  }
  measure: number_of_pdp_after_search {
    group_label: "Search Measures"
    label: "# PDP after Search"
    description: "Total number of PDP events after Search was executed"
    type: count_distinct
    hidden: no
    sql: ${event_uuid} ;;
    filters: [is_pdp_after_search: "yes"]
  }
    measure: number_of_all_zero_search_results {
    group_label: "Search Measures"
    label: "# No Results Searches"
    description: "Total number of searches which returned 0 results"
    type: sum
    hidden: no
    sql: if(${dim_number_of_available_results}= 0, 1, 0) ;;
  }
  measure: number_of_unavailable_search_results {
    group_label: "Search Measures"
    label: "# Out-of-Stock Searches"
    description: "Number of search with unavailable (out-of-stock) products"
    type: sum
    hidden: no
    sql: if(${dim_number_of_unavailable_results}> 0, 1, 0) ;;
  }
  measure: number_of_all_non_zero_search_results {
    group_label: "Search Measures"
    label: "# Non-Zero Results Searches"
    description: "Total number of searches which returned more than 1 result."
    type: sum
    hidden: no
    sql: if(${dim_number_of_all_results}> 0, 1, 0) ;;
  }

  #### Search Results Measures ####
  measure: number_of_all_results {
    group_label: "Product Search Measures"
    label: "# Products Returned"
    description: "Total number of products returned after a search was executed."
    type: sum
    hidden: no
    sql: ${dim_number_of_all_results} ;;
  }
  measure: number_of_available_results {
    group_label: "Product Search Measures"
    label: "# Available Products Returned"
    description: "Number of available products returned after a search was executed."
    type: sum
    hidden: no
    sql: ${dim_number_of_available_results} ;;
  }
  measure: number_of_unavailable_results {
    group_label: "Product Search Measures"
    label: "# Unavailable Products Returned"
    description: "Number of unavailable (out-of-stock) products returned after a search was executed."
    type: sum
    hidden: no
    sql: ${dim_number_of_unavailable_results} ;;
  }

  #### Rates ####

  measure: ctr {
    group_label: "Rates (%)"
    label: "Click-Through Rate (CTR)"
    type: number
    description: "# searches with either PDP or Add-to-Cart / # total searches"
    value_format_name: percent_2
    sql: (${number_of_pdp_after_search} + ${number_of_add_to_cart_after_search}) / nullif(${number_of_all_searches},0);;
  }
  measure: cvr {
    group_label: "Rates (%)"
    label: "Add-To-Cart Rate"
    type: number
    description: "# searches with Add-to-Cart / # total searches"
    value_format_name: percent_2
    sql: ${number_of_add_to_cart_after_search} / nullif(${number_of_all_searches},0);;
  }
  measure: zero_results_rate {
    group_label: "Rates (%)"
    label: "No Search Results Rate"
    type: number
    description: "# searches with Add-to-Cart / # total searches"
    value_format_name: percent_2
    sql: ${number_of_all_zero_search_results} / nullif(${number_of_all_searches},0);;
  }
    measure: out_of_stock_rate {
    group_label: "Rates (%)"
    label: "Out-of-Stock Rate"
    type: number
    description: "# Searches with products which are OoS / # total search results"
    value_format_name: percent_2
    sql: ${number_of_unavailable_search_results} / nullif(${number_of_all_searches},0);;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

    set: detail {
      fields: [
        event_uuid,
        user_id,
        anonymous_id,
        device_id,
        is_user_logged_in,
        has_selected_address,
        event_date,
        event_name,
        platform,
        device_type,
        device_model,
        os_version,
        app_version,
        locale,
        timezone,
        page_path,
        hub_code,
        country_iso,
        is_search_label_used,
        search_query,
        number_of_available_results,
        number_of_all_results,
        number_of_unavailable_results,
        is_added_to_cart_after_search,
        is_pdp_after_search
      ]
    }
  }

# }
