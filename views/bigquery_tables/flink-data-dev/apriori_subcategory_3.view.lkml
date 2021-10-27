view: apriori_subcategory_3 {
  sql_table_name: `flink-data-dev.sandbox_justine.apriori_all`
    ;;

  dimension: category_a {
    type: string
    sql: ${TABLE}.category_A ;;
  }

  dimension: category_b {
    type: string
    sql: ${TABLE}.category_B ;;
  }

  dimension: category_c {
    type: string
    sql: ${TABLE}.category_C ;;
  }

  dimension: occurrences {
    type: number
    sql: ${TABLE}.occurrences ;;
  }

  dimension: size {
    type: number
    sql: ${TABLE}.size ;;
  }

  dimension: confidence {
    type: number
    sql: ${TABLE}.confidence ;;
  }

  dimension: granularity {
    type: string
    sql: ${TABLE}.granularity ;;
  }

  dimension: int64_field_0 {
    hidden: yes
    type: number
    sql: ${TABLE}.int64_field_0 ;;
  }

  dimension: lift {
    type: number
    sql: ${TABLE}.lift ;;
  }

  dimension: support {
    type: number
    sql: ${TABLE}.support ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
