view: hub_monthly_orders {
  derived_table: {
    explore_source: orders_cl {
      column: created_month { field: orders_cl.created_month }
      column: hub_code { field: orders_cl.hub_code }
      column: avg_daily_orders_per_hub { field: orders_cl.avg_daily_orders_per_hub }
      column: number_of_days_opened { field: orders_cl.cnt_unique_date }
      column: number_of_orders { field: orders_cl.cnt_orders }

      # bind_all_filters: yes
      filters: [orders_cl.is_successful_order: "yes"]
    }
  }

  dimension: id {
    sql: concat(cast(${hub_code} as string), ${created_month}) ;;
    primary_key: yes
    hidden: yes
  }


  dimension: created_month {
    label: "Month"
    description: "Order Placement Date"
    type: date
  }

  dimension:  number_of_orders {
    label: "# Orders"
    description: "Number of Orders"
    type: number
  }

  dimension: number_of_days_opened {
    label: "# Days Opened"
    description: "Number of days the hub was open"
  }

  dimension: avg_daily_orders_per_hub {
    label: " AVG # Daily Orders"
    description: "AVG number of daily orders. Computed as # Orders / # Days Opened per hub/month"
    type: number
    value_format_name: decimal_2
  }

  dimension: hub_code {
    label: "Hub Code"
    description: "Hub Code"
    value_format_name: id
  }

  dimension: avg_daily_orders_per_hub_100 {
    label: "AVG # Daily Orders (tiered, 100)"
    description: "tiers: [0, 100, 200, 300, 400, 500, 600+]"
    type: tier
    tiers: [0, 100, 200, 300, 400, 500, 600]
    style: relational
    sql: ${avg_daily_orders_per_hub} ;;
  }

  dimension: avg_daily_orders_per_hub_tier {
    label: "AVG # Daily Orders (tiered)"
    description: "tiers: [0, 200, 350, 500+]"
    type: tier
    tiers: [0, 200, 350, 500]
    style: relational
    sql: ${avg_daily_orders_per_hub} ;;
  }

  measure:  sum_number_of_orders {
    label: "# Orders"
    description: "Number of Orders"
    type: sum
    sql: ${number_of_orders} ;;
  }

  measure: sum_number_of_days_opened {
    label: "# Days Opened"
    description: "Number of days the hub(s) was/were open"
    type: sum
    sql: ${number_of_days_opened} ;;
  }

  measure: avg_daily_orders_per_hub_agg {
    label: " AVG # Daily Orders"
    description: "AVG number of daily orders. Computed as # Orders / # Days Opened per hub/month"
    type: number
    value_format_name: decimal_2
    sql: ${sum_number_of_orders}/NULLIF(${sum_number_of_days_opened}, 0) ;;
  }

}
