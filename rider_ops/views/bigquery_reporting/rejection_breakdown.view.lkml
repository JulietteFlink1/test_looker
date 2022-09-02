view: rejection_breakdown {
  sql_table_name: `flink-data-prod.reporting.rejection_breakdown`
    ;;

  dimension: city {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: rejected_applicants {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_rejected_applicants ;;
  }

  dimension: country {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: applied {
    hidden: yes
    group_label: "* Dates & Timestamps *"
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
    sql: ${TABLE}.applied_date ;;
  }

  dimension_group: rejection {
    group_label: "* Dates & Timestamps *"
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
    sql: ${TABLE}.rejection_date ;;
  }

  dimension: position {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: rejection_reason {
    hidden: no
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.rejection_reason ;;
  }

  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${country}, ${city}, ${position}, ifnull(${rejection_reason}, ''), ${applied_date}, ${rejection_date}) ;;
  }

  ####### Dynamic Dimensions

  dimension: date {
    hidden: yes
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${applied_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${applied_month}
    {% endif %};;
  }

######## Parameters

  parameter: date_granularity {
    hidden: yes
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }

  ################### Measures

  measure: cnt_rejected_applicants {
    group_label: "* Basic Counts *"
    type: sum
    #sql_distinct_key: concat(${country}, ${city}, ${position}, ${rejection_date}) ;;
    label: "# Rejected Applicants"
    sql: ${rejected_applicants} ;;
    value_format_name: decimal_0
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
