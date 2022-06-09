view: cc_headcount_forecast_performance {
  sql_table_name: `flink-data-prod.reporting.cc_headcount_forecast_performance`;;

  dimension: cc_headcount_forecast_performance_uuid {
    label: "Forecast UUID"
    description: "Unique identifier for a job date, 30min slot, team."
    hidden:  yes
    primary_key: yes
    type: string
    sql: ${TABLE}.cc_headcount_forecast_performance_uuid ;;
  }

  dimension_group: forecasted {
    group_label: "* Date & Timestamps *"
    description: "Date for which the forecast was run"
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.start_timestamp ;;
  }

  dimension_group: end_timestamp {
    hidden:  yes
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.end_timestamp ;;
  }

  dimension: job_date {
    label: "Job Date"
    group_label: "* Date & Timestamps *"
    description: "Date on which the forecast was ran."
    type: date
    datatype: date
    sql: ${TABLE}.job_date ;;
  }

  dimension: forecast_horizon_days {
    label: "Forecast Horizon Days"
    description: "Difference in days between forecasted date and job date"
    type: number
    sql: ${TABLE}.forecast_horizon_days ;;
  }

  dimension: team {
    label: "CC Team"
    description: "Customer Care team"
    type: string
    sql: ${TABLE}.team ;;
  }

  measure: number_of_forecasted_agents {
    label: "# Forecasted Agents"
    description: "Forecasted headcount (before interpolation)"
    type: sum
    sql: ${TABLE}.number_of_forecasted_agents ;;
  }

  measure: number_of_forecasted_employees {
    label: "# Forecasted Employees"
    description: "Number of forecasted employees (after interpolation, sent to Quinyx)"
    type: sum
    sql: ${TABLE}.number_of_forecasted_employees ;;
  }

  measure: predicted_contacts {
    label: "# Predicted Contacts"
    description: "# Predicted Contacts within a 30min slot per team.
          Does not take into account contacts where is_deflected_by_bot is true nor agent_id is null"
    type: sum
    sql: ${TABLE}.number_of_predicted_contacts ;;
  }

  measure: number_of_contacts {
    label: "# Contacts"
    description: "# Contacts within a 30min slot per team.
           Does not take into account contacts where is_deflected_by_bot is true nor agent_id is null"
    type: sum
    sql: ${TABLE}.number_of_contacts ;;
  }
}
