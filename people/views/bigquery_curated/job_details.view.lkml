view: job_details {
  sql_table_name: `flink-data-prod.curated.job_details`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: contract_type {
    type: string
    sql: ${TABLE}.contract_type ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: division {
    type: string
    sql: ${TABLE}.division ;;
  }

  dimension: experience_level {
    type: string
    sql: ${TABLE}.experience_level ;;
  }

  dimension: recruiter_name {
    type: string
    sql: ${TABLE}.recruiter_name ;;
  }

  dimension: function {
    type: string
    sql: ${TABLE}.function ;;
  }

  dimension_group: job_created {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.job_created_date ;;
  }

  dimension: job_language {
    type: string
    sql: ${TABLE}.job_language ;;
  }

  dimension: job_status {
    type: string
    sql: ${TABLE}.job_status ;;
  }

  dimension: job_title {
    type: string
    sql: ${TABLE}.job_title ;;
  }

  dimension: job_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.job_uuid ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
