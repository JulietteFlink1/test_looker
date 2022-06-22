view: daily_violations_aggregates {
  sql_table_name: `flink-data-dev.reporting.daily_violations_aggregates`
    ;;

  dimension: app_build {
    type: string
    sql: ${TABLE}.app_build ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: daily_violation_uuid {
    type: string
    sql: ${TABLE}.daily_violation_uuid ;;
  }

  dimension_group: event {
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
    sql: ${TABLE}.event_date ;;
  }

  dimension: number_of_violations {
    type: number
    sql: ${TABLE}.number_of_violations ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: tracking_plan_id {
    type: string
    sql: ${TABLE}.tracking_plan_id ;;
  }

  dimension: violated_event_name {
    type: string
    sql: ${TABLE}.violated_event_name ;;
  }

  dimension: violation_description {
    type: string
    sql: ${TABLE}.violation_description ;;
  }

  dimension: violation_field {
    type: string
    sql: ${TABLE}.violation_field ;;
  }

  dimension: violation_type {
    type: string
    sql: ${TABLE}.violation_type ;;
  }

  measure: count {
    type: count
    drill_fields: [violated_event_name]
  }
}
