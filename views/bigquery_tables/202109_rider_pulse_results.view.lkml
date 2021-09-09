view: 202109_rider_pulse_results {
  sql_table_name: `flink-data-dev.enps.202109_rider_pulse_results`
    ;;

  dimension: token {
    type: string
    sql: ${TABLE}._ ;;
  }

  dimension: based_on_your_experience_of_riding_with_flink_so_far__how_likely_are_you_to_recommend_joining_us_to_a_friend_or_a_family_member_ {
    type: number
    sql: ${TABLE}.Based_on_your_experience_of_riding_with_Flink_so_far__how_likely_are_you_to_recommend_joining_us_to_a_friend_or_a_family_member_ ;;
  }

  dimension: how_long_have_you_been_riding_with_us_ {
    label: "Time as a Rider"
    type: string
    sql: ${TABLE}.How_long_have_you_been_riding_with_us_ ;;
  }

  dimension: if_you_were_to_consider_leaving_flink_and_riding_for_another_company__what_would_be_the_reason__ {
    type: string
    sql: ${TABLE}.If_you_were_to_consider_leaving_Flink_and_riding_for_another_company__what_would_be_the_reason__ ;;
  }

  dimension: network_id {
    type: string
    sql: ${TABLE}.Network_ID ;;
  }

  dimension: overall__how_satisfied_or_dissatisfied_are_you_with__aspects_related_to_your_payment__ {
    label: "Payments"
    type: string
    sql: case when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with__aspects_related_to_your_payment__ like '%Very dissatisfied%' then 1
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with__aspects_related_to_your_payment__ like '%Dissatisfied%' then 2
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with__aspects_related_to_your_payment__ like '%Neutral%' then 3
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with__aspects_related_to_your_payment__ like 'Satisfied%' then 4
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with__aspects_related_to_your_payment__ like '%Very satisfied%' then 5
             END;;
  }

  dimension: overall__how_satisfied_or_dissatisfied_are_you_with_the__equipment_provided_by_flink__including_bikes_and_clothing___ {
    label: "Equipment"
    type: string
    sql: case when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__equipment_provided_by_Flink__including_bikes_and_clothing___ like '%Very dissatisfied%' then 1
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__equipment_provided_by_Flink__including_bikes_and_clothing___ like '%Dissatisfied%' then 2
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__equipment_provided_by_Flink__including_bikes_and_clothing___ like '%Neutral%' then 3
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__equipment_provided_by_Flink__including_bikes_and_clothing___ like 'Satisfied%' then 4
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__equipment_provided_by_Flink__including_bikes_and_clothing___ like '%Very satisfied%' then 5
             END;;
  }

  dimension: overall__how_satisfied_or_dissatisfied_are_you_with_the__support_provided_by_flink_rider_care__ {
    label: "Rider Support"
    type: string
    sql: case when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__support_provided_by_Flink_Rider_Care__ like '%Very dissatisfied%' then 1
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__support_provided_by_Flink_Rider_Care__ like '%Dissatisfied%' then 2
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__support_provided_by_Flink_Rider_Care__ like '%Neutral%' then 3
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__support_provided_by_Flink_Rider_Care__ like '%Satisfied%' then 4
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_the__support_provided_by_Flink_Rider_Care__ like '%Very satisfied%' then 5
             END;;
  }

  dimension: overall__how_satisfied_or_dissatisfied_are_you_with_your__flink_hub_infrastructure_and_amenities__ {
    label: "Hub Infrastructure"
    type: string
    sql: case when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__Flink_hub_infrastructure_and_amenities__ like '%Very dissatisfied%' then 1
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__Flink_hub_infrastructure_and_amenities__ like '%Dissatisfied%' then 2
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__Flink_hub_infrastructure_and_amenities__ like '%Neutral%' then 3
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__Flink_hub_infrastructure_and_amenities__ like '%Satisfied%' then 4
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__Flink_hub_infrastructure_and_amenities__ like '%Very satisfied%' then 5
             END;;
  }

  dimension: overall__how_satisfied_or_dissatisfied_are_you_with_your__shift_scheduling__ {
    label: "Shift Scheduling"
    type: string
    sql: case when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__shift_scheduling__ like '%Very dissatisfied%' then 1
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__shift_scheduling__ like '%Dissatisfied%' then 2
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__shift_scheduling__ like '%Neutral%' then 3
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__shift_scheduling__ like '%Satisfied%' then 4
              when ${TABLE}.Overall__how_satisfied_or_dissatisfied_are_you_with_your__shift_scheduling__ like '%Very satisfied%' then 5
             END;;
  }

  dimension: please_give_us_more_details_and_explain_why_you_are_dissatisfied_with__aspects_related_to_your_payment__ {
    label: "Payments Comment"
    type: string
    sql: ${TABLE}.Please_give_us_more_details_and_explain_why_you_are_dissatisfied_with__aspects_related_to_your_payment__ ;;
  }

  dimension: please_give_us_more_details_and_explain_why_you_are_dissatisfied_with__equipment_provided_by_flink__including_bikes_and_clothing___ {
    label: "Equipment Comment"
    type: string
    sql: ${TABLE}.Please_give_us_more_details_and_explain_why_you_are_dissatisfied_with__equipment_provided_by_Flink__including_bikes_and_clothing___ ;;
  }

  dimension: please_give_us_more_details_and_explain_why_you_are_dissatisfied_with_the__support_provided_by_flink_rider_care__ {
    label: "Rider Support Comment"
    type: string
    sql: ${TABLE}.Please_give_us_more_details_and_explain_why_you_are_dissatisfied_with_the__support_provided_by_Flink_Rider_Care__ ;;
  }

  dimension: please_give_us_more_details_and_explain_why_you_are_dissatisfied_with_your__flink_hub_infrastructure_and_amenities__ {
    label: "Hub Infrastructure Comment"
    type: string
    sql: ${TABLE}.Please_give_us_more_details_and_explain_why_you_are_dissatisfied_with_your__Flink_hub_infrastructure_and_amenities__ ;;
  }

  dimension: please_give_us_more_details_and_explain_why_you_are_dissatisfied_with_your__shift_scheduling__ {
    label: "Shift Scheduling Comment"
    type: string
    sql: ${TABLE}.Please_give_us_more_details_and_explain_why_you_are_dissatisfied_with_your__shift_scheduling__ ;;
  }

  dimension: survey_type {
    type: string
    sql: 'Riders' ;;
  }

  dimension_group: start_date__utc_ {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.Start_Date__UTC_ ;;
  }

  dimension_group: submit_date__utc_ {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.Submit_Date__UTC_ ;;
  }

  dimension: what_do_you_believe_is_missing_or_disappointing_in_your_experience_with_flink__ {
    label: "What do you believe is missing or disappointing in your experience with Flink?"
    type: string
    sql: ${TABLE}.What_do_you_believe_is_missing_or_disappointing_in_your_experience_with_Flink__ ;;
  }

  dimension: what_do_you_like_best_about_working_at_flink__ {
    label: "What do you like best about working at Flink?"
    type: string
    sql: ${TABLE}.What_do_you_like_best_about_working_at_Flink__ ;;
  }

  dimension: what_hub_are_you_based_in_ {
    label: "Hub"
    type: string
    sql: ${TABLE}.What_Hub_are_you_based_in_ ;;
  }

  dimension: what_type_of_contract_do_you_have_ {
    label: "Contract Type"
    type: string
    sql: ${TABLE}.What_type_of_contract_do_you_have_ ;;
  }

  measure: overall__how_satisfied_or_dissatisfied_are_you_with__aspects_related_to_your_payment__avg {
    label: "Payments"
    type: average
    value_format: "0.0"
    sql: ${overall__how_satisfied_or_dissatisfied_are_you_with__aspects_related_to_your_payment__} ;;
  }

  measure: overall__how_satisfied_or_dissatisfied_are_you_with_the__equipment_provided_by_flink__including_bikes_and_clothing___avg {
    label: "Equipment"
    type: average
    value_format: "0.0"
    sql: ${overall__how_satisfied_or_dissatisfied_are_you_with_the__equipment_provided_by_flink__including_bikes_and_clothing___} ;;
  }

  measure: overall__how_satisfied_or_dissatisfied_are_you_with_the__support_provided_by_flink_rider_care__avg {
    label: "Rider Support"
    type: average
    value_format: "0.0"
    sql: ${overall__how_satisfied_or_dissatisfied_are_you_with_the__support_provided_by_flink_rider_care__} ;;
  }

  measure: overall__how_satisfied_or_dissatisfied_are_you_with_your__flink_hub_infrastructure_and_amenities__avg {
    label: "Hub Infrastructure"
    type: average
    value_format: "0.0"
    sql: ${overall__how_satisfied_or_dissatisfied_are_you_with_your__flink_hub_infrastructure_and_amenities__} ;;
  }

  measure: overall__how_satisfied_or_dissatisfied_are_you_with_your__shift_scheduling__avg {
    label: "Shift Scheduling"
    type: average
    value_format: "0.0"
    sql: ${overall__how_satisfied_or_dissatisfied_are_you_with_your__shift_scheduling__} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
