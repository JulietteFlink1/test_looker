view: lexbizz_item_warehouse {
  sql_table_name: `flink-data-prod.curated.lexbizz_item_warehouse`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: ingestion {
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
    sql: ${TABLE}.ingestion_date ;;
  }

  dimension_group: introduction_timestamp {
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
    sql: ${TABLE}.introduction_timestamp ;;
  }

  dimension: item_at_warehouse_status {
    type: string
    sql: ${TABLE}.item_at_warehouse_status ;;
  }

  dimension: item_status {
    type: string
    sql: ${TABLE}.item_status ;;
  }

  dimension_group: last_modified_timestamp {
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
    sql: ${TABLE}.last_modified_timestamp ;;
  }

  dimension: preferred_vendor_id {
    type: string
    sql: ${TABLE}.preferred_vendor_id ;;
  }

  dimension: preferred_vendor_location {
    type: string
    sql: ${TABLE}.preferred_vendor_location ;;
  }

  dimension: safety_stock {
    type: number
    sql: ${TABLE}.safety_stock ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension_group: termination_timestamp {
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
    sql: ${TABLE}.termination_timestamp ;;
  }

  dimension: warehouse_id {
    type: string
    sql: ${TABLE}.warehouse_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
