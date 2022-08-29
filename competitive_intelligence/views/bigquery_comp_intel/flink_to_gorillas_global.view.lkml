view: flink_to_gorillas_global {
  sql_table_name: `flink-data-prod.curated.flink_to_gorillas_global`
    ;;

  dimension: match_type {
    type:  string
    sql: ${TABLE}.match_type ;;
  }

  dimension: match_score {
    type: number
    sql: ${TABLE}.match_score ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    group_label: "> IDs"
  }

  dimension: flink_product_name {
    type: string
    sql: ${TABLE}.flink_product_name ;;
  }

  dimension: flink_product_sku {
    type: string
    sql: ${TABLE}.flink_product_sku ;;
    hidden: no
    primary_key: yes
  }

  dimension: gorillas_product_id {
    type: string
    sql: ${TABLE}.gorillas_product_id ;;
    hidden: no
  }

  dimension: gorillas_product_name {
    type: string
    sql: ${TABLE}.gorillas_product_name ;;
  }

  dimension: conversion_factor {
    type: number
    sql: ${TABLE}.conversion_factor ;;
  }

  measure: count {
    type: count
    drill_fields: [gorillas_product_name, flink_product_name]
  }
}
