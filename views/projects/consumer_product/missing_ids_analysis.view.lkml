view: missing_ids_analysis {
  derived_table: {
    sql:
    with checkout_viewed as (
SELECT distinct
      anonymous_id
    , case when te.context_traits_anonymous_id is null then false else true end as is_qa
    , context_app_version
    , context_device_type
    , context_traits_user_id as user_id
    , context_traits_user_logged_in
    , id as event_uuid
    , date(timestamp) as event_date
 FROM `flink-data-prod.flink_ios_production.checkout_viewed` t
    LEFT JOIN (
        SELECT distinct
              context_traits_anonymous_id
            , context_traits_email
        FROM `flink-data-prod.flink_ios_production.users`
        WHERE context_traits_email = 'qa@goflink.com'
    ) te
    ON t.anonymous_id = te.context_traits_anonymous_id
 WHERE
    context_traits_user_logged_in is not null
)

, voucher_redemption_attempted as (
SELECT distinct
      anonymous_id
    , case when te.context_traits_anonymous_id is null then false else true end as is_qa
    , context_app_version
    , context_device_type
    , context_traits_user_id as user_id
    , context_traits_user_logged_in
    , id as event_uuid
    , date(timestamp) as event_date
 FROM `flink-data-prod.flink_ios_production.voucher_redemption_attempted` t
    LEFT JOIN (
        SELECT distinct
              context_traits_anonymous_id
            , context_traits_email
        FROM `flink-data-prod.flink_ios_production.users`
        WHERE context_traits_email = 'qa@goflink.com'
    ) te
    ON t.anonymous_id = te.context_traits_anonymous_id
 WHERE
    context_traits_user_logged_in is not null
)

select
     'checkout_viewed' as event_name
    , event_date
    , context_device_type
    , context_app_version
    , context_traits_user_logged_in
    , count(distinct anonymous_id) as count_anonymous_id
from checkout_viewed
where
    is_qa is false
group by 1,2,3,4,5
-- order by 2,4,5

UNION ALL
select
     'voucher_redemption_attempted' as event_name
    , event_date
    , context_device_type
    , context_app_version
    , context_traits_user_logged_in
    , count(distinct anonymous_id) as count_anonymous_id
from voucher_redemption_attempted
where
    is_qa is false
group by 1,2,3,4,5
order by 2,4,5

;;
  }



  dimension_group: event_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.event_date AS DATE) ;;
    datatype: date
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: user_logged_in {
    type: yesno
    sql: ${TABLE}.context_traits_user_logged_in ;;
  }


  measure: sum_of_anonymous_id_count {
    type: sum
    sql: ${TABLE}.count_anonymous_id ;;
  }







}
