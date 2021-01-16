view: product_product {
  sql_table_name: `heroku_backend.product_product`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: _sdc_batched {
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
    sql: ${TABLE}._sdc_batched_at ;;
  }

  dimension_group: _sdc_extracted {
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
    sql: ${TABLE}._sdc_extracted_at ;;
  }

  dimension_group: _sdc_received {
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
    sql: ${TABLE}._sdc_received_at ;;
  }

  dimension: _sdc_sequence {
    type: number
    sql: ${TABLE}._sdc_sequence ;;
  }

  dimension: _sdc_table_version {
    type: number
    sql: ${TABLE}._sdc_table_version ;;
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
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: price_amount {
    type: number
    sql: ${TABLE}.price_amount ;;
  }

  dimension: private_metadata {
    type: string
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: product_type_id {
    type: number
    sql: ${TABLE}.product_type_id ;;
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

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
