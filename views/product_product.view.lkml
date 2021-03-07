view: product_product {
  sql_table_name: `flink-backend.saleor_db.product_product`
    ;;
  drill_fields: [id]

  dimension: id {
    label: "Product ID"
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

  dimension_group: available_for_purchase {
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
    sql: ${TABLE}.available_for_purchase ;;
  }

  dimension: category_id {
    type: number
    sql: ${TABLE}.category_id ;;
  }

  dimension: charge_taxes {
    type: yesno
    sql: ${TABLE}.charge_taxes ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: default_variant_id {
    type: number
    sql: ${TABLE}.default_variant_id ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: description_json {
    type: string
    sql: ${TABLE}.description_json ;;
  }

  dimension: is_published {
    type: yesno
    sql: ${TABLE}.is_published ;;
  }

  dimension: metadata {
    type: string
    sql: ${TABLE}.metadata ;;
  }

  dimension: minimal_variant_price_amount {
    type: number
    sql: ${TABLE}.minimal_variant_price_amount ;;
  }

  dimension: name {
    label: "Product Name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: private_metadata {
    type: string
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: product_type_id {
    type: number
    sql: ${TABLE}.product_type_id ;;
  }

  dimension_group: publication {
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
    sql: ${TABLE}.publication_date ;;
  }

  dimension: seo_description {
    type: string
    sql: ${TABLE}.seo_description ;;
  }

  dimension: seo_title {
    type: string
    sql: ${TABLE}.seo_title ;;
  }

  dimension: slug {
    type: string
    sql: ${TABLE}.slug ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension: visible_in_listings {
    type: yesno
    sql: ${TABLE}.visible_in_listings ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
