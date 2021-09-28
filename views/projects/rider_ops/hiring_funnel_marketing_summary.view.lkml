view: hiring_funnel_marketing_summary {
  sql_table_name: `flink-data-prod.reporting.hiring_funnel_marketing_summary`
    ;;

  dimension: applicants {
    type: number
    sql: ${TABLE}.applicants ;;
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

  dimension: days_to_hire {
    type: number
    sql: ${TABLE}.days_to_hire ;;
  }

  dimension: days_to_hire_tier {
    type: tier
    tiers: [0, 5, 10, 15, 20, 25 ]
    sql: ${days_to_hire} ;;
  }

  dimension: position {
    type: string
    sql: ${TABLE}.position ;;
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
    sql: ${TABLE}.date ;;
  }

  dimension: unique_id {
    type: string
    sql: concat(${country}, ${city}, ${position}, ${channel}, ${start_date}) ;;
    primary_key: yes
    hidden: yes
  }

  #dimension: spend {
  #  type: number
  #  sql: ${TABLE}.spend ;;
  #  hidden: yes
  #}

  #dimension: leads {
  #  type: number
  #  sql: ${TABLE}.leads ;;
  #  hidden: yes
  #}

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

  ################# Measures

  measure: number_of_applicants {
    hidden: no
    type: sum
    sql: ${applicants} ;;
    value_format_name: decimal_0
  }

  measure: number_of_approved_applicants {
    type: sum
    sql: ${applicants} ;;
    filters: [days_to_hire: "not NULL"]
    value_format_name: decimal_0
  }

  measure: total_spend {
    type: sum_distinct
    sql_distinct_key: ${unique_id} ;;
    sql: ${rider_funnel_performance_summary.spend};;
  }

  measure: number_of_leads {
    type: sum_distinct
    sql_distinct_key: ${unique_id} ;;
    sql: ${rider_funnel_performance_summary.leads} ;;
  }

  measure: CVR {
    type: number
    sql: ${number_of_approved_applicants} / NULLIF(${number_of_leads}, 0) ;;
    description: "Pct. of Leads that Converted into Approved Applicants"
    value_format_name: percent_0
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
