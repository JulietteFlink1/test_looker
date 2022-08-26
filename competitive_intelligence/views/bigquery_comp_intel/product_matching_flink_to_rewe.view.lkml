# Owner: Brandon Beckett
# Created: 2022-08-17

# This view contains Flink product SKUs and the best available REWE product match.

view: product_matching_flink_to_rewe {
  sql_table_name: `flink-data-prod.comp_intel.product_matching_flink_to_rewe` ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ====================     __main__     ====================

  dimension: flink_product_sku {

    label: "Flink SKU"
    description: "Flink's Product SKU."
    group_label: "Flink-REWE Product Match"

    type: string
    sql: ${TABLE}.flink_product_sku ;;
  }

  dimension: rewe_product_id {

    label: "REWE NAN"
    description: "REWE's National Article Number. May be referred to as NAN, EDI, or REWE Product ID."
    group_label: "Flink-REWE Product Match"

    type: string
    sql: ${TABLE}.rewe_product_id ;;
  }

  dimension: match_type {

    label: "Match Type"
    description: "The type of product match applied. E.g. manual, nan, fuzzy."
    group_label: "Flink-REWE Product Match"

    type: string
    sql: ${TABLE}.match_type ;;
  }

  dimension: match_score {

    label: "Match Score"
    description: "The best match score that exists for this product match. Match scores range from -2.0 to 3.0 for fuzzy matches, 10.0 for nan matches, and 100.0 for manual matches."
    group_label: "Flink-REWE Product Match"

    type: number
    sql: ${TABLE}.match_score ;;
  }

  dimension: conversion_factor {

    label: "Conversion Factor"
    description: "This number is multiplied by the competitor price for better Flink-Competitor price comparisons."
    group_label: "Flink-REWE Product Match"

    type: number
    sql: ${TABLE}.conversion_factor ;;
  }

# ====================       IDs        ====================

  dimension: match_uuid {

    label: "REWE NAN"
    description: "Unique match ID generated from the flink_product_sku and rewe_product_id."
    group_label: "Flink-REWE Product Match"

    type: string
    sql: ${TABLE}.match_uuid ;;

    primary_key: yes
    hidden: yes
  }

}
