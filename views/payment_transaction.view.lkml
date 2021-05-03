view: payment_transaction {
  sql_table_name: `flink-backend.saleor_db_global.payment_transaction`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: no
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: unique_id {
    primary_key: yes
    type: number
    sql: concat(${country_iso}, ${id}) ;;
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

  dimension: action_required {
    type: yesno
    sql: ${TABLE}.action_required ;;
  }

  dimension: action_required_data {
    type: string
    sql: ${TABLE}.action_required_data ;;
  }

  dimension: already_processed {
    type: yesno
    sql: ${TABLE}.already_processed ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: error {
    type: string
    sql: ${TABLE}.error ;;
  }

  dimension: gateway_response {
    type: string
    sql: ${TABLE}.gateway_response ;;
  }

  dimension: is_success {
    type: yesno
    sql: ${TABLE}.is_success ;;
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }

  dimension: payment_id {
    type: number
    sql: ${TABLE}.payment_id ;;
  }

  dimension: searchable_key {
    type: string
    sql: ${TABLE}.searchable_key ;;
  }

  dimension: token {
    type: string
    sql: ${TABLE}.token ;;
  }

  ####### Measures

  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: sum_amount {
    label: "Sum of Amount"
    type: sum
    sql: ${amount} ;;
  }
}
