view: answers {
  sql_table_name: `flink-backend.saleor_db.answers`
    ;;

  # dimension_group: _sdc_batched {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_batched_at ;;
  # }

  # dimension_group: _sdc_extracted {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_extracted_at ;;
  # }

  # dimension_group: _sdc_received {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_received_at ;;
  # }

  # dimension: _sdc_sequence {
  #   type: number
  #   sql: ${TABLE}._sdc_sequence ;;
  # }

  # dimension: _sdc_table_version {
  #   type: number
  #   sql: ${TABLE}._sdc_table_version ;;
  # }

  dimension: answer {
    type: string
    label: "Answer"
    sql: ${TABLE}.answer ;;
  }

  dimension: data_type {
    type: string
    hidden: yes
    sql: ${TABLE}.data_type ;;
  }

  dimension: landing_id {
    type: string
    hidden: yes
    sql: ${TABLE}.landing_id ;;
  }

  dimension: question_id {
    type: string
    hidden: yes
    sql: ${TABLE}.question_id ;;
  }

  dimension: ref {
    type: string
    sql: ${TABLE}.ref ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: count {
    type: count
    drill_fields: [landings.landing_id, questions.question_id]
  }

  measure: cnt_unique_responses {
    label: "# Unique Responses"
    description: "Count of Unique Responses to Survey"
    hidden:  no
    type: count_distinct
    sql_distinct_key: id;;
    sql: ${TABLE}.landing_id;;
    value_format: "0"
  }
}
