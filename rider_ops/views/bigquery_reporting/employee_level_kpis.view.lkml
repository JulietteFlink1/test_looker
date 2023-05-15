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
    group_label: "> Position Name"
    type: string
    label: "Scheduled Position Name"
    description: "Based on Quinyx assinged shift type (null when an employee is not assgined any shift)"
    sql: ${TABLE}.position_name ;;
  }

  dimension: assigned_position_name {
    group_label: "> Position Name"
    type: string
    label: "Assigned Position Name"
    description: "Based on Quinyx staff category assinged to each employee profile"
  }

  dimension: number_of_picking_time_minutes {
    type: number
    label: "Number of Picking Time Minutes"
    description: "Number of minutes spent picking based on the Hub One app data."
    sql: ${TABLE}.number_of_picking_time_minutes ;;
    hidden: yes
  }

  dimension: rider_id {
    group_label: "> IDs"
    type: string
    label: "Rider ID (old ID)"
    sql: ${TABLE}.rider_id ;;
  }

  dimension: auth0_id {
    group_label: "> IDs"
    type: string
    label: "Rider ID (auth0_id)"
    sql: ${TABLE}.auth0_id ;;
  }

  dimension: employment_id {
    group_label: "> IDs"
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
      day_of_week,
      day_of_week_index,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    group_label: "> Dates & Timestamps"
    sql: ${TABLE}.shift_date ;;
  }

  dimension: staff_number {
    group_label: "> IDs"
    type:  number
    label: "Staff Number"
    description: "Based on Quinyx badgeNo field (Badge No)"
    sql: ${TABLE}.staff_number ;;
    value_format: "0"
  }

  dimension: acquisition_channel {
    group_label: "> Contract"
    type: string
    label: "Acquisition Channel"
    description: "Based on fountain field (utm source)"
    sql: ${TABLE}.acquisition_channel ;;
  }

  dimension: ats_id {
    group_label: "> IDs"
    type: string
    label: "ATS ID"
    description: "Based on fountain ID field (Applicant Tracking System ID)"
    sql: ${TABLE}.ats_id ;;
  }


  dimension: external_agency_name {
    group_label: "> Contract"
    type: string
    label: "External Agency Name"
    description: "Based on Quinyx field (External Agency)"
    sql:
      case
        when regexp_contains(lower(${TABLE}.external_agency_name), 'talent')
          then 'Job & Talent'
        when regexp_contains(lower(${TABLE}.external_agency_name), 'staff')
          then 'Staffmatch'
        when regexp_contains(lower(${TABLE}.external_agency_name), 'vlove|volve')
          then 'Vlove'
        when regexp_contains(lower(${TABLE}.external_agency_name), 'coursier')
          then 'Coursierfr'
        when regexp_contains(lower(${TABLE}.external_agency_name), 'lecastor')
          then 'Lecastor'
        when regexp_contains(lower(${TABLE}.external_agency_name), 'qapa')
          then 'Qapa'
        when regexp_contains(lower(${TABLE}.external_agency_name), 'zj')
          then 'Zenjob'
        else initcap(${TABLE}.external_agency_name)
      end;;
  }



  dimension: fleet_type {
    group_label: "> Contract"
    type: string
    label: "Fleet Type"
    description: "Based on Quinyx data (Internal/Partnership/One-Time)"
    sql: ${TABLE}.fleet_type ;;
  }

  dimension_group: hire {
    group_label: "> Dates & Timestamps"
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
    description: "Hire date based on BambooHR (old HR tool)"
    sql: ${TABLE}.hire_date ;;
  }

  dimension_group: last_update {
    type: time
    timeframes: [
      time,
      hour,
      minute
    ]
    convert_tz: yes
    datatype: datetime
    sql: ${TABLE}.last_updated_timestamp ;;
  }

  dimension: contract_start_date {
    group_label: "> Dates & Timestamps"
    label: "Contract Start Date"
    description: "Based on Quinyx Agreement field - contract start date"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.contract_start_date ;;
  }

  dimension: contract_end_date {
    group_label: "> Dates & Timestamps"
    label: "Contract End Date"
    description: "Based on Quinyx agreement field - contract end date"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.contract_end_date ;;
  }

  dimension: employment_end_date {
    group_label: "> Dates & Timestamps"
    label: "Employment End Date"
    description: "Based on Quinyx 'To' field for inactive employees (Employed field unchecked) - 1 day. Defines 'is_active' field."
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.employment_end_date ;;
  }

  dimension: last_planned_date {
    group_label: "> Dates & Timestamps"
    label: "Last Planned Date"
    description: "Date of the last shift defined as 'Planned' (type = Assigned)"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.last_planned_date ;;
  }

  dimension: last_worked_date_dimension {
    group_label: "> Dates & Timestamps"
    label: "Last Worked Date"
    description: "Date of the last shift defined as 'Worked' (type = Assigned and status = Done evaluation)"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.last_worked_date ;;
  }

  dimension: last_absence_date {
    group_label: "> Dates & Timestamps"
    label: "Last Absence Date"
    description: "Date of the last shift defined as 'Absence' (type = Absence and status != Denied)"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.last_absence_date ;;
  }

  dimension: last_shift_date {
    group_label: "> Dates & Timestamps"
    label: "Last Shift Date"
    description: "Date of the last shift"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.last_shift_date ;;
  }

  dimension: first_shift_date {
    group_label: "> Dates & Timestamps"
    label: "First Shift Date"
    description: "Date of the first shift"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.first_shift_date ;;
  }

  dimension: last_justified_absence_date {
    group_label: "> Dates & Timestamps"
    label: "Last Justified Absence Date"
    description: "Date of the last absence with leave reason containing the word 'sick' or 'wait' or 'arrêt' or 'vacation'"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.last_justified_absence_date ;;
  }

  dimension: last_shift_worked_or_justified_shift_date {
    group_label: "> Dates & Timestamps"
    label: "Last shift (Punched shift or Absence)"
    description: "Date of the last Punched shift or absence with leave reason containing the word 'sick' or 'wait' or 'arrêt' or 'vacation'"
    convert_tz: no
    datatype: date
    type: date
    sql: nullif(
             greatest(
              coalesce(${last_worked_date_dimension}, '1990-01-01'),
              coalesce(${last_justified_absence_date}, '1990-01-01')
            ),
            '1990-01-01'
         );;
  }

  dimension_group: duration_between_last_worked_shift_and_shift_date {
    group_label: "> Dates & Timestamps"
    type: duration
    intervals: [day, week, year]
    label: "Duration between last worked shift date and shift date"
    description: "Number of days between last worked (punched) shift and shift date (NULL if last worked date is after shift date)"
    sql_start:case
          when ${shift_date} > ${last_worked_date_dimension}
          then ${last_worked_date_dimension}
          else ${shift_date} end;;
          # If an employee never had any worked shift this metric should retrun null.
          # Therefore we need to need to default the value in sql_end to null to avoid return 0
    sql_end: case when ${last_worked_date_dimension} is not null then ${shift_date} end;;
  }

  dimension_group: duration_between_last_shift_and_shift_date {
    group_label: "> Dates & Timestamps"
    type: duration
    intervals: [day, week, year]
    label: "Duration between last shift (Punched shift or Absence) and shift date"
    description: "Number of days between last worked (punched) shift or absence and shift date (NULL if last shift date is after shift date)"
    sql_start:case
          when ${shift_date} > ${last_shift_worked_or_justified_shift_date}
          then ${last_shift_worked_or_justified_shift_date}
          else ${shift_date} end;;
          # If an employee never had any worked or justified shift this metric should retrun null.
          # Therefore we need to need to default the value in sql_end to null to avoid return 0
    sql_end:case when ${last_worked_date_dimension} is not null then ${shift_date} end;;
  }

  dimension_group: duration_between_last_worked_shift_and_today {
    group_label: "> Dates & Timestamps"
    type: duration
    intervals: [day, week, year]
    label: "Duration between last worked shift and today"
    description: "Number of days between last worked (punched) shift date and today"
    sql_start:${last_worked_date_dimension};;
    sql_end: current_date ;;
  }

  dimension: account_creation_date {
    group_label: "> Dates & Timestamps"
    label: "Account Creation Date"
    description: "Date of Quinyx account creation"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.account_creation_date ;;
  }

  dimension: employment_start_date {
    group_label: "> Dates & Timestamps"
    label: "Employment Start Date"
    description: "Start date of first employment contract (Agreement in Quinyx UI)"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.employment_start_date ;;
  }

  dimension: is_active {
    group_label: "> Contract"
    type: yesno
    sql: ${TABLE}.is_active ;;
    label: "Is Active"
    description: "Shows if an employee is active (employed) or not. Based on employment end date which is defined in Quinyx ('To' Field for an employee - 1 day)"
  }

  dimension: hub_code {
    type: string
    hidden: yes
    sql: ${TABLE}.hub_code ;;
  }

  dimension: home_hub_code {
    type: string
    hidden: yes
    sql: ${TABLE}.home_hub_code ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_employed {
    group_label: "> Contract"
    type: yesno
    sql: ${TABLE}.is_employed ;;
    label: "Is Employed"
    description: "Is shift date between employment start date and employment end date ?"
  }

  dimension: is_external {
    group_label: "> Contract"
    type: yesno
    sql: ${TABLE}.is_external ;;
    label: "Is External Employee"
    description: "Based on Quinyx assinged shift (null when an employee is not assgined any shift)"
  }

  parameter: avaiability_overlap_parameter {
    type: yesno
    label: "Is Assigned Shift 100% overlapping with Availability ?"
    description: "Yes if the assigned shift fully overlaps (100%) with the availability provided by the employee."
  }

  dimension: type_of_contract {
    group_label: "> Contract"
    type: string
    description: "Based on fountain data: full-time, part-time, min/max, 15, 30, etc (null when no matching ID between Quinyx and Fountain)"
    sql: ${TABLE}.type_of_contract ;;
  }

  dimension: weekly_contracted_hours {
    group_label: "> Contract"
    type: number
    sql: ${TABLE}.weekly_contracted_hours ;;
    description: "# Weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Agreement full time working hours)"
  }

  dimension: min_weekly_contracted_hours {
    group_label: "> Contract"
    type: number
    sql: ${TABLE}.min_weekly_contracted_hours ;;
    label: "MIN Weekly Contracted Hours"
    description: "# Minimum weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Rules for working time)"
  }

  dimension: max_weekly_contracted_hours {
    group_label: "> Contract"
    type: number
    sql: ${TABLE}.max_weekly_contracted_hours ;;
    label: "MAX Weekly Contracted Hours"
    description: "# Maximum weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Rules for working time)"
    }

  dimension_group: time_between_hire_date_and_today {
    type: duration
    intervals: [day, week, year]
    label: "Duration between hire date and today"
    sql_start: coalesce(timestamp(${TABLE}.hire_date), timestamp(${TABLE}.employment_start_date)) ;;
    sql_end: current_timestamp ;;
    group_label: "> Dates & Timestamps"
    description: "Duration between hire date and today (if hire date is not existing then consider Employment Start Date instead)"
  }

  dimension_group: time_between_hire_date_and_shift_date {
    type: duration
    intervals: [day, week, year]
    label: "Duration between hire date and shift date"
    sql_start: coalesce(timestamp(${TABLE}.hire_date), timestamp(${TABLE}.employment_start_date)) ;;
    sql_end: timestamp(${shift_date}) ;;
    group_label: "> Dates & Timestamps"
    description: "Duration between hire date and shift date (if hire date is not existing then consider Employment Start Date instead)"
  }

  dimension: number_of_planned_minutes_availability_based {
    type: number
    hidden: yes
    sql: case
          when {% parameter avaiability_overlap_parameter %} = true
          and  ${TABLE}.number_of_planned_minutes_availability_based != ${TABLE}.number_of_planned_minutes
            then 0
          else ${TABLE}.number_of_planned_minutes_availability_based
          end;;
    value_format_name: decimal_1
  }

  dimension: number_of_picked_orders {
    type: number
    sql: ${TABLE}.number_of_picked_orders ;;
    hidden: yes
  }

  dimension: number_of_reported_items {
    type: number
    sql: ${TABLE}.number_of_reported_items ;;
    hidden: yes
  }

  dimension: number_of_ordered_items {
    type: number
    sql: ${TABLE}.number_of_ordered_items ;;
    hidden: yes
  }

  dimension: number_of_ordered_items_excluding_external_orders {
    type: number
    sql: ${TABLE}.number_of_ordered_items_excluding_external_orders ;;
    hidden: yes
  }

  dimension: number_of_orders_with_perished_products {
    type: number
    sql: ${TABLE}.number_of_orders_with_perished_products ;;
    hidden: yes
  }

  dimension: number_of_orders_with_wrong_products {
    type: number
    sql: ${TABLE}.number_of_orders_with_wrong_products ;;
    hidden: yes
  }

  dimension: number_of_orders_with_missing_products {
    type: number
    sql: ${TABLE}.number_of_orders_with_missing_products ;;
    hidden: yes
  }

  dimension: number_of_picked_orders_excluding_external_orders {
    type: number
    sql: ${TABLE}.number_of_picked_orders_excluding_external_orders ;;
    hidden: yes
  }

  # Adding a UTR-like dimension in order to build tiered graphs based on their performance. Might be different from the "Normal UTR", only needed for tiering.
  dimension: number_of_delivered_orders_per_worked_hour {
    type: number
    sql: ${TABLE}.number_of_delivered_orders/(nullif(${TABLE}.number_of_worked_minutes,0)/60) ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_delivered_orders_per_worked_hour_tiered {
    group_label: "> Logistics"
    label: "Shift-based UTR, Tiered"
    type: tier
    tiers: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4, 2.6, 2.8, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2, 4.4, 4.6, 4.8, 5.0, 5.2, 5.4, 5.6, 5.8, 6.0, 7.0, 8.0]
    sql: ${number_of_delivered_orders_per_worked_hour} ;;
    value_format_name: decimal_1
    style: interval
  }

  dimension: number_of_overtime_minutes {
    type: number
    label: "# Overpunched Hours"
    sql: ${TABLE}.number_of_overtime_minutes;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_unjustified_start_early_minutes {
    type: number
    label: "# Unjustified Early Overpunched Minutes"
    # To show null values as null, we need to sum in sql
    sql: ${TABLE}.number_of_unjustified_start_early_minutes;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_unjustified_end_late_minutes {
    type: number
    label: "# Unjustified Late Overpunched Minutes"
    # To show null values as null, we need to sum in sql
    sql: ${TABLE}.number_of_unjustified_end_late_minutes;;
    value_format_name: decimal_1
    hidden: yes
  }

  ###### CPO Dimensions

  dimension: number_of_sick_minutes_payroll {
    type: number
    label: "# Sick Minutes"
    description: "Number of paid sick minutes. (excluding absences defined as no shows)"
    sql: ${TABLE}.number_of_sick_minutes_payroll ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_vacation_minutes_payroll {
    type: number
    label: "# Vacation Minutes"
    description: "Number of paid vacation minutes."
    sql: ${TABLE}.number_of_vacation_minutes_payroll ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_public_holiday_hours {
    type: number
    label: "# Public Holiday Hours"
    description: "Number of public holiday hours during the shift period. Calculated as AVG Daily Contracted Hours * Public holiday days."
    sql: ${TABLE}.number_of_public_holiday_hours ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_paid_minutes {
    type: number
    label: "# Worked Minutes"
    sql: ${TABLE}.number_of_worked_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_premium_worked_minutes {
    type: number
    label: "# Premium Worked Minutes (Weekend nigh shifts)"
    description: "Number of punched hours during the weekends after 22:00."
    sql: ${TABLE}.number_of_premium_worked_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_premium_worked_minutes_as_ops_associate_plus {
    type: number
    label: "# Premium Worked Minutes (Ops Associate +)"
    description: "Number of punched minutes with 'ops associate +' or 'deputy shift lead' position. It happens when employees with different positions work as a shift lead."
    sql: ${TABLE}.number_of_premium_worked_minutes_as_ops_associate_plus ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: amt_signon_bonus_gross {
    type: number
    label: "Gross Sign On Bonus Amount"
    sql: ${TABLE}.amt_signon_bonus_gross ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: amt_referral_bonus_net {
    type: number
    label: "Net Referral Bonus Amount"
    sql: ${TABLE}.amt_referral_bonus_net ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: hourly_rate {
    group_label: "> Payroll"
    type: number
    label: "Hourly Rate"
    description: "The amount of hourly wage based on SAP data."
    sql: ${TABLE}.hourly_rate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: pct_fringe {
    group_label: "> Payroll"
    type: number
    label: "% Fringe"
    description: " The estimated rate of employer-related social contributions that are mandatory contributions
      for employers. Employers are required to pay it as a percentage of their their employees' gross salaries to various social security programs"
    sql: ${TABLE}.pct_fringe ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: amt_byod_bonus_net {
    group_label: "> Payroll"
    type: number
    label: "AMT BYOD Bonus"
    description: "Net bonus amount paid to riders for bringing and using their own devices."
    sql: ${TABLE}.amt_byod_bonus_net ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_hub_one_tasks_minutes {
    type: number
    label: "# Hub One Tasks Minutes"
    sql: ${TABLE}.number_of_rider_hub_one_tasks_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_equipment_issue_minutes {
    type: number
    label: "# Equipment Issue Minutes"
    sql: ${TABLE}.number_of_rider_equipment_issue_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_large_order_support_minutes {
    type: number
    label: "# Large Order Support Minutes"
    sql: ${TABLE}.number_of_rider_large_order_support_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_accident_minutes {
    type: number
    label: "# Accident Minutes"
    sql: ${TABLE}.number_of_rider_accident_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_temporary_offline_break_minutes {
    type: number
    label: "# Temporary Offline Break Minutes"
    sql: ${TABLE}.number_of_rider_temporary_offline_break_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_total_temporary_offline_minutes {
    type: number
    label: "# Total Temporary Offline Minutes"
    sql: ${TABLE}.number_of_rider_total_temporary_offline_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_unresponsive_minutes {
    type: number
    label: "# Unresponsive Minutes"
    sql: ${TABLE}.number_of_rider_unresponsive_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_other_temporary_offline_minutes {
    type: number
    label: "# Other Temporary Offline Minutes"
    sql: ${TABLE}.number_of_rider_other_temporary_offline_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_idle_minutes {
    type: number
    label: "# Idle Minutes"
    sql: ${TABLE}.number_of_rider_idle_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_idle_minutes_quinyx {
    type: number
    label: "# Idle Minutes - Quinyx"
    sql: ${TABLE}.number_of_idle_minutes_quinyx ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_waiting_for_rider_decision_time_minutes {
    type: number
    label: "# Waiting For Rider Decision Time (min)"
    sql: ${TABLE}.number_of_waiting_for_rider_decision_time_minutes ;;
    value_format_name: decimal_1
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    # ~~~~~~~~~~~~~~~     Logistics     ~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: number_of_delivered_orders_by_riders {
    group_label: "> Logistics"
    type: sum
    label: "# Delivered Orders by Riders"
    sql: ${TABLE}.number_of_delivered_orders ;;
    filters: [position_name: "rider"]
  }

  measure: number_of_delivered_orders {
    group_label: "> Logistics"
    type: sum
    label: "# Delivered Orders"
    sql: ${TABLE}.number_of_delivered_orders ;;
  }

  measure: number_of_picked_items {
    group_label: "> Logistics"
    type: sum
    description: "Number of picked items. Based on Hub One app tracking data."
    label: "# Picked Items"
    sql: ${TABLE}.number_of_picked_items ;;
  }

  measure: sum_number_of_picked_orders {
    group_label: "> Logistics"
    description: "Number of picked orders. Based on Hub One app tracking data."
    type: sum
    label: "# Picked Orders"
    sql: ${number_of_picked_orders} ;;
  }

  measure: sum_number_of_picked_orders_excluding_external_orders {
    group_label: "> Logistics"
    label: "# Picked Orders (Internal)"
    description: "Number of picked internal orders. Based on Hub One app tracking data. Used to calculate post delivery issue rates."
    type: sum
    sql: ${number_of_picked_orders_excluding_external_orders} ;;
  }

  measure: sum_number_of_ordered_items_excluding_external_orders {
    group_label: "> Logistics"
    description: "Number of ordered items (sum of item quantity ordered). Based on CT order data. Excludes external orders. Will be used to calculate post delivery issue rate."
    type: sum
    label: "# Ordered Items (Internal Orders)"
    sql: ${number_of_ordered_items_excluding_external_orders} ;;
    hidden: yes
  }

  measure: sum_number_of_reported_items {
    group_label: "> Logistics"
    label: "# EAN Swapped"
    description: "Items that were not recognized during picking scanning process. Due to damaged or wrong code. Based on Hub One data."
    type: sum
    sql: ${number_of_reported_items} ;;
  }

  measure: number_of_orders_with_handling_time {
    group_label: "> Logistics"
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_orders_with_handling_time ;;
  }

  measure: number_of_orders_with_customer_address {
    group_label: "> Logistics"
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_orders_with_customer_address ;;
  }

  measure: number_of_orders_with_riding_to_customer_time {
    group_label: "> Logistics"
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_orders_with_riding_to_customer_time ;;
  }

  measure: number_of_orders_with_riding_to_hub_time {
    group_label: "> Logistics"
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_orders_with_riding_to_hub_time ;;
  }

  measure: number_of_products_with_damaged_products_issues_post {
    group_label: "> Logistics"
    type: sum
    label: "# Products with Damaged Issues. (Post-delivery)"
    description: "The number of products, that were damaged and were claimed through the Customer Service. Available for hub staff and rider positions"
    sql: ${TABLE}.number_of_orders_with_damaged_products ;;
  }

  measure: number_of_orders_with_damaged_products{
    group_label: "> Logistics"
    type: sum
    label: "# Orders with Products Damaged (Post Delivery)"
    description: "The number of Orders, with products that were damaged and were claimed through the Customer Service. Available for hub staff and rider positions."
    sql: ${TABLE}.number_of_orders_with_damaged_products ;;
  }

  measure: number_of_products_with_missing_products_issues{
    group_label: "> Logistics"
    type: sum
    label: "# Products with Missing Issues"
    description: "The number of missing products. Available only for hub staff positions."
    sql: ${TABLE}.number_of_products_with_missing_products_issues ;;
  }

  measure: number_of_products_with_wrong_products_issues{
    group_label: "> Logistics"
    type: sum
    label: "# Products with Wrong Issues"
    description: "The number of wrong products. Available only for hub staff positions."
    sql: ${TABLE}.number_of_products_with_wrong_products_issues ;;
  }

  measure: number_of_products_with_perished_issues_post{
    group_label: "> Logistics"
    type: sum
    label: "# Products with Perished Issues"
    description: "The number of perished products. Available only for hub staff positions."
    sql: ${TABLE}.number_of_products_with_perished_issues_post ;;
  }

  measure: number_of_products_with_pre_delivery_issues{
    group_label: "> Logistics"
    type: sum
    label: "# Products with Pre-delivery Issues"
    description: "The number of products having issues before delivery. Available only for hub staff positions."
    sql: ${TABLE}.number_of_products_with_pre_delivery_issues ;;
  }

  measure: number_of_products_with_post_delivery_issues{
    group_label: "> Logistics"
    type: sum
    label: "# Products with Post-delivery Issues"
    description: "The number of products having issues after delivery and were claiumed through Customer Service. Available only for hub staff positions."
    sql: ${TABLE}.number_of_products_with_post_delivery_issues ;;
  }

  measure: number_of_orders_with_pre_delivery_issues{
    group_label: "> Logistics"
    type: sum
    label: "# Orders with Pre-delivery Issues"
    description: "The number of Orders having issues before delivery. Available only for hub staff positions."
    sql: ${TABLE}.number_of_orders_with_pre_delivery_issues ;;
  }

  measure: number_of_orders_with_post_delivery_issues{
    group_label: "> Logistics"
    type: sum
    label: "# Orders with Post-delivery Issues"
    description: "The number of Orders having issues after delivery and were claimed through the Customer Service. Available only for hub staff positions."
    sql: ${TABLE}.number_of_orders_with_post_delivery_issues ;;
  }

  measure: sum_number_of_orders_with_perished_products {
    group_label: "> Logistics"
    type: sum
    label: "# Orders with Perished Product Issues"
    description: "Number of Orders with at least one perished product issue. Only available for hub staff positions."
    sql: ${number_of_orders_with_perished_products} ;;
  }

  measure: sum_number_of_orders_with_wrong_products {
    group_label: "> Logistics"
    type: sum
    label: "# Orders with Wrong Product Issues"
    description: "Number of Orders with at least one wrong product issue. Only available for hub staff positions."
    sql: ${number_of_orders_with_wrong_products} ;;
  }

  measure: sum_number_of_orders_with_missing_products {
    group_label: "> Logistics"
    type: sum
    label: "# Orders with Missing Product Issues"
    description: "Number of Orders with at least one missing product issue. Only available for hub staff positions."
    sql: ${number_of_orders_with_missing_products} ;;
  }

  measure: pct_orders_with_damaged_products{
    group_label: "> Logistics"
    type: number
    label: "% Orders with Products Damaged Issues"
    description: "%  Orders with products that were damaged and were claimed through the Customer Service. Divided by delivered orders for rider position and by picked orders for hub staff positions."
    sql:
    -- Considering delivered orders for rider and picked orders for pickers and hub staff.
      safe_divide(
          sum(${TABLE}.number_of_orders_with_damaged_products)
          ,
          sum(
              case
                  when ${position_name} = 'rider'
                      then ${TABLE}.number_of_delivered_orders
                  else
                      ${number_of_picked_orders}
              end
          )
      )
  ;;
    value_format_name: percent_1
  }

  measure: pct_of_orders_with_post_delivery_issues {
    group_label: "> Logistics"
    type: number
    label: "% Orders with Post Delivery Issues"
    description: "Share of Orders with a post-delivery issue (Missing Product, Wrong Product, Damaged Product or Perished Product) over all picked orders. Based on return info manually created in CT. Not available for external orders. Available only for hub staff positions."
    sql: safe_divide(${number_of_orders_with_post_delivery_issues},${sum_number_of_picked_orders_excluding_external_orders}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_orders_with_pre_delivery_issues {
    group_label: "> Logistics"
    type: number
    label: "% Orders with Pre Delivery Issues"
    description: "Share of Orders with a pre-delivery issue (Missing Product, Wrong Product, Damaged Product or Perished Product) over all picked orders. Based on return info manually created in CT. Available only for hub staff positions."
    sql: safe_divide(${number_of_orders_with_pre_delivery_issues},${sum_number_of_picked_orders}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_items_with_post_delivery_issues {
    group_label: "> Logistics"
    type: number
    label: "% Items with Post Delivery Issues"
    description: "Share of Items with a post-delivery issue (Missing Product, Wrong Product, Damaged Product or Perished Product) over all picked items. Based on return info manually created in CT. Not available for external orders. Available only for hub staff positions."
    sql: safe_divide(${number_of_products_with_post_delivery_issues},${sum_number_of_ordered_items_excluding_external_orders}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_items_with_pre_delivery_issues {
    group_label: "> Logistics"
    type: number
    label: "% Items with Pre Delivery Issues"
    description: "Share of Items with a post-delivery issue (Missing Product, Wrong Product, Damaged Product or Perished Product) over all picked items. Based on return info manually created in CT. Available only for hub staff positions."
    sql: safe_divide(${number_of_products_with_pre_delivery_issues},${number_of_picked_items}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_items_with_missing_products {
    group_label: "> Logistics"
    type: number
    label: "% Items with Missing Product Issues"
    description: "Share of Items with a Missing Product post delivery issue over all ordered items. Based on return info manually created in CT. Not available for external orders. Available only for hub staff positions."
    sql: safe_divide(${number_of_products_with_missing_products_issues},${sum_number_of_ordered_items_excluding_external_orders}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_items_with_wrong_products {
    group_label: "> Logistics"
    type: number
    label: "% Items with Wrong Product Issues"
    description: "Share of Items with a Wrong Product post delivery issue over all ordered items. Based on return info manually created in CT. Not available for external orders. Available only for hub staff positions."
    sql: safe_divide(${number_of_products_with_wrong_products_issues},${sum_number_of_ordered_items_excluding_external_orders}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_items_with_perished_products {
    group_label: "> Logistics"
    type: number
    label: "% Items with Perished Product Issues"
    description: "Share of Items with a Perished Product post delivery issue over all ordered items. Based on return info manually created in CT. Not available for external orders. Available only for hub staff positions."
    sql: safe_divide(${number_of_products_with_perished_issues_post},${sum_number_of_ordered_items_excluding_external_orders}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_orders_with_missing_products {
    group_label: "> Logistics"
    type: number
    label: "% Orders with Missing Product Issues"
    description: "Share of Orders with a Missing Product post delivery issue over all picked orders. Based on return info manually created in CT. Not available for external orders. Available only for hub staff positions."
    sql: safe_divide(${sum_number_of_orders_with_missing_products},${sum_number_of_picked_orders_excluding_external_orders}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_orders_with_perished_products {
    group_label: "> Logistics"
    type: number
    label: "% Orders with Perished Product Issues"
    description: "Share of Orders with a Perished Product post delivery issue over all picked orders. Based on return info manually created in CT. Not available for external orders. Available only for hub staff positions."
    sql: safe_divide(${sum_number_of_orders_with_perished_products},${sum_number_of_picked_orders_excluding_external_orders}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_orders_with_wrong_products {
    group_label: "> Logistics"
    type: number
    label: "% Orders with Wrong Product Issues"
    description: "Share of Orders with a Wrong Product post delivery issue over all picked orders. Based on return info manually created in CT. Not available for external orders. Available only for hub staff positions."
    sql: safe_divide(${sum_number_of_orders_with_wrong_products},${sum_number_of_picked_orders_excluding_external_orders}) ;;
    value_format_name: percent_1
  }

  measure: pct_of_reported_items_per_picked_items {
    group_label: "> Logistics"
    label: "% EAN Swapped Products"
    description: "Items that were not recognized during picking scanning process over all picked items. Due to damaged or wrong code."
    type: number
    sql: safe_divide(${sum_number_of_reported_items},${number_of_picked_items}) ;;
    value_format_name: percent_1
  }

  measure: sum_worked_time_minutes {
    group_label: "> Shift Related"
    type: sum
    label: "# Worked Time (min)"
    description: "Sum worked time in minutes"
    sql: ${TABLE}.number_of_worked_minutes ;;
    value_format_name: decimal_1
  }

  measure: sum_worked_time_minutes_rider {
    group_label: "> Shift Related"
    type: sum
    label: "# Worked Time (min) Riders"
    hidden: yes
    description: "Sum worked time in minutes (Riders)"
    sql: ${TABLE}.number_of_worked_minutes ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
  }

  measure: sum_rider_handling_time_minutes {
    group_label: "> Logistics"
    type: sum
    label: "# Rider Handling Time (min)"
    description: "Sum time needed for the rider to handle the order: Riding to customer + At customer + Riding to hub"
    sql: ${TABLE}.number_of_rider_handling_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: sum_delivery_distance_km {
    group_label: "> Logistics"
    type: sum
    label: "SUM Delivery Distance (km)"
    description: "Sum of delivery distance between hub and customer dropoff in kilometers (most direct path / straight line). For stacked orders, it is the sum of distance from previous customer."
    sql: ${TABLE}.sum_delivery_distance_km ;;
    value_format_name: decimal_1
  }

  measure: sum_picking_time_minutes {
    group_label: "> Logistics"
    type: sum
    label: "SUM Picking Time (min)"
    description: "Sum of the time needed for picking items per order. Sums the difference between order_picker_accepted_timestamp and order_packed_timestamp timestamp for each order. Based on Hub One app tracking data."
    sql: ${TABLE}.number_of_picking_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_rider_handling_time_minutes {
    group_label: "> Logistics"
    type: number
    label: "AVG Rider Handling Time (min)"
    description: "Average time needed for the rider to handle the order: Riding to customer + At customer + Riding to hub"
    sql: ${sum_rider_handling_time_minutes}/nullif(${number_of_orders_with_handling_time},0) ;;
    value_format_name: decimal_1
  }

  measure: avg_delivery_distance_km {
    group_label: "> Logistics"
    type: number
    label: "AVG Delivery Distance (km)"
    description: "Average distance between hub and customer dropoff in kilometers(most direct path / straight line). For stacked orders, it is the average distance from previous customer."
    sql: ${sum_delivery_distance_km}/nullif(${number_of_orders_with_customer_address},0) ;;
    value_format_name: decimal_1
  }

  measure: avg_picking_time_order {
    group_label: "> Logistics"
    type: number
    label: "AVG Picking Time Per Order (min)"
    description: "Average time needed for picking items per order. Based on Hub One data."
    sql: ${sum_picking_time_minutes}/nullif(${sum_number_of_picked_orders},0) ;;
    value_format_name: decimal_2
  }

  measure: avg_picking_time_minutes {
    group_label: "> Logistics"
    type: average
    label: "AVG Time Spent Picking (min)"
    description: "Average time spent doing picking activities based on the Hub One data."
    sql: ${TABLE}.number_of_picking_time_minutes ;;
    value_format_name: decimal_2
  }

  measure: avg_picking_time_item {
    group_label: "> Logistics"
    type: number
    label: "AVG Picking Time Per Item (min)"
    description: "Average time needed for picking items. Based on Hub One data"
    sql: ${sum_picking_time_minutes}/nullif(${number_of_picked_items},0) ;;
    value_format_name: decimal_2
  }

  measure: avg_picked_items_per_worked_hour {
    group_label: "> Performance"
    type: number
    label: "AVG # Picked Items Per Worked Hour"
    description: "Average number of items picked per worked hour. Based on Hub One data and shift data"
    sql: safe_divide(${number_of_picked_items},${sum_worked_time_minutes}/60) ;;
    value_format_name: decimal_2
  }

  measure: sum_riding_to_hub_minutes {
    group_label: "> Logistics"
    type: sum
    label: "SUM Riding to Hub time (min)"
    description: "Sum Riding time from customer location back to the hub (<1min or >30min)."
    sql: ${TABLE}.number_of_return_to_hub_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_riding_to_hub_minutes {
    group_label: "> Logistics"
    type: number
    label: "AVG Riding to Hub time (min)"
    description: "Average Riding time from customer location back to the hub (<1min or >30min)."
    sql: ${sum_riding_to_hub_minutes}/nullif(${number_of_orders_with_riding_to_hub_time},0) ;;
    value_format_name: decimal_1
  }

  measure: sum_riding_to_customer_time_minutes {
    group_label: "> Logistics"
    type: sum
    label: "SUM Riding To Customer Time (min)"
    description: "Sum riding to customer time considering delivery start to arrival at customer. Outliers excluded (<1min or >30min)"
    sql: ${TABLE}.number_of_riding_to_customer_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_riding_to_customer_time_minutes {
    group_label: "> Logistics"
    type: number
    label: "AVG Riding To Customer Time (min)"
    description: "Average riding to customer time considering delivery start to arrival at customer. Outliers excluded (<1min or >30min)"
    sql: ${sum_riding_to_customer_time_minutes}/nullif(${number_of_orders_with_riding_to_customer_time},0) ;;
    value_format_name: decimal_1
  }

  measure: sum_at_customer_time_minutes {
    group_label: "> Logistics"
    type: sum
    label: "SUM At Customer Time (min)"
    description: "Sum Time the Rider spent at the customer between arrival and order completion confirmation"
    sql: ${TABLE}.number_of_at_customer_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: avg_at_customer_time_minutes {
    group_label: "> Logistics"
    type: number
    label: "AVG At Customer Time (min)"
    description: "Average Time the Rider spent at the customer between arrival and order completion confirmation"
    sql: ${sum_at_customer_time_minutes}/nullif(${number_of_orders_with_handling_time},0) ;;
    value_format_name: decimal_1
  }


  measure: pct_riding_to_customer_time {
    group_label: "> Logistics"
    type: number
    label: "% Riding To Customer Time"
    description: "Riding to Customer Time / Riding Time (To Customer + Back To Hub) e.g. a rider spent 5 minutes riding between hub to customer then spend another 5 minutes riding between customer to hub then that will result in % Riding To Customer Time to be 50% "
    sql: sum(${TABLE}.number_of_riding_to_customer_time_minutes) / nullif(sum(${TABLE}.number_of_riding_to_customer_time_minutes + ${TABLE}.number_of_return_to_hub_time_minutes),0)  ;;
    value_format: "0%"
  }

  measure: pct_riding_back_to_hub_time {
    group_label: "> Logistics"
    type: number
    label: "% Riding Back To Hub Time"
    description: "Riding Back to Hub Time / Riding Time (To Customer + Back To Hub) e.g. a rider spent 5 minutes riding between hub to customer then spend another 5 minutes riding between customer to hub then that will result in % Riding Back To Hub Time to be 50%"
    sql: sum(${TABLE}.number_of_return_to_hub_time_minutes) / nullif(sum(${TABLE}.number_of_riding_to_customer_time_minutes + ${TABLE}.number_of_return_to_hub_time_minutes),0)  ;;
    value_format: "0%"
  }

  measure: pct_delta_between_to_hub_and_to_customer_time{
    group_label: "> Logistics"
    type: number
    label: "% Delta Riding Time Between To Hub and To Customer"
    description: "% Difference Riding time between To Hub and To Customer (positive value indicates Time To Hub > Time To Customer) e.g. a rider spent 5 minutes riding between hub to customer then spend another 5 minutes riding between customer to hub then that will result in % Delta Riding Time Between To Hub and To Customer to be 0%"
    sql: sum(${TABLE}.number_of_return_to_hub_time_minutes) / nullif(sum(${TABLE}.number_of_riding_to_customer_time_minutes),0) -1 ;;
    value_format_name: percent_1
  }

  measure: number_of_rider_hub_one_tasks_hours {
    group_label: "> Performance"
    type: sum
    label: "# Rider Hub One Tasks Hours"
    description: "Number of hours rider spent temporary offline due to doing hub one tasks or shelf restocking.
    It is calculated based on rider state change reason in Workforce app."
    sql: ${number_of_rider_hub_one_tasks_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_equipment_issue_hours {
    group_label: "> Performance"
    type: sum
    label: "# Rider Equipment Issue Hours"
    description: "Number of hours rider spent temporary offline due to equipment issues.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_equipment_issue_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_large_order_support_hours {
    group_label: "> Performance"
    type: sum
    label: "# Rider Large Order Support Hours"
    description: "Number of hours rider spent temporary offline due to supporting large orders.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_large_order_support_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_accident_hours {
    group_label: "> Performance"
    type: sum
    label: "# Rider Accident Hours"
    description: "Number of hours rider spent temporary offline due to an accident.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_equipment_issue_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_temporary_offline_break_hours {
    group_label: "> Performance"
    type: sum
    label: "# Rider Temporary Offline Break Hours"
    description: "Number of hours rider spent temporary offline due to taking break.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_temporary_offline_break_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_total_temporary_offline_hours {
    group_label: "> Performance"
    type: sum
    label: "# Rider Temporary Offline Hours"
    description: "Number of hours rider spent temporary offline.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_total_temporary_offline_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_other_temporary_offline_hours {
    group_label: "> Performance"
    type: sum
    label: "# Rider Other Temporary Offline Break Hours"
    description: "Number of hours rider spent temporary offline due to doing other tasks than hub one tasks, shelf restocking, equipment issues, supporting large orders, accident and breaks.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_other_temporary_offline_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_unresponsive_hours {
    group_label: "> Performance"
    type: sum
    label: "# Temporary Offline Hours"
    description: "Number of hours rider spent temporary offline due to: doing hub one tasks, equipment issues, supporting large orders, accidend and breaks.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_unresponsive_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_idle_time_hours {
    group_label: "> Performance"
    type: number
    label: "# Rider Idle Time (Hour) (Online hours based)"
    description: "Number of hours rider spent idle. Calculated as: (# Online Minutes - # Rider Handling Time)/60."
    sql: ${sum_rider_idle_time_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: sum_rider_idle_time_minutes {
    group_label: "> Performance"
    type: sum
    label: "# Rider Idle Time (min) (Online hours based)"
    description: "Sum of idle time (min) - the difference between worked minutes and rider handling time minutes"
    sql: ${number_of_idle_minutes} ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
  }

  measure: sum_idle_time_minutes_quinyx {
    group_label: "> Performance"
    type: sum
    label: "# Rider Idle Time (min) (Quinyx based)"
    description: "Number of hours rider spent idle. Calculated as: # Worked Minutes - # Rider Handling Time."
    sql: ${number_of_idle_minutes_quinyx} ;;
    value_format_name: decimal_1
    hidden: no
  }

  measure: number_of_idle_time_hours_quinyx {
    group_label: "> Performance"
    type: number
    label: "# Rider Idle Time (Hour) (Quinyx based)"
    description: "Number of hours rider spent idle. Calculated as: (# Worked Minutes - # Rider Handling Time)/60."
    sql: ${sum_idle_time_minutes_quinyx}/60 ;;
    value_format_name: decimal_2
  }

  measure: pct_rider_idle_time {
    group_label: "> Performance"
    type: number
    label: "% Worked Time Spent Idle (Online Hours Based)"
    description: "% of online hours (from Workforce app) not spent handling an order - compares the difference between online time and rider handling time with total online time."
    sql: ${number_of_idle_time_hours} / nullif(${number_of_online_hours},0) ;;
    value_format_name: percent_2
  }

  measure: pct_rider_idle_time_quinyx {
    group_label: "> Performance"
    type: number
    label: "% Worked Time Spent Idle (Quinyx Based)"
    description: "% of punched hours not spent handling an order - compares the difference between worked time and rider handling time with total worked time."
    sql: ${number_of_idle_time_hours_quinyx} / nullif(${number_of_worked_hours},0) ;;
    value_format_name: percent_2
  }

  measure: sum_waiting_for_rider_decision_time_minutes {
    group_label: "> Logistics"
    type: sum
    label: "# Waiting For Rider Decision Time (min)"
    description: "Number of minutes an order waited for rider to accept (or reject) the offer."
    sql: ${number_of_waiting_for_rider_decision_time_minutes} ;;
    value_format_name: decimal_1
  }

  # ~~~~~~~~~~~~~~~     Shift related     ~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: number_of_scheduled_weeks {
    group_label: "> Shift Related"
    type: number
    hidden: yes
    sql:date_DIFF( safe_cast(max(${shift_date}) as date),safe_cast(min(${shift_date}) as date), week(monday)) + 1 ;;
  }

  measure: last_worked_date {
    group_label: "> Shift Related"
    type: date
    description: "Date of the last worked/punched shift within the filtered period"
    sql: max(case when ${TABLE}.number_of_worked_minutes > 0 then ${TABLE}.shift_date end);;
  }

  measure: first_worked_date {
    group_label: "> Shift Related"
    type: date
    description: "Date of the first worked/punched shift within the filtered period"
    sql: min(case when ${TABLE}.number_of_worked_minutes > 0 then ${TABLE}.shift_date end);;
  }

  measure: number_of_distinct_shift_dates {
    group_label: "> Shift Related"
    label: "# Distinct Shift Dates"
    type: count_distinct
    description: "Number of distinct shift dates based on the selection."
    sql: ${shift_date};;
  }

  measure: number_of_assigned_hours {
    group_label: "> Shift Related"
    alias: [number_of_scheduled_hours]
    type: sum
    label: "# Assigned Hours"
    description: "All shift hours that are assigned to an employee (before punching) including No show Hours"
    sql: ${TABLE}.number_of_planned_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_availability_based {
    group_label: "> Shift Related"
    type: sum
    label: "# Assigned Hours Based on Availability"
    description: "Number of Assigned hours that are overlapping with provided availability"
    sql: ${number_of_planned_minutes_availability_based}/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_availability_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Availability Hours"
    description:" Number of hours that were provided as available by the employee"
    sql: ${TABLE}.number_of_availability_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_weekend_availability_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Weekend Availability Hours"
    description:"Number of hours that were provided as available by the employee between 3 p.m Friday - 12 a.m Sunday "
    sql: ${TABLE}.number_of_weekend_availability_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_availability_hours_within_operational_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Availability Hours Within Operational Hours"
    description: "Number of hours that were provided as available by the employee within operational hours (country-specific, see metric link for more details)."
    sql: ${TABLE}.number_of_availability_minutes_within_operational_hours/60 ;;
    link: {
      label: "Operational hours definition"
      url: "https://data-dbt-prod.pages.dev/#!/macro/macro.flink_data.is_operational_hours"
    }
    value_format_name: decimal_1
  }

  measure: pct_of_weekend_availability_hours {
    group_label: "> Shift Related"
    type: number
    label: "% Weekend Availability Hours"
    description:"Share of Availability Hours between 3 p.m Friday - 12 a.m Sunday over Total Availability Hours "
    sql: ${number_of_weekend_availability_hours} / nullif(${number_of_availability_hours},0) ;;
    value_format_name: percent_1
  }

  measure: pct_availability_hours_within_operational_hours {
    group_label: "> Shift Related"
    type: number
    label: "% Availability Hours Within Operational Hours"
    description:"Share of Availability Hours provided within operational hours in Total Availability Hours "
    sql: ${number_of_availability_hours_within_operational_hours} / nullif(${number_of_availability_hours},0) ;;
    link: {
      label: "Operational hours definition"
      url: "https://data-dbt-prod.pages.dev/#!/macro/macro.flink_data.is_operational_hours"
    }
    value_format_name: percent_1
  }

  measure: number_of_employees {
    group_label: "> Shift Related"
    type: number
    label: "# Employees"
    description:"Number of distinct employees"
    sql: count(distinct ${employment_id}) ;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_employees {
    group_label: "> Shift Related"
    type: number
    label: "# Worked Employees"
    description:"Number of distinct employees punched in Quinyx excluding one-time externals since they dont punch in Quinyx"
    sql: count(distinct case when ${TABLE}.number_of_worked_minutes > 0 then ${employment_id} end) ;;
    value_format_name: decimal_1
  }

  measure: number_of_employees_with_availability_provided {
    group_label: "> Shift Related"
    type: number
    label: "# Employees with Availability provided"
    description:"Number of distinct employees providing Availability in Quinyx"
    sql: count(distinct
           case when ${TABLE}.number_of_availability_minutes > 0
                then ${employment_id}
            end) ;;
    value_format_name: decimal_1
  }

  measure: pct_of_employees_with_availability_provided {
    group_label: "> Shift Related"
    type: number
    label: "% Employees with Availability provided"
    description:"Share of employees providing Availability in Quinyx"
    sql: ${number_of_employees_with_availability_provided} / nullif(${number_of_employees},0) ;;
    value_format_name: percent_1
  }

  measure: number_of_no_show_hours_with_availability {
    group_label: "> Shift Related"
    type: sum
    label: "# No Show Hours within Availability"
    description:"Number of No Show Hours that are overlapping with provided availability"
    sql: case when ${TABLE}.number_of_no_show_minutes > 0
                then ${number_of_planned_minutes_availability_based}/60
         end ;;
    value_format_name: decimal_1
  }

  measure: avg_of_no_show_hours_with_availability {
    group_label: "> Shift Related"
    type: average
    label: "AVG No Show Hours within Availability"
    description: "Average No Show Hours that are overlapping with provided availability"
    sql: case when ${TABLE}.number_of_no_show_minutes > 0
                then ${number_of_planned_minutes_availability_based}/60
         end ;;
    value_format_name: decimal_1
  }

  measure: pct_of_no_show_hours_with_availability {
    group_label: "> Shift Related"
    type: number
    label: "% No Show Hours within Availability"
    description:"Share of No Show hours that are overlapping with provided availability"
    sql:${number_of_no_show_hours_with_availability}/nullif(${number_of_no_show_hours},0) ;;
    value_format_name: percent_1
  }

  measure: pct_of_assigned_hours_availability_based_rider {
    group_label: "> Shift Related"
    label: "% Assigned Hours Based on Availability"
    type: number
    sql: ${number_of_planned_hours_availability_based}/nullif(${number_of_assigned_hours},0) ;;
    description: "Share of Assigned Hours based on Availability from total Assigned Hours - (# Assigned Hours Based on Availability / # Assigned Hours)"
    value_format_name: percent_1
  }

  measure: pct_of_availability_hours_vs_contracted_hours {
    alias: [pct_of_planned_hours_availability_based_rider_vs_contracted_hours]
    group_label: "> Shift Related"
    label: "% Availability Hours vs Total Contracted Hours"
    type: number
    sql:${number_of_availability_hours}/nullif(${sum_weekly_contracted_hours},0) ;;
    description:"# Availability Hours / Total Contracted Hours"
    value_format_name: percent_1
  }

  measure: pct_of_availability_hours_within_oprational_hours_vs_contracted_hours {
    group_label: "> Shift Related"
    label: "% Availability Hours Within Operational Hours vs Total Contracted Hours"
    type: number
    sql:${number_of_availability_hours_within_operational_hours}/nullif(${sum_weekly_contracted_hours},0) ;;
    description:"# Availability Hours Within Operational Hours / Total Contracted Hours"
    value_format_name: percent_1
  }

  measure: pct_of_availability_hours_vs_worked_hours {
    group_label: "> Shift Related"
    label: "% Availability Hours vs Worked Hours"
    type: number
    sql:${number_of_availability_hours}/nullif(${number_of_worked_hours},0) ;;
    description:"# Availability Hours / # Worked Hours"
    value_format_name: percent_1
  }

  measure: pct_of_availability_hours_within_oprational_hours_vs_worked_hours {
    group_label: "> Shift Related"
    label: "% Availability Hours Within Operational Hours vs Worked Hours"
    type: number
    sql:${number_of_availability_hours_within_operational_hours}/nullif(${number_of_worked_hours},0) ;;
    description:"# Availability Hours Within Operational Hours / # Worked Hours"
    value_format_name: percent_1
  }

  measure: number_of_sick_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Sick Hours"
    description: "Number of Absence hours with leave reason containing the word 'sick' or 'wait' or 'arrêt' (excluding absences defined as no shows)"
    sql: ${TABLE}.number_of_sick_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_vacation_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Vacation Hours"
    description: "Number of Absence hours with leave reason containing the word 'vacation' or 'congé payé' or 'holiday paid' (excluding absences defined as no shows)"
    sql: ${TABLE}.number_of_vacation_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_unpaid_absence_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Unpaid Absence Hours"
    description: "Number of Absence hours with leave reason containing the word 'unpaid' (excluding absences defined as no shows)"
    sql: ${TABLE}.number_of_unpaid_absence_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_absence_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Absence Hours"
    description: "Number of Absence hours with all different leave reason (excluding absences defined as no shows)"
    sql: ${TABLE}.number_of_absence_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_evaluated_hours {
    group_label: "> Shift Related"
    type: number
    label: "# Evaluated Hours"
    description: "Worked Hours + Absence Hours"
    sql: ${number_of_worked_hours} + ${number_of_absence_hours} ;;
    value_format_name: decimal_1
  }

  measure: number_recorded_hours {
    group_label: "> Shift Related"
    type: number
    label: "# Recorded Hours"
    description: "Worked Hours + Absence Hours + No Show Hours"
    sql: ${number_of_worked_hours} + ${number_of_absence_hours} + ${number_of_no_show_hours} ;;
    value_format_name: decimal_1
  }

  measure: number_of_early_punched_out_minutes {
    group_label: "> Shift Related"
    type: sum
    label: "# Early Punched-Out (min)"
    description: "Number of early Punch-Out minutes where employee punch-out early before a shift ends e.g. a shift is scheduled to end at 10 pm but an employee punches out at 09:45 will results in 15 minutes early punch-out"
    sql: ${TABLE}.number_of_end_early_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_late_punched_out_minutes {
    group_label: "> Shift Related"
    type: sum
    label: "# Late Punched-Out (min)"
    description: "Number of late Punch-Out minutes where employee punch-out late after a shift ends e.g. a shift is scheduled to end at 10 pm but an employee punches out at 10:15 will results in 15 minutes late punch-out"
    sql: ${TABLE}.number_of_end_late_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_early_punched_in_minutes {
    group_label: "> Shift Related"
    type: sum
    label: "# Early Punched-In (min)"
    description: "Number of early Punch-In minutes where employee punch-in early before a shift starts e.g. a shift is scheduled to start at 8 am but an employee punches in at 7:45 will results in 15 minutes early punch-in"
    sql: ${TABLE}.number_of_start_early_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_late_punched_in_minutes {
    group_label: "> Shift Related"
    type: sum
    label: "# Late Punched-In (min)"
    description: "Number of late Punch-In minutes where employee punch-in late after a shift starts e.g. a shift is scheduled to start  at 8 am but an employee punches in at 8:15 will results in 15 minutes late punch-in"
    sql: ${TABLE}.number_of_start_late_minutes ;;
    value_format_name: decimal_1
  }

  measure: pct_latess {
    group_label: "> Shift Related"
    type: number
    label: "% Lateness (> 5 min)"
    description: "% of Lateness shift (> 5 minutes late punch-in) e.g. a 4 hours shift is scheduled to start at 8 am but an employee punches in at 9:00 will results in 25% late (1 hour late / 4 hours shift duration )"
    sql: sum(case when ${TABLE}.number_of_start_late_minutes > 5
              then ${TABLE}.number_of_start_late_minutes end)/nullif(sum(${TABLE}.number_of_planned_minutes),0)  ;;
    value_format_name: percent_1
  }

  measure: pct_latess_over_15_minutes{
    group_label: "> Shift Related"
    type: number
    label: "% Lateness (> 15 min)"
    description: "% of Lateness shift (> 15 minutes late punch-in) e.g. a 4 hours shift is scheduled to start at 8 am but an employee punches in at 9:00 will results in 25% late (1 hour late / 4 hours shift duration )"
    sql: sum(case when ${TABLE}.number_of_start_late_minutes > 15
      then ${TABLE}.number_of_start_late_minutes end)/nullif(sum(${TABLE}.number_of_planned_minutes),0)  ;;
    value_format_name: percent_1
  }

  measure: avg_late_punched_in_minutes {
    group_label: "> Shift Related"
    type: average
    label: "AVG Late Punched-In (min)"
    description: "AVG Employee late Punch-In minutes where employee punch-in late after a shift starts e.g. a shift is scheduled to start  at 8 am but an employee punchs in at 8:15 will results in 15 minutes late punch-in"
    sql: ${TABLE}.number_of_start_late_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Worked Hours"
    sql: ${TABLE}.number_of_worked_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_online_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Online Rider Hours"
    sql: ${TABLE}.number_of_online_rider_minutes/60;;
    description: "Number of hours rider spent online in Workforce app (Rider app)."
    value_format_name: decimal_1
  }

  measure: pct_online_hours_vs_worked_hours {
    group_label: "> Shift Related"
    type: number
    label: "% Online Rider Hours vs Worked Hours"
    sql: ${number_of_online_hours}/nullif(${number_of_worked_hours},0);;
    description: "hours rider spent online in Workforce app (Rider app)/ Punched Rider Hours (from Quinyx)"
    value_format_name: percent_1
  }


  measure: number_of_overpunched_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Overpunched Hours"
    sql: ${number_of_overtime_minutes}/60;;
    description: "When # Worked Hours > # Assigned Hours then # Worked Hours - # Assigned Hours"
    value_format_name: decimal_1
  }

  measure: number_of_unjustified_start_early_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Unjustified Early Overpunched Hours"
    # To show null values as null, we need to sum in sql
    sql: ${number_of_unjustified_start_early_minutes}/60;;
    description: "Number of hours when a rider punched in earlier than planned shift start time even if the rider has worked.
      In these cases, hub manager should adjust shift start time in Quinyx.
      Calculated as a difference between planned shift start timestamp and first punch in timestamp.
      5 minutes are deducted due to tolerance for preparation time (e.g. changing clothes, packing bag, etc.)."
    value_format_name: decimal_1
    }

  measure: number_of_unjustified_end_late_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Unjustified Late Overpunched Hours"
    # To show null values as null, we need to sum in sql
    sql: ${number_of_unjustified_end_late_minutes}/60;;
    description: "Number of hours when a rider punched out later than planned shift end time.
      This late punch-out is unjustified as rider was idle.
      Calculated as a difference between last rider arrived at hub timestamp and punch out timestamp.
      5 minutes are deducted due to tolerance for preparation time (e.g. changing clothes, packing bag, etc.)."
    value_format_name: decimal_1
  }

  measure: number_of_unjustified_overpunched_hours {
    group_label: "> Shift Related"
    type: number
    label: "# Total Unjustified Overpunched Hours"
    sql: ${number_of_unjustified_end_late_hours} + ${number_of_unjustified_start_early_hours};;
    description: "Sum of # Unjustified Late Overpunched Hours and # Unjustified Early Overpunched Hours."
    value_format_name: decimal_1
  }

  measure: number_of_justified_overpunched_hours {
    group_label: "> Shift Related"
    type: number
    label: "# Justified Overpunched Hours"
    sql:
      case
        when sum(${number_of_unjustified_end_late_minutes}) is null and sum(${number_of_unjustified_start_early_minutes}) is null
          then null
        else ${number_of_overpunched_hours} - ${number_of_unjustified_overpunched_hours}
      end;;
    description: "Difference between # Overpunched Hours and # Unjustified Overpunched Hours"
    value_format_name: decimal_1
  }

  measure: share_of_justified_overpunched_hours {
    group_label: "> Shift Related"
    type: number
    label: "% Justified Overpunched Hours"
    sql: ${number_of_justified_overpunched_hours}/${number_of_overpunched_hours};;
    description: "Share of justified overtime rider spent working during overtime. Formula: # Justified Overpunched Hours / # Overpunched Hours"
    value_format_name: percent_2
  }

  measure: number_of_no_show_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# No Show Hours"
    sql: ${TABLE}.number_of_no_show_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Excused No Show Hours"
    sql: ${TABLE}.number_of_excused_no_show_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Unexcused No Show Hours"
    sql: ${TABLE}.number_of_unexcused_no_show_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_excused_no_show_hours {
    group_label: "> Shift Related"
    type: sum
    label: "# Deleted Excused No Show Hours"
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: avg_rider_utr {
    group_label: "> Logistics"
    type: number
    label: "AVG Rider UTR"
    sql: ${number_of_delivered_orders}/nullif(${number_of_worked_hours},0) ;;
    value_format_name: decimal_1
  }

  measure: avg_rider_utr_using_online_hours {
    group_label: "> Logistics"
    type: number
    label: "AVG Rider UTR (using Online Hours)"
    description: "# Orders delivered / # Hours spent online"
    sql: ${number_of_delivered_orders}/nullif(${number_of_online_hours},0) ;;
    value_format_name: decimal_1
  }

  measure: pct_no_show_hours {
    group_label: "> Shift Related"
    type: number
    hidden: no
    label: "% No Show Hours "
    sql: ${number_of_no_show_hours}/nullif(${number_of_assigned_hours},0) ;;
    value_format: "0%"
  }

  measure: pct_sickness_hours {
    group_label: "> Shift Related"
    type: number
    hidden: no
    label: "% Sickness Hours "
    description: "Sickness hours / (Sickness hours + Scheduled hours)"
    sql: (${number_of_sick_hours})/nullif(${number_of_sick_hours}+${number_of_assigned_hours},0) ;;
    value_format: "0%"
  }

  measure: sum_weekly_contracted_hours_per_employee {
    type: sum_distinct
    sql: ${TABLE}.weekly_contracted_hours ;;
    sql_distinct_key: ${employment_id} ;;
    hidden: yes
    description: "# Weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Agreement full time working hours)"
  }

  measure: sum_weekly_contracted_hours {
    label: "Total Contracted Hours"
    group_label: "> Contract Related"
    type: sum_distinct
    sql_distinct_key: concat(${shift_date},${employment_id});;
    sql: ${TABLE}.avg_daily_contracted_hours;;
    value_format: "0.0"
    description: "Sum of weekly contracted hours based on Quinyx Agreements (Field in Quinyx UI: Agreement full time working hours) =  AVG daily contracted hours * number of days"
  }

  measure: pct_contract_fulfillment {
    group_label: "> Shift Related"
    type: number
    hidden: no
    label: "% Contracted Hours Fulfillment"
    description: "Worked hours / (AVG daily contracted hours * number of days)"
    sql: ${number_of_worked_hours}/nullif(${sum_weekly_contracted_hours},0) ;;
    value_format: "0%"
  }

  measure: pct_evaluated_vs_contracted {
    group_label: "> Shift Related"
    type: number
    hidden: no
    label: "% Evaluated Hours vs Contracted Hours"
    description: "Evaluated Hours (Worked Hours + Absence Hours) / (AVG daily contracted hours * number of days)"
    sql: ${number_evaluated_hours}/nullif(${sum_weekly_contracted_hours},0) ;;
    value_format: "0%"
  }

  measure: pct_recorded_vs_contracted {
    group_label: "> Shift Related"
    type: number
    hidden: no
    label: "% Recorded Hours vs Contracted Hours"
    description: "Recorded Hours (Worked Hours + Absence Hours + No Show Hours) / (AVG daily contracted hours * number of days)"
    sql: ${number_recorded_hours}/nullif(${sum_weekly_contracted_hours},0) ;;
    value_format: "0%"
  }

  measure: pct_scheduled_hours_vs_contracted {
    group_label: "> Shift Related"
    type: number
    hidden: no
    label: "% Assigned Hours vs Contracted Hours"
    description: "Assigned Hours / (AVG daily contracted hours * number of days)"
    sql: ${number_of_assigned_hours}/nullif(${sum_weekly_contracted_hours},0) ;;
    value_format: "0%"
  }

  # ~~~~~~~~~~~~~~~     NPS     ~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: cnt_responses {
    group_label: "> NPS"
    label: "# NPS Responses"
    type: sum
    sql: ${TABLE}.number_of_nps_responses ;;
  }

  measure: cnt_detractors {
    group_label: "> NPS"
    label: "# Detractors"
    type: sum
    sql: ${TABLE}.number_of_detractors ;;
  }

  measure: cnt_promoters {
    group_label: "> NPS"
    label: "# Promoters"
    type: sum
    sql: ${TABLE}.number_of_promoters ;;
  }

  measure: pct_detractors{
    group_label: "> NPS"
    label: "% Detractors"
    description: "Share of Detractors over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_detractors} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }

  measure: pct_promoters{
    group_label: "> NPS"
    label: "% Promoters"
    description: "Share of Promoters over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_promoters} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }

  measure: nps_score{
    group_label: "> NPS"
    label: "% NPS"
    description: "NPS Score (After Order)"
    hidden:  no
    type: number
    sql: ${pct_promoters} - ${pct_detractors};;
    value_format: "0%"
  }

  measure: sum_nps_score {
    group_label: "> NPS"
    type: sum
    hidden: yes
    sql: ${TABLE}.sum_nps_score ;;
  }

  measure: avg_nps_score {
    group_label: "> NPS"
    type: number
    label: "AVG Customer NPS"
    sql: ${sum_nps_score}/nullif(${cnt_responses},0) ;;
  }

  ##### Payroll measures

  measure: number_of_sick_hours_payroll {
    group_label: "> Payroll"
    type: sum
    label: "# Paid Sick Hours"
    description: "Number of paid sick hours (excluding absences defined as no shows)."
    sql: ${number_of_sick_minutes_payroll}/60 ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_vacation_hours_payroll {
    group_label: "> Payroll"
    type: sum
    label: "# Paid Vacation Hours"
    description: "Number of paid vacation hours."
    sql: ${number_of_vacation_minutes_payroll}/60 ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_public_holiday_hours {
    group_label: "> Payroll"
    type: sum
    label: "# Paid Public Holiday Hours"
    description: "Number of paid public holiday hours during the shift period. Calculated as AVG Daily Contracted Hours * Public holiday days."
    sql: ${number_of_public_holiday_hours} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_paid_hours {
    group_label: "> Payroll"
    type: sum
    label: "# Worked Hours"
    sql: ${number_of_paid_minutes}/60 ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_premium_worked_hours {
    group_label: "> Payroll"
    type: sum
    label: "# Premium Worked Hours (Weekend night shifts)"
    description: "Number of punched hours during the weekends after 22:00."
    sql: ${number_of_premium_worked_minutes}/60 ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_premium_worked_hours_as_ops_associate_plus {
    group_label: "> Payroll"
    type: sum
    label: "# Premium Worked Hours (Ops Associate +)"
    description: "Number of punched hours with 'ops associate +' or 'deputy shift lead' position. It happens when employees with different positions work as a shift lead."
    sql: ${number_of_premium_worked_minutes_as_ops_associate_plus}/60 ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_signon_bonus_gross {
    group_label: "> Payroll"
    type: sum
    label: "SUM Gross Sign On Bonus"
    description: "Gross bonus amount paid to an employee during sign on."
    sql: ${amt_signon_bonus_gross} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_referral_bonus_net {
    group_label: "> Payroll"
    type: sum
    label: "SUM Net Referral Bonus"
    description: "Net bonus amount paid to an employee that referred another employee."
    sql: ${amt_referral_bonus_net} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  set: payroll_fields {
    fields: [
      staff_number,
      weekly_contracted_hours,
      number_of_paid_minutes,
      number_of_paid_hours,
      number_of_sick_minutes_payroll,
      number_of_sick_hours_payroll,
      number_of_premium_worked_minutes,
      number_of_premium_worked_hours,
      number_of_premium_worked_minutes_as_ops_associate_plus,
      number_of_premium_worked_hours_as_ops_associate_plus,
      number_of_public_holiday_hours,
      sum_of_public_holiday_hours,
      number_of_vacation_minutes_payroll,
      number_of_vacation_hours_payroll,
      hourly_rate,
      sum_signon_bonus_gross,
      sum_referral_bonus_net,
      pct_fringe,
      amt_byod_bonus_net
    ]
  }

}
