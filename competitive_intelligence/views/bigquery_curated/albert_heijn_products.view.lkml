view: albert_heijn_products {
  sql_table_name: `flink-data-prod.curated.albert_hejn_products`
    ;;

  dimension: albert_heijn_products_hist_uuid {
    type: string
    sql: ${TABLE}.albert_hejn_products_hist_uuid ;;
    primary_key: yes
  }

  dimension: shop_id {
    type: number
    sql: ${TABLE}.shop_id ;;
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

  dimension: product_uuid {
    type: string
    sql: ${TABLE}.product_uuid ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_name_and_size {
    type: string
    sql: ${TABLE}.product_name_and_size ;;
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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: avg_product_price {
    label: "AVG Price"
    description: "Average gross item price."
    hidden:  no
    type: average
    sql: ${price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: med_product_price {
    label: "MED Price"
    description: "Median gross item price."
    hidden:  no
    type: median
    sql: ${price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: min_product_price {
    label: "MIN Price"
    description: "Minimum gross item price."
    hidden:  no
    type: min
    sql: ${price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: max_product_price {
    label: "MAX Price"
    description: "Maximum gross item price."
    hidden:  no
    type: max
    sql: ${price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: count {
    type: count
    drill_fields: [category_name, subcategory_name, product_name]
  }
}
