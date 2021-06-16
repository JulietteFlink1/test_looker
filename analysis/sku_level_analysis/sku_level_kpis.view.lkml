view: sku_level_kpis {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql: with looker_base as (
          select
              hubs.country_iso                                           as country_iso
            , lower(hubs.hub_code)                                       as hub_code
            , hubs.city                                                  as city
            , hubs.hub_name                                              as hub_name
            , product_category.name                                      as sub_category_name
            , parent_category.name                                       as category_name
            , product_product.name                                       as product_name
            , case
                  when length(order_orderline.product_sku) = 7
                      then concat('1', order_orderline.product_sku)
                      else order_orderline.product_sku
              end                                                        as sku
            , date(order_order.created, 'Europe/Berlin')                 as order_date
            , order_order.id                                             as order_id
              -- AGGREGATES
            , sum(order_orderline.quantity_fulfilled)                    as sku_quantity
            , count(distinct date(order_order.created, 'Europe/Berlin')) as num_days_sold
            , coalesce(sum(order_orderline.quantity_fulfilled * order_orderline.unit_price_net_amount),
                       0)                                                as sum_item_price_net
            , coalesce(sum(order_orderline.quantity_fulfilled * order_orderline.unit_price_net_amount),
                       0)                                                as sum_item_price_fulfilled_net
          from flink-backend.saleor_db_global.order_order
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
                     ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com', 'alenaschneck@gmx.de',
                      'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com', 'fabian.hardenberg@gmail.com',
                      'benjamin.zagel@gmail.com')) is null) and (order_order.status in ('fulfilled', 'partially fulfilled')))
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
              1, 2, 3, 4, 5, 6, 7, 8, 9,10
          order by
              10 desc
      )
         , order_kpis as (
          select
              order_id
            , sum(sku_quantity)       as number_items
            , count(sku)              as number_skus
            , sum(sum_item_price_net) as net_order_value
          from looker_base
          group by 1
      )
         , sku_kpis as (
          select
              looker_base.sku as sku,
              looker_base.product_name as product_name,
              looker_base.order_date,
              looker_base.category_name,
              looker_base.sub_category_name,
              looker_base.city,
              count(distinct looker_base.hub_code) as num_hubs ,
              sum(looker_base.sum_item_price_net) as sum_item_price_net,
                  sum(looker_base.sum_item_price_net) /
                  nullif(count(distinct looker_base.hub_code), 0) as equalized_sum_item_price_net
                                    , avg(order_kpis.number_skus) as avg_basket_skus
                                    , avg(order_kpis.number_items) as avg_basket_items
                                    , avg(order_kpis.net_order_value) as avg_basket_value
          from looker_base
          left join order_kpis
                    on looker_base.order_id = order_kpis.order_id
          group by 1, 2, 3, 4, 5, 6
      )

         , sku_kpis_enhanced as (
          select
              sku,product_name, order_date, category_name, sub_category_name, city, num_hubs, sum_item_price_net, equalized_sum_item_price_net
                 , avg_basket_skus, avg_basket_items, avg_basket_value
            -- TABLE CALCS
                 , sum(equalized_sum_item_price_net)
                       over (partition by order_date, sub_category_name) as sum_item_price_net_per_sub_category
                 , sum(equalized_sum_item_price_net)
                       over (partition by order_date, category_name)     as sum_item_price_net_per_category
            -- comparison of last 5weeks value - might be parametrized in looker
                 , ifnull(lag(equalized_sum_item_price_net, 35) over (partition by sku order by order_date),
                          0)                                             as sum_item_price_net_prev_5w
          from sku_kpis
      )

      select *
      from sku_kpis_enhanced
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  dimension: sku {
    label: "Product SKU"
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: product_name {
    label: "Product Name"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension_group: order_date {
    label: "Order"
    timeframes: [date, week, month, year]
    type: time
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: category_name {
    label: "Parent Category Name"
    type: string
    sql: ${TABLE}.category_name ;;
  }

  dimension: sub_category_name {
    label: "Sub-Category Name"
    type: string
    sql: ${TABLE}.sub_category_name ;;
  }

  dimension: city {
    label: "City"
    type: string
    sql: ${TABLE}.city ;;
  }


  measure: num_hubs {
    label: "# Hubs"
    description: "The number of Hubs, where a specific SKU was sold on a day"
    type: sum
    sql: ${TABLE}.num_hubs ;;
    value_format_name: decimal_1
  }

  measure: sum_item_price_net {
    label: "Sum Item Price (Net)"
    description: "Sum of sold Item prices (excl. VAT)"
    type: sum
    sql: ${TABLE}.sum_item_price_net ;;
    value_format_name: eur
  }

  measure: equalized_sum_item_price_net {
    label: "Daily Equalized Revenue"
    description: "The Sum Item Price (Net) devided by the number of Hubs, the SKU was sold"
    type: sum
    sql: ${TABLE}.equalized_sum_item_price_net ;;
    value_format_name: eur
  }

  measure: equalized_revenue_share_per_sub_category {
    label: "% Per Sub-Category: Daily Revenue equalized"
    description: "The share of Daily Revenue equalized vs. all SKUs within a Sub-Category"
    type: number
    sql: ${equalized_sum_item_price_net} / nullif(${sum_item_price_net_per_sub_category},0) ;;
    value_format_name: percent_1
  }

  measure: avg_basket_skus {
    label: "ø Unique Products in Basket"
    description: "The number of unique products, that are on average sold when a selected SKU is in the basket"
    type: average
    sql: ${TABLE}.avg_basket_skus ;;
    value_format_name: decimal_1
  }

  measure: avg_basket_items {
    label: "ø Products in Basket"
    description: "The number of total products, that are on average sold when a selected SKU is in the basket"
    type: average
    sql: ${TABLE}.avg_basket_items ;;
    value_format_name: decimal_1
  }

  measure: avg_basket_value {
    label: "ø Basket Value"
    description: "The average basket value, given a selected SKU is part of the basket"
    type: average
    sql: ${TABLE}.avg_basket_value ;;
    value_format_name: eur
  }

  measure: sum_item_price_net_per_sub_category {
    label: "Per Sub-Category: Daily Revenue equalized"
    description: "The total Daily Revenue equalized of all SKUs within a Sub-Category"
    type: average
    sql: ${TABLE}.sum_item_price_net_per_sub_category ;;
    value_format_name: eur

  }

  measure: sum_item_price_net_per_category {
    label: "Per Category: Daily Revenue equalized"
    description: "The total Daily Revenue equalized of all SKUs within a Category"
    type: average
    sql: ${TABLE}.sum_item_price_net_per_category ;;
    value_format_name: eur
  }

  measure: sum_item_price_net_prev_5w {
    label: "Equalize Revenue - 5w ago"
    description: "The equalized revenue of an SKU 5 weeks ago"
    type: sum
    sql: ${TABLE}.sum_item_price_net_prev_5w ;;
    value_format_name: eur
  }

  measure:equlized_revenue_performance {
    label: "Equalized Revenue Performance"
    description: "The percentage change of the equalized revenue compared to last 5w value"
    type: number
    sql: if(
            ${sum_item_price_net_prev_5w} = 0
            , null
            , ${equalized_sum_item_price_net} / ${sum_item_price_net_prev_5w} -1
            );;
    value_format_name: percent_1
  }

  measure: overall_business_trend {
    label: "Overall Business Growth"
    description: "The growth of the businessed based on the Item Price Net development"
    type: number
    sql: ( sum(${equalized_sum_item_price_net}) over () - sum(${sum_item_price_net_prev_5w}) over () ) /
         nullif(sum(${sum_item_price_net_prev_5w}) over () , 0);;
    value_format_name: percent_1
  }

  measure:equlized_revenue_performance_cleaned_by_business_development {
    label: "Equalized Revenue Performance - Adjusted by Company Growth"
    description: "The percentage change of the equalized revenue compared to last 5w value minus the general business growth over the defined timeframe"
    type: number
    sql: if(
            ${sum_item_price_net_prev_5w} = 0
            , null
            , ${equalized_sum_item_price_net} / ${sum_item_price_net_prev_5w} -1
            ) - ${overall_business_trend};;
    value_format_name: percent_1
  }

  set: detail {
    fields: [
      sku,
      category_name,
      sub_category_name,
      city,
      num_hubs,
      sum_item_price_net,
      equalized_sum_item_price_net,
      avg_basket_skus,
      avg_basket_items,
      avg_basket_value,
      sum_item_price_net_per_sub_category,
      sum_item_price_net_per_category,
      sum_item_price_net_prev_5w
    ]
  }
}
