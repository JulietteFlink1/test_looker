include: "/explores/base_explores/orders_cl.explore.lkml"

view: orders_with_ops_metrics {
  derived_table: {
    explore_source: orders_cl {
      column: hub_code {}
      column: order_uuid {}
      column: cnt_orders {}
      column: avg_number_items {}
      column: avg_ratio_customer_to_hub {}
      column: avg_at_customer_time {}
      column: avg_delivery_distance_km {}
      column: avg_estimated_picking_time_minutes {}
      column: avg_estimated_queuing_time_for_picker_minutes {}
      column: avg_estimated_queuing_time_for_rider_minutes {}
      column: avg_picker_queuing_time {}
      column: avg_rider_queuing_time {}
      column: avg_fulfillment_time {}
      column: avg_estimated_riding_time_minutes {}
      column: avg_fulfillment_time_mm_ss {}
      column: avg_delivery_time_estimate {}
      column: avg_promised_eta {}
      column: avg_pdt_mm_ss {}
      column: avg_picking_time {}
      column: avg_potential_rider_handling_time_without_stacking {}
      column: avg_pre_riding_time {}
      column: avg_targeted_delivery_time {}
      column: avg_riding_to_hub_time {}
      column: avg_riding_to_customer_time {}
      column: avg_rider_handling_time_minutes_saved_with_stacking {}
      column: avg_rider_handling_time {}
      column: cnt_stacked_orders {}
      column: created_date {}
      column: created_minute30 {}
      column: cnt_orders_delayed_under_0_min {}
      column: cnt_orders_with_delivery_eta_available {}
      column: cnt_orders_with_targeted_eta_available {}
      column: cnt_orders_delayed_under_0_min_time_targeted {}
      column: cnt_ubereats_orders {}
      column: cnt_click_and_collect_orders {}
      column: cnt_orders_fulfilled_over_30_min {}
      column: sum_rider_handling_time_minutes_saved_with_stacking {}
      column: sum_potential_rider_handling_time_without_stacking_minutes {}
      filters: {
        field: orders_cl.is_successful_order
        value: "yes"
      }
    }
  }
  dimension: hub_code {
    label: "Hub Code"
    description: ""
    hidden: yes
  }

  dimension: cnt_orders {
    group_label: "> Basic Counts"
    label: "# Orders"
    description: "Count of Orders"
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_orders {
    group_label: "> Basic Counts"
    label: "# Orders"
    description: "Count of Orders (Excl. Cancellations)"
    type: sum
    value_format_name: decimal_0
    sql: ${cnt_orders} ;;
  }

  measure: cnt_click_and_collect_orders {
    group_label: "> Basic Counts"
    label: "# Click & Collect Orders"
    description: "Count of Click & Collect Orders"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    }

  measure: cnt_ubereats_orders {
    group_label: "> Basic Counts"
    label: "# Ubereats Orders"
    description: "Count of Ubereats Orders"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    }

  measure: cnt_rider_orders {
    group_label: "> Basic Counts"
    label: "# Orders (excl. Click & Collect and Ubereats)"
    description: "Count of Orders that require no riders (e.g. Click and collect)"
    hidden:  no
    sql: ${sum_orders}-${cnt_click_and_collect_orders}-${cnt_ubereats_orders} ;;
    value_format_name: decimal_0
    type: number
    }

  measure: avg_number_items {
    group_label: "> Basic Counts"
    label: "AVG # Items"
    description: "Average number of items per order"
    value_format_name: decimal_1
    type: average
  }

  measure: pct_delivery_in_time {
    group_label: "> Operations / Logistics"
    label: "% Orders delivered in time (PDT)"
    description: "Share of orders delivered no later than PDT (30 sec tolerance)"
    type: number
    value_format_name: percent_0
    sql: ${cnt_orders_delayed_under_0_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
  }

  measure: pct_fulfillment_over_30_min {
    group_label: "> Operations / Logistics"
    label: "% Orders fulfilled >30min"
    description: "Share of orders delivered > 30min"
    type: number
    value_format_name: percent_0
    sql: ${cnt_orders_fulfilled_over_30_min} / NULLIF(${sum_orders}, 0);;
    }

  measure: pct_stacked_orders {
    group_label: "> Basic Counts"
    label: "% Stacked Orders"
    description: "The % of orders, that were part of a stacked delivery"
    sql: ${cnt_stacked_orders} / NULLIF(${sum_orders} ,0) ;;
    type: number
    value_format_name: percent_1
  }


  measure: pct_rider_handling_time_saved_with_stacking {
    group_label: "> Operations / Logistics"
    label: "% Rider Handling Time Saved Due To Stacking"
    description: "% Total rider handling time savings achieved due to stacking. Compares estimated savings with the potential rider handling time without stacking."
    type: number
    value_format_name: percent_0
    sql: ${sum_rider_handling_time_minutes_saved_with_stacking} / NULLIF(${sum_potential_rider_handling_time_without_stacking_minutes}, 0);;
  }

  measure: pct_delivery_in_time_time_estimate {
    group_label: "> Operations / Logistics"
    label: "% Orders delivered in time (targeted estimate)"
    description: "Share of orders delivered no later than targeted estimate"
    value_format_name: percent_0
    type: number
    sql: ${cnt_orders_delayed_under_0_min_time_targeted} / NULLIF(${cnt_orders_with_targeted_eta_available}, 0);;
  }

  measure: sum_rider_handling_time_minutes_saved_with_stacking  {
    group_label: "> Operations / Logistics"
    label: "SUM Rider Handling Time Minutes Saved With Stacking"
    description: "Total number of minutes saved on all orders due to stacking (compared to estimated handling time without stacking)"
    hidden: no
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_potential_rider_handling_time_without_stacking_minutes {
    group_label: "> Operations / Logistics"
    label: "SUM Potential Rider Handling Times (Without Stacking)"
    description: "Total estimated sum of minutes it would potentially take for a rider to handle all the orders without stacking"
    hidden:  no
    type: sum
    value_format_name: euro_accounting_2_precision
  }

  measure: cnt_orders_delayed_under_0_min {
    group_label: "> Basic Counts"
    label: "# Orders delivered on time (30 sec tolerance)"
    description: "Count of Orders delivered no later than PDT"
    type: sum
    hidden: yes
  }

  measure: cnt_orders_fulfilled_over_30_min {
    group_label: "* Operations / Logistics *"
    label: "# Orders fulfilled >30min"
    description: "Count of Orders delivered >30min fulfillment time"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    }

  measure: cnt_orders_with_delivery_eta_available {
    group_label: "> Basic Counts"
    label: "# Orders with Delivery PDT available"
    description: "Count of Orders where a PDT is available"
    type: sum
    hidden: yes
  }

  measure: cnt_orders_delayed_under_0_min_time_targeted {
    group_label: "> Basic Counts"
    label: "# Orders delivered in time (time estimate)"
    description: "Count of Orders delivered no later than internal time estimate"
    type: sum
    hidden: yes
  }

  measure: cnt_orders_with_targeted_eta_available {
    group_label: "> Basic Counts"
    label: "# Orders with Targeted Fulfillment Time is available"
    description: "Count of Orders where a Targeted Delivery Time  is available"
    type: sum
    hidden: yes
  }

  measure: avg_at_customer_time {
    group_label: "> Operations / Logistics"
    label: "AVG At Customer Time"
    description: "Average Time the Rider spent at the customer between arrival and order completion confirmation"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_delivery_distance_km {
    group_label: "> Operations / Logistics"
    label: "AVG Delivery Distance (km)"
    description: "Average distance between hub and customer dropoff (most direct path / straight line)"
    value_format_name: decimal_2
    type: average
  }

  measure: avg_estimated_picking_time_minutes {
    group_label: "> Operations / Logistics"
    label: "AVG Estimated Picking Time"
    description: ""
    value_format_name: decimal_1
    type: average
  }

  measure: avg_estimated_queuing_time_for_picker_minutes {
    group_label: "> Operations / Logistics"
    label: "AVG Estimated Queuing Time for Pickers"
    description: ""
    value_format_name: decimal_1
    type: average
    hidden: yes
  }

  measure: avg_estimated_queuing_time_for_rider_minutes {
    group_label: "> Operations / Logistics"
    label: "AVG Estimated Queuing Time for Riders"
    description: ""
    value_format_name: decimal_1
    type: average
    hidden: yes
  }

  measure: avg_picker_queuing_time {
    group_label: "> Operations / Logistics"
    label: "AVG Picker Queuing Time"
    description: "Average Picker Queuing Time of the Picker considering order placement until picking started. Outliers excluded (<0min or >120min)"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_rider_queuing_time {
    group_label: "> Operations / Logistics"
    label: "AVG Rider Queuing Time"
    description: "Average time between picking completion and rider having claimed the order."
    value_format_name: decimal_1
    type: average
  }

  measure: avg_fulfillment_time {
    group_label: "> Operations / Logistics"
    label: "AVG Fulfillment Time (decimal)"
    description: "Average Fulfillment Time (decimal minutes) considering order placement to delivery (rider at customer). Outliers excluded (<3min or >210min)"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_estimated_riding_time_minutes {
    group_label: "> Operations / Logistics"
    label: "AVG Estimated Riding Time"
    description: ""
    value_format_name: decimal_1
    type: average
  }

  measure: avg_fulfillment_time_mm_ss {
    group_label: "> Operations / Logistics"
    label: "AVG Fulfillment Time (MM:SS)"
    description: "Average Fulfillment Time considering order placement to delivery (rider at customer). Outliers excluded (<3min or >210min)"
    value_format: "mm:ss"
    type: average
  }

  measure: avg_delivery_time_estimate {
    group_label: "> Operations / Logistics"
    label: "AVG Fulfillment Time Estimate (min)"
    description: "The average internally predicted time in minutes for the order to arrive at the customer (dynamic model result - not necessarily the PDT shown to the customer as some conversion can be applied in between)"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_promised_eta {
    group_label: "> Operations / Logistics"
    label: "AVG PDT"
    description: "Average Promised Fulfillment Time (PDT) a shown to customer"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_pdt_mm_ss {
    group_label: "> Operations / Logistics"
    label: "AVG PDT (MM:SS)"
    description: "Average Promised Fulfillment Time (PDT) a shown to customer"
    value_format: "mm:ss"
    type: average
  }

  measure: avg_picking_time {
    group_label: "> Operations / Logistics"
    label: "AVG Picking Time"
    description: "Average Picking Time considering first fulfillment to second fulfillment created. Outliers excluded (<0min or >30min)"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_potential_rider_handling_time_without_stacking {
    group_label: "> Operations / Logistics"
    label: "AVG Potential Rider Handling Time Without Stacking"
    description: "Average potential rider handling time estimated without stacking."
    value_format_name: decimal_1
    type: average
  }

  measure: avg_pre_riding_time {
    group_label: "> Operations / Logistics"
    label: "AVG Pre Riding Time"
    description: ""
    value_format_name: decimal_1
    type: average
  }

  measure: avg_targeted_delivery_time {
    group_label: "> Operations / Logistics"
    label: "AVG Targeted Fulfillment Time (min)"
    description: "Average internal targeted delivery time for hub ops."
    value_format_name: decimal_1
    type: average
  }

  measure: avg_riding_to_hub_time {
    group_label: "> Operations / Logistics"
    label: "AVG Riding to Hub time"
    description: "Average riding time from customer location back to the hub (<1min or >30min)."
    value_format_name: decimal_1
    type: average
  }

  measure: avg_riding_to_customer_time {
    group_label: "> Operations / Logistics"
    label: "AVG Riding To Customer Time"
    description: "Average riding to customer time considering delivery start to arrival at customer. Outliers excluded (<1min or >30min)"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_rider_handling_time_minutes_saved_with_stacking {
    group_label: "> Operations / Logistics"
    label: "AVG Rider Handling Time Minutes Saved (Stacking)"
    description: "Average number of minutes saved on each order due to stacking (compared to estimated handling time without stacking)"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_rider_handling_time {
    group_label: "> Operations / Logistics"
    label: "AVG Rider Handling Time (Minutes)"
    description: "Average total rider handling time: riding to customer + at customer + riding to hub"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_rider_handling_time_seconds {
    group_label: "> Operations / Logistics"
    label: "AVG Rider Handling Time (Seconds)"
    description: "Average total rider handling time: riding to customer + at customer + riding to hub"
    value_format_name: decimal_1
    sql: ${avg_rider_handling_time}*60 ;;
  }

  measure: cnt_stacked_orders {
    group_label: "> Basic Counts"
    label: "# Orders - Stacked Order"
    description: "The number of orders, that were part of a stacked delivery"
    type: sum
    value_format_name: decimal_0
    }

  measure: avg_estimated_queuing_time_by_position {
    group_label: "> Operations / Logistics"
    label: "AVG Estimated Queuing Time (Minutes)"
    value_format_name: decimal_1
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${avg_estimated_queuing_time_for_rider_minutes}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${avg_estimated_queuing_time_for_picker_minutes}
      ELSE NULL
      END ;;
  }

  measure: avg_queuing_time_by_position {
    group_label: "> Operations / Logistics"
    label: "AVG Queuing Time (Minutes)"
    value_format_name: decimal_1
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${avg_estimated_queuing_time_for_rider_minutes}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${avg_estimated_queuing_time_for_picker_minutes}
      ELSE NULL
      END ;;
  }

  dimension: order_uuid {
    label: "Order UUID"
    description: ""
    hidden: yes
    primary_key: yes
  }

  dimension: created_time {
    label: "Order Time"
    description: "Order Placement Time/Date"
    type: date_time
    hidden: yes
  }

  dimension: created_date {
    label: "Order Time"
    description: "Order Placement Date"
    type: date
    hidden: yes
  }

  dimension: created_minute30 {
    label: "Order Time"
    description: "Order Placement Date"
    type: date_minute30
    hidden: yes
  }

}
