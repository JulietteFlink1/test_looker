view: hubs {
  sql_table_name: `flink-backend.gsheet_store_metadata.hubs`
    ;;

  dimension: __sdc_row {
    type: number
    sql: ${TABLE}.__sdc_row ;;
  }

  dimension: __sdc_sheet_id {
    type: number
    sql: ${TABLE}.__sdc_sheet_id ;;
  }

  dimension: __sdc_spreadsheet_id {
    type: string
    sql: ${TABLE}.__sdc_spreadsheet_id ;;
  }

  dimension_group: _sdc_batched {
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
    sql: ${TABLE}._sdc_batched_at ;;
  }

  dimension_group: _sdc_extracted {
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
    sql: ${TABLE}._sdc_extracted_at ;;
  }

  dimension_group: _sdc_received {
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
    sql: ${TABLE}._sdc_received_at ;;
  }

  dimension: _sdc_sequence {
    type: number
    sql: ${TABLE}._sdc_sequence ;;
  }

  dimension: _sdc_table_version {
    type: number
    sql: ${TABLE}._sdc_table_version ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: cluster {
    type: string
    sql: ${TABLE}.cluster ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_code_lowercase {
    type: string
    sql: lower(${TABLE}.hub_code) ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: live {
    type: number
    sql: ${TABLE}.live ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: hub_location {
    type: location
    sql_latitude: ${latitude};;
    sql_longitude: ${longitude};;
  }


  measure: count {
    type: count
    drill_fields: [hub_name]
  }
}
