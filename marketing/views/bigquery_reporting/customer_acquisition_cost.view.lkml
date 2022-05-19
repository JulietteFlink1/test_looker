view: customer_acquisition_cost {
  sql_table_name: `flink-data-dev.sandbox_artem.customer_acquisition_cost`
    ;;
  view_label: "* Customer Acquisition Cost Data *"

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

  dimension: installs {
    type: number
    sql: ${TABLE}.installs ;;
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
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
  }

  dimension: campaign_country {
    label: "Campaign Country"
    type: string
    sql: ${TABLE}.campaign_country ;;
  }

  dimension: campaign_id {
    label: "Campaign ID"
    type: string
    sql: ${TABLE}.campaign_id ;;
    hidden: yes
  }

  dimension: campaign_name {
    label: "Campaign Name"
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: campaign_platform {
    label: "Campaign Platform"
    type: string
    sql: ${TABLE}.campaign_platform ;;
  }

  dimension: partner_name {
    label: "Partner Name"
    type: string
    sql: ${TABLE}.partner_name ;;
  }

  dimension: sem_campaign_type {
    label: "SEM Campaign Type"
    type: string
    sql: ${TABLE}.sem_campaign_type ;;
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

  measure: total_installs {

    label: "# Installs"
    description: "Total of installs"
    group_label: "CAC Measures"

    type: sum
    sql: ${installs} ;;

    value_format_name: decimal_0
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

  measure: cpi {
    type: number
    label: "CPI"
    description: "Cost Per Install: how much does it cost marketing to get an install"
    group_label: "CAC Measures"
    sql: ${total_amt_spend} / NULLIF(${total_installs}, 0);;
    value_format_name: euro_accounting_2_precision
  }

}
