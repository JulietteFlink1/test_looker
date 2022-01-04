view: discovery_events {
  sql_table_name: `flink-data-dev.curated.discovery_events`
    ;;

  view_label: "* App Sessions *"
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

########### DIMENSIONS ###########
  ## IDs


  dimension: event_uuid {
    group_label: "IDs"
    type: string
    description: "Event ID defined in DWH as a primary key of this model"
    sql: ${TABLE}.event_uuid ;;
    primary_key: yes
    hidden: yes
  }
  dimension: session_id {
    group_label: "IDs"
    type: string
    description: "Session ID defined in DWH across all models"
    sql: ${TABLE}.session_uuid ;;
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
  # dimension_group: session_end_at {
  #   group_label: "Date Dimensions"
  #   type: time
  #   description: "End of the session with varioud granulairty available"
  #   datatype: datetime
  #   timeframes: [
  #     hour,
  #     hour_of_day,
  #     date,
  #     day_of_week,
  #     week,
  #     month,
  #     year
  #   ]
  #   sql: ${TABLE}.session_end_at ;;
  #   hidden: yes
  # }

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
    description: "Name of an event fired."
    type: string
    sql: ${TABLE}.event_name ;;
  }
  dimension: origin_screen {
    group_label: "Event Dimensions"
    description: "Name of the screen where event originated."
    type: string
    sql: ${TABLE}.origin_screen ;;
  }
  dimension: category_name {
    group_label: "Event Dimensions"
    description: "Name of a category."
    type: string
    sql: ${TABLE}.category_name ;;
  }
  dimension: subcategory_name {
    group_label: "Event Dimensions"
    description: "Name of an event fired."
    type: string
    sql: ${TABLE}.subcategory_name ;;
  }
  dimension: search_query {
    group_label: "Event Dimensions"
    description: "Query typed into a search bar"
    type: string
    sql: ${TABLE}.search_query ;;
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
  }


  ################ Measures ################

  measure: count {
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "Count All Events"
    description: "Count of all events"
    type: count
    drill_fields: [detail*]
    hidden: yes
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


#### Sessions with events ###
  # measure: cnt_has_address {
  #   group_label: "Sessions with Event Flags"
  #   label: "# Sessions with Confirmed Address"
  #   description: "# sessions in which the user had an address (selected in previous session or current)"
  #   type: count
  #   filters: [is_session_with_address: "yes"]
  # }


  ## Measures based on other measures

  # measure: mcvr2 {
  #   group_label: "Conversions"
  #   label: "mCVR2"
  #   type: number
  #   description: "# sessions in which there was a Product Added To Cart, compared to the number of sessions in which there was a Home Viewed"
  #   value_format_name: percent_1
  #   sql: ${cnt_add_to_cart}/NULLIF(${cnt_has_address},0) ;;
  # }



  set: detail {
    fields: [
      session_id,
      user_id,
      anonymous_id,
      category_id,
      subcategory_id,
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
      search_query,
      country,
      country_iso
    ]
  }
}
