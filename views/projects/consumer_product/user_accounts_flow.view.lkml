view: user_accounts_flow {
  derived_table: {
    persist_for: "24 hours"
    sql:
with base as (
select distinct
      event_date
    , anonymous_id
    , first_value(user_logged_in) over (partition by id order by timestamp asc) as is_user_logged_in  -- user state when started the flow
    , event
    , id
    , platform
    , row_number() over (partition by id order by timestamp) as index -- order asc events per user/ per day
    , row_number() over (partition by id, event order by timestamp) as rn -- increment duplicate rows
from (
    select
        date(timestamp) as event_date
        , timestamp
        , anonymous_id
        , concat(cast(date(timestamp)as string),anonymous_id)   as id
        , context_traits_user_logged_in                         as user_logged_in
        , 'ios'                                                 as platform
        , event
    from
        `flink-data-prod.flink_ios_production.tracks` tracks
    where
        date(tracks._PARTITIONTIME) >= "2021-10-26"
    and
        tracks.event in (
                        --  'product_added_to_cart'
                        -- ,'cart_viewed'
                         'checkout_started'
                        ,'account_registration_viewed'
                        -- ,'account_registration_clicked'
                        ,'account_registration_succeeded'
                        ,'account_registration_error_viewed'
                        ,'account_login_viewed'
                        -- ,'account_login_clicked'
                        ,'account_login_succeeded'
                        ,'account_login_error_viewed'
                        --,'sms_verification_request_viewed'
                        ,'sms_verification_viewed'
                        -- ,'sms_verfication_clicked'
                        -- ,'sms_verification_phone_added'
                        --,'sms_verification_send_code_clicked'
                        ,'sms_verification_confirmed'
                        -- ,'sms_verification_added'
                        ,'sms_verification_error_viewed'
                        ,'checkout_viewed'
                        ,'order_placed'
                        )
    order by anonymous_id, timestamp asc
)t

    union all


 select distinct
      event_date
    , anonymous_id
    , first_value(user_logged_in) over (partition by id order by timestamp asc) as is_user_logged_in  -- user state when started the flow
    , event
    , id
    , platform
    , row_number() over (partition by id order by timestamp) as index -- order asc events per user/ per day
    , row_number() over (partition by id, event order by timestamp) as rn -- increment duplicate rows
from (
    select
        date(timestamp) as event_date
        , timestamp
        , anonymous_id
        , concat(cast(date(timestamp)as string),anonymous_id)   as id
        , context_traits_user_logged_in                         as user_logged_in
        , 'android'                                             as platform
        , event
    from
        `flink-data-prod.flink_android_production.tracks` tracks
    where
        date(tracks._PARTITIONTIME) >= "2021-10-26"
    and
        tracks.event in (
                        --  'product_added_to_cart'
                        -- ,'cart_viewed'
                         'checkout_started'
                        ,'account_registration_viewed'
                        -- ,'account_registration_clicked'
                        ,'account_registration_succeeded'
                        ,'account_registration_error_viewed'
                        ,'account_login_viewed'
                        -- ,'account_login_clicked'
                        ,'account_login_succeeded'
                        ,'account_login_error_viewed'
                        --,'sms_verification_request_viewed'
                        ,'sms_verification_viewed'
                        -- ,'sms_verfication_clicked'
                        -- ,'sms_verification_phone_added'
                        --,'sms_verification_send_code_clicked'
                        ,'sms_verification_confirmed'
                        -- ,'sms_verification_added'
                        ,'sms_verification_error_viewed'
                        ,'checkout_viewed'
                        ,'order_placed'
                        )
    order by anonymous_id, timestamp asc
)t

)


, event_rank as (
select
      event_date
    , anonymous_id
    , platform
    , id
    , is_user_logged_in
    , event
    , if(event = 'order_placed', true, false)                as order_placed
    , if(event = 'checkout_started', true, false)            as checkout_started
    , if(event = 'account_registration_viewed', true, false) as account_registration_viewed
    , dense_rank() over (partition by id order by index) as step_num -- to rank unique events in the sequence
from
    base
where rn = 1   -- filter on rank to select only unique events in the sequence
order by anonymous_id, event_date, step_num
)

, step_flow as (
select
      event_date
    , anonymous_id
    , platform
    , id                                as flow_id
    , is_user_logged_in
    , max(order_placed)                 as order_placed
    , max(checkout_started)             as checkout_started
    , max(account_registration_viewed)  as account_registration_viewed
    , max(step_num)                     as max_flow_steps
    , max(if(step_num = 1,event,NULL))  as step_1
    , max(if(step_num = 2,event,NULL))  as step_2
    , max(if(step_num = 3,event,NULL))  as step_3
    , max(if(step_num = 4,event,NULL))  as step_4
    , max(if(step_num = 5,event,NULL))  as step_5
    , max(if(step_num = 6,event,NULL))  as step_6
    , max(if(step_num = 7,event,NULL))  as step_7
    , max(if(step_num = 8,event,NULL))  as step_8
    , max(if(step_num = 9,event,NULL))  as step_9
    , max(if(step_num = 10,event,NULL)) as step_10

from event_rank
group by 1,2,3,4,5
)

select * from step_flow
-- where checkout_started is true
-- to avoid short paths without intent to checkout // in android checkout_started sometimes fires togethjer with checkout_viewed (after registration screen)
;;
  }

## Dimensions

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

  dimension: flow_id {
    type: string
    sql: ${TABLE}.flow_id;;
    # primary_key: yes
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: is_user_logged_in {
    type: yesno
    sql: ${TABLE}.is_user_logged_in ;;
  }

  dimension: account_registration_viewed {
    type: yesno
    sql: ${TABLE}.account_registration_viewed ;;
  }

  dimension: checkout_started {
    type: yesno
    sql: ${TABLE}.checkout_started ;;
    hidden: yes
  }

  dimension: order_placed {
    type: yesno
    sql: ${TABLE}.order_placed ;;
    # hidden: yes
  }

  dimension: max_flow_steps {
    type: number
    sql: ${TABLE}.max_flow_steps ;;
  }

  dimension: step_1 {
    type: string
    sql: ${TABLE}.step_1 ;;
  }

  dimension: step_2 {
    type: string
    sql: ${TABLE}.step_2 ;;
  }

  dimension: step_3 {
    type: string
    sql: ${TABLE}.step_3 ;;
  }

  dimension: step_4 {
    type: string
    sql: ${TABLE}.step_4 ;;
  }

  dimension: step_5 {
    type: string
    sql: ${TABLE}.step_5 ;;
  }

  dimension: step_6 {
    type: string
    sql: ${TABLE}.step_6 ;;
  }

  dimension: step_7 {
    type: string
    sql: ${TABLE}.step_7 ;;
  }

  dimension: step_8 {
    type: string
    sql: ${TABLE}.step_8 ;;
  }

  dimension: step_9 {
    type: string
    sql: ${TABLE}.step_9 ;;
  }

  dimension: step_10 {
    type: string
    sql: ${TABLE}.step_10 ;;
  }


## Measure

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      flow_id,
      anonymous_id,
      is_user_logged_in,
      checkout_started,
      account_registration_viewed,
      order_placed,
      platform,
      max_flow_steps,
      step_1,
      step_2,
      step_3,
      step_4,
      step_5,
      step_6,
      step_7,
      step_8,
      step_9,
      step_10
    ]
  }
}
