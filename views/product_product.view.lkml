view: product_product {
  sql_table_name: `flink-backend.saleor_db_global.product_product`
    ;;
  drill_fields: [id]
  view_label: "* Product / SKU Data *"

  dimension: id {
    label: "Product ID"
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

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
    hidden: yes
    sql: ${TABLE}.category_id ;;
  }

  dimension: charge_taxes {
    type: yesno
    hidden: yes
    sql: ${TABLE}.charge_taxes ;;
  }

  dimension: currency {
    type: string
    hidden: yes
    sql: ${TABLE}.currency ;;
  }

  dimension: default_variant_id {
    type: number
    hidden: yes
    sql: ${TABLE}.default_variant_id ;;
  }

  dimension: description {
    type: string
    label: "Product Description"
    sql: ${TABLE}.description ;;
  }

  dimension: description_json {
    type: string
    hidden: yes
    sql: ${TABLE}.description_json ;;
  }

  dimension: is_published {
    type: yesno
    sql: ${TABLE}.is_published ;;
  }

  dimension: metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.metadata ;;
  }

  dimension: minimal_variant_price_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.minimal_variant_price_amount ;;
  }

  dimension: name {
    label: "Product Name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: private_metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: product_type_id {
    type: number
    hidden: yes
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
    hidden: yes
    sql: ${TABLE}.seo_description ;;
  }

  dimension: seo_title {
    type: string
    hidden: yes
    sql: ${TABLE}.seo_title ;;
  }

  dimension: slug {
    type: string
    hidden: yes
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

}
