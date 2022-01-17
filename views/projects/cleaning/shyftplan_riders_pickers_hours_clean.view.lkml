view: shyftplan_riders_pickers_hours_clean {
  sql_table_name: `flink-data-prod.reporting.daily_hub_staffing`
    ;;

  dimension: id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.daily_staffing_uuid ;;
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

  dimension: number_of_planned_employees {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_employees ;;
  }

  dimension: number_of_worked_employees {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_employees ;;
  }

  dimension: position_name {
    type: string
    hidden: yes
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
    hidden: yes
    datatype: date
    sql: ${TABLE}.shift_date ;;
  }


  measure: sum_orders{
    type: sum
    label:"# Orders"
    hidden: yes
    description: "Number of Orders from hubs that have worked hours"
    sql:${number_of_orders};;
    filters:[position_name: "rider"]
    value_format_name: decimal_0
  }


  dimension: date {
    label: "Shift starts at"
    type: date
    datatype: date
    sql: ${TABLE}.shift_date ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  #dimension: rider_hours {
  #  type: number
  #  sql: ${TABLE}.rider_hours ;;
  #}

  #dimension: riders {
  #  type: number
  #  sql: ${TABLE}.riders ;;
  #}

  #dimension: picker_hours {
  #  type: number
  #  sql: ${TABLE}.picker_hours ;;
  #}

  #dimension: pickers {
  #  type: number
  #  sql: ${TABLE}.pickers ;;
  #}

  ######## Measures

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  measure: rider_hours {
    label: "Sum of Rider Hours"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: riders {
    label: "# Riders"
    type: sum
    sql:${number_of_worked_employees};;
    filters: [position_name: "rider"]
    group_label: "Counts"
  }

  measure: picker_hours {
    label: "Sum of Picker Hours"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "picker"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: pickers {
    label: "# Pickers"
    type: sum
    sql:${number_of_worked_employees};;
    filters: [position_name: "picker"]
    group_label: "Counts"
  }

  measure: shift_orders {
    type: sum
    sql: ${number_of_orders} ;;
    hidden: yes
  }

  measure: adjusted_orders_riders {
    type: sum
    sql:${number_of_orders};;
    filters:[position_name: "rider"]
    hidden: yes
  }

  measure: adjusted_orders_pickers {
    type: sum
    sql:${number_of_orders};;
    filters:[position_name: "picker"]
    hidden: yes
  }

  measure: rider_utr {
    label: "AVG Rider UTR"
    type: number
    description: "# Orders from opened hub / # Worked Rider Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${rider_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: picker_utr {
    label: "AVG Picker UTR"
    type: number
    description: "# Orders from opened hub / # Worked Picker Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${picker_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }


  set: detail {
    fields: [
      date,
      hub_name
    ]
  }
}
