view: sku_performance_coefficiant_spc {

  derived_table: {
    sql: with start_date as (
          select DATE_SUB( DATE_TRUNC(CURRENT_DATE(), week(monday) ) , interval 4 week)            as start_d  # last 4 complete weeks
               , DATE_TRUNC(CURRENT_DATE(), week(sunday) )                                         as end_d    # sunday, as this is last weeks last day in German calendar
               , timestamp(DATE_SUB( DATE_TRUNC(CURRENT_DATE(), week(monday) ) , interval 4 week)) as start_ts
               , timestamp(DATE_TRUNC(CURRENT_DATE(), week(sunday) ))                              as end_ts
      ),

           assignment_data as (
               select *
               from `flink-data-staging`.curated.products_hub_assignment
               where is_sku_assigned_to_hub
                 -- this gives only assignments without duplicates - aka if the status changed in this timeframe, it is not covered
                 -- those values will be set to TRUE in the next step
                 and valid_to >= (select end_ts from start_date)
                 and valid_from <= (select start_ts from start_date)
           ),

           inventory_data as (
               select inv.*
               from `flink-data-prod`.reporting.inventory_stock_count_daily as inv
                        left join assignment_data
                                  on assignment_data.sku = inv.sku
                                      and assignment_data.hub_code = inv.hub_code
               where inventory_tracking_date between (select start_d from start_date) and (select end_d from start_date)
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
                      sum(hours_oos) / NULLIF(sum(open_hours_total),0) as pct_oos
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
                    , prod.created_at                                                                                as sku_created_at_timestamp
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
                    , sum_item_price_sold_net / NULLIF((1 - if(pct_oos = 1, 0.9999999, pct_oos)),0) / NULLIF(num_ass_hub_codes, 0) *
                      max_num_hub_codes                                                                 as revenue_equalized
                    , (avg_unit_price_gross - buying_price - deposit) / NULLIF(avg_unit_price_gross, 0) as gross_margin
                    , sum_item_quantity_sold / NULLIF(avg_stock_count, 0)                               as inventory_turnover
                    , sum_orders_with_sku /
                      NULLIF((sum_orders_per_country / NULLIF((1 - if(pct_oos = 1, 0.9999999, pct_oos)),0) /
                              NULLIF(num_ass_hub_codes, 0) * max_num_hub_codes), 0)                     as basket_penetration
               from merged_data_table
           ),

           add_sub_category_comparison as (
               select *
                    , revenue_equalized /
                      NULLIF(SUM(revenue_equalized) over (partition by country_iso, subcategory), 0)                 as revenue_equalized_share
                    , RANK() over (partition by country_iso, subcategory order by gross_margin asc)                  as gross_margin_score
                    , RANK() over (partition by country_iso, subcategory order by inventory_turnover asc)            as inventory_turnover_score
                    , RANK() over (partition by country_iso, subcategory order by avg_order_value_net_in_basket asc) as avg_basket_value_score
                    , RANK() over (partition by country_iso, subcategory order by basket_penetration asc)            as basket_penetration_score
               from add_calculated_metrics
           )
      select
          *
        , RANK() over (partition by country_iso, subcategory order by revenue_equalized_share,0 asc)                   as revenue_equalized_share_score
      from add_sub_category_comparison
       ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: product_sku_name {
    label: "SKU + Name"
    type: string
    sql: CONCAT(${TABLE}.sku, ' - ', ${TABLE}.product_name) ;;
  }

  # =========  hidden   =========


  # =========  product attributes   =========
  dimension: category {
    label: "Parent Category"
    type: string
    sql: ${TABLE}.category ;;
    group_label: "> Product Dimensions"
  }

  dimension: subcategory {
    label: "Sub-Category"
    type: string
    sql: ${TABLE}.subcategory ;;
    group_label: "> Product Dimensions"
  }

  dimension: substitute_group {
    type: string
    sql: ${TABLE}.substitute_group ;;
    group_label: "> Product Dimensions"
  }

  dimension_group: sku_created_at_timestamp {
    label: "SKU Creation"
    type: time
    sql: ${TABLE}.sku_created_at_timestamp ;;
    group_label: "> Product Dimensions"
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    group_label: "> Product Dimensions"
  }

  dimension: is_local_product {
    type: string
    sql: ${TABLE}.is_local_product ;;
    group_label: "> Product Dimensions"
  }

  dimension: substitute_group_custom_definition {
    type: string
    sql: ${TABLE}.substitute_group_custom_definition ;;
    group_label: "> Product Dimensions"
  }

  dimension: sku_listing_status {
    type: string
    sql: ${TABLE}.sku_listing_status ;;
    group_label: "> Product Dimensions"
  }


  # =========  IDs   =========


  # =========  Geo   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    group_label: "> Geographic Dimensions"
  }


  # =========  Helper Cols   =========
  dimension: subtotal_column {
    type: string
    sql: ${TABLE}.subtotal_column ;;
    group_label: "> Helper Dimension"
  }

  dimension: sum_orders_with_sku {
    label: "# Orders with selected SKU"
    type: number
    sql: ${TABLE}.sum_orders_with_sku ;;
    group_label: "> Helper Dimension"
  }

  dimension: sum_orders_per_country {
    label: "# Total Orders per Country"
    type: number
    sql: ${TABLE}.sum_orders_per_country ;;
    group_label: "> Helper Dimension"
  }
  dimension: max_num_hub_codes {
    label: "# Maximum Hubs per Country and Day"
    type: number
    sql: ${TABLE}.max_num_hub_codes ;;
    group_label: "> Helper Dimension"
  }

  dimension: num_ass_hub_codes {
    label: "# Assigned Hubs (of an SKU)"
    type: number
    sql: ${TABLE}.num_ass_hub_codes ;;
    group_label: "> Helper Dimension"
  }



  # =========  Payment   =========
  dimension: buying_price {
    type: number
    sql: ${TABLE}.buying_price ;;
    required_access_grants: [can_view_buying_information]
    group_label: "> Payment Dimension"
    value_format_name: eur
  }

  dimension: vat_rate {
    type: number
    sql: ${TABLE}.vat_rate ;;
    group_label: "> Payment Dimension"
    value_format_name: percent_2
  }

  dimension: deposit {
    type: number
    sql: ${TABLE}.deposit ;;
    group_label: "> Payment Dimension"
    value_format_name: eur
  }


  # =========  Scores   =========
  dimension: gross_margin_score {
    type: number
    sql: ${TABLE}.gross_margin_score ;;
    group_label: "> Final Scores"
    value_format_name: decimal_1
  }

  dimension: inventory_turnover_score {
    type: number
    sql: ${TABLE}.inventory_turnover_score ;;
    group_label: "> Final Scores"
    value_format_name: decimal_1
  }

  dimension: avg_basket_value_score {
    type: number
    sql: ${TABLE}.avg_basket_value_score ;;
    group_label: "> Final Scores"
    value_format_name: decimal_1
  }

  dimension: basket_penetration_score {
    type: number
    sql: ${TABLE}.basket_penetration_score ;;
    group_label: "> Final Scores"
    value_format_name: decimal_1
  }

  dimension: revenue_equalized_share_score {
    label: "Equalized Revenue Score"
    type: number
    sql: ${TABLE}.revenue_equalized_share_score ;;
    group_label: "> Final Scores"
    value_format_name: decimal_1
  }


  # =========  Numeric Dimensions   =========
  dimension: sum_item_quantity_sold {
    type: number
    sql: ${TABLE}.sum_item_quantity_sold ;;
    group_label: "> Numeric Dimensions"
    value_format_name: decimal_1
  }

  dimension: avg_unit_price_gross {
    type: number
    sql: ${TABLE}.avg_unit_price_gross ;;
    group_label: "> Numeric Dimensions"
    value_format_name: eur
  }

  dimension: avg_unit_price_net {
    type: number
    sql: ${TABLE}.avg_unit_price_net ;;
    group_label: "> Numeric Dimensions"
    value_format_name: eur
  }

  dimension: sum_item_price_sold_net {
    type: number
    sql: ${TABLE}.sum_item_price_sold_net ;;
    group_label: "> Numeric Dimensions"
    value_format_name: eur
  }

  dimension: avg_stock_count {
    type: number
    sql: ${TABLE}.avg_stock_count ;;
    group_label: "> Numeric Dimensions"
    value_format_name: decimal_1
  }

  dimension: pct_oos {
    label: "% Out of Stock"
    type: number
    sql: ${TABLE}.pct_oos ;;
    group_label: "> Numeric Dimensions"
    value_format_name: percent_2
  }

  dimension: avg_skus_in_basket {
    label: "AVG Unique Products in Basket"
    type: number
    sql: ${TABLE}.avg_skus_in_basket ;;
    group_label: "> Numeric Dimensions"
    value_format_name: decimal_1
  }

  dimension: avg_item_quantity_in_basket {
    label: "AVG Item Quantity in Basket"
    type: number
    sql: ${TABLE}.avg_item_quantity_in_basket ;;
    group_label: "> Numeric Dimensions"
    value_format_name: decimal_1
  }

  dimension: avg_order_value_net_in_basket {
    type: number
    sql: ${TABLE}.avg_order_value_net_in_basket ;;
    group_label: "> Numeric Dimensions"
    value_format_name: decimal_1
  }


  dimension: revenue_equalized {
    label: "Equalized Revenue"
    type: number
    sql: ${TABLE}.revenue_equalized ;;
    group_label: "> Numeric Dimensions"
    value_format_name: eur
  }

  dimension: gross_margin {
    type: number
    sql: ${TABLE}.gross_margin ;;
    required_access_grants: [can_view_buying_information]
    group_label: "> Numeric Dimensions"
    value_format_name: eur
  }

  dimension: inventory_turnover {
    type: number
    sql: ${TABLE}.inventory_turnover ;;
    group_label: "> Numeric Dimensions"
    value_format_name: decimal_3
  }

  dimension: basket_penetration {
    type: number
    sql: ${TABLE}.basket_penetration ;;
    group_label: "> Numeric Dimensions"
    value_format_name: percent_3
  }

  dimension: revenue_equalized_share {
    label: "Share Equalized Revenue vs Sub-Category"
    type: number
    sql: ${TABLE}.revenue_equalized_share ;;
    group_label: "> Numeric Dimensions"
    value_format_name: percent_3
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


























}
