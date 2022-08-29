view: flink_to_albert_heijn_global {
  sql_table_name: `flink-data-prod.curated.flink_to_albert_heijn_global`
    ;;

  dimension: albert_heijn_product_id {
    type: string
    sql: ${TABLE}.albert_heijn_product_id ;;
  }

  dimension: albert_heijn_product_name {
    type: string
    sql: ${TABLE}.albert_heijn_product_name ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: flink_product_name {
    type: string
    sql: ${TABLE}.flink_product_name ;;
  }

  dimension: flink_product_sku {
    type: string
    sql: ${TABLE}.flink_product_sku ;;
  }

  dimension: match_score {
    type: number
    sql: ${TABLE}.match_score ;;
  }

  dimension: match_type {
    type: string
    sql: ${TABLE}.match_type ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    primary_key: yes
  }

  dimension: conversion_factor {
    type: number
    sql: ${TABLE}.conversion_factor ;;
  }

  measure: count {
    type: count
    drill_fields: [albert_heijn_product_name, flink_product_name]
  }
}
