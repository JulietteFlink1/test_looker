view: erp_buying_prices {
  sql_table_name: `flink-data-prod.curated.erp_buying_prices`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: erp_item_name {
    type: string
    sql: ${TABLE}.erp_item_name ;;
  }

  dimension: erp_vendor_id {
    type: string
    sql: ${TABLE}.erp_vendor_id ;;
  }

  dimension: erp_vendor_name {
    type: string
    sql: ${TABLE}.erp_vendor_name ;;
  }

  dimension: erp_warehouse_id {
    type: string
    sql: ${TABLE}.erp_warehouse_id ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: ingestion_timestamp {
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
    sql: ${TABLE}.ingestion_timestamp ;;
  }

  dimension: is_price_promotional {
    type: yesno
    sql: ${TABLE}.is_price_promotional ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

  dimension_group: valid_from {
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
    sql: ${TABLE}.valid_from ;;
  }

  dimension_group: valid_to {
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
    sql: ${TABLE}.valid_to ;;
  }

  measure: count {
    type: count
    drill_fields: [erp_item_name, erp_vendor_name]
  }
}
