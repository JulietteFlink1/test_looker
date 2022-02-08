view: analysis_add_to_cart_rate {
    derived_table: {
      sql: with base as (
select id as event_id, event as event_name, anonymous_id , timestamp as event_timestamp, date(timestamp) as event_date, context_device_type as device_type, context_app_version as app_version
from `flink-data-prod.flink_android_production.tracks`
where {% condition filter_event_date %} date(_partitiontime) {% endcondition %}
and {% condition filter_event_date %} date(timestamp) {% endcondition %}
and event not LIKE "api%"
    and event not in("application_opened","app_opened","application_updated",'deep_link_opened', 'install_attributed', 'adjust_attributions')
      and not (LOWER(context_app_version) LIKE "%app-rating%"
           or LOWER(context_app_version) LIKE "%debug%"
           or LOWER(context_app_version) LIKE "%prerelease%"
           or LOWER(context_app_version) LIKE "%intercom%")
      and NOT (LOWER(context_app_name) = "flink-staging"
           or LOWER(context_app_name) = "flink-debug")
      and (LOWER(context_traits_email) != "qa@goflink.com"
           or context_traits_email is null)
      and (context_traits_hub_slug not IN('erp_spitzbergen', 'de_hub_test', 'fr_hub_test', 'nl_hub_test', 'at_hub_test', 'be_hub_test'
                                                           , 'de_qaa_test', 'fr_qaa_test', 'nl_qaa_test', 'at_qaa_test' , 'be_qaa_test'
                                        )
           or context_traits_hub_slug is null)
union all
select id as event_id, event as event_name, anonymous_id , timestamp as event_timestamp, date(timestamp) as event_date, context_device_type as device_type, context_app_version as app_version
from `flink-data-prod.flink_ios_production.tracks`
where {% condition filter_event_date %} date(_partitiontime) {% endcondition %}
and {% condition filter_event_date %} date(timestamp) {% endcondition %}
and event not LIKE "api%"
    and event not in("application_opened","app_opened","application_updated",'deep_link_opened', 'install_attributed', 'adjust_attributions')
      and not (LOWER(context_app_version) LIKE "%app-rating%"
           or LOWER(context_app_version) LIKE "%debug%"
           or LOWER(context_app_version) LIKE "%prerelease%"
           or LOWER(context_app_version) LIKE "%intercom%")
      and NOT (LOWER(context_app_name) = "flink-staging"
           or LOWER(context_app_name) = "flink-debug")
      and (LOWER(context_traits_email) != "qa@goflink.com"
           or context_traits_email is null)
      and (context_traits_hub_slug not IN('erp_spitzbergen', 'de_hub_test', 'fr_hub_test', 'nl_hub_test', 'at_hub_test', 'be_hub_test'
                                                           , 'de_qaa_test', 'fr_qaa_test', 'nl_qaa_test', 'at_qaa_test' , 'be_qaa_test'
                                        )
           or context_traits_hub_slug is null)

)
, min_add_to_cart_ts as (
-- get min timestamp for add_to_cart event per user
select event_id, event_date, anonymous_id, event_name, event_timestamp , device_type, app_version,
case when event_name = 'product_added_to_cart'
     then first_value(event_timestamp) over(partition by anonymous_id, event_date, event_name order by event_timestamp)
     end as add_to_cart_ts,
from base
group by 1,2,3,4,5,6,7
)

, ts_distributed as (
 -- assign min add-to-cart timestamp to each event per user per day
 select event_id, event_date, anonymous_id , event_name, event_timestamp, add_to_cart_ts, device_type, app_version,
 min (add_to_cart_ts)  over (partition by event_date, anonymous_id  order by add_to_cart_ts  RANGE BETWEEN CURRENT ROW and unbounded following) as add_to_cart_ts_distributed
 from min_add_to_cart_ts
)
, product_added_to_cart as (
-- get list_category for add-to-cart event
-- reason for this CTE and filtering data based on partition (reducing costs)
select id, anonymous_id, list_category
from `flink-data-prod.flink_android_production.product_added_to_cart`
where {% condition filter_event_date %} date(_partitiontime) {% endcondition %}
and {% condition filter_event_date %} date(timestamp) {% endcondition %}

union all
select id, anonymous_id, list_category
from `flink-data-prod.flink_ios_production.product_added_to_cart`
where {% condition filter_event_date %} date(_partitiontime) {% endcondition %}
and {% condition filter_event_date %} date(timestamp) {% endcondition %}
)

-- set flag for when users had any product in the cart, select only PDP and add-to-cart events
select event_id,
       event_date ,
       d.anonymous_id ,
       device_type,
       app_version,
       event_name,
       lead(event_name) over(partition by event_date, d.anonymous_id order by event_timestamp) as next_event_name,
       event_timestamp,
       cart.list_category,
       case when event_timestamp >= add_to_cart_ts_distributed
            then true else false
            end as user_has_items_in_cart
from ts_distributed d
left join product_added_to_cart cart on cart.id = event_id
# where event_name in ('product_added_to_cart','product_details_viewed')
              ;;
    }

  filter: filter_event_date {
    label: "Filter: Event Date"
    type: date
    datatype: date
  }

    ##################  DIMENSIONS  ##################

    dimension: event_uuid {
      primary_key: yes
      type: string
      sql: ${TABLE}.event_id ;;
      hidden: yes
    }
    dimension: anonymous_id {
    group_label: "User Dimensions"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
    dimension_group: event {
      group_label: "Date Dimensions"
      type: time
      datatype: timestamp
      timeframes: [
        date,
        day_of_week,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}.event_timestamp ;;
    }
    dimension: event_name {
      group_label: "Event Dimensions"
      description: "Name of the event"
      type: string
      sql: ${TABLE}.event_name ;;
    }
  dimension: next_event_name {
    group_label: "Event Dimensions"
    description: "Name of the subsequent event"
    type: string
    sql: ${TABLE}.next_event_name ;;
  }
    dimension: device_type {
      group_label: "Device Dimensions"
      description: "Type of the device: iOS or Android"
      type: string
      sql: ${TABLE}.device_type ;;
    }
    dimension: app_version {
      group_label: "Device Dimensions"
      description: "Version of the app released"
      type: string
      sql: ${TABLE}.app_version ;;
    }
    dimension: product_placement {
      group_label: "Event Dimensions"
      description: "Place where product was placed / shown wihtin the apps"
      type: string
      sql: ${TABLE}.list_category ;;
    }
    dimension: user_has_items_in_cart {
      group_label: "User Dimensions"
      description: "Boolean: true is add-to-cart event happened before other event"
      type: yesno
      hidden: no
      sql: ${TABLE}.user_has_items_in_cart  ;;
    }

    ##################  MEASURES  ##################

    measure: events {
      description: "Sum of all add-to-cart events."
      label: "# Events"
      type: count_distinct
      sql: ${event_uuid};;
    }
    measure: product_events {
      description: "Product events based on product_added_to_cart event"
      label: "#Product Events"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [event_name: "product_added_to_cart"]
    }
    measure: unique_users {
      description: "Sum of all add-to-cart events."
      label: "# Unique Users"
      type: count_distinct
      sql: ${anonymous_id} ;;
    }
    measure: unique_users_product_events {
      description: "Sum of all add-to-cart events."
      label: "# Unique Users on add-to-cart"
      type: count_distinct
      sql: ${anonymous_id} ;;
      filters: [event_name: "product_added_to_cart"]
   }
    measure: events_from_cart {
      group_label: "Add-to-Cart Events"
      description: "Sum of all add-to-cart events from cart."
      label: "#Events from Cart"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "cart", event_name: "product_added_to_cart"]
    }
    measure: events_from_last_bought {
      group_label: "Add-to-Cart Events"
      description: "Sum of all add-to-cart events from last bought."
      label: "#Events from Last Bought"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "last_bought", event_name: "product_added_to_cart"]
    }
    measure: events_from_favourites {
      group_label: "Add-to-Cart Events"
      description: "Sum of all add-to-cart events from favourites."
      label: "#Events from Favourites"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "favourites", event_name: "product_added_to_cart"]
    }
    measure: events_from_swimlane {
      group_label: "Add-to-Cart Events"
      description: "Sum of all add-to-cart events from swimlanes."
      label: "#Events from Swimlane"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "swimlane", event_name: "product_added_to_cart"]
    }
    measure: events_from_search {
      group_label: "Add-to-Cart Events"
      description: "Sum of all add-to-cart events from search."
      label: "#Events from Search"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "search", event_name: "product_added_to_cart"]
    }
    measure: events_from_category {
      group_label: "Add-to-Cart Events"
      description: "Sum of all add-to-cart events from category pages."
      label: "#Events from Category"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "category", event_name: "product_added_to_cart"]
    }
    measure: events_from_pdp {
      group_label: "Add-to-Cart Events"
      description: "Sum of all add-to-cart events."
      label: "#Events from PDP"
      type: count_distinct
      sql: ${event_uuid} ;;
      filters: [product_placement: "pdp", event_name: "product_added_to_cart"]
    }
    measure: avg_event_per_user {#
      description: "AVG amount of add-to-cart events per unique user"
      label: "AVG add-to-cart events per User"
      type: number
      sql: ${events} / ${unique_users} ;;
      value_format: "#.##"
    }

    ### Add-to-cart rate measure ###
    measure: add_to_cart_rate_cart  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from cart (#add-to-cart-from-Cart / #total_add-to-cart"
      label: "From Cart"
      type: number
      sql: ${events_from_cart} / ${product_events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_category  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from category (#add-to-cart-from-Category / #total_add-to-cart"
      label: "From Category"
      type: number
      sql: ${events_from_category} / ${product_events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_last_bought  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from last bought (#add-to-cart-from-Last_bought / #total_add-to-cart"
      label: "From Last-Bought"
      type: number
      sql: ${events_from_last_bought} / ${product_events};;
      value_format_name: percent_2
    }
      measure: add_to_cart_rate_favourites  {
        group_label: "Add-to-cart Rate (%)"
        description: "Add-to-cart rate from favourites (#add-to-cart-from-Favourites / #total_add-to-cart"
        label: "From Favourites"
        type: number
        sql: ${events_from_favourites} / ${product_events};;
        value_format_name: percent_2
    }
    measure: add_to_cart_rate_swimlane  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from cart (#add-to-cart-from-Swimlane / #total_add-to-cart"
      label: "From Swimlane"
      type: number
      sql: ${events_from_swimlane} / ${product_events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_search  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from cart (#add-to-cart-from-Search / #total_add-to-cart"
      label: "From Search"
      type: number
      sql: ${events_from_search} / ${product_events};;
      value_format_name: percent_2
    }
    measure: add_to_cart_rate_pdp  {
      group_label: "Add-to-cart Rate (%)"
      description: "Add-to-cart rate from PDP (#add-to-cart-from-PDP / #total_add-to-cart"
      label: "From PDP"
      type: number
      sql: ${events_from_pdp} / ${product_events};;
      value_format_name: percent_2
    }
  }
