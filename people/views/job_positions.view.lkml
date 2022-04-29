view: job_positions {
  sql_table_name: `flink-data-dev.curated.job_positions`
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

  measure: number_of_filled_positions {
    group_label: "> Position Status"
    label: "# Filled Positions"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    filters: [status: "FILLED"]
  }

  measure: number_of_hired_positions {
    group_label: "> Position Status"
    label: "# Hired Positions"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    filters: [status: "HIRED"]
  }

  measure: number_of_open_positions {
    group_label: "> Position Status"
    label: "# Open Positions"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    filters: [status: "OPEN"]
  }

  measure: number_of_created_positions {
    group_label: "> Position Status"
    label: "# Created Positions"
    type: count_distinct
    sql: ${job_position_uuid} ;;
    filters: [status: "CREATED"]
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
}
