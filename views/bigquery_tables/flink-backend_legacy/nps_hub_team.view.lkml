view: nps_hub_team {
  sql_table_name: `flink-backend.gsheet_hub_nps.Hub_Feedback_DE__EN_`
    ;;

  dimension: country_iso {
    type: string
    sql: LEFT(${TABLE}.hub, 2) ;;
  }


  dimension: contract_type {
    type: string
    sql: ${TABLE}.do_you_work_full_time_or_part_time_ ;;
  }

  dimension: employee_id {
    hidden: yes
    type: string
    sql: ${TABLE}.e ;;
  }

  dimension: working_hours_per_week {
    type: string
    sql: ${TABLE}.how_many_hours_a_week_do_you_work_for_flink_ ;;
  }

  dimension: hub_code {
    type: string
    #hidden: yes
    sql: ${TABLE}.hub ;;
  }

  dimension: nps_comment {
    label: "Suggestion for improvement"
    type: string
    sql: ${TABLE}.if_there_is_one_thing_you_would_improve_about_our_working_conditions__what_would_it_be_ ;;
  }

  dimension: score {
    type: number
    sql: CAST(${TABLE}.score__nu AS INT64) ;;
  }

  dimension: start_date {
    type: string
    sql: ${TABLE}.sd ;;
  }

  dimension_group: submitted {
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
    sql: ${TABLE}.submitted_at ;;
  }

  dimension: job_profile {
    type: string
    sql: ${TABLE}.thank_you__do_you_work_as_a_rider_or_picker_ ;;
  }

  dimension: token {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.token ;;
  }

  dimension: nps_driver {
    label: "Driver (Primary Reason for NPS)"
    type: string
    sql: ${TABLE}.what_do_you_like_best_about_working_at_flink_ ;;
  }

##### MEASURES #####

  measure: cnt_responses {
    type: count
    label: "# NPS Responses"
  }

  measure: cnt_detractors {
    type: count
    filters: [score: "[0,6]"]
  }

  measure: cnt_passives {
    type: count
    filters: [score: "[7,8]"]
  }

  measure: cnt_promoters {
    type: count
    filters: [score: "[9,10]"]
  }

  measure: pct_detractors{
    label: "% Detractors"
    description: "Share of Detractors over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_detractors} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }

  measure: pct_passives{
    label: "% Passives"
    description: "Share of Passives over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_passives} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }

  measure: pct_promoters{
    label: "% Promoters"
    description: "Share of Promoters over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_promoters} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }

  measure: nps_score{
    label: "% NPS"
    description: "NPS Score (After Order)"
    hidden:  no
    type: number
    sql: ${pct_promoters} - ${pct_detractors};;
    value_format: "0%"
  }

}
