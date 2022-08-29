view: gorillas_to_flink_global {
  sql_table_name: `flink-data-prod.curated.gorillas_to_flink_global`
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

  dimension: flink_product_name {
    type: string
    sql: ${TABLE}.flink_product_name ;;
  }

  dimension: flink_product_sku {
    type: string
    sql: ${TABLE}.flink_product_sku ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    group_label: "> IDs"
  }

  dimension: gorillas_product_id {
    type: string
    sql: ${TABLE}.gorillas_product_id ;;
    hidden: yes
    primary_key: yes
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
