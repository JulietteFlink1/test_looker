view: nps_after_order_cl {
  sql_table_name: `flink-data-prod.curated.nps_after_order`
    ;;



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_contactable {
    type: yesno
    sql: ${TABLE}.is_contactable ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.nps_score ;;
  }

  dimension: nps_driver {
    type: string
    sql: ${TABLE}.main_score_driver ;;
  }

  dimension: nps_comment {
    type: string
    sql: ${TABLE}.suggestions_for_improvements ;;
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
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension_group: order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }


  # =========  hidden   =========
  dimension_group: last_modified_at {
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
    sql: ${TABLE}.synched_at ;;
    hidden: yes
  }
  dimension_group: partition_timestamp {
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
    sql: ${TABLE}.partition_timestamp ;;
    hidden: yes
  }


  # =========  IDs   =========
  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
    hidden: no
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
    hidden: no
    primary_key: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: cnt_responses {
    type: sum
    sql: ${TABLE}.is_nps_response ;;
  }

  measure: cnt_detractors {
    type: sum
    sql: ${TABLE}.is_detractor ;;
  }


  measure: cnt_passives {
    type: sum
    sql: ${TABLE}.is_passive ;;
  }

  measure: cnt_promoters {
    type: sum
    sql: ${TABLE}.is_promoter ;;
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
