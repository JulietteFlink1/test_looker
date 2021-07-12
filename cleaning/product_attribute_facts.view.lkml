view: product_attribute_facts {
  sql_table_name: `flink-data-dev.sandbox.product_attribute_facts`
    ;;
  view_label: "* Product / SKU Data *"
  drill_fields: [id]

  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: id {
    group_label: "* IDs *"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: ean {
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: leading_product {
    group_label: "* Product Attributes *"
    type: string
    sql: ${TABLE}.leading_product ;;
  }

  dimension: noos_group {
    group_label: "* Product Attributes *"
    type: string
    sql: ${TABLE}.noos_group ;;
  }

  dimension: sku {
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: substitute_group {
    group_label: "* Product Attributes *"
    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  dimension: substitute_group_internal_ranking {
    group_label: "* Product Attributes *"
    type: string
    sql: ${TABLE}.substitute_group_internal_ranking ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
