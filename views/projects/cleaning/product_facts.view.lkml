view: product_facts {
  sql_table_name: `flink-data-dev.sandbox.product_facts`
    ;;

  dimension_group: available_for_purchase {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.available_for_purchase_date ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: has_variants {
    type: string
    sql: ${TABLE}.has_variants ;;
  }

  dimension: is_digital {
    type: string
    sql: ${TABLE}.is_digital ;;
  }

  dimension: is_published {
    type: string
    sql: ${TABLE}.is_published ;;
  }

  dimension: is_shipping_required {
    type: string
    sql: ${TABLE}.is_shipping_required ;;
  }

  dimension: leading_product {
    type: string
    sql: ${TABLE}.leading_product ;;
  }

  dimension: noos_group {
    type: string
    sql: ${TABLE}.noos_group ;;
  }

  dimension: parent_category_name {
    type: string
    sql: ${TABLE}.parent_category_name ;;
  }

  dimension: price_amount {
    type: number
    sql: ${TABLE}.price_amount ;;
  }

  dimension: product_category_name {
    type: string
    sql: ${TABLE}.product_category_name ;;
  }

  dimension: product_description {
    type: string
    sql: ${TABLE}.product_description ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: producttype_name {
    type: string
    sql: ${TABLE}.producttype_name ;;
  }

  dimension: productvariant_name {
    type: string
    sql: ${TABLE}.productvariant_name ;;
  }

  dimension_group: publication {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.publication_date ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: substitute_group {
    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.updated_date ;;
  }

  dimension: visible_in_listings {
    type: string
    sql: ${TABLE}.visible_in_listings ;;
  }

  measure: count {
    type: count
    drill_fields: [productvariant_name, product_name, product_category_name, parent_category_name, producttype_name]
  }
}
