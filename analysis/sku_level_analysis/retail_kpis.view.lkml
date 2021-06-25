view: retail_kpis {
  derived_table: {
    sql: with
    looker_base as (
        select
            hubs.country_iso                           as country_iso
          , lower(hubs.hub_code)                       as hub_code
          , hubs.city                                  as city
          , hubs.hub_name                              as hub_name
          , product_category.name                      as sub_category_name
          , parent_category.name                       as category_name
          , product_product.name                       as product_name
          , case
            when length(order_orderline.product_sku) = 7
                then concat('1', order_orderline.product_sku)
                else order_orderline.product_sku
            end                                        as sku
          , date(order_order.created, 'Europe/Berlin') as order_date
          , order_order.id                             as order_id
            -- AGGREGATES
          , sum(order_orderline.quantity_fulfilled)    as sku_quantity
          , sum(order_orderline.unit_price_net_amount) as sku_unit_price
          , coalesce(sum(order_orderline.quantity_fulfilled * order_orderline.unit_price_net_amount),
                     0)                                as sum_item_price_net
        from
            flink-backend.saleor_db_global.order_order
                                                               as order_order
            left join flink-backend.saleor_db_global.order_orderline
                                                               as order_orderline
                      on order_orderline.country_iso = order_order.country_iso and
                         order_orderline.order_id = order_order.id
            left join flink-backend.gsheet_store_metadata.hubs as hubs
                      on order_order.country_iso = hubs.country_iso and
                         (case
                          when json_extract_scalar(order_order.metadata, '$.warehouse') in
                               ('hamburg-oellkersallee', 'hamburg-oelkersallee')
                              then 'de_ham_alto'
                          when json_extract_scalar(order_order.metadata, '$.warehouse') = 'münchen-leopoldstraße'
                              then 'de_muc_schw'
                              else json_extract_scalar(order_order.metadata, '$.warehouse')
                          end) = (lower(hubs.hub_code))
            left join flink-backend.saleor_db_global.product_productvariant
                                                               as product_productvariant
                      on order_orderline.country_iso = product_productvariant.country_iso and
                         (case
                          when length(order_orderline.product_sku) = 7
                              then concat('1', order_orderline.product_sku)
                              else order_orderline.product_sku
                          end) = product_productvariant.sku
            left join flink-backend.saleor_db_global.product_product
                                                               as product_product
                      on product_productvariant.country_iso = product_product.country_iso and
                         product_productvariant.product_id = product_product.id
            left join flink-backend.saleor_db_global.product_category
                                                               as product_category
                      on product_category.country_iso = product_product.country_iso and
                         product_category.id = product_product.category_id
            left join flink-backend.saleor_db_global.product_category
                                                               as parent_category
                      on product_category.country_iso = parent_category.country_iso and
                         product_category.parent_id = parent_category.id
        where
                (order_order.created) >=
                (timestamp(format_timestamp('%F %H:%M:%E*S', timestamp('2021-01-25 00:00:00')), 'Europe/Berlin'))
          and   ((not (order_order.user_email like '%goflink%' or order_order.user_email like '%pickery%' or
                       lower(order_order.user_email) in
                       ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
                        'alenaschneck@gmx.de',
                        'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com', 'fabian.hardenberg@gmail.com',
                        'benjamin.zagel@gmail.com')) or
                  (order_order.user_email like '%goflink%' or order_order.user_email like '%pickery%' or
                   lower(order_order.user_email) in
                   ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
                    'alenaschneck@gmx.de',
                    'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com', 'fabian.hardenberg@gmail.com',
                    'benjamin.zagel@gmail.com')) is null) and
                 (order_order.status in ('fulfilled', 'partially fulfilled')))
          and   (((upper((order_order.country_iso)) like upper('%') or ((order_order.country_iso) is null))) and
                 (((upper((hubs.city)) like upper('%') or ((hubs.city) is null))) and (case
                                                                                       when (85.0) = 28
                                                                                           then
                                                                                               (format_timestamp('%F',
                                                                                                                 timestamp_trunc(order_order.created, week(monday), 'Europe/Berlin'),
                                                                                                                 'Europe/Berlin')) <
                                                                                               (format_timestamp('%F',
                                                                                                                 timestamp_trunc(current_timestamp, week(monday), 'Europe/Berlin'),
                                                                                                                 'Europe/Berlin'))
                                                                                           else 1 = 1
                                                                                       end)))
        group by
            1
          , 2
          , 3
          , 4
          , 5
          , 6
          , 7
          , 8
          , 9
          , 10
        order by
            10 desc
    )

  , looker_base_clean as (
    select
        country_iso
      , hub_code
      , city
      , hub_name
      , sub_category_name
      , category_name
      , product_name
      , sku
      , order_date
      , case
        when order_date between date_add(current_date(), interval -7 day) and date_add(current_date(), interval -1 day)
            then 'current'
        when order_date between date_add(current_date(), interval -7 * 6 day) and date_add(current_date(), interval -(7 * 5 + 1) day)
            then 'previous'
            else 'undefined'
        end as cohorts
      , order_id
      , sku_quantity
      , sku_unit_price
      , sum_item_price_net
    from looker_base
    -- where placeholder LOOKER FILTER
           WHERE {% condition order_date_filter %} cast(looker_base.order_date as timestamp) {% endcondition %} and
                 {% condition hub_code_filter %} looker_base.hub_code {% endcondition %} and
                 {% condition hub_name_filter %} looker_base.hub_name {% endcondition %} and
                 {% condition city_filter %} looker_base.city {% endcondition %} and
                 {% condition country_iso_filter %} looker_base.country_iso {% endcondition %}

)


  , order_kpis as (
    -- om the order-level, calculates the number of items and basket value
    select
        order_id
      , sum(sku_quantity)       as number_items
      , count(sku)              as number_skus
      , sum(sum_item_price_net) as net_order_value
    from looker_base_clean
    group by
        1
)
  , looker_base_enriched as (
    -- data still on order level
    -- adds basket information to orders
    select
        lb.sku                as sku
      , lb.order_id           as order_id
      , lb.product_name       as product_name
      , lb.order_date         as order_date
      , lb.cohorts
      , lb.category_name      as category_name
      , lb.sub_category_name  as sub_category_name
      , lb.hub_code           as hub_code
      , lb.hub_name           as hub_name
      , lb.city               as city
      , lb.country_iso        as country_iso
      , lb.sum_item_price_net as sum_item_price_net
      , lb.sku_quantity       as sku_quantity
      , lb.sku_unit_price     as sku_unit_price
      , o.number_skus         as number_skus
      , o.number_items        as number_items
      , o.net_order_value     as net_order_value

        --, SUM(lb.sum_item_price_net) over (partition by sub_category_name) as sum_item_price_net_subcat
        -- , count(distinct lb.hub_code) over (partition by sub_category_name) as average_hubs_subcat
    from
        looker_base_clean    as lb
        left join order_kpis as o
                  on lb.order_id = o.order_id
)
  , aggregations as (
    select
        sku
      , product_name
      , order_date
      , date_trunc(order_date, week)                                        as order_week
      , category_name
      , sub_category_name
        -- measures
      , sum(sum_item_price_net)                                             as sum_item_price_net
      , sum(if(cohorts = 'current', sum_item_price_net, 0))                 as sum_item_price_net_current
      , sum(if(cohorts = 'previous', sum_item_price_net, 0))                as sum_item_price_net_previous
      , count(distinct hub_code)                                            as distinct_hub_codes
      , count(distinct if(cohorts = 'current', hub_code, null))             as distinct_hub_codes_current
      , count(distinct if(cohorts = 'previous', hub_code, null))            as distinct_hub_codes_previous
      , sum(sum_item_price_net) / nullif(count(distinct hub_code), 0)       as equalized_revenue
      , sum(if(cohorts = 'current', sum_item_price_net, 0)) /
        nullif(count(distinct if(cohorts = 'current', hub_code, null)), 0)  as equalized_revenue_current
      , sum(if(cohorts = 'previous', sum_item_price_net, 0)) /
        nullif(count(distinct if(cohorts = 'previous', hub_code, null)), 0) as equalized_revenue_previous
      , avg(number_skus)                                                    as avg_basket_skus
      , avg(number_items)                                                   as avg_basket_items
      , avg(net_order_value)                                                as avg_basket_value
    from looker_base_enriched
    group by
        1, 2, 3, 4, 5, 6
    order by
        order_week desc
)
select
    sku
  , product_name
  , order_date
  , order_week
  , category_name
  , sub_category_name
  , sum_item_price_net
  , sum_item_price_net_current
  , sum_item_price_net_previous
  , distinct_hub_codes
  , distinct_hub_codes_current
  , distinct_hub_codes_previous
  , equalized_revenue
  , equalized_revenue_current
  , equalized_revenue_previous
  , avg_basket_skus
  , avg_basket_items
  , avg_basket_value
  -- , sum(equalized_revenue) over (partition by sub_category_name) as equalized_revenue_subcategory
  , sum(equalized_revenue_current) over (partition by sub_category_name) as equalized_revenue_subcategory_current
  , sum(equalized_revenue_previous) over (partition by sub_category_name) as equalized_revenue_subcategory_previous
  , sum(equalized_revenue_current) over () as equalized_revenue_total_current
  , sum(equalized_revenue_previous) over () as equalized_revenue_total_previous
from aggregations
order by sku, order_date desc
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: order_date {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }
  dimension: order_week {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: category_name {
    type: string
    sql: ${TABLE}.category_name ;;
  }

  dimension: sub_category_name {
    type: string
    sql: ${TABLE}.sub_category_name ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     FILTER         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  filter: order_date_filter {
    type: date
  }

  filter: hub_code_filter {
    type: string
  }

  filter: hub_name_filter {
    type: string
  }

  filter: city_filter {
    type: string
  }

  filter: country_iso_filter {
    type: string
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameter         ~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # TODO: parameter to set the week to compare with


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures         ~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_item_price_net {
    type: sum
    value_format_name: eur
  }
  measure: sum_item_price_net_current {
    type: sum
    value_format_name: eur
  }
  measure: sum_item_price_net_previous {
    type: sum
    value_format_name: eur
  }
  # -----------------------------------------------------------
  measure: distinct_hub_codes {
    type: max
    value_format_name: decimal_1
    hidden: yes
  }
  measure: distinct_hub_codes_current {
    type: max
    value_format_name: decimal_1
    hidden: yes
  }
  measure: distinct_hub_codes_previous {
    type: max
    value_format_name: decimal_1
    hidden: yes
  }
  # -----------------------------------------------------------
  measure: equalized_revenue {
    type: sum
    value_format_name: eur
  }
  measure: equalized_revenue_current {
    type: sum
    value_format_name: eur
  }
  measure: equalized_revenue_previous {
    type: sum
    value_format_name: eur
  }


  # ~~~~~~~    Window Calculation    ~~~~~~~
  measure: equalized_revenue_subcategory_current {
    type: max
    value_format_name: eur
  }
  measure: equalized_revenue_subcategory_previous {
    type: max
    value_format_name: eur
  }
  measure: equalized_revenue_total_current {
    type: max
    value_format_name: eur
  }
  measure: equalized_revenue_total_previous {
    type: max
    value_format_name: eur
  }



  # ~~~~~~~    Order Metrics    ~~~~~~~
  measure: avg_basket_skus {
    type: average
    sql: ${TABLE}.avg_basket_skus ;;
  }

  measure: avg_basket_items {
    type: average
    sql: ${TABLE}.avg_basket_items ;;
  }

  measure: avg_basket_value {
    type: average
    sql: ${TABLE}.avg_basket_value ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Percentages         ~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: pct_eq_revenue_share_subcat_current {
    type: number
    value_format_name: percent_1
    sql:  ${equalized_revenue_current} / nullif(${equalized_revenue_subcategory_current} ,0);;
  }

  measure: pct_overall_business_growth {
    type: number
    value_format_name: percent_1
    sql: (${equalized_revenue_total_current} - ${equalized_revenue_total_previous}) / nullif(${equalized_revenue_total_previous} ,0) ;;
  }

  measure: pct_sku_growth {
    type: number
    value_format_name: percent_1
    sql: (${equalized_revenue_current} - ${equalized_revenue_previous}) / nullif(${equalized_revenue_previous} ,0) ;;
    html:
      {% if value > 0.3 %}
      <p style="color: #2ECC71; background-color: #D5F5E3 ;font-size: 100%; text-align:center">{{ rendered_value }}</p>
      {% elsif value < -0.3 %}
      <p style="color: #E74C3C; background-color: #FADBD8 ; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% endif %};;
  }

  measure: pct_sku_growth_corrected {
    type: number
    value_format_name: percent_1
    sql: ${pct_sku_growth} - ${pct_overall_business_growth} ;;

    html:
      {% if value > 0.3 %}
      <p style="color: #2ECC71; background-color: #D5F5E3 ;font-size: 100%; text-align:center">{{ rendered_value }}</p>
      {% elsif value < -0.3 %}
      <p style="color: #E74C3C; background-color: #FADBD8 ; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% endif %};;
  }

  set: detail {
    fields: [
      sku,
      product_name,
      order_date,
      order_week,
      category_name,
      sub_category_name,
    ]
  }
}
