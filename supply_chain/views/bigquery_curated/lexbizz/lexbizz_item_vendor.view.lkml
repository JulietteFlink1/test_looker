view: lexbizz_item_vendor {
  sql_table_name: `flink-data-prod.curated.lexbizz_item_vendor`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: edi {
    type: string
    sql: ${TABLE}.edi ;;
  }

  dimension_group: ingestion {
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension: min_order_qty {
    type: number
    sql: ${TABLE}.min_order_qty ;;
  }

  dimension: purchase_unit {
    type: string
    sql: ${TABLE}.purchase_unit ;;
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

  dimension: vendor_id {
    label: "Supplier ID"
    type: string
    sql: ${TABLE}.vendor_id ;;
  }

  dimension: vendor_location {
    label: "Supplier Location"
    type: string
    sql: ${TABLE}.vendor_location ;;
  }

  dimension: vendor_name {
    label: "Supplier Name"
    type: string
    sql: ${TABLE}.vendor_name ;;
  }

  measure: count {
    type: count
    drill_fields: [vendor_name]
  }
}
