view: 202109_hq_pulse_results {
  sql_table_name: `flink-data-dev.enps.202109_hq_pulse_results`
    ;;

  dimension: token {
    type: string
    primary_key: yes
    sql: ${TABLE}._ ;;
  }

  dimension: are_you_a_people_manager_ {
    type: number
    sql: ${TABLE}.Are_you_a_People_Manager_ ;;
  }

  dimension: i_am_fairly_rewarded__e_g__pay__promotion__training__for_my_contributions_to_flink_ {
    type: string
    sql: case when ${TABLE}.I_am_fairly_rewarded__e_g__pay__promotion__training__for_my_contributions_to_Flink_ like '%I strongly disagree%' then 1
              when ${TABLE}.I_am_fairly_rewarded__e_g__pay__promotion__training__for_my_contributions_to_Flink_ like '%I disagree%' then 2
              when ${TABLE}.I_am_fairly_rewarded__e_g__pay__promotion__training__for_my_contributions_to_Flink_ like '%I neither%' then 3
              when ${TABLE}.I_am_fairly_rewarded__e_g__pay__promotion__training__for_my_contributions_to_Flink_ like '%I agree%' then 4
              when ${TABLE}.I_am_fairly_rewarded__e_g__pay__promotion__training__for_my_contributions_to_Flink_ like '%I strongly agree%' then 5
             END;;
  }

  dimension: i_am_given_opportunities_to_learn_and_develop_my_skills_ {
    type: string
    sql: case when ${TABLE}.I_am_given_opportunities_to_learn_and_develop_my_skills_ like '%I strongly disagree%' then 1
              when ${TABLE}.I_am_given_opportunities_to_learn_and_develop_my_skills_ like '%I disagree%' then 2
              when ${TABLE}.I_am_given_opportunities_to_learn_and_develop_my_skills_ like '%I neither%' then 3
              when ${TABLE}.I_am_given_opportunities_to_learn_and_develop_my_skills_ like '%I agree%' then 4
              when ${TABLE}.I_am_given_opportunities_to_learn_and_develop_my_skills_ like '%I strongly agree%' then 5
             END;;
  }

  dimension: i_feel_comfortable_giving_opinions_and_feedback_to_managers_ {
    type: string
    sql: case when ${TABLE}.I_feel_comfortable_giving_opinions_and_feedback_to_managers_ like '%I strongly disagree%' then 1
              when ${TABLE}.I_feel_comfortable_giving_opinions_and_feedback_to_managers_ like '%I disagree%' then 2
              when ${TABLE}.I_feel_comfortable_giving_opinions_and_feedback_to_managers_ like '%I neither%' then 3
              when ${TABLE}.I_feel_comfortable_giving_opinions_and_feedback_to_managers_ like '%I agree%' then 4
              when ${TABLE}.I_feel_comfortable_giving_opinions_and_feedback_to_managers_ like '%I strongly agree%' then 5
             END;;
  }

  dimension: i_m_given_enough_freedom_to_decide_how_to_do_my_work_ {
    type: string
    sql: case when ${TABLE}.I_m_given_enough_freedom_to_decide_how_to_do_my_work_ like '%I strongly disagree%' then 1
              when ${TABLE}.I_m_given_enough_freedom_to_decide_how_to_do_my_work_ like '%I disagree%' then 2
              when ${TABLE}.I_m_given_enough_freedom_to_decide_how_to_do_my_work_ like '%I neither%' then 3
              when ${TABLE}.I_m_given_enough_freedom_to_decide_how_to_do_my_work_ like '%I agree%' then 4
              when ${TABLE}.I_m_given_enough_freedom_to_decide_how_to_do_my_work_ like '%I strongly agree%' then 5
             END;;
  }

  dimension: if_i_do_great_work__i_know_that_it_will_be_recognized_ {
    type: string
    sql: case when ${TABLE}.If_I_do_great_work__I_know_that_it_will_be_recognized_ like '%I strongly disagree%' then 1
              when ${TABLE}.If_I_do_great_work__I_know_that_it_will_be_recognized_ like '%I disagree%' then 2
              when ${TABLE}.If_I_do_great_work__I_know_that_it_will_be_recognized_ like '%I neither%' then 3
              when ${TABLE}.If_I_do_great_work__I_know_that_it_will_be_recognized_ like '%I agree%' then 4
              when ${TABLE}.If_I_do_great_work__I_know_that_it_will_be_recognized_ like '%I strongly agree%' then 5
             END;;
  }

  dimension: if_you_could_be_the_ceo_of_flink_for_one_day__what_would_you_change_ {
    type: string
    sql: ${TABLE}.If_you_could_be_the_CEO_of_Flink_for_one_day__what_would_you_change_
        ;;
  }

  dimension: network_id {
    type: string
    sql: ${TABLE}.Network_ID ;;
  }

  dimension: on_a_scale_from_1_10__how_likely_are_you_to_recommend_flink_as_a_place_to_work_to_a_friend_or_family_member_ {
    type: number
    sql: ${TABLE}.On_a_scale_from_1_10__how_likely_are_you_to_recommend_Flink_as_a_place_to_work_to_a_friend_or_family_member_ ;;
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

  dimension: what_country_are_you_based_in__ {
    type: string
    sql: ${TABLE}.What_country_are_you_based_in__ ;;
  }

  dimension: what_department_do_you_work_in_ {
    type: string
    sql: ${TABLE}.What_department_do_you_work_in_ ;;
  }

  dimension: why_did_you_rate_this_way__ {
    type: string
    sql: ${TABLE}.Why_did_you_rate_this_way__ ;;
  }

  dimension: survey_type {
    type: string
    sql: 'HQ' ;;
  }

  measure: i_am_fairly_rewarded__e_g__pay__promotion__training__for_my_contributions_to_flink_avg {
    type: average
    value_format: "0.0"
    sql: ${i_am_fairly_rewarded__e_g__pay__promotion__training__for_my_contributions_to_flink_};;
  }

  measure: i_am_given_opportunities_to_learn_and_develop_my_skills_avg {
    type: average
    value_format: "0.0"
    sql: ${i_am_given_opportunities_to_learn_and_develop_my_skills_};;
  }

  measure: i_feel_comfortable_giving_opinions_and_feedback_to_managers_avg {
    type: average
    value_format: "0.0"
    sql: ${i_feel_comfortable_giving_opinions_and_feedback_to_managers_};;
  }

  measure: i_m_given_enough_freedom_to_decide_how_to_do_my_work_avg {
    type: average
    value_format: "0.0"
    sql: ${i_m_given_enough_freedom_to_decide_how_to_do_my_work_};;
  }

  measure: if_i_do_great_work__i_know_that_it_will_be_recognized_avg{
    type: average
    value_format: "0.0"
    sql: ${if_i_do_great_work__i_know_that_it_will_be_recognized_};;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
