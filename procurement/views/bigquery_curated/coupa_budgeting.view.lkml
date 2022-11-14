view: coupa_budgeting {
  sql_table_name: `flink-data-dev.dbt_vbreda_curated.coupa_budgeting`
    ;;

  dimension: coupa_budget_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.coupa_budget_uuid ;;
  }

  dimension: amount_budget {
    type: number
    hidden: yes
    sql: ${TABLE}.amount_budget ;;
  }

  dimension: amount_remaining_budget {
    type: number
    hidden: yes
    sql: ${TABLE}.amount_remaining_budget ;;
  }

  dimension_group: period_end {
    group_label: "Dates & Timestamp"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.period_end_timestamp ;;
  }

  dimension_group: period_start {
    group_label: "Dates & Timestamp"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.period_start_timestamp ;;
  }

  dimension: budget_description {
    type: string
    description: "Description of the budget purpose."
    sql: ${TABLE}.budget_description ;;
  }

  dimension: period_name {
    type: string
    description: "Name of the budgeted period. Contains information about the country and month. Eg. DE Budget 10/22."
    sql: ${TABLE}.period_name ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  measure: sum_amount_budget {
    group_label: "Budget"
    label: "Amount Budget"
    description: "Amount of budget allocated, in euros."
    type: sum
    sql: ${amount_budget} ;;
    value_format_name: eur
  }

  measure: sum_amount_remaining_budget {
    group_label: "Budget"
    label: "Amount Remaining Budget"
    description: "Remaining amount of budget allocated, in euros."
    type: sum
    sql: ${amount_remaining_budget} ;;
    value_format_name: eur
  }

  measure: share_of_budget_remaining {
    group_label: "Budget"
    label: "% Amount Remaining Budget"
    description: "Remaining amount of budget allocated, divided by the initially allocated budget."
    type: number
    sql: safe_divide(${sum_amount_remaining_budget},${sum_amount_budget}) ;;
    value_format_name: percent_1
  }

}
