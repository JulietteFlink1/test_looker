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

  dimension: number_of_planned_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_minutes ;;
  }

  dimension: number_of_worked_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_minutes ;;
  }

  dimension: numbre_of_no_show_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.numbre_of_no_show_minutes ;;
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
    label:"Sum Actual Orders"
    sql:${number_of_orders};;
    value_format_name: decimal_0
  }

  measure: sum_planned_hours{
    type: sum
    label:"Sum Planned Hours"
    description: "Number of Planned/Scheduled Hours"
    sql:${number_of_planned_minutes}/60;;
    value_format_name: decimal_1
  }

  measure: sum_worked_hours{
    type: sum
    label:"Sum Worked Hours"
    description: "Number of Planned/Scheduled Hours"
    sql:${number_of_worked_minutes}/60;;
    value_format_name: decimal_1
  }


  measure: avg_employees_utr{
    label:"AVG UTR"
    type: number
    description: "Average Employees UTR"
    sql:${sum_orders} / ${sum_worked_hours} ;;
    value_format_name: decimal_2
  }


  measure: sum_employees_needed {
    type: number
    label:"Sum Actual Needed Hours"
    description: "Number of needed Employees based on actual order demand"
    sql:ceiling(${sum_orders} / (2.5 / 2));;
    value_format_name: decimal_0
  }

  measure: pct_no_show_employees{
    label:"% No_Show Hours"
    type: number
    description: "Number of No Show Employees"
    sql:(${sum_planned_hours} - ${sum_worked_hours})/${sum_planned_hours} ;;
    value_format_name: percent_1
  }

  measure: count {
    type: count
    drill_fields: [position_name]
  }
}
