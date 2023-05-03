### Author: Artem Avramenko & James Davies
### Created: 2022-09-17

### This view represents spend and acquistions data for online marketing channels as well as
### other campaign performance-related measures.

view: customer_acquisition_cost {
  sql_table_name: `flink-data-prod.reporting.customer_acquisition_cost`
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
    description: "Two letter abbreviation for country that the campaign where the campaign is run."
    type: string
    sql: ${TABLE}.campaign_country ;;
  }

  dimension: campaign_id {
    group_label: "* Campaign Dimensions *"
    label: "Campaign ID"
    description: "ID associated with specific campaign, one more level of granularity from partner name."
    type: string
    sql: ${TABLE}.campaign_id ;;
    hidden: yes
  }

  dimension: campaign_name {
    group_label: "* Campaign Dimensions *"
    label: "Campaign Name"
    description: "Name associated with the campaign, one more level of granularity from partner name."
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: campaign_platform {
    group_label: "* Campaign Dimensions *"
    label: "Campaign Platform"
    description: "Platform that the adverts are run on."
    type: string
    sql: ${TABLE}.campaign_platform ;;
  }

###Unsolved bug here when adding extra partners to the CAC dashboard. Workaround would be to write in the names manually
###as part of a tag list.
  dimension: partner_name {
    group_label: "* Campaign Dimensions *"
    label: "Channel Name"
    description: "Name of the advertising partner."
    type: string
    sql: ${TABLE}.partner_name ;;
  }

  dimension: sem_campaign_type {
    group_label: "* Campaign Dimensions *"
    label: "SEM Campaign Type"
    description: "Search engine marketing campaign type, null for non sem campaigns."
    type: string
    sql: ${TABLE}.sem_campaign_type ;;
  }

  # =========  Parameters   =========

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    hidden: no
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
    hidden: yes
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

  measure: total_amt_spend_eur_app {

    label: "SUM Spend, App only"
    description: "Total of online marketing spend, app campaigns only"
    group_label: "* CAC Measures *"
    filters: [partner_name: "-Google Ads - SEM"  ]
    type: sum
    sql: ${amt_spend_net_eur} ;;
    hidden: yes

    value_format_name: euro_accounting_2_precision
  }

  measure: total_amt_spend_eur_sem_web {

    label: "SUM Spend, Web Only"
    description: "Total of online marketing spend, web campaigns only"
    group_label: "* CAC Measures *"
    filters: [partner_name: "Google Ads - SEM"  ]
    type: sum
    sql: ${amt_spend_net_eur} ;;
    hidden: yes

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

  measure: total_installs_app {

    label: "# Installs, App only"
    description: "Total of installs, app campaigns only"
    group_label: "* CAC Measures *"
    filters: [partner_name: "-Google Ads - SEM"  ]
    type: sum
    sql: ${number_of_installs} ;;
    hidden: yes

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

  measure: total_acquisitions_app{

    label: "# Acquisitions, App only"
    description: "Total of acquisitions, app campaigns only"
    group_label: "* CAC Measures *"
    filters: [partner_name: "-Google Ads - SEM"  ]
    type: sum
    sql: ${number_of_acquisitions} ;;
    hidden: yes

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

  measure: total_clicks_app {

    label: "# Clicks, App only"
    description: "Total of clicks, app campaigns only"
    group_label: "* CAC Measures *"
    filters: [partner_name: "-Google Ads - SEM"  ]
    type: sum
    sql: ${number_of_clicks} ;;
    hidden: yes

    value_format_name: decimal_0
  }

  measure: total_orders {

    label: "# Orders, Web Only"
    description: "Number of Orders, web campaigns only"
    group_label: "* CAC Measures *"
    filters: [partner_name: "Google Ads - SEM" ]

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

###Cost per install includes costs of both app and web campaigns, even though the majority of the web campaign output is measured
### in web orders

  measure: cpi {
    type: number
    label: "CPI"
    description: "Cost Per Install: how much do marketing spend on app or web campaigns to get an install? "
    group_label: "* CAC Measures *"
    sql: ${total_amt_spend_eur} / NULLIF(${total_installs}, 0);;
    value_format_name: euro_accounting_2_precision
  }

  measure: cpo {
    type: number
    label: "CPO"
    description: "Cost Per Order: how much do marketing spend on web campaigns to get a web order?"
    group_label: "* CAC Measures *"
    sql: ${total_amt_spend_eur_sem_web} / NULLIF(${total_orders}, 0);;
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
    description: "Cost Per Click: how much does it cost marketing to get a click."
    group_label: "* CAC Measures *"
    sql: ${total_amt_spend_eur} / NULLIF(${total_clicks}, 0);;
    value_format_name: euro_accounting_2_precision
  }

  measure: click_through_rate {
    type: number
    label: "% CTR"
    description: "Click Through Rate: what % of impressions result in clicks."
    group_label: "* CAC Measures *"
    sql: NULLIF(${total_clicks}, 0) / NULLIF(${total_impressions}, 0);;
    value_format_name: percent_2
  }

###Install conversion rate needs to be for App campaigns only (no SEM) as the over 100% rate for SEM would distort the conversion rate

  measure: install_conversion_rate {
    type: number
    label: "% Install-to-First Order CVR"
    description: "Install Conversion Rate: what % of installs result in first orders for app campaigns only."
    group_label: "* CAC Measures *"
    sql: NULLIF(${total_acquisitions_app}, 0) / NULLIF(${total_installs_app}, 0);;
    value_format_name: percent_2
  }

###SEM is still included here, although the conversion rate will be very low (most clicks for SEM result in web orders not measured here)

  measure: click_conversion_rate {
    type: number
    label: "% Click-to-Install CVR"
    description: "Click Conversion Rate: what % of clicks result in installs for app and web campaigns."
    group_label: "* CAC Measures *"
    sql: NULLIF(${total_installs}, 0) / NULLIF(${total_clicks}, 0);;
    value_format_name: percent_2
  }

}
