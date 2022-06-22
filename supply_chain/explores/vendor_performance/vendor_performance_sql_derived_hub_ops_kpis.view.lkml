view: vendor_performance_sql_derived_hub_ops_kpis {
  derived_table: {
    sql:
    with
desadv as (
    select
          delivery_date
        , dispatch_notification_id
        , estimated_delivery_timestamp
        , hub_code
        , sku
        , sum(total_quantity) as num_selling_units
    from curated.dispatch_notifications
    where true
        and sku is not null

    group by 1,2,3,4,5
),

inbound as (
    select
             date(inventory_changes.inventory_change_timestamp) as report_date
           , inventory_changes.hub_code
           , products.replenishment_substitute_group_parent_sku as parent_sku
             -- in case 2 items of a RSG belong to one of the category and one not, take TRUE
           , max(products.category in (
                      'Groente & Aardappelen'
                    , 'Fruits'
                    , 'Obst & Gemüse'
                    , 'Légumes'
                    , 'Fruit'))                                as is_fruit_or_veggie
           , sum(inventory_changes.quantity_change)            as num_inbouded
           , max(inventory_changes.inventory_change_timestamp) as max_inbound_ts
           , min(inventory_changes.inventory_change_timestamp) as min_inbound_ts
    from curated.inventory_changes
    left join curated.products
    on
        products.product_sku = inventory_changes.sku
    where
        is_inbound

    group by 1,2,3
),

combine_data as (
    select
          desadv.delivery_date
        , desadv.dispatch_notification_id
        , desadv.estimated_delivery_timestamp
        , desadv.hub_code
        , desadv.sku
        , desadv.num_selling_units
        , inbound.is_fruit_or_veggie
        , inbound.num_inbouded
        , inbound.max_inbound_ts
        , TIMESTAMP_DIFF(inbound.max_inbound_ts, desadv.estimated_delivery_timestamp, minute) / 60   as hours_delivery_to_inbound
        , TIMESTAMP_DIFF(inbound.max_inbound_ts, desadv.estimated_delivery_timestamp, minute) <= 120 as is_inbounded_in_2h
        , TIMESTAMP_DIFF(inbound.max_inbound_ts, desadv.estimated_delivery_timestamp, minute) <= 180 as is_inbounded_in_3h
        , count(distinct desadv.dispatch_notification_id)
                over (partition by desadv.delivery_date,
                                   desadv.hub_code,
                                   desadv.sku)                      as num_desadvs_per_sku_delivered_same_day
        , sum(num_selling_units)
                over (partition by desadv.dispatch_notification_id) as total_desadv_items
        , sum(inbound.num_inbouded)
                over (partition by desadv.dispatch_notification_id
                          order by max_inbound_ts)                  as run_sum_inbounded_items
        , sum(num_selling_units)
                over (partition by desadv.dispatch_notification_id,
                                   is_fruit_or_veggie)              as total_desadv_items_fruit_and_veggy
        , sum(inbound.num_inbouded)
                over (partition by desadv.dispatch_notification_id,
                                   is_fruit_or_veggie
                          order by max_inbound_ts)                  as run_sum_inbounded_items_fruit_and_veggy
    from desadv
    left join inbound
    on
        inbound.report_date = desadv.delivery_date
    and inbound.hub_code    = desadv.hub_code
    and inbound.parent_sku  = desadv.sku
),

define_percent_inbounded as (
    select
          *
        , safe_divide(run_sum_inbounded_items, total_desadv_items) as pct_inbounded

    from combine_data
),

define_90_percent_inbounded as (

    select
          *
          -- when the current row is 90 percent inbounded or more and the row before has less than 90%, then this is the time/SKU what was inbounded 90%
        , pct_inbounded >= 0.9 and
          (lag(pct_inbounded)
               over (partition by dispatch_notification_id
                   order by max_inbound_ts) < 0.9
              or
           lag(pct_inbounded)
               over (partition by dispatch_notification_id
                   order by max_inbound_ts) is null
        ) as is_90_percent_inbounded


    from define_percent_inbounded
),

define_core_hub_ops_metrics as (

        select
              *
            , if (is_inbounded_in_3h is true and
                  is_fruit_or_veggie is true,
                  safe_divide(run_sum_inbounded_items_fruit_and_veggy,
                              total_desadv_items_fruit_and_veggy),
                  null)                                                 as percent_inbounded_fruit_and_veggy_in_3_hours_per_desadv
            , if (is_inbounded_in_2h is true and
                  is_fruit_or_veggie is true,
                  safe_divide(run_sum_inbounded_items_fruit_and_veggy,
                              total_desadv_items_fruit_and_veggy),
                  null)                                                 as percent_inbounded_fruit_and_veggy_in_2_hours_per_desadv
            , if (is_90_percent_inbounded is true,
                  hours_delivery_to_inbound,
                  null)                                                 as hours_needed_to_inbound_90_percent_per_desadv
        from  define_90_percent_inbounded
),

final_table as (

        select
              dispatch_notification_id
            , max(percent_inbounded_fruit_and_veggy_in_3_hours_per_desadv) as percent_inbounded_fruit_and_veggy_in_3_hours_per_desadv
            , max(percent_inbounded_fruit_and_veggy_in_2_hours_per_desadv) as percent_inbounded_fruit_and_veggy_in_2_hours_per_desadv
            , max(hours_needed_to_inbound_90_percent_per_desadv)           as hours_needed_to_inbound_90_percent_per_desadv
        from define_core_hub_ops_metrics
        group by 1
)

select * from final_table
      ;;
  }

  dimension: dispatch_notification_id {
    hidden: yes
    primary_key: yes
  }

  dimension: percent_inbounded_fruit_and_veggy_in_3_hours_per_desadv { hidden: yes}
  dimension: percent_inbounded_fruit_and_veggy_in_2_hours_per_desadv { hidden: yes}
  dimension: hours_needed_to_inbound_90_percent_per_desadv { hidden: yes }

  measure: avg_percent_FaV_inbounded_in_3_h {

    label: "AVG F&V Inbounded in 3h"
    description: "This metric shows, how many items in the fruits and vegetables group are inbounded within the first 3 hours since delivery. The metric is an average across dispatch notifications (DESADVs)"
    group_label: "Inbounding Performance"

    type: average
    sql: ${percent_inbounded_fruit_and_veggy_in_3_hours_per_desadv} ;;
    value_format_name: percent_1
  }

  measure: avg_percent_FaV_inbounded_in_2_h {

    label: "AVG F&V Inbounded in 2h"
    description: "This metric shows, how many items in the fruits and vegetables group are inbounded within the first 2 hours since delivery. The metric is an average across dispatch notifications (DESADVs)"
    group_label: "Inbounding Performance"

    type: average
    sql: ${percent_inbounded_fruit_and_veggy_in_2_hours_per_desadv} ;;
    value_format_name: percent_1
  }

  measure: hours_needed_to_inbound_90_percent {

    label: "AVG Hours to Inbound 90% Delivery"
    description: "This metric shows, how many hours are needed to inbound 90% of a related dispatch notification. If the dispatch notification was not inbounded at least to a degree of 90%, this field is empty. The metric is an average across dispatch notifications (DESADVs)"
    group_label: "Inbounding Performance"

    type: average
    sql: ${hours_needed_to_inbound_90_percent_per_desadv} ;;
    value_format_name: decimal_1
  }



}
