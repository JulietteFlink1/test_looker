view: products_ct {
  sql_table_name: `flink-data-prod.curated.products_ct`
    ;;

  dimension: primary_key {
    sql: ${TABLE}.product_sku ;;
    primary_key: yes
    hidden: yes
  }
  dimension: amt_product_price_gross {
    type: number
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: country_of_origin {
    type: string
    sql: ${TABLE}.country_of_origin ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: deposit_cent_amount {
    type: number
    sql: ${TABLE}.deposit_centAmount ;;
  }

  dimension: deposit_currency_code {
    type: string
    sql: ${TABLE}.deposit_currencyCode ;;
  }

  dimension: deposit_type {
    type: string
    sql: ${TABLE}.deposit_type ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: ean_handling_unit {
    type: number
    sql: ${TABLE}.ean_handling_unit ;;
  }

  dimension: is_leading_product {
    type: yesno
    sql: ${TABLE}.is_leading_product ;;
  }

  dimension: is_noos {
    type: yesno
    sql: ${TABLE}.is_noos ;;
  }

  dimension: is_published {
    type: yesno
    sql: ${TABLE}.is_published ;;
  }

  dimension_group: last_modified {
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
    sql: ${TABLE}.last_modified_at ;;
  }

  dimension: max_single_order_quantity {
    type: number
    sql: ${TABLE}.max_single_order_quantity ;;
  }

  dimension: meta_description {
    type: string
    sql: ${TABLE}.meta_description ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_erp_brand {
    type: string
    sql: ${TABLE}.product_erp_brand ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_shelf_no {
    type: string
    sql: ${TABLE}.product_shelf_no ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: product_uuid {
    type: string
    sql: ${TABLE}.product_uuid ;;
  }

  dimension: slug_de {
    type: string
    sql: ${TABLE}.slug_de ;;
  }

  dimension: subcategory {
    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: substitute_group {
    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  dimension: synonyms {
    type: string
    sql: ${TABLE}.synonyms ;;
  }

  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}.unit_of_measure ;;
  }

  dimension: units_per_handling_unit {
    type: number
    sql: ${TABLE}.units_per_handling_unit ;;
  }

  dimension: units_per_hu {
    type: number
    sql: ${TABLE}.units_per_hu ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name]
  }
}
