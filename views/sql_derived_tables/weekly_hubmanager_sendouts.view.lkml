view: weekly_hubmanager_sendouts {
  derived_table: {
    sql:with
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
                    country_iso,
                    date_trunc(order_date, week(monday)) as week,
                    avg(number_daily_orders) as avg_daily_orders

             from daily_orders

             group by 1 ,2, 3
      ),

      buckets as (
             select hub_code,
                    country_iso,
                    week,
                    case when avg_daily_orders < 200 then '<200'
                         when avg_daily_orders between 200 and 349 then '200-350'
                         when avg_daily_orders between 350 and 499 then '350-500'
                         when avg_daily_orders between 500 and 649 then '500-650'
                         when avg_daily_orders >= 650  then '>650' end as bucket

             from buckets_base

      ),

      total_hubs_country_bucket as (
                select hub_code,
                       country_iso,
                       bucket,
                       week,
                       count(distinct hub_code) over(partition by country_iso, bucket) as number_total_hubs_in_bucket,
                       count(distinct hub_code) over (partition by country_iso) as number_total_hubs_in_country

                from buckets


      ),


      orders as (

             select hub_code,
                    date_trunc(date(order_timestamp),week(monday)) as week,
                    country_iso,
                    count(distinct order_uuid) as number_of_orders,
                    avg(fulfillment_time_minutes) as fulfillment_time_minutes,
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
             staffing_data.* except(week, hub_code),
             total_hubs_country_bucket.number_total_hubs_in_bucket,
             total_hubs_country_bucket.number_total_hubs_in_country,


      from orders

      left join orderline using(hub_code, week)

      left join inventory_tool using(hub_code, week)

      left join staffing_data using(hub_code, week)

      left join total_hubs_country_bucket using(hub_code, week)
      ),

      last_week as (
             select bucket,
                    base.* except(week),
                    base.week,
                    'Last Week' as dimension

             from base

             left join buckets using(hub_code)

             where base.week = date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)


      ),

      pre_last_week as (
             select bucket,
                    base.* except(week) ,
                    date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week) as week,
                    'Previous Week' as dimension

             from base

             left join buckets using(hub_code)

             where base.week = date_sub(date_trunc(current_date(), week(MONDAY)),interval 2 week)


      ),


      WoW as (
             select hub_code,
                    base.country_iso,
                    base.week,
                    bucket,
                    number_total_hubs_in_bucket,
                    number_total_hubs_in_country,
                    ((number_of_orders - lag(number_of_orders,1) over (partition by hub_code order by week asc))/lag(number_of_orders,1) over (partition by hub_code order by week asc))*100 as number_of_orders,
                    ((fulfillment_time_minutes - lag(fulfillment_time_minutes,1) over (partition by hub_code order by week asc))/lag(fulfillment_time_minutes,1) over (partition by hub_code order by week asc))*100  as fulfillment_time_minutes,
                    (share_of_orders_with_delta_pdt_less_than_2 - lag(share_of_orders_with_delta_pdt_less_than_2,1) over (partition by hub_code order by week asc))*100 as share_of_orders_with_delta_pdt_less_than_2,
                    (share_of_orders_delivered_more_than_20 - lag(share_of_orders_delivered_more_than_20,1) over (partition by hub_code order by week asc))*100 as share_of_orders_delivered_more_than_20,
                    (share_pre_order_swiped - lag(share_pre_order_swiped,1) over (partition by hub_code order by week asc))*100 as share_pre_order_swiped,
                    (share_post_order_issues - lag(share_post_order_issues,1) over (partition by hub_code order by week asc))*100 as share_post_order_issues,
                    (share_of_outbound_skus - lag(share_of_outbound_skus,1) over (partition by hub_code order by week asc))*100 as share_of_outbound_skus,
                    (share_negative_corrected - lag(share_negative_corrected,1) over (partition by hub_code order by week asc))*100 as share_negative_corrected,
                    (share_positive_corrected - lag(share_positive_corrected,1) over (partition by hub_code order by week asc))*100 as share_positive_corrected,
                    (share_of_no_show - lag(share_of_no_show,1) over (partition by hub_code order by week asc))*100 as share_of_no_show,
                    round(rider_utr,2) - round(lag(rider_utr,1) over (partition by hub_code order by week asc),2) as rider_utr,
                    round(picker_utr,2) - round(lag(picker_utr,1) over (partition by hub_code order by week asc),2) as picker_utr,



                     'WoW' as dimension

             from base

             left join buckets using(hub_code,week)



      ),


      ranking_country as (
             select hub_code,
                    base.week,
                    buckets.bucket,
                    base.country_iso,
                    number_total_hubs_in_bucket,
                    number_total_hubs_in_country,
                    rank() over (partition by base.country_iso, week order by number_of_orders desc) as number_of_orders,
                    rank() over (partition by base.country_iso, week order by fulfillment_time_minutes desc) as fulfillment_time_minutes,
                    rank() over (partition by base.country_iso, week order by share_of_orders_with_delta_pdt_less_than_2 desc) as share_of_orders_with_delta_pdt_less_than_2,
                    rank() over (partition by base.country_iso, week order by share_of_orders_delivered_more_than_20 asc) as share_of_orders_delivered_more_than_20,
                    rank() over (partition by base.country_iso, week order by share_pre_order_swiped asc) as share_pre_order_swiped,
                    rank() over (partition by base.country_iso, week order by share_post_order_issues asc) as share_post_order_issues,
                    rank() over (partition by base.country_iso, week order by share_of_outbound_skus asc) as share_of_outbound_skus,
                    rank() over (partition by base.country_iso, week order by share_negative_corrected asc) as share_negative_corrected,
                    rank() over (partition by base.country_iso, week order by share_positive_corrected asc) as share_positive_corrected,
                    rank() over (partition by base.country_iso, week order by share_of_no_show asc) as share_of_no_show,
                    rank() over (partition by base.country_iso, week order by rider_utr desc) as rider_utr,
                    rank() over (partition by base.country_iso, week order by picker_utr desc) as picker_utr,
                    'Ranking in Country' as dimension

             from base

             left join buckets using(hub_code, week)


      ),

      ranking_bucket as (
              select hub_code,
                    week,
                    base.country_iso,
                    bucket,
                    number_total_hubs_in_bucket,
                    number_total_hubs_in_country,
                    rank() over (partition by base.country_iso, week, bucket order by number_of_orders desc) as number_of_orders,
                    rank() over (partition by base.country_iso, week, bucket order by fulfillment_time_minutes desc) as fulfillment_time_minutes,
                    rank() over (partition by base.country_iso, week, bucket order by share_of_orders_with_delta_pdt_less_than_2 desc) as share_of_orders_with_delta_pdt_less_than_2,
                    rank() over (partition by base.country_iso, week, bucket order by share_of_orders_delivered_more_than_20 asc) as share_of_orders_delivered_more_than_20,
                    rank() over (partition by base.country_iso, week, bucket order by share_pre_order_swiped asc) as share_pre_order_swiped,
                    rank() over (partition by base.country_iso, week, bucket order by share_post_order_issues asc) as share_post_order_issues,
                    rank() over (partition by base.country_iso, week, bucket order by share_of_outbound_skus asc) as share_of_outbound_skus,
                    rank() over (partition by base.country_iso, week, bucket order by share_negative_corrected asc) as share_negative_corrected,
                    rank() over (partition by base.country_iso, week, bucket order by share_positive_corrected asc) as share_positive_corrected,
                    rank() over (partition by base.country_iso, week, bucket order by share_of_no_show asc) as share_of_no_show,
                    rank() over (partition by base.country_iso, week, bucket order by rider_utr desc) as rider_utr,
                    rank() over (partition by base.country_iso, week, bucket order by picker_utr desc) as picker_utr,
                    'Ranking in Bucket' as dimension

             from base
             left join buckets using(hub_code,week)


      ),

      final as (

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    number_of_orders,
                    fulfillment_time_minutes,
                    share_of_orders_with_delta_pdt_less_than_2,
                    share_of_orders_delivered_more_than_20,
                    share_pre_order_swiped as share_pre_order_swiped,
                    share_post_order_issues as share_post_order_issues,
                    share_of_outbound_skus,
                    share_negative_corrected,
                    share_positive_corrected,
                    share_of_no_show,
                    rider_utr,
                    picker_utr,
                    week,
                    number_total_hubs_in_bucket,
                    number_total_hubs_in_country





             from last_week

             union all

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    number_of_orders,
                    fulfillment_time_minutes,
                    share_of_orders_with_delta_pdt_less_than_2,
                    share_of_orders_delivered_more_than_20,
                    share_pre_order_swiped as share_pre_order_swiped,
                    share_post_order_issues as share_post_order_issues,
                    share_of_outbound_skus,
                    share_negative_corrected,
                    share_positive_corrected,
                    share_of_no_show,
                    rider_utr,
                    picker_utr,
                    week,
                    number_total_hubs_in_bucket,
                    number_total_hubs_in_country

             from pre_last_week

             union all

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    round(number_of_orders,1) as number_of_orders,
                    round(fulfillment_time_minutes,1) as fulfillment_time_minutes,
                    round(share_of_orders_with_delta_pdt_less_than_2,1) as share_of_orders_with_delta_pdt_less_than_2 ,
                    round(share_of_orders_delivered_more_than_20,1) as share_of_orders_delivered_more_than_20 ,
                    round(share_pre_order_swiped,1)   as share_pre_order_swiped,
                    round(share_post_order_issues,1)  as share_post_order_issues,
                    round(share_of_outbound_skus,1)   as share_of_outbound_skus,
                    round(share_negative_corrected,1) as share_negative_corrected,
                    round(share_positive_corrected,1) as share_positive_corrected,
                    round(share_of_no_show,1) as share_of_no_show,
                    round(rider_utr,2)  as rider_utr,
                    round(picker_utr,2) as picker_utr,
                    week,
                    number_total_hubs_in_bucket,
                    number_total_hubs_in_country

             from WoW

             where week =  date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)

             union all

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    number_of_orders,
                    round(fulfillment_time_minutes,0) as fulfillment_time_minutes,
                    round(share_of_orders_with_delta_pdt_less_than_2,0) as share_of_orders_with_delta_pdt_less_than_2 ,
                    round(share_of_orders_delivered_more_than_20,0) as share_of_orders_delivered_more_than_20 ,
                    round(share_pre_order_swiped,0) as share_pre_order_swiped,
                    round(share_post_order_issues,0) as share_post_order_issues,
                    round(share_of_outbound_skus,0) as share_of_outbound_skus,
                    round(share_negative_corrected,0) as share_negative_corrected,
                    round(share_positive_corrected,0) as share_positive_corrected,
                    round(share_of_no_show,0) as share_of_no_show,
                    round(rider_utr,0) as rider_utr,
                    round(picker_utr,0) as picker_utr,
                    week,
                    number_total_hubs_in_bucket,
                    number_total_hubs_in_country

             from ranking_country

             where week =  date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)

             union all

             select dimension,
                    hub_code,
                    country_iso,
                    bucket,
                    number_of_orders,
                    fulfillment_time_minutes,
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
                    week,
                    number_total_hubs_in_bucket,
                    number_total_hubs_in_country

             from ranking_bucket

             where week =  date_sub(date_trunc(current_date(), week(MONDAY)),interval 1 week)
      )

      select *

      from final;;
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
    sql: concat(${TABLE}.bucket, ' AVG Daily Orders') ;;
  }

  dimension: uuid {
    type: string
    primary_key: yes
    sql: concat(${hub_code},${week},${dimension}) ;;
  }

  dimension: number_of_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: share_of_orders_with_delta_pdt_less_than_2 {
    type: number
    hidden: yes
    sql: ${TABLE}.share_of_orders_with_delta_pdt_less_than_2 ;;
  }

  dimension: share_of_orders_delivered_more_than_20 {
    type: number
    hidden: yes
    sql: ${TABLE}.share_of_orders_delivered_more_than_20 ;;
  }

  dimension: share_pre_order_swiped {
    type: number
    hidden: yes
    sql: ${TABLE}.share_pre_order_swiped ;;
  }

  dimension: fulfillment_time_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.fulfillment_time_minutes ;;
  }

  dimension: share_post_order_issues {
    type: number
    hidden: yes
    sql: ${TABLE}.share_post_order_issues ;;
  }

  dimension: share_of_outbound_skus {
    hidden: yes
    type: number
    sql: ${TABLE}.share_of_outbound_skus ;;
  }

  dimension: share_negative_corrected {
    type: number
    hidden: yes
    sql: ${TABLE}.share_negative_corrected ;;
  }

  dimension: share_positive_corrected {
    type: number
    hidden: yes
    sql: ${TABLE}.share_positive_corrected ;;
  }

  dimension: share_of_no_show {
    type: number
    hidden: yes
    sql: ${TABLE}.share_of_no_show ;;
  }

  dimension: rider_utr {
    type: number
    hidden: yes
    sql: ${TABLE}.rider_utr ;;
  }

  dimension: picker_utr {
    type: number
    hidden: yes
    sql: ${TABLE}.picker_utr ;;
  }

  dimension: week {
    type: date
    datatype: date
    sql: ${TABLE}.week ;;
  }

  dimension: number_total_hubs_in_bucket {
    type: number
    value_format: "0"
    sql: ${TABLE}.number_total_hubs_in_bucket ;;
  }

  dimension: number_total_hubs_in_country {
    type: number
    value_format: "0"
    sql: ${TABLE}.number_total_hubs_in_country ;;
  }



  ################ Measures

    measure: avg_number_total_hubs_in_bucket {
      type: average
      value_format: "0"
      sql: ${number_total_hubs_in_bucket} ;;
    }

    measure: avg_number_total_hubs_in_country {
      type: average
      value_format: "0"
      sql: ${number_total_hubs_in_country} ;;
    }

  measure: first_tier_country {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_country}/3 ;;
  }

  measure: second_tier_country {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_country}/3*2 ;;
  }

  measure: third_tier_country {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_country} ;;
  }

  measure: first_tier_bucket {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_bucket}/3 ;;
  }

  measure: second_tier_bucket {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_bucket}/3*2 ;;
  }

  measure: third_tier_bucket {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_bucket} ;;
  }

  measure: sum_number_of_orders {
    label: "# Orders"
    type: sum
    value_format: "0"
    sql: ${number_of_orders} ;;
    html: {% if dimension._value == 'WoW' and value > 0 %}
    <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>+{{ value }} %</p>
    {% elsif dimension._value == 'WoW' and value < 0 %}
     <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>{{ value }} %</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Bucket' %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
     {% elsif dimension._value == 'Ranking in Country'  %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% else %}
    {{ rendered_value }}
    {% endif %} ;;
  }

  measure: avg_share_of_orders_with_delta_pdt_less_than_2 {
    label: "% Orders < 2min vs PDT"
    description: "Share of orders delivered with a delta <= 2min vs PDT"
    type: average
    sql: ${share_of_orders_with_delta_pdt_less_than_2} ;;
    value_format: "0.0%"
    html: {% if dimension._value == 'WoW' and value > 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>+{{ value }} pp</p>
          {% elsif dimension._value == 'WoW' and value < 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>{{ value }} pp</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
          {% else %}
          {{rendered_value}}
          {% endif %}  ;;
  }



  measure: avg_fulfillment_time_mimutes {
    label: "AVG Fulfillment Time"
    type: average
    sql: ${fulfillment_time_minutes} ;;
    value_format: "0.0"
    html: {% if dimension._value == 'WoW' and value < 0 %}
    <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }}% </p>
    {% elsif dimension._value == 'WoW' and value > 0 %}
     <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }}%</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Bucket' %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
     {% elsif dimension._value == 'Ranking in Country'  %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% else %}
    {{rendered_value}}
    {% endif %}  ;;
  }

  measure: avg_share_of_orders_delivered_more_than_20 {
    label: "% Orders > 20min"
    description: "Share of Orders delivered in more than 20min"
    type: average
    value_format: "0.0%"
    sql: ${share_of_orders_delivered_more_than_20} ;;
    html: {% if dimension._value == 'WoW' and value < 0 %}
    <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }} pp</p>
    {% elsif dimension._value == 'WoW' and value > 0 %}
     <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }} pp</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Bucket' %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
     {% elsif dimension._value == 'Ranking in Country'  %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% else %}
    {{rendered_value}}
    {% endif %} ;;
  }


  measure: avg_share_pre_order_swiped {
    label: "% Orders Pre Order Swiped"
    description: "Share of Orders with pre delivery swipe issue"
    type: average
    value_format: "0.0%"
    sql: ${share_pre_order_swiped} ;;
    html: {% if dimension._value == 'WoW' and value < 0 %}
    <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }} pp</p>
    {% elsif dimension._value == 'WoW' and value > 0 %}
     <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }} pp</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Bucket' %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
     {% elsif dimension._value == 'Ranking in Country'  %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% else %}
    {{rendered_value}}
    {% endif %};;
   }

  measure: avg_share_post_order_issues {
    label: "% Orders Post Order Issues"
    description: "Share of Orders with post delivery issues"
    type: average
    value_format: "0.0%"
    sql: ${share_post_order_issues} ;;
    html:  {% if dimension._value == 'WoW' and value < 0 %}
    <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }} pp</p>
    {% elsif dimension._value == 'WoW' and value > 0 %}
     <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }} pp</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Bucket' %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
     {% elsif dimension._value == 'Ranking in Country'  %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% else %}
    {{ rendered_value }}
    {% endif %} ;;
  }

  measure: avg_rider_utr {
    label: "Rider UTR"
    type: average
    value_format: "0.00"
    sql: ${rider_utr} ;;
    html: {% if dimension._value == 'WoW' and value > 0 %}
    <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>+{{ rendered_value }}</p>
    {% elsif dimension._value == 'WoW' and value < 0 %}
     <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>{{ rendered_value }}</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Bucket' %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
     {% elsif dimension._value == 'Ranking in Country'  %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% endif %};;
  }

  measure: avg_picker_utr {
    label: "Picker UTR"
    type: average
    value_format: "0.00"
    sql: ${picker_utr} ;;
    html: {% if dimension._value == 'WoW' and value > 0 %}
    <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>+{{ rendered_value }}</p>
    {% elsif dimension._value == 'WoW' and value < 0 %}
     <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>{{ rendered_value }}</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
    {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Bucket' %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_bucket._value}}</p>
     {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
    <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
    <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
     {% elsif dimension._value == 'Ranking in Country'  %}
    <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value}} / {{avg_number_total_hubs_in_country._value}}</p>
    {% endif %};;
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
