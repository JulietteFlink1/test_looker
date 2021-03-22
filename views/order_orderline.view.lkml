view: order_orderline {
  sql_table_name: `flink-backend.saleor_db_global.order_orderline`
    ;;
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      id,
      product_sku,
      product_name,
      unit_price_gross_amount,
      unit_price_net_amount,
      quantity,
      order_order.id,
      order_order.warehouse_name,
      order_order.created_raw,
      order_order.customer_type,
    ]
  }

  dimension: id {
    primary_key: no
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: is_shipping_required {
    type: yesno
    sql: ${TABLE}.is_shipping_required ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: quantity_fulfilled {
    type: number
    sql: ${TABLE}.quantity_fulfilled ;;
  }

  dimension: tax_rate {
    type: number
    sql: ${TABLE}.tax_rate ;;
  }

  dimension: translated_product_name {
    type: string
    sql: ${TABLE}.translated_product_name ;;
  }

  dimension: translated_variant_name {
    type: string
    sql: ${TABLE}.translated_variant_name ;;
  }

  dimension: unit_price_gross_amount {
    type: number
    sql: ${TABLE}.unit_price_gross_amount ;;
  }

  dimension: unit_price_net_amount {
    type: number
    sql: ${TABLE}.unit_price_net_amount ;;
  }

  dimension: variant_id {
    type: number
    sql: ${TABLE}.variant_id ;;
  }

  dimension: variant_name {
    type: string
    sql: ${TABLE}.variant_name ;;
  }

  measure: count {
    type: count
    drill_fields: [id, variant_name, product_name, translated_product_name, translated_variant_name]
  }

##########
## SUMS ##
##########

  measure: sum_item_quantity {
    label: "SUM Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    hidden:  no
    type: sum
    sql: ${quantity};;
    value_format: "0"
  }

  measure: sum_item_price_gross {
    label: "SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${quantity} * ${unit_price_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_item_price_net {
    label: "SUM Item Prices sold (net)"
    description: "Sum of sold Item prices (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${quantity} * ${unit_price_net_amount};;
    value_format_name: euro_accounting_2_precision
  }

}
