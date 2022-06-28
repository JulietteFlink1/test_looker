view: rider_hub_nps {
  sql_table_name: `flink-data-prod.reporting.rider_hub_nps`
    ;;

 dimension: uuid {
  hidden: yes
  type: string
  primary_key: yes
  sql: ${TABLE}.rider_hub_nps_uuid;;
}

dimension: npssource {
  type: string
  sql: ${TABLE}.npssource;;
}

dimension: score {
  hidden: yes
  type: number
  sql: ${TABLE}.nps_score;;
}

dimension: nps {
  type: number
  sql: case when ${score} <= 6 then -100
              when ${score} >= 9 then 100
              else 0 end
    ;;
}


dimension: group {
  type: string
  description: "Promoters, Detractors or Passives"
  sql: CASE WHEN ${score}<=6 THEN "Detractors"
              WHEN ${score}>=9 THEN "Promoters"
              ELSE "Passives" END;;
}

dimension: bikes {
  hidden: yes
  type: number
  sql: ${TABLE}.bikes;;
}


dimension: communication_support {
  hidden: yes
  type: number
  sql: ${TABLE}.communication_support;;
}


dimension: contract_type {
  type: string
  sql:case when ${TABLE}.contract_type in ('Rider','Rider Captain') then ${TABLE}.contract_type else null end ;;
}

dimension: hub_code {
  hidden: yes
  type: string
  sql: ${TABLE}.hub_code ;;
}



dimension: hub_infrastructure {
  hidden: yes
  type: number
  sql: ${TABLE}.hub_infrastructure;;
}

dimension: on_boarding_experience {
  hidden: yes
  type: number
  sql: ${TABLE}.on_boarding_experience;;
}


dimension: payments {
  hidden: yes
  type: number
  sql: ${TABLE}.payments;;
}


dimension: rider_app {
  hidden: yes
  type: number
  sql: ${TABLE}.rider_app;;
}


dimension: shift_planning {
  hidden: yes
  type: number
  sql: ${TABLE}.shift_planning;;
}


dimension_group: submitted_at {
  type: time
  timeframes: [
    date,
    day_of_week,
    week,
    month,
    year
  ]
  sql: ${TABLE}.submitted_at_timestamp;;
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
  label: "Hub Code"
  type: string
  sql: coalesce(${hub_code}, lower(REGEXP_EXTRACT(${TABLE}.what_hub_are_you_based_in_, r'([a-zA-Z0-9-][a-zA-Z0-9-.]_[a-zA-Z0-9-.][a-zA-Z0-9-.][a-zA-Z0-9-.]_[a-zA-Z0-9-.][a-zA-Z0-9-.][a-zA-Z0-9-.][a-zA-Z0-9-.])'))
  );;
}

dimension: country_iso {
  type: string
  sql: ${TABLE}.country_iso;;
}

dimension: city {
  type: string
  sql: coalesce(${TABLE}.city,REGEXP_EXTRACT(${TABLE}.what_hub_are_you_based_in_,r'\((.*?)\)' ));;
}

dimension: work_duties {
  hidden: yes
  type: number
  sql: ${TABLE}.work_duties;;
}


dimension: work_environment_atmosphere {
  hidden: yes
  type: number
  sql: ${TABLE}.work_environment_atmosphere;;
}

dimension: what_is_your_role_at_flink_ {
  type: string
  sql: coalesce(${TABLE}.what_is_your_role_at_flink_,${contract_type});;
}

dimension: my_supervisor_s_treats_everyone_fairly_ {
  hidden: yes
  type: number
  sql: ${TABLE}.my_supervisor_s_treats_everyone_fairly_;;
}

dimension: my_supervisor_s_cares_about_their_employees_ {
  hidden: yes
  type: number
  sql: ${TABLE}.my_supervisor_s_cares_about_their_employees_;;
}

dimension: i_feel_comfortable_giving_opinions_and_feedback_to_managers_ {
  hidden: yes
  type: number
  sql: ${TABLE}.i_feel_comfortable_giving_opinions_and_feedback_to_managers_;;
}

dimension: if_i_do_great_work_i_know_that_it_will_be_recognised_ {
  hidden: yes
  type: number
  sql: ${TABLE}.if_i_do_great_work_i_know_that_it_will_be_recognised_;;
}

dimension: there_is_a_strong_level_of_teamwork_in_the_hub_{
  hidden:  yes
  type:  number
  sql: ${TABLE}.there_is_a_strong_level_of_teamwork_in_the_hub_ ;;
}

dimension: _i_am_satisfied_with_the_hub_working_conditions_ {
  hidden: yes
  type: number
  sql: ${TABLE}._i_am_satisfied_with_the_hub_working_conditions_;;
}

dimension: _my_hub_adheres_to_the_highest_safety_standards_ {
  hidden: yes
  type: number
  sql: ${TABLE}._my_hub_adheres_to_the_highest_safety_standards_;;
}

dimension: my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_ {
  hidden: yes
  type: number
  sql: ${TABLE}.my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_;;
}

dimension: quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_ {
  hidden: yes
  type: number
  sql: ${TABLE}.quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_;;
}


dimension: dockr_cargo_bikes_ {
  hidden: yes
  type: number
  sql: ${TABLE}.dockr_cargo_bikes_;;
}


dimension: get_henry_black_ {
  hidden: yes
  type: number
  sql: ${TABLE}.get_henry_black_;;
}

dimension: get_henry_white_ {
  hidden: yes
  type: number
  sql: ${TABLE}.get_henry_white_;;
}

dimension: movelo {
  hidden: yes
  type: number
  sql: ${TABLE}.movelo;;
}

dimension: smartvelo {
  hidden: yes
  type: number
  sql: ${TABLE}.smartvelo;;
}

dimension: swapfiets {
  hidden: yes
  type: number
  sql: ${TABLE}.swapfiets;;
}

dimension: tier {
  hidden: yes
  type: number
  sql: ${TABLE}.tier;;
}

dimension: zoomo {
  hidden: yes
  type: number
  sql: ${TABLE}.zoomo;;
}

dimension: moby {
  hidden: yes
  type: number
  sql: ${TABLE}.moby;;
}

dimension: dott {
  hidden: yes
  type: number
  sql: ${TABLE}.dott;;
}

dimension: kemmrod {
  hidden: yes
  type: number
  sql: ${TABLE}.kemmrod;;
}

dimension: vely_velo {
  hidden: yes
  type: number
  sql: ${TABLE}.vely_velo;;
}

  dimension: i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_clothing {
    type: number
    sql: ${TABLE}.i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_clothing ;;
  }

  dimension: i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_ {
    type: number
    sql: ${TABLE}.i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_;;
  }

######################################### MEASURES ##############################################


###################################################### SUM #################################################


measure: sum_responded_bikes {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [bikes: "not null"]
}


measure: sum_responded_dockr_cargo_bikes {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [dockr_cargo_bikes_: ">0"]
}

measure: sum_responded_get_henry_black {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [get_henry_black_: "not null"]
}

measure: sum_responded_get_henry_white {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [get_henry_white_: "not null"]
}

measure: sum_responded_movelo {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [movelo: "not null"]
}

measure: sum_responded_smartvelo {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [smartvelo: "not null"]
}

measure: sum_responded_swapfiets {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [swapfiets: "not null"]
}

measure: sum_responded_tier {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [tier: "not null"]
}

measure: sum_responded_zoomo {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [zoomo: "not null"]
}

measure: sum_responded_moby {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [moby: "not null"]
}

measure: sum_responded_dott {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [dott: "not null"]
}

measure: sum_responded_kemmrod {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [kemmrod: "not null"]
}

measure: sum_responded_vely_velo {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [vely_velo: "not null"]
}

measure: sum_responded_i_am_satisfied_with_the_hub_working_conditions_ {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [_i_am_satisfied_with_the_hub_working_conditions_: "not null"]
}

measure: sum_responded_my_hub_adheres_to_the_highest_safety_standards_ {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [_my_hub_adheres_to_the_highest_safety_standards_: "not null"]
}

measure: sum_responded_my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_ {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_: "not null"]
}

measure: sum_responded_quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_ {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_: "not null"]
}

measure: sum_responded_my_supervisor_s_cares_about_their_employees_ {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [my_supervisor_s_cares_about_their_employees_: "not null"]
}

measure: sum_responded_my_supervisor_s_treats_everyone_fairly_ {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [my_supervisor_s_treats_everyone_fairly_: "not null"]
}

measure: sum_responded_i_feel_comfortable_giving_opinions_and_feedback_to_managers_ {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [i_feel_comfortable_giving_opinions_and_feedback_to_managers_: "not null"]
}

measure: sum_responded_if_i_do_great_work_i_know_that_it_will_be_recognised_ {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [if_i_do_great_work_i_know_that_it_will_be_recognised_:  "not null"]
}

  measure: sum_responded_there_is_a_strong_level_of_teamwork_in_the_hub_ {
    group_label: "# Responses"
    type: count_distinct
    value_format: "0"
    sql: ${uuid};;
    filters: [there_is_a_strong_level_of_teamwork_in_the_hub_:  "not null"]
  }


measure: sum_responded_communication_support {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [communication_support:  "not null"]
}


measure: sum_responded_hub_infrastructure {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [hub_code:  "not null"]
}

measure: sum_responded_on_boarding_experience {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [on_boarding_experience:  "not null"]
}

measure: sum_responded_payments {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [payments:   "not null"]
}


measure: sum_responded_rider_app {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [rider_app:  "not null"]
}


measure: sum_responded_shift_scheduling {
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [shift_planning:  "not null"]
}


measure: sum_responded_work_duties {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [work_duties: "not null"]
}


measure: sum_responded_work_environment_atmosphere {
  group_label: "# Responses"
  type: count_distinct
  value_format: "0"
  sql: ${uuid};;
  filters: [work_environment_atmosphere: "not null"]
}


###################################### AVG #############################################

measure: avg_nps {
  group_label: "NPS"
  type: average
  value_format: "0"
  sql: ${nps};;
}

measure: avg_bikes {
  group_label: "Bikes"
  label: "All Bikes"
  type: average
  value_format: "0.0"
  sql: ${bikes};;
}

measure: avg_dockr_cargo_bikes_ {
  group_label: "Bikes"
  label: "Cargo Bikes"
  type: average
  value_format: "0.0"
  sql: ${dockr_cargo_bikes_};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_dockr_cargo_bikes._rendered_value }} answers)</i> ;;

}

measure: avg_get_henry_black_ {
  group_label: "Bikes"
  label: "Get Henry Black Bikes"
  type: average
  value_format: "0.0"
  sql: ${get_henry_black_};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_get_henry_black._rendered_value }} answers)</i> ;;

}


measure: avg_get_henry_white_ {
  group_label: "Bikes"
  label: "Get Henry White Bikes"
  type: average
  value_format: "0.0"
  sql: ${get_henry_white_};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_get_henry_white._rendered_value }} answers)</i> ;;

}

measure: avg_movelo {
  group_label: "Bikes"
  label: "Movelo Bikes"
  type: average
  value_format: "0.0"
  sql: ${movelo};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_movelo._rendered_value }} answers)</i> ;;

}

measure: avg_smartvelo {
  group_label: "Bikes"
  label: "Smartvelo Bikes"
  type: average
  value_format: "0.0"
  sql: ${smartvelo};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_smartvelo._rendered_value }} answers)</i> ;;

}

measure: avg_swapfiets {
  group_label: "Bikes"
  label: "Swapfiets Bikes"
  type: average
  value_format: "0.0"
  sql: ${swapfiets};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_swapfiets._rendered_value }} answers)</i> ;;

}

measure: avg_tier {
  group_label: "Bikes"
  label: "Tier Bikes"
  type: average
  value_format: "0.0"
  sql: ${tier};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_tier._rendered_value }} answers)</i> ;;
}

measure: avg_zoomo {
  group_label: "Bikes"
  label: "Zoomo Bikes"
  type: average
  value_format: "0.0"
  sql: ${zoomo};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_zoomo._rendered_value }} answers)</i> ;;

}

measure: avg_moby {
  group_label: "Bikes"
  label: "Moby Bikes"
  type: average
  value_format: "0.0"
  sql: ${moby};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_moby._rendered_value }} answers)</i> ;;

}

measure: avg_dott {
  group_label: "Bikes"
  label: "Dott Bikes"
  type: average
  value_format: "0.0"
  sql: ${dott};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_dott._rendered_value }} answers)</i> ;;

}

measure: avg_kemmrod {
  group_label: "Bikes"
  label: "Kemmrod Bikes"
  type: average
  value_format: "0.0"
  sql: ${kemmrod};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_kemmrod._rendered_value }} answers)</i> ;;

}

measure: avg_vely_velo {
  label: "VelyVelo Bikes"
  group_label: "Bikes"
  type: average
  value_format: "0.0"
  sql: ${vely_velo};;
  html:  {{rendered_value}} <br><i>(# {{ sum_responded_vely_velo._rendered_value }} answers)</i> ;;

}

  measure: avg_i_am_satisfied_with_the_hub_working_conditions_ {
    group_label: "Hub Infrastructure"
    label: "I Am Satisfied With The Hub Working Conditions"
    type: average
    value_format: "0.0"
    sql: ${_i_am_satisfied_with_the_hub_working_conditions_};;

  }

measure: avg_i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_ {
  group_label: "Bikes"
  label: "I Am Satisfied With The Quality Of Rider Equipment at Flink"
  type: average
  value_format: "0.0"
  sql: ${i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_};;
}

measure: avg_i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_clothing {
  group_label: "Bikes"
  label: "I Am Satisfied With The Quality Of Rider Equipment at Flink (Clothing)"
  type: average
  value_format: "0.0"
  sql: ${i_am_satisfied_with_the_quality_of_rider_equipment_at_flink_clothing};;
}

measure: avg_my_hub_adheres_to_the_highest_safety_standards_ {
  group_label: "Hub Infrastructure"
  label: "My Hub Adheres To The Highest Safety Standards"
  type: average
  value_format: "0.0"
  sql: ${_my_hub_adheres_to_the_highest_safety_standards_};;
}

measure: avg_my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_ {
  group_label: "Shift Planning"
  label: "My shifts are Planned Flexibly taking into Account my Responsibilities Outside of Flink"
  type: average
  value_format: "0.0"
  sql: ${my_shifts_are_planned_flexibly_taking_into_account_my_responsibilities_outside_of_flink_};;
}

measure: avg_quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_ {
  group_label: "Shift Planning"
  label: "Quinyx is a Good tool for Keeping me Informed about Upcoming Shifts and Requesting Absences"
  type: average
  value_format: "0.0"
  sql: ${quinyx_is_a_good_tool_for_keeping_me_informed_about_upcoming_shifts_and_requesting_absences_};;
}

measure: avg_my_supervisor_s_cares_about_their_employees_ {
  group_label: "Work Environment"
  label: "My Supervisor(s) Cares About Their Employees"
  type: average
  value_format: "0.0"
  sql: ${my_supervisor_s_cares_about_their_employees_};;
}

measure: avg_my_supervisor_s_treats_everyone_fairly_ {
  group_label: "Work Environment"
  label: "My Supervisor(s) Treats Everyone Fairly"
  type: average
  value_format: "0.0"
  sql: ${my_supervisor_s_treats_everyone_fairly_};;
}

measure: avg_i_feel_comfortable_giving_opinions_and_feedback_to_managers_ {
  group_label: "Work Environment"
  label: "I Feel Comfortable Giving Opinions and Feedback to Managers"
  type: average
  value_format: "0.0"
  sql: ${i_feel_comfortable_giving_opinions_and_feedback_to_managers_};;
}

measure: avg_if_i_do_great_work_i_know_that_it_will_be_recognised_ {
  group_label: "Work Environment"
  label: "If I do Great Work I Know That it Will Be Recognised"
  type: average
  value_format: "0.0"
  sql: ${if_i_do_great_work_i_know_that_it_will_be_recognised_};;
}

  measure: avg_there_is_a_strong_level_of_teamwork_in_the_hub_ {
    group_label: "Work Environment"
    label: "There Is A Strong Level Of Teamwork In The Hub"
    type: average
    value_format: "0.0"
    sql: ${there_is_a_strong_level_of_teamwork_in_the_hub_};;
  }


measure: avg_communication_support {
  group_label: "Communication & Support"
  label: "Communication Support Hub Care Team"
  type: average
  value_format: "0.0"
  sql: ${communication_support};;
}

measure: avg_hub_infrastructure {
  group_label: "Hub Infrastructure"
  label: "Hub Infrastructure"
  type: average
  value_format: "0.0"
  sql: ${hub_infrastructure};;
}

measure: avg_on_boarding_experience {
  group_label: "On-Boarding Experience"
  label: "On-boarding Experience"
  type: average
  value_format: "0.0"
  sql: ${on_boarding_experience};;
}

measure: avg_payments {
  group_label: "Payments"
  label: "Payments"
  type: average
  value_format: "0.0"
  sql: ${payments};;
}

measure: avg_rider_app {
  group_label: "Rider App"
  label: "Rider App"
  type: average
  value_format: "0.0"
  sql: ${rider_app};;
}

measure: avg_shift_planning {
  group_label: "Shift Planning"
  label: "Shift Scheduling"
  type: average
  value_format: "0.0"
  sql: ${shift_planning};;
}

measure: avg_work_duties {
  group_label: "Work Duties"
  label: "Work Duties"
  type: average
  value_format: "0.0"
  sql: ${work_duties};;
}

measure: avg_work_environment_atmosphere {
  group_label: "Work Environment"
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
