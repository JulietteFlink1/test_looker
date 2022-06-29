view: daily_violations_aggregates {
  sql_table_name: `flink-data-prod.reporting.daily_violations_aggregates`
    ;;
  view_label: "Daily Violations Aggregates"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

    ######## Table ID ########

  dimension: daily_violation_uuid {
    type: string
    hidden: no
    primary_key: yes
    sql: ${TABLE}.daily_violation_uuid ;;
  }

    ######## Dates ########

  dimension_group: event {
    group_label: "Date Dimensions"
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
    group_label: "Device Attributes"
    type: string
    sql: ${TABLE}.app_build ;;
  }

  dimension: app_version {
    group_label: "Device Attributes"
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: platform {
    group_label: "Device Attributes"
    type: string
    sql: ${TABLE}.platform ;;
  }

    ######## Segment Violation Attributes ########

  dimension: tracking_plan_id {
    group_label: "Violation Attributes"
    type: string
    sql: ${TABLE}.tracking_plan_id ;;
  }

  dimension: violated_event_name {
    group_label: "Violation Attributes"
    type: string
    sql: ${TABLE}.violated_event_name ;;
  }

  dimension: violation_description {
    group_label: "Violation Attributes"
    type: string
    sql: ${TABLE}.violation_description ;;
  }

  dimension: violation_field {
    group_label: "Violation Attributes"
    type: string
    sql: ${TABLE}.violation_field ;;
  }

  dimension: violation_type {
    group_label: "Violation Attributes"
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
