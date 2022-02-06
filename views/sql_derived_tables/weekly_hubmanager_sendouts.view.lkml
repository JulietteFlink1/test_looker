view: weekly_hubmanager_sendouts {
  derived_table: {
    sql: with
      daily_orders as (

             select hub_code,
                    order_date,
                    country_iso,
                    count(distinct order_uuid) as number_daily_orders

             from `flink-data-prod.curated.orders` as orders

             where is_successful_order is true
             and date_trunc(date(order_timestamp),week(monday)) = date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)

             group by 1, 2, 3

      ),

      buckets_base as (
             select hub_code,
                    date_trunc(order_date, week(monday)),
                    avg(number_daily_orders) as avg_daily_orders

             from daily_orders

             group by 1 ,2
      ),

      buckets as (
             select hub_code,
                    case when avg_daily_orders < 200 then '<200'
                         when avg_daily_orders between 200 and 349 then '200-350'
                         when avg_daily_orders between 350 and 499 then '350-500'
                         when avg_daily_orders between 500 and 649 then '500-650'
                         when avg_daily_orders >= 650  then '>650' end as bucket

             from buckets_base



      ),


      orders as (

             select hub_code,
                    date_trunc(date(order_timestamp),week(monday)) as week,
                    country_iso,
                    count(distinct order_uuid) as number_of_orders,
                    count(case when abs(delivery_pdt_minutes - fulfillment_time_minutes)<=2 then order_uuid end)/count(distinct order_uuid)  as share_of_orders_with_delta_pdt_less_than_2,
                    count(case when fulfillment_time_minutes > 20 then order_uuid end) /count(distinct order_uuid) as share_of_orders_delivered_more_than_20,

             from `flink-data-prod.curated.orders` as orders

             where is_successful_order is true

             and date_trunc(date(order_timestamp),week(monday)) between date_sub(date_trunc(current_date(), week(MONDAY)),interval 2 week) and date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)


             group by 1,2,3
      ),

      orderline as (
             select ol.hub_code,
                    date_trunc(date(ol.order_timestamp),week(monday)) as week,
                    count(distinct case when return_reason like '%goods_not_on_shelf%' then ol.order_uuid
                                        when return_reason like '%goods_spoiled%'  then ol.order_uuid
                                        when return_reason like '%goods_damaged%'  then ol.order_uuid
                    end)/count(distinct order_uuid) as share_pre_order_swiped,
                    count(distinct case when return_reason not like '%goods_not_on_shelf%'
                                       and return_reason not like '%goods_spoiled%'
                                       and return_reason not like '%goods_damaged%'
                                       and return_reason is not null
                                       then ol.order_uuid end)/count(distinct order_uuid) as share_post_order_issues,


             from `flink-data-prod.curated.order_lineitems` ol
             left join `flink-data-prod.curated.orders` o using(order_uuid)

             where is_successful_order is true
             and date_trunc(date(o.order_timestamp),week(monday)) between date_sub(date_trunc(current_date(), week(MONDAY)),interval 2 week) and date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)
             and date_trunc(date(ol.order_timestamp),week(monday)) between date_sub(date_trunc(current_date(), week(MONDAY)),interval 2 week) and date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)

             group by 1, 2

      ),


      inventory_tool as (
             select
                  hub_code,
                  date_trunc(inventory_change_date,week(monday)) as week,
                  count(distinct case when change_reason in ('product-damaged', 'product-expired', 'too-good-to-go') and quantity_change<>0 then sku end)/count(distinct sku) as share_of_outbound_skus ,
                  count(distinct case when change_reason  = 'inventory-correction' and quantity_change < 0 then sku end)/count(distinct sku) as share_negative_corrected,
                  count(distinct case when change_reason  = 'inventory-correction' and quantity_change > 0 then sku end) /count(distinct sku) as share_positive_corrected

             from `flink-data-prod.reporting.inventory_changes_daily` AS inventory_changes_daily

             where date_trunc(inventory_change_date,week(monday)) between date_sub(date_trunc(current_date(), week(MONDAY)),interval 2 week) and date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)
             group by 1,2

      ),

      staffing_data as (

             select
                    hub_code,
                    date_trunc(shift_date,week(monday))                             as week,
                    sum(number_of_no_show_minutes)/sum(number_of_planned_minutes)   as share_of_no_show,
                    sum(number_of_planned_minutes)                                  as number_of_planned_minutes,
                    sum(number_of_worked_minutes_external)                          as number_of_worked_minutes_external,
                    sum(number_of_worked_minutes)                                   as number_of_worked_minutes,
                    sum(case when position_name = 'rider' then safe_cast(number_of_orders as int64) end ) /sum(case when position_name = 'rider'  then safe_cast(number_of_worked_minutes/60 as float64) end) as rider_utr,
                    sum(case when position_name = 'picker' then safe_cast(number_of_orders as int64)  end )/sum(case when position_name = 'picker' then safe_cast(number_of_worked_minutes/60 as float64) end) as picker_utr


             from `flink-data-prod.reporting.hub_staffing`

             where date_trunc(shift_date,week(monday)) between date_sub(date_trunc(current_date(), week(MONDAY)),interval 2 week) and date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)

             group by 1,2
      ),

      base as(

      select orders.*,
             orderline.* except(week, hub_code),
             inventory_tool.* except(week,hub_code),
             staffing_data.* except(week, hub_code)


      from orders

      left join orderline using(hub_code, week)

      left join inventory_tool using(hub_code, week)

      left join staffing_data using(hub_code, week)
      ),

      last_week as (
             select bucket, base.* except(week) ,week, 'current_week' as dimension

             from base

             left join buckets using(hub_code)

             where week = date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)


      ),

      pre_last_week as (
             select bucket, base.* except(week) ,
             date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week) as week,
             'last_week' as dimension

             from base

             left join buckets using(hub_code)

             where week = date_sub(date_trunc(current_date(), week(MONDAY)),interval 2 week)


      ),


      wow as (
             select hub_code,
                    country_iso,
                    week,
                    bucket,
                    (number_of_orders - lag(number_of_orders,1) over (partition by hub_code order by week asc))/lag(number_of_orders,1) over (partition by hub_code order by week asc) as number_of_orders,
                    share_of_orders_with_delta_pdt_less_than_2 - lag(share_of_orders_with_delta_pdt_less_than_2,1) over (partition by hub_code order by week asc) as share_of_orders_with_delta_pdt_less_than_2,
                    share_of_orders_delivered_more_than_20 - lag(share_of_orders_delivered_more_than_20,1) over (partition by hub_code order by week asc) as share_of_orders_delivered_more_than_20,
                    share_pre_order_swiped - lag(share_pre_order_swiped,1) over (partition by hub_code order by week asc) as share_pre_order_swiped,
                    share_post_order_issues - lag(share_post_order_issues,1) over (partition by hub_code order by week asc) as share_post_order_issues,
                    share_of_outbound_skus - lag(share_of_outbound_skus,1) over (partition by hub_code order by week asc) as share_of_outbound_skus,
                    share_negative_corrected - lag(share_negative_corrected,1) over (partition by hub_code order by week asc) as share_negative_corrected,
                    share_positive_corrected - lag(share_positive_corrected,1) over (partition by hub_code order by week asc) as share_positive_corrected,
                    share_of_no_show - lag(share_of_no_show,1) over (partition by hub_code order by week asc) as share_of_no_show,
                    rider_utr - lag(rider_utr,1) over (partition by hub_code order by week asc) as rider_utr,
                    picker_utr - lag(picker_utr,1) over (partition by hub_code order by week asc) as picker_utr,



                     'wow' as dimension

             from base

             left join buckets using(hub_code)



      ),


      ranking_country as (
             select hub_code,
                    week,
                    buckets.bucket,
                    country_iso,
                    rank() over (partition by country_iso, week order by number_of_orders desc) as number_of_orders,
                    rank() over (partition by country_iso, week order by share_of_orders_with_delta_pdt_less_than_2 desc) as share_of_orders_with_delta_pdt_less_than_2,
                    rank() over (partition by country_iso, week order by share_of_orders_delivered_more_than_20 asc) as share_of_orders_delivered_more_than_20,
                    rank() over (partition by country_iso, week order by share_pre_order_swiped asc) as share_pre_order_swiped,
                    rank() over (partition by country_iso, week order by share_post_order_issues asc) as share_post_order_issues,
                    rank() over (partition by country_iso, week order by share_of_outbound_skus asc) as share_of_outbound_skus,
                    rank() over (partition by country_iso, week order by share_negative_corrected asc) as share_negative_corrected,
                    rank() over (partition by country_iso, week order by share_positive_corrected asc) as share_positive_corrected,
                    rank() over (partition by country_iso, week order by share_of_no_show asc) as share_of_no_show,
                    rank() over (partition by country_iso, week order by rider_utr desc) as rider_utr,
                    rank() over (partition by country_iso, week order by picker_utr desc) as picker_utr,
                    'country_rank' as dimension

             from base

             left join buckets using(hub_code)


      ),

      ranking_bucket as (
              select hub_code,
                    week,
                    country_iso,
                    bucket,
                    rank() over (partition by country_iso, week, bucket order by number_of_orders desc) as number_of_orders,
                    rank() over (partition by country_iso, week, bucket order by share_of_orders_with_delta_pdt_less_than_2 desc) as share_of_orders_with_delta_pdt_less_than_2,
                    rank() over (partition by country_iso, week, bucket order by share_of_orders_delivered_more_than_20 asc) as share_of_orders_delivered_more_than_20,
                    rank() over (partition by country_iso, week, bucket order by share_pre_order_swiped asc) as share_pre_order_swiped,
                    rank() over (partition by country_iso, week, bucket order by share_post_order_issues asc) as share_post_order_issues,
                    rank() over (partition by country_iso, week, bucket order by share_of_outbound_skus asc) as share_of_outbound_skus,
                    rank() over (partition by country_iso, week, bucket order by share_negative_corrected asc) as share_negative_corrected,
                    rank() over (partition by country_iso, week, bucket order by share_positive_corrected asc) as share_positive_corrected,
                    rank() over (partition by country_iso, week, bucket order by share_of_no_show asc) as share_of_no_show,
                    rank() over (partition by country_iso, week, bucket order by rider_utr desc) as rider_utr,
                    rank() over (partition by country_iso, week, bucket order by picker_utr desc) as picker_utr,
                    'bucket_rank' as dimension

             from base
             left join buckets using(hub_code)


      ),

      final as (

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    number_of_orders,
                    share_of_orders_with_delta_pdt_less_than_2,
                    share_of_orders_delivered_more_than_20,
                    share_pre_order_swiped,
                    share_post_order_issues,
                    share_of_outbound_skus,
                    share_negative_corrected,
                    share_positive_corrected,
                    share_of_no_show,
                    rider_utr,
                    picker_utr,
                    week





             from last_week

             union all

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    number_of_orders,
                    share_of_orders_with_delta_pdt_less_than_2,
                    share_of_orders_delivered_more_than_20,
                    share_pre_order_swiped,
                    share_post_order_issues,
                    share_of_outbound_skus,
                    share_negative_corrected,
                    share_positive_corrected,
                    share_of_no_show,
                    rider_utr,
                    picker_utr,
                    week

             from pre_last_week

             union all

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    number_of_orders,
                    share_of_orders_with_delta_pdt_less_than_2,
                    share_of_orders_delivered_more_than_20,
                    share_pre_order_swiped,
                    share_post_order_issues,
                    share_of_outbound_skus,
                    share_negative_corrected,
                    share_positive_corrected,
                    share_of_no_show,
                    rider_utr,
                    picker_utr,
                    week

             from wow

             where week =  date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)

             union all

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    number_of_orders,
                    share_of_orders_with_delta_pdt_less_than_2,
                    share_of_orders_delivered_more_than_20,
                    share_pre_order_swiped,
                    share_post_order_issues,
                    share_of_outbound_skus,
                    share_negative_corrected,
                    share_positive_corrected,
                    share_of_no_show,
                    rider_utr,
                    picker_utr,
                    week

             from ranking_country

             where week =  date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)

             union all

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    number_of_orders,
                    share_of_orders_with_delta_pdt_less_than_2,
                    share_of_orders_delivered_more_than_20,
                    share_pre_order_swiped,
                    share_post_order_issues,
                    share_of_outbound_skus,
                    share_negative_corrected,
                    share_positive_corrected,
                    share_of_no_show,
                    rider_utr,
                    picker_utr,
                    week

             from ranking_bucket

             where week =  date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)
      )

      select *

      from final
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: dimension {
    type: string
    sql: ${TABLE}.dimension ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: bucket {
    type: string
    sql: ${TABLE}.bucket ;;
  }

  dimension: number_of_orders {
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: share_of_orders_with_delta_pdt_less_than_2 {
    type: number
    sql: ${TABLE}.share_of_orders_with_delta_pdt_less_than_2 ;;
  }

  dimension: share_of_orders_delivered_more_than_20 {
    type: number
    sql: ${TABLE}.share_of_orders_delivered_more_than_20 ;;
  }

  dimension: share_pre_order_swiped {
    type: number
    sql: ${TABLE}.share_pre_order_swiped ;;
  }

  dimension: share_post_order_issues {
    type: number
    sql: ${TABLE}.share_post_order_issues ;;
  }

  dimension: share_of_outbound_skus {
    type: number
    sql: ${TABLE}.share_of_outbound_skus ;;
  }

  dimension: share_negative_corrected {
    type: number
    sql: ${TABLE}.share_negative_corrected ;;
  }

  dimension: share_positive_corrected {
    type: number
    sql: ${TABLE}.share_positive_corrected ;;
  }

  dimension: share_of_no_show {
    type: number
    sql: ${TABLE}.share_of_no_show ;;
  }

  dimension: rider_utr {
    type: number
    sql: ${TABLE}.rider_utr ;;
  }

  dimension: picker_utr {
    type: number
    sql: ${TABLE}.picker_utr ;;
  }

  dimension: week {
    type: date
    datatype: date
    sql: ${TABLE}.week ;;
  }

  measure: sum_number_of_orders {
    label: "# Orders"
    type: sum
    sql: ${number_of_orders} ;;
  }

  measure: avg_share_of_orders_with_delta_pdt_less_than_2 {
    label: "% Orders < 2min vs PDT"
    description: "Share of orders delivered with a delta <= 2min vs PDT"
    type: average
    sql: ${share_of_orders_with_delta_pdt_less_than_2} ;;
  }

  measure: avg_share_of_orders_delivered_more_than_20 {
    label: "% Orders > 20min"
    description: "Share of Orders delivered in more than 20min"
    type: average
    sql: ${share_of_orders_delivered_more_than_20} ;;
  }

  measure: avg_share_pre_order_swiped {
    label: "% Orders Pre Order Swiped"
    description: "Share of Orders with pre delivery swipe issue"
    type: average
    sql: ${share_pre_order_swiped} ;;
  }

  measure: avg_share_post_order_issues {
    label: "% Orders Post Order Issues"
    description: "Share of Orders with post delivery issues"
    type: average
    sql: ${share_pre_order_swiped} ;;
  }

  measure: avg_rider_utr {
    label: "Rider UTR"
    type: average
    sql: ${rider_utr} ;;
  }

  measure: avg_picker_utr {
    label: "Picker UTR"
    type: average
    sql: ${picker_utr} ;;
  }

  set: detail {
    fields: [
      dimension,
      hub_code,
      country_iso,
      bucket,
      number_of_orders,
      share_of_orders_with_delta_pdt_less_than_2,
      share_of_orders_delivered_more_than_20,
      share_pre_order_swiped,
      share_post_order_issues,
      share_of_outbound_skus,
      share_negative_corrected,
      share_positive_corrected,
      share_of_no_show,
      rider_utr,
      picker_utr,
      week
    ]
  }
}
