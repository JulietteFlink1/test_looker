# Author: Justine Grammatikas
# Created on: 2023-05-16
# This view contains Ops associate staffing data based on the model owned by the Ops team.

view: ops_associate_staffing {
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
    group_label: "> Forecasted Orders"
    label: "# External and C&C Orders"
    description: "Number of Click&Collect orders and orders that were created through an external provider (e.g. Wolt, UberEats)."
    type: sum
    sql: ${number_of_external_and_cc_orders} ;;
    value_format_name: decimal_0
  }

  ############ Half Hourly forecats

  measure: sum_number_of_manual_input_ops_associates {
    group_label: "> Forecasted Ops Associates - Half Hourly"
    label: "# Forecasted Ops Associates - Manual Input (30min)"
    description: "Number of manually added Ops Associates to solve capacity issues. For instance we need to add an additional OA for contract compliance."
    type: sum
    sql: ${number_of_manual_input_ops_associates} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_total_hub_staff {
    group_label: "> Forecasted Ops Associates - Half Hourly"
    label: "# Forecasted Hub Staff - Total (30min)"
    description: "Total number of Hub Staff (Ops Associates, Ops Associate+ and Shift Leads) needed."
    type: sum
    sql: ${number_of_forecasted_total_ops_associates_incl_shift_leads} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_inbound_ops_associates {
    group_label: "> Forecasted Ops Associates - Half Hourly"
    label: "# Forecasted Ops Associates - Inbound (30min)"
    description: "Number of forecasted Ops Associates needed to perform inbounding related tasks. Based on Ops team model."
    type: sum
    sql: ${number_of_forecasted_inbound_ops_associates} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_checks_ops_associates {
    group_label: "> Forecasted Ops Associates - Half Hourly"
    label: "# Forecasted Ops Associates - Inventory Checks (30min)"
    description: "Number of forecasted Ops Associates needed to perform inventory checks related tasks. Based on Ops team model."
    type: sum
    sql: ${number_of_forecasted_checks_ops_associates} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_picking_ops_associates {
    group_label: "> Forecasted Ops Associates - Half Hourly"
    label: "# Forecasted Ops Associates - Picking (30min)"
    description: "Number of forecasted Ops Associates needed to perform picking related tasks. Based on Ops team model."
    type: sum
    sql: ${number_of_forecasted_picking_ops_associates} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_total_ops_associates {
    group_label: "> Forecasted Ops Associates - Half Hourly"
    label: "# Forecasted Ops Associates - Total (30min)"
    description: "Total number of Ops Associates needed. This is the number sent to Quinyx. It represent the rounded sum of check, inbound, picking OA needed and of the potential manual adjustment of OA needed."
    type: sum
    sql: ${number_of_forecasted_total_ops_associates} ;;
    value_format_name: decimal_1
  }

  ######### Hourly Metrics


  measure: sum_number_of_manual_input_ops_associates_hourly {
    group_label: "> Forecasted Ops Associates - Hourly"
    label: "# Forecasted Ops Associates - Manual Input (hourly)"
    description: "Number of manually added Ops Associates to solve capacity issues. For instance we need to add an additional OA for contract compliance. Computed as the half hourly number divided by 2."
    type: sum
    sql: ${number_of_manual_input_ops_associates}/2 ;;
    value_format_name: decimal_1
    }

    measure: sum_number_of_forecasted_total_hub_staff_hourly {
    group_label: "> Forecasted Ops Associates - Hourly"
    label: "# Forecasted Hub Staff - Total (hourly)"
    description: "Total number of Ops Associates, Ops Associates+ and Shift Leads needed. Computed as the half hourly number divided by 2."
    type: sum
    sql: ${number_of_forecasted_total_ops_associates_incl_shift_leads}/2 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_inbound_ops_associates_hourly {
    group_label: "> Forecasted Ops Associates - Hourly"
    label: "# Forecasted Ops Associates - Inbound (hourly)"
    description: "Number of forecasted Ops Associates needed to perform inbounding related tasks. Based on Ops team model. Computed as the half hourly number divided by 2."
    type: sum
    sql: ${number_of_forecasted_inbound_ops_associates}/2 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_checks_ops_associates_hourly {
    group_label: "> Forecasted Ops Associates - Hourly"
    label: "# Forecasted Ops Associates - Inventory Checks (hourly)"
    description: "Number of forecasted Ops Associates needed to perform inventory checks related tasks. Based on Ops team model. Computed as the half hourly number divided by 2."
    type: sum
    sql: ${number_of_forecasted_checks_ops_associates}/2 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_picking_ops_associates_hourly {
    group_label: "> Forecasted Ops Associates - Hourly"
    label: "# Forecasted Ops Associates - Picking (hourly)"
    description: "Number of forecasted Ops Associates needed to perform picking related tasks. Based on Ops team model. Computed as the half hourly number divided by 2."
    type: sum
    sql: ${number_of_forecasted_picking_ops_associates}/2 ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_forecasted_total_ops_associates_hourly {
    group_label: "> Forecasted Ops Associates - Hourly"
    label: "# Forecasted Ops Associates - Total (hourly)"
    description: "Total number of Ops Associates needed. This is the number sent to Quinyx. It represent the rounded sum of check, inbound, picking OA needed and of the potential manual adjustment of OA needed. Computed as the half hourly number divided by 2."
    type: sum
    sql: ${number_of_forecasted_total_ops_associates}/2 ;;
    value_format_name: decimal_1
  }

  ######## Schedule Deviations

  measure: pct_schedule_deviation_ops_associates {
    label: "% Schedule Deviation Ops Associates"
    description: "Computed as # Scheduled Ops Associates / # Forecasted Ops Associates - 1"
    type: number
    sql: safe_divide(${ops.number_of_scheduled_hours_ops_associate}*2,${ops_associate_staffing.sum_number_of_forecasted_total_ops_associates})-1 ;;
    value_format_name: percent_1
  }

  measure: pct_schedule_deviation_hub_staff {
    label: "% Schedule Deviation Hub Staff"
    description: "Computed as # Scheduled Hub Staff / # Forecasted Hub Staff - 1"
    type: number
    sql: safe_divide(${ops.number_of_scheduled_hours_hub_staff}*2,${ops_associate_staffing.sum_number_of_forecasted_total_hub_staff})-1 ;;
    value_format_name: percent_1
  }

}
