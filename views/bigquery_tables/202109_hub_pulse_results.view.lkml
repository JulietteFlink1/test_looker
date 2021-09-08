view: 202109_hub_pulse_results {
  sql_table_name: `flink-data-dev.enps.202109_hub_pulse_results`
    ;;

  dimension: token {
    type: string
    primary_key: yes
    sql: ${TABLE}._ ;;
  }

  dimension: _if_you_could_change_three_things_about_the_day_to_day_hub_operations__what_would_it_be___ {
    type: string
    sql: ${TABLE}._If_you_could_change_three_things_about_the_day_to_day_hub_operations__what_would_it_be___ ;;
  }

  dimension: _on_a_scale_from_1_10__how_likely_are_you_to_recommend_flink_as_a_place_to_work_to_a_friend_or_family_member____1___very_unlikely__10___very_likely____ {
    type: number
    sql: ${TABLE}._On_a_scale_from_1_10__how_likely_are_you_to_recommend_Flink_as_a_place_to_work_to_a_friend_or_family_member____1___Very_unlikely__10___Very_likely____ ;;
  }

  dimension: _what_is_your_role___ {
    type: string
    sql: ${TABLE}._What_is_your_role___ ;;
  }

  dimension: _what_type_of_contract_do_you_have___ {
    type: string
    sql: ${TABLE}._What_type_of_contract_do_you_have___ ;;
  }

  dimension: _which_hub_do_you_work_in___ {
    type: string
    sql: ${TABLE}._Which_hub_do_you_work_in___ ;;
  }

  dimension: _which_location_do_you_work_in__ {
    type: string
    sql: ${TABLE}._Which_location_do_you_work_in__ ;;
  }

  dimension: _why_did_you_rate_this_way___ {
    type: string
    sql: ${TABLE}._Why_did_you_rate_this_way___ ;;
  }

  dimension: i_enjoy_doing_my_job_ {
    type: string
    sql: ${TABLE}.I_enjoy_doing_my_job_ ;;
  }

  dimension: i_feel_i_have_a_good_work_life_balance_ {
    type: string
    sql: ${TABLE}.I_feel_I_have_a_good_work_life_balance_ ;;
  }

  dimension: i_understand_how_my_work_contributes_to_the_achievement_of_the_company_s_goal_ {
    type: string
    sql: ${TABLE}.I_understand_how_my_work_contributes_to_the_achievement_of_the_company_s_goal_ ;;
  }

  dimension: my_direct_supervisor_s__manage_employees_effectively_ {
    type: string
    sql: ${TABLE}.My_direct_supervisor_s__manage_employees_effectively_ ;;
  }

  dimension: network_id {
    type: string
    sql: ${TABLE}.Network_ID ;;
  }

  dimension: survey_type {
    type: string
    sql: 'Hub' ;;
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

  measure: count {
    type: count
    drill_fields: []
  }
}
