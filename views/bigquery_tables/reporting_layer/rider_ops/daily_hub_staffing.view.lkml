view: daily_hub_staffing {
  sql_table_name: `flink-data-prod.reporting.daily_hub_staffing`
    ;;

  dimension: daily_staffing_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.daily_staffing_uuid ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: number_of_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: number_of_planned_hours {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_hours ;;
  }

  dimension: number_of_worked_hours {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_hours ;;
  }

  dimension: numbre_of_no_show_hours {
    type: number
    hidden: yes
    sql: ${TABLE}.numbre_of_no_show_hours ;;
  }

  dimension: position_name {
    type: string
    sql: ${TABLE}.position_name ;;
  }

  dimension_group: shift {
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
    sql: ${TABLE}.shift_date ;;
  }


  measure: sum_orders{
    type: sum
    label:"# Actual Orders"
    sql:${number_of_orders};;
    value_format_name: decimal_0
  }

  measure: sum_planned_hours{
    type: sum
    label:"Sum Planned Hours"
    description: "Number of Planned/Scheduled Hours"
    sql:${number_of_planned_hours};;
    value_format_name: decimal_1
  }

  measure: sum_worked_hours{
    type: sum
    label:"Sum Worked Hours"
    description: "Number of Planned/Scheduled Hours"
    sql:${number_of_worked_hours};;
    value_format_name: decimal_1
  }


  measure: count {
    type: count
    drill_fields: [position_name]
  }
}
