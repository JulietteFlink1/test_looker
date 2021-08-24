view: voucher_retention {
  sql_table_name: `flink-data-prod.reporting.voucher_retention`
    ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: voucher_retention_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.voucher_retention_uuid ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: discount_code {
    type: string
    sql: ${TABLE}.discount_code ;;
  }

  dimension: base_7 {
    type: number
    sql: ${TABLE}.base_7 ;;
  }

  dimension: base_14 {
    type: number
    sql: ${TABLE}.base_14 ;;
  }

  dimension: base_30 {
    type: number
    sql: ${TABLE}.base_30 ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: _7_day_retention {
    type: number
    sql: ${TABLE}._7_day_retention ;;
  }

  dimension: _14_day_retention {
    type: number
    sql: ${TABLE}._14_day_retention ;;
  }

  dimension: _30_day_retention {
    type: number
    sql: ${TABLE}._30_day_retention ;;
  }

  dimension: country_name {
    type: string
    sql: CASE WHEN ${country_iso} = "DE" then "Germany"
          WHEN ${country_iso} = "NL" then "Netherlands"
          ELSE 'France' end ;;
  }

  ######## Measures

  measure: cnt_base_7 {
    type: sum
    sql: ${base_7} ;;
  }

  measure: cnt_base_14 {
    type: sum
    sql: ${base_14} ;;
  }

  measure: cnt_base_30 {
    type: sum
    sql: ${base_30} ;;
  }

  measure: cnt_7_day_retention {
    type: sum
    sql: ${_7_day_retention} ;;
  }

  measure: cnt_14_day_retention {
    type: sum
    sql: ${_14_day_retention} ;;
  }

  measure: cnt_30_day_retention {
    type: sum
    sql: ${_30_day_retention} ;;
  }

  set: detail {
    fields: [
      country_iso,
      city,
      discount_code,
      base_7,
      base_14,
      base_30,
      hub_name,
      _7_day_retention,
      _14_day_retention,
      _30_day_retention
    ]
  }
}
