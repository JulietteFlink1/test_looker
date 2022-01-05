view: product_events {
  derived_table: {
    persist_for: "5 hour"
    sql:
    with
      product_events as (
      select *
             , lead(event_name) over (partition by session_id, product_sku order by event_timestamp asc)               as next_event_product
             , lead(event_name) over (partition by session_id order by event_timestamp asc)                            as next_event_session
             , lead(event_timestamp) over (partition by session_id, product_sku order by event_timestamp asc)          as next_event_timestamp_product
             , lead(event_timestamp) over (partition by session_id order by event_timestamp asc)                       as next_event_timestamp_session
      from `flink-data-prod.curated.product_events`
      where 1=1
        and {% condition filter_event_date %} date(event_timestamp) {% endcondition %}
      )

      select *
      from product_events
      ;;
  }

  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      country,
      city,
      hub_code,
      device_type,
      event_name
    ]
  }

  filter: filter_event_date {
    label: "Filter: Event Date"
    type: date
    datatype: date
    default_value: "last 14 days"
  }

########### DIMENSIONS ###########
  ## IDs
  dimension: product_event_uuid {
    group_label: "IDs"
    type: string
    description: "Event ID defined in DWH as a primary key of this model"
    sql: ${TABLE}.product_event_uuid ;;
    primary_key: yes
    hidden: yes
  }
  dimension: session_id {
    group_label: "IDs"
    type: string
    description: "Session ID defined in DWH across all models"
    sql: ${TABLE}.session_id ;;
  }
  dimension: user_id  {
    group_label: "IDs"
    type: string
    description: "User ID populated upon registration"
    sql: ${TABLE}.user_id  ;;
    hidden: yes
  }
  dimension: anonymous_id {
    group_label: "IDs"
    type: string
    description: "Anonymou ID populated by Segment as a user identifier"
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: category_id {
    group_label: "IDs"
    type: string
    description: "Anonymou ID populated by Segment as a user identifier"
    sql: ${TABLE}.category_id ;;
    hidden: yes
  }
  dimension: subcategory_id {
    group_label: "IDs"
    type: string
    description: "Anonymou ID populated by Segment as a user identifier"
    sql: ${TABLE}.subcategory_id ;;
    hidden: yes
  }
  dimension: product_sku {
    group_label: "IDs"
    description: "SKU of a product"
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  ## Device attributes
  dimension: platform {
    group_label: "Device Dimensions"
    type: string
    description: "Platform where session appeared >> app"
    sql: ${TABLE}.platform ;;
    hidden: yes
  }
  dimension: device_type {
    group_label: "Device Dimensions"
    type: string
    description: "Device type is either iOS or Android"
    sql: ${TABLE}.device_type ;;
  }
  dimension: app_version {
    group_label: "Device Dimensions"
    type: string
    description: "App realease version"
    sql: ${TABLE}.app_version ;;
  }
  dimension: timezone {
    group_label: "Device Dimensions"
    type: string
    description: "Timezone in which session occured"
    sql: ${TABLE}.timezone ;;
    hidden: yes
  }

  ## GENERIC: Dates / Timestamp
  dimension_group: event_start_at {
    group_label: "Date Dimensions"
    label: "Event Start "
    type: time
    description: "Start of the session with varioud granulairty available"
    datatype: timestamp
    timeframes: [
      second,
      hour,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      year
    ]
    sql: ${TABLE}.event_timestamp ;;
  }

  dimension_group: events_duration_at {
    group_label: "Duration Dimensions"
    label: "Between 2 events"
    type: duration
    intervals: [second, minute]
    sql_start: ${TABLE}.event_timestamp;;
    sql_end: ${TABLE}.next_event_timestamp_session ;;
    description: "Duration between two events which fired"
  }
  dimension_group: events_product_duration_at {
    group_label: "Duration Dimensions"
    label: "Between 2 events | SKU"
    type: duration
    intervals: [second, minute]
    sql_start: ${TABLE}.event_timestamp;;
    sql_end: ${TABLE}.next_event_timestamp_product ;;
    description: "Duration between two events which fired partitioned by SKU"
  }

  ## Geo Dimenstions ##
  dimension: country_iso {
    group_label: "Geo Dimensions"
    description: "Country ISO associated to the event"
    type: string
    sql: ${TABLE}.country_iso  ;;
  }
  dimension: country {
    group_label: "Geo Dimensions"
    type: string
    case: {
      when: {
        sql: ${TABLE}.country_iso = "DE" ;;
        label: "Germany"
      }
      when: {
        sql: ${TABLE}.country_iso = "FR" ;;
        label: "France"
      }
      when: {
        sql: ${TABLE}.country_iso = "NL" ;;
        label: "Netherlands"
      }
      when: {
        sql: ${TABLE}.country_iso = "AT" ;;
        label: "Austria"
      }
      else: "Other / Unknown"
    }
  }
  dimension: hub_code {
    group_label: "Geo Dimensions"
    description: "Hub code associated to the event"
    type: string
    sql: ${TABLE}.hub_code ;;
  }
  dimension: city {
    group_label: "Geo Dimensions"
    description: "City associated to the event"
    type: yesno
    sql: ${TABLE}.city ;;
  }

  ## Event Dimenstions ##
  dimension: event_name {
    group_label: "Event Dimensions"
    description: "Name of an event fired"
    type: string
    sql: ${TABLE}.event_name ;;
  }
  dimension: next_event_name_product {
    group_label: "Event Dimensions"
    label: "Next Event Name - Product Partition"
    description: "Event name which followed the proceeding event partitioned by a product >> this ensure product level attribution."
    type: string
    sql: ${TABLE}.next_event_product;;
  }
  dimension: next_event_name_session {
    group_label: "Event Dimensions"
    label: "Next Event Name"
    description: "Event name which followed the proceeding event"
    type: string
    sql: ${TABLE}.next_event_session;;
  }
  dimension: origin_screen {
    group_label: "Event Dimensions"
    description: "Name of the screen where event originated"
    type: string
    sql: ${TABLE}.origin_screen ;;
  }
  dimension: category_name {
    group_label: "Event Dimensions"
    description: "Name of a category"
    type: string
    sql: ${TABLE}.category_name ;;
  }
  dimension: subcategory_name {
    group_label: "Event Dimensions"
    description: "Name of an event fired"
    type: string
    sql: ${TABLE}.subcategory_name ;;
  }
  dimension: product_name {
    group_label: "Event Dimensions"
    description: "Name of the product"
    type: string
    sql: ${TABLE}.product_name ;;
  }
  dimension: product_placement {
    group_label: "Event Dimensions"
    description: "Where product was placed, currently one of: home, swimlane, favourites, category, pdp, cart, search"
    type: string
    sql: ${TABLE}.product_placement ;;
  }
  dimension: pdp_origin {
    group_label: "Event Dimensions"
    description: "Placement where from PDP originated, currently one of: home, swimlane, favourites, category, pdp, cart, search"
    type: string
    sql: ${TABLE}.pdp_origin ;;
  }
  dimension: cart_value {
    group_label: "Event Dimensions"
    description: "Value of the cart"
    type: string
    sql: ${TABLE}.cart_value ;;
  }

### Custom dimensions
  dimension: event_start_date_granularity {
    group_label: "Date Dimensions"
    label: "Event Start Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    hidden:  yes
    sql:
    {% if timeframe_picker._parameter_value == 'Hour' %}
      ${event_start_at_hour}
    {% elsif timeframe_picker._parameter_value == 'Day' %}
      ${event_start_at_date}
    {% elsif timeframe_picker._parameter_value == 'Week' %}
      ${event_start_at_week}
    {% elsif timeframe_picker._parameter_value == 'Month' %}
      ${event_start_at_month}
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
    hidden:  yes
  }

  ################ Measures ################
  measure: count {
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "Count All Events"
    description: "Count of all events"
    type: count
    drill_fields: [detail*]
    hidden: no
  }
  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of unique users identified via anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }
  measure: cnt_unique_sessions {
    label: "# Unique Sessions"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of unique sessions based on sessions_uuid"
    hidden:  no
    type: count_distinct
    sql: ${session_id};;
    value_format_name: decimal_0
  }
  measure: cnt_unique_products {
    label: "# Unique Products"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of unique products."
    hidden:  no
    type: count_distinct
    sql: ${product_sku};;
    value_format_name: decimal_0
  }
  measure: cnt_all_products {
    label: "# All Products"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Total number of all products."
    hidden:  no
    drill_fields: [detail*]
    value_format_name: decimal_0
  }

  ### AVERAGES ###
  # measure: avg_pdp_products {
  #   label: "AVG #Products"
  #   group_label: "Averages"
  #   description: "Average amount of distinct products which were PDPed during a session."
  #   hidden: no
  #   type: average
  #   sql: ${cnt_all_products};;
  #   value_format_name: decimal_1
  # }
  measure: events_duration_seconds {
    label: "AVG #seconds between 2 events"
    group_label: "Averages"
    description: "Average amount of seconds it take for a user to generate 2 events during a session"
    type: average
    sql:  ${seconds_events_duration_at} ;;
    value_format_name: decimal_2
  }
  measure: events_duration_minutes {
    label: "AVG #minutes between 2 events"
    group_label: "Averages"
    description: "Average amount of minutes it take for a user to generate 2 events during a session"
    type: average
    sql:  ${minutes_events_duration_at} ;;
    value_format_name: decimal_2
  }
  measure: product_events_duration_seconds {
    label: "AVG #seconds between 2 events | SKU"
    group_label: "Averages"
    description: "Average amount of seconds it take for a user to generate 2 events attributed to the same SKU during a session"
    type: average
    sql:  ${seconds_events_product_duration_at} ;;
    value_format_name: decimal_2
  }
  measure: product_events_duration_minutes {
    label: "AVG #minutes between 2 events | SKU"
    group_label: "Averages"
    description: "Average amount of minutes it take for a user to generate 2 events attributed to the same SKU during a session"
    type: average
    sql:  ${minutes_events_product_duration_at} ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [
      session_id,
      user_id,
      anonymous_id,
      category_id,
      subcategory_id,
      product_placement,
      event_start_at_date,
      platform,
      device_type,
      app_version,
      timezone,
      country,
      city,
      hub_code,
      event_name,
      origin_screen,
      category_name,
      subcategory_name,
      country,
      country_iso
    ]
  }
}
