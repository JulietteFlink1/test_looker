view: user_order_rank {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql:
          SELECT
                  order_order.id,
                  row_number() over (partition by user_email order by order_order.id) as user_order_rank
                FROM `flink-backend.saleor_db.order_order` order_order
                where order_order.status IN ('fulfilled', 'partially fulfilled')
          ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: user_order_rank {
    type: number
    sql: ${TABLE}.user_order_rank ;;
  }
}
