# Owner:   Omar Alshobaki
# Created: 2022-06-01
# This view contains daily aggregation of shift and ops related kpis as well as employment info in per distinct hub employee and position

view: employee_level_kpis {
  sql_table_name: `flink-data-dev.reporting.employee_level_kpis`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: table_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: position_name {
    type: string
    label: "Position Name"
    sql: ${TABLE}.position_name ;;
  }

  dimension: rider_id {
    type: string
    label: "Rider ID"
    sql: ${TABLE}.rider_id ;;
  }

  dimension_group: shift {
    type: time
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
    sql: ${TABLE}.shift_date ;;
  }

  dimension: staff_number {
    type:  number
    label: "Staff Number"
    sql: ${TABLE}.staff_number ;;
    value_format: "0"
  }

  dimension: acquisition_channel {
    type: string
    label: "Acquisition Channel"
    sql: ${TABLE}.acquisition_channel ;;
  }

  dimension: ats_id {
    type: string
    label: "ATS ID"
    sql: ${TABLE}.ats_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: external_agency_name {
    type: string
    label: "External Agency Name"
    sql: ${TABLE}.external_agency_name ;;
  }

  dimension: fleet_type {
    type: string
    label: "Fleet Type"
    description: "Internal/Partnership/One-Time"
    sql: ${TABLE}.fleet_type ;;
  }

  dimension_group: hire {
    type: time
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
    sql: ${TABLE}.hire_date ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_external {
    type: yesno
    sql: ${TABLE}.is_external ;;
  }

  dimension: type_of_contract {
    type: string
    description: "Based on fountain data: full-time, part-time, min/max, 15, 30, etc"
    sql: ${TABLE}.type_of_contract ;;
  }

  dimension: weekly_contracted_hours {
    type: number
    sql: ${TABLE}.weekly_contracted_hours ;;
  }

  dimension_group: time_between_hire_date_and_today {
    type: duration
    sql_start: timestamp(${TABLE}.hire_date) ;;
    sql_end: current_timestamp ;;
    group_label: "Rider Tenure - time since hired "
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: number_of_scheduled_weeks {
    type: number
    hidden: yes
    sql:1 + date_DIFF( safe_cast(max(${shift_date}) as date),safe_cast(min(${shift_date}) as date), week) ;;
  }


  measure: last_worked_date {
    datatype: date
    description: "date of the last worked/punched shift"
    sql: max(case when ${TABLE}.number_of_worked_minutes > 0 then ${TABLE}.shift_date end);;
  }

  measure: first_worked_date {
    datatype: date
    description: "date of the first worked/punched shift"
    sql: min(case when ${TABLE}.number_of_worked_minutes > 0 then ${TABLE}.shift_date end);;
  }

  measure: number_of_delivered_orders {
    type: sum
    label: "# Delivered Orders"
    sql: ${TABLE}.number_of_delivered_orders ;;
  }

  measure: number_of_orders_with_available_nps_score {
    type: sum
    hidden: no
    sql: ${TABLE}.number_of_orders_with_available_nps_score ;;
  }

  measure: number_of_scheduled_hours {
    type: sum
    label: "# Scheduled Hours"
    sql: ${TABLE}.number_of_planned_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_products_with_damaged_products_issues_post {
    type: sum
    label: "# Products Damaged (Post Delivery)"
    description: "The number of products, that were damaged and were claimed through the Customer Service"
    sql: ${TABLE}.number_of_orders_with_damaged_products ;;
  }

  measure: number_of_orders_with_damaged_products{
    type: sum
    label: "# Orders with Products Damaged (Post Delivery)"
    description: "The number of Orders, with products that were damaged and were claimed through the Customer Service"
    sql: ${TABLE}.number_of_orders_with_damaged_products ;;
  }

  measure: sum_rider_handling_time_minutes {
    type: sum
    label: "Sum Rider Handling Time (min)"
    description: "Sum time needed for the rider to handle the order: Riding to customer + At customer + Riding to hub"
    sql: ${TABLE}.number_of_rider_handling_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_rider_handling_time_minutes {
    type: number
    label: "AVG Rider Handling Time (min)"
    description: "Average time needed for the rider to handle the order: Riding to customer + At customer + Riding to hub"
    sql: ${sum_rider_handling_time_minutes}/nullif(${number_of_delivered_orders},0) ;;
    value_format_name: decimal_1
  }

  measure: sum_riding_to_hub_minutes {
    type: sum
    label: "Sum Riding to Hub time (min)"
    description: "Sum Riding time from customer location back to the hub (<1min or >30min)."
    sql: ${TABLE}.number_of_return_to_hub_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_riding_to_hub_minutes {
    type: number
    label: "AVG Riding to Hub time (min)"
    description: "Average Riding time from customer location back to the hub (<1min or >30min)."
    sql: ${sum_riding_to_hub_minutes}/nullif(${number_of_delivered_orders},0) ;;
    value_format_name: decimal_1
  }

  measure: sum_riding_to_customer_time_minutes {
    type: sum
    label: "Sum Riding To Customer Time (min)"
    description: "Sum riding to customer time considering delivery start to arrival at customer. Outliers excluded (<1min or >30min)"
    sql: ${TABLE}.number_of_riding_to_customer_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_riding_to_customer_time_minutes {
    type: number
    label: "AVG Riding To Customer Time (min)"
    description: "Average riding to customer time considering delivery start to arrival at customer. Outliers excluded (<1min or >30min)"
    sql: ${sum_riding_to_customer_time_minutes}/nullif(${number_of_delivered_orders},0) ;;
    value_format_name: decimal_1
  }

  measure: sum_at_customer_time_minutes {
    type: sum
    label: "Sum At Customer Time (min)"
    description: "Sum Time the Rider spent at the customer between arrival and order completion confirmation"
    sql: ${TABLE}.number_of_at_customer_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_at_customer_time_minutes {
    type: number
    label: "AVG At Customer Time (min)"
    description: "Average Time the Rider spent at the customer between arrival and order completion confirmation"
    sql: ${sum_at_customer_time_minutes}/nullif(${number_of_delivered_orders},0) ;;
    value_format_name: decimal_1
  }

  measure: pct_riding_to_customer_time {
    type: number
    label: "% Riding To Customer Time"
    description: "Riding to Customer Time / Riding Time (To Customer + Back To Hub) "
    sql: ${TABLE}.number_of_riding_to_customer_time_minutes / nullif(${TABLE}.number_of_riding_to_customer_time_minutes + ${TABLE}.number_of_return_to_hub_time_minutes,0)  ;;
    value_format: "0%"
  }

  measure: pct_riding_back_to_hub_time {
    type: number
    label: "% Riding Back To Hub"
    description: "Riding Back to Hub Time / Riding Time (To Customer + Back To Hub) "
    sql: ${TABLE}.number_of_return_to_hub_time_minutes / nullif(${TABLE}.number_of_riding_to_customer_time_minutes + ${TABLE}.number_of_return_to_hub_time_minutes,0)  ;;
    value_format: "0%"
  }

  measure: number_of_sick_hours {
    type: sum
    label: "# Sickness Hours"
    sql: ${TABLE}.number_of_sick_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_early_punched_out_minutes {
    type: sum
    label: "# Early Punched-Out (min)"
    description: "Number of Early Punch-Out Minutes"
    sql: ${TABLE}.number_of_end_early_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_late_punched_out_minutes {
    type: sum
    label: "# Late Punched-Out (min)"
    description: "Number of Late Punch-Out Minutes"
    sql: ${TABLE}.number_of_end_late_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_early_punched_in_minutes {
    type: sum
    label: "# Early Punched-In (min)"
    description: "Number of Early Punch-In Minutes"
    sql: ${TABLE}.number_of_start_early_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_late_punched_in_minutes {
    type: sum
    label: "# Late Punched-In (min)"
    description: "Number of Late Punch-In Minutes"
    sql: ${TABLE}.number_of_start_late_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_late_punched_in_minutes {
    type: average
    label: "AVG Late Punched-In (min)"
    description: "AVG Employee Late Punch-In Minutes"
    sql: ${TABLE}.number_of_start_late_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours {
    type: sum
    label: "# Worked Hours"
    sql: ${TABLE}.number_of_worked_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours {
    type: sum
    label: "# No Show Hours"
    sql: ${TABLE}.number_of_no_show_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: avg_rider_utr {
    type: number
    label: "AVG Rider UTR"
    sql: ${number_of_delivered_orders}/nullif(${number_of_worked_hours},0) ;;
    value_format_name: decimal_1
  }

  measure: pct_no_show_hours {
    type: number
    hidden: no
    label: "% No Show Hours "
    sql: ${number_of_no_show_hours}/nullif(${number_of_scheduled_hours},0) ;;
    value_format: "0%"
  }

  measure: pct_sickness_hours {
    type: number
    hidden: no
    label: "% Sickness Hours "
    sql: ${number_of_sick_hours}/nullif(${number_of_scheduled_hours},0) ;;
    value_format: "0%"
  }

  measure: pct_contract_fulfillment {
    type: number
    hidden: no
    label: "% Contracted Hours Fulfillment"
    description: "Worked hours / (weekly_contracted_hours * number_of_weeks)"
    sql: ${number_of_worked_hours}/nullif(${weekly_contracted_hours}*${number_of_scheduled_weeks},0) ;;
    value_format: "0%"
  }

  measure: cnt_responses {
    label: "# NPS Responses"
    type: sum
    sql: ${TABLE}.number_of_nps_responses ;;
  }

  measure: cnt_detractors {
    label: "# Detractors"
    type: sum
    sql: ${TABLE}.number_of_detractors ;;
  }

  measure: cnt_promoters {
    label: "# Promoters"
    type: sum
    sql: ${TABLE}.number_of_promoters ;;
  }

  measure: pct_detractors{
    label: "% Detractors"
    description: "Share of Detractors over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_detractors} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }

  measure: pct_promoters{
    label: "% Promoters"
    description: "Share of Promoters over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_promoters} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }

  measure: nps_score{
    label: "% NPS"
    description: "NPS Score (After Order)"
    hidden:  no
    type: number
    sql: ${pct_promoters} - ${pct_detractors};;
    value_format: "0%"
  }

  measure: sum_nps_score {
    type: sum
    hidden: yes
    sql: ${TABLE}.sum_nps_score ;;
  }

  measure: avg_nps_score {
    type: number
    label: "AVG Customer NPS"
    sql: ${sum_nps_score}/nullif(${number_of_orders_with_available_nps_score},0) ;;
  }

}
