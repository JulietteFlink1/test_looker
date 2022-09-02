view: rider_transitions {
  sql_table_name: `flink-data-prod.curated.rider_transitions`
    ;;

  dimension: applicant_email {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.applicant_email ;;
  }

  dimension: applicant_uuid {
    group_label: "* IDs *"
    type: string
    primary_key: yes
    sql: ${TABLE}.applicant_uuid ;;
  }

  dimension: channel {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: applied_at {
    group_label: "* Dates & Timestamps *"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension: position {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: stage_title {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.stage_title ;;
  }

  dimension_group: transitioned_to_stage_at {
    group_label: "* Dates & Timestamps *"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.transitioned_to_stage_at_timestamp ;;
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

  measure: count_applicants {
    group_label: "* Basic Counts *"
    label: "# Applicants"
    type: count
    drill_fields: []
  }
}
