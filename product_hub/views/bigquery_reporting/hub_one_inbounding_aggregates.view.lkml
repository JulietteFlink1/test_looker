# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-12-21

view: hub_one_inbounding_aggregates {
  sql_table_name: `flink-data-prod.reporting.hub_one_inbounding_aggregates`
    ;;

  view_label: "1 Inbouding Aggregates"
  # This is a table from the reporting layer that aggregates data for inbounding process

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
    description: "Unique identifier generated by back-end when the inbound process is started (legacy inventory_movement_id)."
    sql: ${TABLE}.dropping_list_id ;;
  }

  # =========  Location Dimensions   =========

  dimension: country_iso {
    type: string
    group_label: "Location Dimensions"
    label: "Country ISO"
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
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
      month,
      week_of_year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension_group: list_preparation_started {
    type: time
    description: "Timestamp when the user starts the list preparation from inbounding process (state = list_preparation_started)."
    timeframes: [
      time,
      date,
      hour_of_day,
      day_of_week,
      week_of_year
    ]
    sql: ${TABLE}.list_preparation_started_at ;;
  }

  dimension_group: dropping_list_started {
    type: time
    description: "Timestamp when the user starts the dropping of the products on shelfs (state = dropping_list_started)."
    timeframes: [
      time,
      date,
      hour_of_day,
      day_of_week,
      week_of_year
    ]
    sql: ${TABLE}.dropping_list_started_at ;;
  }


  dimension_group: dropping_list_finished {
    type: time
    description: "Timestamp when the user finishes dropping the products on the shelfs (state = dropping_list_finished)."
    timeframes: [
      time,
      date,
      hour_of_day,
      day_of_week,
      week_of_year
    ]
    sql: ${TABLE}.dropping_list_finished_at ;;
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Number of products   =========

  measure: number_of_distinct_dropping_lists {
    group_label: "Total Metrics"
    description: "Number of distinct Dropping Lists"
    type: count_distinct
    sql: ${dropping_list_id} ;;
  }

  # =========  Number of products   =========

  measure: number_of_distinct_products_added_to_list {
    type: sum
    group_label: "Total Metrics"
    description: "Count of distinct products added to list (action = product_added_to_list)."
    sql: ${TABLE}.number_of_distinct_products_added_to_list ;;
  }

  measure: number_of_distinct_products_updated {
    type: sum
    group_label: "Total Metrics"
    description: "Count of distinct products updated from list (action = product_updated_quantity)."
    sql: ${TABLE}.number_of_distinct_products_updated ;;
  }

  measure: number_of_distinct_products_removed_from_list {
    type: sum
    group_label: "Total Metrics"
    description: "Count of distinct products removed from list (action = product_removed_from_list)."
    sql: ${TABLE}.number_of_distinct_products_removed_from_list ;;
  }

  measure: number_of_distinct_products_dropped {
    type: sum
    group_label: "Total Metrics"
    description: "Count of distinct products dropped (action = product_dropped)."
    sql: ${TABLE}.number_of_distinct_products_dropped ;;
  }

  # =========  Number of distinct products   =========

  measure: number_of_products_added_to_list {
    group_label: "Total Metrics"
    type: sum
    description: "Sum of quantity of products added to list (action = product_added_to_list)."
    sql: ${TABLE}.number_of_products_added_to_list ;;
  }

  measure: number_of_products_updated {
    group_label: "Total Metrics"
    type: sum
    description: "Sum of quantity of products updated from list (action = product_updated_quantity)."
    sql: ${TABLE}.number_of_products_updated ;;
  }

  measure: number_of_products_removed_from_list {
    group_label: "Total Metrics"
    type: sum
    description: "Sum of quantity of products removed from list (action = product_removed_from_list)."
    sql: ${TABLE}.number_of_products_removed_from_list ;;
  }

  measure: number_of_products_dropped {
    group_label: "Total Metrics"
    type: sum
    description: "Sum of quantity of products dropped (action = product_dropped)."
    sql: ${TABLE}.number_of_products_dropped ;;
  }

  # =========  Total Times   =========

  measure: sum_time_populating_list_hours {
    type: sum
    group_label: "Total Times"
    description: "Total time spent populating the cart during inbounding process in the specified unit (from list_preparation_started to dropping_list_started)"
    value_format: "0.00"
    sql: ${TABLE}.time_populating_list_hours ;;
  }

  measure: sum_time_populating_list_minutes {
    type: sum
    group_label: "Total Times"
    description: "Total time spent populating the cart during inbounding process in the specified unit (from list_preparation_started to dropping_list_started)"
    value_format: "0.00"
    sql: ${TABLE}.time_populating_list_minutes ;;
  }

  measure: sum_time_dropping_products_hours {
    type: sum
    group_label: "Total Times"
    description: "Total time spent dropping products on shelf during inbounding process in the specified unit (from dropping_list_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_dropping_products_hours ;;
  }

  measure: sum_time_dropping_products_minutes {
    type: sum
    group_label: "Total Times"
    description: "Total time spent dropping products on shelf during inbounding process in the specified unit (from dropping_list_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_dropping_products_minutes ;;
  }

  measure: sum_time_inbounding_hours {
    type: sum
    group_label: "Total Times"
    description: "Total duration of the inbounding process in the specified unit (from list_preparation_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_inbounding_hours ;;
  }

  measure: sum_time_inbounding_minutes {
    type: sum
    group_label: "Total Times"
    description: "Total duration of the inbounding process in the specified unit (from list_preparation_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_inbounding_minutes ;;
  }

  # =========  Average Times   =========

  measure: avg_time_populating_list_hours {
    type: average
    group_label: "Avg Times"
    description: "Total time spent populating the cart during inbounding process in the specified unit (from list_preparation_started to dropping_list_started)"
    value_format: "0.00"
    sql: ${TABLE}.time_populating_list_hours ;;
  }

  measure: avg_time_populating_list_minutes {
    type: average
    group_label: "Avg Times"
    description: "Total time spent populating the cart during inbounding process in the specified unit (from list_preparation_started to dropping_list_started)"
    value_format: "0.00"
    sql: ${TABLE}.time_populating_list_minutes ;;
  }

  measure: avg_time_dropping_products_hours {
    type: average
    group_label: "Avg Times"
    description: "Total time spent dropping products on shelf during inbounding process in the specified unit (from dropping_list_started to dropping_list_finished)."
    sql: ${TABLE}.time_dropping_products_hours ;;
  }

  measure: avg_time_dropping_products_minutes {
    type: average
    group_label: "Avg Times"
    description: "Total time spent dropping products on shelf during inbounding process in the specified unit (from dropping_list_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_dropping_products_minutes ;;
  }

  measure: avg_time_inbounding_hours {
    type: average
    group_label: "Avg Times"
    description: "Total duration of the inbounding process in the specified unit (from list_preparation_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_inbounding_hours ;;
  }

  measure: avg_time_inbounding_minutes {
    type: average
    group_label: "Avg Times"
    description: "Total duration of the inbounding process in the specified unit (from list_preparation_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_inbounding_minutes ;;
  }
}
