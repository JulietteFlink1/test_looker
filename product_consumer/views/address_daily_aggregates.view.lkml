view: address_daily_aggregates {
  sql_table_name: `flink-data-dev.reporting.address_daily_aggregates`
    ;;

  dimension: has_order {
    type: yesno
    sql: ${TABLE}.has_order ;;
  }

  ## I want to additional fields: one is the hub that appOpened detected, one is a flag that says whether appOpened changed the hub assignment since the last other event happened

  measure: count {
    description: "Counts the number of occurrences of the selected dimension(s)"
    type: count
    drill_fields: [detail*]
  }

  ######### IDs ##########
  dimension: user_uuid {
    group_label: "IDs"
    description: "User ID that is either ID from logged-in user (generated when user creates an account with us) or anonymous ID from not logged-in user"
    type: string
    sql: ${TABLE}.user_uuid ;;
  }

  dimension: daily_user_uuid {
    group_label: "IDs"
    description: "A surrogate key representing a unique identifier per user per day. If the same users interacted with the app on two different days, they will get a different identifier."
    type: string
    primary_key: yes
    sql: ${TABLE}.daily_user_uuid ;;
  }

  # dimension: timezone {
  #   type: string
  #   sql: ${TABLE}.timezone ;;
  # }

# removed fields: session_id, anonymous_id, user_id, session_duration_minutes, session_start_at, session_end_at

  ########## Device attributes #########
  dimension: app_version {
    group_label: "Device Dimensions"
    label: "App version"
    description: "App version used in the session"
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: platform {
    group_label: "Device Dimensions"
    label: "Platform"
    description: "Platform type: android, ios or web"
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "Device type, e.g. ios, android, windows, linux, etc."
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: full_app_version {
    group_label: "Device Dimensions"
    description: "Device type and app version combined in one dimension"
    type: string
    sql: CASE WHEN ${TABLE}.device_type IN ('ios','android') THEN  (${TABLE}.device_type || '-' || ${TABLE}.app_version ) END ;;
  }

  ########## Location attributes #########
  dimension: hub_code {
    group_label: "Location Dimensions"
    description: "Hub code associated with the last address the user selected"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_city {
    group_label: "Location Dimensions"
    label: "City"
    description: "City associated with the last address the user selected"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    hidden: yes
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: country {
    group_label: "Location Dimensions"
    description: "Country ISO associated with the last address the user selected"
    type: string
    case: {
      when: {
        sql: ${country_iso} = "DE" ;;
        label: "Germany"
      }
      when: {
        sql: ${country_iso} = "FR" ;;
        label: "France"
      }
      when: {
        sql: ${country_iso} = "NL" ;;
        label: "Netherlands"
      }
      when: {
        sql: ${country_iso} = "AT" ;;
        label: "Austria"
      }
      else: "Other / Unknown"
    }
  }

  ######## Event Flags ########
  # User Flags

  dimension: is_address_confirmed {
    group_label: "Event Occurences"
    label: "Is Address Confirmed"
    description: "Did daily_user_uuid select a (new) address?"
    type: yesno
    sql: ${TABLE}.is_address_confirmed ;;
  }

  dimension: is_home_viewed {
    group_label: "Event Occurences"
    label: "Is Home Viewed"
    description: "Did daily_user_uuid view home?"
    type: yesno
    sql: ${TABLE}.is_home_viewed ;;
  }

  dimension: is_location_pin_placed {
    group_label: "Event Occurences"
    label: "Is Location Pin Placed"
    description: "Did daily_user_uuid choose a location on the map?"
    type: yesno
    sql: ${TABLE}.is_location_pin_placed ;;
  }

  dimension: is_address_resolution_failed_inside_area {
    group_label: "Event Occurences"
    label: "Is Address Resolution Failed Events Inside Delivery Area"
    description: "Did daily_user_uuid experience any addressResolutionFailed events inside delivery area?"
    type: yesno
    sql: ${TABLE}.is_address_resolution_failed_inside_area ;;
  }

  dimension: is_address_resolution_failed_outside_area {
    group_label: "Event Occurences"
    label: "Is Address Resolution Failed Events Outside Delivery Area"
    description: "Did daily_user_uuid experience any addressResolutionFailed events outside delivery area?"
    type: yesno
    sql: ${TABLE}.is_address_resolution_failed_outside_area ;;
  }

  dimension: is_address_skipped {
    group_label: "Event Occurences"
    label: "Is Address Skipped"
    description: "Did daily_user_uuid skip address selection while being inside delivery area?"
    type: yesno
    sql: ${TABLE}.is_address_skipped ;;
  }

  dimension: is_map_viewed {
    group_label: "Event Occurences"
    label: "Is Map Viewed"
    description: "Did daily_user_uuid view the address selection map?"
    type: yesno
    sql: ${TABLE}.is_map_viewed ;;
  }

  dimension: is_selection_browse_selected {
    group_label: "Event Occurences"
    label: "Is Browse Selection"
    description: "Did daily_user_uuid choose to browse selection while being outside of our delivery area?"
    type: yesno
    sql: ${TABLE}.is_selection_browse_selected ;;
  }

  dimension: is_waitlist_signup_selected {
    group_label: "Event Occurences"
    label: "Is Waitlist Signup Selected"
    description: "Did daily_user_uuid tap the waitlist sign up button?"
    type: yesno
    sql: ${TABLE}.is_waitlist_signup_selected ;;
  }

  dimension: is_checkout_viewed {
    group_label: "Event Occurences"
    label: "Is Hub Updated With Cart"
    description: "Did daily_user_uuid update their address or hub after they already put a product into their cart?"
    type: yesno
    sql: ${TABLE}.is_checkout_viewed ;;
  }

  dimension: is_hub_updated_with_cart {
    group_label: "Event Occurences"
    label: "Is Hub Updated With Cart"
    description: "Did daily_user_uuid update their address or hub after they already put a product into their cart?"
    type: yesno
    sql: ${TABLE}.is_hub_updated_with_cart ;;
  }

  dimension: is_addres_tappped_at_checkout {
    group_label: "Event Occurences"
    label: "Is Waitlist Signup Selected"
    description: "Did daily_user_uuid tap the address at checkout?"
    type: yesno
    sql: ${TABLE}.is_addres_tappped_at_checkout ;;
  }

  ######### User Metrics ###########

  measure: cnt_users_with_address {
    group_label: "# Daily Users"
    label: "# Daily Users With Address"
    description: "# daily users with address (selected in the past or on that day)"
    type: count
    filters: [is_address_set: "yes"]
  }

  measure: cnt_users_address_selected {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Confirmed"
    description: "# daily users with at least one Address Confirmed event"
    type: count
    filters: [is_address_confirmed: "yes"]
  }

  measure: cnt_users_location_pin_placed {
    group_label: "# Daily Users"
    label: "# Daily Users With Location Pin Placed"
    description: "# daily users with at least one Location Pin Placed event"
    type: count
    filters: [is_location_pin_placed: "yes"]
  }

  measure: cnt_has_waitlist_signup_selected {
    group_label: "# Daily Users"
    label: "# Daily Users With Waitlist Intent"
    description: "# daily users with Waitlist Signup Selected event"
    type: count
    filters: [is_waitlist_signup_selected: "yes"]
  }

  measure: cnt_available_area {
    group_label: "# Daily Users"
    label: "# Daily Users At Deliverable Location"
    description: "# daily users with least one Location Pin Placed at a location we can deliver to (=inside delivery zone and resolvable address)"
    type: count
    filters: [has_seen_inside_delivery_area: "yes", is_location_pin_placed: "yes"]
  }

  measure: cnt_unavailable_area {
    group_label: "# Daily Users"
    label: "# Daily Users Outside Deliverable Locations"
    description: "# daily users with at least one Location Pin Placed at a location we cannot deliver to (=outside delivery zone or no resolvable address)"
    type: count
    filters: [has_seen_outside_delivery_area: "yes", is_location_pin_placed: "yes"]
  }

  measure: cnt_address_skipped_in_available_area {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Skipped, At Deliverable Location"
    description: "# daily users who skipped address selection at least once and the user was at a deliverable location and did not select any address"
    type: count
    filters: [has_seen_inside_delivery_area: "yes", is_address_skipped: "yes", is_address_confirmed: "no"]
  }

  measure: cnt_address_confirmed_area_available {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Confirmed, Inside Delivery Area"
    description: "# daily users with at least one address was selected and address selection wasn't skipped"
    type: count
    filters: [has_seen_inside_delivery_area: "yes", is_address_confirmed: "yes", is_address_skipped: "no"]
  }

  measure: cnt_confirmed_and_skipped_area_available {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Confirmed AND Address Skipped, Inside Delivery Area"
    description: "# daily users who were in an available area and both selected and skipped address at least once"
    type: count
    filters: [has_seen_inside_delivery_area: "yes", is_address_confirmed: "yes", is_address_skipped: "yes"]
  }

  measure: cnt_noaction_area_available {
    group_label: "# Daily Users"
    label: "# Daily Users Without Address Confirmed or Address Skipped but Location Pin Placed, Inside Delivery Area"
    description: "# daily users who were in an available area but did not perform any address selection or skipping action"
    type: count
    filters: [has_seen_inside_delivery_area: "yes", is_address_confirmed: "no", is_address_skipped: "no"]
  }

  measure: cnt_waitlist_area_unavailable {
    group_label: "# Daily Users"
    label: " # Daily Users With Waitlist Intent, Outside Delivery Area"
    description: "# daily users who were in an unavailable area and selected join waitlist but did not browse products"
    type: count
    filters: [has_seen_outside_delivery_area: "yes", is_waitlist_signup_selected: "yes", is_selection_browse_selected: "no"]
  }

  measure: cnt_browse_area_unavailable {
    label: "# Daily Users With Product Browsing, Outside Delivery Area"
    description: "# daily users who were in an unavailable area and selected browse products but did not sign up for waitlist"
    type: count
    filters: [has_seen_outside_delivery_area: "yes", is_selection_browse_selected: "yes", is_waitlist_signup_selected: "no"]
  }

  measure: cnt_waitlist_and_browse_area_unavailable {
    group_label: "# Daily Users"
    label: "# Daily Users With Waitlist Intent AND Product Browsing, Outside Delivery Area"
    description: "# daily users who were in an unavailable area and both selected join waitlist and browsed products"
    type: count
    filters: [has_seen_outside_delivery_area: "yes", is_selection_browse_selected: "yes", is_waitlist_signup_selected: "yes"]
  }

  measure: cnt_noaction_area_unavailable {
    group_label: "# Daily Users"
    label: "# Daily Users Without Waitlist Intent or Product Browsing but Location Pin Placed, Outside Delivery Area"
    description: "# daily users who were in an unavailable area and did not have a waitlist joining intent or browsing selection action"
    type: count
    filters: [has_seen_outside_delivery_area: "yes", is_selection_browse_selected: "no", is_waitlist_signup_selected: "no"]
  }

  # NOTE: want to update this to also be able to specify whether it's failed within delivery area or not
  measure: cnt_address_resolution_failed_inside_area {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Unidentified, Inside Delivery Area"
    description: "# daily users that experienced at least one unidentified address inside delivery area"
    type: count
    filters: [is_address_resolution_failed_inside_area: "yes"]
  }

  measure: cnt_address_resolution_failed_outside_area {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Unidentified, Outside Delivery Area"
    description: "# daily users that experienced at least one unidentified address inside delivery areaa"
    type: count
    filters: [is_address_resolution_failed_outside_area: "yes"]
  }

  measure: cnt_address_skipped {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Skipped"
    description: "# daily users who skipped address selection"
    type: count
    filters: [is_address_skipped: "yes"]
  }

  measure: cnt_map_viewed {
    group_label: "# Daily Users"
    label: "# Daily Users With Map Viewed"
    description: "# daily users who viewed address selection map at least once"
    type: count
    filters: [is_map_viewed: "yes"]
  }

  measure: cnt_is_hub_updated_with_cart {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Updated With Cart"
    description: "# daily users who updated their address after having added at least one product to their cart"
    type: count
    filters: [is_hub_updated_with_cart: "yes"]
  }

  measure: cnt_is_addres_tappped_at_checkout {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Tapped At Checkout"
    description: "# daily users who tapped on the delivery address on the checkout screen"
    type: count
    filters: [is_addres_tappped_at_checkout: "yes"]
  }

  measure: cnt_is_checkout_viewed {
    group_label: "# Daily Users"
    label: "# Daily Users With Checkout Viewed"
    description: "# daily users with at least one Checkout Viewed event"
    type: count
    filters: [is_checkout_viewed: "yes"]
  }

  ######## Daily Attributes ########

  dimension: is_address_set {
    group_label: "Daily User Dimensions"
    description: "Whether the Daily User had an Address Confirmed (either saved from a previous day or selected in the current)"
    type: yesno
    sql: ${TABLE}.is_address_set ;;
  }

  dimension: is_new_user {
    group_label: "Session Dimensions"
    description: "Whether it was the first session of the user (= new user)"
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }

  dimension: delivery_pdt {
    group_label: "Session Dimensions"
    label: "Delivery PDT"
    description: "The delivery PDT in minutes associated with the selected address"
    type: number
    sql: ${TABLE}.delivery_pdt ;;
  }

  dimension: delivery_lat {
    group_label: "Location Dimensions"
    label: "Delivery Latitude"
    description: "The latitude of the delivery address selected by user"
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }

  dimension: delivery_lng {
    group_label: "Location Dimensions"
    label: "Delivery Longitude"
    description: "The longitude of the delivery address selected by user"
    type: number
    sql: ${TABLE}.delivery_lng ;;
  }

  dimension: has_seen_inside_delivery_area {
    group_label: "Location Dimensions"
    label: "Has Seen Location Inside Delivery Area"
    description: "TRUE if there was any locationPinPlaced inside of the delivery area, FALSE otherwise"
    type: yesno
    sql: ${TABLE}.has_seen_inside_delivery_area;;
  }

  dimension: has_seen_outside_delivery_area {
    group_label: "Location Dimensions"
    label: "Has Seen Location Inside Delivery Area"
    description: "TRUE if there was any locationPinPlaced outside of the delivery area, FALSE otherwise"
    type: yesno
    sql: ${TABLE}.has_seen_outside_delivery_area;;
  }

  dimension: has_seen_deliverable_location {
    group_label: "Location Dimensions"
    label: "Has Seen Deliverable Location"
    description: "TRUE if there was any locationPinPlaced within a deliverable location, FALSE otherwise"
    type: yesno
    sql: ${TABLE}.has_seen_deliverable_location;;
  }

  dimension: has_seen_undeliverable_location {
    group_label: "Location Dimensions"
    label: "Has Seen Undeliverable Location"
    description: "TRUE if there was any locationPinPlaced on a location that was not deliverable (=either outside of delivery area or inside of delivery area on a location that is not deliverable), FALSE otherwise"
    type: yesno
    sql: ${TABLE}.has_seen_undeliverable_location;;
  }

######## Dates ########

  dimension_group: event_date_at {
    group_label: "Date Dimensions"
    label: "Event date"
    type: time
    datatype: date
    timeframes: [
      day_of_week,
      date,
      week,
      month
    ]
    sql: ${TABLE}.event_date ;;
  }
  dimension: event_date_granularity {
    group_label: "Date Dimensions"
    label: "Event Date (Dynamic)"
    label_from_parameter: timeframe_picker
    description: "Event Date. Note to set timeframe for week, month, etc., filter on Event Date Granularity Setting. This field will update accordingly"
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    sql:
      {% if timeframe_picker._parameter_value == 'Day' %}
        ${event_date_at_date}
      {% elsif timeframe_picker._parameter_value == 'Week' %}
        ${event_date_at_week}
      {% elsif timeframe_picker._parameter_value == 'Month' %}
        ${event_date_at_month}
      {% endif %};;
  }

  parameter: timeframe_picker {
    group_label: "Date Dimensions"
    label: "Event Date Granularity"
    type: unquoted
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  measure: mcvr1 {
    label: "mCVR1"
    type: number
    description: "Number of daily_user_uuid where an address was selected, compared to the total number of active users"
    value_format_name: percent_1
    sql: ${cnt_users_address_selected}/NULLIF(${count},0) ;;
  }

  set: detail {
    fields: [
      daily_user_uuid,
      event_date_at_date,
      user_uuid,
      is_address_set,
      has_seen_inside_delivery_area,
      has_seen_outside_delivery_area,
      has_seen_deliverable_location,
      has_seen_undeliverable_location,
      is_location_pin_placed,
      is_address_skipped,
      is_address_resolution_failed_inside_area,
      is_address_resolution_failed_outside_area,
      is_address_confirmed,
      is_waitlist_signup_selected,
      app_version,
      device_type,
      is_new_user,
      hub_code,
      country_iso,
      hub_city,
      delivery_pdt,
    ]
  }
}
