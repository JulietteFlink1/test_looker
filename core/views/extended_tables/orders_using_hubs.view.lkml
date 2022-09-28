include: "/**/*.view"
view: orders_using_hubs {
  extends: [orders]
  view_label: "* Orders *"

  dimension: hub_location  {
    group_label: "* Hub Dimensions *"
    type: location
    sql_latitude: ${hubs.latitude};;
    sql_longitude: ${hubs.longitude};;
  }

  dimension_group: time_between_hub_launch_and_order {
    group_label: "* Hub Dimensions *"
    datatype: date
    type: duration
    sql_start: ${hubs.start_date} ;;
    sql_end: ${order_date} ;;
  }

  dimension: hub_to_customer_distance_m {
    group_label: "* Operations / Logistics *"
    label: "Delivery Distance M (Hub to Customer)"
    type: distance
    units: meters
    start_location_field: hub_location
    end_location_field: customer_location
    description: "Distance between hub and customer dropoff in meters (most direct path / straight line)."
  }

  dimension: hub_to_customer_distance_km {
    group_label: "* Operations / Logistics *"
    label: "Delivery Distance KM (Hub to Customer)"
    type: distance
    units: kilometers
    start_location_field: hub_location
    end_location_field: customer_location
    description: "Distance between hub and customer dropoff in kilometers (most direct path / straight line)."
  }

  dimension: hub_to_customer_distance_tier {
    group_label: "* Operations / Logistics *"
    label: "Delivery Distance Tier (km) (Hub to Customer)"
    type: tier
    tiers: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0]
    style: interval
    sql: ${hub_to_customer_distance_km} ;;
  }

  dimension: is_hub_to_customer_delivery_distance_over_10km {
    group_label: "* Operations / Logistics *"
    label: "Is Hub to Customer Delivery Distance Over 10 km"
    type: yesno
    sql: IF(${hub_to_customer_distance_km} > 10, TRUE, FALSE);;
  }


  measure: avg_hub_to_customer_delivery_distance_km {
    group_label: "* Operations / Logistics *"
    label: "AVG Delivery Distance (km) (Hub to Customer)"
    description: "Average distance between hub and customer dropoff in kilometers (most direct path / straight line)."
    hidden:  no
    type: average
    sql: ${hub_to_customer_distance_km};;
    value_format: "0.00"
    filters: [is_hub_to_customer_delivery_distance_over_10km: "no"]
  }

  dimension: delivery_distance_m {
    group_label: "* Operations / Logistics *"
    label: "Delivery Distance M"
    type: number
    sql: ${TABLE}.delivery_distance_km/1000 ;;
    description: "Distance between hub and customer dropoff in meters (most direct path / straight line). For stacked orders, it is the distance from previous customer."

  }

  dimension: delivery_distance_km {
    group_label: "* Operations / Logistics *"
    label: "Delivery Distance KM"
    type: number
    sql: ${TABLE}.delivery_distance_km ;;
    description: "Distance between hub and customer dropoff in kilometers (most direct path / straight line). For stacked orders, it is the distance from previous customer."
    }

  dimension: delivery_distance_tier {
    group_label: "* Operations / Logistics *"
    label: "Delivery Distance Tier (km)"
    type: tier
    tiers: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0]
    style: interval
    sql: ${delivery_distance_km} ;;
  }

  dimension: is_delivery_distance_over_10km {
    group_label: "* Operations / Logistics *"
    label: "Is Delivery Distance Over 10 km"
    type: yesno
    sql: IF(${delivery_distance_km} > 10, TRUE, FALSE);;
  }

  measure: avg_delivery_distance_km {
    group_label: "* Operations / Logistics *"
    label: "AVG Delivery Distance (km)"
    description: "Average distance between hub and customer dropoff in kilometers(most direct path / straight line). For stacked orders, it is the average distance from previous customer."
    hidden:  no
    type: average
    sql: ${delivery_distance_km};;
    value_format: "0.00"
    filters: [is_delivery_distance_over_10km: "no"]
  }

  ######### Order New/Existing Hubs - Cell Split Hubs

  dimension: is_order_new_hub {
    group_label: "* Order Dimensions *"
    label: "Is Order From New Hub"
    description: "An order is considered to come from a new hub if it was placed less than 30 days after the hub start date"
    type: yesno
    sql: ${TABLE}.is_order_from_new_hub ;;
  }
# (date_diff(${order_date},${hubs.start_date},day)<= 30)
  dimension: is_order_from_cell_split_hub{
    group_label: "* Order Dimensions *"
    label: "Is Order From Cell Split Hub"
    description: "Order coming from an identified cell split hub"
    hidden:  yes
    type: yesno
    sql: case when ${hubs.is_cell_split_hub} = true then true end;;
  }

  ###### Sums

  measure: sum_gmv_existing_hubs {
    group_label: "* Monetary Values *"
    label: "SUM GMV Existing Hubs"
    description: "GMV from orders from existing hubs."
    type: sum
    value_format_name: euro_accounting_0_precision
    sql: ${gmv_gross};;
    filters: [is_order_new_hub: "no"]
  }

  measure: sum_gmv_new_hubs {
    group_label: "* Monetary Values *"
    label: "SUM GMV New Hubs"
    description: "GMV from orders from new hubs."
    type: sum
    value_format_name: euro_accounting_0_precision
    sql: ${gmv_gross};;
    filters: [is_order_new_hub: "yes"]
  }

  measure: sum_gmv_new_cell_split_hubs {
    group_label: "* Monetary Values *"
    label: "SUM GMV New Hubs (Cell Split)"
    description: "GMV from orders from new hubs that are cell split."
    type: sum
    value_format_name: euro_accounting_0_precision
    sql: ${gmv_gross};;
    filters: [is_order_new_hub: "yes", is_order_from_cell_split_hub: "yes"]
  }

  measure: sum_gmv_new_non_cell_split_hubs {
    group_label: "* Monetary Values *"
    label: "SUM GMV New Hubs (Non Cell Split)"
    description: "GMV from orders from new hubs that are not cell split."
    type: sum
    value_format_name: euro_accounting_0_precision
    sql: ${gmv_gross};;
    filters: [is_order_new_hub: "yes", is_order_from_cell_split_hub: "no"]
  }

### # orders
  measure: sum_orders_existing_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders Existing Hubs"
    description: "# Orders coming from existing hubs."
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [is_order_new_hub: "no"]
  }

  measure: sum_orders_new_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders New Hubs"
    description: "# Orders coming from new hubs. Don't take cell split into account"
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [is_order_new_hub: "yes"]
  }

  measure: sum_orders_new_cell_split_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders New Hubs (Cell Split)"
    description: "# Orders coming from hubs that are new and cell split."
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [is_order_from_cell_split_hub: "yes", is_order_new_hub: "yes"]
  }

  measure: sum_orders_new_non_cell_split_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders New Hubs (Non Cell Split)"
    description: "# Orders coming from hubs that are new and non cell split."
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [is_order_from_cell_split_hub: "no", is_order_new_hub: "yes"]
  }

  ##### Shares

  measure: pct_gmv_existing_hubs {
    group_label: "* Monetary Values *"
    label: "% GMV Existing Hubs"
    description: "% GMV coming from existing hubs."
    type: number
    sql: ${sum_gmv_existing_hubs} / NULLIF(${sum_gmv_gross}, 0);;
    value_format: "0.0%"
  }

  measure: pct_gmv_new_hubs {
    group_label: "* Monetary Values *"
    label: "% GMV New Hubs"
    description: "% GMV coming from new hubs."
    type: number
    sql: ${sum_gmv_new_hubs} / NULLIF(${sum_gmv_gross}, 0);;
    value_format: "0.0%"
  }

  measure: pct_gmv_new_cell_split_hubs {
    group_label: "* Monetary Values *"
    label: "% GMV New Hubs (Cell Split)"
    description: "% GMV coming from new hubs that are cell split."
    type: number
    sql: ${sum_gmv_new_cell_split_hubs} / NULLIF(${sum_gmv_gross}, 0);;
    value_format: "0.0%"
  }

  measure: pct_gmv_new_non_cell_split_hubs {
    group_label: "* Monetary Values *"
    label: "% GMV New Hubs (Non Cell Split)"
    description: "% GMV coming from new hubs that are not cell split."
    type: number
    sql: ${sum_gmv_new_non_cell_split_hubs} / NULLIF(${sum_gmv_gross}, 0);;
    value_format: "0.0%"
  }

  measure: pct_orders_existing_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "% Orders Existing Hubs"
    description: "Share of orders coming from existing hubs."
    type: number
    sql: ${sum_orders_existing_hubs} / NULLIF(${cnt_orders}, 0);;
    value_format: "0.0%"
  }

  measure: pct_orders_new_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "% Orders New Hubs"
    description: "Share of orders coming from new hubs."
    type: number
    sql: ${sum_orders_new_hubs} / NULLIF(${cnt_orders}, 0);;
    value_format: "0.0%"
  }

  measure: pct_orders_new_cell_split_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "% Orders New Hubs (Cell Split)"
    description: "Share of orders coming from new hubs that are cell split."
    type: number
    sql: ${sum_orders_new_cell_split_hubs} / NULLIF(${cnt_orders}, 0);;
    value_format: "0.0%"
  }

  measure: pct_orders_new_non_cell_split_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "% Orders New Hubs (Non Cell Split)"
    description: "Share of orders coming from new hubs that are not cell split."
    type: number
    sql: ${sum_orders_new_non_cell_split_hubs} / NULLIF(${cnt_orders}, 0);;
    value_format: "0.0%"
  }

}
