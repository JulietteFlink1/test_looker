view: missing_ids_ct_analysis {
  derived_table: {
    sql: with checkout_viewed as (
SELECT distinct
      context_traits_user_id
     , 'ios' as device
FROM `flink-data-prod.flink_ios_production.checkout_viewed`
WHERE context_traits_user_id is not null
and context_traits_user_id not in ( '2CpVZEc9vTU6R3zGg5V9Mn5APmG3','v80DIHyDugaBfGTJigL5zVdY1DY2')

UNION ALL

SELECT distinct
      context_traits_user_id
     , 'android' as device
FROM `flink-data-prod.flink_android_production.checkout_viewed`
WHERE context_traits_user_id is not null
and context_traits_user_id not in ( '2CpVZEc9vTU6R3zGg5V9Mn5APmG3','v80DIHyDugaBfGTJigL5zVdY1DY2')
order by 1
)

, order_placed as (
SELECT distinct
      context_traits_user_id
     , 'ios' as device
FROM `flink-data-prod.flink_ios_production.order_placed`
WHERE context_traits_user_id is not null
and context_traits_user_id not in ( '2CpVZEc9vTU6R3zGg5V9Mn5APmG3','v80DIHyDugaBfGTJigL5zVdY1DY2')

UNION ALL

SELECT distinct
      context_traits_user_id
     , 'android' as device
FROM `flink-data-prod.flink_android_production.order_placed`
WHERE context_traits_user_id is not null
and context_traits_user_id not in ( '2CpVZEc9vTU6R3zGg5V9Mn5APmG3','v80DIHyDugaBfGTJigL5zVdY1DY2')
order by 1
)

, curated as (
        SELECT DISTINCT external_id
        FROM
            `flink-data-prod.curated.orders`
)

 SELECT
        'checkout_viewed' as event_name
        ,is_ct_present
        , count(*) as count_all
 FROM (
    SELECT  DISTINCT
          context_traits_user_id
        , external_id
        , case when external_id is null then false else true end as is_ct_present
    FROM  checkout_viewed
    LEFT JOIN curated
    ON checkout_viewed.context_traits_user_id = curated.external_id
 )t
 GROUP BY 1,2
 UNION ALL
  SELECT
        'order_placed' as event_name
        ,is_ct_present
        , count(*) as count_all
 FROM (
    SELECT  DISTINCT
          context_traits_user_id
        , external_id
        , case when external_id is null then false else true end as is_ct_present
    FROM  order_placed
    LEFT JOIN curated
    ON order_placed.context_traits_user_id = curated.external_id
 )t
 GROUP BY 1,2

 ;;
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: is_ct_present {
    type: yesno
    sql: ${TABLE}.is_ct_present ;;
  }

  measure: sum_of_user_id_count {
    type: sum
    sql: ${TABLE}.count_all ;;
  }


}
