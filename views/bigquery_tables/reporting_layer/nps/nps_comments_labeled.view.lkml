view: nps_comments_labeled {
  sql_table_name: `flink-data-dev.reporting.nps_comments_labeled`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: label {
    label: "Topic"
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: nps_driver {
    label: "NPS Comment"
    type: string
    sql: ${TABLE}.nps_driver ;;
  }

  dimension: nps_score {
    type: number
    sql: ${TABLE}.nps_score ;;
  }

  dimension: customer_group {
    type: string
    label: "Group"
    sql: case when ${nps_score}>=9 then 'Promoters'
              when ${nps_score}<=6 then 'Detractors'
              else 'Passives'
              end
      ;;
  }

  dimension: prediction {
    type: number
    sql: ${TABLE}.prediction ;;
  }

  dimension: response_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.response_uuid ;;
  }

  dimension_group: submitted {
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
    sql: ${TABLE}.submitted_date ;;
  }

  measure: num_responses {
    label: "# NPS Responses"
    type: count_distinct
    sql: ${response_uuid} ;;
  }

  measure: sum_predictions {
    label: "# Topic Occurrences"
    type: sum
    sql: ${prediction}
    ;;
  }

  dimension: nps {
    type: number
    sql: case when ${nps_score} >= 9 then 100
              when ${nps_score} <= 6 then -100
              else 0 end;;
  }

  measure: avg_nps {
    label: "AVG NPS"
    type: average
    sql: ${nps}
    ;;
    value_format:  "0"
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
