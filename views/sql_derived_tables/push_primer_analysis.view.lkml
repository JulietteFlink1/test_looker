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
  , max(if(event_name='notification_request_viewed',true,false)) as notification_request_viewed
  , max(if(event_name='notification_request_succeeded',true,false)) as notification_request_succeeded
  , max(if(event_name='notification_request_postponed',true,false)) as notification_request_postponed
  , max(if(event_name='native_ui_prompt_shown',true,false)) as native_ui_prompt_shown
  , max(if(event_name='native_ui_response_received',true,false)) as native_ui_response_received
  , max(if(event_name='native_ui_prompt_shown',event_uuid,null)) as native_ui_prompt_shown_id
  , max(if(event_name='native_ui_response_received',event_uuid,null)) as native_ui_response_received_id
 from `flink-data-prod.curated.daily_events`
 where
  event_name in ( 'notification_request_viewed'
                    , 'notification_request_succeeded'
                    , 'notification_request_postponed'
                    , 'native_ui_prompt_shown'
                    , 'native_ui_response_received')
group by
    event_date
  , anonymous_id
  , platform
  , device_type
  , device_model
  , app_version
  , country_iso
)

, native_ui_prompt_shown as (
  select id
      , anonymous_id
      , event
      , cast(original_timestamp as date) as event_date
      , original_timestamp
      , component_name
      , screen_name
  from
    `flink-data-prod.flink_ios_production.native_ui_prompt_shown`
  where id in (select native_ui_prompt_shown_id from daily_events )
  and component_name = 'enable_notifications'
  and screen_name = 'home'
  group by 1,2,3,4,5,6,7
)

, native_ui_response_received as (
  select id
      , anonymous_id
      , event
      , cast(original_timestamp as date) as event_date
      , original_timestamp
      , component_name
      , component_content
      , screen_name
  from
    `flink-data-prod.flink_ios_production.native_ui_response_received`
  where id in (select native_ui_response_received_id from daily_events )
  and component_name = 'enable_notifications'
    and screen_name = 'home'
  group by 1,2,3,4,5,6,7,8
)
, final as (
select daily_events.* except(native_ui_prompt_shown_id,native_ui_response_received_id )
      , max(if(native_ui_prompt_shown.component_name='enable_notifications',true,false)) as enable_notifications_prompt_shown
      , max(if(native_ui_response_received.component_content='allow',true,false)) as allow_notifications_response_received
      , max(if(native_ui_response_received.component_content='deny',true,false)) as deny_notifications_response_received
from
  daily_events
  left join native_ui_prompt_shown
    on daily_events.native_ui_prompt_shown_id = native_ui_prompt_shown.id
  left join native_ui_response_received
    on daily_events.native_ui_response_received_id = native_ui_response_received.id
group by 1,2,3,4,5,6,7,8,9,10,11,12
)

select
       event_date
      , platform
      , country_iso
      , count(if(notification_request_viewed is true,anonymous_id,null))              as notification_request_viewed
      , count(if(notification_request_succeeded is true,anonymous_id,null))           as notification_request_succeeded
      , count(if(notification_request_postponed is true,anonymous_id,null))           as notification_request_postponed
      , count(if(enable_notifications_prompt_shown is true,anonymous_id,null))        as enable_notifications_prompt_shown
      , count(if(allow_notifications_response_received is true,anonymous_id,null))    as allow_notifications_response_received
      , count(if(deny_notifications_response_received is true,anonymous_id,null))     as deny_notifications_response_received
from final
group by 1,2,3;;
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

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  measure: notification_request_viewed {
    type: sum
    sql: ${TABLE}.notification_request_viewed ;;
  }

  measure: notification_request_succeeded {
    type: sum
    sql: ${TABLE}.notification_request_succeeded ;;
  }

  measure: notification_request_postponed {
    type: sum
    sql: ${TABLE}.notification_request_postponed ;;
  }

  measure: enable_notifications_prompt_shown {
    type: sum
    sql: ${TABLE}.enable_notifications_prompt_shown ;;
  }

  measure: allow_notifications_response_received {
    type: sum
    sql: ${TABLE}.allow_notifications_response_received ;;
  }

  measure: deny_notifications_response_received {
    type: sum
    sql: ${TABLE}.deny_notifications_response_received ;;
  }


}
