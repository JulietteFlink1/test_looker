view: warehouse_warehouse {
  sql_table_name: `flink-backend.saleor_db.warehouse_warehouse`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
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

  dimension: address_id {
    type: number
    sql: ${TABLE}.address_id ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: slug {
    type: string
    sql: CASE WHEN ${TABLE}.slug = 'hamburg-oellkersallee' THEN 'de_ham_alto'
              WHEN ${TABLE}.slug = 'münchen-leopoldstraße' THEN 'de_muc_schw'
              ELSE ${TABLE}.slug END
              ;;
  }

  measure: count {
    type: count
    drill_fields: [id, company_name, name]
  }
}
