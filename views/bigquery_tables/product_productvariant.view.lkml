view: product_productvariant {
  sql_table_name: `flink-data-prod.saleor_prod_global.product_productvariant`
    ;;
  drill_fields: [id]
  view_label: "* Product / SKU Data *"

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

  dimension: currency {
    type: string
    hidden: yes
    sql: ${TABLE}.currency ;;
  }

  dimension: metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.metadata ;;
  }

  dimension: name {
    group_label: "* Product Attributes *"
    label: "Productvariant Name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: price_amount {
    type: number
    sql: ${TABLE}.price_amount ;;
  }

  dimension: private_metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: product_id {
    type: number
    hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: sku {
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: sort_order {
    type: number
    hidden: yes
    sql: ${TABLE}.sort_order ;;
  }

  dimension: track_inventory {
    type: yesno
    hidden: yes
    sql: ${TABLE}.track_inventory ;;
  }

}
