### Author: Artem Avramenko & James Davies
### Created: 2022-09-17

### This view represents spend and acquistions data for online marketing channels as well as
### other campaign performance-related measures.

view: customer_acquisition_cost {
  sql_table_name: `flink-data-dev.sandbox_reporting.customer_acquisition_cost`
    ;;
  view_label: "* Customer Acquisition Cost Data *"

  # =========  hidden   =========
  dimension: number_of_acquisitions {
    alias: [acquisitions]
    type: number
    sql: ${TABLE}.number_of_acquisitions ;;
    hidden: yes
  }

  dimension: amt_spend_net_eur {
    alias: [amt_spend]
    type: number
    sql: ${TABLE}.amt_spend_eur ;;
    hidden: yes
  }

  dimension: number_of_installs {
    alias: [installs]
    type: number
    sql: ${TABLE}.number_of_installs ;;
    hidden: yes
  }

  dimension: number_of_impressions {
    alias: [impressions]
    type: number
    sql: ${TABLE}.number_of_impressions ;;
    hidden: yes
  }

  dimension: number_of_clicks {
    alias: [clicks]
    type: number
    sql: ${TABLE}.number_of_clicks ;;
    hidden: yes
  }

  dimension: number_of_orders {
    type: number
    sql: ${TABLE}.number_of_orders ;;
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
    group_label: "* Dates and Timestamps *"
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
    sql: ${TABLE}.report_date ;;
  }

  dimension: campaign_country {
    group_label: "* Campaign Dimensions *"
    label: "Campaign Country"
    type: string
    sql: ${TABLE}.campaign_country ;;
  }

  dimension: campaign_id {
    group_label: "* Campaign Dimensions *"
    label: "Campaign ID"
    type: string
    sql: ${TABLE}.campaign_id ;;
    hidden: yes
  }

  dimension: campaign_name {
    group_label: "* Campaign Dimensions *"
    label: "Campaign Name"
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: campaign_platform {
    group_label: "* Campaign Dimensions *"
    label: "Campaign Platform"
    type: string
    sql: ${TABLE}.campaign_platform ;;
  }

  dimension: partner_name {
    group_label: "* Campaign Dimensions *"
    label: "Channel Name"
    type: string
    sql: ${TABLE}.partner_name ;;
  }

  dimension: sem_campaign_type {
    group_label: "* Campaign Dimensions *"
    label: "SEM Campaign Type"
    type: string
    sql: ${TABLE}.sem_campaign_type ;;
  }

  # =========  Parameters   =========

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
    default_value: "Week"
  }

  # =========  Dynamic dimensions   =========

  dimension: date {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${report_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${report_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${report_month}
    {% elsif date_granularity._parameter_value == 'Quarter' %}
      ${report_quarter}
    {% elsif date_granularity._parameter_value == 'Year' %}
      ${report_year}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    group_label: "* Parameters *"
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
            {% elsif date_granularity._parameter_value == 'Quarter' %}
              "Quarter"
            {% elsif date_granularity._parameter_value == 'Year' %}
              "Year"
            {% endif %};;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: total_amt_spend_eur {

    alias: [total_amt_spend]
    label: "SUM Spend"
    description: "Total of online marketing spend"
    group_label: "* CAC Measures *"

    type: sum
    sql: ${amt_spend_net_eur} ;;

    value_format_name: euro_accounting_2_precision
  }

  measure: total_amt_spend_eur_no_sem {

    label: "SUM Spend"
    description: "Total of online marketing spend"
    group_label: "* CAC Measures *"
    filters: [partner_name: "-Google Ads - SEM (Web only), -Google Ads - SEM (App only)"  ]
    type: sum
    sql: ${amt_spend_net_eur} ;;

    value_format_name: euro_accounting_2_precision
  }


  measure: total_installs {

    label: "# Installs"
    description: "Total of installs"
    group_label: "* CAC Measures *"

    type: sum
    sql: ${number_of_installs} ;;

    value_format_name: decimal_0
  }

  measure: total_installs_no_sem {

    label: "# Installs"
    description: "Total of installs"
    group_label: "* CAC Measures *"
    filters: [partner_name: "-Google Ads - SEM (Web only), -Google Ads - SEM (App only)"  ]
    type: sum
    sql: ${number_of_installs} ;;

    value_format_name: decimal_0
  }

  measure: total_acquisitions {

    label: "# Acquisitions"
    description: "Total of acquisitions"
    group_label: "* CAC Measures *"

    type: sum
    sql: ${number_of_acquisitions} ;;

    value_format_name: decimal_0
  }

  measure: total_acquisitions_no_sem{

    label: "# Acquisitions"
    description: "Total of acquisitions"
    group_label: "* CAC Measures *"
    filters: [partner_name: "-Google Ads - SEM (Web only), -Google Ads - SEM (App only)"  ]
    type: sum
    sql: ${number_of_acquisitions} ;;

    value_format_name: decimal_0
  }

  measure: total_impressions {

    label: "# Impressions"
    description: "Total of impressions"
    group_label: "* CAC Measures *"

    type: sum
    sql: ${number_of_impressions} ;;

    value_format_name: decimal_0
  }

  measure: total_clicks {

    label: "# Clicks"
    description: "Total of clicks"
    group_label: "* CAC Measures *"

    type: sum
    sql: ${number_of_clicks} ;;

    value_format_name: decimal_0
  }

  measure: total_clicks_no_sem {

    label: "# Clicks"
    description: "Total of clicks"
    group_label: "* CAC Measures *"
    filters: [partner_name: "-Google Ads - SEM (Web only), -Google Ads - SEM (App only)"  ]
    type: sum
    sql: ${number_of_clicks} ;;

    value_format_name: decimal_0
  }

  measure: total_orders {

    label: "# Orders"
    description: "Number of Orders"
    group_label: "* CAC Measures *"

    type: sum
    sql: ${number_of_orders} ;;

    value_format_name: decimal_0
  }

  measure: cac {
    type: number
    label: "CAC"
    description: "Customer Acquisition Cost: how much does it cost marketing to get a conversion"
    group_label: "* CAC Measures *"
    sql: safe_divide(${total_amt_spend_eur}, ${total_acquisitions});;
    value_format_name: euro_accounting_2_precision
  }

  measure: cpi {
    type: number
    label: "CPI"
    description: "Cost Per Install: how much does it cost marketing to get an install"
    group_label: "* CAC Measures *"
    sql: ${total_amt_spend_eur_no_sem} / NULLIF(${total_installs_no_sem}, 0);;
    value_format_name: euro_accounting_2_precision
  }

  measure: cost_per_mile {
    type: number
    label: "CPM"
    description: "Cost Per 1k Impressions: how much does it cost marketing to get 1000 impressions"
    group_label: "* CAC Measures *"
    sql: ${total_amt_spend_eur} / NULLIF(${total_impressions}, 0) * 1000;;
    value_format_name: euro_accounting_2_precision
  }

  measure: cost_per_click {
    type: number
    label: "CPC"
    description: "Cost Per Click: how much does it cost marketing to get a click"
    group_label: "* CAC Measures *"
    sql: ${total_amt_spend_eur} / NULLIF(${total_clicks}, 0);;
    value_format_name: euro_accounting_2_precision
  }

  measure: click_through_rate {
    type: number
    label: "% CTR"
    description: "Click Through Rate: what % of impressions result in clicks"
    group_label: "* CAC Measures *"
    sql: NULLIF(${total_clicks}, 0) / NULLIF(${total_impressions}, 0);;
    value_format_name: percent_2
  }

  measure: install_conversion_rate {
    type: number
    label: "% Install-to-First Order CVR"
    description: "Install Conversion Rate: what % of installs result in first orders"
    group_label: "* CAC Measures *"
    sql: NULLIF(${total_acquisitions_no_sem}, 0) / NULLIF(${total_installs_no_sem}, 0);;
    value_format_name: percent_2
  }

  measure: click_conversion_rate {
    type: number
    label: "% Click-to-Install CVR"
    description: "Click Conversion Rate: what % of clicks result in installs"
    group_label: "* CAC Measures *"
    sql: NULLIF(${total_installs_no_sem}, 0) / NULLIF(${total_clicks_no_sem}, 0);;
    value_format_name: percent_2
  }

}
