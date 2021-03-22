view: product_producttype {
  sql_table_name: `flink-backend.saleor_db_global.product_producttype`
    ;;
  drill_fields: [id]

  dimension: id {
    label: "Producttype ID"
    primary_key: no
    type: number
    sql: ${TABLE}.id ;;
  }


  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: has_variants {
    type: yesno
    sql: ${TABLE}.has_variants ;;
  }

  dimension: is_digital {
    type: yesno
    sql: ${TABLE}.is_digital ;;
  }

  dimension: is_shipping_required {
    type: yesno
    sql: ${TABLE}.is_shipping_required ;;
  }

  dimension: metadata {
    type: string
    sql: ${TABLE}.metadata ;;
  }

  dimension: name {
    label: "Producttype Name"
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

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
