view: payment_transaction {
  sql_table_name: `flink-backend.saleor_db_global.payment_transaction`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: unique_id {
    group_label: "* IDs *"
    hidden: yes
    primary_key: yes
    type: number
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension_group: _sdc_batched {
    hidden: yes
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
    hidden: yes
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
    hidden: yes
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
    hidden: yes
    type: number
    sql: ${TABLE}._sdc_sequence ;;
  }

  dimension: _sdc_table_version {
    hidden: yes
    type: number
    sql: ${TABLE}._sdc_table_version ;;
  }

  dimension: action_required {
    hidden: yes
    type: yesno
    sql: ${TABLE}.action_required ;;
  }

  dimension: action_required_data {
    hidden: yes
    type: string
    sql: ${TABLE}.action_required_data ;;
  }

  dimension: already_processed {
    group_label: "* Payment Status / Type *"
    type: yesno
    sql: ${TABLE}.already_processed ;;
  }

  dimension: amount {
    group_label: "* Monetary Values *"
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: country_iso {
    hidden: yes
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Transaction Created"
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
    hidden: yes
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: error {
    group_label: "* Payment Status / Type *"
    type: string
    sql: ${TABLE}.error ;;
  }

  dimension: gateway_response {
    hidden: yes
    type: string
    sql: ${TABLE}.gateway_response ;;
  }

  dimension: is_success {
    group_label: "* Payment Status / Type *"
    type: yesno
    sql: ${TABLE}.is_success ;;
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }

  dimension: payment_id {
    group_label: "* IDs *"
    type: number
    sql: ${TABLE}.payment_id ;;
  }

  dimension: searchable_key {
    hidden: yes
    type: string
    sql: ${TABLE}.searchable_key ;;
  }

  dimension: token {
    label: "Transaction Token"
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.token ;;
  }

  ####### Measures

  measure: count {
    label: "# Transactions"
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    type: count
    drill_fields: [id]
  }

  measure: sum_amount {
    group_label: "* Monetary Values *"
    label: "Sum Payment Transaction Amount"
    type: sum
    sql: ${amount} ;;
  }
}
