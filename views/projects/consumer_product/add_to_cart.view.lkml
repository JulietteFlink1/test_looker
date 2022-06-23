view: add_to_cart {
  derived_table: {
    persist_for: "1 hour"
    sql: WITH
        events AS ( -- ios all events
        SELECT
            tracks.anonymous_id
          , tracks.context_app_version
          , tracks.context_device_type
          , tracks.context_locale
          , tracks.event
          , tracks.event_text
          , tracks.id
          , cart.list_category
          , tracks.timestamp
          , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
          `flink-data-prod.flink_ios_production.tracks_view` tracks
        LEFT JOIN `flink-data-prod.flink_ios_production.product_added_to_cart_view` cart ON cart.id = tracks.id
        WHERE
          tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND tracks.event != "app_opened"
          AND tracks.event != "application_updated"
          AND tracks.event != "application_opened"
          AND NOT (LOWER(tracks.context_app_version) LIKE "%app-rating%"
           OR LOWER(tracks.context_app_version) LIKE "%debug%")
          AND NOT (LOWER(tracks.context_app_name) = "flink-staging"
           OR LOWER(tracks.context_app_name) = "flink-debug")
          AND (LOWER(tracks.context_traits_email) != "qa@goflink.com"
           OR tracks.context_traits_email is null)
          AND (tracks.context_traits_hub_slug NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
           OR tracks.context_traits_hub_slug is null)
    UNION ALL
        SELECT -- android all events
            tracks.anonymous_id
          , tracks.context_app_version
          , tracks.context_device_type
          , tracks.context_locale
          , tracks.event
          , tracks.event_text
          , tracks.id
          , cart.list_category
          , tracks.timestamp
          , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
          `flink-data-prod.flink_android_production.tracks_view` tracks
        LEFT JOIN `flink-data-prod.flink_android_production.product_added_to_cart_view` cart ON cart.id = tracks.id
        WHERE
          tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND tracks.event != "app_opened"
          AND tracks.event != "application_updated"
          AND tracks.event != "application_opened"
          AND NOT (LOWER(tracks.context_app_version) LIKE "%app-rating%"
           OR LOWER(tracks.context_app_version) LIKE "%debug%")
          AND NOT (LOWER(tracks.context_app_name) = "flink-staging"
           OR LOWER(tracks.context_app_name) = "flink-debug")
          AND (LOWER(tracks.context_traits_email) != "qa@goflink.com"
           OR tracks.context_traits_email is null)
          AND (tracks.context_traits_hub_slug NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
           OR tracks.context_traits_hub_slug is null)
          )

     , tracking_sessions AS ( -- defining 30 min sessions
            SELECT
              anonymous_id
            , anonymous_id || '-' || ROW_NUMBER() OVER(PARTITION BY anonymous_id ORDER BY timestamp ASC) AS session_id
            , ROW_NUMBER() OVER(PARTITION BY anonymous_id ORDER BY timestamp ASC) AS session_number
            , timestamp AS session_start_at
            , LEAD(timestamp) OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS next_session_start_at
            , context_app_version
            , context_device_type
            , context_locale
            FROM
              events
            WHERE
              (events.inactivity_time > 30
                OR events.inactivity_time IS NULL)
            ORDER BY
              1)

    , hub_data_union AS ( -- ios & android pulling address_confirmed and order_placed for hub_data and delivery_eta
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.hub_city,
              event.hub_code AS hub_encoded,
              hub.slug as hub_code,
              CAST(event.delivery_eta as INT) as delivery_eta,
              CAST(NULL AS BOOL) AS has_selected_address
        FROM `flink-data-prod.flink_ios_production.address_confirmed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.hub_city,
              event.hub_code AS hub_encoded,
              hub.slug as hub_code,
              event.delivery_eta,
              CAST(NULL AS BOOL) AS has_selected_address
        FROM `flink-data-prod.flink_android_production.address_confirmed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.hub_city,
              event.hub_code AS hub_encoded,
              hub.slug as hub_code,
              CAST(event.delivery_eta as INT) as delivery_eta,
              CAST(NULL AS BOOL) AS has_selected_address
        FROM `flink-data-prod.flink_ios_production.order_placed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.hub_city,
              event.hub_code AS hub_encoded,
              hub.slug as hub_code,
              delivery_eta,
              CAST(NULL AS BOOL) AS has_selected_address
        FROM `flink-data-prod.flink_android_production.order_placed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.city AS hub_city,
              NULL AS hub_encoded,
              hub_slug as hub_code,
              NULL AS delivery_eta,
              event.has_selected_address
        FROM `flink-data-prod.flink_android_production.app_opened_view` event
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.city AS hub_city,
              NULL AS hub_encoded,
              hub_slug as hub_code,
              NULL AS delivery_eta,
              event.has_selected_address
        FROM `flink-data-prod.flink_ios_production.app_opened_view` event
    )

    , has_address_fill AS (
      SELECT
        hd.event,
        hd.anonymous_id,
        hd.timestamp,
        hd.hub_city,
        hd.hub_code,
        COALESCE(hs.country_iso, hc.country_iso) as hub_country,
        hd.delivery_eta,
        LAST_VALUE(hd.has_selected_address IGNORE NULLS) OVER
            (PARTITION BY anonymous_id ORDER BY timestamp RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS has_selected_address
      FROM hub_data_union hd
      LEFT JOIN (
                SELECT DISTINCT country_iso, city
                FROM `flink-data-prod.google_sheets.hub_metadata`
                 ) hc
            ON hd.hub_city = hc.city
      LEFT JOIN (
          SELECT DISTINCT country_iso, hub_code
          FROM `flink-data-prod.google_sheets.hub_metadata`
         ) hs
      ON LOWER(hd.hub_code) = LOWER(hs.hub_code)

      WHERE (hs.hub_code NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
          OR hs.hub_code is null)
    )

    , hub_data AS (
    SELECT  ha.event,
            ha.anonymous_id,
            ha.timestamp,
            ha.hub_city,
            ha.hub_country,
            ha.hub_code,
            ha.delivery_eta,
            ha.has_selected_address,
            CASE
                WHEN ha.has_selected_address THEN true
                WHEN ha.event="address_confirmed" THEN true
                WHEN ha.event="order_placed" THEN true
                ELSE false
            END AS has_address,
            ROW_NUMBER() OVER(PARTITION BY ha.event, ha.anonymous_id, ha.timestamp ORDER BY ha.timestamp DESC)       AS row_n
    FROM has_address_fill ha
    )

    , sessions_final AS ( -- merging sessions with hub_data
    SELECT
           anonymous_id
         , context_app_version
         , context_device_type
         , context_locale
         , session_id
         , session_number
         , session_start_at
         , next_session_start_at
         , CASE WHEN hub_city LIKE 'Ludwigshafen%' THEN 'DE'
            WHEN hub_city LIKE 'Mülheim%' THEN 'DE'
            WHEN hub_city LIKE 'Mulheim%' THEN 'DE'
            ELSE hub_country END AS hub_country
         , hub_city
         , hub_code
         , delivery_eta
         , has_selected_address
         , has_address
    FROM (
        SELECT
              ts.anonymous_id
            , ts.context_app_version
            , ts.context_device_type
            , ts.context_locale
            , ts.session_id
            , ts.session_number
            , ts.session_start_at
            , ts.next_session_start_at
            , hd.timestamp as hd_timestamp
            , hd.hub_code
            , hd.hub_country
            , hd.hub_city
            , hd.delivery_eta
            , hd.has_selected_address
            , hd.has_address
            , DENSE_RANK() OVER (PARTITION BY ts.anonymous_id, ts.session_id ORDER BY hd.timestamp DESC) as rank_hd -- ranks all data_hub related events // filter set = 1 to get 'latest' timestamp
        FROM tracking_sessions ts
                LEFT JOIN (
                    SELECT
                        anonymous_id
                      , timestamp
                      , hub_code
                      , hub_city
                      , hub_country
                      , delivery_eta
                      , event
                      , has_selected_address
                      , has_address
                    FROM hub_data
                ) hd
                ON ts.anonymous_id = hd.anonymous_id
                AND ( hd.timestamp < ts.next_session_start_at OR ts.next_session_start_at IS NULL)
            )
    WHERE
        rank_hd = 1  -- filter set = 1 to get 'latest' timestamp
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13, 14
    )
    , add_to_cart AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
             , countif(e.list_category = 'category') as list_category
             , countif(e.list_category = 'favourites') as list_favourites
             , countif(e.list_category = 'last_bought') as list_last_bought
             , countif(e.list_category IN ('order_details', 'pdp')) as list_pdp
             , countif(e.list_category = 'search') as list_search
             , countif(e.list_category = 'swimlane') as list_swimlane
             , countif(e.list_category IN ('cart', 'checkout')) as list_cart
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'product_added_to_cart'
        GROUP BY 1,2
    )

    , home_viewed AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'home_viewed'
        GROUP BY 1,2
    )

    , more_categories AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'categories_show_more_selected'
        GROUP BY 1,2
    )

    , category_selected AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'category_selected'
        GROUP BY 1,2
    )

    , first_order AS (
        SELECT
               e.anonymous_id
             , MIN(e.timestamp) as first_order_timestamp
        FROM events e
        WHERE e.event = 'order_placed'
        GROUP BY 1
    )

    , order_placed AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'order_placed'
        GROUP BY 1,2
    )

    SELECT
          sf.anonymous_id
        , sf.context_app_version
        , sf.context_device_type
        , sf.context_locale
        , sf.session_id
        , sf.session_number
        , datetime(sf.session_start_at, 'UTC') AS session_start_at
        , datetime(sf.next_session_start_at, 'UTC') AS next_session_start_at
        , sf.hub_code
        , sf.hub_country
        , sf.hub_city
        , sf.delivery_eta
      --  , sf.has_selected_address
        , sf.has_address
        , atc.list_category as add_to_cart_category
        , atc.list_favourites as add_to_cart_favourites
        , atc.list_last_bought as add_to_cart_last_bought
        , atc.list_pdp as add_to_cart_pdp
        , atc.list_search as add_to_cart_search
        , atc.list_swimlane as add_to_cart_swimlane
        , atc.list_cart as add_to_cart_cart
        , atc.event_count as add_to_cart
        , hv.event_count as home_viewed
        , cv.event_count as more_categories
        , cs.event_count as category_selected
        , op.event_count as order_placed
        , CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM sessions_final sf
        LEFT JOIN add_to_cart atc ON sf.session_id = atc.session_id
        LEFT JOIN home_viewed hv ON sf.session_id = hv.session_id
        LEFT JOIN more_categories cv ON sf.session_id = cv.session_id
        LEFT JOIN category_selected cs ON sf.session_id = cs.session_id
        LEFT JOIN order_placed op ON sf.session_id = op.session_id
        LEFT JOIN first_order fo ON sf.anonymous_id = fo.anonymous_id
 ;;
  }

  #### DIMENSIONS ####

  ## Dates / Timestamps ##

  dimension_group: session_start_at {
    group_label: "Date Dimensions"
    type: time
    datatype: datetime
    timeframes: [
      hour,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.session_start_at ;;
  }
  dimension: session_start_date_granularity {
    hidden: yes
    group_label: "Date Dimensions"
    label: "Session Start Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    sql:
    {% if timeframe_picker._parameter_value == 'Hour' %}
      ${session_start_at_hour}
    {% elsif timeframe_picker._parameter_value == 'Day' %}
      ${session_start_at_date}
    {% elsif timeframe_picker._parameter_value == 'Week' %}
      ${session_start_at_week}
    {% elsif timeframe_picker._parameter_value == 'Month' %}
      ${session_start_at_month}
    {% endif %};;
  }
  parameter: timeframe_picker {
    group_label: "Date Dimensions"
    label: "Session Start Date Granularity"
    type: unquoted
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  ## IDs ##

  dimension: anonymous_id {
    group_label: "IDs"
    description: "User ID set by Segment"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: session_id {
    group_label: "IDs"
    description: "Session ID defined by business logic"
    type: string
    sql: ${TABLE}.session_id ;;
  }
  dimension: session_number {
    type: number
    sql: ${TABLE}.session_number ;;
    hidden: yes
  }

  ### Geo Dimensions ###

  dimension: hub_code {
    group_label: "Geo Dimensions"
    description: "Hub code"
    type: string
    sql: ${TABLE}.hub_code ;;
  }
  dimension: hub_country {
    group_label: "Geo Dimensions"
    label: "Country"
    description: "Country - whole name"
    type: string
    sql: ${TABLE}.hub_country ;;
  }
  dimension: hub_city {
    group_label: "Geo Dimensions"
    label: "City"
    description: "City of the hub"
    type: string
    sql: ${TABLE}.hub_city ;;
  }
  dimension: delivery_pdt {
    group_label: "Geo Dimensions"
    label: "Delivery PDT Minutes"
    description: "Delivery PDT (Predictive Time Delivery)"
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }
  dimension: country {
    group_label: "Geo Dimensions"
    label: "Country ISO"
    description: "ISO country code"
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

  ## Device Dimensions ##

  dimension: context_app_version {
    group_label: "Device Dimensions"
    label: "App Version"
    description: "Version of the app release"
    type: string
    sql: ${TABLE}.context_app_version ;;
  }
  dimension: context_device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "Type of the device: iOS or Android"
    type: string
    sql: ${TABLE}.context_device_type ;;
  }
  dimension: full_app_version {
    group_label: "Device Dimensions"
    label: "Full App Version"
    description: "Device type & App version"
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }
  dimension: context_locale {
    group_label: "Device Dimensions"
    label: "Locale"
    type: string
    sql: ${TABLE}.context_locale ;;
    hidden: yes
  }

## Generic Dimensions ##

  # dimension: list_category {
  #   group_label: "Generic Dimensions"
  #   label: "Product Placement"
  #   description: "Set of 6 static placements of the product"
  #   type: string
  #   sql: ${TABLE}.list_category ;;
  # }
  dimension: has_ordered {
    group_label: "Generic Dimensions"
    label: "Is Session with Order Placed"
    description: "Session with placed order"
    type: yesno
    sql: ${TABLE}.has_ordered ;;
  }
  dimension: returning_customer {
    group_label: "Generic Dimensions"
    label: "Is Returning Customer"
    description: "BOOLEAN if a user is returning customer"
    type: yesno
    sql: ${has_ordered} ;;
  }
  dimension: is_first_session {
    group_label: "Generic Dimensions"
    label: "Is First Session"
    description: "BOOLEAN if the session is the first session of a user"
    type: yesno
    sql: ${TABLE}.session_number=1 ;;
  }
  dimension: hub_unknown {
    group_label: "Generic Dimensions"
    type: yesno
    sql: ${hub_code} IS NULL ;;
  }
  dimension: has_address {
    group_label: "Generic Dimensions"
    label: "Is Session with Anddress Confirmed"
    description: "Sessions with confirmed address"
    type: yesno
    sql: ${TABLE}.has_address ;;
  }

  ## Dimensions relevant to metrics only, all hidden to end users ##

  dimension: add_to_cart {
    type: number
    sql: ${TABLE}.add_to_cart ;;
    hidden: yes
  }
  dimension: home_viewed {
    type: number
    sql: ${TABLE}.home_viewed ;;
    hidden: yes
  }
  dimension: more_categories {
    type: number
    sql: ${TABLE}.more_categories ;;
    hidden: yes
  }
  dimension: category_selected {
    type: number
    sql: ${TABLE}.category_selected ;;
    hidden: yes
  }
  dimension: order_placed {
    type: number
    sql: ${TABLE}.order_placed ;;
    hidden: yes
  }

## Product Placements ##

  dimension: add_to_cart_category {
    type: number
    sql: ${TABLE}.add_to_cart_category;;
    hidden: yes
  }
  dimension: add_to_cart_favourites {
    type: number
    sql: ${TABLE}.add_to_cart_favourites ;;
    hidden: yes
  }
  dimension: add_to_cart_last_bought {
    type: number
    sql: ${TABLE}.add_to_cart_last_bought ;;
    hidden: yes
  }
  dimension: add_to_cart_pdp {
    type: number
    sql: ${TABLE}.add_to_cart_pdp ;;
    hidden: yes
  }
  dimension: add_to_cart_search {
    type: number
    sql: ${TABLE}.add_to_cart_search ;;
    hidden: yes
  }
  dimension: add_to_cart_swimlane {
    type: number
    sql: ${TABLE}.add_to_cart_swimlane ;;
    hidden: yes
  }
  dimension: add_to_cart_cart {
    type: number
    sql: ${TABLE}.add_to_cart_cart ;;
    hidden: yes
  }

#### MEASURES ####

#### product placement on a sessions level ####

  measure: cnt_cart_category{
    group_label: "Product Placement - Sessions"
    label: "# Add to cart Sessions - Category"
    description: "Number of sessions with at least one add-to-cart event from Category placement"
    type: count
    filters: [add_to_cart_category: ">0"]
  }
  measure: cnt_cart_favourites{
    group_label: "Product Placement - Sessions"
    label: "# Add to cart Sessions - Favourites"
    description: "Number of sessions with at least one add-to-cart event from Favourites placement"
    type: count
    filters: [add_to_cart_favourites: ">0"]
  }
  measure: cnt_cart_last_bought {
    group_label: "Product Placement - Sessions"
    label: "# Add to cart Sessions - Last Bought"
    description: "Number of sessions with at least one add-to-cart event from Last Bought placement"
    type: count
    filters: [add_to_cart_last_bought: ">0"]
  }
  measure: cnt_cart_pdp {
    group_label: "Product Placement - Sessions"
    label: "# Add to cart Sessions - PDP"
    description: "Number of sessions with  at least one add-to-cart event from PDP placement"
    type: count
    filters: [add_to_cart_pdp: ">0"]
  }
  measure: cnt_cart_search{
    group_label: "Product Placement - Sessions"
    label: "# Add to cart Sessions - Search"
    description: "Number of sessions with at least one add-to-cart event from Search placement"
    type: count
    filters: [add_to_cart_search: ">0"]
  }
  measure: cnt_cart_swimlane{
    group_label: "Product Placement - Sessions"
    label: "# Add to cart Sessions - Swimlane"
    description: "Number of sessions with at least one add-to-cart event from Swimlane placement"
    type: count
    filters: [add_to_cart_swimlane: ">0"]
  }
  measure: cnt_cart_cart{
    group_label: "Product Placement - Sessions"
    label: "# Add to cart Sessions - Cart"
    description: "Number of sessions with at least one add-to-cart event from Cart placement"
    type: count
    filters: [add_to_cart_cart: ">0"]
  }

#### product placement on a event level ####

  measure: sum_add_to_cart_cart {
    group_label: "Product Placement - Events"
    label: "# Add to Cart Events - Cart"
    description: "Number of add-to-cart events from cart"
    type: sum
    sql: ${add_to_cart_cart} ;;
  }
  measure: sum_add_to_cart_category {
    group_label: "Product Placement - Events"
    label: "# Add to Cart Events - Category"
    description: "Number of add-to-cart events from category"
    type: sum
    sql: ${add_to_cart_category} ;;
  }
  measure: sum_add_to_cart_favourites {
    group_label: "Product Placement - Events"
    label: "# Add to Cart Events - Favourites"
    description: "Number of add-to-cart events from favourites"
    type: sum
    sql: ${add_to_cart_favourites} ;;
  }
  measure: sum_add_to_cart_last_bought {
    group_label: "Product Placement - Events"
    label: "# Add to Cart Events - Last Bought"
    description: "Number of add-to-cart events from last bought"
    type: sum
    sql: ${add_to_cart_last_bought} ;;
  }
  measure: sum_add_to_cart_pdp {
    group_label: "Product Placement - Events"
    label: "# Add to Cart Events - PDP"
    description: "Number of add-to-cart events from PDP"
    type: sum
    sql: ${add_to_cart_pdp} ;;
  }
  measure: sum_add_to_cart_search {
    group_label: "Product Placement - Events"
    label: "# Add to Cart Events - Search"
    description: "Number of add-to-cart events from search"
    type: sum
    sql: ${add_to_cart_search} ;;
  }
  measure: sum_add_to_cart_swimlane {
    group_label: "Product Placement - Events"
    label: "# Add to Cart Events - Swimlane"
    description: "Number of add-to-cart events from swimlane"
    type: sum
    sql: ${add_to_cart_swimlane} ;;
  }

  #### Other Metrics ####

  measure: cnt_unique_anonymousid {
    group_label: "Basic Counts"
    label: "# Unique Users"
    description: "Number of unique users identified via anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }
  measure: count {
    group_label: "Basic Counts"
    label: "# Unique Sessions"
    description: "Number of unique sessions"
    type: count
    drill_fields: [detail*]
  }
  measure: cnt_add_to_cart {
    group_label: "Basic Counts"
    label: "# Sessions with Add to cart"
    description: "Number of sessions with at least one add-to-cart event happened"
    type: count
    filters: [add_to_cart: "NOT NULL"]
  }
  measure: cnt_home_viewed {
    group_label: "Basic Counts"
    label: "# Session with Home Viewed"
    description: "Number of sessions in which at least one Home Viewed event happened"
    type: count
    filters: [home_viewed: "NOT NULL"]
  }
  measure: cnt_has_address {
    group_label: "Basic Counts"
    label: "# Session with Address Confirmed"
    description: "# sessions in which the user had an address (selected in previous session or current)"
    type: count
    filters: [has_address: "yes"]
  }
  measure: cnt_more_categories {
    group_label: "Basic Counts"
    label: "# Session with More Categories event"
    description: "Number of sessions in which at least one More Categories event happened"
    type: count
    filters: [more_categories: "NOT NULL"]
  }
  measure: cnt_category_selected {
    group_label: "Basic Counts"
    label: "# Sessions with Category Selected event"
    description: "Number of sessions in which at least one Category Selected event happened"
    type: count
    filters: [category_selected: "NOT NULL"]
  }
  measure: cnt_purchase {
    group_label: "Basic Counts"
    label: "# Session with Order Placed event"
    description: "Number of sessions in which at least one Order Placed event happened"
    type: count
    filters: [order_placed: "NOT NULL"]
  }

  #### SUM of events ####

  measure: sum_add_to_cart {
    group_label: "Basic Sums"
    label: "# Add to Cart Events"
    description: "Number of all add-to-cart events"
    type: sum
    sql: ${add_to_cart} ;;
  }
  measure: sum_category_selected {
    group_label: "Basic Sums"
    label: "# Category Selected Events"
    description: "Number of category_selected events"
    type: sum
    sql: ${category_selected} ;;
  }
  measure: sum_purchases {
    group_label: "Basic Sums"
    label: "# Order Placed Events"
    description: "Number of order_placed events"
    type: sum
    sql: ${order_placed} ;;
  }
  measure: sum_home_viewed {
    group_label: "Basic Sums"
    label: "# Home Viewed Events"
    description: "Number of home_viewed events"
    type: sum
    sql: ${home_viewed} ;;
  }
  measure: sum_more_categories{
    group_label: "Basic Sums"
    label: "# More Categories Events"
    description: "Number of more_categories events"
    type: sum
    sql: ${more_categories} ;;
  }

  ## COMVERSIONS ##

  measure: overall_conversion_rate {
    type: number
    group_label: "Conversions"
    label: "CVR"
    description: "Number of sessions in which an Order Placed event happened, compared to the total number of Session Started"
    value_format_name: percent_1
    sql: ${cnt_purchase}/NULLIF(${count},0) ;;
  }

  measure: mcvr2 {
    type: number
    group_label: "Conversions"
    label: "mCVR2"
    description: "# sessions in which there was a Product Added To Cart, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_add_to_cart}/NULLIF(${cnt_has_address},0) ;;
  }

  measure: mcvr2_cart{
    type: number
    group_label: "Conversions"
    label: "mCVR2 Cart"
    description: "# sessions in which there was a Product Added To Cart from Cart, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_cart_cart}/NULLIF(${cnt_has_address},0) ;;
  }
  measure: mcvr2_favourites {
    type: number
    group_label: "Conversions"
    label: "mCVR2 Favourites "
    description: "# sessions in which there was a Product Added To Cart from Favourites, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_cart_favourites}/NULLIF(${cnt_has_address},0) ;;
  }
  measure: mcvr2_pdp {
    type: number
    group_label: "Conversions"
    label: "mCVR2 PDP"
    description: "# sessions in which there was a Product Added To Cart from PDP, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_cart_pdp}/NULLIF(${cnt_has_address},0) ;;
  }
  measure: mcvr2_last_bought {
    type: number
    group_label: "Conversions"
    label: "mCVR2 Last Bought"
    description: "# sessions in which there was a Product Added To Cart from Last Bought, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_cart_last_bought}/NULLIF(${cnt_has_address},0) ;;
  }
  measure: mcvr2_search {
    type: number
    group_label: "Conversions"
    label: "mCVR2 Search"
    description: "# sessions in which there was a Product Added To Cart from Search, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_cart_search}/NULLIF(${cnt_has_address},0) ;;
  }
  measure: mcvr2_swimlane {
    type: number
    group_label: "Conversions"
    label: "mCVR2 Swimlane"
    description: "# sessions in which there was a Product Added To Cart from Swimlane, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_cart_swimlane}/NULLIF(${cnt_has_address},0) ;;
  }
  measure: mcvr2_category {
    type: number
    group_label: "Conversions"
    label: "mCVR2 Category"
    description: "# sessions in which there was a Product Added To Cart from Category, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_cart_category}/NULLIF(${cnt_has_address},0) ;;
  }

  #########

  set: detail {
    fields: [
      anonymous_id,
      context_app_version,
      context_device_type,
      context_locale,
      session_id,
      session_number,
      session_start_at_date,
      hub_code,
      hub_country,
      hub_city,
      delivery_pdt,
      has_address,
      add_to_cart,
      home_viewed,
      more_categories,
      category_selected,
      order_placed,
      has_ordered
    ]
  }
}
