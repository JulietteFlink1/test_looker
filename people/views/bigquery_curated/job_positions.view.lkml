view: job_positions {
  sql_table_name: `flink-data-prod.curated.job_positions`
    ;;

  dimension: country_iso {
    hidden: yes
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: job_id {
    label: "Job ID"
    hidden: yes
    type: string
    sql: ${TABLE}.job_id ;;
  }

  dimension: job_position_uuid {
    label: "Position ID"
    hidden: yes
    type: string
    sql: ${TABLE}.job_position_uuid ;;
  }

  dimension_group: position_open {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.position_open_date ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: target_start {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.target_start_date ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: number_of_hired_started_positions {
    alias: [number_of_filled_positions]
    group_label: "> Position Status"
    label: "# Hired Positions (started)"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    description: "Number of positions with status FILLED for jobs with any status"
    filters: [status: "FILLED", job_details.job_status: "FILLED, INTERVIEW, SOURCING, OFFER, CREATED, ON-HOLD, CANCELLED"]
  }

  measure: number_of_hired_not_started_positions {
    alias: [number_of_hired_positions]
    group_label: "> Position Status"
    label: "# Hired Positions (not started)"
    description: "Number of positions with status HIRED for jobs with any status"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    filters: [status: "HIRED", job_details.job_status: "FILLED, INTERVIEW, SOURCING, OFFER, CREATED, ON-HOLD, CANCELLED"]
  }

  measure: number_of_all_hired_positions {
    group_label: "> Position Status"
    label: "# Hired Positions (all)"
    description: "Number of positions with status HIRED or FILLED for jobs with any status"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    filters: [status: "HIRED, FILLED", job_details.job_status: "FILLED, INTERVIEW, SOURCING, OFFER, CREATED, ON-HOLD, CANCELLED"]
  }

  measure: number_of_all_hired_positions_filtered {
    group_label: "> Position Status"
    label: "# Hired Positions (all)"
    description: "Number of positions with status HIRED or FILLED for jobs with any status except ON-HOLD and CANCELLED"
    type: count_distinct
    hidden: yes
    sql: ${job_position_uuid} ;;
    filters: [status: "HIRED, FILLED", job_details.job_status: "FILLED, INTERVIEW, SOURCING, OFFER, CREATED"]
  }

  measure: number_of_open_positions {
    group_label: "> Position Status"
    label: "# Open Positions"
    description: "# Open positions for jobs with status INTERVIEW, SOURCING, OFFER"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    filters: [status: "OPEN", job_details.job_status: "INTERVIEW, SOURCING, OFFER"]
  }

  measure: number_of_created_positions {
    group_label: "> Position Status"
    label: "# Created Positions"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    filters: [status: "CREATED"]
  }

  measure: number_of_positions {
    group_label: "> Position Status"
    hidden: yes
    label: "# Positions"
    type: count_distinct
    sql: ${job_position_uuid} ;;
  }

  measure: number_of_positions_filtered {
    group_label: "> Position Status"
    label: "# Positions"
    description: "# Positions for job with status FILLED, INTERVIEW, SOURCING, OFFER, CREATED. Excluding ON_HOLD and CANCELLED"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    filters: [job_details.job_status: "FILLED, INTERVIEW, SOURCING, OFFER, CREATED"]
  }

  measure: fill_rate {
    group_label: "> Fill Rate"
    label: "% Fill Rate"
    description: "# Hired positions for Job with status FILLED, INTERVIEW, SOURCING, OFFER / # All positions for jobs with status FILLED, INTERVIEW, SOURCING, OFFER"
    type: number
    value_format: "0%"
    sql:  safe_divide(${number_of_all_hired_positions_filtered},${number_of_positions_filtered});;
  }

  ########## Parameters

  parameter: date_granularity {
    group_label: "> Dates"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  ######## DYNAMIC DIMENSIONS

  dimension: position_open_date_dynamic {
    group_label:  "> Dates"
    label: "Position Open Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${position_open_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${position_open_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${position_open_month}
    {% endif %};;
  }

  dimension: target_start_date_dynamic {
    group_label:  "> Dates"
    label: "Target Start Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${target_start_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${target_start_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${target_start_month}
    {% endif %};;
  }

  dimension: hiring_date_dynamic {
    group_label:  "> Dates"
    label: "Hiring Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${candidate_application_funnel.hiring_date_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${candidate_application_funnel.hiring_date_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${candidate_application_funnel.hiring_date_month}
    {% endif %};;
  }
}
