view: cc_agent_staffing_half_hourly {
  sql_table_name: `flink-data-prod.reporting.cc_agent_staffing_half_hourly`
    ;;

    set: cc_contacts_fields {
      fields: [
        agent_email,
        country_iso,
        agent_name,
        cc_agent_shift_uuid,
        employment_id,
        is_external_agent,
        position_name,
        shift_date,
        shift_week,
        shift_month,
        shift_year,
        staff_number,
        sum_number_of_worked_hours,
        sum_number_of_closed_contacts,
        number_of_contact_per_hour,
        number_of_agents_working,
        date_granularity,
        date,
        date_granularity_pass_through,
        number_of_worked_minutes,

        ]
    }

  dimension: agent_email {

    required_access_grants: [can_access_pii_hq_employees]

    group_label: "> Agent Dimensions"
    type: string
    description: "Quinyx email address of the customer care agent. If the email address starts with 'ext-', we remove that prefix.
    This is done to be able to join on Intercom agents' email addresses, which sometimes do not have that prefix."
    sql: ${TABLE}.agent_email ;;
  }

  dimension: cc_agent_shift_uuid {
    sql: ${TABLE}.cc_agent_shift_uuid ;;
    primary_key: yes
    hidden: yes
  }

  dimension: agent_name {

    required_access_grants: [can_access_pii_hq_employees]

    group_label: "> Agent Dimensions"
    description: "Name of the customer care agent."
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
    description: "Displays Yes if the agent is external. Based on the Quinyx agent email (starts with ext- or ext.)"
    type: yesno
    sql: ${TABLE}.is_external_agent ;;
  }

  dimension: cc_team {
    group_label: "> Agent Dimensions"
    label: "CC Team"
    description: "Customer care team the agent is part of: german, dutch, french"
    type: string
    sql: ${TABLE}.cc_team ;;
  }

  dimension: leave_reason {
    group_label: "> Shift Dimensions"
    label: "Absence Reason"
    description: "Reason associated with the creation of an absence in Quinyx"
    type: string
    sql: ${TABLE}.leave_reason ;;
  }

  dimension: is_deleted {
    group_label: "> Shift Dimensions"
    label: "Is Deleted"
    description: "Displays Yes if the shift is deleted in Quinyx"
    type: yesno
    sql: ${TABLE}.is_deleted ;;
  }

  dimension: shift_id {
    group_label: "> Shift Dimensions"
    label: "Shift ID"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.shift_id ;;
  }

  dimension_group: block_starts {
    group_label: "> Dates"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    convert_tz: yes
    sql: ${TABLE}.block_starts_timestamp ;;
  }

  dimension_group: block_ends {
    group_label: "> Dates"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    convert_tz: yes
    sql: ${TABLE}.block_ends_timestamp ;;
  }

  dimension_group: shift_starts {
    group_label: "> Dates"
    type: time
    timeframes: [
      time
    ]
    convert_tz: yes
    sql: ${TABLE}.shift_starts_timestamp ;;
  }

  dimension_group: shift_ends {
    group_label: "> Dates"
    type: time
    timeframes: [
      time
    ]
    convert_tz: yes
    sql: ${TABLE}.shift_ends_timestamp ;;
  }

  dimension: number_of_planned_minutes {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_planned_minutes ;;
  }

  dimension: number_of_productive_minutes {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_productive_minutes ;;
  }

  dimension: number_of_closed_contacts {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_closed_contacts ;;
  }

  dimension: number_of_punched_minutes {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_punched_minutes ;;
  }

  dimension: number_of_worked_minutes {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_worked_minutes ;;
  }

  dimension: number_of_absence_minutes {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_absence_minutes ;;
  }

  dimension: number_of_unplanned_absence_minutes {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_unplanned_absence_minutes ;;
  }

  dimension: number_of_planned_absence_minutes {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_planned_absence_minutes ;;
  }

  dimension: position_name {
    group_label: "> Agent Dimensions"
    description: "Name of the agent position in quinyx. E.g. cc, early, mid, late "
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
    description: "Number of worked hours by a customer care agent.
    We consider the punched duration when available, else we consider the planned duration. Excludes shifts that are overlapped by absences."
    type: sum
    sql: ${number_of_worked_minutes}/60 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_punched_hours {
    group_label: "> Agent Productivity"
    label: "# Punched Hours"
    description: "Number of hours punched by a customer care agent, as seen in Quinyx."
    type: sum
    sql: ${number_of_punched_minutes}/60 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_planned_hours {
    alias: [sum_number_of_assigned_hours]
    group_label: "> Agent Productivity"
    label: "# Planned Hours"
    description: "Number of hours planned for a customer care agent. We consider the planned duration of the shift, including the break duration."
    type: sum
    sql: ${number_of_planned_minutes}/60 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_productive_hours {
    group_label: "> Agent Productivity"
    label: "# Productive Hours"
    description: "Number of planned hours for a customer care agent,
    excluding break duration and shift durations that are overlapped by absences."
    type: sum
    sql: ${number_of_productive_minutes}/60 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_absence_hours {
    group_label: "> Agent Productivity"
    label: "# Absence Hours"
    description: "Number of hours a customer care agent was absent. We consider the duration of absences that overlap with shifts,
    apart from absences with 'Unavailable' leave reason."
    type: sum
    sql: ${number_of_absence_minutes}/60 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_planned_absence_hours {
    group_label: "> Agent Productivity"
    label: "# Planned Absence Hours"
    description: "Number of absence hours for a customer care agent, but considering all absences except the ones with
    'Sick Day', 'Sick Leave Approved', 'No Show' and 'Unavailable' as leave reason."
    type: sum
    sql: ${number_of_planned_absence_minutes}/60 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_unplanned_absence_hours {
    group_label: "> Agent Productivity"
    label: "# Unplanned Absence Hours"
    description: "Number of absence hours for a customer care agent, but considering only absences with
    'Sick Day', 'Sick Leave Approved' and 'No Show' as leave reason."
    type: sum
    sql: ${number_of_unplanned_absence_minutes}/60 ;;
    value_format_name: decimal_1
  }

  measure: share_of_absences_per_planned_hours {
    group_label: "> Agent Productivity"
    label: "% Absence Hours"
    description: "Number of absence hours divided by the number of planned hours"
    type: number
    sql: safe_divide(${sum_number_of_absence_hours},${sum_number_of_planned_hours}) ;;
    value_format_name: percent_1
  }

  measure: share_of_unplanned_absences_per_planned_hours {
    group_label: "> Agent Productivity"
    label: "% Unplanned Absence Hours"
    description: "Number of unplanned absence hours divided by the number of planned hours"
    type: number
    sql: safe_divide(${sum_number_of_unplanned_absence_hours},${sum_number_of_planned_hours}) ;;
    value_format_name: percent_1
  }

  measure: share_of_planned_absences_per_planned_hours {
    group_label: "> Agent Productivity"
    label: "% Planned Absence Hours"
    description: "Number of planned absence hours divided by the number of planned hours"
    type: number
    sql: safe_divide(${sum_number_of_planned_absence_hours},${sum_number_of_planned_hours}) ;;
    value_format_name: percent_1
  }

  measure: sum_number_of_closed_contacts {
    group_label: "> Agent Productivity"
    label: "# Closed Contacts"
    description: "Number of contacts that were closed by the agent"
    type: sum
    sql: ${number_of_closed_contacts} ;;
    value_format_name: decimal_0
  }

  measure: number_of_contact_per_hour {
    group_label: "> Agent Productivity"
    label: "AVG # Closed Contacts / Hour"
    description: "AVG Number of contacts closed by an agent in one productive hour. Productive hours correspond to the number
    of planned hours for a customer care agent, excluding break duration and shift durations that are overlapped by absences."
    type: number
    sql: safe_divide(${sum_number_of_closed_contacts},${sum_number_of_productive_hours}) ;;
    value_format: "0.00"
  }

  measure: number_of_agents_working {
    alias: [number_of_agents]
    group_label: "> Agent Productivity"
    label: "# Working Agents"
    description: "Number of agents who worked during the timeframe."
    type: count_distinct
    filters: [number_of_worked_minutes: ">0"]
    sql: ${agent_email} ;;
  }

  measure: number_of_agents_punched {
    group_label: "> Agent Productivity"
    label: "# Punched Agents"
    description: "Number of agents who punched during the timeframe."
    type: count_distinct
    filters: [number_of_punched_minutes: ">0"]
    sql: ${agent_email} ;;
  }

  measure: number_of_agents_planned {
    group_label: "> Agent Productivity"
    label: "# Planned Agents"
    description: "Number of agents who had a shift planned during the timeframe."
    type: count_distinct
    filters: [number_of_planned_minutes: ">0"]
    sql: ${agent_email} ;;
  }

  measure: number_of_agents_productive {
    group_label: "> Agent Productivity"
    label: "# Productive Agents"
    description: "Number of agents who were productive during the timeframe. Productive hours correspond to the number
    of planned hours for a customer care agent, excluding break duration and shift durations that are overlapped by absences."
    type: count_distinct
    filters: [number_of_productive_minutes: ">0"]
    sql: ${agent_email} ;;
  }

  ######### Parameters

  parameter: date_granularity {
    group_label: "> Dates"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }


  ######## Dynamic Dimensions

  dimension: date {
    group_label: "> Dates"
    label: "Shift Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${shift_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${shift_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${shift_month}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    group_label: "> Parameters"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: no # yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }

}
