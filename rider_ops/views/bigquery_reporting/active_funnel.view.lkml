view: active_funnel {
  sql_table_name: `flink-data-prod.reporting.active_funnel`
    ;;

  dimension: applicants {
    hidden: yes
    type: number
    sql: ${TABLE}.applicants ;;
  }

  dimension: city {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: position {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: stage_title {
    hidden: yes
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.stage_title ;;
  }

  dimension: unique_id {
    primary_key: yes
    sql: concat(${country}, ${city}, ${position}, ${stage_title}) ;;
    hidden: yes
  }

  dimension_group: applied {
    hidden: yes
    type: time
    group_label: "* Dates & Timestamps *"
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

######## Dynamic Dimensions

  dimension: date {
    hidden: yes
    group_label: "* Dates & Timestamps *"
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
    group_label: "* Dates & Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }

  ############### Measures

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }

  measure: count_applicants {
    group_label: "* Basic Counts *"
    type: sum
    label: "# Applicants"
    sql: ${applicants} ;;
  }


}
