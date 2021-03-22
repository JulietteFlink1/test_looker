view: nps_after_order {
  derived_table: {
  datagroup_trigger: flink_default_datagroup
  sql:
      SELECT * FROM
      (
          SELECT
          'DE' AS country_iso,
          token,
          submitted_at,
          CAST(o AS INT64) AS order_id,
          CAST(score AS INT64) AS score,
          vielen_dank__was_ist_der_hauptgrund_f_r_deine_einsch_tzung_ AS nps_driver,
          was_k_nnen_wir_zus_tzlich_tun__um_flink_zu_verbessern_ AS nps_comment,
          row_number() over(partition by o order by submitted_at desc) AS rnk

          FROM `flink-backend.gsheet_nps.Flink_Feedback_DE`
          WHERE o NOT IN ('999999', '999,999', 'xxxxx')
      )
      WHERE rnk=1
      order by submitted_at
;;
}
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
    sql: ${TABLE}.nps_driver ;;
  }

  dimension: nps_comment {
    type: string
    sql: ${TABLE}.nps_comment ;;
  }


##### MEASURES #####

  measure: count {
    type: count
    drill_fields: []
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
    sql: ${cnt_detractors} / NULLIF(${count}, 0);;
    value_format: "0%"
  }

  measure: pct_passives{
    label: "% Passives"
    description: "Share of Passives over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_passives} / NULLIF(${count}, 0);;
    value_format: "0%"
  }

  measure: pct_promoters{
    label: "% Promoters"
    description: "Share of Promoters over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_promoters} / NULLIF(${count}, 0);;
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
