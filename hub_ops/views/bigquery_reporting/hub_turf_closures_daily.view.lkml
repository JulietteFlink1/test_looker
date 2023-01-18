## Owner: Victor Breda
## This model provides closure information on a hub-turf-day-closure_reason granularity,
## and contains all historical data
view: hub_turf_closures_daily {
  sql_table_name: `flink-data-prod.reporting.hub_turf_closures_daily` ;;

  ############
  # Dimensions
  ############

  dimension: hub_turf_daily_closure_uuid{
    type: string
    primary_key: yes
    hidden:  yes
    sql: ${TABLE}.hub_turf_daily_closure_uuid ;;
  }

  dimension: country_iso {
    description: "Country ISO based on 'hub_code'."
    hidden: yes
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    description: "Code of a hub identical to back-end source tables."
    hidden: yes
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: turf_id {
    description: "Unique ID of the turf, coming from the hub locator database."
    type: string
    sql: ${TABLE}.turf_id ;;
  }

  dimension: turf_name {
    description: "Name of the turf."
    type: string
    sql: ${TABLE}.turf_name ;;
  }

  dimension_group: report {
    group_label: "Dates and Timestamps"
    label: "Report"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.date_current_timestamp ;;
  }

  dimension: closure_source {
    label: "Closure Source"
    description: "Backend system the closure originated from: LaunchDarkly, Hub-locator, auto-closing system."
    type: string
    sql: ${TABLE}.closure_source ;;
  }

  dimension: cleaned_comment {
    label: "Closure Reason"
    type: string
    sql: ${TABLE}.cleaned_comment ;;
  }

  dimension: number_of_closed_hours {
    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_closed_hours ;;
  }

  dimension: number_of_open_hours {
    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_open_hours ;;
  }

  dimension: number_of_missed_orders_forced_closure {
    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_missed_orders_forced_closure ;;
  }

  dimension: amt_estimated_lost_gmv_eur {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_estimated_lost_gmv_eur ;;
  }

  ############
  # Parameters
  ############

  parameter: date_granularity {
    group_label: "Dates and Timestamps"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  ############
  # Dynamic Dimensions
  ############

  dimension: date {
    group_label: "Dates and Timestamps"
    label: "Report Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
      {% if date_granularity._parameter_value == 'Day' %}
      ${report_date}
      {% elsif date_granularity._parameter_value == 'Week' %}
      ${report_week}
      {% elsif date_granularity._parameter_value == 'Month' %}
      ${report_month}
      {% endif %};;
  }

  ############
  # Measures
  ############

  measure: sum_number_of_missed_orders_forced_closure {
    label: "# Estimated Missed Orders (Daily)"
    description: "Estimated number of missed orders due to the forced closures."
    type: sum_distinct
    sql_distinct_key: ${hub_turf_daily_closure_uuid}  ;;
    sql: ${number_of_missed_orders_forced_closure} ;;
    value_format_name: decimal_0
  }

  measure: sum_amt_estimated_lost_gmv_eur {
    label: "AMT Estimated Lost GMV (Daily)"
    description: "Estimated lost GMV. Computed as number of missed orders due to emergency closure multiplied by average order value."
    type: sum_distinct
    sql_distinct_key: ${hub_turf_daily_closure_uuid} ;;
    sql: ${amt_estimated_lost_gmv_eur} ;;
    value_format_name: eur
  }

  measure: sum_number_of_open_hours {
    label: "# Open Hours (Daily)"
    description: "Number of hours the turf was open."
    type: sum_distinct
    sql_distinct_key: concat(${report_date}, ${hub_code}, coalesce(${turf_id}, ''));;
    sql: ${number_of_open_hours} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_closed_hours {
    label: "# Closed Hours (Daily)"
    description: "Number of hours the hub/turf was closed."
    type: sum_distinct
    sql_distinct_key: ${hub_turf_daily_closure_uuid} ;;
    sql: ${number_of_closed_hours} ;;
    value_format_name: decimal_2
  }

  measure: share_closed_hours_per_open_hours {
    label: "% Closures (Daily)"
    description: "# Closed hours / # Opened hours"
    type: number
    sql: safe_divide(${sum_number_of_closed_hours}, ${sum_number_of_open_hours});;
    value_format_name: percent_1
  }

}
