view: push_primer_analysis {
  derived_table: {
    sql:
with daily_events as (
select
    event_date
  , anonymous_id
  , platform
  , device_type
  , device_model
  , app_version
  , country_iso

  , max(if(event_name='notification_request_viewed',true,false))          as notification_request_viewed
  , max(if(event_name='notification_request_succeeded',true,false))       as notification_request_succeeded
  , max(if(event_name='notification_request_postponed',true,false))       as notification_request_postponed

  , max(if(event_name='native_ui_prompt_shown'
            and component_name = 'enable_notifications'
            and screen_name='home',true,false))     as native_ui_prompt_shown_home
  , max(if(component_name='enable_notifications'
            and component_content = 'allow'
            and screen_name='home',true,false))     as native_ui_response_allow_home
  , max(if(component_name='enable_notifications'
            and component_content = 'deny'
            and screen_name='home',true,false))     as native_ui_response_deny_home

  , max(if(event_name='native_ui_prompt_shown'
            and component_name = 'enable_notifications'
            and screen_name='order_tracking',true,false))     as native_ui_prompt_shown_order_tracking
  , max(if(component_name='enable_notifications'
            and component_content = 'allow'
            and screen_name='order_tracking',true,false))     as native_ui_response_allow_order_tracking
  , max(if(component_name='enable_notifications'
            and component_content = 'deny'
            and screen_name='order_tracking',true,false))     as native_ui_response_deny_order_tracking

  , max(if(event_name='order_placed',true,false))                           as order_placed

 from `flink-data-prod.curated.daily_events`
 where
  platform in ('ios','android')
  and (
    event_name = 'notification_request_viewed'
  or
    event_name = 'notification_request_succeeded'
  or
    event_name = 'notification_request_postponed'
  or
    (event_name = 'native_ui_prompt_shown' and component_name = 'enable_notifications' and screen_name ='home')
  or
    (event_name = 'native_ui_response_received' and component_name = 'enable_notifications' and screen_name ='home')
  or
    (event_name = 'native_ui_prompt_shown' and component_name = 'enable_notifications' and screen_name ='order_tracking')
or
    (event_name = 'native_ui_response_received' and component_name = 'enable_notifications' and screen_name ='order_tracking')
  or
  event_name = 'order_placed'
  )
group by
    event_date
  , anonymous_id
  , platform
  , device_type
  , device_model
  , app_version
  , country_iso
)
select *
from  daily_events

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

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: notification_request_viewed {
    type: yesno
    sql: ${TABLE}.notification_request_viewed ;;
  }

  dimension: notification_request_succeeded {
    type: yesno
    sql: ${TABLE}.notification_request_succeeded ;;
  }

  dimension: notification_request_postponed {
    type: yesno
    sql: ${TABLE}.notification_request_postponed ;;
  }

  dimension: native_ui_prompt_shown_home {
    type: yesno
    sql: ${TABLE}.native_ui_prompt_shown_home ;;
  }

  dimension: native_ui_response_allow_home {
    type: yesno
    sql: ${TABLE}.native_ui_response_allow_home ;;
  }

  dimension: native_ui_response_deny_home {
    type: yesno
    sql: ${TABLE}.native_ui_response_deny_home ;;
  }

  dimension: allow_notifications_response_received {
    type: yesno
    sql: ${TABLE}.allow_notifications_response_received ;;
  }

  dimension: native_ui_prompt_shown_order_tracking {
    type: yesno
    sql: ${TABLE}.native_ui_prompt_shown_order_tracking ;;
  }

  dimension: native_ui_response_allow_order_tracking {
    type: yesno
    sql: ${TABLE}.native_ui_response_allow_order_tracking ;;
  }

  dimension: native_ui_response_deny_order_tracking {
    type: yesno
    sql: ${TABLE}.native_ui_response_deny_order_tracking ;;
  }

  dimension: order_placed {
    type: yesno
    sql: ${TABLE}.order_placed ;;
  }


  ############ Measures   ############

  measure: count_users {
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }

  measure: users_with_notification_request_viewed {
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [notification_request_viewed: "yes"]
  }

  measure: users_with_notification_request_succeeded{
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [notification_request_succeeded: "yes"]
  }

  measure: users_with_notification_request_postponed{
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [notification_request_postponed: "yes"]
  }

  measure: users_with_native_ui_prompt_shown_home{
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [native_ui_prompt_shown_home: "yes"]
  }

  measure: users_with_native_ui_response_allow_home{
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [native_ui_response_allow_home: "yes"]
  }

  measure: users_with_native_ui_response_deny_home{
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [native_ui_response_deny_home: "yes"]
  }

  measure: users_with_order_placed{
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [order_placed: "yes"]
  }

  measure: users_with_native_ui_prompt_shown_order_tracking{
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [native_ui_prompt_shown_order_tracking: "yes"]
  }

  measure: users_with_native_ui_response_allow_order_tracking{
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [native_ui_response_allow_order_tracking: "yes"]
  }

  measure: users_with_native_ui_response_deny_order_tracking{
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [native_ui_response_deny_order_tracking: "yes"]
  }



}
