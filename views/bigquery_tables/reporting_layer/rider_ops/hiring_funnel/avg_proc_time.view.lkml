view: avg_proc_time {
  sql_table_name: `flink-data-prod.reporting.avg_proc_time`
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

  dimension: country {
    group_label: "* Funnel Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: days_to_stage {
    hidden: yes
    type: number
    sql: ${TABLE}.days_to_stage ;;
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

  dimension: unique_id {
    primary_key: yes
    sql: concat(${country}, ${city}, ${position}, ${stage_title}, ${applied_date}) ;;
    hidden: yes
  }

  dimension_group: applied {
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

  ############## Dynamic Dimensions

  dimension: date {
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
    group_label: "* Dates & Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }

  ######################## Measure

  measure: cnt_applicants {
    group_label: "* Basic Counts *"
    type: sum
    label: "# Applicants"
    sql: ${applicants} ;;
  }

  measure: avg_days_to_stage {
    group_label: "* Averages *"
    type: average
    label: "AVG time to stage (Days)"
    sql: ${days_to_stage} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
