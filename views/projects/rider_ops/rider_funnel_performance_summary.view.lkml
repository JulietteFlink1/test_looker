view: rider_funnel_performance_summary {
  sql_table_name: `flink-data-prod.reporting.rider_funnel_performance_summary`
    ;;

  dimension: days_to_first_shift {
    type: number
    hidden: yes
    sql: ${TABLE}.avg_days_to_first_shift ;;
  }

  dimension: days_to_hire {
    type: number
    hidden: yes
    sql: ${TABLE}.avg_days_to_hire ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: date {
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
    sql: ${TABLE}.date ;;
  }

  dimension: unique_id {
    hidden: yes
    sql: concat(${country}, ${city}, ${channel}, ${position}, ${date_raw}) ;;
    primary_key: yes
  }

  dimension: hires {
    hidden: yes
    type: number
    sql: ${TABLE}.hires ;;
  }

  dimension: hires_with_first_shift {
    hidden: yes
    type: number
    sql: ${TABLE}.hires_with_first_shift ;;
  }

  dimension: leads {
    hidden: yes
    type: number
    sql: ${TABLE}.leads ;;
  }

  dimension: position {
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: spend {
    hidden: yes
    type: number
    sql: ${TABLE}.spend ;;
    value_format_name: eur_0
  }

  dimension: date_ {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${date_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${date_month}
    {% endif %};;
  }

  ######## Parameters

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }

  ######## Measures

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }

  measure: number_of_leads {
    type: sum
    sql: ${leads} ;;
    value_format_name: decimal_0
  }

  measure: number_of_hires {
    type: sum
    sql: ${hires} ;;
    value_format_name: decimal_0
  }

  measure: number_of_hires_with_first_shift {
    type: sum
    sql: ${hires_with_first_shift} ;;
    value_format_name: decimal_0
  }

  measure: avg_days_to_hire {
    type: average
    sql: ${days_to_hire} ;;
    value_format_name: decimal_1
  }

  measure: avg_days_to_first_shift {
    type: average
    sql: ${days_to_first_shift} ;;
    value_format_name: decimal_1
  }

  measure: total_spend {
    type: sum
    sql: ${spend} ;;
    value_format_name: eur_0
  }

}
