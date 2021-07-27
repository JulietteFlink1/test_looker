view: product_product {
  sql_table_name: `flink-data-prod.saleor_prod_global.product_product`
    ;;
  drill_fields: [id]
  view_label: "* Product / SKU Data *"

  dimension: id {
    label: "Product ID"
    group_label: "* IDs *"
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
    group_label: "* IDs *"
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension_group: available_for_purchase {
    type: time
    group_label: "* Dates and Timestamps *"
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
    group_label: "* IDs *"
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
    group_label: "* Product Attributes *"
    label: "Product Description"
    sql: ${TABLE}.description ;;
  }

  dimension: description_json {
    type: string
    hidden: yes
    sql: ${TABLE}.description_json ;;
  }

  dimension: is_published {
    group_label: "* Product Attributes *"
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
    group_label: "* Product Attributes *"
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
    group_label: "* Dates and Timestamps *"
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
    group_label: "* Dates and Timestamps *"
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
    group_label: "* Product Attributes *"
    type: yesno
    sql: ${TABLE}.visible_in_listings ;;
  }

  measure: cnt_sku {
    label: "# SKUs (Total)"
    group_label: "* Basic Counts *"
    description: "Count of Total SKUs in Assortment"
    hidden:  no
    type: count
    value_format: "0"
  }

  measure: cnt_sku_published {
    label: "# SKUs (Published)"
    group_label: "* Basic Counts *"
    description: "Count of published SKUs in Assortment"
    hidden:  no
    type: count
    value_format: "0"
    filters: [is_published: "yes"]
  }

}
