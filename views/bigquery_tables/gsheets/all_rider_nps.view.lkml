view: all_rider_nps {
  sql_table_name: `flink-data-dev.google_sheets.all_rider_nps`
  ;;

  dimension: token {
    type: string
    primary_key: yes
    sql: ${TABLE}.token;;
  }

  dimension: npssource {
    type: string
    sql: ${TABLE}.npssource;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.based_on_your_experience_of_riding_with_flink_so_far_how_likely_are_you_to_recommend_joining_us_to_a_friend_or_a_family_member_;;
  }

  dimension: nps {
    type: number
    sql: case when ${score} <= 6 then -100
              when ${score} >= 9 then 100
              else 0 end
    ;;
  }

  dimension: has_responded_nps {
    type: number
    sql: case when ${TABLE}.nps is not null then 1 else 0;;
  }


  dimension: group {
    type: string
    sql: CASE WHEN ${score}<=6 THEN "Detractors"
              WHEN ${score}>=9 THEN "Promoters"
              ELSE "Passives" END;;
  }

  dimension: bikes {
    type: number
    sql: ${TABLE}.bikes;;
  }

  dimension: has_responded_bikes {
    type: number
    sql: case when ${TABLE}.bikes is not null then 1 else 0 end;;
  }


  dimension: communication_support {
    type: number
    sql: ${TABLE}.communication_support;;
  }

  dimension: has_responded_communication_support {
    type: number
    sql: case when ${TABLE}.communication_support is not null then 1 else 0 end;;
  }


  dimension: contract_type {
    type: string
    sql: ${TABLE}.contract_type;;
  }

  dimension: hub {
    type: string
    sql: ${TABLE}.hub;;
  }


  dimension: hub_infrastructure {
    type: number
    sql: ${TABLE}.hub_infrastructure;;
  }

  dimension: has_responded_hub_infrastructure{
    type: number
    sql: case when ${TABLE}.hub_infrastructure is not null then 1 else 0 end;;
  }


  dimension: on_boarding_experience {
    type: number
    sql: ${TABLE}.on_boarding_experience;;
  }

  dimension: has_responded_on_boarding_experience{
    type: number
    sql: case when ${TABLE}.on_boarding_experience is not null then 1 else 0 end;;
  }


  dimension: payments {
    type: number
    sql: ${TABLE}.payments;;
  }

  dimension: has_responded_payments{
    type: number
    sql: case when ${TABLE}.payments is not null then 1 else 0 end;;
  }


  dimension: rider_app {
    type: number
    sql: ${TABLE}.rider_app;;
  }

  dimension: has_responded_rider_app{
    type: number
    sql: case when ${TABLE}.hub_infrastructure is not null then 1 else 0 end;;
  }


  dimension: shift_planning {
    type: number
    sql: ${TABLE}.shift_planning;;
  }

  dimension: has_responded_shift_planning{
    type: number
    sql: case when ${TABLE}.shift_planning is not null then 1 else 0 end;;
  }


  dimension_group: submitted_at {
    type: time
    timeframes: [
      raw,
      hour_of_day,
      hour,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.submitted_at;;
  }

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: submitted_at {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
      {% if date_granularity._parameter_value == 'Day' %}
      ${submitted_at_date}
      {% elsif date_granularity._parameter_value == 'Week' %}
      ${submitted_at_week}
      {% elsif date_granularity._parameter_value == 'Month' %}
      ${submitted_at_month}
      {% endif %};;
  }

  dimension: what_can_flink_do_to_make_work_better_for_you_sharing_this_will_help_us_to_focus_on_specific_areas_to_improve_ {
    type: string
    sql: ${TABLE}.what_can_flink_do_to_make_work_better_for_you_sharing_this_will_help_us_to_focus_on_specific_areas_to_improve_;;
  }

  dimension: what_hub_are_you_based_in_ {
    type: string
    sql: ${TABLE}.what_hub_are_you_based_in_;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city;;
  }

  dimension: work_duties_deliveries_other_tasks_ {
    type: number
    sql: ${TABLE}.work_duties_deliveries_other_tasks_;;
  }

  dimension: has_responded_work_duties_deliveries_other_tasks_{
    type: number
    sql: case when ${TABLE}.work_duties_deliveries_other_tasks_ is not null then 1 else 0 end;;
  }


  dimension: work_environment_atmosphere {
    type: number
    sql: ${TABLE}.work_environment_atmosphere;;
  }

  dimension: has_responded_work_environment_atmosphere{
    type: number
    sql: case when ${TABLE}.work_environment_atmosphere is not null then 1 else 0 end;;
  }

  dimension: what_is_your_role_at_flink_ {
    type: string
    sql: ${TABLE}.what_is_your_role_at_flink_;;
  }

  dimension: my_supervisor_s_treats_everyone_fairly_ {
    type: number
    sql: ${TABLE}.my_supervisor_s_treats_everyone_fairly_;;
  }

  dimension: has_responded_my_supervisor_s_treats_everyone_fairly_{
    type: number
    sql: case when ${TABLE}.my_supervisor_s_treats_everyone_fairly_ is not null then 1 else 0 end;;
  }

  dimension: my_supervisor_s_cares_about_their_employees_ {
    type: number
    sql: ${TABLE}.my_supervisor_s_cares_about_their_employees_;;
  }

  dimension: has_responded_my_supervisor_s_cares_about_their_employees_{
    type: number
    sql: case when ${TABLE}.my_supervisor_s_cares_about_their_employees_ is not null then 1 else 0 end;;
  }

  dimension: i_feel_comfortable_giving_opinions_and_feedback_to_managers_ {
    type: number
    sql: ${TABLE}.i_feel_comfortable_giving_opinions_and_feedback_to_managers_;;
  }

  dimension: has_responded_i_feel_comfortable_giving_opinions_and_feedback_to_managers_{
    type: number
    sql: case when ${TABLE}.i_feel_comfortable_giving_opinions_and_feedback_to_managers_ is not null then 1 else 0 end;;
  }

  dimension: if_i_do_great_work_i_know_that_it_will_be_recognised_ {
    type: number
    sql: ${TABLE}.if_i_do_great_work_i_know_that_it_will_be_recognised_;;
  }

  dimension: has_responded_if_i_do_great_work_i_know_that_it_will_be_recognised_{
    type: number
    sql: case when ${TABLE}.if_i_do_great_work_i_know_that_it_will_be_recognised_ is not null then 1 else 0 end;;
  }

  dimension: management {
    type: number
    sql: ${TABLE}.management;;
  }

  dimension: has_responded_management{
    type: number
    sql: case when ${TABLE}.management is not null then 1 else 0 end;;
  }

  dimension: _i_am_satisfied_with_the_hub_working_conditions_ {
    type: number
    sql: ${TABLE}._i_am_satisfied_with_the_hub_working_conditions_;;
  }

  dimension: has_responded_i_am_satisfied_with_the_hub_working_conditions_{
    type: number
    sql: case when ${TABLE}._i_am_satisfied_with_the_hub_working_conditions_ is not null then 1 else 0 end;;
  }

  dimension: _my_hub_adheres_to_the_highest_safety_standards_ {
    type: number
    sql: ${TABLE}._my_hub_adheres_to_the_highest_safety_standards_;;
  }

  dimension: has_responded_my_hub_adheres_to_the_highest_safety_standards_{
    type: number
    sql: case when ${TABLE}._my_hub_adheres_to_the_highest_safety_standards_ is not null then 1 else 0 end;;
  }

  dimension: i_have_adequate_training_to_do_my_job_well_ {
    type: number
    sql: ${TABLE}.i_have_adequate_training_to_do_my_job_well_;;
  }

  dimension: has_responded_i_have_adequate_training_to_do_my_job_well_{
    type: number
    sql: case when ${TABLE}.i_have_adequate_training_to_do_my_job_well_ is not null then 1 else 0 end;;
  }

  dimension: i_receive_my_salary_on_time_and_accurately_ {
    type: number
    sql: ${TABLE}.i_receive_my_salary_on_time_and_accurately_;;
  }

  dimension: has_responded_i_receive_my_salary_on_time_and_accurately_{
    type: number
    sql: case when ${TABLE}.i_receive_my_salary_on_time_and_accurately_ is not null then 1 else 0 end;;
  }

  dimension: my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_ {
    type: number
    sql: ${TABLE}.my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_;;
  }

  dimension: has_responded_my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_{
    type: number
    sql: case when ${TABLE}.my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_ is not null then 1 else 0 end;;
  }

  dimension: quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_ {
    type: number
    sql: ${TABLE}.quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_;;
  }

  dimension: has_responded_quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_{
    type: number
    sql: case when ${TABLE}.quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_ is not null then 1 else 0 end;;
  }

  dimension: i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_ {
    type: number
    sql: ${TABLE}.i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_;;
  }

  dimension: has_responded_i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_{
    type: number
    sql: case when ${TABLE}.i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_ is not null then 1 else 0 end;;
  }

  dimension: i_am_happy_with_my_work_duties_and_role_responsibilities_ {
    type: number
    sql: ${TABLE}.i_am_happy_with_my_work_duties_and_role_responsibilities_;;
  }

  dimension: has_responded_i_am_happy_with_my_work_duties_and_role_responsibilities_{
    type: number
    sql: case when ${TABLE}.i_am_happy_with_my_work_duties_and_role_responsibilities_ is not null then 1 else 0 end;;
  }

  dimension: i_am_satisfied_with_the_level_of_support_communication_from_the_hub_care_team_ {
    type: number
    sql: ${TABLE}.i_am_satisfied_with_the_level_of_support_communication_from_the_hub_care_team_;;
  }

  dimension: has_responded_i_am_satisfied_with_the_level_of_support_communication_from_the_hub_care_team_{
    type: number
    sql: case when ${TABLE}.i_am_satisfied_with_the_level_of_support_communication_from_the_hub_care_team_ is not null then 1 else 0 end;;
  }

  dimension: there_is_a_strong_level_of_teamwork_in_the_hub_ {
    type: number
    sql: ${TABLE}.there_is_a_strong_level_of_teamwork_in_the_hub_;;
  }

  dimension: has_responded_there_is_a_strong_level_of_teamwork_in_the_hub_{
    type: number
    sql: case when ${TABLE}.there_is_a_strong_level_of_teamwork_in_the_hub_ is not null then 1 else 0 end;;
  }

  dimension: dockr_cargo_bikes_ {
    type: number
    sql: ${TABLE}.dockr_cargo_bikes_;;
  }

  dimension: has_responded_dockr_cargo_bikes_ {
    type: number
    sql: case when ${TABLE}.dockr_cargo_bikes_ is not null then 1 else 0 end;;
  }

  dimension: get_henry_black_ {
    type: number
    sql: ${TABLE}.get_henry_black_;;
  }

  dimension: has_responded_get_henry_black_ {
    type: number
    sql: case when ${TABLE}.get_henry_black_ is not null then 1 else 0 end;;
  }

  dimension: get_henry_white_ {
    type: number
    sql: ${TABLE}.get_henry_white_;;
  }

  dimension: has_responded_get_henry_white_ {
    type: number
    sql: case when ${TABLE}.get_henry_white_ is not null then 1 else 0 end;;
  }

  dimension: movelo {
    type: number
    sql: ${TABLE}.movelo;;
  }

  dimension: has_responded_movelo {
    type: number
    sql: case when ${TABLE}.movelo is not null then 1 else 0 end;;
  }

  dimension: smartvelo {
    type: number
    sql: ${TABLE}.smartvelo;;
  }

  dimension: has_responded_smartvelo {
    type: number
    sql: case when ${TABLE}.smartvelo is not null then 1 else 0 end;;
  }

  dimension: swapfiets {
    type: number
    sql: ${TABLE}.swapfiets;;
  }

  dimension: has_responded_swapfiets {
    type: number
    sql: case when ${TABLE}.swapfiets is not null then 1 else 0 end;;
  }

  dimension: tier {
    type: number
    sql: ${TABLE}.tier;;
  }

  dimension: has_responded_tier {
    type: number
    sql: case when ${TABLE}.tier is not null then 1 else 0 end;;
  }

  dimension: zoomo {
    type: number
    sql: ${TABLE}.zoomo;;
  }

  dimension: has_responded_zoomo {
    type: number
    sql: case when ${TABLE}.zoomo is not null then 1 else 0 end;;
  }

  dimension: moby {
    type: number
    sql: ${TABLE}.moby;;
  }

  dimension: has_responded_moby {
    type: number
    sql: case when ${TABLE}.moby is not null then 1 else 0 end;;
  }

  dimension: dott {
    type: number
    sql: ${TABLE}.dott;;
  }

  dimension: has_responded_dott {
    type: number
    sql: case when ${TABLE}.dott is not null then 1 else 0 end;;
  }

  dimension: all_bike_score {
    type: number
    sql: ${TABLE}.all_bike_score;;
  }

  dimension: has_responded_all_bike_score {
    type: number
    sql: case when ${TABLE}.all_bike_score is not null then 1 else 0 end;;
  }

  dimension: total_bikes_response {
    type: number
    sql: ${TABLE}.total_bikes_response;;
  }

  dimension: has_responded_total_bikes_response {
    type: number
    sql: case when ${TABLE}.total_bikes_response is not null then 1 else 0 end;;
  }

  ############################### MEASURES ####################################

  ####### SUM #########


  measure: sum_responded_bikes {
    type: sum
    value_format: "0"
    sql: ${has_responded_bikes};;
  }

  measure: sum_responded_communication_support {
    type: sum
    value_format: "0"
    sql: ${has_responded_communication_support};;
  }

  measure: sum_responded_hub_infrastructure {
    type: sum
    value_format: "0"
    sql: ${has_responded_hub_infrastructure};;
  }

  measure: sum_responded_on_boarding_experience {
    type: sum
    value_format: "0"
    sql: ${has_responded_on_boarding_experience};;
  }

  measure: sum_responded_payments {
    type: sum
    value_format: "0"
    sql: ${has_responded_payments};;
  }

  measure: sum_responded_rider_app {
    type: sum
    value_format: "0"
    sql: ${has_responded_rider_app};;
  }

  measure: sum_responded_shift_scheduling {
    type: sum
    value_format: "0"
    sql: ${has_responded_shift_planning};;
  }

  measure: sum_responded_work_duties_deliveries_other_tasks_ {
    type: sum
    value_format: "0"
    sql: ${has_responded_work_duties_deliveries_other_tasks_};;
  }

  measure: sum_responded_work_environment_atmosphere {
    type: sum
    value_format: "0"
    sql: ${has_responded_work_environment_atmosphere};;
  }

            ######## AVG ###########

 measure: avg_nps {
    type: average
    value_format: "0"
    sql: ${nps};;
  }

  measure: avg_bikes {
    label: "Bikes"
    type: average
    value_format: "0.0"
    sql: ${bikes};;
  }


  measure: avg_communication_support {
    label: "Communication Support"
    type: average
    value_format: "0.0"
    sql: ${communication_support};;
  }

  measure: avg_hub_infrastructure {
    label: "Hub Infrastructure"
    type: average
    value_format: "0.0"
    sql: ${hub_infrastructure};;
  }

  measure: avg_on_boarding_experience {
    label: "On-boarding Experience"
    type: average
    value_format: "0.0"
    sql: ${on_boarding_experience};;
  }


  measure: avg_payments {
    label: "Payments"
    type: average
    value_format: "0.0"
    sql: ${payments};;
  }

  measure: avg_rider_app {
    label: "Rider App"
    type: average
    value_format: "0.0"
    sql: ${rider_app};;
  }


  measure: avg_shift_planning {
    label: "Shift Scheduling"
    type: average
    value_format: "0.0"
    sql: ${shift_planning};;
  }

  measure: avg_work_duties_deliveries_other_tasks_ {
    label: "Work Duties"
    type: average
    value_format: "0.0"
    sql: ${work_duties_deliveries_other_tasks_};;
  }

  measure: avg_work_environment_atmosphere {
    label: "Work Atmosphere"
    type: average
    value_format: "0.0"
    sql: ${work_environment_atmosphere};;
  }


  measure: count {
    type: count
    drill_fields: []
  }

}
