view: fountain_avg_proc_time {
  sql_table_name: `flink-data-staging.curated.fountain_avg_proc_time`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: days_to_stage {
    hidden: yes
    type: number
    sql: ${TABLE}.days_to_stage ;;
  }

  dimension: position {
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: applicants {
    hidden: yes
    type: number
    sql: ${TABLE}.applicants ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}.start_date ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: unique_id {
    type: string
    sql: concat(${country}, ${city}, ${position}, ${title}, ${start_date}) ;;
    hidden: yes
    primary_key: yes
  }

  dimension: date_ {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${start_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${start_month}
    {% endif %};;
  }

  ###### Parameters

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }

  ##### Measures

  measure: avg_days_to_stage {
    type: average
    sql: ${days_to_stage} ;;
    value_format_name: decimal_2
  }

  measure: number_of_applicants {
    type: sum
    sql: ${applicants} ;;
    value_format_name: decimal_0
  }


  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
