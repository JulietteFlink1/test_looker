view: test_funnel_recruitment {
  sql_table_name: `flink-data-dev.sandbox_justine.test_funnel_recruitment`
    ;;

  dimension: application_source {
    type: string
    sql: ${TABLE}.application_source ;;
  }

  dimension: application_status {
    type: string
    sql: ${TABLE}.application_status ;;
  }

  dimension: candidate_id {
    type: string
    sql: ${TABLE}.candidate_id ;;
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    sql: concat(${TABLE}.candidate_id, ${job_id},${application_status}) ;;
  }

  dimension: candidates_city {
    type: string
    sql: ${TABLE}.candidates_city ;;
  }

  dimension: candidates_country {
    type: string
    sql: ${TABLE}.candidates_country ;;
  }

  dimension: function {
    type: string
    sql: ${TABLE}.function ;;
  }

  dimension: job_id {
    type: string
    sql: ${TABLE}.job_id ;;
  }

  dimension: reason_of_rejection {
    type: string
    sql: ${TABLE}.reason_of_rejection ;;
  }

  dimension: reason_of_withdrawal {
    type: string
    sql: ${TABLE}.reason_of_withdrawal ;;
  }

  dimension_group: status_start {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.status_start_date ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.updated_on ;;
  }

  dimension: is_application_status_new {
    type: yesno
    sql: case when lower(${application_status}) = 'new' then true else false end ;;
  }

  dimension: is_application_status_interview {
    type: yesno
    sql: case when lower(${application_status}) = 'interview' then true else false end ;;
  }

  dimension: is_application_status_rejected {
    type: yesno
    sql: case when lower(${application_status}) = 'rejected' then true else false end ;;
  }

  dimension: is_application_status_offered {
    type: yesno
    sql: case when lower(${application_status}) = 'offered' then true else false end ;;
  }

  dimension_group: updated_new_date {
    type: time
    datatype: date
    sql: case when ${is_application_status_new} then ${updated_date} end ;;

  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: number_of_applications_new {
    type: count_distinct
    sql: ${candidate_id};;
    filters: [is_application_status_new: "yes"]
  }

  measure: number_of_applications_interview {
    type: count_distinct
    sql: ${candidate_id};;
    filters: [is_application_status_interview: "yes"]
  }

  measure: number_of_applications_offered {
    type: count_distinct
    sql: ${candidate_id};;
    filters: [is_application_status_offered: "yes"]
  }

  measure: number_of_applications_rejected {
    type: count_distinct
    sql: ${candidate_id};;
    filters: [is_application_status_rejected: "yes"]
  }
}
