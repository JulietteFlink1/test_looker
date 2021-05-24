view: checkout_checkoutline {
  sql_table_name: `flink-backend.saleor_db.checkout_checkoutline`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }


  dimension: checkout_id {
    type: string
    hidden: yes
    sql: ${TABLE}.checkout_id ;;
  }

  dimension: data {
    type: string
    hidden: yes
    sql: ${TABLE}.data ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: variant_id {
    type: number
    hidden: yes
    sql: ${TABLE}.variant_id ;;
  }

}
