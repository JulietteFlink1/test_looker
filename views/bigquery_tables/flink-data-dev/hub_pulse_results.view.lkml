view: 202112_202109_hub_pulse_results {
  sql_table_name: sql_table_name: `flink-data-dev.enps.202121_hub_pulse_results`
  ;;

  dimension: token {
    type: string
    primary_key: yes
    sql: ${TABLE}._ ;;
  }

  dimension: _If_you_could_change_three_things_about_the_day_to_day_hub_operations__what_would_it_be___ {
    label: "If you could change 3 things about the day to day hub operations what would it be?"
    type: string
    sql: ${TABLE}._If_you_could_change_three_things_about_the_day_to_day_hub_operations__what_would_it_be___ ;;
  }

  dimension: _On_a_scale_from_0_10__how_likely_are_you_to_recommend_Flink_as_a_place_to_work_to_a_friend_or_family_member____0___Very_unlikely__10___Very_likely____ {
    type: number
    sql: ${TABLE}._On_a_scale_from_0_10__how_likely_are_you_to_recommend_Flink_as_a_place_to_work_to_a_friend_or_family_member____0___Very_unlikely__10___Very_likely____ ;;
  }

  dimension: role {
    label: "Role"
    type: string
    sql: ${TABLE}.role ;;
  }

  dimension: contract_type {
    label: "Contract Type"
    type: string
    sql: ${TABLE}.contract_type ;;
  }

  dimension: hub {
    label: "Hub"
    type: string
    sql: ${TABLE}.hub ;;
  }

  dimension: location {
    label: "Location"
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: _why_did_you_rate_this_way___ {
    label: "Why did you rate this way?"
    type: string
    sql: ${TABLE}._why_did_you_rate_this_way___ ;;
  }

  dimension: work_satisfaction {
    label: "Work Satisfaction"
    type: string
    sql: case when ${TABLE}.work_satisfaction like '%I strongly disagree%' then 1
              when ${TABLE}.work_satisfaction like '%I disagree%' then 2
              when ${TABLE}.work_satisfaction like '%I neither%' then 3
              when ${TABLE}.work_satisfaction like '%I agree%' then 4
              when ${TABLE}.work_satisfaction like '%I strongly agree%' then 5
             END;;
  }

  dimension: work_life_balance {
    label: "Work Life Balance"
    type: string
    sql: case when ${TABLE}.work_life_balance like '%I strongly disagree%' then 1
              when ${TABLE}.work_life_balance like '%I disagree%' then 2
              when ${TABLE}.work_life_balance like '%I neither%' then 3
              when ${TABLE}.work_life_balance like '%I agree%' then 4
              when ${TABLE}.work_life_balance like '%I strongly agree%' then 5
             END;;
  }

  dimension: clarity_of_mission {
    label: "Clarity of Mission"
    type: string
    sql: case when ${TABLE}.clarity_of_mission like '%I strongly disagree%' then 1
              when ${TABLE}.clarity_of_mission like '%I disagree%' then 2
              when ${TABLE}.clarity_of_mission like '%I neither%' then 3
              when ${TABLE}.clarity_of_mission like '%I agree%' then 4
              when ${TABLE}.clarity_of_mission like '%I strongly agree%' then 5
             END;;
  }

  dimension: supervisor {
    label: "Supervisor"
    type: string
    sql: case when ${TABLE}.supervisor like '%I strongly disagree%' then 1
              when ${TABLE}.supervisor like '%I disagree%' then 2
              when ${TABLE}.supervisor like '%I neither%' then 3
              when ${TABLE}.supervisor like '%I agree%' then 4
              when ${TABLE}.supervisor like '%I strongly agree%' then 5
             END;;
  }


  dimension: survey_type {
    type: string
    sql: 'Hubs' ;;
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

  measure: work_satisfactionavg  {
    type: average
    value_format: "0.0"
    label: "Work Satisfaction"
    sql: ${work_satisfaction} ;;
  }

  measure: work_life_balanceavg  {
    type: average
    value_format: "0.0"
    label: "Work Life Balance"
    sql: ${work_life_balance} ;;
  }

  measure: clarity_of_missionavg  {
    type: average
    value_format: "0.0"
    label: "Clarity of Mission"
    sql: ${clarity_of_mission} ;;
  }

  measure: supervisoravg  {
    type: average
    value_format: "0.0"
    label: "Supervisor"
    sql: ${supervisor} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
