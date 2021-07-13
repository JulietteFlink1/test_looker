view: hub_counts {
  sql_table_name: `flink-backend.gsheet_gorillas_hub_count_tracker.hub_counts`
    ;;

  dimension: __sdc_row {
    type: number
    sql: ${TABLE}.__sdc_row ;;
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
    hidden: yes
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
    hidden: yes
  }

  dimension: _sdc_sequence {
    type: number
    sql: ${TABLE}._sdc_sequence ;;
    hidden: yes
  }

  dimension: _sdc_table_version {
    type: number
    sql: ${TABLE}._sdc_table_version ;;
    hidden: yes
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }

  dimension: dusseldorf {
    type: string
    sql: ${TABLE}.dusseldorf ;;
  }

  dimension: frankfurt_m {
    type: string
    sql: ${TABLE}.frankfurt_m ;;
  }

  dimension: furth {
    type: string
    sql: ${TABLE}.furth ;;
  }

  dimension: nuremberg {
    type: string
    sql: ${TABLE}.nuremberg ;;
  }

  dimension: nyc {
    type: string
    sql: ${TABLE}.nyc ;;
  }

  dimension: offenbach {
    type: string
    sql: ${TABLE}.offenbach ;;
  }

  dimension: southampton {
    type: string
    sql: ${TABLE}.southampton ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: gorillas_hub_count {
    type: sum
    sql: ${TABLE}.gorillas_hub_count ;;
  }
}
