view: fountain_funnel_pipeline {
  sql_table_name: `flink-data-staging.curated.fountain_funnel_pipeline`
    ;;

  dimension: applicants {
    type: number
    sql: ${TABLE}.applicants ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: funnel {
    type: string
    sql: ${TABLE}.funnel ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}.start_date ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
