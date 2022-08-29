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
      column: number_of_orders_per_month { field: orders_cl.cnt_orders }

      filters: [
        orders_cl.is_successful_order: "yes",
        orders_cl.is_order_new_hub: "",
        global_filters_and_parameters.datasource_filter: ""]
    }
  }

  dimension: id {
    sql: concat(${hub_code}, ${created_month}) ;;
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

  dimension:  number_of_orders_per_month {
    label: "# Monthly Orders"
    description: "Number of Orders per hub/calendar month"
    hidden:  yes
    type: number
  }

  dimension: number_of_days_opened {
    group_label: "> Monthly Data"
    label: "# Days With Orders"
    description: "Number of distinct days the hub received orders, per calendar month"
    type: number
    value_format_name: decimal_0
  }

  dimension: avg_daily_orders_per_hub {
    group_label: "> Monthly Data"
    label: " AVG # Daily Orders"
    description: "AVG number of daily orders per calendar month. Computed as # Orders / # Days with Orders per hub/month"
    type: number
    value_format_name: decimal_2
  }

  dimension: avg_daily_orders_per_hub_100 {
    group_label: "> Monthly Data"
    label: "AVG # Daily Orders (tiered, 100)"
    description: "Average number of daily orders per hub/calendar month, tiered. The tiers are: [0, 100, 200, 300, 400, 500, 600+]"
    type: tier
    tiers: [100, 200, 300, 400, 500, 600]
    style: relational
    sql: ${avg_daily_orders_per_hub} ;;
  }

  dimension: avg_daily_orders_per_hub_tier {
    group_label: "> Monthly Data"
    label: "AVG # Daily Orders (tiered)"
    description: "Average number of daily orders per hub/calendar month, tiered. The tiers are: [0, 200, 350, 500+]"
    type: tier
    tiers: [200, 350, 500]
    style: relational
    sql: ${avg_daily_orders_per_hub} ;;
  }

  measure:  sum_number_of_orders_per_month {
    label: "# Orders"
    description: "Number of Orders"
    hidden:  yes
    type: sum
    sql: ${number_of_orders_per_month} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_days_opened {
    label: "# Days With Orders"
    description: "Number of days the hub(s) received orders"
    type: sum
    sql: ${number_of_days_opened} ;;
    value_format_name: decimal_0
  }

  measure: avg_daily_orders_per_hub_agg {
    label: " AVG # Daily Orders"
    description: "AVG number of daily orders. Computed as # Orders / # Days with Orders per hub/month"
    type: number
    value_format_name: decimal_2
    sql: ${sum_number_of_orders_per_month}/NULLIF(${sum_number_of_days_opened}, 0) ;;
  }

}
