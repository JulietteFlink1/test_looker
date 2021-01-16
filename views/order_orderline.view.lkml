view: order_orderline {
  sql_table_name: `heroku_backend.order_orderline`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # dimension_group: _sdc_batched {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_batched_at ;;
  # }

  # dimension_group: _sdc_extracted {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_extracted_at ;;
  # }

  # dimension_group: _sdc_received {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_received_at ;;
  # }

  # dimension: _sdc_sequence {
  #   type: number
  #   sql: ${TABLE}._sdc_sequence ;;
  # }

  # dimension: _sdc_table_version {
  #   type: number
  #   sql: ${TABLE}._sdc_table_version ;;
  # }

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
}
