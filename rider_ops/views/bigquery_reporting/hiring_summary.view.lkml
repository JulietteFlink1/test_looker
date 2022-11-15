# Owner:   Nazrin Guliyeva
# Created: 2022-11-08

# This view contains information about hiring summary breakdown by country, city, hub code, channel etc.

view: hiring_summary {
  sql_table_name: `flink-data-prod.reporting.hiring_summary`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: city {
    type: string
    description: "Applied city."
    sql: ${TABLE}.city ;;
  }

  dimension: contract_type {
    label: "Contract Type"
    type: string
    description: "Type of contract."
    sql: ${TABLE}.contract_type;;
  }

  dimension: country_iso {
    label: "Country ISO"
    type: string
    description: "Applied country code."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    label: "Hub Code"
    type: string
    description: "Applied hub code."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_first_shift_completed {
    label: "Is First Shift Completed"
    type: yesno
    description: "Yes, if first assigned shift is worked."
    sql: ${TABLE}.is_first_shift_completed ;;
  }

  dimension: is_first_shift_scheduled {
    label: "Is First Shift Scheduled"
    type: yesno
    description: "Yes, if first shift is assigned."
    sql: ${TABLE}.is_first_shift_scheduled ;;
  }

  dimension: position_name {
    type: string
    description: "Applied position name."
    sql: ${TABLE}.position_name ;;
  }

  dimension: rejection_reason {
    type: string
    description: "Rejection reason for a job application in the Fountain platform."
    sql: ${TABLE}.rejection_reason ;;
  }

  dimension: stage_title {
    type: string
    description: "Hiring stage title in Fountain platform."
    sql: ${TABLE}.stage_title ;;
  }

  dimension: table_uuid {
    primary_key: yes
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
  }

  dimension: utm_channel {
    type: string
    description: "Used to identify a channel such as organic or job platform."
    sql: ${TABLE}.utm_channel ;;
  }

  dimension_group: last_transitioned {
    label: "Last Transitioned"
    type: time
    description: "Last transition date from one hiring stage (from Fountain platform) into another in UTC timezone."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_transitioned_date ;;
  }

  dimension: date_ {
  label: "Date (Dynamic)"
  label_from_parameter: date_granularity
  sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${last_transitioned_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${last_transitioned_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${last_transitioned_month}
    {% endif %};;
  }

  dimension: week_number {
    label: "Week Number"
    type: number
    sql: extract(week from date_trunc(${TABLE}.last_transitioned_date, week(monday))) ;;
    hidden: no
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: number_of_applicants {
    label: "# Applicants"
    type: sum
    description: "Number of applicants from Fountain platform."
    sql: ${TABLE}.number_of_applicants ;;
  }

  measure: number_of_rejected_applicants {
    label: "# Rejected Applicants"
    type: sum
    description: "Number of rejected applicants from Fountain platform."
    filters: [stage_title: "Rejected"]
    sql: ${TABLE}.number_of_applicants ;;
  }

  measure: number_of_hired_applicants {
    label: "# Hired Applicants"
    type: sum
    description: "Number of hired applicants (Approved stage) from Fountain platform."
    filters: [stage_title: "Rejected"]
    sql: ${TABLE}.number_of_applicants ;;
  }

  measure: number_of_applicants_with_first_shift_completed {
    label: "# Applicants - First Shift Completed"
    type: sum
    description: "Number of applicants worked their first scheduled shift."
    filters: [is_first_shift_completed: "Yes"]
    sql: ${TABLE}.number_of_applicants ;;
  }

  measure: number_of_applicants_with_first_shift_scheduled{
    label: "# Applicants - First Shift Scheduled"
    type: sum
    description: "Number of applicants that has first shift assigned."
    filters: [is_first_shift_scheduled: "Yes"]
    sql: ${TABLE}.number_of_applicants ;;
  }

  measure: number_of_days_to_first_shift {
    label: "# Days to First Shift"
    type: sum
    description: "A total number of days between the application creation date from Fountain and first scheduled shift date."
    sql: ${TABLE}.number_of_days_to_first_shift ;;
  }

  measure: number_of_days_to_hire {
    label: "# Days to Hire"
    type: sum
    description: "A total number of days between the application creation date from Fountain and hiring date."
    sql: ${TABLE}.number_of_days_to_hire ;;
  }

  measure: avg_number_of_days_to_hire {
    label: "AVG Days to Hire"
    type: number
    description: "Average number of days to hire an applicant."
    sql: ${number_of_days_to_hire}/${number_of_applicants} ;;
    value_format_name: decimal_1
  }

  measure: avg_number_of_days_to_first_shift {
    label: "AVG Days to First Shift"
    type: number
    description: "Average number of days to first scheduled shift."
    sql: ${number_of_days_to_first_shift}/${number_of_applicants} ;;
    value_format_name: decimal_1
  }

  measure: share_of_hired_applicants {
    label: "CVR"
    type: number
    description: "Share of Hired Applicants"
    sql: ${number_of_hired_applicants}/${number_of_applicants} ;;
    value_format_name: percent_1
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: date_granularity {
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }

}
