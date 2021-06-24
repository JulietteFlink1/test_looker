view: daily_historical_stock_levels {
  sql_table_name: `flink-data-dev.sandbox_andreas.daily_historical_stock_levels`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameter     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter: date_granularity {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Select Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: date {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${tracking_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${tracking_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${tracking_month}
    {% endif %};;
  }
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: tracking {
    type: time
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
    sql: ${TABLE}.tracking_date ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures       ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_stock_count {
    label: "ø Stock"
    type: average
    sql: ${TABLE}.avg_stock_count ;;
    value_format_name: decimal_1
  }

  measure: avg_stock_count_per_substitute_group {
    label: "ø Stock Substitue Group"
    type: average
    sql: ${TABLE}.avg_stock_count_per_substitute_group ;;
    value_format_name: decimal_1
  }


  measure: hours_oos {
    label: "Hours Out-Of-Stock"
    type: sum
    sql: ${TABLE}.hours_oos ;;
    value_format_name: decimal_0
  }

  measure: open_hours_total {
    label: "Opening Hours"
    type: sum
    sql: ${TABLE}.open_hours_total ;;
    value_format_name: decimal_0
  }

  measure: sum_count_purchased {
    label: "# Items Sold"
    type: sum
    sql: ${TABLE}.sum_count_purchased ;;
    value_format_name: decimal_0
  }

  measure: sum_count_restocked {
    label: "# Items Re-Stocked"
    type: sum
    sql: ${TABLE}.sum_count_restocked ;;
    value_format_name: decimal_0
  }
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Calculations     ~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: pct_oos {
    label: "% Out Of Stock"
    type: number
    sql: ${hours_oos} / nullif( ${open_hours_total},0) ;;
    value_format_name: percent_0
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Hidden     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
