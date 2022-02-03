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
