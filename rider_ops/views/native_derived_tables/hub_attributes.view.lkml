# Owner: Nazrin Guliyeva
# Created: 2022-11-29

# The main purpose of this table is to provide the hub attributes based on distance, riding to customer, daily orders, stacking rate based on past 30 days.
# This allows team to see if certain hub characteristics have any impact on our metrics such as UTR.

view: hub_attributes {
  derived_table: {
    explore_source: orders_cl {
      column: hub_code {}
      column: country_iso {}
      column: avg_daily_orders {}
      column: number_of_days_opened { field: orders_cl.cnt_unique_date }
      column: avg_rider_handling_time {}
      column: avg_delivery_distance_km {}
      column: avg_riding_to_customer_time {}
      column: pct_stacked_orders {}
      column: avg_waiting_for_rider_time {}
      filters: [
        orders_cl.is_successful_order: "yes",
        orders_cl.is_order_new_hub: "",
        global_filters_and_parameters.datasource_filter: "last 30 days"]
    }
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: id {
    sql: concat(${hub_code}) ;;
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

  dimension: avg_daily_orders {
    group_label: "> Data"
    label: " AVG # Daily Orders"
    description: "AVG number of daily orders in the past 30 days. Computed as # Orders / # Days with Orders per hub"
    type: number
    value_format_name: decimal_2
    hidden: yes
  }

  dimension: avg_daily_orders_tier_50 {
    group_label: "> Tiers"
    label: "AVG # Daily Orders (tiered, 50 Orders)"
    description: "Hubs based on tiered average number of daily orders in the past 30 days. The tiers are: [50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600]"
    type: tier
    tiers: [50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600]
    style: relational
    sql: ${avg_daily_orders} ;;
  }

  dimension: avg_delivery_distance_km {
    group_label: "> Data"
    label: "AVG Delivery Distance (km)"
    description: "Average distance between hub and customer dropoff in kilometers (most direct path / straight line) in the past 30 days. For stacked orders, it is the average distance from previous customer."
    type: number
    value_format_name: decimal_2
    hidden: yes
  }

  dimension: avg_delivery_distance_km_tier {
    group_label: "> Tiers"
    label: "AVG Delivery Distance (km) (tiered, 0.1 km)"
    description: "Hubs based on tiered average delivery distance (km) in the past 30 days. The tiers are: [0.1, 0.2, 0.3, 0.4,...,4.0]"
    type: tier
    tiers: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9,
            1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9,
            2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9,
            3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9,
            4.0]
    style: relational
    sql: ${avg_delivery_distance_km} ;;
  }

  dimension: avg_riding_to_customer_time {
    group_label: "> Data"
    label: "AVG Riding To Customer Time"
    description: "Average riding to customer time considering delivery start to arrival at customer in the past 30 days. Outliers excluded (<1min or >30min)"
    type: number
    value_format_name: decimal_2
    hidden: yes
  }

  dimension: avg_riding_to_customer_time_tier {
    group_label: "> Tiers"
    label: "AVG Riding To Customer Time (tiered, 1 min)"
    description: "Hubs based on tiered average riding to customer time in the past 30 days. The tiers are: [1, 2, 3, 4,...,45]"
    type: tier
    tiers: [1, 2, 3, 4, 5, 6, 7, 8, 9,
            10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
            20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
            30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
            40, 41, 42, 43, 44, 45]
    style: relational
    sql: ${avg_riding_to_customer_time} ;;
  }

  dimension: pct_stacked_orders {
    group_label: "> Data"
    label: "% Stacked Orders"
    description: "The % of orders, that were part of a stacked delivery in the past 30 days (share of internal orders only)."
    type: number
    value_format_name: percent_2
    hidden: yes
  }

  dimension: pct_stacked_orders_tier {
    group_label: "> Tiers"
    label: "% Stacked Orders (tiered, 5%)"
    description: "Hubs based on tiered % stacked orders in the past 30 days. The tiers are: [5, 10, 15, 10,...,100]"
    type: tier
    tiers: [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5,
            0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1]
    style: relational
    sql: ${pct_stacked_orders} ;;
  }

  dimension: avg_waiting_for_rider_time {
    group_label: "> Data"
    label: "AVG Waiting for Rider Time"
    description: "Average time between order offered to rider and rider having claimed the order. Outliers excluded (>120min)"
    value_format_name: decimal_1
    type: number
  }

  dimension: avg_waiting_for_rider_time_tier {
    group_label: "> Tiers"
    label: "AVG Waiting for Rider Time (tiered, 1 min)"
    description: "Hubs based on tiered average waiting for rider time in the past 30 days. The tiers are: [1, 2, 3, 4,...,45]"
    type: tier
    tiers: [1, 2, 3, 4, 5, 6, 7, 8, 9,
      10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
      20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
      30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
      40, 41, 42, 43, 44, 45]
    style: relational
    sql: ${avg_waiting_for_rider_time} ;;
  }

}
