view: orderline_ct {
  sql_table_name: `flink-data-prod.curated.orderline_ct`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: no
    hidden: yes
    type: string
    sql: ${TABLE}.lineitem_id ;;
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

  dimension: unit_price_gross_amount {
    type: number
    sql: ${TABLE}.amt_unit_price_gross ;;
  }

  dimension: unit_price_net_amount {
    type: number
    sql: ${TABLE}.amt_unit_price_net ;;
  }

  dimension: variant_id {
    type: number
    sql: null ;;
  }

  dimension: variant_name {
    type: string
    sql: null ;;
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

  dimension: is_shipping_required {
    type: yesno
    hidden: yes
    sql: null ;;
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

  dimension: quantity_fulfilled {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: product_sku {
    type: number
    sql: ${TABLE}.sku ;;
  }

  dimension: tax_rate {
    type: number
    sql: ${TABLE}.tax_rate ;;
  }

  dimension: translated_product_name {
    type: string
    sql: null ;;
  }

  dimension: translated_variant_name {
    type: string
    sql: null ;;
  }

  dimension: unique_id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.lineitem_uuid ;;
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

  measure: sum_item_quantity_fulfilled {
    label: "SUM Item Quantity fulfilled"
    description: "Quantity of Order Line Items fulfilled"
    hidden:  no
    type: sum
    sql: ${quantity_fulfilled};;
    value_format: "0"
  }

  measure: sum_item_price_gross {
    label: "SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_item_price_net {
    label: "SUM Item Prices sold (net)"
    description: "Sum of sold Item prices (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_item_price_fulfilled_gross {
    label: "SUM Item Prices fulfilled (gross)"
    description: "Sum of fulfilled Item prices (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_item_price_fulfilled_net {
    label: "SUM Item Prices fulfilled (net)"
    description: "Sum of fulfilled Item prices (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: cnt_skus {
    type: count_distinct
    label: "AVG SKUS"
    sql: ${product_sku} ;;
    value_format_name: decimal_1
  }


  measure: number_of_orderlines {
    type: count
    drill_fields: [id, product_name]
  }
}
