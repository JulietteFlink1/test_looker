# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-12-29

view: merge_hub_one_legacy_inbounding {
  sql_table_name: `flink-data-dev.reporting.merge_hub_one_legacy_inbounding`
    ;;

  # view_label: "1 Inbouding Aggregates"
  # This table merges legacy and hub_one info coming from inbounding to avoid losing data until hub_one is fully rolled out.
  # When the adoption rate of hub one onbounding flow reaches 80/90 % this model will be deprecated.

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Sets          ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  IDs   =========

  dimension: table_uuid {
    type: string
    primary_key: yes
    hidden: yes
    description: "Concatenation of dropping_list_id, event_date and hub_code."
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: dropping_list_id {
    type: string
    hidden: yes
    description: "Unique identifier generated by back-end when the inbound process is started (legacy inventory_movement_id)."
    sql: ${TABLE}.dropping_list_id ;;
  }

  # =========  Location Dimensions   =========

  dimension: country_iso {
    type: string
    hidden: yes
    group_label: "Location Dimensions"
    label: "Country ISO"
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    hidden: yes
    group_label: "Location Dimensions"
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  # =========  Employee Attributes   =========

  dimension: quinyx_badge_number {
    type: string
    group_label: "Employee Attributes"
    description: "Employment ID that was initially generated by bambooHR. It is used to identify staff members from hub operations. To be able to map employees between different HR systems (after migrating to SAP), we still refered to it as quiniyx badge number. Quiniyx is used as our workforce management tool for rider ops."
    sql: ${TABLE}.quinyx_badge_number ;;
  }

  # =========  Dates and Timestamps   =========

  dimension_group: event {
    type: time
    description: "Date when an event was triggered."
    timeframes: [
      raw,
      date,
      week,
      day_of_week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension_group: list_preparation_started {
    type: time
    hidden: yes
    description: "Timestamp when the user starts the list preparation from inbounding process (state = list_preparation_started)."
    timeframes: [
      time,
      date,
      hour_of_day,
      day_of_week
    ]
    sql: ${TABLE}.list_preparation_started_at ;;
  }

  dimension_group: dropping_list_started {
    type: time
    hidden: yes
    description: "Timestamp when the user starts the dropping of the products on shelfs (state = dropping_list_started)."
    timeframes: [
      time,
      date,
      hour_of_day,
      day_of_week
    ]
    sql: ${TABLE}.dropping_list_started_at ;;
  }


  dimension_group: dropping_list_finished {
    type: time
    hidden: yes
    description: "Timestamp when the user finishes dropping the products on the shelfs (state = dropping_list_finished)."
    timeframes: [
      time,
      date,
      hour_of_day,
      day_of_week
    ]
    sql: ${TABLE}.dropping_list_finished_at ;;
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Number of products   =========

  measure: number_of_products_dropped {
    group_label: "Total Metrics"
    type: sum
    description: "Sum of quantity of products dropped (action = product_dropped)."
    sql: ${TABLE}.number_of_products_dropped ;;
  }

  # =========  Total Times   =========

  measure: sum_time_inbounding_hours {
    type: sum
    group_label: "Total Times"
    description: "Total duration of the inbounding process in the specified unit (from list_preparation_started to dropping_list_finished)."
    sql: ${TABLE}.time_inbounding_hours ;;
  }

  measure: sum_time_inbounding_minutes {
    type: sum
    group_label: "Total Times"
    description: "Total duration of the inbounding process in the specified unit (from list_preparation_started to dropping_list_finished)."
    sql: ${TABLE}.time_inbounding_minutes ;;
  }

  # =========  Other metrics   =========

  measure: number_of_products_inbounded_per_hour {
    label: "# Products Inbounded per Hour"
    description: "Number of products inbounded per hour"
    type: number

    sql: safe_divide(${number_of_products_dropped}, ${sum_time_inbounding_hours})  ;;

    value_format_name: decimal_2
  }

  measure: number_of_products_inbounded_per_minute {
    label: "# Products Inbounded per Minute"
    description: "Number of products inbounded per minute"
    type: number

    sql: safe_divide(${number_of_products_dropped}, ${sum_time_inbounding_minutes})  ;;

    value_format_name: decimal_2
  }

  measure: numnber_of_distinct_employees {
    label: "# Employees Inbounding"
    description: "Number of distinct employees involved in the inbounding process (based on unique quynix_badge_number)"

    type: count_distinct
    sql: ${quinyx_badge_number} ;;
    value_format_name: decimal_0
  }

}
