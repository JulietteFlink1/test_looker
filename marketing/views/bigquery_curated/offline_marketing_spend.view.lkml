view: offline_marketing_spend {
  sql_table_name: `flink-data-prod.curated.offline_marketing_spend`
    ;;

  ############ Dimensions

  dimension: amt_spend {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_spend ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: network {
    type: string
    sql: ${TABLE}.network ;;
  }

  dimension: table_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
  }

  dimension_group: week {
    type: time
    label: "Report"
    group_label: "* Dates *"
    timeframes: [
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.week ;;
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
      ${week_week}}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${week_month}
    {% elsif date_granularity._parameter_value == 'Quarter' %}
      ${week_quarter}
    {% elsif date_granularity._parameter_value == 'Year' %}
      ${week_year}
    {% endif %};;
  }


  dimension: date_granularity_pass_through {
    group_label: "* Parameters *"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: no # yes
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

  ############ Measures

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }

  measure: total_offline_spend {
    type: sum
    sql: ${amt_spend} ;;
    value_format_name: eur_0
  }
}
