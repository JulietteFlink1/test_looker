view: discovery_flow {
    derived_table: {
      persist_for: "4 hour"
      sql: with
base as (
    select
      event_uuid,
      anonymous_id,
      event_name,
      platform,
      country_iso,
      event_date,
      received_at,
      event_timestamp,
    case
        when event_name="home_viewed" or page_path like '%shop/' then "home"
        when event_name in ("product_details_viewed", "product_clicked") then "pdp"
        when event_name in ("product_added_to_cart", "product_added") then "product_added"
        when event_name in ("product_removed_from_cart", "product_removed") then "product_removed"
        when event_name="category_selected" then "category_selection"
        when event_name="product_search_executed" then "search_executed"
        when event_name="product_search_viewed" then "search_viewed"
        when event_name="cart_viewed"then "cart"
        when event_name='checkout_viewed' or page_path like '%checkout%' then "checkout"
        when event_name="address_confirmed" then "address_conf"
        when event_name in ("app_opened","web_opened") then "app_web_opened"
        else "other"
        end as renamed_event
    from `flink-data-prod.curated.daily_events`
    where {% condition filter_event_date %} date(event_timestamp) {% endcondition %}
    -- take only events which could contribute to add_to_cart events
    and event_name in ("app_opened","web_opened","address_confirmed","home_viewed", "product_details_viewed", "product_clicked","product_added_to_cart","product_added",
                   "product_removed_from_cart","product_removed","category_selected","product_search_executed","product_search_viewed","cart_viewed","checkout_viewed")
  )

, atc_flag as (
    select *,
      case when event_name in ('product_added_to_cart','product_added') then event_uuid else null end as is_atc
    from base
)

, flow as (
    select
      renamed_event,
      anonymous_id,
      country_iso,
      platform,
      event_date,
      received_at,
      event_timestamp,
      last_value(is_atc ignore nulls) over (partition by anonymous_id
          order by event_timestamp desc rows between unbounded preceding and current row ) as flow_id,
      lag(renamed_event) over(partition by anonymous_id order by event_timestamp) as prev_event
    from atc_flag
  )

, steps as (
    select *, first_value(flow_step) over (partition by flow_id order by flow_step desc) AS max_steps_current_flow
    from (
          select *, row_number() over(partition by flow_id) as flow_step
          from flow
          where renamed_event != prev_event
      )
  )

, final as (
    select
      flow_id,
      max(max_steps_current_flow) as max_steps_current_flow,
      max(platform) as platform,
      max(country_iso) as country_iso,
      max(event_date) as event_date,
      max(date(received_at)) as received_at_date,
      max(if(flow_step = 1, renamed_event, null)) AS step1,
      max(if(flow_step = 2, renamed_event, null)) AS step2,
      max(if(flow_step = 3, renamed_event, null)) AS step3,
      max(if(flow_step = 4, renamed_event, null)) AS step4,
      max(if(flow_step = 5, renamed_event, null)) AS step5,
      max(if(flow_step = 6, renamed_event, null)) AS step6,
      max(if(flow_step = 7, renamed_event, null)) AS step7,
      max(if(flow_step = 8, renamed_event, null)) AS step8
    from steps
    where flow_id is not null -- remove flow which did not have add-to-cart events
    group by flow_id
)

select *
from final
        ;;
    }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  filter: filter_event_date {
    label: "Filter: Event Date"
    type: date
    datatype: date
    }
    ### IDs ###

    dimension: event_uuid {
      type: string
      sql: ${TABLE}.event_uuid ;;
    }
    dimension: flow_id {
      type: string
      sql: ${TABLE}.flow_id ;;
    }
    dimension: anonymous_id {
      type: string
      sql: ${TABLE}.anonymous_id ;;
    }

    ### Dates ###

    dimension_group: event {
      group_label: "Date / Timestamp"
      label: "Event"
      description: "Timestamp of when an event happened"
      type: time
      timeframes: [
        date,
        week,
        quarter
      ]
      sql: ${TABLE}.event_date ;;
      datatype: date
  }
    dimension_group: received_at_date {
      hidden: yes
      type: time
      timeframes: [
        date
      ]
      sql: ${TABLE}.received_at_date ;;
      datatype: date
    }

    ### Device & Location Dimensions
    dimension: country_iso {
      type: string
      sql: ${TABLE}.country_iso ;;
    }
    dimension: platform {
      type: string
      sql: ${TABLE}.platform ;;
    }
    dimension: max_steps_current_flow {
      type: number
      sql: ${TABLE}.max_steps_current_flow ;;
    }
    dimension: step1 {
      type: string
      sql: ${TABLE}.step1 ;;
    }
    dimension: step2 {
      type: string
      sql: ${TABLE}.step2 ;;
    }
    dimension: step3 {
      type: string
      sql: ${TABLE}.step3 ;;
    }
    dimension: step4 {
      type: string
      sql: ${TABLE}.step4 ;;
    }
    dimension: step5 {
      type: string
      sql: ${TABLE}.step5 ;;
    }
    dimension: step6 {
      type: string
      sql: ${TABLE}.step6 ;;
    }
    dimension: step7 {
      type: string
      sql: ${TABLE}.step7 ;;
    }
    dimension: step8 {
      type: string
      sql: ${TABLE}.step8 ;;
    }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

    set: detail {
      fields: [
        flow_id,
        event_date,
        anonymous_id,
        max_steps_current_flow,
        step1,
        step2,
        step3,
        step4,
        step5,
        step6,
        step7,
        step8
      ]
    }
  }
