view: product_category {
  sql_table_name: `flink-backend.saleor_db_global.product_category`
    ;;
  drill_fields: [id]
  view_label: "* Product / SKU Category Data *"

  dimension: id {
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

  dimension: background_image {
    type: string
    hidden: yes
    sql: ${TABLE}.background_image ;;
  }

  dimension: background_image_alt {
    type: string
    hidden: yes
    sql: ${TABLE}.background_image_alt ;;
  }

  dimension: description {
    label: "Category Description"
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: description_json {
    type: string
    hidden: yes
    sql: ${TABLE}.description_json ;;
  }

  dimension: level {
    type: number
    hidden: yes
    sql: ${TABLE}.level ;;
  }

  dimension: lft {
    type: number
    hidden: yes
    sql: ${TABLE}.lft ;;
  }

  dimension: metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.metadata ;;
  }

  dimension: name {
    label: "Category Name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: parent_id {
    label: "Parent Category ID"
    type: number
    sql: ${TABLE}.parent_id ;;
  }

  dimension: private_metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: rght {
    type: number
    hidden: yes
    sql: ${TABLE}.rght ;;
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

  dimension: tree_id {
    type: number
    hidden: yes
    sql: ${TABLE}.tree_id ;;
  }

}
