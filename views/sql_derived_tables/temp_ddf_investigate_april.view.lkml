view: temp_ddf_investigate_april {
  derived_table: {
    sql: with   base_cart_viewed AS (
          SELECT
          anonymous_id
     , context_device_type as device_type
     , user_id
     , hub_slug
     , LEFT(hub_slug,2) as country_iso
     , subtotal
     , delivery_fee
     , msg_displayed
     , date(original_timestamp) as date_
     , event_text
     , row_number() OVER (PARTITION BY anonymous_id , DATE(original_timestamp), hub_slug ORDER BY original_timestamp ASC ) as cart_viewed_ranked
      FROM `flink-data-prod.flink_android_production.cart_viewed`
      WHERE DATE(_PARTITIONTIME) >= "2022-03-20" and hub_slug NOT LIKE '%test'
          AND subtotal IS NOT NULL
       )

      , base_cart_updated as (
      SELECT
      anonymous_id
      , context_device_type as device_type
      , user_id
      , hub_slug
      , LEFT(hub_slug,2) as country_iso
      , subtotal
      , delivery_fee
      , msg_displayed
      , date(original_timestamp) as date_
      , original_timestamp
      , event_text
      , row_number() OVER (PARTITION BY anonymous_id , DATE(original_timestamp), hub_slug ORDER BY original_timestamp ASC ) as cart_update_ranked
      FROM `flink-data-prod.flink_android_production.cart_updated`
      WHERE hub_slug NOT LIKE '%test'
      AND DATE(_PARTITIONTIME) >= "2022-03-20"
      and subtotal IS NOT NULL
      )


      , first_cart_viewed_android as (

      SELECT *
      FROM base_cart_viewed
      where cart_viewed_ranked = 1
      )

      , last_cart_updated_helper_android as (
      SELECT anonymous_id
      , date_
      , hub_slug
      , MAX(cart_update_ranked) as last_hit
      FROM base_cart_updated
      GROUP BY 1,2,3
      )

      , last_cart_updated_android as (
      SELECT  bd.*
      , helper.last_hit
      FROM base_cart_updated as bd
      INNER JOIN last_cart_updated_helper_android as helper ON bd.anonymous_id = helper.anonymous_id
      AND bd.cart_update_ranked = helper.last_hit
      AND bd.date_ = helper.date_
      AND bd.hub_slug = helper.hub_slug
      )


      ,  checkout_started_android_helper as (
      SELECT
      anonymous_id
      , hub_slug
      , DATE(timestamp) as date_
      , left(hub_slug , 2 ) as country_iso
      , row_number() OVER(PARTITION BY anonymous_id , DATE(timestamp), hub_slug ORDER BY original_timestamp ASC) as checkout_ranked
      FROM `flink-data-prod.flink_android_production.checkout_started`
      WHERE DATE(_PARTITIONTIME) >= "2022-03-20"
      )

      , checkout_started_android as (
      SELECT *
      FROM checkout_started_android_helper
      where checkout_ranked = 1
      )

      , order_placed_helper_android as (
      SELECT anonymous_id
      , hub_slug
      , delivery_fee
      , order_revenue
      , DATE(timestamp) as date_
      , voucher_value
      , order_number
      , left(hub_slug , 2 ) as country_iso
      , row_number() OVER(PARTITION BY anonymous_id , order_number , hub_slug ORDER BY original_timestamp ASC) as order_rank
      FROM `flink-data-prod.flink_android_production.order_placed`
      WHERE DATE(_PARTITIONTIME) >= "2022-03-20"

      )


      , order_placed_clean_android as (
      SELECT *
      FROM order_placed_helper_android
      where order_rank = 1
      )


      , final_android as (
      SELECT fi.anonymous_id
      , fi.device_type
      , fi.country_iso
      , fi.hub_slug
      , fi.date_
      , fi.delivery_fee
      , fi.msg_displayed
      , fi.subtotal as sub_total_first_hit
      , CASE WHEN la.anonymous_id IS NOT NULL THEN 1 ELSE 0 END as cart_updated
      , la.subtotal as subtotal_last_update
      , la.delivery_fee as df_last_update
      , la.msg_displayed as msg_last_seen
      , la.last_hit as number_of_updates
      , CASE WHEN cs.anonymous_id IS NOT NULL THEN 1 ELSE 0 END as checkout_started
      , CASE WHEN op.anonymous_id IS NOT NULL THEN 1 ELSE 0 END AS order_placed
      , op.delivery_fee as delivery_fee_order
      , op.order_revenue
      , op.voucher_value
      FROM  first_cart_viewed_android as fi
      LEFT JOIN last_cart_updated_android as la ON fi.anonymous_id = la.anonymous_id AND fi.date_ = la.date_ AND fi.hub_slug = la.hub_slug
      LEFT JOIN checkout_started_android as cs ON fi.anonymous_id = cs.anonymous_id AND fi.date_ = cs.date_ AND fi.hub_slug = cs.hub_slug
      LEFT JOIN order_placed_clean_android as op ON fi.anonymous_id = op.anonymous_id AND fi.date_ = op.date_ AND fi.hub_slug = op.hub_slug
      )

      , base_cart_viewed_ios AS (
          SELECT
          anonymous_id
     , context_device_type as device_type
     , user_id
     , hub_slug
     , LEFT(hub_slug,2) as country_iso
     , sub_total
     , delivery_fee
     , msg_displayed
     , date(original_timestamp) as date_
     , event_text
     , row_number() OVER (PARTITION BY anonymous_id , DATE(original_timestamp), hub_slug ORDER BY original_timestamp ASC ) as cart_viewed_ranked
      FROM `flink-data-prod.flink_ios_production.cart_viewed`
      WHERE DATE(_PARTITIONTIME) >= "2022-04-04" and hub_slug NOT LIKE '%test'
          AND sub_total IS NOT NULL
       )

      , base_cart_updated_ios as (
      SELECT
      anonymous_id
      , context_device_type as device_type
      , user_id
      , hub_slug
      , LEFT(hub_slug,2) as country_iso
      , sub_total
      , delivery_fee
      , msg_displayed
      , date(original_timestamp) as date_
      , original_timestamp
      , event_text
      , row_number() OVER (PARTITION BY anonymous_id , DATE(original_timestamp), hub_slug ORDER BY original_timestamp ASC ) as cart_update_ranked
      FROM `flink-data-prod.flink_ios_production.cart_updated`
      WHERE hub_slug NOT LIKE '%test'
      AND DATE(_PARTITIONTIME) >= "2022-04-04"
      and sub_total IS NOT NULL
      )


      , first_cart_viewed_ios as (

      SELECT *
      FROM base_cart_viewed_ios
      where cart_viewed_ranked = 1
      )

      , last_cart_updated_helper_ios as (
      SELECT anonymous_id
      , date_
      , hub_slug
      , MAX(cart_update_ranked) as last_hit
      FROM base_cart_updated_ios
      GROUP BY 1,2,3
      )

      , last_cart_updated_ios as (
      SELECT  bd.*
      , helper.last_hit
      FROM base_cart_updated_ios as bd
      INNER JOIN last_cart_updated_helper_ios as helper ON bd.anonymous_id = helper.anonymous_id
      AND bd.cart_update_ranked = helper.last_hit
      AND bd.date_ = helper.date_
      AND bd.hub_slug = helper.hub_slug
      )


      ,  checkout_started_ios_helper as (
      SELECT
      anonymous_id
      , hub_slug
      , DATE(timestamp) as date_
      , left(hub_slug , 2 ) as country_iso
      , row_number() OVER(PARTITION BY anonymous_id , DATE(timestamp), hub_slug ORDER BY original_timestamp ASC) as checkout_ranked
      FROM `flink-data-prod.flink_ios_production.checkout_started`
      WHERE DATE(_PARTITIONTIME) >= "2022-04-04"
      )

      , checkout_started_ios as (
      SELECT *
      FROM checkout_started_ios_helper
      where checkout_ranked = 1
      )

      , order_placed_helper_ios as (
      SELECT anonymous_id
      , hub_slug
      , delivery_fee
      , order_revenue
      , DATE(timestamp) as date_
      , voucher_value
      , order_number
      , left(hub_slug , 2 ) as country_iso
      , row_number() OVER(PARTITION BY anonymous_id , order_number , hub_slug ORDER BY original_timestamp ASC) as order_rank
      FROM `flink-data-prod.flink_ios_production.order_placed`
      WHERE DATE(_PARTITIONTIME) >= "2022-04-04"

      )


      , order_placed_clean_ios as (
      SELECT *
      FROM order_placed_helper_ios
      where order_rank = 1
      )


      , final_ios as (
      SELECT fi.anonymous_id
      , fi.device_type
      , fi.country_iso
      , fi.hub_slug
      , fi.date_
      , fi.delivery_fee
      , fi.msg_displayed
      , fi.sub_total as sub_total_first_hit
      , CASE WHEN la.anonymous_id IS NOT NULL THEN 1 ELSE 0 END as cart_updated
      , la.sub_total as subtotal_last_update
      , la.delivery_fee as df_last_update
      , la.msg_displayed as msg_last_seen
      , la.last_hit as number_of_updates
      , CASE WHEN cs.anonymous_id IS NOT NULL THEN 1 ELSE 0 END as checkout_started
      , CASE WHEN op.anonymous_id IS NOT NULL THEN 1 ELSE 0 END AS order_placed
      , op.delivery_fee as delivery_fee_order
      , op.order_revenue
      , op.voucher_value
      FROM  first_cart_viewed_ios as fi
      LEFT JOIN last_cart_updated_ios as la ON fi.anonymous_id = la.anonymous_id AND fi.date_ = la.date_ AND fi.hub_slug = la.hub_slug
      LEFT JOIN checkout_started_ios as cs ON fi.anonymous_id = cs.anonymous_id AND fi.date_ = cs.date_ AND fi.hub_slug = cs.hub_slug
      LEFT JOIN order_placed_clean_ios as op ON fi.anonymous_id = op.anonymous_id AND fi.date_ = op.date_ AND fi.hub_slug = op.hub_slug
      )

, aggregate as (
      SELECT * FROM final_android

      UNION ALL

      SELECT * FROM final_ios)

      SELECT * FROM aggregate
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_slug {
    type: string
    sql: ${TABLE}.hub_slug ;;
  }

  dimension: date_ {
    type: date
    datatype: date
    sql: ${TABLE}.date_ ;;
  }

  dimension: delivery_fee {
    type: number
    sql: ${TABLE}.delivery_fee ;;
  }

  dimension: msg_displayed {
    type: string
    sql: ${TABLE}.msg_displayed ;;
  }

  measure: sub_total_first_hit {
    type: number
    sql: ${TABLE}.sub_total_first_hit ;;
  }

  dimension: cart_updated {
    type: number
    sql: ${TABLE}.cart_updated ;;
  }

  measure: subtotal_last_update {
    type: number
    sql: ${TABLE}.subtotal_last_update ;;
  }

  dimension: df_last_update {
    type: number
    sql: ${TABLE}.df_last_update ;;
  }

  dimension: msg_last_seen {
    type: string
    sql: ${TABLE}.msg_last_seen ;;
  }

  dimension: number_of_updates {
    type: number
    sql: ${TABLE}.number_of_updates ;;
  }

  dimension: checkout_started {
    type: number
    sql: ${TABLE}.checkout_started ;;
  }

  dimension: order_placed {
    type: number
    sql: ${TABLE}.order_placed ;;
  }

  dimension: delivery_fee_order {
    type: number
    sql: ${TABLE}.delivery_fee_order ;;
  }

  measure: order_revenue {
    type: number
    sql: ${TABLE}.order_revenue ;;
  }

  measure: voucher_value {
    type: number
    sql: ${TABLE}.voucher_value ;;
  }

  measure: cnt_anonymous {
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }

  measure: sum_updates {
    type: sum
    sql: ${TABLE}.cart_updated ;;
  }

  measure: sum_checkout_started {
    type: sum
    sql: ${TABLE}.checkout_started ;;
  }

  measure: sum_order_placed {
    type: sum
    sql: ${TABLE}.order_placed ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      device_type,
      country_iso,
      hub_slug,
      date_,
      delivery_fee,
      msg_displayed,
      sub_total_first_hit,
      cart_updated,
      subtotal_last_update,
      df_last_update,
      msg_last_seen,
      number_of_updates,
      checkout_started,
      order_placed,
      delivery_fee_order,
      order_revenue,
      voucher_value
    ]
  }
}
