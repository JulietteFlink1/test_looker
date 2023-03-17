view: offline_customer_acquisition_cost {
  sql_table_name: `flink-data-prod.curated.offline_customer_acquisition_cost`
    ;;
  view_label: "* Offline Customer Acquisition Cost Data *"

  # =========  hidden   =========
  dimension: acquisitions {
    type: number
    sql: ${TABLE}.number_of_acquisitions ;;
    hidden: yes
  }

  dimension: amt_spend {
    type: number
    sql: ${TABLE}.amt_spend_net ;;
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
    group_label: "* Dates *"
    timeframes: [
      raw,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_week ;;
  }

  dimension: country_iso {
    label: "Spend Country"
    group_label: "* Dimensions *"
    description: "Country of marketing activity"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: channel {
    label: "Marketing Channel"
    group_label: "* Dimensions *"
    description: "Category of marketing channel"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: network {
    label: "Marketing Network"
    group_label: "* Dimensions *"
    description: "Sub category of marketing channel"
    type: string
    sql: ${TABLE}.network ;;
  }

  # =========  Parameters   =========

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
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
    {% if date_granularity._parameter_value == 'Week' %}
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
    hidden: no
    sql:
            {% if date_granularity._parameter_value == 'Week' %}
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

  measure: total_amt_spend {

    label: "SUM Offline Spend"
    description: "Total of online marketing spend"
    group_label: "* CAC Measures *"

    type: sum
    sql: ${amt_spend} ;;

    value_format_name: euro_accounting_2_precision
  }

  measure: total_acquisitions {

    label: "# Offline Acquisitions"
    description: "Total of acquisitions, offline sources only"
    group_label: "* CAC Measures *"

    type: sum
    sql: ${acquisitions} ;;

    value_format_name: decimal_0
  }

  measure: cac {
    type: number
    label: "Offline CAC"
    description: "Customer Acquisition Cost: how much does it cost marketing to get a conversion, offline sources only"
    group_label: "* CAC Measures *"
    sql: ${total_amt_spend} / NULLIF(${total_acquisitions}, 0);;
    value_format_name: euro_accounting_2_precision
  }
}
