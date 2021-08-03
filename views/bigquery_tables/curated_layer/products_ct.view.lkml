view: products_ct {
  view_label: "* Product Data *"
  sql_table_name: `flink-data-prod.curated.products_ct`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: category {
    type: string
    label: "Parent Category"
    sql: ${TABLE}.category ;;
  }

  dimension: is_leading_product {
    type: yesno
    sql: ${TABLE}.is_leading_product ;;
  }

  dimension: is_noos {
    type: yesno
    sql: ${TABLE}.is_noos ;;
  }

  dimension: country_of_origin {
    type: string
    sql: ${TABLE}.country_of_origin ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: subcategory {
    label: "Sub-Category"
    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: substitute_group {
    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  # =========  hidden   =========
  dimension: primary_key {
    sql: ${TABLE}.product_sku ;;
    primary_key: yes
    hidden: yes
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
    hidden: yes
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
    hidden: yes
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: units_per_hu {
    type: number
    sql: ${TABLE}.units_per_hu ;;
    hidden: yes
  }

  dimension: is_published {
    type: yesno
    sql: ${TABLE}.is_published ;;
    hidden: yes
  }

  dimension: product_erp_brand {
    type: string
    sql: ${TABLE}.product_erp_brand ;;
    hidden: yes
  }

  # =========  Price Data   =========
  dimension: amt_product_price_gross {
    type: number
    sql: ${TABLE}.amt_product_price_gross ;;
    group_label: "> Price Data"
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
    group_label: "> Price Data"
  }

  dimension: deposit_cent_amount {
    type: number
    sql: ${TABLE}.deposit_centAmount ;;
    group_label: "> Price Data"
  }

  dimension: deposit_currency_code {
    type: string
    sql: ${TABLE}.deposit_currencyCode ;;
    group_label: "> Price Data"
  }

  dimension: deposit_type {
    type: string
    sql: ${TABLE}.deposit_type ;;
    group_label: "> Price Data"
  }



  # =========  IDs   =========
  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
    group_label: "> IDs"
  }

  dimension: ean_handling_unit {
    type: number
    sql: ${TABLE}.ean_handling_unit ;;
    group_label: "> IDs"
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
    group_label: "> IDs"
  }

  dimension: product_uuid {
    type: string
    sql: ${TABLE}.product_uuid ;;
    group_label: "> IDs"
  }


  # =========  Special Purpose Data   =========
  dimension: max_single_order_quantity {
    type: number
    sql: ${TABLE}.max_single_order_quantity ;;
    group_label: "> Special Purpose Data"
  }

  dimension: meta_description {
    type: string
    sql: ${TABLE}.meta_description ;;
    group_label: "> Special Purpose Data"
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
    group_label: "> Special Purpose Data"
  }

  dimension: slug_de {
    type: string
    sql: ${TABLE}.slug_de ;;
    group_label: "> Special Purpose Data"
  }

  dimension: synonyms {
    type: string
    sql: ${TABLE}.synonyms ;;
    group_label: "> Special Purpose Data"
  }

  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}.unit_of_measure ;;
    group_label: "> Special Purpose Data"
  }

  dimension: units_per_handling_unit {
    type: number
    sql: ${TABLE}.units_per_handling_unit ;;
    group_label: "> Special Purpose Data"
  }

  dimension: product_shelf_no {
    type: string
    sql: ${TABLE}.product_shelf_no ;;
    group_label: "> Special Purpose Data"
  }



  measure: count {
    type: count
    drill_fields: [product_name]
    hidden: yes
  }
}
