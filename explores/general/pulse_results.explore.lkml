include: "/views/**/all_pulse_results.view.lkml"
include: "/views/**/202109_hub_pulse_results.view.lkml"
include: "/views/**/202109_rider_pulse_results.view.lkml"
include: "/views/**/202109_hq_pulse_results.view.lkml"
include: "/views/**/*.view"
include: "/views/**/hub_pulse_results.view.lkml"
include: "/views/**/hq_pulse_results.view.lkml"

explore: pulse_results {
  hidden:yes
  from: all_pulse_results
  label: "All Pulse Results"
  view_label: "All Pulse Results"
  group_label: "18) People Ops"
  description: "Pulse Check Survey Results - 2021/09"


  access_filter: {
    field: pulse_results.country_iso
    user_attribute: country_iso
  }



  join: hq_pulse_results {
    from: 202109_hq_pulse_results
    sql_on: ${pulse_results.token} = ${hq_pulse_results.token}
      AND ${pulse_results.survey_type} = ${hq_pulse_results.survey_type} ;;
    relationship: one_to_one
    type: left_outer

  }

  join: rider_pulse_results {
    from: 202109_rider_pulse_results
    sql_on: ${pulse_results.token} = ${rider_pulse_results.token}
      AND ${pulse_results.survey_type} = ${rider_pulse_results.survey_type} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: hub_pulse_results {
    from: 202109_hub_pulse_results
    sql_on: ${pulse_results.token} = ${hub_pulse_results.token}
      AND ${pulse_results.survey_type} = ${hub_pulse_results.survey_type} ;;
    relationship: one_to_one
    type: left_outer
  }
  join: new_hub_pulse_results {
    from: hub_pulse_results
    sql_on: ${pulse_results.token} = ${new_hub_pulse_results.token}
      AND ${pulse_results.survey_type} = ${new_hub_pulse_results.survey_type} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: new_hq_pulse_results {
    from: hq_pulse_results
    sql_on: ${pulse_results.token} = ${new_hq_pulse_results.token}
      AND ${pulse_results.survey_type} = ${new_hq_pulse_results.survey_type} ;;
    relationship: one_to_one
    type: left_outer
  }

}
