view: add_to_cart_rate_events {
  derived_table: {
    sql: with product_added_to_cart as (
        -- get list_category for add-to-cart event
        -- reason for this CTE and filtering data based on partition (reducing costs)
        select id, anonymous_id, list_category, context_app_version, context_device_type, timestamp
        from `flink-data-prod.flink_android_production.product_added_to_cart`
        where {% condition filter_event_date %} date(_partitiontime) {% endcondition %}
        and {% condition filter_event_date %} date(timestamp) {% endcondition %}
        QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY timestamp DESC) = 1

        union all
        select id, anonymous_id, list_category, context_app_version, context_device_type, timestamp
        from `flink-data-prod.flink_ios_production.product_added_to_cart`
        where {% condition filter_event_date %} date(_partitiontime) {% endcondition %}
        and {% condition filter_event_date %} date(timestamp) {% endcondition %}
        QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY timestamp DESC) = 1
        )

    select *
    from product_added_to_cart
    where (LOWER(context_app_version) not LIKE "%app-rating%"
                   or LOWER(context_app_version) not LIKE "%debug%"
                   or LOWER(context_app_version) not LIKE "%prerelease%"
                   or LOWER(context_app_version) not LIKE "%intercom%")
    ;;
    }

    filter: filter_event_date {
      label: "Filter: Event Date"
      type: date
      datatype: date
    }
    ##################  DIMENSIONS  ##################

    dimension: event_uuid {
      primary_key: yes
      type: string
      sql: ${TABLE}.id ;;
      hidden: yes
    }
    dimension: anonymous_id {
      group_label: "User Dimensions"
      type: string
      sql: ${TABLE}.anonymous_id ;;
    }
    dimension_group: event {
      group_label: "Date Dimensions"
      type: time
      datatype: timestamp
      timeframes: [
        date,
        day_of_week,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}.timestamp ;;
    }
    dimension: device_type {
      group_label: "Device Dimensions"
      description: "Type of the device: iOS or Android"
      type: string
      sql: ${TABLE}.context_device_type ;;
    }
    dimension: app_version {
      group_label: "Device Dimensions"
      description: "Version of the app released"
      type: string
      sql: ${TABLE}.context_app_version ;;
    }
    dimension: product_placement {
      group_label: "Event Dimensions"
      description: "Place where product was placed / shown wihtin the apps"
      type: string
      sql: ${TABLE}.list_category ;;
    }

    ##################  MEASURES  ##################

    measure: events {
      description: "Sum of all add-to-cart events."
      label: "# Events"
      type: count_distinct
      sql: ${event_uuid};;
    }
    measure: unique_users {
      description: "Sum of all add-to-cart events."
      label: "# Unique Users"
      type: count_distinct
      sql: ${anonymous_id} ;;
    }
    measure: events_from_cart {
      group_label: "Add-to-cart Events"
      description: "Sum of all add-to-cart events from cart."
      label: "#Events from Cart"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "cart"]
    }
    measure: events_from_last_bought {
      group_label: "Add-to-cart Events"
      description: "Sum of all add-to-cart events from last bought."
      label: "#Events from Last Bought"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "last_bought"]
    }
    measure: events_from_favourites {
      group_label: "Add-to-cart Events"
      description: "Sum of all add-to-cart events from favourites."
      label: "#Events from Favourites"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "favourites"]
    }
    measure: events_from_swimlane {
      group_label: "Add-to-cart Events"
      description: "Sum of all add-to-cart events from swimlanes."
      label: "#Events from Swimlane"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "swimlane"]
    }
    measure: events_from_search {
      group_label: "Add-to-cart Events"
      description: "Sum of all add-to-cart events from search."
      label: "#Events from Search"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "search"]
    }
    measure: events_from_category {
      group_label: "Add-to-cart Events"
      description: "Sum of all add-to-cart events from category pages."
      label: "#Events from Category"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "category"]
    }
    measure: events_from_pdp {
      group_label: "Add-to-cart Events"
      description: "Sum of all add-to-cart events."
      label: "#Events from PDP"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "pdp"]
    }
    measure: avg_event_per_user {#
      description: "AVG amount of add-to-cart events per unique user"
      label: "AVG add-to-cart events per User"
      type: number
      sql: ${events} / ${unique_users} ;;
      value_format: "#.##"
    }

    ### Add-to-cart rate measure ###
    measure: add_to_cart_rate_cart  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from cart (#add-to-cart-from-Cart / #total_add-to-cart"
      label: "From Cart"
      type: number
      sql: ${events_from_cart} / ${events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_category  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from category (#add-to-cart-from-Category / #total_add-to-cart"
      label: "From Category"
      type: number
      sql: ${events_from_category} / ${events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_last_bought  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from last bought (#add-to-cart-from-Last_bought / #total_add-to-cart"
      label: "From Last-Bought"
      type: number
      sql: ${events_from_last_bought} / ${events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_favourites  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from favourites (#add-to-cart-from-Favourites / #total_add-to-cart"
      label: "From Favourites"
      type: number
      sql: ${events_from_favourites} / ${events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_swimlane  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from cart (#add-to-cart-from-Swimlane / #total_add-to-cart"
      label: "From Swimlane"
      type: number
      sql: ${events_from_swimlane} / ${events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_search  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from cart (#add-to-cart-from-Search / #total_add-to-cart"
      label: "From Search"
      type: number
      sql: ${events_from_search} / ${events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_pdp  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from PDP (#add-to-cart-from-PDP / #total_add-to-cart"
      label: "From PDP"
      type: number
      sql: ${events_from_pdp} / ${events};;
      value_format_name: percent_2
    }
  }
