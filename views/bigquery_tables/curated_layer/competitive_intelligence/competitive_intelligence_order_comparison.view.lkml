view: competitive_intelligence_order_comparison {
  sql_table_name: `flink-data-dev.reporting.competitive_intelligence_order_comparison`
    ;;

  dimension: active_hubs_uuid {
    type: string
    sql: ${TABLE}.active_hubs_uuid ;;
  }

  dimension: city_name {
    type: string
    sql: ${TABLE}.city_name ;;
  }

  dimension: competitive_intelligence_order_comparison_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.competitive_intelligence_order_comparison_uuid ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: first_seen {
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
    sql: ${TABLE}.first_seen ;;
  }

  dimension: h3_index {
    type: string
    sql: ${TABLE}.h3_index ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension_group: last_seen {
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
    sql: ${TABLE}.last_seen ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: number_of_orders {
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension_group: order {
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
    sql: ${TABLE}.order_date ;;
  }

  dimension: provider {
    type: string
    sql: ${TABLE}.provider ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: region_iso {
    type: string
    sql: ${TABLE}.region_iso ;;
  }

  measure: count {
    type: count
    drill_fields: [hub_name, city_name]
  }
}
