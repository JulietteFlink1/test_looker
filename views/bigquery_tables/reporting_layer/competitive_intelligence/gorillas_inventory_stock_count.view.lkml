view: gorillas_inventory_stock_count {
  sql_table_name: `flink-data-prod.reporting.gorillas_inventory_stock_count`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: count_purchased {
    type: number
    sql: ${TABLE}.count_purchased ;;
  }

  dimension: count_restocked {
    type: number
    sql: ${TABLE}.count_restocked ;;
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

  dimension: country_of_origin {
    type: string
    sql: ${TABLE}.country_of_origin ;;
  }

  dimension: current_quantity {
    type: number
    sql: ${TABLE}.current_quantity ;;
  }

  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: gorillas_product_sales_uuid {
    type: string
    sql: ${TABLE}.gorillas_product_sales_uuid ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: hub_label {
    type: string
    sql: ${TABLE}.hub_label ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  # dimension: latitude {
  #   type: number
  #   sql: ${TABLE}.latitude ;;
  # }

  # dimension: longitude {
  #   type: number
  #   sql: ${TABLE}.longitude ;;
  # }

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

  dimension: parent_category {
    type: string
    sql: ${TABLE}.parent_category ;;
  }

  dimension: parent_category_id {
    type: string
    sql: ${TABLE}.parent_category_id ;;
  }

  dimension: previous_quantity {
    type: number
    sql: ${TABLE}.previous_quantity ;;
  }

  dimension: price_gross {
    type: number
    sql: ${TABLE}.price_gross ;;
  }

  dimension: price_per_unit_of_measure {
    type: number
    sql: ${TABLE}.price_per_unit_of_measure ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
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

  dimension: revenue {
    type: number
    value_format: "0.00€"
    sql: ${TABLE}.revenue ;;
  }

  dimension: scrape_id {
    type: string
    sql: ${TABLE}.scrape_id ;;
  }

  dimension: striked_price {
    type: number
    sql: ${TABLE}.striked_price ;;
  }

  dimension: subcategory {
    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: subcategory_id {
    type: string
    sql: ${TABLE}.subcategory_id ;;
  }

  dimension_group: time_scraped {
    type: time
    sql: ${TABLE}.time_scraped ;;
  }


  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}.unit_of_measure ;;
  }

  dimension: vat_percent {
    type: number
    sql: ${TABLE}.vat_percent ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  measure: count {
    type: count
    drill_fields: [hub_name, product_name]
  }

  measure: sum_revenue {
    type: sum
    value_format: "0.00€"
    sql: ${revenue} ;;
  }

  measure: sum_restocked {
    type: sum
    sql: ${count_restocked} ;;
  }

  measure: sum_purchased {
    type: sum
    sql: ${count_purchased} ;;
  }

}
