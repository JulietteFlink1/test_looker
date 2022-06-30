view: offline_customer_acquisition_cost {
  sql_table_name: `flink-data-dev.sandbox_artem.offline_customer_acquisition_cost`
    ;;
  view_label: "* Offline Customer Acquisition Cost Data *"

  # =========  hidden   =========
  dimension: acquisitions {
    type: number
    sql: ${TABLE}.acquisitions ;;
    hidden: yes
  }

  dimension: amt_spend {
    type: number
    sql: ${TABLE}.amt_spend ;;
    hidden: yes
  }

  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension_group: report {
    type: time
    label: "Report"
    timeframes: [
      raw,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_week ;;
  }

  dimension: country_iso {
    label: "Spend Country"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: channel {
    label: "Marketing Channel"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: network {
    label: "Marketing Network"
    type: string
    sql: ${TABLE}.network ;;
  }

  dimension: use_case {
    label: "Use Case"
    type: string
    sql: ${TABLE}.use_case ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: total_amt_spend {

    label: "SUM Spend"
    description: "Total of online marketing spend"
    group_label: "CAC Measures"

    type: sum
    sql: ${amt_spend} ;;

    value_format_name: euro_accounting_2_precision
  }

  measure: total_acquisitions {

    label: "# Acquisitions"
    description: "Total of acquisitions"
    group_label: "CAC Measures"

    type: sum
    sql: ${acquisitions} ;;

    value_format_name: decimal_0
  }

  measure: cac {
    type: number
    label: "CAC"
    description: "Customer Acquisition Cost: how much does it cost marketing to get a conversion"
    group_label: "CAC Measures"
    sql: ${total_amt_spend} / NULLIF(${total_acquisitions}, 0);;
    value_format_name: euro_accounting_2_precision
  }
}
