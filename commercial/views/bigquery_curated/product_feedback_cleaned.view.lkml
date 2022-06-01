view: product_feedback_cleaned {
  sql_table_name: `flink-data-dev.sandbox.product_feedback_cleaned`
    ;;

  dimension: phrases_matches {
    type: string
    sql: ${TABLE}.phrases_matches ;;
  }

  dimension: stemmed_words {
    type: string
    sql: ${TABLE}.stemmed_words ;;
  }

  dimension: word_matches {
    type: string
    sql: ${TABLE}.word_matches ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
