view: rider_rejections {
  sql_table_name: `flink-data-prod.curated.rider_rejections`
    ;;

  dimension: applicant_uuid {
    group_label: "* IDs *"
    primary_key: yes
    type: string
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
    type: time
    group_label: "* Dates & Timestamps *"
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

  dimension_group: rejected_at {
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
    sql: ${TABLE}.rejected_at_timestamp ;;
  }

  dimension: rejection_reason {
    type: string
    sql: ${TABLE}.rejection_reason ;;
  }

  ############### Measures

  measure: count_rejected_applicants {
    group_label: "* Basic Counts *"
    label: "# Rejected Applicants"
    type: count
    drill_fields: []
  }
}
