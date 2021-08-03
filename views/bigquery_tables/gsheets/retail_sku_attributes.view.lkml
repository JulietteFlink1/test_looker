view: retail_sku_attributes {
  sql_table_name: `flink-data-prod.google_sheets.retail_sku_attributes`
    ;;



  dimension: buying_price {
    type: string
    sql: ${TABLE}.buying_price ;;
  }

  dimension: deposit {
    type: number
    sql: ${TABLE}.deposit ;;
  }

  dimension: is_local_product {
    type: yesno
    sql: ${TABLE}.is_local_product ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    primary_key: yes
  }

  dimension: sku_listing_status {
    type: string
    sql: ${TABLE}.sku_listing_status ;;
  }

  dimension: substitute_group_custom_definition {
    type: string
    sql: ${TABLE}.substitute_group_custom_definition ;;
  }

  dimension: subtotal_column {
    type: string
    sql: ${TABLE}.subtotal_column ;;
  }

  dimension: vat_rate {
    type: number
    sql: ${TABLE}.vat_rate ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name]
  }
}
