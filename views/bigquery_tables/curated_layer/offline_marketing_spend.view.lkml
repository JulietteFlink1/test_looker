view: offline_marketing_spend {
  sql_table_name: `flink-data-prod.curated.offline_marketing_spend`
    ;;

  dimension: amt_spend {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_spend ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_matched_in_master_file {
    hidden: yes
    type: string
    sql: ${TABLE}.is_matched_in_master_file ;;
  }

  dimension: network {
    type: string
    sql: ${TABLE}.network ;;
  }

  dimension: provider {
    type: string
    sql: ${TABLE}.provider ;;
  }

  dimension: unique_id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.unique_id ;;
  }

  dimension_group: week {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.week ;;
  }

  ############ Measures

  measure: count {
    type: count
    drill_fields: []
  }

  measure: total_offline_spend {
    type: sum
    sql: ${amt_spend} ;;
    value_format_name: eur_0
  }
}
