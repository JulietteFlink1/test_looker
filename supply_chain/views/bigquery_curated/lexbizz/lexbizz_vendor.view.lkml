view: lexbizz_vendor {
  sql_table_name: `flink-data-prod.curated.lexbizz_vendor`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: country_vendor {
    type: string
    sql: ${TABLE}.country_vendor ;;
  }

  dimension_group: created_at_timestamp {
    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: gln {
    type: string
    sql: ${TABLE}.gln ;;
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

  dimension_group: last_modified_timestamp {
    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.last_modified_timestamp ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: street {
    type: string
    sql: ${TABLE}.street ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: tax_calculation_mode {
    type: string
    sql: ${TABLE}.tax_calculation_mode ;;
  }

  dimension: tax_zone {
    type: string
    sql: ${TABLE}.tax_zone ;;
  }

  dimension: terms {
    type: string
    sql: ${TABLE}.terms ;;
  }

  dimension: vendor_class {
    type: string
    sql: ${TABLE}.vendor_class ;;
  }

  dimension: vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
  }

  dimension: vendor_name {
    type: string
    sql: ${TABLE}.vendor_name ;;
  }

  dimension: vendor_status {
    type: string
    sql: ${TABLE}.vendor_status ;;
  }

  measure: count {
    type: count
    drill_fields: [vendor_name]
  }
}
