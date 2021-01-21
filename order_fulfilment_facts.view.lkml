view: order_fulfilment_facts {
  derived_table: {
    sql: SELECT
          order_order.id  AS order_order_id,
        order_fulfillment.id  AS order_fulfillment_id,
        FORMAT_TIMESTAMP('%F %T', order_order.created ) AS order_order_created_time,
        FORMAT_TIMESTAMP('%F %T', order_fulfillment.created ) AS order_fulfillment_created_time,
        CAST(TIMESTAMP_DIFF(order_fulfillment.created , order_order.created , MINUTE) AS INT64) AS order_order_minutes_time_diff_between_x,
        COUNT(order_fulfillment.id ) AS order_fulfillment_count,
        RANK() OVER(partition by order_order.id order by MIN(order_fulfillment.created)) as order_rank
      FROM `flink-backend.pickery_saleor_db.order_order`
           AS order_order
      LEFT JOIN `flink-backend.pickery_saleor_db.order_fulfillment`
           AS order_fulfillment ON order_fulfillment.order_id = order_order.id

      GROUP BY 1,2,3,4,5
      ORDER BY 1,4 asc
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_order_id {
    type: number
    sql: ${TABLE}.order_order_id ;;
  }

  dimension: order_fulfillment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_fulfillment_id ;;
  }

  dimension: order_order_created_time {
    type: string
    sql: ${TABLE}.order_order_created_time ;;
  }

  dimension: order_fulfillment_created_time {
    type: string
    sql: ${TABLE}.order_fulfillment_created_time ;;
  }

  dimension: order_order_minutes_time_diff_between_x {
    type: number
    sql: ${TABLE}.order_order_minutes_time_diff_between_x ;;
  }

  dimension: order_fulfillment_count {
    type: number
    sql: ${TABLE}.order_fulfillment_count ;;
  }

  dimension: order_rank {
    type: number
    sql: ${TABLE}.order_rank ;;
  }

  dimension: is_first_order {
    description: "Is this the first session for this user?"
    type: yesno
    sql: ${order_rank} = 1 ;;
  }

  set: detail {
    fields: [
      order_order_id,
      order_fulfillment_id,
      order_order_created_time,
      order_fulfillment_created_time,
      order_order_minutes_time_diff_between_x,
      order_fulfillment_count,
      order_rank
    ]
  }
}
