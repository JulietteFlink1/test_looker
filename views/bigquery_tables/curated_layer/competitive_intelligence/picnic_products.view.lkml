view: picnic_products {
  sql_table_name: `flink-data-prod.curated.picnic_products`
    ;;

  dimension: category_l0 {
    type: number
    sql: ${TABLE}.category_l0 ;;
  }

  dimension: category_l1 {
    type: number
    sql: ${TABLE}.category_l1 ;;
  }

  dimension: category_l2 {
    type: string
    sql: ${TABLE}.category_l2 ;;
  }

  dimension: max_single_order_quantity {
    type: number
    sql: ${TABLE}.max_single_order_quantity ;;
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

  dimension: picnic_products_hist_uuid {
    type: string
    sql: ${TABLE}.picnic_products_hist_uuid ;;
  }

  dimension: price_gross {
    type: number
    sql: ${TABLE}.price_gross ;;
  }

  dimension: price_per_unit_of_measure {
    type: string
    sql: ${TABLE}.price_per_unit_of_measure ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_quantity {
    type: string
    sql: ${TABLE}.product_quantity ;;
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
