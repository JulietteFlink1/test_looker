view: 202109_all_pulse_results {
  sql_table_name: `flink-data-dev.enps.202109_all_pulse_results`
    ;;

  dimension: nps {
    type: number
    sql: ${TABLE}.nps ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.score ;;
  }

  dimension: survey_type {
    type: string
    sql: ${TABLE}.survey_type ;;
  }

  dimension: token {
    type: string
    primary_key:  yes
    sql: ${TABLE}.token ;;
  }

  measure: avg_nps {
    type: average
    value_format: "0"
    sql:  ${nps} ;;
  }

  dimension: group {
    type: string
    sql: CASE WHEN ${nps}<=6 THEN "Detractors"
              WHEN ${nps}>=9 THEN "Promoters"
              ELSE "Passives" END;;
  }
  measure: count {
    type: count
    drill_fields: []
  }
}
