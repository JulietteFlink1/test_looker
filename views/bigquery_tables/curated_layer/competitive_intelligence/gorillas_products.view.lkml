view: gorillas_products {
  view_label: "* Gorillas Products Data *"
  sql_table_name: `flink-data-prod.curated.gorillas_products` ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========

  dimension: gorillas_products_uuid {
    type: string
    sql: ${TABLE}.gorillas_products_uuid ;;
    group_label: "> IDs"
  }

  dimension: scrape_id {
    type: string
    sql: ${TABLE}.scrape_id ;;
    group_label: "> IDs"
  }

  dimension_group: partition_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      day_of_week,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.partition_timestamp ;;
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

  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: country_of_origin {
    type: string
    sql: ${TABLE}.country_of_origin ;;
  }

  dimension: price_gross {
    type: number
    sql: ${TABLE}.price_gross ;;
    group_label: "> Pricing Data"
  }

  dimension: striked_price {
    type: number
    sql: ${TABLE}.striked_price ;;
    group_label: "> Pricing Data"
  }

  dimension: vat_percent {
    type: number
    sql: ${TABLE}.vat_percent ;;
    group_label: "> Pricing Data"
  }

  dimension: price_per_unit_of_measure {
    type: number
    sql: ${TABLE}.price_per_unit_of_measure ;;
    group_label: "> Pricing Data"
  }

  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}.unit_of_measure ;;
    group_label: "> Pricing Data"
  }

  dimension: product_quantity {
    type: number
    sql: ${TABLE}.product_quantity ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  dimension: net_weight {
    type: string
    sql: ${TABLE}.net_weight ;;
  }

  dimension: min_single_order_quantity {
    type: number
    sql: ${TABLE}.min_single_order_quantity ;;
    group_label: "> Special Purpose Data"
  }

  dimension: max_single_order_quantity {
    type: number
    sql: ${TABLE}.max_single_order_quantity ;;
    group_label: "> Special Purpose Data"
  }

  dimension: product_synonyms {
    type: string
    sql: ${TABLE}.product_synonyms ;;
    group_label: "> Special Purpose Data"
  }

}
