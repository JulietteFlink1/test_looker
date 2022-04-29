view: candidate_application_status {
  sql_table_name: `flink-data-dev.curated.candidate_application_status`
    ;;

  dimension: application_uuid {
    group_label: "> IDs"
    description: "Application ID from SR"
    primary_key: yes
    type: string
    sql: ${TABLE}.application_uuid ;;
  }

  dimension: candidate_id {
    group_label: "> IDs"
    description: "Candidate ID from SR"
    type: string
    sql: ${TABLE}.candidate_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_referral {
    type: yesno
    sql: ${TABLE}.is_referral ;;
  }

  dimension: job_id {
    description: "Job ID from SR"
    group_label: "> IDs"
    type: string
    sql: ${TABLE}.job_id ;;
  }

  dimension: number_of_days_last_interview_to_offered {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_days_last_interview_to_offered ;;
  }

  dimension: number_of_days_new_to_hired {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_days_new_to_hired ;;
  }

  dimension: number_of_days_new_to_in_review {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_days_new_to_in_review ;;
  }

  dimension: number_of_days_new_to_interview {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_days_new_to_interview ;;
  }

  dimension: number_of_days_new_to_interview_prescreen {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_days_new_to_interview_prescreen ;;
  }

  dimension: number_of_days_new_to_rejection {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_days_new_to_rejection ;;
  }

  dimension: number_of_days_new_to_start {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_days_new_to_start ;;
  }

  dimension: number_of_days_new_to_withdrawn {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_days_new_to_withdrawn ;;
  }

  dimension: number_of_days_offered_to_hired {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_days_offered_to_hired ;;
  }

  dimension: number_of_interviews {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_interviews ;;
  }

  dimension: reason_of_rejection {
    type: string
    sql: ${TABLE}.reason_of_rejection ;;
  }

  dimension: reason_of_withdrawal {
    type: string
    sql: ${TABLE}.reason_of_withdrawal ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  ################# Core Funnel Dates

  dimension_group: start_date {
    type: time
    timeframes: [date,
      week,
      month
    ]
    datatype: date
    convert_tz: no
    group_label: "> Core Funnel Dates"
    label: "Start"
    sql: ${TABLE}.start_date ;;
  }

  dimension: status_first_interview {
    type: date
    convert_tz: no
    group_label: "> Core Funnel Dates"
    label: "First Interview Date"
    sql: ${TABLE}.status_first_interview_date ;;
  }

  dimension_group: hiring_date {
    type: time
    timeframes: [ date,
      week,
      month
    ]
    datatype: date
    label: "Hiring"
    convert_tz: no
    group_label: "> Core Funnel Dates"
    sql: ${TABLE}.status_hired_date ;;
  }

  dimension: status_last_interview {
    type: date
    convert_tz: no
    group_label: "> Core Funnel Dates"
    label: "Last Interview Date"
    sql: ${TABLE}.status_last_interview_date ;;
  }

  dimension_group: application_date {
    alias: [status_new]
    type: time
    timeframes: [ date,
      week,
      month
    ]
    datatype: date
    label: "Application"
    convert_tz: no
    group_label: "> Core Funnel Dates"
    sql: ${TABLE}.application_date ;;
  }

  dimension: status_in_review {
    type: date
    group_label: "> Core Funnel Dates"
    label: "In-Review Date"
    sql: ${TABLE}.status_in_review_date ;;
  }

  dimension: status_offered {
    type: date
    group_label: "> Core Funnel Dates"
    label: "Offered Date"
    sql: ${TABLE}.status_offered_date ;;
  }

  dimension: status_rejected {
    type: date
    convert_tz: no
    group_label: "> Core Funnel Dates"
    label: "Rejected Date"
    sql: ${TABLE}.status_rejected_date ;;
  }

  dimension: status_withdrawn {
    type: date
    convert_tz: no
    group_label: "> Core Funnel Dates"
    label: "Withdrawn Date"
    sql: ${TABLE}.status_withdrawn_date ;;
  }

  ############### In-Review Dates

  dimension: substatus_in_review_recruiter {
    type: date
    convert_tz: no
    group_label: "> In-Review Dates"
    label: "In-Review Recruiter Date"
    sql: ${TABLE}.substatus_in_review_recruiter_date ;;
  }

  dimension: substatus_in_review_hiring_manager {
    type: date
    convert_tz: no
    group_label: "> In-Review Dates"
    label: "In-Review Hiring Manager Date"
    sql: ${TABLE}.substatus_in_review_hiring_manager_date ;;
  }

  ############### Interview Dates

  dimension: substatus_interview_f2f_executive {
    type: date
    convert_tz: no
    group_label: "> Interview Dates"
    label: "[INTERVIEW] F2F Executive Interview Date"
    sql: ${TABLE}.substatus_interview_f2f_executive_date ;;
  }

  dimension: substatus_interview_f2f_founder {
    type: date
    convert_tz: no
    group_label: "> Interview Dates"
    label: "[INTERVIEW] F2F Founder Interview Date"
    sql: ${TABLE}.substatus_interview_f2f_founder_date ;;
  }

  dimension: substatus_interview_f2f_peer {
    type: date
    convert_tz: no
    group_label: "> Interview Dates"
    label: "[INTERVIEW] F2F Peer Interview Date"
    sql: ${TABLE}.substatus_interview_f2f_peer_date ;;
  }

  dimension: substatus_interview_f2f_recruiter_hiring_manager {
    type: date
    convert_tz: no
    group_label: "> Interview Dates"
    label: "[INTERVIEW] F2F Recruiter & Hiring Manager Date"
    sql: ${TABLE}.substatus_interview_f2f_recruiter_hiring_manager_date ;;
  }

  dimension: substatus_interview_preliminary {
    type: date
    convert_tz: no
    group_label: "> Interview Dates"
    label: "[INTERVIEW] Preliminary Interview Date"
    sql: ${TABLE}.substatus_interview_preliminary_date ;;
  }

  dimension: substatus_interview_prescreen {
    type: date
    convert_tz: no
    group_label: "> Interview Dates"
    label: "[INTERVIEW] Pre-screen Interview Date"
    sql: ${TABLE}.substatus_interview_prescreen_date ;;
  }

  dimension: substatus_interview_test_assignment {
    type: date
    convert_tz: no
    group_label: "> Interview Dates"
    label: "[INTERVIEW] Test Assignment Date"
    sql: ${TABLE}.substatus_interview_test_assignment_date ;;
  }

  ################ Counts

  measure: number_of_candidates {
    group_label: "> Counts"
    type: count_distinct
    label: "# Candidates"
    sql: ${candidate_id} ;;
  }

  measure: number_of_jobs {
    group_label: "> Counts"
    type: count_distinct
    label: "# Jobs"
    sql: ${job_id} ;;
  }

  measure: number_of_new_applications {
    group_label: "> Counts"
    type: count_distinct
    label: "# New Applications"
    sql: ${application_uuid} ;;
    filters: [application_date_date: "not null"]
  }

  measure: number_of_rejected {
    group_label: "> Counts"
    type: count_distinct
    label: "# Rejected"
    sql: ${application_uuid} ;;
    filters: [status_rejected: "not null"]
  }

  measure: number_of_in_reviews {
    group_label: "> Counts"
    type: count_distinct
    label: "# In-Review (any)"
    description:"# of applications that entered the In-Review status in SR, with any substatus (HM or Recruiter)"
    sql: ${application_uuid} ;;
    filters: [status_in_review: "not null"]
  }

  measure: number_of_in_review_recruiter {
    group_label: "> Counts"
    type: count_distinct
    label: "# In-Review (Recruiter)"
    description:"# of applications that entered the Recruiter In-Review sub-status in SR"
    sql: ${application_uuid} ;;
    filters: [substatus_in_review_recruiter: "not null"]
  }

  measure: number_of_in_review_hiring_manager {
    group_label: "> Counts"
    type: count_distinct
    label: "# In-Review (Hiring Manager)"
    description:"# of applications that entered the Hiring Manager In-Review sub-status in SR"
    sql: ${application_uuid} ;;
    filters: [substatus_in_review_hiring_manager: "not null"]
  }

  measure: number_of_prescreen_interviews {
    group_label: "> Counts"
    type: count_distinct
    label: "# Pre-Screen Interview"
    sql: ${application_uuid} ;;
    filters: [substatus_interview_prescreen: "not null"]
  }

  measure: number_of_first_interviews {
    group_label: "> Counts"
    type: count_distinct
    label: "# First Interview"
    sql: ${application_uuid} ;;
    filters: [status_first_interview: "not null"]
  }

  measure: number_of_last_interviews {
    group_label: "> Counts"
    type: count_distinct
    label: "# Last Interview"
    sql: ${application_uuid} ;;
    filters: [status_last_interview: "not null"]
  }

  measure: number_of_hired {
    group_label: "> Counts"
    type: count_distinct
    label: "# Hired"
    sql: ${application_uuid} ;;
    filters: [hiring_date_date: "not null"]
  }

  measure: number_of_offered {
    group_label: "> Counts"
    type: count_distinct
    label: "# Offered"
    sql: ${application_uuid} ;;
    filters: [status_offered: "not null"]
  }


  ################ Duration Between Stages

  measure: avg_number_of_days_last_interview_to_offered {
    group_label: "> Duration Between Stages"
    type: average
    label: "AVG # Days Last Interview to Offer"
    sql: ${number_of_days_last_interview_to_offered} ;;
    value_format: "0.0"
  }

  measure: avg_number_of_days_new_to_hired {
    group_label: "> Duration Between Stages"
    type: average
    label: "AVG # Days New to Hired"
    sql: ${number_of_days_new_to_hired} ;;
    value_format: "0.0"
  }

  measure: avg_number_of_days_new_to_in_review {
    group_label: "> Duration Between Stages"
    type: average
    label: "AVG # Days New to In-Review"
    sql: ${number_of_days_new_to_in_review} ;;
    value_format: "0.0"
  }

  measure: avg_number_of_days_new_to_interview {
    group_label: "> Duration Between Stages"
    type: average
    label: "AVG # Days New to Interview"
    sql: ${number_of_days_new_to_interview} ;;
    value_format: "0.0"
  }

  measure: avg_number_of_days_new_to_interview_prescreen {
    group_label: "> Duration Between Stages"
    type: average
    label: "AVG # Days New to Pre-Screen Interview"
    sql: ${number_of_days_new_to_interview_prescreen} ;;
    value_format: "0.0"
  }

  measure: avg_number_of_days_new_to_rejection {
    type: average
    group_label: "> Duration Between Stages"
    label: "AVG # Days New to Rejected"
    sql: ${number_of_days_new_to_rejection} ;;
    value_format: "0.0"
  }

  measure: avg_number_of_days_new_to_withdrawn {
    type: average
    group_label: "> Duration Between Stages"
    label: "AVG # Days New to Withdrawn"
    sql: ${number_of_days_new_to_withdrawn} ;;
    value_format: "0.0"
  }

  measure: avg_number_of_interviews {
    type: average
    group_label: "> Counts"
    label: "AVG # Interviews"
    description: "AVG number of interviews for the candidates who enter the interview process"
    sql: ${number_of_interviews} ;;
    value_format: "0.0"
    filters: [status_first_interview: "not null"]
  }


    ################ Conversion Rates

  measure: conversion_rate_new2hired {
    type: number
    group_label: "> Conversion Rates"
    sql: ${number_of_hired}/${number_of_new_applications} ;;
    label: "% Transformation Rate (New Application → Hired)"
    value_format: "0.0%"
  }

  measure: conversion_rate_new2rejection {
    type: number
    group_label: "> Conversion Rates"
    sql: ${number_of_rejected}/${number_of_new_applications} ;;
    label: "% Rejection Rate (New Application → Rejected)"
    value_format: "0.0%"
  }

  measure: offer_acceptance_rate_offered2hired {
    type: number
    group_label: "> Conversion Rates"
    sql: safe_divide(${number_of_hired},${number_of_offered}) ;;
    label: "% Offer Acceptance (Offered → Hired)"
    value_format: "0.0%"
  }

  ########## Parameters

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  ######## DYNAMIC DIMENSIONS

  dimension: application_date_dynamic {
    group_label:  "> Core Funnel Dates"
    label: "Application Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${application_date_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${application_date_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${application_date_month}
    {% endif %};;
  }

  dimension: hiring_date_dynamic {
    group_label:  "> Core Funnel Dates"
    label: "Hiring Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${hiring_date_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${hiring_date_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${hiring_date_month}
    {% endif %};;
  }

  dimension: start_date_dynamic {
    group_label:  "> Core Funnel Dates"
    label: "Start Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${start_date_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${start_date_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${start_date_month}
    {% endif %};;
  }

  # dimension: date_granularity_pass_through {
  #   group_label: "> Parameters"
  #   description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
  #   type: string
  #   hidden: no # yes
  #   sql:
  #           {% if date_granularity._parameter_value == 'Day' %}
  #             "Day"
  #           {% elsif date_granularity._parameter_value == 'Week' %}
  #             "Week"
  #           {% elsif date_granularity._parameter_value == 'Month' %}
  #             "Month"
  #           {% endif %};;
  # }


}
