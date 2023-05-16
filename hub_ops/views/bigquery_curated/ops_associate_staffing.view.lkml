# Author: Justine Grammatikas
# Created on: 2023-05-16
# This view contains Ops associate staffing data based on the model owned by Ops team.

view: ops_associate_staffing {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `flink-data-prod.curated.ops_associate_staffing`
    ;;

  dimension_group: block_starts {
    hidden: yes
    type: time
    description: "Timestamp at which the 30min block starts."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      minute30,
      year
    ]
    sql: ${TABLE}.block_starts_timestamp ;;
  }

  ### Dimensions

  dimension: country_iso {
    hidden: yes
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: forecast_iso_week {
    hidden: yes
    type: number
    description: "Iso Week of the date for which the forecast is done."
    sql: ${TABLE}.forecast_iso_week ;;
  }

  dimension: hub_code {
    hidden: yes
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: job_date_iso_week {
    label: "Job Date Iso Week"
    type: number
    description: "Iso Week of the date at which the forecast was run."
    sql: ${TABLE}.job_date_iso_week ;;
  }

  dimension: number_of_external_and_cc_orders {
    hidden: yes
    type: number
    description: "Number of Click&Collect orders and orders that were created through an external provider (e.g. Wolt, UberEats)."
    sql: ${TABLE}.number_of_external_and_cc_orders ;;
  }

  dimension: number_of_forecasted_checks_ops_associates {
    hidden: yes
    type: number
    description: "Number of forecasted Ops Associates needed to perform inventory check related tasks. Based on Ops team model."
    sql: ${TABLE}.number_of_forecasted_checks_ops_associates ;;
  }

  dimension: number_of_forecasted_inbound_ops_associates {
    hidden: yes
    type: number
    description: "Number of forecasted Ops Associates needed to perform inbounding related tasks. Based on Ops team model."
    sql: ${TABLE}.number_of_forecasted_inbound_ops_associates ;;
  }

  dimension: number_of_forecasted_orders_adjusted {
    hidden: yes
    type: number
    description: "A total number of orders forecasted for internal Flink riders including adjustments made by the Rider Ops team using Airtable."
    sql: ${TABLE}.number_of_forecasted_orders_adjusted ;;
  }

  dimension: number_of_forecasted_picking_ops_associates {
    hidden: yes
    type: number
    description: "Number of forecasted Ops Associates needed to perform order preparation related tasks. Based on Ops team model."
    sql: ${TABLE}.number_of_forecasted_picking_ops_associates ;;
  }

  dimension: number_of_forecasted_total_ops_associates {
    hidden: yes
    type: number
    description: "Total number of Ops Associates needed. This is the number sent to Quinyx. It represent the rounded sum of check, inbound, picking OA needed and of the potential manual adjustment of OA needed."
    sql: ${TABLE}.number_of_forecasted_total_ops_associates ;;
  }

  dimension: number_of_forecasted_total_ops_associates_incl_shift_leads {
    hidden: yes
    type: number
    description: "Total number of Ops Associates and Shift Leads needed."
    sql: ${TABLE}.number_of_forecasted_total_ops_associates_incl_shift_leads ;;
  }

  dimension: number_of_manual_input_ops_associates {
    hidden: yes
    type: number
    description: "Number of manually added Ops Associates to solve capacity issues. For instance we need to add an additional OA for contract compliance."
    sql: ${TABLE}.number_of_manual_input_ops_associates ;;
  }

  dimension_group: start {
    hidden: yes
    type: time
    description: "Date for which the forecast is done."
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
    sql: ${TABLE}.start_date ;;
  }

  dimension: table_uuid {
    primary_key: yes
    hidden: yes
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
  }

############ Measures

  measure: sum_number_of_external_and_cc_orders {
    group_label: "> Forecasted Ops Associates"
    label: "# External and C&C Orders"
    description: "Number of Click&Collect orders and orders that were created through an external provider (e.g. Wolt, UberEats)."
    type: sum
    sql: ${number_of_external_and_cc_orders} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_manual_input_ops_associates {
    group_label: "> Forecasted Ops Associates"
    label: "# Forecasted Ops Associates - Manual Input"
    description: "Number of manually added Ops Associates to solve capacity issues. For instance we need to add an additional OA for contract compliance."
    type: sum
    sql: ${number_of_manual_input_ops_associates} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_total_ops_associates_incl_shift_leads {
    group_label: "> Forecasted Ops Associates"
    label: "# Forecasted Ops Associates & Shift Leads - Total"
    description: "Total number of Ops Associates and Shift Leads needed."
    type: sum
    sql: ${number_of_forecasted_total_ops_associates_incl_shift_leads} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_inbound_ops_associates {
    group_label: "> Forecasted Ops Associates"
    label: "# Forecasted Ops Associates - Inbound"
    description: "Number of forecasted Ops Associates needed to perform inbounding related tasks. Based on Ops team model."
    type: sum
    sql: ${number_of_forecasted_inbound_ops_associates} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_checks_ops_associates {
    group_label: "> Forecasted Ops Associates"
    label: "# Forecasted Ops Associates - Inventory Checks"
    description: "Number of forecasted Ops Associates needed to perform inventory checks related tasks. Based on Ops team model."
    type: sum
    sql: ${number_of_forecasted_checks_ops_associates} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_picking_ops_associates {
    group_label: "> Forecasted Ops Associates"
    label: "# Forecasted Ops Associates - Picking"
    description: "Number of forecasted Ops Associates needed to perform picking related tasks. Based on Ops team model."
    type: sum
    sql: ${number_of_forecasted_picking_ops_associates} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_total_ops_associates {
    group_label: "> Forecasted Ops Associates"
    label: "# Forecasted Ops Associates - Total"
    description: "Total number of Ops Associates needed. This is the number sent to Quinyx. It represent the rounded sum of check, inbound, picking OA needed and of the potential manual adjustment of OA needed."
    type: sum
    sql: ${number_of_forecasted_total_ops_associates} ;;
    value_format_name: decimal_1
  }

}
