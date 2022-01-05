view: albert_hejn_products {
  sql_table_name: `flink-data-prod.curated.albert_hejn_products`
    ;;

  dimension: albert_hejn_products_hist_uuid {
    type: string
    sql: ${TABLE}.albert_hejn_products_hist_uuid ;;
  }

  dimension: category_id {
    type: number
    sql: ${TABLE}.category_id ;;
  }

  dimension: category_name {
    type: string
    sql: ${TABLE}.category_name ;;
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
    value_format_name: euro_accounting_2_precision
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
    type: string
    sql: ${TABLE}.product_quantity ;;
  }

  dimension: subcategory_id {
    type: number
    sql: ${TABLE}.subcategory_id ;;
  }

  dimension: subcategory_name {
    type: string
    sql: ${TABLE}.subcategory_name ;;
  }

  measure: count {
    type: count
    drill_fields: [category_name, subcategory_name, product_name]
  }
}
