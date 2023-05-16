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

  set: to_include_product {
    fields: [
      sum_time_inbounding_hours,
      sum_time_inbounding_minutes,
      avg_time_inbounding_minutes,
      sum_time_dropping_products_hours,
      sum_time_dropping_products_minutes,
      avg_time_dropping_products_minutes,
      sum_time_populating_list_hours,
      sum_time_populating_list_minutes,
      avg_time_populating_list_minutes
    ]
  }

  set: to_include_vendor_performance {
    fields: [
      quinyx_badge_number,
      event_date,
      event_week,
      sum_time_inbounding_hours,
      sum_time_inbounding_minutes,
      number_of_products_dropped,
      number_of_products_inbounded_per_minute,
      number_of_products_inbounded_per_hour
    ]

  }
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
    group_label: "Dropping List Attributes"
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

  # =========  Inbounding Properties   =========

  dimension: sscc {
    type: string
    group_label: "Dropping List Attributes"
    description: "Serial Shipping Container Code. A delivery is usually delivered on multiple rollies. This field relates to the ID of each rolli."
    sql: ${TABLE}.sscc ;;
  }

  dimension: inbounding_type {
    type: string
    group_label: "Dropping List Attributes"
    description: "Type of the inbounding selected in hub one app. Possible values for DE and FR: REWE or CARREFOUR (main supplier), delivered-today, not-part-of-a-delivery and for NL delivered-today and not-delivered-today."
    sql: ${TABLE}.inbounding_type ;;
  }

  dimension: distinct_products_added_to_list {
    type: number
    group_label: "Dropping List Attributes"
    description: "Count of distinct products added to list (action = product_added_to_list)."
    sql: ${TABLE}.number_of_distinct_products_added_to_list ;;
  }

  dimension: distinct_products_updated {
    type: number
    group_label: "Dropping List Attributes"
    description: "Count of distinct products updated from list (action = product_updated_quantity)."
    sql: ${TABLE}.number_of_distinct_products_updated ;;
  }

  dimension: distinct_products_removed_from_list {
    type: number
    group_label: "Dropping List Attributes"
    description: "Count of distinct products removed from list (action = product_removed_from_list)."
    sql: ${TABLE}.number_of_distinct_products_removed_from_list ;;
  }

  dimension: distinct_products_dropped {
    type: number
    group_label: "Dropping List Attributes"
    description: "Count of distinct products dropped (action = product_dropped)."
    sql: ${TABLE}.number_of_distinct_products_dropped ;;
  }

  dimension: is_less_than_x_skus {
    type: yesno
    label: "Is one product dropping_list"
    group_label: "Dropping List Attributes"
    description: "True when the dropping list has only one product_sku dropped."
    sql: if(${distinct_products_dropped}=1,true, false) ;;
  }

  dimension: is_quantity_modified {
    type: yesno
    label: "Is Quantity Modifed"
    group_label: "Dropping List Attributes"
    description: "True when at least one item was modified via verification process"
    sql: if(${TABLE}.is_quantity_modified > 0, true, false) ;;
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
    convert_tz: no
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
    convert_tz: no
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
    convert_tz: no
    sql: ${TABLE}.dropping_list_finished_at ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Number of dropping_lists   =========

  measure: number_of_distinct_dropping_lists {
    group_label: "Total Metrics"
    description: "Number of distinct Dropping Lists"
    type: count_distinct
    sql: ${dropping_list_id} ;;
  }

  # =========  Number of distinct products   =========

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

  # =========  Number of products   =========

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

  measure: number_of_distinct_products_verified {
    group_label: "Total Metrics"
    type: sum
    description: "Sum of quantity of distinct products veriied."
    sql: ${TABLE}.number_of_distinct_products_verified ;;
  }

  measure: number_of_products_quantity_modified {
    type: sum
    label: "Sum Quantity Modifed"
    group_label: "Total Metrics"
    description: "Sum of quantity of products modified"
    sql: ${TABLE}.is_quantity_modified  ;;
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

  measure: sum_time_list_verification_minutes {
    type: sum
    group_label: "Total Times"
    description: "Total duration of the list verification process in the specified unit (from list_verification_started to list_preparation_started)."
    value_format: "0.00"
    sql: ${TABLE}.time_inbounding_minutes ;;
  }

  # =========  Average Times   =========

  measure: avg_time_populating_list_hours {
    type: average
    group_label: "Avg Times"
    description: "Average time spent populating the cart during inbounding process in the specified unit (from list_preparation_started to dropping_list_started)"
    value_format: "0.00"
    sql: ${TABLE}.time_populating_list_hours ;;
  }

  measure: avg_time_populating_list_minutes {
    type: average
    group_label: "Avg Times"
    description: "Average time spent populating the cart during inbounding process in the specified unit (from list_preparation_started to dropping_list_started)"
    value_format: "0.00"
    sql: ${TABLE}.time_populating_list_minutes ;;
  }

  measure: avg_time_dropping_products_hours {
    type: average
    group_label: "Avg Times"
    description: "Average time spent dropping products on shelf during inbounding process in the specified unit (from dropping_list_started to dropping_list_finished)."
    sql: ${TABLE}.time_dropping_products_hours ;;
  }

  measure: avg_time_dropping_products_minutes {
    type: average
    group_label: "Avg Times"
    description: "Average time spent dropping products on shelf during inbounding process in the specified unit (from dropping_list_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_dropping_products_minutes ;;
  }

  measure: avg_time_inbounding_hours {
    type: average
    group_label: "Avg Times"
    description: "Average duration of the inbounding process in the specified unit (from list_preparation_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_inbounding_hours ;;
  }

  measure: avg_time_inbounding_minutes {
    type: average
    group_label: "Avg Times"
    description: "Average duration of the inbounding process in the specified unit (from list_preparation_started to dropping_list_finished)."
    value_format: "0.00"
    sql: ${TABLE}.time_inbounding_minutes ;;
  }

  measure: avg_time_list_verification_minutes {
    type: average
    group_label: "Avg Times"
    description: "Average duration of the list verification process in the specified unit (from list_verification_started to list_preparation_started)."
    value_format: "0.00"
    sql: ${TABLE}.time_inbounding_minutes ;;
  }

  measure: avg_time_list_verification_hours {
    type: average
    group_label: "Avg Times"
    description: "Average duration of the list verification process in the specified unit (from list_verification_started to list_preparation_started)."
    value_format: "0.00"
    sql: ${TABLE}.time_inbounding_hours ;;
  }

  # =========  Productivity   =========

  measure: number_of_products_inbounded_per_minute {
    label: "# Products Inbounded per Minute"
    group_label: "Productivity"
    description: "Number of products inbounded per minute."
    type: number

    sql: safe_divide(${number_of_products_dropped}, ${sum_time_inbounding_minutes})  ;;

    value_format_name: decimal_2
  }

  measure: number_of_products_inbounded_per_hour {
    label: "# Products Inbounded per Hour"
    group_label: "Productivity"
    description: "Number of products inbounded per hour."
    type: number

    sql: safe_divide(${number_of_products_dropped}, ${sum_time_inbounding_hours})  ;;

    value_format_name: decimal_2
  }

  # =========  List Verification Process   =========

  measure: sku_share_list_verification {
    label: "% Products Verified"
    group_label: "List Verification"
    description: "Share of products that went through list verification process"
    type: number

    sql: safe_divide(${number_of_distinct_products_verified}, ${number_of_products_dropped})  ;;

    value_format_name: percent_2
  }

  measure: sku_share_list_modified{
    label: "% Products Modified"
    group_label: "List Verification"
    description: "Share of products that were modified via list verification process."
    type: number

    sql: safe_divide(${number_of_products_quantity_modified}, ${number_of_distinct_products_verified})  ;;

    value_format_name: percent_2
  }
}
