view: marketingbanners_mobile_events_displayed_hours {
  derived_table: {
    sql: with
      user_hub_data as ( -- get all address_confirmed_view with hub info per user
          select
                  anonymous_id
                  , 'Android' as where_shown
                  , split(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(hub_code)),':')[OFFSET(1)] as hub_id
          from
              `flink-backend.flink_android_production.address_confirmed_view`

          union all

          select
                  anonymous_id
                  , 'iOS' as where_shown
                  , split(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(hub_code)),':')[OFFSET(1)] as hub_id
          from
              `flink-backend.flink_ios_production.address_confirmed_view`
      ),

      hub_data as ( -- translate the hub-id into hub-code
          select
              usr_hub.anonymous_id
            , usr_hub.where_shown
            , max(hub.slug)   as hub_code
          from
              user_hub_data                                              as usr_hub
          left join `flink-data-prod.saleor_prod_global.warehouse_warehouse` as hub
             on usr_hub.hub_id = hub.id
          group by 1,2
      ),

      android_data as ( -- get banner data for android, add hub info
          SELECT
              'Android' as where_shown
            , base.banner_position
            , base.timestamp as time_banner_viewed
            , base.banner_id
            , ifnull(hub.hub_code,'na') as hub
          FROM
            `flink-backend.flink_android_production.marketing_banner_viewed_view` as base
          LEFT JOIN
              hub_data                                                            as hub
                    on hub.anonymous_id = base.anonymous_id
                   and hub.where_shown = 'Android'
          group by
              where_shown, banner_position ,time_banner_viewed, banner_id, hub
          order by
              banner_position, time_banner_viewed
      ),
      ios_data as ( -- get banner data for ios - add hub data
          SELECT
              'iOS' as where_shown
            , banner_position
            , timestamp        as time_banner_viewed
            , banner_id
            , ifnull(hub.hub_code,'na') as hub
          FROM
            `flink-backend.flink_ios_production.marketing_banner_viewed_view` as base
          LEFT JOIN
            hub_data                                                          as hub
                  on hub.anonymous_id = base.anonymous_id
                 and hub.where_shown = 'iOS'
          group by
              where_shown, banner_position ,time_banner_viewed, banner_id, hub
          order by
              banner_position, time_banner_viewed
      ),

      full_data as ( -- combine the banner data
          (select * from android_data)
          union all
          (select * from ios_data)
      ),

      session_logic as ( -- define the start and end time of a banner shown per OS, hub and banner position
          select *,
      /*        case when banner_id != lag(banner_id, 1) over (partition by where_shown, hub, banner_position order by time_banner_viewed )
                      or lag(banner_id, 1) over (partition by where_shown, hub, banner_position order by time_banner_viewed ) is null
                      then time_banner_viewed
              end as start_session,

              case when banner_id != lead(banner_id, 1) over (partition by where_shown, hub, banner_position order by time_banner_viewed )
                      then time_banner_viewed
              end as end_session,*/

              case when banner_id != lag(banner_id, 1) over (partition by where_shown, hub, banner_position order by time_banner_viewed )
                      or lag(banner_id, 1) over (partition by where_shown, hub, banner_position order by time_banner_viewed ) is null
                      --then 'works'--MD5(concat(where_shown, banner_position,cast(time_banner_viewed as string), banner_id, hub))
                     then MD5(concat(where_shown, banner_position, cast(time_banner_viewed as string), banner_id, hub))
                      --else 'error'
              end as session_id,

          from full_data
          order by
              where_shown, hub, banner_position, time_banner_viewed
      ),

      session_final as ( -- give every row of a session a session id
          select *
                , sum(case when session_id is not null then 1 else 0 end) over (partition by where_shown, hub, banner_position order by time_banner_viewed) as sessionID
                -- IFF(session_id is not null, session_id, ) as as session
          from session_logic
      )
      select
          where_shown
        , hub
        , banner_position
        , banner_id
        , sessionID
        , min(time_banner_viewed) as start_date
        , max(time_banner_viewed) as end_date
        , date_diff(max(time_banner_viewed), min(time_banner_viewed), minute) as min_displayed
      from session_final
      group by
        where_shown, hub, banner_position, banner_id, sessionID
      having min_displayed > 0 -- remove odd events
      order by
        where_shown, hub, banner_id, banner_position, sessionID
       ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql:${TABLE}.sessionID ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  dimension: where_shown {
    label: "OS"
    description: "OS of the mobile device - either Android or iOS"
    type: string
    sql: ${TABLE}.where_shown ;;
  }

  dimension: hub {
    label: "Hub Code"
    description: "The hub code"
    type: string
    sql: ${TABLE}.hub ;;
  }

  dimension: banner_position {
    label: "Banner Position"
    description: "The position of a banner within the app - position 1 is shown initially to the user"
    type: number
    sql: ${TABLE}.banner_position ;;
  }

  dimension: banner_id {
    label: "Banner ID"
    description: "The identifier of a specific banner"
    type: string
    sql: ${TABLE}.banner_id ;;
  }

  dimension: session_id {
    type: number
    sql: ${TABLE}.sessionID ;;
    hidden: yes
  }

  dimension_group: start_date {
    label: "Airing Start Date"
    description: "The date, when the banner was initially shown"
    type: time
    sql: ${TABLE}.start_date ;;
  }

  dimension_group: end_date {
    label: "Airing End Date"
    description: "The date, when the banner was removed"
    type: time
    sql: ${TABLE}.end_date ;;
  }

  dimension: min_displayed {
    type: number
    sql: ${TABLE}.min_displayed ;;
    hidden: yes
  }

  measure: total_minutes_displayed {
    label: "Total Minutes Displayed"
    description: "The time-difference in minutes between the start end end date of the airing"
    type: sum
    sql:${min_displayed}  ;;
    value_format_name: decimal_0
  }

  measure: max_banner_position {
    label: "Banner Position"
    description: "The position of a banner within the app - position 1 is shown initially to the user"
    type: max
    sql: ${banner_position} ;;
    value_format_name: decimal_0
  }

  set: detail {
    fields: [
      where_shown,
      hub,
      banner_position,
      banner_id,
      session_id,
      start_date_time,
      end_date_time,
      min_displayed
    ]
  }
}
