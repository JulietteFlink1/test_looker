view: product_attribute {
  sql_table_name: `heroku_backend.product_attribute`
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

  dimension: available_in_grid {
    type: yesno
    sql: ${TABLE}.available_in_grid ;;
  }

  dimension: filterable_in_dashboard {
    type: yesno
    sql: ${TABLE}.filterable_in_dashboard ;;
  }

  dimension: filterable_in_storefront {
    type: yesno
    sql: ${TABLE}.filterable_in_storefront ;;
  }

  dimension: input_type {
    type: string
    sql: ${TABLE}.input_type ;;
  }

  dimension: is_variant_only {
    type: yesno
    sql: ${TABLE}.is_variant_only ;;
  }

  dimension: metadata {
    type: string
    sql: ${TABLE}.metadata ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: private_metadata {
    type: string
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: slug {
    type: string
    sql: ${TABLE}.slug ;;
  }

  dimension: storefront_search_position {
    type: number
    sql: ${TABLE}.storefront_search_position ;;
  }

  dimension: value_required {
    type: yesno
    sql: ${TABLE}.value_required ;;
  }

  dimension: visible_in_storefront {
    type: yesno
    sql: ${TABLE}.visible_in_storefront ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
