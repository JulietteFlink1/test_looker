view: cc_agent_staffing_daily {
  sql_table_name: `flink-data-dev.dbt_jgrammatikas.cc_agent_staffing_daily`
    ;;

  dimension: agent_email {
    group_label: "> Agent Dimensions"
    type: string
    sql: ${TABLE}.agent_email ;;
  }

  dimension: cc_agent_shift_uuid {
    sql: ${TABLE}.cc_agent_shift_uuid ;;
    primary_key: yes
    hidden: yes
  }

  dimension: agent_name {
    group_label: "> Agent Dimensions"
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension: country_iso {
    group_label: "> Geography"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: employment_id {
    group_label: "> Agent Dimensions"
    description: "Quinyx employment ID"
    type: number
    sql: ${TABLE}.employment_id ;;
  }

  dimension: is_external_agent {
    group_label: "> Agent Dimensions"
    description: "Flags if the agent is external based on the email (starts with ext-)"
    type: yesno
    sql: ${TABLE}.is_external_agent ;;
  }

  dimension: number_of_assigned_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_assigned_hours ;;
  }

  dimension: number_of_closed_contacts {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_closed_contacts ;;
  }

  dimension: number_of_punched_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_punched_hours ;;
  }

  dimension: number_of_worked_hours {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_worked_hours ;;
  }

  dimension: position_name {
    group_label: "> Agent Dimensions"
    description: "Name of the agent position in quinyx. E.g. "
    type: string
    sql: ${TABLE}.position_name ;;
  }

  dimension_group: shift {
    group_label: "> Dates"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shift_date ;;
  }

  dimension: staff_number {
    group_label: "> Agent Dimensions"
    description: "Badge No of the agent in Quinyx"
    type: number
    sql: ${TABLE}.staff_number ;;
  }

  measure: count {
    type: count
    drill_fields: [agent_name, position_name]
  }

  ########## Measures

  measure: sum_number_of_worked_hours {
    group_label: "> Agent Productivity"
    label: "# Worked Hours"
    description: "Worked Hours as seen in Quinyx. For external agents we consider the planned hours, for internal agents the punched hours"
    type: sum
    hidden: no
    sql: ${number_of_worked_hours} ;;
  }

  measure: sum_number_of_closed_contacts {
    group_label: "> Agent Productivity"
    label: "# Closed Contacts"
    description: "Number of contacts that were closed by the agent"
    type: sum
    hidden: no
    sql: ${number_of_closed_contacts} ;;
  }

  measure: number_of_contact_per_hour {
    group_label: "> Agent Productivity"
    label: "AVG # Contacts/Hour"
    type: number
    hidden: no
    sql: safe_divide(${sum_number_of_closed_contacts},${sum_number_of_worked_hours}) ;;
    value_format: "0.00"
  }

}
