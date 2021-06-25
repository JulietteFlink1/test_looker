view: product_producttype {
  sql_table_name: `flink-backend.saleor_db_global.product_producttype`
    ;;
  drill_fields: [id]
  view_label: "* Product / SKU Data *"

  dimension: id {
    label: "Producttype ID"
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

  dimension: has_variants {
    group_label: "* Product Attributes *"
    type: yesno
    sql: ${TABLE}.has_variants ;;
  }

  dimension: is_digital {
    group_label: "* Product Attributes *"
    type: yesno
    sql: ${TABLE}.is_digital ;;
  }

  dimension: is_shipping_required {
    group_label: "* Product Attributes *"
    type: yesno
    sql: ${TABLE}.is_shipping_required ;;
  }

  dimension: metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.metadata ;;
  }

  dimension: name {
    group_label: "* Product Attributes *"
    label: "Producttype Name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: private_metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: slug {
    type: string
    hidden: yes
    sql: ${TABLE}.slug ;;
  }

  dimension: weight {
    type: number
    hidden: yes
    sql: ${TABLE}.weight ;;
  }

}
