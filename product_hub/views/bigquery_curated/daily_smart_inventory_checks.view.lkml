# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-08-03


view: daily_smart_inventory_checks {
  sql_table_name: `flink-data-prod.curated.daily_smart_inventory_checks`
    ;;
  view_label: "1 Daily Smart Inventory Checks"

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
    hidden: no
    label: "Table UUID"
    description: "Check id from smart_inventory.checks"
    sql: ${TABLE}.table_uuid ;;
  }

  # =========  Location Attributes   =========

  dimension: country_iso {
    type: string
    group_label: "1 Location Dimensions"
    label: "Country ISO"
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    group_label: "1 Location Dimensions"
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  # =========  Employee Attributes   =========

  dimension: completed_by {
    type: string
    group_label: "3 Employee Attributes"
    label: "Employee ID"
    description: "Operator who performed the check."
    sql: ${TABLE}.completed_by ;;
    }

  # =========  Product Attributes  =========

  dimension: sku {
    type: string
    group_label: "2 Product Attributes"
    label: "Sku"
    description: "The sku of the product, as available in the backend."
    sql: ${TABLE}.sku ;;
  }

  dimension: shelf_number {
    type: string
    group_label: "2 Product Attributes"
    label: "Shelf Number"
    description: "Number of the shelf (from 0 to 86) where the SKU is stored in the hub followed by a letter which indicates the level within the shelf."
    sql: ${TABLE}.shelf_number ;;
  }

  # =========  Check Attributes   =========

  dimension: priority {
    type: number
    group_label: "4 Check Attributes"
    label: "Priority"
    description: "Define when the check needs to be performed during the day."
    sql: ${TABLE}.priority ;;
  }

  dimension: type {
    type: string
    group_label: "4 Check Attributes"
    label: "Type"
    description: "Reason why we checked the sku."
    sql: ${TABLE}.type ;;
  }

  dimension: status {
    type: string
    group_label: "4 Check Attributes"
    label: "Status"
    description: "Status of the check."
    sql: ${TABLE}.status ;;
  }

  dimension: is_postponed {
    type: yesno
    group_label: "4 Check Attributes"
    label: "Is Posponed"
    description: "Whether or not the check has been postponed."
    sql: ${TABLE}.is_postponed ;;
  }

  dimension: expected_quantity {
    type: number
    group_label: "4 Check Attributes"
    label: "Expected Quantity"
    description: "Number of items expected in stock for this sku."
    sql: ${TABLE}.expected_quantity ;;
  }

  dimension: is_finished {
    type: yesno
    group_label: "4 Check Attributes"
    label: "Is Finished"
    description: "Boolean to inform if a check has been finished."
    sql: if(${status} in ('done'),True,False) ;;
  }

  # =========  Check Timestamps   =========

  dimension_group: scheduled {
    type: time
    group_label: "5 Check Timestamps"
    label: "Scheduled"
    description: "Date when the sku is supposed to be checked."
    timeframes: [
      raw,
      date,
      week,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.scheduled_at ;;
  }

  dimension_group: created_at_timestamp {
    type: time
    group_label: "5 Check Timestamps"
    label: "Created At"
    description: "When the check has been uploaded in UTC."
    timeframes: [
      raw,
      date,
      time
    ]
    convert_tz: no
    datatype: datetime
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension_group: started_at_timestamp {
    type: time
    group_label: "5 Check Timestamps"
    label: "Started Counting At"
    description: "When the operator started counting the items."
    timeframes: [
      raw,
      time,
      date,
      hour,
      day_of_week
    ]
    convert_tz: no
    sql: ${TABLE}.started_at_timestamp ;;
  }

  dimension_group: finished_at_timestamp {
    type: time
    group_label: "5 Check Timestamps"
    label: "Finished Counting At"
    description: "When the operator finished counting the items."
    timeframes: [
      raw,
      time,
      date
    ]
    convert_tz: no
    sql: ${TABLE}.ended_at_timestamp ;;
  }

  # dimension: dim_started_to_finished_seconds {
  #   type: number
  #   group_label: "5 Check Timestamps"
  #   label: "Started to Finished seconds"
  #   description: "Diferrence in seconds between Started Counting and Finished Counting timestamps."
  #   value_format: "0"
  #   sql: DATETIME_DIFF(${finished_at_timestamp_raw}, ${started_at_timestamp_raw}, SECOND) ;;
  # }

  # =========  Correction Attributes  =========

  dimension: is_correction {
    type: yesno
    group_label: "6 Correction Attributes"
    label: "Is Correction"
    description: "Whether or not the operator entered a different quantity versus the expeted_quantity."
    sql: ${TABLE}.is_correction ;;
  }

  dimension_group: correction_done_at_timestamp {
    type: time
    group_label: "6 Correction Attributes"
    label: "Finished Correction At"
    description: "When the operator performed the correction."
    timeframes: [
      raw,
      time,
      date
    ]
    convert_tz: no
    sql: ${TABLE}.correction_done_at_timestamp ;;
  }
      # week,
      # month,
      # quarter,
      # year

  dimension: quantity_before_correction {
    type: number
    group_label: "6 Correction Attributes"
    label: "Quantity before Correction"
    description: "Should correspond to the expected quantity in case of correction."
    sql: ${TABLE}.quantity_before_correction ;;
  }

  dimension: quantity_after_correction {
    type: number
    group_label: "6 Correction Attributes"
    label: "Quantity after Correction"
    description: "New stock level entered by the operator."
    sql: ${TABLE}.quantity_after_correction ;;
  }

  dimension: is_correction_upwards {
    type: yesno
    group_label: "6 Correction Attributes"
    label: "Is Correction Upwards"
    description: "Flag that identifies if the correction was upwards."
    sql: if(${quantity_after_correction}-${quantity_before_correction}>0, true, false) ;;
  }
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Total Metrics  =========

  measure: number_of_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Checks"
    description: "Number of checks, includes status: done, open, canceled and unfulfillable."
    sql: ${table_uuid} ;;
  }

  measure: number_of_corrections {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Corrections"
    description: "Number of corrections."
    sql: ${table_uuid} ;;
    filters: [is_correction: "yes"]
  }

  measure: number_of_items_corrected {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Items Corrected"
    description: "Number of items corrected (count_distinct skus with corrections)."
    sql: ${sku} ;;
    filters: [is_correction: "yes"]
  }

  measure: number_of_completed_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Completed Checks"
    description: "Number of completed checks."
    sql: ${table_uuid} ;;
    filters: [status: "done"]
  }

  measure: number_of_open_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Open Checks"
    description: "Number of open checks."
    sql: ${table_uuid} ;;
    filters: [status: "open"]
  }

  measure: number_of_skipped_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Skipped Checks"
    description: "Number of skipped checks."
    sql: ${table_uuid} ;;
    filters: [status: "skipped"]
  }

  measure: number_of_open_completed_skipped_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Open, Completed and Skipped Checks"
    description: "Number of open and completed checks."
    sql: ${table_uuid} ;;
    filters: [status: "open, done, skipped"]
  }

  # =========  Rate Metrics  =========

  measure: corrections_per_completed_checks {
    type: number
    value_format: "0%"
    group_label: "Rate Metrics"
    label: "% of Corrections"
    description: "# of Corrections/ # of Completed Checks."
    sql: ${number_of_corrections}/nullif(${number_of_completed_checks},0) ;;
  }

  measure: pct_of_completion {
    type: number
    value_format: "0%"
    group_label: "Rate Metrics"
    label: "% of Completion"
    description: "# of Completed Checks/ (# of Completed Checks + # of Open Checks + # of Skipped Checks)"
    sql: ${number_of_completed_checks}/nullif((${number_of_open_completed_skipped_checks}),0) ;;
  }

  # =========  Time Metrics  =========

  measure: started_to_finished_seconds {
    type: sum
    group_label: "Time Metrics"
    label: "Started to Finished seconds"
    description: "Sum of the diferrence in seconds between Started Counting and Finished Counting timestamps for completed checks."
    value_format: "0"
    filters: [is_finished: "yes"]
    sql: DATETIME_DIFF(${finished_at_timestamp_raw}, ${started_at_timestamp_raw}, SECOND) ;;
  }

  measure: created_to_finished_seconds {
    type: sum
    group_label: "Time Metrics"
    label: "Created to Finished seconds"
    description: "Sum of the diferrence in seconds between Created At and Finished Counting timestamps for completed checks."
    value_format: "0"
    filters: [is_finished: "yes"]
    sql: DATETIME_DIFF(${finished_at_timestamp_raw}, ${created_at_timestamp_raw}, SECOND) ;;
  }

  measure: created_to_started_seconds {
    type: sum
    group_label: "Time Metrics"
    label: "Created to Started seconds"
    description: "Sum of the diferrence in seconds between Created At and Started Counting timestamps for completed checks."
    value_format: "0"
    filters: [is_finished: "yes"]
    sql: DATETIME_DIFF(${created_at_timestamp_raw}, ${started_at_timestamp_raw}, SECOND) ;;
  }

}
