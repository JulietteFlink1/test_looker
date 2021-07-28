# based on the ticket:
# https://goflink.atlassian.net/browse/DATA-628
view: shelf_planning {
  derived_table: {
    sql: with
          looker_base_order_data as (
              select
                  product_facts.product_name                                    as product_name
                , case
                  when length(order_orderline.product_sku) = 7
                      then concat('1', order_orderline.product_sku)
                      else order_orderline.product_sku
                  end                                                           as sku
                , (date(base_orders.created, 'Europe/Berlin'))                  as order_date
                , case
                  when extract(dayofweek from date(base_orders.created, 'Europe/Berlin')) in (2, 3, 4)
                      then 'mon-wed'
                  when extract(dayofweek from date(base_orders.created, 'Europe/Berlin')) in (5, 6, 7)
                      then 'thu-sat'
                  when extract(dayofweek from date(base_orders.created, 'Europe/Berlin')) in (1)
                      then 'sun'
                  end                                                           as day_of_week_group
                , extract(week from date(base_orders.created, 'Europe/Berlin')) as order_week
                , lower(hubs.hub_code)                                          as hub_code
                , coalesce(sum(order_orderline.quantity), 0)                    as sum_item_quantity
              from `flink-data-prod.saleor_prod_global.order_order`
                  as base_orders
              left join `flink-backend.gsheet_store_metadata.hubs`
                  as hubs
                        on base_orders.country_iso = hubs.country_iso and
                           (case
                            when json_extract_scalar(base_orders.metadata, '$.warehouse') in
                                 ('hamburg-oellkersallee', 'hamburg-oelkersallee')
                                then 'de_ham_alto'
                            when json_extract_scalar(base_orders.metadata, '$.warehouse') = 'münchen-leopoldstraße'
                                then 'de_muc_schw'
                                else json_extract_scalar(base_orders.metadata, '$.warehouse')
                            end) = (lower(hubs.hub_code))
              left join `flink-data-prod.saleor_prod_global.order_orderline`
                  as order_orderline
                        on order_orderline.country_iso = base_orders.country_iso and
                           order_orderline.order_id = base_orders.id
              left join `flink-data-dev.sandbox.product_facts`
                  as product_facts
                        on order_orderline.country_iso = product_facts.country_iso
                            and (case
                                 when length(order_orderline.product_sku) = 7
                                     then concat('1', order_orderline.product_sku)
                                     else order_orderline.product_sku
                                 end) = product_facts.sku

              where
                  {% condition date_filter %}    date(base_orders.created, 'Europe/Berlin')    {% endcondition %}
                  and
                  base_orders.status in ('fulfilled', 'partially fulfilled')
                  -- and date(base_orders.created, 'Europe/Berlin') > date_sub(current_date(), interval 14 day)

                  and extract(dayofweek from date(base_orders.created, 'Europe/Berlin')) not in (1)
              group by
                  1, 2, 3, 4, 5, 6
          )
        , daily_skus_with_stock as (
          select
              sku
            , hub_code
            , tracking_date
            , avg_stock_count
          from `flink-data-dev`.sandbox.daily_historical_stock_levels
              -- only SKUs in stock per day
          where
          {% condition date_filter %}    tracking_date    {% endcondition %}
                  and
                avg_stock_count > 0

            -- and tracking_date > date_sub(current_date(), interval 14 day)
      )
        , looker_orders_no_oos as (
          select
              base.sku
            , base.product_name
            , base.hub_code
            , concat('w', base.order_week, ' ', base.day_of_week_group) as three_day_window
            , sum(base.sum_item_quantity)                               as sum_item_quantity
            , avg(day.avg_stock_count)                                  as avg_stock_count

          from looker_base_order_data      as base
          inner join daily_skus_with_stock as day
                     on base.sku = day.sku
                         and base.order_date = day.tracking_date
                         and base.hub_code = day.hub_code
          group by 1, 2, 3, 4
          order by hub_code, sku, three_day_window
      )
        , window_median as (
          select *
               , percentile_disc(sum_item_quantity, 0.5) over (partition by sku, hub_code) as median_sum_item_quantity
          from looker_orders_no_oos
      )
        , aggregated_data as (
          select
              sku
            , product_name
            , hub_code
            , median_sum_item_quantity
            , count(distinct three_day_window) as num_3d_windows
            , avg(avg_stock_count)             as avg_stock_over_days_3d_windows_total_time
            , max(sum_item_quantity)           as max_sum_item_quantity
            , avg(sum_item_quantity)           as AVG_sum_item_quantity
            , stddev(sum_item_quantity)        as std_sum_item_quantity

          from window_median
          group by 1, 2, 3, 4
      )

      select *
      from aggregated_data
       ;;
  }
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     FILTER         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  filter: date_filter {
    type: date
    datatype: date
    default_value: "6 weeks ago"
  }
  parameter: last_weeks {
    type: number
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${sku}, ${hub_code}) ;;
  }
  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     MEASURES       ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: avg_median_sum_item_quantity {
    label: "Median Item Quantity"
    group_label: "Support KPIs"
    type: average
    sql: ${TABLE}.median_sum_item_quantity ;;
    value_format_name: decimal_1

  }

  measure: avg_num_3d_windows {
    label: "# 3d Windows"
    group_label: "Support KPIs"
    type: average
    sql: ${TABLE}.num_3d_windows ;;
    value_format_name: decimal_1
  }

  measure: avg_stock_over_days_3d_windows_total_time {
    label: "AVG Stock Count"
    group_label: "Support KPIs"
    type: average
    sql: ${TABLE}.avg_stock_over_days_3d_windows_total_time ;;
    value_format_name: decimal_1
  }

  measure: avg_sum_item_quantity {
    label: "AVG Item Quantity"
    group_label: "Support KPIs"
    type: average
    sql: ${TABLE}.AVG_sum_item_quantity ;;
    value_format_name: decimal_1
  }

  measure: std_sum_item_quantity {
    label: "STD Item Quantity"
    group_label: "Support KPIs"
    type: average
    sql: ${TABLE}.std_sum_item_quantity ;;
    value_format_name: decimal_1
  }

  # --- main kpis
  measure: avg_max_sum_item_quantity {
    label: "1) AVG Max Item Quantity"
    group_label: "Main KPIs"
    type: average
    sql: ${TABLE}.max_sum_item_quantity ;;
    value_format_name: decimal_1
  }

  measure: percentile_sum_item_quantity {
    label: "2) 3rd Quartile Item Quantity"
    group_label: "Main KPIs"
    type: percentile
    percentile: 75
    sql: ${TABLE}.max_sum_item_quantity ;;
    value_format_name: decimal_1
  }

  measure: avg_main_kpis {
    label: "3) AVG over 1) and 2)"
    group_label: "Main KPIs"
    type: number
    sql: (${avg_max_sum_item_quantity} + ${percentile_sum_item_quantity}) / 2 ;;
    value_format_name: decimal_1
  }

}
