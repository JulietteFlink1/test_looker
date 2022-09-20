### Author: Artem Avramenko
### Created: 2022-09-17

### This view represents spend and acquistions data for online marketing channels as well as
### other campaign performance-related measures.

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

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
    hidden: yes
  }

  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
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

  measure: total_impressions {

    label: "# Impressions"
    description: "Total of impressions"
    group_label: "CAC Measures"

    type: sum
    sql: ${impressions} ;;

    value_format_name: decimal_0
  }

  measure: total_clicks {

    label: "# Clicks"
    description: "Total of clicks"
    group_label: "CAC Measures"

    type: sum
    sql: ${clicks} ;;

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

  measure: cost_per_mile {
    type: number
    label: "CPM"
    description: "Cost Per 1k Impressions: how much does it cost marketing to get 1000 impressions"
    group_label: "CAC Measures"
    sql: ${total_amt_spend} / NULLIF(${total_impressions}, 0) * 1000;;
    value_format_name: euro_accounting_2_precision
  }

  measure: cost_per_click {
    type: number
    label: "CPC"
    description: "Cost Per Click: how much does it cost marketing to get a click"
    group_label: "CAC Measures"
    sql: ${total_amt_spend} / NULLIF(${total_clicks}, 0);;
    value_format_name: euro_accounting_2_precision
  }

  measure: click_through_rate {
    type: number
    label: "% CTR"
    description: "Click Through Rate: what % of impressions result in clicks"
    group_label: "CAC Measures"
    sql: NULLIF(${total_clicks}, 0) / NULLIF(${total_impressions}, 0);;
    value_format_name: percent_2
  }

  measure: conversion_rate {
    type: number
    label: "% CVR"
    description: "Conversion Rate: what % of installs result in first orders"
    group_label: "CAC Measures"
    sql: NULLIF(${total_acquisitions}, 0) / NULLIF(${total_installs}, 0);;
    value_format_name: percent_2
  }

}
