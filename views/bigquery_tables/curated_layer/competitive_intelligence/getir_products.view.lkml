view: getir_products {
  sql_table_name: `flink-data-prod.curated.getir_products`
    ;;

  dimension: getir_products_hist_uuid {
    type: string
    sql: ${TABLE}.getir_products_hist_uuid ;;
  }

  dimension: getir_products_uuid {
    type: string
    sql: ${TABLE}.getir_products_uuid ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: parent_category_id {
    type: string
    sql: ${TABLE}.parent_category_id ;;
  }

  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}.unit_of_measure ;;
  }

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

  dimension: price_gross {
    type: number
    sql: ${TABLE}.price_gross ;;
  }

  dimension: price_per_unit_of_measure {
    type: number
    sql: ${TABLE}.price_per_unit_of_measure ;;
  }

  dimension: price_per_unit_of_measure_text {
    type: string
    sql: ${TABLE}.price_per_unit_of_measure_text ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_name_short {
    type: string
    sql: ${TABLE}.product_name_short ;;
  }

  dimension: striked_price {
    type: number
    sql: ${TABLE}.striked_price ;;
  }

  dimension: subcategory_id {
    type: string
    sql: ${TABLE}.subcategory_id ;;
  }

  dimension_group: time_scraped {
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
    sql: ${TABLE}.time_scraped ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name]
  }
}
