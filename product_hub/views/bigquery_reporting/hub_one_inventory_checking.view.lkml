# Owner: Product Analytics, Flavia Alvarez
# Created: 2023-01-18

view: hub_one_inventory_checking {
  sql_table_name: `flink-data-prod.reporting.hub_one_inventory_checking`
    ;;

  view_label: "1 Hub One Inventory Checking"

  # This is a table from the reporting layer that combines fe and be data from hub tasks

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

  dimension: task_id {
    group_label: "Task Attributes"
    description: "Unique identifier of each task (called check_id in the frontend app). Corresponds to the ID of the task in hub_task schema."
    type: string
    sql: ${TABLE}.task_id ;;
  }

  dimension: table_uuid {
    group_label: "Task Attributes"
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.task_id ;;
  }

  dimension: product_sku {
    description: "Task of the product, as available in the backend."
    group_label: "Task Attributes"
    type: string
    sql: ${TABLE}.product_sku ;;
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

  dimension: finished_by {
    description: "  Quinyx_badge_number of the employee who finished the task. Corresponds to ended_by in hub_task schema."
    group_label: "Employee Attributes"
    type: string
    sql: ${TABLE}.finished_by ;;
  }

  # =========  Task Dimensions   =========

  dimension: fe_origin {
    description: "Hub One screen from where the task_id has been started. Possible values are inventory/check-list, activities, inventory/eoy-inventory-check-list."
    group_label: "Task Attributes"
    type: string
    sql: ${TABLE}.fe_origin ;;
  }

  dimension: is_automatic_check {
    description: "TRUE when the check was scheduled."
    group_label: "Task Attributes"
    type: yesno
    sql: ${TABLE}.is_automatic_check ;;
  }

  dimension: is_correction {
    description: "TRUE when the task resulted in inventory correction. Calculated by retrieving the stock corrections from stock_changelog between started_at_timestamp and finished_at_timestamp."
    group_label: "Task Attributes"
    type: yesno
    sql: if(${task_status} = 'DONE', ${TABLE}.is_correction, false) ;;
  }

  dimension: shelf_number {
    description: "Unique identifier of the shelf where the SKU is stored in the hub. Number of the shelf (from 0 to 86) followed by a letter which indicates the level within the shelf."
    group_label: "Task Attributes"
    type: string
    sql: ${TABLE}.shelf_number ;;
  }

  dimension: task_priority {
    description: "Define when the task needs to be performed during the day. Corresponds to priority in hub_task schema."
    group_label: "Task Attributes"
    type: number
    sql: ${TABLE}.task_priority ;;
  }

  dimension: task_reason {
    description: "  Reason why we performed task. Corresponds to the reason in hub_task schema. Possible values are: MISSING, TOBACCO, EXPENSIVE, FRESHNESS, ROLLING_8_WEEKS, ROLLING_12_WEEKS, LOW_STOCK."
    group_label: "Task Attributes"
    type: string
    sql: ${TABLE}.task_reason ;;
  }

  dimension: raw_task_status {
    description: "  Status of the task. Corresponds to status in hub_task schema. Possible values are: OPEN, CANCELED, DONE, SKIPPED, IN_PROGRESS."
    group_label: "Task Attributes"
    hidden: yes
    type: string
    sql: ${TABLE}.task_status ;;
  }

  dimension: task_status {
    description: "  Status of the task. Corresponds to status in hub_task schema. Possible values are: OPEN, CANCELED, DONE, SKIPPED, IN_PROGRESS."
    group_label: "Task Attributes"
    type: string
    sql: case when ${task_type} = 'STOCK_CORRECTION' or ${TABLE}.task_status in ('OPEN', 'IN_PROGRESS') then ${TABLE}.task_status
              when ${TABLE}.task_status in ('CANCELED', 'DONE') and ${updated_at_timestamp_date} > ${scheduled_at_date} then 'OPEN'
              when ${TABLE}.task_status in ('CANCELED', 'DONE') and ${updated_at_timestamp_date} = ${scheduled_at_date} then ${TABLE}.task_status
              when ${TABLE}.task_status in ('SKIPPED') and ${updated_at_timestamp_date} <= ${scheduled_at_date} then ${TABLE}.task_status
              when ${TABLE}.task_status in ('SKIPPED') and ${updated_at_timestamp_date} > ${scheduled_at_date} then 'OPEN'
              else 'NO STATUS' end;;
  }

  dimension: task_type {
    description: "  Type of task. Corresponds to the type in hub_task schema. Possible values are: STOCK_CHECK, FRESHNESS_CHECK."
    group_label: "Task Attributes"
    type: string
    sql: ${TABLE}.task_type ;;
  }

  dimension: is_correction_upwards {
    type: yesno
    group_label: "Task Attributes"
    label: "Is Correction Upwards"
    description: "Flag that identifies if the correction made after a inventory task was upwards."
    sql: if(${quantity_after_correction}-${quantity_before_correction}>0 and ${task_status}='DONE', true, false) ;;
  }

  # =========  Backend Quantities   =========

  dimension: expected_quantity {
    description: "Expected amount of units before the task. Corresponds to quantity_to in stock_changelog schema of the last change made for that sku before started_at_timestamp."
    hidden: yes
    group_label: "Backend Quantities"
    type: number
    sql: ${TABLE}.expected_quantity ;;
  }

  dimension: quantity_before_correction {
    description: "Amount of units before the inventory correction. Corresponds to quantity_from in stock_changelog schema of the inventory correction performed."
    hidden: yes
    group_label: "Backend Quantities"
    type: number
    sql: ${TABLE}.quantity_before_correction ;;
  }

  dimension: quantity_after_correction {
    description: "New amount of units after the inventory correction. Corresponds to quantity_to in stock_changelog schema of the inventory correction performed."
    hidden: yes
    group_label: "Backend Quantities"
    type: number
    sql: ${TABLE}.quantity_after_correction ;;
  }


  # =========  Dates and Timestamps   =========
  # Backend Timestamps

  dimension_group: scheduled_at {
    description: "Date for when the task it's scheduled."
    type: time
    datatype: date
    timeframes: [
      raw,
      date,
      month,
      day_of_week,
      week_of_year,
      week
    ]
    sql: ${TABLE}.scheduled_at_date ;;
  }

  # dimension: scheduled_at_week {
  #   description: "Date for when the task it's scheduled."
  #   datatype: date
  #   sql: extract(week from ${scheduled_at_date}) ;;
  # }

  dimension_group: created_at_timestamp {
    description: "Timestamp for when the task has been created. Corresponds to created_at timestamp in hub_task schema."
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      hour,
      day_of_week,
      week_of_year,
      week
    ]
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension_group: updated_at_timestamp {
    description: "Timestamp for when the task has been updated. Corresponds to updated_at timestamp in hub_task schema."
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      hour,
      day_of_week,
      week_of_year,
      week
    ]
    sql: ${TABLE}.updated_at_timestamp ;;
  }

  dimension_group: started_at_timestamp {
    description: "Timestamp for when the task has been started. Corresponds to created_at timestamp in hub_task schema."
    type: time
    convert_tz: no
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      hour,
      day_of_week,
      week_of_year,
      week
    ]
    sql: ${TABLE}.started_at_timestamp ;;
  }

  dimension_group: finished_at_timestamp {
    description: "Timestamp for when the task has been finished. Corresponds to ended_at timestamp in hub_task schema."
    type: time
    convert_tz: no
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      hour,
      day_of_week,
      week_of_year,
      week
    ]
    sql: ${TABLE}.finished_at_timestamp ;;
  }

  dimension_group: correction_done_at_timestamp {
    description: "  Timestamp for when the correction has been made, null when there wasn't a stock correction (only checks). Corresponds to created_at timestamp in stock_changelog schema."
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      hour,
      day_of_week,
      week_of_year,
      week
    ]
    sql: ${TABLE}.correction_done_at_timestamp ;;
  }

  # Frontend Timestamps

  dimension_group: fe_started_at_timestamp {
    description: "  Timestamp for when the task has been started from Hub One app."
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      hour,
      day_of_week,
      week_of_year,
      week
    ]
    sql: ${TABLE}.fe_started_at_timestamp ;;
  }

  dimension_group: fe_finished_at_timestamp {
    description: "Timestamp for when the task has been finished from Hub One app."
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      hour,
      day_of_week,
      week_of_year,
      week
    ]
    sql: ${TABLE}.fe_finished_at_timestamp ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # # =========  Backend Quantities   =========

  # measure: sum_of_expected_quantity {
  #   description: ""
  #   group_label: "Backend Quantities"
  #   type: sum
  #   sql: ${TABLE}.expected_quantity ;;
  # }

  # measure: sum_of_quantity_before_correction {
  #   description: ""
  #   group_label: "Backend Quantities"
  #   type: sum
  #   filters: [is_automatic_check: "Yes"]
  #   sql: ${TABLE}.quantity_before_correction ;;
  # }

  # measure: sum_of_quantity_after_correction {
  #   description: ""
  #   group_label: "Backend Quantities"
  #   type: sum
  #   filters: [is_automatic_check: "Yes"]
  #   sql: ${TABLE}.quantity_after_correction ;;
  # }

  # =========  Frontend Quantities   =========

  # We only count the fe_quantity measures when the check is done in the same day as scheduled to avoid duplicates)

  measure: fe_quantity_expected {
    description: "Expected amount of units before the task (only checks). Value coming from Hub One."
    group_label: "Frontend Quantities"
    type: sum
    filters: [task_status: "done"]
    sql: ${TABLE}.fe_quantity_expected ;;
  }

  measure: fe_quantity_counted {
    description: "Number of units counted by the employee while performing the task (only checks). Value coming from Hub One."
    group_label: "Frontend Quantities"
    type: sum
    filters: [task_status: "done"]

    sql: ${TABLE}.fe_quantity_counted ;;
  }

  measure: fe_quantity_damaged {
    description: "Number of units reported as damaged by the employee while performing the task (checks and corrections). Value coming from Hub One."
    group_label: "Frontend Quantities"
    type: sum
    filters: [task_status: "done"]
    sql: ${TABLE}.fe_quantity_damaged ;;
  }

  measure: fe_quantity_expired {
    description: "Number of units reported as expired by the employee while performing the task (checks and corrections). Value coming from Hub One."
    group_label: "Quantities Metrics"
    type: sum
    filters: [task_status: "done"]
    sql: ${TABLE}.fe_quantity_expired ;;
  }

  measure: fe_quantity_corrected {
    description: "Number of units reported as corrected by the employee while performing the task (only corrections). Value coming from Hub One."
    group_label: "Quantities Metrics"
    type: sum
    filters: [task_status: "done"]
    sql: ${TABLE}.fe_quantity_corrected ;;
  }

  measure: fe_quantity_tgtg {
    description: "Number of units reported as damaged by the employee while performing the task (checks and corrections). Value coming from Hub One."
    group_label: "Quantities Metrics"
    type: sum
    filters: [task_status: "done"]
    sql: ${TABLE}.fe_quantity_tgtg ;;
  }

 # For the following two we dont need the filter cause the measures are only valid for stock_corrections and no for checks

  measure: sum_of_quantity_before_correction {
    description: "Amount of units before the inventory correction (only available for stock_corrections)."
    group_label: "Quantities Metrics"
    type: sum
    filters: [is_automatic_check: "No"]
    sql: ${TABLE}.quantity_before_correction ;;
  }

  measure: sum_of_quantity_after_correction {
    description: "New amount of units after the inventory correction (only available for stock_corrections)."
    group_label: "Quantities Metrics"
    type: sum
    filters: [is_automatic_check: "No"]
    sql: ${TABLE}.quantity_after_correction ;;
  }

  # =========  Total Metrics  =========

  measure: number_of_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Tasks"
    description: "Number of Tasks, includes all status."
    sql: ${table_uuid} ;;
  }

  # For the following is the same as above, we need to only count corrections when the check has been done in the scheduled_date to avoid duplicates

  measure: number_of_corrections {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Corrections"
    description: "Number of corrections."
    filters: [task_status: "done"]
    filters: [is_correction: "yes"]
    sql: ${table_uuid} ;;
  }

  measure: number_of_items_corrected {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Items Corrected"
    description: "Number of items corrected (count_distinct skus with corrections)."
    filters: [task_status: "done"]
    filters: [is_correction: "yes"]
    sql: ${product_sku} ;;
  }

  measure: number_of_completed_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Completed Tasks"
    description: "Number of completed tasks (task_status = done)."
    filters: [task_status: "done"]
    sql: ${table_uuid} ;;
  }

  # In the case of open checks we need to count all the open ones + the remaining from previous days
  measure: number_of_open_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Open Tasks"
    description: "Number of open tasks (task_status = open)."
    filters: [task_status: "open"]
    sql: ${table_uuid} ;;
  }

  measure: number_of_skipped_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Skipped Tasks"
    description: "Number of skipped tasks (task_status = skipped)."
    filters: [task_status: "skipped"]
    sql: ${table_uuid} ;;
  }

# Too many dependencies to adapt the name of the measure
  measure: number_of_open_completed_skipped_checks {
    type: count_distinct
    group_label: "Total Metrics"
    label: "# of Open and Completed Tasks"
    description: "Number of open and completed tasks (task_status = open, done, in_progress)."
    filters: [task_status: "open, done, in_progress"]
    sql: ${table_uuid} ;;
  }

  measure: number_of_not_canceled_checks {
    type: count_distinct
    hidden: yes
    group_label: "Total Metrics"
    description: "Number of tasks excluding canceled."
    filters: [task_status: "-canceled"]
    sql: ${table_uuid} ;;
  }

  # =========  Rate Metrics    =========

  measure: corrections_per_completed_checks {
    type: number
    value_format: "0%"
    group_label: "Rate Metrics (only checks)"
    label: "% of Corrections"
    description: "# of Corrections/ # of Completed Tasks."
    sql: ${number_of_corrections}/nullif(${number_of_completed_checks},0) ;;
  }

  measure: pct_of_completion {
    type: number
    value_format: "0%"
    group_label: "Rate Metrics (only checks)"
    label: "% of Completion"
    description: "# of Completed Tasks/ (# of Completed Tasks + # of Open Tasks)"
    sql: ${number_of_completed_checks}/nullif((${number_of_open_completed_skipped_checks}),0) ;;
  }

  # =========  Time Measures   =========

  measure: time_checking_minutes {
    group_label: "Time Metrics"
    description: "Time spent performing the task in minutes (calculated with as the time difference between fe_started_at_timestamp and fe_finished_at_timestamp)."
    type: sum
    value_format: "0.##"
    filters: [task_status: "done"]
    sql: ${TABLE}.time_checking_minutes ;;
  }

  measure: time_checking_seconds {
    group_label: "Time Metrics"
    description: "Time spent performing the task in seconds (calculated with as the time difference between fe_started_at_timestamp and fe_finished_at_timestamp)."
    type: sum
    value_format: "0.##"
    filters: [task_status: "done"]
    sql: ${TABLE}.time_checking_seconds ;;
  }

  measure: avg_time_checking_minutes {
    group_label: "Time Metrics"
    description: "Average time spent performing the task in minutes (calculated with as the time difference between fe_started_at_timestamp and fe_finished_at_timestamp)."
    type: average
    value_format: "0.##"
    filters: [task_status: "done"]
    sql: ${TABLE}.time_checking_minutes ;;
  }

  measure: avg_time_checking_seconds {
    group_label: "Time Metrics"
    description: "Average time spent performing the task in seconds (calculated with as the time difference between fe_started_at_timestamp and fe_finished_at_timestamp)."
    type: average
    value_format: "0.##"
    filters: [task_status: "done"]
    sql: ${TABLE}.time_checking_seconds ;;
  }
}
