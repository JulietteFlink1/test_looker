view: product_attributevalue {
  sql_table_name: `flink-backend.saleor_db.product_attributevalue`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: attribute_id {
    type: number
    hidden: yes
    sql: ${TABLE}.attribute_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: slug {
    type: string
    sql: ${TABLE}.slug ;;
  }

  dimension: sort_order {
    type: number
    sql: ${TABLE}.sort_order ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }

}
