view: rider_applicants {
  sql_table_name: `flink-data-prod.curated.rider_applicants`
    ;;

  dimension: applicant_email {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.applicant_email ;;
  }

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
    sql: ${TABLE}.applied_at_timestamp ;;
  }

  dimension_group: last_updated_at {
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
    sql: ${TABLE}.last_updated_at_timestamp ;;
  }

  dimension: position {
    group_label: "* Applicant Dimensions *"
    type: string
    sql: ${TABLE}.position ;;
  }

  ##################### Measures

  measure: count_applicants {
    group_label: "* Basic Counts *"
    label: "# Applicants"
    type: count
    drill_fields: []
  }
}
