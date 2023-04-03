# Owner: Brandon Beckett & Kristina Voloshina
# Created: 2023-02-14

# This view contains the currently published products that are actively assigned to a hub. This reporting layer view is to be hidden from external stakeholders, and is specifically for Pricing & Competitive-Intel use cases.

view: published_and_assigned_products {
  sql_table_name: `flink-data-prod.reporting.published_and_assigned_products`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: parent_sku {
    type: string
    sql: ${TABLE}.parent_sku ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

}
