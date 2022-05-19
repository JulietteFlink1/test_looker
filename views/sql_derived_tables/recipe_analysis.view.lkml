view: recipe_analysis {
  derived_table: {
    sql:
     with daily_recipes as (
select
    event_date
  , anonymous_id
  , platform
  , event_name
  , split(page_path,"/")[safe_offset(3)] as recipe_title
 from `flink-data-prod.curated.daily_events`
 where
  platform = 'web'
 and
  cast(event_timestamp as date) >= '2022-04-01'
 and
  event_name = 'pageview'
 and
  page_path like '%-0%'  -- to include only recipes with defined recipe id in url // tbc the volume
 and
  page_path like '%recipes/%' -- to exclude test traffic
 and
  page_path not like '%recipes/'  -- to exclude test traffic
 and
  page_path not like '%test%' -- to exclude test traffic
group by
   1,2,3,4,5
)

, daily_recipes_clean as (
  select
      event_date
    , anonymous_id
    , recipe_title
    , substr(split(right(recipe_title,8),"-")[safe_offset(1)],3) as recipe_id
    , left(split(right(recipe_title,8),"-")[safe_offset(1)],2) as country_recipe_id
    , case
        when
          left(split(right(recipe_title,8),"-")[safe_offset(1)],2) = '01' then 'DE'
        when
          left(split(right(recipe_title,8),"-")[safe_offset(1)],2) = '02' then 'NL'
        when
          left(split(right(recipe_title,8),"-")[safe_offset(1)],2) = '03' then 'FR'
        when
          left(split(right(recipe_title,8),"-")[safe_offset(1)],2) = '04' then 'AT'
        end
            as country_iso -- derived from recipe_id
from daily_recipes
where recipe_title <> 'recipes' -- to exclude test traffic
group by 1,2,3,4
)

, daily_events as (
select
    event_date
  , anonymous_id
  -- events on recipe LP
  , max(if(event_name = 'click' and  component_name = 'cta' and screen_name = 'recipes',true,false))                                             as entered_webshop_cart_cta_click
  , max(if(event_name = 'click' and component_name = 'order_ingredients' and screen_name = 'recipe',true,false))                                 as order_ingredients_click
  , max(if(event_name = 'click' and  component_name = 'recommendations' and component_content = 'recipe' and screen_name = 'recipe',true,false)) as recipe_recommendation_click
  , max(if(event_name = 'click' and component_name = 'recommendations' and component_content = 'product' and screen_name = 'recipe',true,false)) as product_recommendation_click
  , max(if(event_name = 'section_viewed' and component_name = 'address_book_modal' and screen_name = 'recipes',true,false))                      as address_book_modal_viewed
  , max(if(event_name = 'click' and component_name in( 'Allergene','Allergenen','Nährwertangaben pro Portion'
                                                    , 'Voedingswaarden per portie','Ontdek meer','Tags') and screen_name = 'recipe',true,false)) as recipe_details_click -- Allergene / Nährwertangaben pro Portion / Tags
  -- enetered webshop
  , max(if(page_path like '%/shop/%',true,false))                                                                                                as visited_webshop
  --  funnel events
  , max(if(event_name = 'product_added',true,false))                                                                                             as product_added_to_cart
  , max(if(event_name = 'cart_viewed',true,false))                                                                                               as cart_viewed
  , max(if(event_name = 'checkout_started',true,false))                                                                                          as checkout_started
  , max(if(event_name = 'order_completed',true,false))                                                                                           as order_completed

 from `flink-data-prod.curated.daily_events`
 where
   platform = 'web'
 and
  cast(event_timestamp as date) >= '2022-04-01'
 and
   anonymous_id in (select anonymous_id from daily_recipes_clean) -- only users coming from recipe lp
 and
   event_name in ('click'
                , 'section_viewed'
                , 'product_added'
                , 'cart_viewed'
                , 'checkout_started'
                , 'order_completed'
                )
group by
      1,2
)

, final as (
select
    daily_recipes_clean.event_date  as visit_date
  , daily_recipes_clean.anonymous_id as anonymous_id
  , recipe_mapping.recipe_name       as recipe_name
  , daily_recipes_clean.recipe_id    as recipe_id
  , daily_recipes_clean.country_iso  as country_iso
  , if(daily_recipes_clean.anonymous_id is not null,true,false) as recipe_page_visited
  , if(daily_events.anonymous_id is not null,true,false) as is_active_user -- if user is present in daily_events
  , daily_events.entered_webshop_cart_cta_click as entered_webshop_cart_cta_click
  , daily_events.recipe_recommendation_click as recipe_recommendation_click
  , daily_events.product_recommendation_click as product_recommendation_click
  , daily_events.recipe_details_click as recipe_details_click
  , daily_events.order_ingredients_click as order_ingredients_click
  , daily_events.address_book_modal_viewed as address_book_modal_viewed
  , daily_events.visited_webshop as visited_webshop
  , daily_events.product_added_to_cart as product_added_to_cart
  , daily_events.cart_viewed as cart_viewed
  , daily_events.checkout_started as checkout_started
  , daily_events.order_completed as order_completed
from
  daily_recipes_clean
 left join
  daily_events
 on daily_recipes_clean.anonymous_id = daily_events.anonymous_id
  and daily_recipes_clean.event_date = daily_events.event_date
 left join
  `flink-data-dev.sandbox_natalia.recipe_mapping` recipe_mapping
  on daily_recipes_clean.recipe_id = recipe_mapping.recipe_id
)

select * from final
;;
  }


  dimension_group: visit_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.visit_date AS DATE) ;;
    datatype: date
  }

  dimension: anonymous_id {
    hidden: yes
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }


  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: recipe_name {
    type: string
    sql: ${TABLE}.recipe_name ;;
  }

  dimension: recipe_id {
    type: string
    sql: ${TABLE}.recipe_id ;;
  }

  dimension: recipe_page_visited {
    type: yesno
    sql: ${TABLE}.recipe_page_visited ;;
  }

  dimension: is_active_user {
    type: yesno
    sql: ${TABLE}.is_active_user ;;
  }

  # Dimensions for recipe interactions

  dimension: entered_webshop_cart_cta_click {
    type: yesno
    sql: ${TABLE}.entered_webshop_cart_cta_click ;;
  }

  dimension: recipe_recommendation_click {
    type: yesno
    sql: ${TABLE}.recipe_recommendation_click ;;
  }

  dimension: product_recommendation_click {
    type: yesno
    sql: ${TABLE}.product_recommendation_click ;;
  }

  dimension: recipe_details_click {
    type: yesno
    sql: ${TABLE}.recipe_details_click ;;
  }

  dimension: order_ingredients_click {
    type: yesno
    sql: ${TABLE}.order_ingredients_click ;;
  }

  dimension: address_book_modal_viewed {
    type: yesno
    sql: ${TABLE}.address_book_modal_viewed ;;
  }

  dimension: visited_webshop {
    type: yesno
    sql: ${TABLE}.visited_webshop ;;
  }

  dimension: product_added_to_cart {
    type: yesno
    sql: ${TABLE}.product_added_to_cart ;;
  }

  dimension: cart_viewed {
    type: yesno
    sql: ${TABLE}.cart_viewed ;;
  }

  dimension: checkout_started {
    type: yesno
    sql: ${TABLE}.checkout_started ;;
  }

  dimension: order_completed {
    type: yesno
    sql: ${TABLE}.order_completed ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: user_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
  }

  measure: recipe_page_visited_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [recipe_page_visited: "yes"]
  }

  measure: order_ingredients_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [order_ingredients_click: "yes"]
  }

  measure: entered_webshop_cart_cta_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [entered_webshop_cart_cta_click: "yes"]
  }

  measure: recipe_recommendation_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [recipe_recommendation_click: "yes"]
  }

  measure: product_recommendation_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [product_recommendation_click: "yes"]
  }

  measure: recipe_details_click_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [recipe_details_click: "yes"]
  }

  measure: address_book_modal_viewed_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [address_book_modal_viewed: "yes"]
  }

  measure: visited_webshop_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [visited_webshop: "yes"]
  }

  measure: product_added_to_cart_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [product_added_to_cart: "yes"]
  }

  measure: cart_viewed_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [cart_viewed: "yes"]
  }

  measure: checkout_started_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [checkout_started: "yes"]
  }

  measure: order_completed_count {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [order_completed: "yes"]
  }




}
