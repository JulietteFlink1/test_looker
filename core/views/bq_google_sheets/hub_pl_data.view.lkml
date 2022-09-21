view: hub_pl_data {
  sql_table_name: `flink-data-prod.google_sheets.hub_pl_data`
    ;;

  dimension_group: _fivetran_synced {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: _row {
    type: number
    hidden: yes
    sql: ${TABLE}._row ;;
  }

  dimension: amt_eur {
    type: number
    hidden: yes
    sql: safe_cast(${TABLE}.amt_eur as float64) ;;
  }

  dimension: expense_type {
    type: string
    sql: ${TABLE}.expense_type ;;
  }

  dimension: hub_code {
    type: string
    sql: lower(${TABLE}.hub_code) ;;
  }

  dimension: unique_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: concat(${month}, ${expense_type}, ${hub_code}) ;;
  }


  dimension: month {
    type: date
    datatype: date
    sql: PARSE_DATE("%Y-%m", ${TABLE}.month) ;;
  }

  dimension: month_string {
    type: date
    hidden:yes
    datatype: date
    sql: ${TABLE}.month ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_logistics_costs  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "logistics_costs"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_other_logistics_costs  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "other_logistics_costs"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_internal_rider_salaries  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "internal_rider_salaries"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_external_rider_salaries  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "external_rider_salalries"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_internal_operations_salaries  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "internal_operations_salaries"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_external_operations_salaries  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "external_operations_salaries"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_shiftlead_salaries  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "shiftlead_salaries"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_citymanager_salaries  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "citymanager_salaries"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_supplier_funding  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "Supplier funding"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_hubmanager_salaries  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "hubmanager_salaries"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_ebikes  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "E-bikes"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_other_hub_recurring  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "other_hub_recurring"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_rent  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "rent"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_rider_equipment  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "rider_equipment"]
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_packaging  {
    type: sum
    sql: ${amt_eur};;
    filters: [expense_type: "Packaging"]
    value_format_name: euro_accounting_2_precision
  }

}
