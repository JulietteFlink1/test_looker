view: nps_comments_words_ranked {
  derived_table: {
    sql: with words_occurrences AS (
      SELECT word, count(*) as num_occurrences
      FROM `flink-data-dev.reporting.nps_comments_words_count`
      GROUP BY 1)
      select word, row_number() over (order by num_occurrences desc) as rk
      from words_occurrences
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: word {
    primary_key: yes
    type: string
    sql: ${TABLE}.word ;;
  }

  dimension: rk {
    type: number
    sql: ${TABLE}.rk ;;
  }

  set: detail {
    fields: [word, rk]
  }
}
