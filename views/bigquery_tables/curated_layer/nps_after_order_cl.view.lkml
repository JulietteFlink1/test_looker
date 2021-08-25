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
    sql: ${TABLE}.nps_driver ;;
  }

  dimension: nps_comment {
    type: string
    sql: ${TABLE}.nps_comment ;;
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
    sql: ${TABLE}.last_modified_at ;;
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
  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
    hidden: no
  }

  dimension: response_uuid {
    type: string
    sql: ${TABLE}.response_uuid ;;
    hidden: no
    primary_key: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: cnt_responses {
    label: "# NPS Responses"
    type: sum
    sql: ${TABLE}.is_nps_response ;;
  }

  measure: cnt_detractors {
    label: "# Detractors"
    type: sum
    sql: ${TABLE}.is_detractor ;;
  }


  measure: cnt_passives {
    label: "# Passives"
    type: sum
    sql: ${TABLE}.is_passive ;;
  }

  measure: cnt_promoters {
    label: "# Promoters"
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
