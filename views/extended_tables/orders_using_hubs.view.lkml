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

  dimension: delivery_distance_m {
    group_label: "* Operations / Logistics *"
    type: distance
    units: meters
    start_location_field: hub_location
    end_location_field: customer_location
  }

  dimension: delivery_distance_km {
    group_label: "* Operations / Logistics *"
    type: distance
    units: kilometers
    start_location_field: hub_location
    end_location_field: customer_location
  }

  dimension: delivery_distance_tier {
    group_label: "* Operations / Logistics *"
    type: tier
    tiers: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0]
    style: interval
    sql: ${delivery_distance_km} ;;
  }

  dimension: is_delivery_distance_over_10km {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: IF(${delivery_distance_km} > 10, TRUE, FALSE);;
  }

  measure: avg_delivery_distance_km {
    group_label: "* Operations / Logistics *"
    label: "AVG Delivery Distance (km)"
    description: "Average distance between hub and customer dropoff (most direct path / straight line)"
    hidden:  no
    type: average
    sql: ${delivery_distance_km};;
    value_format: "0.00"
    filters: [is_delivery_distance_over_10km: "no"]
  }

  ######### Order New/Existing Hubs

  dimension: is_order_new_hub {
    group_label: "* Order Dimensions *"
    label: "Is Order New Hub"
    description: "An order is considered to come from a new hub if it was placed less than 30 days after the hub start date."
    type: yesno

    sql: (date_diff(${order_date},${hubs.start_date},day)<= 30) ;;
  }

  ###### Sums

  measure: sum_gmv_new_hubs {
    group_label: "* Monetary Values *"
    label: "SUM GMV New Hubs"
    description: "GMV from orders from new hubs."
    type: sum
    value_format_name: euro_accounting_0_precision
    sql: ${gmv_gross};;
    filters: [is_order_new_hub: "yes"]
  }

  measure: sum_gmv_existing_hubs {
    group_label: "* Monetary Values *"
    label: "SUM GMV Existing Hubs"
    description: "GMV from orders from existing hubs."
    type: sum
    value_format_name: euro_accounting_0_precision
    sql: ${gmv_gross};;
    filters: [is_order_new_hub: "no"]
  }

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
    description: "# Orders coming from new hubs."
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [is_order_new_hub: "yes"]
  }

  ##### Shares

  measure: pct_gmv_new_hubs {
    group_label: "* Monetary Values *"
    label: "% GMV New Hubs"
    description: "% GMV coming from new hubs."
    type: number
    sql: ${sum_gmv_new_hubs} / NULLIF(${sum_gmv_gross}, 0);;
    value_format: "0.0%"
  }

  measure: pct_gmv_existing_hubs {
    group_label: "* Monetary Values *"
    label: "% GMV Existing Hubs"
    description: "% GMV coming from existing hubs."
    type: number
    sql: ${sum_gmv_existing_hubs} / NULLIF(${sum_gmv_gross}, 0);;
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

  measure: pct_orders_existing_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "% Orders Existing Hubs"
    description: "Share of orders coming from existing hubs."
    type: number
    sql: ${sum_orders_existing_hubs} / NULLIF(${cnt_orders}, 0);;
    value_format: "0.0%"
  }







}
