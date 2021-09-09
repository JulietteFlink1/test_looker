view: testing__spc {

  derived_table: {
    sql: with start_date as (
          select DATE_SUB(CURRENT_DATE(), interval 7 day)            as start_d
               , CURRENT_DATE()                                      as end_d
               , timestamp(DATE_SUB(CURRENT_DATE(), interval 7 day)) as start_ts
               , CURRENT_TIMESTAMP()                                 as end_ts
      ),

           assignment_data as (
               select *
               from `flink-data-staging`.curated.products_hub_assignment
               where is_sku_assigned_to_hub
                 -- this gives only assignments without duplicates - aka if the status changed in this timeframe, it is not covered
                 -- those values will be set to TRUE in the next step
                 and valid_until >= (select end_ts from start_date)
                 and valid_from <= (select start_ts from start_date)
           ),

           inventory_data as (
               select inv.*
               from `flink-data-prod`.reporting.inventory_stock_count_daily as inv
                        left join assignment_data
                                  on assignment_data.sku = inv.sku
                                      and assignment_data.hub_code = inv.hub_code
               where partition_timestamp between (select start_d from start_date) and (select end_d from start_date)
                 and (assignment_data.is_sku_assigned_to_hub = TRUE or assignment_data.is_sku_assigned_to_hub is null)
           ),

           order_data as (
               select *
               from `flink-data-prod`.curated.order_lineitems as items
               where order_timestamp between (select start_ts from start_date) and (select end_ts from start_date)
           ),

           all_orders as (
               select country_iso,
                      COUNT(distinct order_uuid) as sum_orders_per_country
               from order_data
               group by 1
           ),

           agg_order_data as (
               select sku
                    , country_iso
                    , count(distinct order_data.order_uuid) as sum_orders_with_sku
                    , sum(quantity)                         as sum_item_quantity_sold
                    , avg(amt_unit_price_net)               as avg_unit_price_net
                    , avg(amt_unit_price_gross)             as avg_unit_price_gross
                    , sum(amt_unit_price_net * quantity)    as sum_item_price_sold_net
                    , AVG(sum_quantity)                     as avg_item_quantity_in_basket
                    , AVG(sum_item_price_net)               as avg_order_value_net_in_basket
                    , AVG(sum_skus)                         as avg_skus_in_basket
               from order_data
                        left join (
                   select order_uuid
                        , sum(quantity)                                   as sum_quantity
                        , COUNT(distinct sku)                             as sum_skus
                        , coalesce(sum(quantity * amt_unit_price_net), 0) as sum_item_price_net
                   from order_data
                   group by 1
               ) as hlp on hlp.order_uuid = order_data.order_uuid
               group by 1, 2
           ),
           oos_data as (
               select sku,
                      avg(avg_stock_count)                   as avg_stock_count,
                      sum(hours_oos) / sum(open_hours_total) as pct_oos
               from inventory_data
               group by 1
           ),
           num_assigned_hubs as (
               select sku
                    , COUNT(distinct hub_code) as num_ass_hub_codes
                    , max(max_num_hub_codes)   as max_num_hub_codes
               from (
                        select sku,
                               hub_code,
                               COUNT(distinct hub_code) over (partition by left (hub_code, 2)) as max_num_hub_codes
                        from assignment_data
                    )
               group by 1
           ),
           merged_data_table as (
               select prod.category
                    , prod.subcategory
                    , prod.substitute_group
                    , prod.product_sku                                                                               as sku
                    , agg_order_data.country_iso
                    , prod.product_name
                    , cust.is_local_product
                    , cust.subtotal_column
                    , cast((CASE
                                WHEN cust.buying_price like '%/%' THEN NULL
                                else cust.buying_price end) as float64)                                              as buying_price
                    , cust.substitute_group_custom_definition
                    , cust.sku_listing_status
                    , cust.vat_rate
                    , cast(cust.deposit as float64)                                                                  as deposit
                    , agg_order_data.sum_item_quantity_sold
                    , agg_order_data.avg_unit_price_gross
                    , agg_order_data.avg_unit_price_net
                    , agg_order_data.sum_item_price_sold_net
                    , oos_data.avg_stock_count
                    , oos_data.pct_oos
                    , num_assigned_hubs.max_num_hub_codes
                    , num_assigned_hubs.num_ass_hub_codes
                    , agg_order_data.avg_skus_in_basket
                    , agg_order_data.avg_item_quantity_in_basket
                    , agg_order_data.avg_order_value_net_in_basket
                    , agg_order_data.sum_orders_with_sku
                    , all_orders.sum_orders_per_country
               from `flink-data-prod`.curated.products as prod
                        left join `flink-data-prod`.google_sheets.retail_sku_attributes as cust on cust.sku = prod.product_sku
                        left join num_assigned_hubs on num_assigned_hubs.sku = prod.product_sku
                        left join oos_data on oos_data.sku = prod.product_sku
                        left join agg_order_data on agg_order_data.sku = prod.product_sku
                        left join all_orders on all_orders.country_iso = agg_order_data.country_iso
           ),

           add_calculated_metrics as (
               select *
                    , sum_item_price_sold_net / (1 - if(pct_oos = 1, 0.9999999, pct_oos)) / NULLIF(num_ass_hub_codes, 0) *
                      max_num_hub_codes                                                                 as revenue_equalized
                    , (avg_unit_price_gross - buying_price - deposit) / NULLIF(avg_unit_price_gross, 0) as gross_margin
                    , sum_item_quantity_sold / NULLIF(avg_stock_count, 0)                               as inventory_turnover
                    , sum_orders_with_sku /
                      NULLIF((sum_orders_per_country / (1 - if(pct_oos = 1, 0.9999999, pct_oos)) /
                              NULLIF(num_ass_hub_codes, 0) * max_num_hub_codes), 0)                     as basket_penetration
               from merged_data_table
           ),

           add_sub_category_comparison as (
               select *
                    , revenue_equalized /
                      NULLIF(SUM(revenue_equalized) over (partition by subcategory), 0)                 as revenue_equalized_share
                    , RANK() over (partition by subcategory order by gross_margin asc)                  as gross_margin_score
                    , RANK() over (partition by subcategory order by inventory_turnover asc)            as inventory_turnover_score
                    , RANK() over (partition by subcategory order by avg_order_value_net_in_basket asc) as avg_basket_value_score
                    , RANK() over (partition by subcategory order by basket_penetration asc)            as basket_penetration_score
               from add_calculated_metrics
           )
      select *
      from add_sub_category_comparison
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: subcategory {
    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: substitute_group {
    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: is_local_product {
    type: string
    sql: ${TABLE}.is_local_product ;;
  }

  dimension: subtotal_column {
    type: string
    sql: ${TABLE}.subtotal_column ;;
  }

  dimension: buying_price {
    type: number
    sql: ${TABLE}.buying_price ;;
    required_access_grants: [can_view_buying_information]
  }

  dimension: substitute_group_custom_definition {
    type: string
    sql: ${TABLE}.substitute_group_custom_definition ;;
  }

  dimension: sku_listing_status {
    type: string
    sql: ${TABLE}.sku_listing_status ;;
  }

  dimension: vat_rate {
    type: number
    sql: ${TABLE}.vat_rate ;;
  }

  dimension: deposit {
    type: number
    sql: ${TABLE}.deposit ;;
  }

  dimension: sum_item_quantity_sold {
    type: number
    sql: ${TABLE}.sum_item_quantity_sold ;;
  }

  dimension: avg_unit_price_gross {
    type: number
    sql: ${TABLE}.avg_unit_price_gross ;;
  }

  dimension: avg_unit_price_net {
    type: number
    sql: ${TABLE}.avg_unit_price_net ;;
  }

  dimension: sum_item_price_sold_net {
    type: number
    sql: ${TABLE}.sum_item_price_sold_net ;;
  }

  dimension: avg_stock_count {
    type: number
    sql: ${TABLE}.avg_stock_count ;;
  }

  dimension: pct_oos {
    type: number
    sql: ${TABLE}.pct_oos ;;
  }

  dimension: max_num_hub_codes {
    type: number
    sql: ${TABLE}.max_num_hub_codes ;;
  }

  dimension: num_ass_hub_codes {
    type: number
    sql: ${TABLE}.num_ass_hub_codes ;;
  }

  dimension: avg_skus_in_basket {
    type: number
    sql: ${TABLE}.avg_skus_in_basket ;;
  }

  dimension: avg_item_quantity_in_basket {
    type: number
    sql: ${TABLE}.avg_item_quantity_in_basket ;;
  }

  dimension: avg_order_value_net_in_basket {
    type: number
    sql: ${TABLE}.avg_order_value_net_in_basket ;;
  }

  dimension: sum_orders_with_sku {
    type: number
    sql: ${TABLE}.sum_orders_with_sku ;;
  }

  dimension: sum_orders_per_country {
    type: number
    sql: ${TABLE}.sum_orders_per_country ;;
  }

  dimension: revenue_equalized {
    type: number
    sql: ${TABLE}.revenue_equalized ;;
  }

  dimension: gross_margin {
    type: number
    sql: ${TABLE}.gross_margin ;;
    required_access_grants: [can_view_buying_information]
  }

  dimension: inventory_turnover {
    type: number
    sql: ${TABLE}.inventory_turnover ;;
  }

  dimension: basket_penetration {
    type: number
    sql: ${TABLE}.basket_penetration ;;
  }

  dimension: revenue_equalized_share {
    type: number
    sql: ${TABLE}.revenue_equalized_share ;;
  }

  dimension: gross_margin_score {
    type: number
    sql: ${TABLE}.gross_margin_score ;;
  }

  dimension: inventory_turnover_score {
    type: number
    sql: ${TABLE}.inventory_turnover_score ;;
  }

  dimension: avg_basket_value_score {
    type: number
    sql: ${TABLE}.avg_basket_value_score ;;
  }

  dimension: basket_penetration_score {
    type: number
    sql: ${TABLE}.basket_penetration_score ;;
  }

  set: detail {
    fields: [
      category,
      subcategory,
      substitute_group,
      sku,
      country_iso,
      product_name,
      is_local_product,
      subtotal_column,
      buying_price,
      substitute_group_custom_definition,
      sku_listing_status,
      vat_rate,
      deposit,
      sum_item_quantity_sold,
      avg_unit_price_gross,
      avg_unit_price_net,
      sum_item_price_sold_net,
      avg_stock_count,
      pct_oos,
      max_num_hub_codes,
      num_ass_hub_codes,
      avg_skus_in_basket,
      avg_item_quantity_in_basket,
      avg_order_value_net_in_basket,
      sum_orders_with_sku,
      sum_orders_per_country,
      revenue_equalized,
      gross_margin,
      inventory_turnover,
      basket_penetration,
      revenue_equalized_share,
      gross_margin_score,
      inventory_turnover_score,
      avg_basket_value_score,
      basket_penetration_score
    ]
  }
}
