view: hub_counts {
  sql_table_name: `flink-data-prod.google_sheets.investor_report_input_hub_counts`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }

  dimension: tracking_date {
    type: date
    convert_tz: no
    sql: ${TABLE}.date ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: gorillas_hub_count {
    type: sum
    sql: ${TABLE}.gorillas_hub_count ;;
  }
}
