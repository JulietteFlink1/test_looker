# Owner: Brandon Beckett
# Created: 2022-02-08
#
# This view contains Gorillas historical scraped data
#
# Logs:
# 2022-02-08 - Initially created view for explore related to Jira Ticket: DATA-1780

view: gorillas_products_hist {
  sql_table_name: `flink-data-prod.curated.gorillas_products_hist` ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ====================     __main__     ====================

  dimension_group: partition_timestamp {
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
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension: country_of_origin {
    type: string
    sql: ${TABLE}.country_of_origin ;;
  }

  dimension: deposit_amount {
    type: number
    sql: ${TABLE}.deposit_amount ;;
    group_label: "> Pricing Data"
  }

  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: max_single_order_quantity {
    type: number
    sql: ${TABLE}.max_single_order_quantity ;;
  }

  dimension: min_single_order_quantity {
    type: number
    sql: ${TABLE}.min_single_order_quantity ;;
  }

  dimension: net_weight {
    type: string
    sql: ${TABLE}.net_weight ;;
  }

  dimension: price_gross {
    type: number
    sql: ${TABLE}.price_gross ;;
    group_label: "> Pricing Data"
  }

  dimension: price_per_unit_of_measure {
    type: number
    sql: ${TABLE}.price_per_unit_of_measure ;;
    group_label: "> Pricing Data"
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_quantity {
    type: number
    sql: ${TABLE}.product_quantity ;;
  }

  dimension: product_synonyms {
    type: string
    sql: ${TABLE}.product_synonyms ;;
  }

  dimension: striked_price {
    type: number
    sql: ${TABLE}.striked_price ;;
    group_label: "> Pricing Data"
  }

  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}.unit_of_measure ;;
    group_label: "> Pricing Data"
  }

  dimension: vat_percent {
    type: number
    sql: ${TABLE}.vat_percent ;;
    group_label: "> Pricing Data"
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }


# ====================      hidden      ====================



# ====================       IDs        ====================

  dimension: gorillas_products_hist_uuid {
    type: string
    sql: ${TABLE}.gorillas_products_hist_uuid ;;
    primary_key: yes
    group_label: "> IDs"
  }

  dimension: scrape_id {
    type: string
    sql: ${TABLE}.scrape_id ;;
    group_label: "> IDs"
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
    group_label: "> IDs"
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
    group_label: "> IDs"
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: avg_product_price {
    label: "Average Price"
    description: "Average gross item price."
    hidden:  no
    type: average
    sql: ${price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: med_product_price {
    label: "Median Price"
    description: "Median gross item price."
    hidden:  no
    type: median
    sql: ${price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: min_product_price {
    label: "Minimum Price"
    description: "Minimum gross item price."
    hidden:  no
    type: min
    sql: ${price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: max_product_price {
    label: "Maximum Price"
    description: "Maximum gross item price."
    hidden:  no
    type: max
    sql: ${price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: number_of_distinct_products {
    label: "Number of Unique Products"
    description: "Number of unique products."
    hidden:  no
    type: count_distinct
    sql: ${product_id};;
    value_format: "0"
  }
}
