# Owner:   Omar Alshobaki
# Created: 2022-06-01
# This view contains daily aggregation of shift, Customer NPS and ops related kpis as well as employment info per distinct hub employee and position

view: employee_level_kpis {
  sql_table_name: `flink-data-prod.reporting.employee_level_kpis`
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
    description: "Based on Quinyx assinged shift type (null when an employee is not assgined any shift)"
    sql: ${TABLE}.position_name ;;
  }

  dimension: rider_id {
    type: string
    label: "Rider ID (old ID)"
    sql: ${TABLE}.rider_id ;;
  }

  dimension: auth0_id {
    type: string
    label: "Rider ID (auth0_id)"
    sql: ${TABLE}.auth0_id ;;
  }

  dimension: employment_id {
    type: string
    label: "Employee ID"
    sql: ${TABLE}.employment_id ;;
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
    description: "Based on Quinyx badgeNo field (Badge No)"
    sql: ${TABLE}.staff_number ;;
    value_format: "0"
  }

  dimension: acquisition_channel {
    type: string
    label: "Acquisition Channel"
    description: "Based on fountain field (utm source)"
    sql: ${TABLE}.acquisition_channel ;;
  }

  dimension: ats_id {
    type: string
    label: "ATS ID"
    description: "Based on fountain ID field (Applicant Tracking System ID)"
    sql: ${TABLE}.ats_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: external_agency_name {
    type: string
    label: "External Agency Name"
    description: "Based on Quinyx field (External Agency)"
    sql: ${TABLE}.external_agency_name ;;
  }

  dimension: fleet_type {
    type: string
    label: "Fleet Type"
    description: "Based on Quinyx data (Internal/Partnership/One-Time)"
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
    description: "Based on fountain hiring funnel (the date when an applicant transits to Creating Accounts or Approved stage)"
    sql: ${TABLE}.hire_date ;;
  }

  dimension: contract_start_date {
    label: "Contract Start Date"
    description: "Based on Quinyx Agreement field - Contract Start Date"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.contract_start_date ;;
  }

  dimension: contract_end_date {
    label: "Contract End Date"
    description: "Based on Quinyx Agreement field - Contract End Date"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.contract_end_date ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_external {
    type: yesno
    sql: ${TABLE}.is_external ;;
    description: "Based on Quinyx assinged shift (null when an employee is not assgined any shift)"
  }

  dimension: type_of_contract {
    type: string
    description: "Based on fountain data: full-time, part-time, min/max, 15, 30, etc (null when no matching ID between Quinyx and Fountain)"
    sql: ${TABLE}.type_of_contract ;;
  }

  dimension: weekly_contracted_hours {
    type: number
    sql: ${TABLE}.weekly_contracted_hours ;;
    description: "# Weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Agreement full time working hours)"
  }

  dimension: min_weekly_contracted_hours {
    type: number
    sql: ${TABLE}.min_weekly_contracted_hours ;;
    label: "MIN Weekly Contracted Hours"
    description: "# Minimum weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Rules for working time)"
  }

  dimension: max_weekly_contracted_hours {
    type: number
    sql: ${TABLE}.max_weekly_contracted_hours ;;
    label: "MAX Weekly Contracted Hours"
    description: "# Maximum weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Rules for working time)"
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


    # ~~~~~~~~~~~~~~~     Logistics     ~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: number_of_delivered_orders_by_riders {
    group_label: "* Logistics *"
    type: sum
    label: "# Delivered Orders by Riders"
    sql: ${TABLE}.number_of_delivered_orders ;;
    filters: [position_name: "rider"]
  }

  measure: number_of_delivered_orders {
    group_label: "* Logistics *"
    type: sum
    label: "# Delivered Orders"
    sql: ${TABLE}.number_of_delivered_orders ;;
  }

  measure: number_of_picked_items {
    group_label: "* Logistics *"
    type: sum
    label: "# Picked Items (Order items)"
    sql: ${TABLE}.number_of_picked_items ;;
  }

  measure: number_of_orders_with_handling_time {
    group_label: "* Logistics *"
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_orders_with_handling_time ;;
  }

  measure: number_of_products_with_damaged_products_issues_post {
    group_label: "* Logistics *"
    type: sum
    label: "# Products Damaged (Post Delivery)"
    description: "The number of products, that were damaged and were claimed through the Customer Service"
    sql: ${TABLE}.number_of_orders_with_damaged_products ;;
  }

  measure: number_of_orders_with_damaged_products{
    group_label: "* Logistics *"
    type: sum
    label: "# Orders with Products Damaged (Post Delivery)"
    description: "The number of Orders, with products that were damaged and were claimed through the Customer Service"
    sql: ${TABLE}.number_of_orders_with_damaged_products ;;
  }

  measure: pct_orders_with_damaged_products{
    group_label: "* Logistics *"
    type: number
    label: "% Delivered Orders with Products Damaged "
    description: "% Delivered Orders, with products that were damaged and were claimed through the Customer Service"
    sql: sum(${TABLE}.number_of_orders_with_damaged_products)/nullif(sum(${TABLE}.number_of_delivered_orders),0) ;;
    value_format_name: percent_1
  }

  measure: sum_worked_time_minutes {
    group_label: "* Shift related *"
    type: sum
    label: "# Worked Time (min)"
    description: "Sum worked time in minutes"
    sql: ${TABLE}.number_of_worked_minutes ;;
    value_format_name: decimal_1
  }

  measure: sum_worked_time_minutes_rider {
    group_label: "* Shift related *"
    type: sum
    label: "# Worked Time (min) Riders"
    hidden: yes
    description: "Sum worked time in minutes (Riders)"
    sql: ${TABLE}.number_of_worked_minutes ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
  }

  measure: sum_rider_handling_time_minutes {
    group_label: "* Logistics *"
    type: sum
    label: "# Rider Handling Time (min)"
    description: "Sum time needed for the rider to handle the order: Riding to customer + At customer + Riding to hub"
    sql: ${TABLE}.number_of_rider_handling_time_minutes ;;
    value_format_name: decimal_1
  }


  measure: sum_rider_idle_time_minutes {
    group_label: "* Performance *"
    type: sum
    label: "# Rider Idle Time (min)"
    description: "Sum of idle time (min) - the difference between worked minutes and rider handling time minutes"
    sql: ${TABLE}.number_of_idle_minutes ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
  }

  measure: sum_picking_time_minutes {
    group_label: "* Logistics *"
    type: sum
    label: "Sum Picking Time (min)"
    description: "Sum time needed for picking items per order"
    sql: ${TABLE}.number_of_picking_time_minutes ;;
    value_format_name: decimal_1
    hidden: yes

  }

  measure: avg_rider_handling_time_minutes {
    group_label: "* Logistics *"
    type: number
    label: "AVG Rider Handling Time (min)"
    description: "Average time needed for the rider to handle the order: Riding to customer + At customer + Riding to hub"
    sql: ${sum_rider_handling_time_minutes}/nullif(${number_of_orders_with_handling_time},0) ;;
    value_format_name: decimal_1
  }

  measure: avg_picking_time_order {
    group_label: "* Logistics *"
    type: number
    label: "AVG Picking Time Per Order (min)"
    description: "Average time needed for picking items per order"
    sql: ${sum_picking_time_minutes}/nullif(${number_of_delivered_orders},0) ;;
    value_format_name: decimal_1
  }

  measure: avg_picking_time_item {
    group_label: "* Logistics *"
    type: number
    label: "AVG Picking Time Per Item (min)"
    description: "Average time needed for picking items"
    sql: ${sum_picking_time_minutes}/nullif(${number_of_picked_items},0) ;;
    value_format_name: decimal_1
  }

  measure: sum_riding_to_hub_minutes {
    group_label: "* Logistics *"
    type: sum
    label: "Sum Riding to Hub time (min)"
    description: "Sum Riding time from customer location back to the hub (<1min or >30min)."
    sql: ${TABLE}.number_of_return_to_hub_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_riding_to_hub_minutes {
    group_label: "* Logistics *"
    type: number
    label: "AVG Riding to Hub time (min)"
    description: "Average Riding time from customer location back to the hub (<1min or >30min)."
    sql: ${sum_riding_to_hub_minutes}/nullif(${number_of_orders_with_handling_time},0) ;;
    value_format_name: decimal_1
  }

  measure: sum_riding_to_customer_time_minutes {
    group_label: "* Logistics *"
    type: sum
    label: "Sum Riding To Customer Time (min)"
    description: "Sum riding to customer time considering delivery start to arrival at customer. Outliers excluded (<1min or >30min)"
    sql: ${TABLE}.number_of_riding_to_customer_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_riding_to_customer_time_minutes {
    group_label: "* Logistics *"
    type: number
    label: "AVG Riding To Customer Time (min)"
    description: "Average riding to customer time considering delivery start to arrival at customer. Outliers excluded (<1min or >30min)"
    sql: ${sum_riding_to_customer_time_minutes}/nullif(${number_of_orders_with_handling_time},0) ;;
    value_format_name: decimal_1
  }

  measure: sum_at_customer_time_minutes {
    group_label: "* Logistics *"
    type: sum
    label: "Sum At Customer Time (min)"
    description: "Sum Time the Rider spent at the customer between arrival and order completion confirmation"
    sql: ${TABLE}.number_of_at_customer_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_at_customer_time_minutes {
    group_label: "* Logistics *"
    type: number
    label: "AVG At Customer Time (min)"
    description: "Average Time the Rider spent at the customer between arrival and order completion confirmation"
    sql: ${sum_at_customer_time_minutes}/nullif(${number_of_orders_with_handling_time},0) ;;
    value_format_name: decimal_1
  }


  measure: pct_riding_to_customer_time {
    group_label: "* Logistics *"
    type: number
    label: "% Riding To Customer Time"
    description: "Riding to Customer Time / Riding Time (To Customer + Back To Hub) e.g. a rider spent 5 minutes riding between hub to customer then spend another 5 minutes riding between customer to hub then that will result in % Riding To Customer Time to be 50% "
    sql: sum(${TABLE}.number_of_riding_to_customer_time_minutes) / nullif(sum(${TABLE}.number_of_riding_to_customer_time_minutes + ${TABLE}.number_of_return_to_hub_time_minutes),0)  ;;
    value_format: "0%"
  }

  measure: pct_riding_back_to_hub_time {
    group_label: "* Logistics *"
    type: number
    label: "% Riding Back To Hub Time"
    description: "Riding Back to Hub Time / Riding Time (To Customer + Back To Hub) e.g. a rider spent 5 minutes riding between hub to customer then spend another 5 minutes riding between customer to hub then that will result in % Riding Back To Hub Time to be 50%"
    sql: sum(${TABLE}.number_of_return_to_hub_time_minutes) / nullif(sum(${TABLE}.number_of_riding_to_customer_time_minutes + ${TABLE}.number_of_return_to_hub_time_minutes),0)  ;;
    value_format: "0%"
  }

  measure: pct_delta_between_to_hub_and_to_customer_time{
    group_label: "* Logistics *"
    type: number
    label: "% Delta Riding Time Between To Hub and To Customer"
    description: "% Difference Riding time between To Hub and To Customer (positive value indicates Time To Hub > Time To Customer) e.g. a rider spent 5 minutes riding between hub to customer then spend another 5 minutes riding between customer to hub then that will result in % Delta Riding Time Between To Hub and To Customer to be 0%"
    sql: sum(${TABLE}.number_of_return_to_hub_time_minutes) / nullif(sum(${TABLE}.number_of_riding_to_customer_time_minutes),0) -1 ;;
    value_format_name: percent_1
  }

  measure: pct_rider_idle_time {
    group_label: "* Performance *"
    type: number
    label: "% Worked Time Spent Idle (Riders)"
    description: "% of worked time (min) not spent handling an order - compares the difference between worked time (min) and rider handling time (min) with total worked time (min)"
    sql: ${sum_rider_idle_time_minutes} / nullif(${sum_worked_time_minutes_rider},0) ;;
    value_format: "0%"
  }

  # ~~~~~~~~~~~~~~~     Shift related     ~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: number_of_scheduled_weeks {
    group_label: "* Shift related *"
    type: number
    hidden: no
    sql:
      CASE
        WHEN date_DIFF( safe_cast(max(${shift_date}) as date),safe_cast(min(${shift_date}) as date), week) = 0 THEN 1
        ELSE date_DIFF( safe_cast(max(${shift_date}) as date),safe_cast(min(${shift_date}) as date), week)
      END ;;
  }

  measure: last_worked_date {
    group_label: "* Shift related *"
    type: date
    description: "Date of the last worked/punched shift"
    sql: max(case when ${TABLE}.number_of_worked_minutes > 0 then ${TABLE}.shift_date end);;
  }

  measure: first_worked_date {
    group_label: "* Shift related *"
    type: date
    description: "Date of the first worked/punched shift"
    sql: min(case when ${TABLE}.number_of_worked_minutes > 0 then ${TABLE}.shift_date end);;
  }

  measure: number_of_scheduled_hours {
    group_label: "* Shift related *"
    type: sum
    label: "# Scheduled Hours"
    sql: ${TABLE}.number_of_planned_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_sick_hours {
    group_label: "* Shift related *"
    type: sum
    label: "# Sickness Hours"
    sql: ${TABLE}.number_of_sick_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_early_punched_out_minutes {
    group_label: "* Shift related *"
    type: sum
    label: "# Early Punched-Out (min)"
    description: "Number of Early Punch-Out Minutes where employee punch-out early before a shift ends e.g. a shift is scheduled to end at 10 pm but an employee punches out at 09:45 will results in 15 minutes early punch-out"
    sql: ${TABLE}.number_of_end_early_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_late_punched_out_minutes {
    group_label: "* Shift related *"
    type: sum
    label: "# Late Punched-Out (min)"
    description: "Number of Late Punch-Out Minutes where employee punch-out late after a shift ends e.g. a shift is scheduled to end at 10 pm but an employee punches out at 10:15 will results in 15 minutes late punch-out"
    sql: ${TABLE}.number_of_end_late_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_early_punched_in_minutes {
    group_label: "* Shift related *"
    type: sum
    label: "# Early Punched-In (min)"
    description: "Number of Early Punch-In Minutes where employee punch-in early before a shift starts e.g. a shift is scheduled to start at 8 am but an employee punches in at 7:45 will results in 15 minutes early punch-in"
    sql: ${TABLE}.number_of_start_early_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_late_punched_in_minutes {
    group_label: "* Shift related *"
    type: sum
    label: "# Late Punched-In (min)"
    description: "Number of Late Punch-In Minutes where employee punch-in late after a shift starts e.g. a shift is scheduled to start  at 8 am but an employee punches in at 8:15 will results in 15 minutes late punch-in"
    sql: ${TABLE}.number_of_start_late_minutes ;;
    value_format_name: decimal_1
  }

  measure: pct_latess {
    group_label: "* Shift related *"
    type: number
    label: "% Lateness (> 5 min)"
    description: "% of Lateness shift (> 5 minutes late punch-in) e.g. e.g. a 4 hours shift is scheduled to start at 8 am but an employee punches in at 9:00 will results in 25% late (1 hour late / 4 hours shift duration )"
    sql: sum(case when ${TABLE}.number_of_start_late_minutes > 5
              then ${TABLE}.number_of_start_late_minutes end)/nullif(sum(${TABLE}.number_of_planned_minutes),0)  ;;
    value_format_name: percent_1
  }

  measure: avg_late_punched_in_minutes {
    group_label: "* Shift related *"
    type: average
    label: "AVG Late Punched-In (min)"
    description: "AVG Employee Late Punch-In Minutes where employee punch-in late after a shift starts e.g. a shift is scheduled to start  at 8 am but an employee punchs in at 8:15 will results in 15 minutes late punch-in"
    sql: ${TABLE}.number_of_start_late_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours {
    group_label: "* Shift related *"
    type: sum
    label: "# Worked Hours"
    sql: ${TABLE}.number_of_worked_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours {
    group_label: "* Shift related *"
    type: sum
    label: "# No Show Hours"
    sql: ${TABLE}.number_of_no_show_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: avg_rider_utr {
    group_label: "* Logistics *"
    type: number
    label: "AVG Rider UTR"
    sql: ${number_of_delivered_orders}/nullif(${number_of_worked_hours},0) ;;
    value_format_name: decimal_1
  }

  measure: pct_no_show_hours {
    group_label: "* Shift related *"
    type: number
    hidden: no
    label: "% No Show Hours "
    sql: ${number_of_no_show_hours}/nullif(${number_of_scheduled_hours},0) ;;
    value_format: "0%"
  }

  measure: pct_sickness_hours {
    group_label: "* Shift related *"
    type: number
    hidden: no
    label: "% Sickness Hours "
    description: "Sickness hours / (Sickness hours + Scheduled hours)"
    sql: (${number_of_sick_hours})/nullif(${number_of_sick_hours}+${number_of_scheduled_hours},0) ;;
    value_format: "0%"
  }

  measure: dimensional_weekly_contracted_hours {
    type: sum_distinct
    sql: ${TABLE}.weekly_contracted_hours ;;
    sql_distinct_key: ${employment_id} ;;
    hidden: yes
    description: "# Weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Agreement full time working hours)"
  }

  measure: sum_weekly_contracted_hours {
    label: "Total Weekly Contracted Hours"
    group_label: "* Contract related *"
    type: number
    sql: ${dimensional_weekly_contracted_hours} * ${number_of_scheduled_weeks} ;;
    description: "Sum of weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Agreement full time working hours) - # Weekly Contracted Hours * # Scheduled Weeks"
  }

  measure: pct_contract_fulfillment {
    group_label: "* Shift related *"
    type: number
    hidden: no
    label: "% Contracted Hours Fulfillment"
    description: "Worked hours / (weekly_contracted_hours * number_of_weeks)"
    sql: ${number_of_worked_hours}/nullif(${sum_weekly_contracted_hours},0) ;;
    value_format: "0%"
  }

  # ~~~~~~~~~~~~~~~     NPS     ~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: cnt_responses {
    group_label: "* NPS *"
    label: "# NPS Responses"
    type: sum
    sql: ${TABLE}.number_of_nps_responses ;;
  }

  measure: cnt_detractors {
    group_label: "* NPS *"
    label: "# Detractors"
    type: sum
    sql: ${TABLE}.number_of_detractors ;;
  }

  measure: cnt_promoters {
    group_label: "* NPS *"
    label: "# Promoters"
    type: sum
    sql: ${TABLE}.number_of_promoters ;;
  }

  measure: pct_detractors{
    group_label: "* NPS *"
    label: "% Detractors"
    description: "Share of Detractors over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_detractors} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }

  measure: pct_promoters{
    group_label: "* NPS *"
    label: "% Promoters"
    description: "Share of Promoters over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_promoters} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }

  measure: nps_score{
    group_label: "* NPS *"
    label: "% NPS"
    description: "NPS Score (After Order)"
    hidden:  no
    type: number
    sql: ${pct_promoters} - ${pct_detractors};;
    value_format: "0%"
  }

  measure: sum_nps_score {
    group_label: "* NPS *"
    type: sum
    hidden: yes
    sql: ${TABLE}.sum_nps_score ;;
  }

  measure: avg_nps_score {
    group_label: "* NPS *"
    type: number
    label: "AVG Customer NPS"
    sql: ${sum_nps_score}/nullif(${cnt_responses},0) ;;
  }

}
