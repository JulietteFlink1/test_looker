view: order_fulfillment_facts {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql: SELECT
        *,
        LEAD(order_fulfillment_created_time) OVER(partition by order_order_id order by order_fulfillment_rank) AS leading_order_fulfillment_created_time FROM
        (
          SELECT
                  order_order.id  AS order_order_id,
                  order_fulfillment.id  AS order_fulfillment_id,
                  FORMAT_TIMESTAMP('%F %T', order_order.created ) AS order_order_created_time,
                  FORMAT_TIMESTAMP('%F %T', order_fulfillment.created ) AS order_fulfillment_created_time,
                  CAST(TIMESTAMP_DIFF(order_fulfillment.created , order_order.created , MINUTE) AS INT64) AS minutes_time_diff_between_order_created_and_fulfillment_created,
                  COUNT(order_fulfillment.id) AS order_fulfillment_count,
                  RANK() OVER(partition by order_order.id order by MIN(order_fulfillment.created)) as order_fulfillment_rank
                  FROM `flink-backend.saleor_db.order_order`
                     AS order_order
                LEFT JOIN `flink-backend.saleor_db.order_fulfillment`
                     AS order_fulfillment ON order_fulfillment.order_id = order_order.id

                GROUP BY 1,2,3,4,5
                ORDER BY 1,4 asc
        )
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

  dimension: leading_order_fulfillment_created_time {
    type: string
    sql: ${TABLE}.leading_order_fulfillment_created_time ;;
  }

  dimension: order_fulfillment_count {
    type: number
    sql: ${TABLE}.order_fulfillment_count ;;
  }

  dimension: order_fulfillment_rank {
    type: number
    sql: ${TABLE}.order_fulfillment_rank ;;
  }

  dimension: is_first_fulfillment {
    description: "Is this the first fulfillment for this order?"
    type: yesno
    sql: ${order_fulfillment_rank} = 1 ;;
  }

  dimension: is_second_fulfillment {
    description: "Is this the second fulfillment for this order?"
    type: yesno
    sql: ${order_fulfillment_rank} = 2 ;;
  }

  set: detail {
    fields: [
      order_order_id,
      order_fulfillment_id,
      order_order_created_time,
      order_fulfillment_created_time,
      order_fulfillment_count,
      order_fulfillment_rank,
      leading_order_fulfillment_created_time
    ]
  }
}
