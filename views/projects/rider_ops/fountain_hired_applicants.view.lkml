view: fountain_hired_applicants {
  sql_table_name: `flink-data-staging.curated.fountain_hired_applicants`
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

  dimension: days_to_hire {
    type: number
    sql: ${TABLE}.days_to_hire ;;
  }

  dimension: funnel {
    type: string
    sql: ${TABLE}.funnel ;;
  }

  dimension: hires {
    type: number
    sql: ${TABLE}.hires ;;
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
