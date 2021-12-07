view: transition_history {
  sql_table_name: `flink-data-prod.reporting.transitions_history`
    ;;

  dimension: city {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: applicants {
    hidden: yes
    type: number
    sql: ${TABLE}.cnt_applicants ;;
  }

  dimension: country_iso {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: position {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: stage_title {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.stage_title ;;
  }

  dimension_group: applied {
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

  dimension_group: transition {
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
    sql: ${TABLE}.transition_date ;;
  }

  dimension: events_custom_sort {
    label: "Stages (Custom Sort)"
    case: {
      when: {
        sql: ${stage_title} = 'Data Collection & Video' ;;
        label: "Data Collection & Video"
      }
      when: {
        sql: ${stage_title} = 'Review Resume and Motiviation' ;;
        label: "Review Resume and Motiviation"
      }
      when: {
        sql: ${stage_title} = 'Assesment Center' ;;
        label: "Assesment Center"
      }
      when: {
        sql: ${stage_title} = 'Personal Information' ;;
        label: "Personal Information"
      }
      when: {
        sql: ${stage_title} = 'Review Fields' ;;
        label: "Review Fields"
      }
      when: {
        sql: ${stage_title} = 'Waiting for Documents' ;;
        label: "Waiting for Documents"
      }
      when: {
        sql: ${stage_title} = 'Contract Signature' ;;
        label: "Contract Signature"
      }
      when: {
        sql: ${stage_title} = 'Creating Accounts' ;;
        label: "Creating Accounts"
      }
      when: {
        sql: ${stage_title} = 'Approved' ;;
        label: "Approved"
      }
      when: {
        sql: ${stage_title} = 'First Shift' ;;
        label: "First Shift"
      }
    }
  }

######## Dynamic Dimensions

  dimension: created_date {
    group_label: "* Dates and Timestamps *"
    label: "Start Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${applied_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${applied_month}
    {% endif %};;
  }

  dimension: transition_date_ {
    group_label: "* Dates and Timestamps *"
    label: "Transition Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${transition_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${transition_month}
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

  #################### Measures

  measure: cnt_transitioned_applicants {
    type: sum
    label: "# Applicants"
    sql: ${applicants} ;;
    value_format_name: decimal_0
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
