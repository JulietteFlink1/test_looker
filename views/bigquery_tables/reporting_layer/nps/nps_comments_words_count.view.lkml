view: nps_comments_words_count {
  sql_table_name: `flink-data-prod.reporting.nps_comments_words_count`
    ;;

  dimension: column {
    type: number
    sql: ${TABLE}.column ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: response_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.response_uuid  ;;
  }

  dimension: nps_driver {
    type: string
    sql: ${TABLE}.nps_driver ;;
  }

  dimension: nps_score {
    type: number
    sql: ${TABLE}.nps_score ;;
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

  dimension: is_bigram {
    type: number
    sql: case when length(REGEXP_REPLACE(${word},' ',''))=length(${word}) then 0 else 1 end ;;
  }

  measure: num_occurrences {
    type: count
  }

  dimension: word {
    type: string
    sql: ${TABLE}.word ;;
  }

  measure: count {
    type: count
    drill_fields: [word]
  }
}
