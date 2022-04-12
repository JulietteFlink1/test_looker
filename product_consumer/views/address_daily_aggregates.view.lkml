view: address_daily_aggregates {
  sql_table_name: `flink-data-prod.reporting.daily_user_address_aggregates`
    ;;

  ## I want to additional fields: one is the hub that appOpened detected, one is a flag that says whether appOpened changed the hub assignment since the last other event happened

  measure: count {
    description: "Counts the number of occurrences of the selected dimension(s)"
    type: count
    drill_fields: [detail*]
  }

  dimension: daily_user_uuid {
    group_label: "IDs"
    description: "A surrogate key representing a unique identifier per user per day. If the same users interacted with the app on two different days, they will get a different identifier."
    type: string
    primary_key: yes
    sql: ${TABLE}.daily_user_uuid ;;
  }

  ######## Flags | Event ########
  # User Flags specific to addresses (not part of the daily_user_aggregates model)

  dimension: is_address_confirmed {
    group_label: "Flags | Event"
    label: "Is Address Confirmed"
    description: "Did daily_user_uuid select a (new) address?"
    type: yesno
    sql: ${TABLE}.is_address_confirmed ;;
  }

  dimension: is_location_pin_placed {
    group_label: "Flags | Event"
    label: "Is Location Pin Placed"
    description: "Did daily_user_uuid choose a location on the map?"
    type: yesno
    sql: ${TABLE}.is_location_pin_placed ;;
  }

  dimension: is_address_resolution_failed_inside_area {
    group_label: "Flags | Event"
    label: "Is Address Resolution Failed Events Inside Delivery Area"
    description: "Did daily_user_uuid experience any addressResolutionFailed events inside delivery area?"
    type: yesno
    sql: ${TABLE}.is_address_resolution_failed_inside_area ;;
  }

  dimension: is_address_resolution_failed_outside_area {
    group_label: "Flags | Event"
    label: "Is Address Resolution Failed Events Outside Delivery Area"
    description: "Did daily_user_uuid experience any addressResolutionFailed events outside delivery area?"
    type: yesno
    sql: ${TABLE}.is_address_resolution_failed_outside_area ;;
  }

  dimension: is_address_skipped {
    group_label: "Flags | Event"
    label: "Is Address Skipped"
    description: "Did daily_user_uuid skip address selection while being inside delivery area?"
    type: yesno
    sql: ${TABLE}.is_address_skipped ;;
  }

  dimension: is_map_viewed {
    group_label: "Flags | Event"
    label: "Is Map Viewed"
    description: "Did daily_user_uuid view the address selection map?"
    type: yesno
    sql: ${TABLE}.is_map_viewed ;;
  }

  dimension: is_selection_browse_selected {
    group_label: "Flags | Event"
    label: "Is Browse Selection"
    description: "Did daily_user_uuid choose to browse selection while being outside of our delivery area?"
    type: yesno
    sql: ${TABLE}.is_selection_browse_selected ;;
  }

  dimension: is_waitlist_signup_selected {
    group_label: "Flags | Event"
    label: "Is Waitlist Signup Selected"
    description: "Did daily_user_uuid tap the waitlist sign up button?"
    type: yesno
    sql: ${TABLE}.is_waitlist_signup_selected ;;
  }

  dimension: is_hub_updated_with_cart {
    group_label: "Flags | Event"
    label: "Is Hub Updated With Cart"
    description: "Did daily_user_uuid update their address or hub after they already put a product into their cart?"
    type: yesno
    sql: ${TABLE}.is_hub_updated_with_cart ;;
  }

  dimension: is_addres_tappped_at_checkout {
    group_label: "Flags | Event"
    label: "Is Waitlist Signup Selected"
    description: "Did daily_user_uuid tap the address at checkout?"
    type: yesno
    sql: ${TABLE}.is_addres_tappped_at_checkout ;;
  }

  ######### User Metrics ###########

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
    label: "# Daily Users Inside Delivery Area"
    description: "# daily users with least one Location Pin Placed at a location we can deliver to (=inside delivery zone and resolvable address)"
    type: count
    filters: [is_seen_inside_delivery_area: "yes", is_location_pin_placed: "yes"]
  }

  measure: cnt_unavailable_area {
    group_label: "# Daily Users"
    label: "# Daily Users Outside Delivery Area"
    description: "# daily users with at least one Location Pin Placed at a location we cannot deliver to (=outside delivery zone or no resolvable address)"
    type: count
    filters: [is_seen_outside_delivery_area: "yes", is_location_pin_placed: "yes"]
  }

  measure: cnt_address_skipped_in_available_area {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Skipped, At Deliverable Location"
    description: "# daily users who skipped address selection at least once and the user was at a deliverable location and did not select any address"
    type: count
    filters: [is_seen_inside_delivery_area: "yes", is_address_skipped: "yes", is_address_confirmed: "no"]
  }

  measure: cnt_address_confirmed_area_available {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Confirmed, Inside Delivery Area"
    description: "# daily users with at least one address was selected and address selection wasn't skipped"
    type: count
    filters: [is_seen_inside_delivery_area: "yes", is_address_confirmed: "yes", is_address_skipped: "no"]
  }

  measure: cnt_confirmed_and_skipped_area_available {
    group_label: "# Daily Users"
    label: "# Daily Users With Address Confirmed AND Address Skipped, Inside Delivery Area"
    description: "# daily users who were in an available area and both selected and skipped address at least once"
    type: count
    filters: [is_seen_inside_delivery_area: "yes", is_address_confirmed: "yes", is_address_skipped: "yes"]
  }

  measure: cnt_noaction_area_available {
    group_label: "# Daily Users"
    label: "# Daily Users Without Address Confirmed or Address Skipped but Location Pin Placed, Inside Delivery Area"
    description: "# daily users who were in an available area but did not perform any address selection or skipping action"
    type: count
    filters: [is_seen_inside_delivery_area: "yes", is_address_confirmed: "no", is_address_skipped: "no"]
  }

  measure: cnt_waitlist_area_unavailable {
    group_label: "# Daily Users"
    label: " # Daily Users With Waitlist Intent, Outside Delivery Area"
    description: "# daily users who were in an unavailable area and selected join waitlist but did not browse products"
    type: count
    filters: [is_seen_outside_delivery_area: "yes", is_waitlist_signup_selected: "yes", is_selection_browse_selected: "no"]
  }

  measure: cnt_browse_area_unavailable {
    label: "# Daily Users With Product Browsing, Outside Delivery Area"
    description: "# daily users who were in an unavailable area and selected browse products but did not sign up for waitlist"
    type: count
    filters: [is_seen_outside_delivery_area: "yes", is_selection_browse_selected: "yes", is_waitlist_signup_selected: "no"]
  }

  measure: cnt_waitlist_and_browse_area_unavailable {
    group_label: "# Daily Users"
    label: "# Daily Users With Waitlist Intent AND Product Browsing, Outside Delivery Area"
    description: "# daily users who were in an unavailable area and both selected join waitlist and browsed products"
    type: count
    filters: [is_seen_outside_delivery_area: "yes", is_selection_browse_selected: "yes", is_waitlist_signup_selected: "yes"]
  }

  measure: cnt_noaction_area_unavailable {
    group_label: "# Daily Users"
    label: "# Daily Users Without Waitlist Intent or Product Browsing but Location Pin Placed, Outside Delivery Area"
    description: "# daily users who were in an unavailable area and did not have a waitlist joining intent or browsing selection action"
    type: count
    filters: [is_seen_outside_delivery_area: "yes", is_selection_browse_selected: "no", is_waitlist_signup_selected: "no"]
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

  ######## Daily Attributes ########

  dimension: is_seen_inside_delivery_area {
    group_label: "Location Dimensions"
    label: "Has Seen Location Inside Delivery Area"
    description: "TRUE if there was any locationPinPlaced inside of the delivery area, FALSE otherwise"
    type: yesno
    sql: ${TABLE}.is_seen_inside_delivery_area;;
  }

  dimension: is_seen_outside_delivery_area {
    group_label: "Location Dimensions"
    label: "Has Seen Location Inside Delivery Area"
    description: "TRUE if there was any locationPinPlaced outside of the delivery area, FALSE otherwise"
    type: yesno
    sql: ${TABLE}.is_seen_outside_delivery_area;;
  }

  dimension: is_seen_deliverable_location {
    group_label: "Location Dimensions"
    label: "Has Seen Deliverable Location"
    description: "TRUE if there was any locationPinPlaced within a deliverable location, FALSE otherwise"
    type: yesno
    sql: ${TABLE}.is_seen_deliverable_location;;
  }

  dimension: is_seen_undeliverable_location {
    group_label: "Location Dimensions"
    label: "Has Seen Undeliverable Location"
    description: "TRUE if there was any locationPinPlaced on a location that was not deliverable (=either outside of delivery area or inside of delivery area on a location that is not deliverable), FALSE otherwise"
    type: yesno
    sql: ${TABLE}.is_seen_undeliverable_location;;
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

  set: detail {
    fields: [
      daily_user_uuid,
      event_date_at_date,
      is_seen_inside_delivery_area,
      is_seen_outside_delivery_area,
      is_seen_deliverable_location,
      is_seen_undeliverable_location,
      is_location_pin_placed,
      is_address_skipped,
      is_address_resolution_failed_inside_area,
      is_address_resolution_failed_outside_area,
      is_address_confirmed,
      is_waitlist_signup_selected
    ]
  }
}
