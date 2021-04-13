view: nps_after_order {
sql_table_name: `flink-backend.gsheet_nps.results_global`;;

dimension: country_iso {
  type: string
  sql: ${TABLE}.country_iso ;;
}

dimension: order_id {
  type: number
  sql: ${TABLE}.order_id ;;
}


dimension: score {
  type: number
  sql: ${TABLE}.score ;;
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

dimension: token {
  type: string
  primary_key: yes
  sql: ${TABLE}.token ;;
}

dimension: nps_driver {
  type: string
  sql: ${TABLE}.driver_comment ;;
}

dimension: nps_comment {
  type: string
  sql: ${TABLE}.what_can_we_do_to_improve ;;
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
