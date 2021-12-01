view: location_segment_sessions {
  derived_table: {
    persist_for: "1 hour"
    sql: WITH
    events AS (
      SELECT
        anonymous_id,
        event_name AS event,
        event_timestamp AS timestamp
      FROM `flink-data-prod.curated.app_session_events_full_load`
    )

  , tracking_sessions AS ( -- defining 30 min sessions
        SELECT
          anonymous_id,
          session_uuid AS session_id,
          is_new_user,
          session_start_at,
          session_end_at,
          app_version AS context_app_version,
          device_type AS context_device_type,
          country_iso AS hub_country,
          city AS hub_city,
          hub_code,
          delivery_pdt_minutes AS delivery_eta,
          is_session_with_address AS has_address
        FROM `flink-data-prod.curated.app_sessions_full_load`
    )

  , location_pin_placed_data AS (-- ios & android pulling location_pin_placed for user_area_available
      SELECT
            event.event,
            event.anonymous_id,
            event.timestamp,
            event.user_area_available
      FROM `flink-data-prod.flink_ios_production.location_pin_placed_view` event

      UNION ALL

      SELECT
            event.event,
            event.anonymous_id,
            event.timestamp,
            event.user_area_available
      FROM `flink-data-prod.flink_android_production.location_pin_placed_view` event
      -- WHERE event.location_selection_method = "locateMe" OR event.location_selection_method="addressSearch"
  )

  , address_resolution_failed_data AS (-- ios & android pulling address_resolution_failed data for is_inside_delivery_area
      SELECT
            event.event,
            event.anonymous_id,
            event.timestamp,
            event.is_inside_delivery_area
      FROM `flink-data-prod.flink_ios_production.address_resolution_failed_view` event
       -- WHERE event.location_selection_method = "locateMe" OR event.location_selection_method="addressSearch"

      UNION ALL

      SELECT
            event.event,
            event.anonymous_id,
            event.timestamp,
            event.is_inside_delivery_area
      FROM `flink-data-prod.flink_android_production.address_resolution_failed_view` event
      -- WHERE event.location_selection_method = "locateMe" OR event.location_selection_method="addressSearch"
  )

    , sessions_final AS ( -- merging sessions with location pin data
    SELECT
           anonymous_id
         , context_app_version
         , context_device_type
         , session_id
         , is_new_user
         , session_start_at
         , session_end_at
         , CASE WHEN hub_city LIKE 'Ludwigshafen%' THEN 'DE'
            WHEN hub_city LIKE 'Mülheim%' THEN 'DE'
            WHEN hub_city LIKE 'Mulheim%' THEN 'DE'
            ELSE hub_country END AS hub_country
         , hub_city
         , hub_code
         , delivery_eta
         , has_address
         , user_area_available
    FROM (
        SELECT
            ts.anonymous_id
          , ts.context_app_version
          , ts.context_device_type
          , ts.session_id
          , ts.is_new_user
          , ts.session_start_at
          , ts.session_end_at
          , ts.hub_code
          , ts.hub_country
          , ts.hub_city
          , ts.delivery_eta
          , ts.has_address
        , ld.user_area_available
        , DENSE_RANK() OVER (PARTITION BY ts.anonymous_id, ts.session_id ORDER BY ld.timestamp DESC) as order_ld --ranks all location_pin_placed events to surface FALSE before TRUE
    FROM tracking_sessions ts
            LEFT JOIN (
                SELECT
                    anonymous_id
                  , timestamp
                  , user_area_available
                FROM location_pin_placed_data
            ) ld
            ON ts.anonymous_id = ld.anonymous_id
            AND ld.timestamp >= ts.session_start_at
            AND ( ld.timestamp <= ts.session_end_at OR ts.session_end_at IS NULL)
        )
      WHERE order_ld = 1 -- filter set = 1 to get last pin value - to get false if there is a false value (set DENSE_RANK ORDER BY ld.user_area_available ASC)
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
  ),

event_counts AS (
       SELECT
           sf.anonymous_id
         , sf.session_id
         , SUM(CASE WHEN e.event="location_pin_placed" THEN 1 ELSE 0 END) as location_pin_placed_event_count
         , SUM(CASE WHEN e.event="address_skipped" THEN 1 ELSE 0 END) as address_skipped_event_count
         , SUM(CASE WHEN e.event="address_confirmed" THEN 1 ELSE 0 END) as address_confirmed_event_count
         , SUM(CASE WHEN e.event="waitlist_signup_selected" THEN 1 ELSE 0 END) as waitlist_signup_selected_event_count
         , SUM(CASE WHEN e.event="selection_browse_selected" THEN 1 ELSE 0 END) as selection_browse_selected_event_count
         , SUM(CASE WHEN e.event="home_viewed" THEN 1 ELSE 0 END) as home_viewed_event_count
         , SUM(CASE WHEN e.event="map_viewed" THEN 1 ELSE 0 END) as map_viewed_event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp <= sf.session_end_at OR session_end_at IS NULL)
        GROUP BY 1,2
    )

, address_resolution_failed_inside_area AS (
    SELECT
           sf.anonymous_id
         , sf.session_id
         , count(e.timestamp) as event_count
    FROM address_resolution_failed_data e
        LEFT JOIN sessions_final sf
        ON e.anonymous_id = sf.anonymous_id
        AND e.timestamp >= sf.session_start_at
        AND ( e.timestamp <= sf.session_end_at OR session_end_at IS NULL)
    WHERE e.is_inside_delivery_area=true
    GROUP BY 1,2
)

, address_resolution_failed_outside_area AS (
    SELECT
           sf.anonymous_id
         , sf.session_id
         , count(e.timestamp) as event_count
    FROM address_resolution_failed_data e
        LEFT JOIN sessions_final sf
        ON e.anonymous_id = sf.anonymous_id
        AND e.timestamp >= sf.session_start_at
        AND ( e.timestamp <= sf.session_end_at OR session_end_at IS NULL)
    WHERE e.is_inside_delivery_area=false
    GROUP BY 1,2
)
    SELECT
          sf.anonymous_id
        , sf.context_app_version
        , sf.context_device_type
        , sf.session_id
        , sf.is_new_user
        , datetime(sf.session_start_at,
          'UTC') AS session_start_at
        , datetime(sf.session_end_at,
          'UTC') AS session_end_at
        -- , sf.hub_id
        , sf.hub_code
        , sf.hub_country
        , sf.hub_city
        -- , sf.delivery_postcode
        , sf.delivery_eta
        , sf.user_area_available
        , sf.has_address
        , ec.location_pin_placed_event_count as location_pin_placed
        , ec.address_skipped_event_count as address_skipped
        , ec.address_confirmed_event_count as address_confirmed
        , ec.waitlist_signup_selected_event_count as waitlist_signup_selected
        , ec.selection_browse_selected_event_count as selection_browse
        , afi.event_count as address_resolution_failed_inside_area
        , afo.event_count as address_resolution_failed_outside_area
        , ec.map_viewed_event_count as map_viewed
        --, hu.event_count as hub_updated
        --, acac.event_count as address_change_at_checkout
        -- , ae.event_count as any_event
        --, CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM sessions_final sf
        LEFT JOIN event_counts  ec
        ON sf.session_id = ec.session_id
        LEFT JOIN address_resolution_failed_inside_area afi
        ON sf.session_id = afi.session_id
        LEFT JOIN address_resolution_failed_outside_area afo
        ON sf.session_id = afo.session_id
     ;;
  }

  ## I want to additional fields: one is the hub that appOpened detected, one is a flag that says whether appOpened changed the hub assignment since the last other event happened

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_unique_anonymousid {
    label: "Count Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  dimension: has_address_confirmed_event {
    type: yesno
    sql: ${TABLE}.address_confirmed >0 ;;
  }

  dimension: has_waitlist_signup_selected {
    type: yesno
    sql: ${TABLE}.waitlist_signup_selected >0;;
  }

  ######### IDs ##########
  dimension: anonymous_id {
    group_label: "IDs"
    description: "Anonymous ID generated by Segment as user identifier"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: session_id {
    group_label: "IDs"
    description: "Session ID based on user and session definition, primary key of this model"
    type: string
    primary_key: yes
    sql: ${TABLE}.session_id ;;
  }


  ########## Device attributes #########
  dimension: context_app_version {
    group_label: "Device Dimensions"
    label: "app_version"
    description: "App version used in the session"
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_type {
    group_label: "Device Dimensions"
    label: "device_type"
    description: "iOS or Android"
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: full_app_version {
    group_label: "Device Dimensions"
    description: "Device type and app version combined in one dimension"
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  ########## Location attributes #########
  dimension: hub_code {
    group_label: "Location Dimensions"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_country {
    group_label: "Location Dimensions"
    hidden: yes
    type: string
    sql: ${TABLE}.hub_country ;;
  }

  dimension: hub_city {
    group_label: "Location Dimensions"
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: country {
    group_label: "Location Dimensions"
    type: string
    case: {
      when: {
        sql: ${TABLE}.hub_country = "DE" ;;
        label: "Germany"
      }
      when: {
        sql: ${TABLE}.hub_country = "FR" ;;
        label: "France"
      }
      when: {
        sql: ${TABLE}.hub_country = "NL" ;;
        label: "Netherlands"
      }
      when: {
        sql: ${TABLE}.hub_country = "AT" ;;
        label: "Austria"
      }
      else: "Other / Unknown"
    }
  }

  ######## Session Counts ########
  ##### Unique count of events during a session. If multiple events are triggerred during a session, e.g 3 times view item, the event is only counted once.

  measure: cnt_has_address {
    group_label: "Session With Event Counts"
    label: "Has address count"
    description: "# sessions in which the user had an address (selected in previous session or current)"
    type: count
    filters: [has_address: "yes"]
  }

  measure: cnt_address_selected {
    group_label: "Session With Event Counts"
    label: "Count sessions address confirmed"
    description: "Number of sessions in which at least one Address Confirmed event happened"
    type: count
    filters: [address_confirmed: ">0"]
  }

  measure: cnt_location_pin_placed {
    group_label: "Session With Event Counts"
    label: "Count sessions location pin placed"
    description: "Number of sessions in which at least one Location Pin Placed event happened"
    type: count
    filters: [location_pin_placed: ">0"]
  }

# for unknown reasons didn't work to count NOT NULL on waitlist_signup_selected, that's why created boolean and counting those
  measure: cnt_has_waitlist_signup_selected {
    group_label: "Session With Event Counts"
    label: "Count sessions waitlist intent"
    description: "Number of sessions in which Waitlist Signup Selected happened"
    type: count
    filters: [has_waitlist_signup_selected: "yes"]
  }

  measure: cnt_available_area {
    group_label: "Session With Event Counts"
    label: "Count sessions with available area"
    description: "Number of sessions in which at least one Location Pin Placed event landed on an available area"
    type: count
    filters: [user_area_available: "true"]
  }

  measure: cnt_unavailable_area {
    group_label: "Session With Event Counts"
    label: "Count sessions with unavailable area"
    description: "Number of sessions in which at least one Location Pin Placed event landed on an unavailable area"
    type: count
    filters: [user_area_available: "false"]
  }

  measure: cnt_address_skipped_in_available_area {
    group_label: "Session With Event Counts"
    label: "Count sessions available area with skipped address"
    description: "Number of sessions in which Address Skipped was selected at least once and the user was in an available area and did not confirm any address"
    type: count
    filters: [user_area_available: "true", address_skipped: ">0", address_confirmed: "0"]
  }

  measure: cnt_address_confirmed_area_available {
    group_label: "Session With Event Counts"
    label: "Count sessions available area with address confirmed"
    description: "Number of sessions in which Address Confirm was selected at least once and the user was in an available area"
    type: count
    filters: [user_area_available: "true", address_confirmed: ">0", address_skipped: "0"]
  }

  measure: cnt_confirmed_and_skipped_area_available {
    group_label: "Session With Event Counts"
    label: "Count sessions available area with address confirmed and address skipped events"
    description: "Number of sessions in which user was in an available area and both confirmed and skipped address at least once"
    type: count
    filters: [user_area_available: "true", address_confirmed: ">0", address_skipped: ">0"]
  }

  measure: cnt_noaction_area_available {
    group_label: "Session With Event Counts"
    label: "Count sessions available area without confirmation or skipping action"
    description: "Number of sessions in which the user was in an available area but did not perform any address confirmation or skipping action"
    type: count
    filters: [user_area_available: "true", address_confirmed: "0", address_skipped: "0"]
  }

  measure: cnt_waitlist_area_unavailable {
    group_label: "Session With Event Counts"
    label: "Count sessions unavailable area with waitlist intent"
    description: "Number of sessions in which the user was in an unavailable area and selected join waitlist"
    type: count
    filters: [user_area_available: "false", waitlist_signup_selected: ">0", selection_browse: "0"]
  }

  measure: cnt_browse_area_unavailable {
    group_label: "Session With Event Counts"
    label: "Count sessions unavailable area with product browsing"
    description: "Number of sessions in which the user was in an unavailable area and selected browse products"
    type: count
    filters: [user_area_available: "false", selection_browse: ">0", waitlist_signup_selected: "0"]
  }

  measure: cnt_waitlist_and_browse_area_unavailable {
    group_label: "Session With Event Counts"
    label: "Count sessions unavailable area with waitlist intent and product browsing"
    description: "Number of sessions in which the user was in an unavailable area and selected join waitlist and selected browse products"
    type: count
    filters: [user_area_available: "false", selection_browse: ">0", waitlist_signup_selected: ">0"]
  }

  measure: cnt_noaction_area_unavailable {
    group_label: "Session With Event Counts"
    label: "Count sessions unavailable area without waitlist intent or browsing"
    description: "Number of sessions in which the user was in an unavailable area and did not have a waitlist joining intent or browsing selection action"
    type: count
    filters: [user_area_available: "false", waitlist_signup_selected: "0", selection_browse: "0"]
  }

  # NOTE: want to update this to also be able to specify whether it's failed within delivery area or not
  measure: cnt_address_resolution_failed_inside_area {
    group_label: "Session With Event Counts"
    label: "Cnt Address Unidentified Inside Delivery Area Sessions"
    description: "Number of sessions in which there was at least one unidentified address inside delivery area"
    type: count
    filters: [address_resolution_failed_inside_area: ">0"]
  }

  measure: cnt_address_resolution_failed_outside_area {
    group_label: "Session With Event Counts"
    label: "Cnt Address Unidentified Outside Delivery Area Sessions"
    description: "Number of sessions in which there was at least one unidentified address outside delivery area"
    type: count
    filters: [address_resolution_failed_outside_area: ">0"]
  }

  measure: cnt_address_skipped {
    group_label: "Session With Event Counts"
    label: "Cnt Address Skipped Sessions"
    description: "Number of sessions in which at least one Address Skipped event happened"
    type: count
    filters: [address_skipped: ">0"]
  }

  measure: cnt_map_viewed {
    group_label: "Session With Event Counts"
    label: "Cnt Map Viewed Sessions"
    description: "Number of sessions with Map Viewed"
    type: count
    filters: [map_viewed: ">0"]
  }

  ######## Event Counts Within Session ########
  dimension: address_skipped {
    group_label: "Event Counts"
    description: "Number of events within a single session. For example, the event might've occured twice for a certain session_id"
    type: number
    sql: ${TABLE}.address_skipped ;;
  }

  dimension: address_confirmed {
    group_label: "Event Counts"
    description: "Number of events within a single session. For example, the event might've occured twice for a certain session_id"
    type: number
    sql: ${TABLE}.address_confirmed ;;
  }

  dimension: waitlist_signup_selected {
    group_label: "Event Counts"
    description: "Number of events within a single session. For example, the event might've occured twice for a certain session_id"
    type: number
    sql: ${TABLE}.waitlist_signup_selected;;
  }

  dimension: selection_browse {
    group_label: "Event Counts"
    description: "Number of events within a single session. For example, the event might've occured twice for a certain session_id"
    type: number
    sql: ${TABLE}.selection_browse;;
  }

  dimension: location_pin_placed {
    group_label: "Event Counts"
    description: "Number of events within a single session. For example, the event might've occured twice for a certain session_id"
    type: number
    sql: ${TABLE}.location_pin_placed ;;
  }

  dimension: map_viewed {
    group_label: "Event Counts"
    description: "Number of events within a single session. For example, the event might've occured twice for a certain session_id"
    type: number
    sql: ${TABLE}.map_viewed ;;
  }

  ######## Session Attributes########

  dimension: has_address {
    group_label: "Session Dimensions"
    type: yesno
    sql: ${TABLE}.has_address ;;
  }

  dimension: has_ordered {
    group_label: "Session Dimensions"
    type: number
    sql: ${TABLE}.has_ordered ;;
  }

  dimension: is_new_user {
    group_label: "Session Dimensions"
    type: string
    hidden: yes
    sql: ${TABLE}.is_new_user ;;
  }

  dimension: is_first_session {
    group_label: "Session Dimensions"
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }

  dimension: hub_unknown {
    group_label: "Session Dimensions"
    type: yesno
    sql: ${hub_code} IS NULL ;;
  }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }

  dimension: user_area_available {
    type: string
    sql: CAST(${TABLE}.user_area_available AS STRING) ;;
    description: "FALSE if there is any locationPinPlaced event in the session for which user_area_available was FALSE, TRUE if not and NULL if there was no locationPinPlaced event)"
  }

  dimension: address_resolution_failed_inside_area {
    type: number
    sql: ${TABLE}.address_resolution_failed_inside_area ;;
    description: "Number of addressResolutionFailed events inside delivery area if there are any, NULL otherwise"
  }

  dimension: address_resolution_failed_outside_area {
    type: number
    sql: ${TABLE}.address_resolution_failed_outside_area ;;
    description: "Number of addressResolutionFailed events outside delivery area if there are any, NULL otherwise"
  }

  # dimension: hub_updated {
  #   type: number
  #   sql: ${TABLE}.hub_updated ;;
  # }

  # dimension: address_change_at_checkout {
  #   type: number
  #   sql: ${TABLE}.address_change_at_checkout ;;
  # }



  dimension_group: session_start_at {
    type: time
    datatype: datetime
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.session_start_at ;;
  }

  dimension_group: session_end_at {
    type: time
    datatype: datetime
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.session_end_at ;;
  }

  dimension: session_start_date_granularity {
    label: "Session Start Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    sql:
    {% if timeframe_picker._parameter_value == 'Day' %}
      ${session_start_at_date}
    {% elsif timeframe_picker._parameter_value == 'Week' %}
      ${session_start_at_week}
    {% elsif timeframe_picker._parameter_value == 'Month' %}
      ${session_start_at_month}
    {% endif %};;
  }

  parameter: timeframe_picker {
    label: "Session Start Date Granular"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }



  ## Measures based on other measures

  measure: mcvr1 {
    type: number
    description: "Number of sessions in which an Addres Confirmed event happened, compared to the total number of Session Started"
    value_format_name: percent_1
    sql: ${cnt_address_selected}/NULLIF(${count},0) ;;
  }

  set: detail {
    fields: [
      location_pin_placed,
      user_area_available,
      address_skipped,
      address_resolution_failed_inside_area,
      address_resolution_failed_outside_area,
      address_confirmed,
      waitlist_signup_selected,

      anonymous_id,
      context_app_version,
      context_device_type,
      session_id,
      is_new_user,
      session_start_at_date,
      session_end_at_date,
      hub_code,
      hub_country,
      hub_city,
      delivery_eta,
      has_address,
      has_ordered
    ]
  }
}
