view: orderline_ct {
  sql_table_name: `flink-data-dev.curated.orderline_ct`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: amt_discount {
    type: number
    sql: ${TABLE}.amt_discount ;;
  }

  dimension: amt_revenue_gross {
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: amt_total_price_gross {
    type: number
    sql: ${TABLE}.amt_total_price_gross ;;
  }

  dimension: amt_total_price_net {
    type: number
    sql: ${TABLE}.amt_total_price_net ;;
  }

  dimension: amt_unit_price_gross {
    type: number
    sql: ${TABLE}.amt_unit_price_gross ;;
  }

  dimension: amt_unit_price_net {
    type: number
    sql: ${TABLE}.amt_unit_price_net ;;
  }

  dimension: backend_source {
    type: string
    sql: ${TABLE}.backend_source ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
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

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: product_category_erp {
    type: string
    sql: ${TABLE}.product_category_erp ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_name_erp {
    type: string
    sql: ${TABLE}.product_name_erp ;;
  }

  dimension: product_shelf_no {
    type: string
    sql: ${TABLE}.product_shelf_no ;;
  }

  dimension: product_slug {
    type: string
    sql: ${TABLE}.product_slug ;;
  }

  dimension: product_subcategory_erp {
    type: string
    sql: ${TABLE}.product_subcategory_erp ;;
  }

  dimension: product_substitute_group {
    type: string
    sql: ${TABLE}.product_substitute_group ;;
  }

  dimension: product_unit {
    type: number
    sql: ${TABLE}.product_unit ;;
  }

  dimension: product_uom {
    type: string
    sql: ${TABLE}.product_uom ;;
  }

  dimension: product_uuid {
    type: string
    sql: ${TABLE}.product_uuid ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: sku {
    type: number
    sql: ${TABLE}.sku ;;
  }

  dimension: tax_rate {
    type: number
    sql: ${TABLE}.tax_rate ;;
  }

  dimension: unique_id {
    type: string
    sql: ${TABLE}.unique_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, product_name]
  }
}
