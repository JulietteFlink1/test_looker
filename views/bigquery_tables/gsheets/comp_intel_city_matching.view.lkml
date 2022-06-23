view: comp_intel_city_matching {
  sql_table_name: `flink-data-prod.google_sheets.comp_intel_city_matching`
    ;;

  dimension_group: _fivetran_synced {
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
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: _row {
    type: number
    sql: ${TABLE}._row ;;
  }

  dimension: flink_city_name {
    type: string
    sql: ${TABLE}.flink_city_name ;;
  }

  dimension: gorillas_city_name {
    type: string
    sql: ${TABLE}.gorillas_city_name ;;
  }

  measure: count {
    type: count
    drill_fields: [flink_city_name, gorillas_city_name]
  }
}
