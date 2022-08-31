view: fountain_funnel_pipeline {
  sql_table_name: `flink-data-prod.reporting.fountain_funnel_pipeline`
    ;;

  dimension: applicants {
    hidden: yes
    type: number
    sql: ${TABLE}.applicants ;;
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
    sql: ${TABLE}.start_date ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: unique_id {
    type: string
    sql: concat(${country}, ${city}, ${position}, ${start_date}, ${title}) ;;
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

  dimension: events_custom_sort {
    label: "Stages (Custom Sort)"
    case: {
      when: {
        sql: ${title} = 'Data Collection & Video' ;;
        label: "Data Collection & Video"
      }
      when: {
        sql: ${title} = 'Review Resume and Motiviation' ;;
        label: "Review Resume and Motiviation"
      }
      when: {
        sql: ${title} = 'Assesment Center' ;;
        label: "Assesment Center"
      }
      when: {
        sql: ${title} = 'Personal Information' ;;
        label: "Personal Information"
      }
      when: {
        sql: ${title} = 'Review Fields' ;;
        label: "Review Fields"
      }
      when: {
        sql: ${title} = 'Waiting for Documents' ;;
        label: "Waiting for Documents"
      }
      when: {
        sql: ${title} = 'Contract Signature' ;;
        label: "Contract Signature"
      }
      when: {
        sql: ${title} = 'Creating Accounts' ;;
        label: "Creating Accounts"
      }
      when: {
        sql: ${title} = 'Approved' ;;
        label: "Approved"
      }
      when: {
        sql: ${title} = 'First Shift' ;;
        label: "First Shift"
      }
    }
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

  ###### Measures

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
