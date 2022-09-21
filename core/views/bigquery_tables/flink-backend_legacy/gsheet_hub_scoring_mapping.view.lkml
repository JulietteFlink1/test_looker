view: gsheet_hub_scoring_mapping {
  sql_table_name: `flink-backend.gsheet_hub_scoring_mapping.mapping`
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

  dimension: index {
    type: number
    sql: ${TABLE}.index ;;
  }

  dimension: percent_external_shift_rate {
    type: number
    sql: ${TABLE}.percent_external_shift_rate ;;
  }

  dimension: percent_issue_rate {
    type: number
    sql: ${TABLE}.percent_issue_rate ;;
  }

  dimension: percent_no_show_rate {
    type: number
    sql: ${TABLE}.percent_no_show_rate ;;
  }

  dimension: percent_nps_score_last_7_days_avg {
    type: number
    sql: ${TABLE}.percent_nps_score_last_7_days_avg ;;
  }

  dimension: percent_open_shift_rate {
    type: number
    sql: ${TABLE}.percent_open_shift_rate ;;
  }

  dimension: percent_orders_delayed_greater_5min {
    type: number
    sql: ${TABLE}.percent_orders_delayed_greater_5min ;;
  }

  dimension: percent_orders_delivered_in_time {
    type: number
    sql: ${TABLE}.percent_orders_delivered_in_time ;;
  }

  dimension: score_external_shift_rate {
    type: number
    sql: ${TABLE}.score_external_shift_rate ;;
  }

  dimension: score_issue_rate {
    type: number
    sql: ${TABLE}.score_issue_rate ;;
  }

  dimension: score_no_show_rate {
    type: number
    sql: ${TABLE}.score_no_show_rate ;;
  }

  dimension: score_nps_score_last_7_days_avg {
    type: number
    sql: ${TABLE}.score_nps_score_last_7_days_avg ;;
  }

  dimension: score_open_shift_rate {
    type: number
    sql: ${TABLE}.score_open_shift_rate ;;
  }

  dimension: score_orders_delayed_greater_5min {
    type: number
    sql: ${TABLE}.score_orders_delayed_greater_5min ;;
  }

  dimension: score_orders_delivered_in_time {
    type: number
    sql: ${TABLE}.score_orders_delivered_in_time ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
