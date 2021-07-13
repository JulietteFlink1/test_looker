include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"


# TODO
# extract base explore
# add ndt for num hubs
# add ndt for equalized_rev
# use bind_all_filters (and only have ndts on min-level)
# make table-calcs on new or eqalized-rev ndt
#expl

# explore: retail_kpis_per_dims {
#   hidden: yes
# }

explore: retail_kpis {
  label: "SKU Analytics"
  group_label: "15) Ad-Hoc"
  hidden: yes
}

explore: listed_skus_in_hubs {
  hidden: yes
}

explore: shelf_planning {
  hidden: yes
  aggregate_table: rollup__hub_code__product_name__sku {
    query: {
      dimensions: [hub_code, product_name, sku]
      measures: [avg_main_kpis, avg_max_sum_item_quantity, avg_median_sum_item_quantity, avg_num_3d_windows, avg_stock_over_days_3d_windows_total_time, avg_sum_item_quantity, percentile_sum_item_quantity, std_sum_item_quantity]
      filters: [shelf_planning.date_filter: "5 weeks"]
      timezone: "Europe/Berlin"
    }

    materialization: {
      datagroup_trigger: flink_default_datagroup
    }
  }

  join: hubs_clean {
    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs_clean.hub_code_lowercase} = ${shelf_planning.hub_code} ;;
    fields: [hubs_clean.city, hubs_clean.country_iso, hubs_clean.hub_name, hubs_clean.hub_code_lowercase]
  }
  join: product_facts {
    type: left_outer
    relationship: many_to_one
    sql_on:  ${product_facts.sku}         = ${shelf_planning.sku}
       and   ${product_facts.country_iso} = ${hubs_clean.country_iso}
      ;;
  }

  join: shelf_planning_top_x_per_subcat {
    type: left_outer
    relationship: many_to_one
    sql_on: ${shelf_planning_top_x_per_subcat.sku} = ${shelf_planning.sku} ;;
    fields: [shelf_planning_top_x_per_subcat.rank_per_subcat, shelf_planning_top_x_per_subcat.sku]
  }
}


explore: retail_orders_explore {
  from: order_order
  hidden: yes
  label: "Retail SKU Explore"
  always_filter: {
    filters:  [
      hubs.country: "",
      hubs.hub_name: "",
      retail_orders_explore.is_internal_order: "no",
      retail_orders_explore.is_successful_order: "yes",
      retail_orders_explore.created_date: "after 2021-01-25"
    ]
  }
  aggregate_table: test_agg {
    query: {
      dimensions: [
        retail_orders_explore.created_date ,
        parent_category.name,
        product_category.name,
        order_orderline.product_name,
        order_orderline.product_sku
        ]
      measures: [
        retail_kpis_equalized_revenue._measures*,
        retail_kpis_rev_per_subcat._measures*,
        retail_kpis_rev_per_total._measures*,
        daily_historical_stock_levels._measures*
        ]
        filters: [
          hubs.city: "",
          hubs.country: "",
          hubs.country_iso: "",
          hubs.hub_code: "",
          hubs.hub_code_lowercase: "",
          retail_orders_explore.is_internal_order: "no",
          retail_orders_explore.is_successful_order: "yes",
          retail_orders_explore.created_date: "after 2021-05-01",
        ]
        sorts: [
          retail_orders_explore.created_date: desc,
          parent_category.name: asc,
          product_category.name: asc,
          order_orderline.product_sku: asc
        ]

        timezone: "Europe/Berlin"
    }
    materialization: {
      sql_trigger_value: SELECT CURRENT_DATE() ;;
    }

  }

  fields: [

    retail_orders_explore.is_internal_order,
    retail_orders_explore.is_successful_order,
    retail_orders_explore.created_date,


    order_orderline.country_iso,
    order_orderline.order_id,
    order_orderline.sum_item_price_net,
    order_orderline.sum_item_quantity,
    order_orderline.ctn_skus,
    order_orderline.product_sku,
    order_orderline.product_name,

    hubs.city,
    hubs.country_iso,
    hubs.country,
    hubs.hub_code,
    hubs.hub_code_lowercase,
    hubs.hub_name,

    parent_category.name,
    product_category.name,
    product_product.name,

    retail_kpis_hubs_and_rev_on_sku_date_level.export_fields*,

    retail_kpis_hubs_and_rev_on_sku_date_level.created_date,
    retail_kpis_hubs_and_rev_on_sku_date_level.product_sku,

    retail_kpis_equalized_revenue._measures*,
    retail_kpis_rev_per_subcat._measures*,
    retail_kpis_rev_per_total._measures*,
    daily_historical_stock_levels._measures*
    # retail_kpis_order_metrics._metrics*,
    # retail_kpis_order_metrics.order_id

  ]

  # fields: [
  #   ALL_FIELDS*,
  #   -retail_orders_explore.exclude_dims_as_that_cross_reference*


  #   # -retail_orders_explore.years_time_since_sign_up,
  #   # -retail_orders_explore.quarters_time_since_sign_up,
  #   # -retail_orders_explore.months_time_since_sign_up,
  #   # -retail_orders_explore.weeks_time_since_sign_up,
  #   # -retail_orders_explore.days_time_since_sign_up,
  #   # -retail_orders_explore.hours_time_since_sign_up,
  #   # -retail_orders_explore.minutes_time_since_sign_up,
  #   # -retail_orders_explore.seconds_time_since_sign_up,
  #   # -retail_orders_explore.years_time_between_sign_up_month_and_now,
  #   # -retail_orders_explore.quarters_time_between_sign_up_month_and_now,
  #   # -retail_orders_explore.months_time_between_sign_up_month_and_now,

  #   # -retail_orders_explore.weeks_time_between_sign_up_month_and_now,
  #   # -retail_orders_explore.days_time_between_sign_up_month_and_now,
  #   # -retail_orders_explore.hours_time_between_sign_up_month_and_now,
  #   # -retail_orders_explore.minutes_time_between_sign_up_month_and_now,
  #   # -retail_orders_explore.years_time_between_sign_up_week_and_now,

  #   # -retail_orders_explore.seconds_time_between_sign_up_month_and_now,
  #   # -retail_orders_explore.quarters_time_between_sign_up_week_and_now,
  #   # -retail_orders_explore.months_time_between_sign_up_week_and_now,
  #   # -retail_orders_explore.weeks_time_between_sign_up_week_and_now,
  #   # -retail_orders_explore.days_time_between_sign_up_week_and_now,
  #   # -retail_orders_explore.hours_time_between_sign_up_week_and_now,
  #   # -retail_orders_explore.minutes_time_between_sign_up_week_and_now,
  #   # -retail_orders_explore.seconds_time_between_sign_up_week_and_now,
  #   # -retail_orders_explore.years_time_between_hub_launch_and_order,
  #   # -retail_orders_explore.quarters_time_between_hub_launch_and_order,
  #   # -retail_orders_explore.months_time_between_hub_launch_and_order,
  #   # -retail_orders_explore.weeks_time_between_hub_launch_and_order,

  #   # -retail_orders_explore.days_time_between_hub_launch_and_order,
  #   # -retail_orders_explore.hours_time_between_hub_launch_and_order,
  #   # -retail_orders_explore.minutes_time_between_hub_launch_and_order,
  #   # -retail_orders_explore.seconds_time_between_hub_launch_and_order,
  #   # -retail_orders_explore.customer_type,
  #   # -retail_orders_explore.KPI,
  #   # -retail_orders_explore.reaction_time,
  #   # -retail_orders_explore.acceptance_time,
  #   # -retail_orders_explore.time_diff_between_two_subsequent_fulfillments,

  #   # -retail_orders_explore.avg_picking_time,
  #   # -retail_orders_explore.avg_acceptance_time,
  #   # -retail_orders_explore.hub_location,

  #   # -retail_orders_explore.cnt_unique_orders_existing_customers,
  #   # -retail_orders_explore.cnt_unique_orders_new_customers,
  #   # -retail_orders_explore.avg_reaction_time,

  #   # -retail_orders_explore.delivery_distance_m,
  #   # -retail_orders_explore.delivery_distance_km

  # ]


  # access_filter: {
  #   field: retail_orders_explore.country_iso
  #   user_attribute: country_iso
  # }

  # access_filter: {
  #   field: hubs.city
  #   user_attribute: city
  # }

  # #filter Investor user so they can only see completed calendar weeks data and not week to date
  # sql_always_where: CASE WHEN ({{ _user_attributes['id'] }}) = 28 THEN ${retail_orders_explore.created_week} < ${now_week} ELSE 1=1 END;;


  join: order_orderline {
    sql_on: ${order_orderline.country_iso} = ${retail_orders_explore.country_iso} AND
      ${order_orderline.order_id} = ${retail_orders_explore.id} ;;
    relationship: one_to_many
    type: left_outer

  }

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${retail_orders_explore.country_iso} = ${hubs.country_iso} AND
      ${retail_orders_explore.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
    fields: [
      hubs.city,
      hubs.country_iso,
      hubs.country,
      hubs.hub_code,
      hubs.hub_code_lowercase,
      hubs.hub_name
    ]
  }

  join: product_productvariant {
    sql_on: ${order_orderline.country_iso} = ${product_productvariant.country_iso} AND
      ${order_orderline.product_sku} = ${product_productvariant.sku} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_product {
    sql_on: ${product_productvariant.country_iso} = ${product_product.country_iso} AND
      ${product_productvariant.product_id} = ${product_product.id} ;;
    relationship: one_to_one
    type: left_outer
    fields: [product_product.name]
  }

  join: product_category {
    view_label: "* Sub Category Data *"
    sql_on: ${product_category.country_iso} = ${product_product.country_iso} AND
      ${product_category.id} = ${product_product.category_id} ;;
    relationship: one_to_one
    type: left_outer
    fields: [product_category.name]
  }

  join: parent_category {
    view_label: "* Parent Category Data *"
    from: product_category
    sql_on: ${product_category.country_iso} = ${parent_category.country_iso} AND
      ${product_category.parent_id} = ${parent_category.id} ;;
    relationship: one_to_one
    type: left_outer
    fields: [parent_category.name]

  }

  join: retail_kpis_hubs_and_rev_on_sku_date_level {
    type: left_outer
    view_label: "SKU+Date Level Aggregations"
    relationship: many_to_one
    sql_on:  ${retail_kpis_hubs_and_rev_on_sku_date_level.product_sku}  = ${order_orderline.product_sku}        and
             ${retail_kpis_hubs_and_rev_on_sku_date_level.created_date} = ${retail_orders_explore.created_date}
            ;;
  }

  join: retail_kpis_equalized_revenue {
    view_label: "SKU+Date Level Aggregations"
    type: left_outer
    relationship: many_to_one
    sql_on:  ${retail_kpis_hubs_and_rev_on_sku_date_level.product_sku}  = ${retail_kpis_equalized_revenue.product_sku}  and
             ${retail_kpis_hubs_and_rev_on_sku_date_level.created_date} = ${retail_kpis_equalized_revenue.created_date}
    ;;

  }

  join: retail_kpis_rev_per_subcat {
    view_label: "High-Level Level Aggregations"
    type: left_outer
    relationship: many_to_one
    sql_on:   ${retail_kpis_rev_per_subcat.created_date} = ${retail_orders_explore.created_date} and
              ${retail_kpis_rev_per_subcat.sub_category_name} = ${product_category.name};;

  }

  join: retail_kpis_rev_per_total {
    view_label: "High-Level Level Aggregations"
    type: left_outer
    relationship: many_to_one
    sql_on:   ${retail_kpis_rev_per_total.created_date} = ${retail_orders_explore.created_date} ;;

  }

  join: daily_historical_stock_levels {
    view_label: "Out-Of-Stock Metrics"
    type: left_outer
    relationship: many_to_one
    sql_on: ${daily_historical_stock_levels.hub_code} = ${hubs.hub_code_lowercase} and
            ${daily_historical_stock_levels.sku}      = ${order_orderline.product_sku} and
            ${daily_historical_stock_levels.tracking_date} = ${retail_orders_explore.created_date}
    ;;

  }
  # join: retail_kpis_order_metrics {
  #   view_label: "Basket Information"
  #   type: left_outer
  #   relationship: many_to_one
  #   sql: ${order_orderline.order_id} = ${retail_kpis_order_metrics.order_id} ;;
  # }

  # join: retail_kpis_per_dims {
  #   view_label: "TESt"
  #   type: left_outer
  #   relationship: many_to_one
  #   sql:  ${retail_kpis_per_dims.created_date} = ${retail_orders_explore.created_date}    and
  #         ${retail_kpis_per_dims.product_sku}  = ${order_orderline.product_sku}
  #         ;;
  # }

}
