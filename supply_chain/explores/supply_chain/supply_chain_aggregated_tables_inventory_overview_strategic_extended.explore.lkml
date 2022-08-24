# # this file creates aggregated tables for the dashbaord Inventory Overview (strategic - extended metrics)
# # https://goflink.cloud.looker.com/dashboards/1618


# include: "/**/supply_chain.explore"


# # Place in `flink_v3` model
# explore: +supply_chain {
#   aggregate_table: rollup__hubs_ct_city__hubs_ct_country__hubs_ct_country_iso__hubs_ct_hub_code__hubs_ct_start_date__key_value_items_is_kvi__lexbizz_item_max_shelf_life_days__products_category__products_product_brand__products_subcategory__products_hub_assi__0 {
#     query: {
#       dimensions: [
#         hubs_ct.city,
#         hubs_ct.country,
#         hubs_ct.country_iso,
#         hubs_ct.hub_code,
#         hubs_ct.start_date,
#         key_value_items.is_kvi,
#         lexbizz_item.max_shelf_life_days,
#         products.category,
#         products.product_brand,
#         products.subcategory,
#         products_hub_assignment.erp_vendor_name,
#         products_hub_assignment.leading_sku_replenishment_substitute_group,
#         products_hub_assignment.sku_dynamic
#       ]
#       measures: [inventory_daily.pct_in_stock]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__hubs_ct_city__hubs_ct_country_iso__hubs_ct_hub_code__hubs_ct_start_date__key_value_items_is_kvi__lexbizz_item_max_shelf_life_days__products_category__products_product_brand__products_subcategory__products_hub_assignment_country_is__1 {
#     query: {
#       dimensions: [
#         hubs_ct.city,
#         hubs_ct.country_iso,
#         hubs_ct.hub_code,
#         hubs_ct.start_date,
#         key_value_items.is_kvi,
#         lexbizz_item.max_shelf_life_days,
#         products.category,
#         products.product_brand,
#         products.subcategory,
#         products_hub_assignment.country_iso,
#         products_hub_assignment.erp_vendor_name,
#         products_hub_assignment.leading_sku_replenishment_substitute_group,
#         products_hub_assignment.sku_dynamic
#       ]
#       measures: [inventory_daily.avg_inventory, inventory_daily.pct_oos, inventory_daily.sum_of_total_correction, inventory_daily.sum_of_total_inbound, inventory_daily.sum_of_total_outbound, inventory_daily.turnover_rate]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__hubs_ct_city__hubs_ct_country_iso__hubs_ct_hub_code__hubs_ct_start_date__key_value_items_is_kvi__lexbizz_item_max_shelf_life_days__products_category__products_product_brand__products_subcategory__products_hub_assignment_erp_vendor__2 {
#     query: {
#       dimensions: [
#         hubs_ct.city,
#         hubs_ct.country_iso,
#         hubs_ct.hub_code,
#         hubs_ct.start_date,
#         key_value_items.is_kvi,
#         lexbizz_item.max_shelf_life_days,
#         products.category,
#         products.product_brand,
#         products.subcategory,
#         products_hub_assignment.erp_vendor_name,
#         products_hub_assignment.leading_sku_replenishment_substitute_group,
#         products_hub_assignment.sku_dynamic
#       ]
#       measures: [inventory_daily.avg_inventory, inventory_daily.pct_oos, inventory_daily.sum_of_total_correction, inventory_daily.sum_of_total_inbound, inventory_daily.sum_of_total_outbound, inventory_daily.turnover_rate]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__hubs_ct_city__hubs_ct_country_iso__hubs_ct_hub_code__hubs_ct_start_date__key_value_items_is_kvi__lexbizz_item_max_shelf_life_days__products_category__products_product_brand__products_subcategory__products_hub_assignment_erp_vendor__3 {
#     query: {
#       dimensions: [
#         hubs_ct.city,
#         hubs_ct.country_iso,
#         hubs_ct.hub_code,
#         hubs_ct.start_date,
#         key_value_items.is_kvi,
#         lexbizz_item.max_shelf_life_days,
#         products.category,
#         products.product_brand,
#         products.subcategory,
#         products_hub_assignment.erp_vendor_name,
#         products_hub_assignment.leading_sku_replenishment_substitute_group,
#         products_hub_assignment.sku_dynamic
#       ]
#       measures: [inventory_daily.avg_inventory, inventory_daily.pct_oos, inventory_daily.sum_of_total_correction, inventory_daily.sum_of_total_inbound, inventory_daily.sum_of_total_outbound, inventory_daily.turnover_rate]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__hubs_ct_city__hubs_ct_country_iso__hubs_ct_hub_code__hubs_ct_hub_name__hubs_ct_start_date__key_value_items_is_kvi__lexbizz_item_max_shelf_life_days__products_category__products_product_brand__products_subcategory__products_hub_ass__4 {
#     query: {
#       dimensions: [
#         hubs_ct.city,
#         hubs_ct.country_iso,
#         hubs_ct.hub_code,
#         hubs_ct.hub_name,
#         hubs_ct.start_date,
#         key_value_items.is_kvi,
#         lexbizz_item.max_shelf_life_days,
#         products.category,
#         products.product_brand,
#         products.subcategory,
#         products_hub_assignment.erp_vendor_name,
#         products_hub_assignment.leading_sku_replenishment_substitute_group,
#         products_hub_assignment.sku_dynamic
#       ]
#       measures: [inventory_daily.avg_inventory, inventory_daily.pct_oos, inventory_daily.sum_of_total_correction, inventory_daily.sum_of_total_inbound, inventory_daily.sum_of_total_outbound, inventory_daily.turnover_rate]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__inventory_daily_report_date_dynamic__products_hub_assignment_erp_vendor_name__5 {
#     query: {
#       dimensions: [inventory_daily.report_date_dynamic, products_hub_assignment.erp_vendor_name]
#       measures: [inventory_changes_daily.pct_waste_quote_items, inventory_daily.pct_in_stock]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         inventory_daily.report_date_dynamic: "-NULL",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__hubs_ct_hub_code__hubs_ct_hub_name__inventory_daily_report_date_dynamic__6 {
#     query: {
#       dimensions: [hubs_ct.hub_code, hubs_ct.hub_name, inventory_daily.report_date_dynamic]
#       measures: [inventory_changes_daily.pct_waste_quote_items, inventory_daily.pct_in_stock]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         inventory_daily.report_date_dynamic: "-NULL",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__inventory_daily_report_date_dynamic__products_product_brand__7 {
#     query: {
#       dimensions: [inventory_daily.report_date_dynamic, products.product_brand]
#       measures: [inventory_changes_daily.pct_waste_quote_items, inventory_daily.pct_in_stock]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         inventory_daily.report_date_dynamic: "-NULL",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__inventory_daily_report_date_dynamic__products_subcategory__8 {
#     query: {
#       dimensions: [inventory_daily.report_date_dynamic, products.subcategory]
#       measures: [inventory_changes_daily.pct_waste_quote_items, inventory_daily.pct_in_stock]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         inventory_daily.report_date_dynamic: "-NULL",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__inventory_daily_report_date_dynamic__products_category__9 {
#     query: {
#       dimensions: [inventory_daily.report_date_dynamic, products.category]
#       measures: [inventory_changes_daily.pct_waste_quote_items, inventory_daily.pct_in_stock]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         inventory_daily.report_date_dynamic: "-NULL",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__hubs_ct_hub_code__inventory_daily_report_date_dynamic__products_category__products_subcategory__products_hub_assignment_replenishment_substitute_group__products_hub_assignment_sku_dynamic__products_hub_assignment_substitute_group__10 {
#     query: {
#       dimensions: [
#         hubs_ct.hub_code,
#         inventory_daily.report_date_dynamic,
#         products.category,
#         products.subcategory,
#         products_hub_assignment.replenishment_substitute_group,
#         products_hub_assignment.sku_dynamic,
#         products_hub_assignment.substitute_group,
#         sku_hub_day_level_orders.product_name
#       ]
#       measures: [inventory_changes_daily.pct_waste_quote_items, inventory_daily.pct_in_stock]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         inventory_daily.report_date_dynamic: "-NULL",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__hubs_ct_country_iso__inventory_daily_report_date_dynamic__11 {
#     query: {
#       dimensions: [hubs_ct.country_iso, inventory_daily.report_date_dynamic]
#       measures: [inventory_changes_daily.pct_waste_quote_items, inventory_daily.pct_in_stock]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }

#   aggregate_table: rollup__hubs_ct_city__hubs_ct_country_iso__hubs_ct_hub_code__hubs_ct_start_date__key_value_items_is_kvi__lexbizz_item_max_shelf_life_days__products_category__products_product_brand__products_subcategory__products_hub_assignment_erp_vendo__12 {
#     query: {
#       dimensions: [
#         hubs_ct.city,
#         hubs_ct.country_iso,
#         hubs_ct.hub_code,
#         hubs_ct.start_date,
#         key_value_items.is_kvi,
#         lexbizz_item.max_shelf_life_days,
#         products.category,
#         products.product_brand,
#         products.subcategory,
#         products_hub_assignment.erp_vendor_name,
#         products_hub_assignment.leading_sku_replenishment_substitute_group,
#         products_hub_assignment.sku_dynamic,
#         top_50_skus_per_gmv_supply_chain_explore.top_50
#       ]
#       measures: [top_50_skus_per_gmv_supply_chain_explore.sum_item_price_gross_14d]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 day ago for 21 day",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         top_50_skus_per_gmv_supply_chain_explore.top_50: "-x) Other"
#       ]
#       timezone: "Europe/Berlin"
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup
#     }
#   }
# }
