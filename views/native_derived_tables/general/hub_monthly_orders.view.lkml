# The main purpose of this table is to provide the AVG # Daily Orders per hub and calendar month
# This KPI allows to group the hubs into tiers, which is useful to assess trends in groups of 'similar' hubs

view: hub_monthly_orders {
  derived_table: {
    explore_source: orders_cl {
      column: created_month {}
      column: hub_code {}
      column: country_iso {}
      column: avg_daily_orders_per_hub {}
      column: number_of_days_opened { field: orders_cl.cnt_unique_date }
      column: number_of_orders { field: orders_cl.cnt_orders }

      filters: [orders_cl.is_successful_order: "yes",
        orders_cl.is_order_new_hub: "",
        global_filters_and_parameters.datasource_filter: ""]
    }
  }

  dimension: id {
    sql: concat(cast(${hub_code} as string), ${created_month}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: hub_code {
    label: "Hub Code"
    description: "Hub Code"
    hidden:  yes
    value_format_name: id
  }

  dimension: country_iso {
    label: "Country Iso"
    hidden:  yes
    description: "Iso code of the country"
    type: string
  }

  dimension: created_month {
    label: "Order Month"
    hidden:  yes
    description: "Order Placement Date"
    type: date
  }

  dimension:  number_of_orders {
    label: "# Monthly Orders"
    description: "Number of Orders per hub/month"
    hidden:  yes
    type: number
  }

  dimension: number_of_days_opened {
    label: "# Days With Orders"
    description: "Number of distinct days the hub received orders"
  }

  dimension: avg_daily_orders_per_hub {
    label: " AVG # Daily Orders"
    description: "AVG number of daily orders per calendar month. Computed as # Orders / # Days with Orders per hub/month"
    type: number
    value_format_name: decimal_2
  }

  dimension: avg_daily_orders_per_hub_100 {
    label: "AVG # Daily Orders (tiered, 100)"
    description: "tiers: [0, 100, 200, 300, 400, 500, 600+]"
    type: tier
    tiers: [100, 200, 300, 400, 500, 600]
    style: relational
    sql: ${avg_daily_orders_per_hub} ;;
  }

  dimension: avg_daily_orders_per_hub_tier {
    label: "AVG # Daily Orders (tiered)"
    description: "tiers: [0, 200, 350, 500+]"
    type: tier
    tiers: [200, 350, 500]
    style: relational
    sql: ${avg_daily_orders_per_hub} ;;
  }

  measure:  sum_number_of_orders {
    label: "# Orders"
    description: "Number of Orders"
    hidden:  yes
    type: sum
    sql: ${number_of_orders} ;;
  }

  measure: sum_number_of_days_opened {
    label: "# Days With Orders"
    description: "Number of days the hub(s) received orders"
    type: sum
    sql: ${number_of_days_opened} ;;
  }

  measure: avg_daily_orders_per_hub_agg {
    label: " AVG # Daily Orders"
    description: "AVG number of daily orders. Computed as # Orders / # Days with Orders per hub/month"
    type: number
    value_format_name: decimal_2
    sql: ${sum_number_of_orders}/NULLIF(${sum_number_of_days_opened}, 0) ;;
  }

}
