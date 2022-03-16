view: forget_password_analysis {
  derived_table: {
    persist_for: "24 hours"
  sql:
with ios as (
  select *, if((password_forgotten_viewed = 0 and password_reset_requested = 0 and account_login_succeeded = 1 and checkout_viewed = 1),0,1) as login_filter  from (
select
      date(tracks.timestamp)                                            as event_date
    , tracks.anonymous_id                                               as anonymous_id
    , upper(left(tracks.context_traits_hub_slug,2))                     as country_iso
    , tracks.context_traits_user_logged_in                              as user_logged_in
    , tracks.context_app_version                                        as app_version
    , 'ios'                                                             as platform
    , max(if(tracks.event = 'account_login_viewed', 1,0))               as account_login_viewed
    , max(if(tracks.event = 'password_forgotten_viewed',1,0))           as password_forgotten_viewed
    , max(if(tracks.event = 'password_forgotten_clicked',1,0))          as password_reset_requested
    , max(if(login.event = 'account_login_succeeded',1,0))              as account_login_succeeded
    , max(if(checkout.event = 'checkout_viewed',1,0))                   as checkout_viewed
 from
   `flink-data-prod.flink_ios_production.tracks` tracks
 left join
   `flink-data-prod.flink_ios_production.account_login_succeeded` login
   on tracks.anonymous_id = login.anonymous_id
    and date(login.timestamp) >= date(tracks.timestamp) -- to assure the login happened after requesting password reset
 left join
   `flink-data-prod.flink_ios_production.checkout_viewed` checkout
   on login.anonymous_id = checkout.anonymous_id
    and date(login.timestamp) = date(checkout.timestamp) -- to assure the checkout happened after login
where date(tracks._PARTITIONTIME) >= "2022-02-07" and  date(login._PARTITIONTIME) >= "2022-02-07" and date(checkout._PARTITIONTIME) >= "2022-02-07"
and tracks.event in ('account_login_viewed','password_forgotten_viewed','password_forgotten_clicked')
and tracks.context_app_version >= '2.19.0'
group by 1,2,3,4,5
)t
where account_login_viewed = 1
)

, android as (
  select *, if((password_forgotten_viewed = 0 and password_reset_requested = 0 and account_login_succeeded = 1),0,1) as login_filter  from (
select
      date(tracks.timestamp)                                            as event_date
    , tracks.anonymous_id                                               as anonymous_id
    , upper(left(tracks.context_traits_hub_slug,2))                     as country_iso
    , tracks.context_traits_user_logged_in                              as user_logged_in
    , tracks.context_app_version                                        as app_version
    , 'android'                                                         as platform
    , max(if(tracks.event = 'account_login_viewed', 1,0))               as account_login_viewed
    , max(if(screen_viewed.screen_name = 'reset_password'   ,1,0))      as password_forgotten_viewed
    , max(if(click.component_name = 'send_instructions'
        and click.screen_name = 'reset_password'   ,1,0))               as password_reset_requested
    , max(if(tracks.event = 'account_login_succeeded',1,0))             as account_login_succeeded
    , max(if(checkout.event = 'checkout_viewed',1,0))                   as checkout_viewed
 from
 `flink-data-prod.flink_android_production.account_login_viewed` tracks
 left join
  `flink-data-prod.flink_android.screen_viewed` screen_viewed
  on tracks.anonymous_id = screen_viewed.anonymous_id
    and date(tracks.timestamp) = date(screen_viewed.timestamp)
 left join
  `flink-data-prod.flink_android.click` click
  on screen_viewed.anonymous_id = click.anonymous_id
    and date(screen_viewed.timestamp) = date(click.timestamp)
 left join
  `flink-data-prod.flink_android_production.account_login_succeeded` login
  on tracks.anonymous_id = login.anonymous_id
    and date(login.timestamp) >= date(tracks.timestamp) -- to assure the login happened after requesting password reset
 left join
   `flink-data-prod.flink_android_production.checkout_viewed` checkout
   on login.anonymous_id = checkout.anonymous_id
    and date(login.timestamp) = date(checkout.timestamp) -- to assure the checkout happened after login
where date(tracks._PARTITIONTIME)  >= "2022-02-07" --and date(login._PARTITIONTIME) >= "2022-02-07" and date(checkout._PARTITIONTIME) >= "2022-02-07"
and tracks.context_app_version >= '2.19.0'
group by 1,2,3,4,5
)t
where account_login_viewed = 1
)


, web as (
  select *, if((password_forgotten_viewed = 0 and password_reset_requested = 0 and account_login_succeeded = 1),0,1) as login_filter  from (
select
      date(pages.timestamp)                                               as event_date
    , pages.anonymous_id                                                  as anonymous_id
    , pages.context_traits_country_code                                   as country_iso
    , pages.context_traits_user_logged_in                                 as user_logged_in
    , cast(null as string)                                                as app_version
    , 'web'                                                               as platform
    , max(if(pages.path like '%/login%',1,0))                             as account_login_viewed
    , max(if(tracks.context_page_path like '%/forgot-password%',1,0))     as password_forgotten_viewed
    , max(if(tracks.event = 'password_reset_request_submitted',1,0))      as password_reset_requested
    , max(if(login.event = 'account_login_succeeded',1,0))                as account_login_succeeded
    , max(if(pages.path like '%/checkout%',1,0))                          as checkout_viewed
 from
  `flink-data-prod.flink_website_production.pages` pages
 left join
  `flink-data-prod.flink_website_production.tracks`  tracks
  on pages.anonymous_id = tracks.anonymous_id
    and date(pages.timestamp) = date(tracks.timestamp)
 left join
  `flink-data-prod.flink_website_production.account_login_succeeded` login
  on tracks.anonymous_id = login.anonymous_id
    and date(login.timestamp) >= date(tracks.timestamp) -- to assure the login happened after requesting password reset
where
  date(pages._PARTITIONTIME) >= "2022-02-07"
and
  (pages.path like '%/login%' or pages.path like '%/forgot-password%' or pages.path like '%/checkout%' )
or
  tracks.event = 'password_reset_request_submitted'
group by 1,2,3,4,5
)t
where account_login_viewed = 1
)


, dsunion as (
select * except(login_filter) from ios
--  where login_filter = 1
-- login_filter = 1 filters out all users who landed on login and successfully logged in without interacting with forget password on that day
-- if a user requested password reset on day 1 but changed uit and logged in successful in day 2, trhe entire interaction will be attributed to day 1 (day of reset request)
union all
select * except(login_filter) from android
--  where login_filter = 1
union all
select * except(login_filter) from web
--  where login_filter = 1
)


select
    event_date
  , anonymous_id
  , country_iso
  , app_version
  , platform
  , account_login_viewed
  , password_forgotten_viewed
  , password_reset_requested
  , account_login_succeeded
  , checkout_viewed
 from dsunion
group by 1,2,3,4,5,6,7,8,9,10
 ;;
}


  view_label: "* Forget Password *"
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      platform,
      country_iso,
      app_version,
      event_date_date
    ]
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

  dimension: platform {
    description: "Platform"
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: app_version {
    description: "App version"
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: country_iso {
    description: "Country"
    type: string
    sql: ${TABLE}.country_hub ;;
  }

  dimension: anonymous_id {
    description: "anonymous_id"
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.anonymous_id ;;
  }

###### Dimensions for measure filters

  dimension: account_login_viewed {
    description: "account_login_viewed"
    type: number
    hidden: yes
    sql: ${TABLE}.account_login_viewed ;;
  }

  dimension: password_forgotten_viewed {
    description: "password_forgotten_viewed"
    type: number
    hidden: yes
    sql: ${TABLE}.password_forgotten_viewed ;;
  }

  dimension: password_reset_requested {
    description: "password_reset_requested"
    type: number
    hidden: yes
    sql: ${TABLE}.password_reset_requested ;;
  }

  dimension: account_login_succeeded {
    description: "account_login_succeeded"
    type: number
    hidden: yes
    sql: ${TABLE}.account_login_succeeded ;;
  }

  dimension: checkout_viewed {
    description: "checkout_viewed"
    type: number
    hidden: yes
    sql: ${TABLE}.checkout_viewed ;;
  }

###### Measures

  # measure: count_users {
  #   description: "# All Users"
  #   type: count_distinct
  #   sql: ${TABLE}.anonymous_id ;;
  # }

  measure: count_users_login_viewed {
    description: "# Users | Login Viewed"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [account_login_viewed: "1"]
  }

  measure: count_users_password_forgotten_viewed {
    description: "# Users | Password Forgotten Viewed"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [account_login_viewed: "1", password_forgotten_viewed: "1"]
  }

  measure: count_users_password_reset_requested {
    description: "# Users | Password Requested"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [account_login_viewed: "1", password_forgotten_viewed: "1",password_reset_requested: "1" ]
  }

  measure: count_users_login_succeded {
    description: "# Users | Login Succeeded"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [account_login_viewed: "1", password_forgotten_viewed: "1",password_reset_requested: "1" ,
     account_login_succeeded: "1" ]
  }

  measure: count_users_checkout_viewed {
    description: "# Users | Checkout Viewed"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [account_login_viewed: "1", password_forgotten_viewed: "1",password_reset_requested: "1" ,
      account_login_succeeded: "1" , checkout_viewed: "1" ]
  }








}
