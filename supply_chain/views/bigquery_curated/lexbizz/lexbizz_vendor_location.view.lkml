view: lexbizz_vendor_location {
  sql_table_name: `flink-data-prod.curated.lexbizz_vendor_location`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_hub {
    type: string
    sql: ${TABLE}.country_hub ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
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

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
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

  dimension: vendor_status {
    label: "Supplier Status"
    type: string
    sql: ${TABLE}.vendor_status ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
