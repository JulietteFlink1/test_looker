view: order_fulfillment_facts_clean {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql: SELECT
        *,
        LEAD(order_fulfillment_created_time) OVER(partition by country_iso, order_order_id order by order_fulfillment_rank) AS leading_order_fulfillment_created_time FROM
        (
          SELECT
                  order_order.country_iso,
                  order_order.id  AS order_order_id,
                  order_fulfillment.id  AS order_fulfillment_id,
                  FORMAT_TIMESTAMP('%F %T', order_order.created ) AS order_order_created_time,
                  FORMAT_TIMESTAMP('%F %T', order_fulfillment.created ) AS order_fulfillment_created_time,
                  CAST(TIMESTAMP_DIFF(order_fulfillment.created , order_order.created , MINUTE) AS INT64) AS minutes_time_diff_between_order_created_and_fulfillment_created,
                  COUNT(order_fulfillment.id) AS order_fulfillment_count,
                  RANK() OVER(partition by order_order.country_iso, order_order.id order by MIN(order_fulfillment.created)) as order_fulfillment_rank

                  FROM `flink-data-prod.saleor_prod_global.order_order` AS order_order
                  LEFT JOIN `flink-data-prod.saleor_prod_global.order_fulfillment` AS order_fulfillment ON order_fulfillment.country_iso = order_order.country_iso AND order_fulfillment.order_id = order_order.id

                GROUP BY 1,2,3,4,5,6
                ORDER BY 1,2,5
        )
       ;;
  }


  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: order_order_id {
    type: number
    hidden: yes
    sql: ${TABLE}.order_order_id ;;
  }

  dimension: order_fulfillment_id {
    primary_key: no
    type: number
    hidden: yes
    sql: ${TABLE}.order_fulfillment_id ;;
  }

  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${order_fulfillment_id}) ;;
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

  ########### Cross Referenced Dimensions

  dimension: time_diff_between_two_subsequent_fulfillments {
    group_label: "* Operations / Logistics *"
    type: number
    sql: TIMESTAMP_DIFF(TIMESTAMP(${leading_order_fulfillment_created_time}), ${order_fulfillment_clean.created_raw}, SECOND) / 60 ;;
  }

  dimension: is_picking_less_than_0_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${time_diff_between_two_subsequent_fulfillments} < 0 ;;
  }

  dimension: is_picking_more_than_30_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${time_diff_between_two_subsequent_fulfillments} > 30 ;;
  }

  measure: avg_picking_time {
    group_label: "* Operations / Logistics *"
    label: "AVG Picking Time"
    description: "Average Picking Time considering first fulfillment to second fulfillment created. Outliers excluded (<0min or >30min)"
    hidden:  no
    type: average
    sql:${time_diff_between_two_subsequent_fulfillments};;
    value_format: "0.0"
    filters: [is_first_fulfillment: "yes", is_picking_less_than_0_minute: "no", is_picking_more_than_30_minute: "no"]
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
