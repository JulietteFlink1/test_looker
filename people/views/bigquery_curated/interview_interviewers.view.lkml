view: interview_interviewers {
  sql_table_name: `flink-data-prod.curated.interview_interviewers`
    ;;

  dimension: candidate_id {
    type: string
    group_label: "> IDs"
    sql: ${TABLE}.candidate_id ;;
  }

  dimension_group: created {
    type: time
    group_label: "> Dates & Timestamps"
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.created_timestamp ;;
  }

  dimension: interview_id {
    group_label: "> IDs"
    type: string
    sql: ${TABLE}.interview_id ;;
  }

  dimension: application_id {
    group_label: "> IDs"
    type: string
    sql: ${TABLE}.application_id ;;
  }

  dimension: interview_interviewer_uuid {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.interview_interviewer_uuid ;;
  }

  dimension_group: interview {
    type: time
    group_label: "> Dates & Timestamps"
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.interview_timestamp ;;
  }

  dimension: interview_type {
    type: string
    sql: ${TABLE}.interview_type ;;
  }

  dimension: interviewer_id {
    group_label: "> IDs"
    type: string
    sql: ${TABLE}.interviewer_id ;;
  }

  dimension: interviewer_name {
    group_label: "> Interview Dimensions"
    type: string
    sql: ${TABLE}.interviewer_name ;;
  }

  dimension: interviewer_rating {
    type: number
    hidden: yes
    sql: ${TABLE}.interviewer_rating ;;
  }

  dimension: job_id {
    group_label: "> IDs"
    type: string
    sql: ${TABLE}.job_id ;;
  }

  dimension: interview_rank {
    group_label: "> Interview Dimensions"
    type: number
    sql: ${TABLE}.interview_rank ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [interviewer_name]
  }

  ########### Measures

  measure: number_of_interviews {
    type: count_distinct
    sql: ${interview_id} ;;
    label: "# Interviews"
    description: "Number of interviews"
  }

  measure: average_rating {
    type: average
    sql: ${interviewer_rating} ;;
    label: "AVG Rating"
    description: "AVG rating given by an iterviewer to a candidate after an interview"
    sql_distinct_key: ${interview_id} ;;
    value_format: "0.00"
  }

  ########## Parameters

  parameter: date_granularity {
    group_label: "> Dates and Timestamps"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  ######## DYNAMIC DIMENSIONS

  dimension: interview_date_dynamic {
    group_label:  "> Dates and Timestamps"
    label: "Interview Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${interview_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${interview_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${interview_month}
    {% endif %};;
  }

}
