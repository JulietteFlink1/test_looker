view: fountain_rejection_breakdown {
  sql_table_name: `flink-data-staging.curated.fountain_rejection_breakdown`
    ;;

  dimension: applicants {
    type: number
    sql: ${TABLE}.applicants ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
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

  dimension: rejection_reason {
    type: string
    sql: ${TABLE}.rejection_reason ;;
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

  measure: count {
    type: count
    drill_fields: []
  }
}
