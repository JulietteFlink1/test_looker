view: 202112_202109_hq_pulse_results {
  sql_table_name: `flink-data-dev.enps.hq_pulse_results`
      ;;

  dimension: token {
    type: string
    primary_key: yes
    sql: ${TABLE}.token ;;
  }

  dimension: are_you_a_people_manager_ {
    type: number
    sql: ${TABLE}.Are_you_a_People_Manager_ ;;
  }


  dimension: organizational_fit {
    type: string
    sql: case when ${TABLE}.organizational_fit like '%I strongly disagree%' then 1
              when ${TABLE}.organizational_fit like '%I disagree%' then 2
              when ${TABLE}.organizational_fit like '%I neither%' then 3
              when ${TABLE}.organizational_fit like '%I agree%' then 4
              when ${TABLE}.organizational_fit like '%I strongly agree%' then 5
             END;;
  }

  dimension: opportunities_for_development {
    type: string
    sql: case when ${TABLE}.opportunities_for_development like '%I strongly disagree%' then 1
              when ${TABLE}.opportunities_for_development like '%I disagree%' then 2
              when ${TABLE}.opportunities_for_development like '%I neither%' then 3
              when ${TABLE}.opportunities_for_development like '%I agree%' then 4
              when ${TABLE}.opportunities_for_development like '%I strongly agree%' then 5
             END;;
  }

  dimension: feedback {
    type: string
    sql: case when ${TABLE}.feedback like '%I strongly disagree%' then 1
              when ${TABLE}.feedback like '%I disagree%' then 2
              when ${TABLE}.feedback like '%I neither%' then 3
              when ${TABLE}.feedback like '%I agree%' then 4
              when ${TABLE}.feedback like '%I strongly agree%' then 5
             END;;
  }

  dimension: autonomy {
    type: string
    sql: case when ${TABLE}.autonomy like '%I strongly disagree%' then 1
              when ${TABLE}.autonomy like '%I disagree%' then 2
              when ${TABLE}.autonomy like '%I neither%' then 3
              when ${TABLE}.autonomy like '%I agree%' then 4
              when ${TABLE}.autonomy like '%I strongly agree%' then 5
             END;;
  }

  dimension: recognition {
    type: string
    sql: case when ${TABLE}.recognition like '%I strongly disagree%' then 1
              when ${TABLE}.recognition like '%I disagree%' then 2
              when ${TABLE}.recognition like '%I neither%' then 3
              when ${TABLE}.recognition like '%I agree%' then 4
              when ${TABLE}.recognition like '%I strongly agree%' then 5
             END;;
  }



  dimension: on_a_scale_from_0_10__how_likely_are_you_to_recommend_Flink_as_a_place_to_work_to_a_friend_or_family_member_ {
    type: number
    sql: ${TABLE}.on_a_scale_from_0_10__how_likely_are_you_to_recommend_Flink_as_a_place_to_work_to_a_friend_or_family_member_ ;;
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
    sql: ${TABLE}.submit_date__utc_ ;;
  }

  dimension_group: survey_month {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.survey_month ;;
  }

  dimension: what_country_are_you_based_in__ {
    type: string
    sql: ${TABLE}.what_country_are_you_based_in__ ;;
  }

  dimension: what_department_do_you_work_in_ {
    type: string
    sql: ${TABLE}.what_department_do_you_work_in_ ;;
  }

  dimension: why_did_you_rate_this_way {
    label: "Why did you rate this way?"
    type: string
    sql: ${TABLE}.why_did_you_rate_this_way ;;
  }

  dimension: survey_type {
    type: string
    sql: 'HQ' ;;
  }

  measure: organizational_fitavg {
    label: "Organizational Fit"
    type: average
    value_format: "0.0"
    sql: ${organizational_fit};;
  }

  measure: opportunities_for_developmentavg {
    label: "Opportunities for Development"
    type: average
    value_format: "0.0"
    sql: ${opportunities_for_development};;
  }

  measure: feedbackavg {
    label: "Feedback"
    type: average
    value_format: "0.0"
    sql: ${feedback};;
  }

  measure: autonomyavg {
    label: "Autonomy"
    type: average
    value_format: "0.0"
    sql: ${autonomy};;
  }

  measure: recognitionavg{
    label: "Recognition"
    type: average
    value_format: "0.0"
    sql: ${recognition};;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}


