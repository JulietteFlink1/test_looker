view: coupa_budgeting {
  sql_table_name: `flink-data-prod.curated_finance.coupa_budgeting`
    ;;

# This view provides information about the budget of hubs.
# Author: Victor Breda
# Created: 2022-11-22

  dimension: coupa_budget_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.coupa_budget_uuid ;;
  }

  dimension: hub_code {
    type: string
    hidden: yes
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: amt_budget_gross_eur {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_budget_gross_eur ;;
  }

  dimension: amt_remaining_budget_gross_eur {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_remaining_budget_gross_eur ;;
  }

  dimension_group: period_end {
    description: "Timestamps at which the budgeting period ends."
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
    description: "Timestamps at which the budgeting period starts."
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
    label: "Budget Decription"
    type: string
    description: "Description of the budget purpose."
    sql: ${TABLE}.budget_description ;;
  }

  dimension: period_name {
    label: "Period Name"
    type: string
    description: "Name of the budgeted period. Contains information about the country and month. Eg. DE Budget 10/22."
    sql: ${TABLE}.period_name ;;
  }

  dimension: cost_center_id {
    label: "Cost Center ID"
    type: string
    description: "ID of the cost center linked to the budget."
    sql: ${TABLE}.cost_center_id ;;
  }

  dimension: gl_account_id {
    label: "GL Account ID"
    type: string
    description: "ID of the General Ledger account linked to the budget."
    sql: ${TABLE}.gl_account_id ;;
  }

  measure: sum_amt_budget_gross_eur {
    group_label: "Budget"
    label: "€ Amount Budget Gross"
    description: "Amount of budget allocated, incl. VAT in euros."
    type: sum
    sql: ${amt_budget_gross_eur} ;;
    value_format_name: eur
  }

  measure: sum_amt_remaining_budget_gross_eur {
    group_label: "Budget"
    label: "€  Amount Remaining Budget Gross"
    description: "Remaining amount of budget allocated, incl. VAT in euros."
    type: sum
    sql: ${amt_remaining_budget_gross_eur} ;;
    value_format_name: eur
  }

  measure: share_of_budget_remaining {
    group_label: "Budget"
    label: "% Amount Remaining Budget"
    description: "Remaining amount of budget allocated, divided by the initially allocated budget."
    type: number
    sql: safe_divide(${sum_amt_remaining_budget_gross_eur},${sum_amt_budget_gross_eur}) ;;
    value_format_name: percent_1
  }

}
