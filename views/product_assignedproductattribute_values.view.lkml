view: product_assignedproductattribute_values {
  sql_table_name: `flink-backend.saleor_db.product_assignedproductattribute_values`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: assignedproductattribute_id {
    type: number
    hidden: yes
    sql: ${TABLE}.assignedproductattribute_id ;;
  }

  dimension: attributevalue_id {
    type: number
    hidden: yes
    sql: ${TABLE}.attributevalue_id ;;
  }

}
