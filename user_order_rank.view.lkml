view: user_order_rank {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql:
          SELECT
                  order_order.country_iso,
                  order_order.id,
                  row_number() over (partition by country_iso, user_email order by order_order.id) as user_order_rank
                FROM `flink-backend.saleor_db_global.order_order` order_order
                where order_order.status IN ('fulfilled', 'partially fulfilled')
          ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: user_order_rank {
    group_label: "* User Dimensions *"
    type: number
    sql: ${TABLE}.user_order_rank ;;
  }
}
