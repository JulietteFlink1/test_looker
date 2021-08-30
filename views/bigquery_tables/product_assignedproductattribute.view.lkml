view: product_assignedproductattribute {
  sql_table_name: `flink-data-prod.saleor_prod_global.product_assignedproductattribute`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: assignment_id {
    type: number
    hidden: yes
    sql: ${TABLE}.assignment_id ;;
  }

  dimension: product_id {
    type: number
    hidden: yes
    sql: ${TABLE}.product_id ;;
  }

}
