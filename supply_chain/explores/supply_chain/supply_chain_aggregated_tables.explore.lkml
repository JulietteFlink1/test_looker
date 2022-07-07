include: "/**/supply_chain.explore"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - -    Aggregate Tables: Inventory Overview (strategic)
# - - - - - - - - - - https://goflink.cloud.looker.com/dashboards/1227
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Overview: per Parent Category
explore: +supply_chain {
  aggregate_table: rollup__inventory_daily_report_date_dynamic__products_category {
    query: {
      dimensions: [inventory_daily.report_date_dynamic, products.category]
      measures: [inventory_daily.pct_in_stock]
      filters: [
        global_filters_and_parameters.datasource_filter: "21 days ago for 21 days",
        inventory_daily.date_granularity: "Day",
        inventory_daily.in_stock_cutoff_hours: "1",
        inventory_daily.report_date_dynamic: "-NULL",
        products_hub_assignment.assingment_dynamic: "Yes",
        products_hub_assignment.select_calculation_granularity: "replenishment"
      ]
      timezone: "Europe/Berlin"
    }

    materialization: {
      datagroup_trigger: flink_default_datagroup
      partition_keys: ["inventory_daily.report_date_dynamic"]
    }
  }
}


# Overview: per Sub-Category
explore: +supply_chain {
  aggregate_table: rollup__inventory_daily_report_date_dynamic__products_subcategory {
    query: {
      dimensions: [inventory_daily.report_date_dynamic, products.subcategory]
      measures: [inventory_daily.pct_in_stock]
      filters: [
        global_filters_and_parameters.datasource_filter: "21 days ago for 21 days",
        inventory_daily.date_granularity: "Day",
        inventory_daily.in_stock_cutoff_hours: "1",
        inventory_daily.report_date_dynamic: "-NULL",
        products_hub_assignment.assingment_dynamic: "Yes",
        products_hub_assignment.select_calculation_granularity: "replenishment"
      ]
      timezone: "Europe/Berlin"
    }

    materialization: {
      datagroup_trigger: flink_default_datagroup
      partition_keys: ["inventory_daily.report_date_dynamic"]
    }
  }
}



# Overview: per Supplier
# Place in `flink_v3` model
explore: +supply_chain {
  aggregate_table: rollup__inventory_daily_report_date_dynamic__products_hub_assignment_erp_vendor_name {
    query: {
      dimensions: [inventory_daily.report_date_dynamic, products_hub_assignment.erp_vendor_name]
      measures: [inventory_daily.pct_in_stock]
      filters: [
        global_filters_and_parameters.datasource_filter: "21 days ago for 21 days",
        inventory_daily.date_granularity: "Day",
        inventory_daily.in_stock_cutoff_hours: "1",
        inventory_daily.report_date_dynamic: "-NULL",
        products_hub_assignment.assingment_dynamic: "Yes",
        products_hub_assignment.select_calculation_granularity: "replenishment"
      ]
      timezone: "Europe/Berlin"
    }

    materialization: {
      datagroup_trigger: flink_default_datagroup
      partition_keys: ["inventory_daily.report_date_dynamic"]
    }
  }
}



# Overview: per Hub
explore: +supply_chain {
  aggregate_table: rollup__hubs_ct_hub_code__hubs_ct_hub_name__inventory_daily_report_date_dynamic {
    query: {
      dimensions: [hubs_ct.hub_code, hubs_ct.hub_name, inventory_daily.report_date_dynamic]
      measures: [inventory_daily.pct_in_stock]
      filters: [
        global_filters_and_parameters.datasource_filter: "21 days ago for 21 days",
        inventory_daily.date_granularity: "Day",
        inventory_daily.in_stock_cutoff_hours: "1",
        inventory_daily.report_date_dynamic: "-NULL",
        products_hub_assignment.assingment_dynamic: "Yes",
        products_hub_assignment.select_calculation_granularity: "replenishment"
      ]
      timezone: "Europe/Berlin"
    }

    materialization: {
      datagroup_trigger: flink_default_datagroup
      partition_keys: ["inventory_daily.report_date_dynamic"]
    }
  }
}


# Overview: Granular Overview
# explore: +supply_chain {
#   aggregate_table: rollup__hubs_ct_hub_code__inventory_daily_report_date_dynamic__products_category__products_subcategory__products_hub_assignment_replenishment_substitute_group__products_hub_assignment_sku_dynamic__products_hub_assignment_substitute_group__sk {
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
#       measures: [inventory_daily.pct_in_stock]
#       filters: [
#         global_filters_and_parameters.datasource_filter: "21 days ago for 21 days",
#         inventory_daily.date_granularity: "Day",
#         inventory_daily.in_stock_cutoff_hours: "1",
#         inventory_daily.report_date_dynamic: "-NULL",
#         products_hub_assignment.assingment_dynamic: "Yes",
#         products_hub_assignment.select_calculation_granularity: "replenishment"
#       ]
#     }

#     materialization: {
#       datagroup_trigger: flink_default_datagroup

#     }
#   }
# }

# Overview: per Brand
explore: +supply_chain {
  aggregate_table: rollup__inventory_daily_report_date_dynamic__products_product_brand {
    query: {
      dimensions: [inventory_daily.report_date_dynamic, products.product_brand]
      measures: [inventory_daily.pct_in_stock]
      filters: [
        global_filters_and_parameters.datasource_filter: "21 days ago for 21 days",
        inventory_daily.date_granularity: "Day",
        inventory_daily.in_stock_cutoff_hours: "1",
        inventory_daily.report_date_dynamic: "-NULL",
        products_hub_assignment.assingment_dynamic: "Yes",
        products_hub_assignment.select_calculation_granularity: "replenishment"
      ]
      timezone: "Europe/Berlin"
    }

    materialization: {
      datagroup_trigger: flink_default_datagroup
      partition_keys: ["inventory_daily.report_date_dynamic"]
    }
  }
}
