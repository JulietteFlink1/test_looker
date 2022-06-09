view: daily_user_address_aggregates {
  sql_table_name: `flink-data-dev.reporting.daily_user_address_aggregates`
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

  dimension: user_uuid {
    group_label: "IDs"
    label: "User UUID"
    type: string
    description: "Unique user identifier: if user was logged in, the identifier is 'user_id' populated upon registration, else 'anonymous_id' populated by Segment"
    sql: ${TABLE}.anonymous_id ;;
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

  dimension: is_skip_address_selection_onboarding {
    group_label: "Flags | Event"
    label: "Is Address Selection Skipped"
    description: "Did daily_user_uuid choose to browse selection on onboarding screen and skip address selection?"
    type: yesno
    sql: ${TABLE}.is_skip_address_selection_onboarding ;;
  }

  dimension: is_seen_unresolved_address {
    group_label: "Flags | Event"
    label: "Is Address Resolution Failed Event"
    description: "Did daily_user_uuid experience any address resolution failure?"
    type: yesno
    sql: ${TABLE}.is_seen_unresolved_address ;;
  }

  dimension: is_seen_address_search {
    group_label: "Flags | Event"
    label: "Is Map Viewed"
    description: "Did daily_user_uuid view the address selection map?"
    type: yesno
    sql: ${TABLE}.is_seen_address_search ;;
  }

  dimension: is_skip_waitlist {
    group_label: "Flags | Event"
    label: "Is Browsing Because Outside Of Delivery Area"
    description: "Did daily_user_uuid choose to browse selection while being outside of our delivery area?"
    type: yesno
    sql: ${TABLE}.is_skip_waitlist ;;
  }

  dimension: is_waitlist_signup_selected {
    group_label: "Flags | Event"
    label: "Is Waitlist Signup Selected"
    description: "Did daily_user_uuid tap the waitlist sign up button?"
    type: yesno
    sql: ${TABLE}.is_waitlist_signup_selected ;;
  }

  dimension: is_city_not_available {
    group_label: "Flags | Event"
    label: "Is City Not Available Selected"
    description: "Did daily_user_uuid choose to browse as guest and then select that their city is not available?"
    type: yesno
    sql: ${TABLE}.is_city_not_available ;;
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
    label: "Address Tap At Checkout"
    description: "Did daily_user_uuid tap the address at checkout?"
    type: yesno
    sql: ${TABLE}.is_addres_tappped_at_checkout ;;
  }

  ######### User Metrics ###########

  measure: cnt_users_address_selected {
    group_label: "# Active User Metrics"
    label: "# Active Users With Address Confirmed"
    description: "# daily users with at least one Address Confirmed event"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_address_confirmed: "yes"]
  }

  measure: cnt_has_waitlist_signup_selected {
    group_label: "# Active User Metrics"
    label: "# Active Users With Waitlist Intent"
    description: "# daily users with Waitlist Signup Selected event"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_waitlist_signup_selected: "yes"]
  }

  measure: cnt_available_area {
    group_label: "# Active User Metrics"
    label: "# Active Users Inside Delivery Area"
    description: "# daily users who selected at least one address that is inside our delivery area and saw the address refinement screen"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_selected_address_inside_delivery_area: "yes"]
  }

  measure: cnt_noaction_area_available {
    group_label: "# Active User Metrics"
    label: "# Active Users Without Address Confirmed Inside Delivery Area"
    description: "# daily users who were in an available area but did not confirm any address"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_selected_address_inside_delivery_area: "yes", is_address_confirmed: "no"]
  }

  measure: cnt_browse_area_unavailable {
    group_label: "# Active User Metrics"
    label: "# Active Users Outside Delivery Selecting Browse Products"
    description: "# daily users who were in an unavailable area and selected browse products and did not sign up for waitlist"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_selected_address_outside_delivery_area: "yes", is_skip_waitlist: "yes", is_waitlist_signup_selected: "no"]
  }

  measure: cnt_unavailable_area {
    group_label: "# Active User Metrics"
    label: "# Active Users Outside Delivery Area"
    description: "# daily users who selected at least one address that is outside our delivery area and saw the out of delivery area screen"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_selected_address_outside_delivery_area: "yes"]
  }

  measure: cnt_has_waitlist_signup_selected_no_browsing {
    group_label: "# Active User Metrics"
    label: "# Active Users With Waitlist Intent And Without Selecting Browse Products"
    description: "# daily users who were in an unavailable area and selected to join waitlist and did not select browse products"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_waitlist_signup_selected: "yes"]
  }

  measure: cnt_has_waitlist_signup_selected_and_browsing {
    group_label: "# Active User Metrics"
    label: "# Active Users With Waitlist Intent And Selecting Browse Products"
    description: "# daily users who were in an unavailable area and tapped both the join waitlist and select browse products buttons"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_waitlist_signup_selected: "yes", is_skip_waitlist: "yes"]
  }

  measure: cnt_noaction_area_unavailable {
    group_label: "# Active User Metrics"
    label: "# Active Users Outside Delivery Area Without Waitlist Intent or Product Browsing"
    description: "# daily users who were in an unavailable area and did not have a waitlist joining intent or browsing selection action"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_selected_address_outside_delivery_area: "yes", is_skip_waitlist: "no", is_waitlist_signup_selected: "no"]
  }

  measure: cnt_is_city_unavailable {
    group_label: "# Active User Metrics"
    label: "# Active Users With Unavailable Cities"
    description: "# daily users that tapped City Not Available"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_city_not_available: "yes"]
  }

  measure: cnt_address_resolution_failed {
    group_label: "# Active User Metrics"
    label: "# Active Users With Unidentified Address"
    description: "# daily users that experienced at least one unidentified address"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_seen_unresolved_address: "yes"]
  }

  measure: cnt_is_seen_address_search {
    group_label: "# Active User Metrics"
    label: "# Active Users Who Started Address Search"
    description: "# daily users who viewed address search screen at least once"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_seen_address_search: "yes"]
  }

  measure: cnt_is_hub_updated_with_cart {
    group_label: "# Active User Metrics"
    label: "# Active Users With Address Updated With Cart"
    description: "# daily users who updated their address after having added at least one product to their cart"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_hub_updated_with_cart: "yes"]
  }

  measure: cnt_is_addres_tappped_at_checkout {
    group_label: "# Active User Metrics"
    label: "# Active Users With Address Tapped At Checkout"
    description: "# daily users who tapped on the delivery address on the checkout screen"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_addres_tappped_at_checkout: "yes"]
  }

  ######## Daily Attributes ########

  dimension: is_selected_address_inside_delivery_area {
    group_label: "Location Dimensions"
    label: "Has Selected A Location Inside Delivery Area"
    description: "TRUE if user selected at least one address inside the delivery area and saw the address refinement screen"
    type: yesno
    sql: ${TABLE}.is_selected_address_inside_delivery_area;;
  }

  dimension: is_selected_address_outside_delivery_area {
    group_label: "Location Dimensions"
    label: "Has Seen Location outside Delivery Area"
    description: "TRUE if there was any locationPinPlaced outside of the delivery area, FALSE otherwise"
    type: yesno
    sql: ${TABLE}.is_selected_address_outside_delivery_area;;
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
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  set: detail {
    fields: [
      daily_user_uuid,
      event_date_at_date,
      is_selected_address_inside_delivery_area,
      is_selected_address_outside_delivery_area,
      is_skip_address_selection_onboarding,
      is_skip_waitlist,
      is_address_confirmed,
      is_waitlist_signup_selected
    ]
  }
}
