view: marketing_channel_mapping {
  sql_table_name: `flink-data-prod.google_sheets.marketing_channel_mapping`
    ;;

  dimension_group: _fivetran_synced {
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
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: _row {
    type: number
    sql: ${TABLE}._row ;;
  }

  dimension: channel_name_in_commercetools_ {
    type: string
    sql: ${TABLE}.channel_name_in_commercetools_ ;;
  }

  dimension: network_group_in_commercetools_ {
    type: string
    sql: ${TABLE}.network_group_in_commercetools_ ;;
  }

  dimension: name_group_key {
    type: string
    primary_key: yes
    sql:CONCAT(${channel_name_in_commercetools_},${network_group_in_commercetools_}) ;;
  }

  dimension: voucher_use_case {
    type: string
    sql: ${TABLE}.voucher_use_case ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
