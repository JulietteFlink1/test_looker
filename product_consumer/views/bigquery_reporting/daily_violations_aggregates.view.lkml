view: daily_violations_aggregates {
  sql_table_name: `flink-data-dev.reporting.daily_violations_aggregates`
    ;;
  view_label: "Daily Violations Aggregates"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

    ######## Table ID ########

  dimension: daily_violation_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.daily_violation_uuid ;;
  }

    ######## Dates ########

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
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

    ######## Device Attributes ########

  dimension: app_build {
    type: string
    sql: ${TABLE}.app_build ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

    ######## Segment Violation Attributes ########

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

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures    ~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: number_of_violations {
    type: sum
    sql: ${TABLE}.number_of_violations ;;
  }

  measure: count {
    type: count
    drill_fields: [violated_event_name]
  }
}
