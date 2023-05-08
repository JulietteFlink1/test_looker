# This view is used in Ops Explore. It contains order KPIs aggregated on 30min granularity

include: "/**/orders_cl.explore.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

view: orders_with_ops_metrics {
  derived_table: {
    explore_source: orders_cl {
      column: hub_code {}
      column: order_uuid {}
      column: cnt_orders {}
      column: avg_daily_orders {}
      column: cnt_unique_date {}
      column: avg_number_items {}
      column: avg_ratio_customer_to_hub {}
      column: avg_at_customer_time {}
      column: avg_delivery_distance_km {}
      column: avg_estimated_picking_time_minutes {}
      column: avg_estimated_queuing_time_for_picker_minutes {}
      column: avg_estimated_queuing_time_for_rider_minutes {}
      column: avg_waiting_for_picker_time {}
      column: avg_waiting_for_rider_decision_time {}
      column: avg_waiting_for_available_rider_time_minutes {}
      column: avg_waiting_for_trip_readiness_time_minutes {}
      column: avg_rider_preparing_for_trip_time_minutes {}
      column: avg_number_of_offered_to_riders_events {}
      column: avg_number_of_withheld_from_riders_events {}
      column: avg_withheld_from_picking_time_minutes {}
      column: avg_fulfillment_time {}
      column: avg_estimated_riding_time_minutes {}
      column: avg_fulfillment_time_mm_ss {}
      column: avg_delivery_time_estimate {}
      column: avg_promised_eta {}
      column: avg_pdt_mm_ss {}
      column: avg_pick_pack_handling_time_minutes {}
      column: avg_potential_rider_handling_time_without_stacking {}
      column: avg_pre_riding_time {}
      column: avg_targeted_delivery_time {}
      column: avg_riding_to_hub_time {}
      column: avg_riding_to_customer_time {}
      column: avg_rider_handling_time_minutes_saved_with_stacking {}
      column: avg_rider_handling_time {}
      column: cnt_stacked_orders {}
      column: cnt_stacked_orders_double_stack {}
      column: cnt_stacked_orders_triple_stack {}
      column: created_date {}
      column: created_minute30 {}
      column: cnt_orders_delayed_under_0_min {}
      column: cnt_external_orders {}
      column: cnt_orders_with_delivery_eta_available {}
      column: cnt_orders_with_targeted_eta_available {}
      column: cnt_orders_delayed_under_0_min_time_targeted {}
      column: cnt_ubereats_orders {}
      column: cnt_click_and_collect_orders {}
      column: cnt_daas_orders {}
      column: cnt_orders_fulfilled_over_30_min {}
      column: sum_rider_handling_time_minutes_saved_with_stacking {}
      column: sum_rider_handling_time_minutes {}
      column: sum_potential_rider_handling_time_without_stacking_minutes {}
      column: avg_picking_time_per_item {}
      column: cnt_internal_orders {}
      column: number_of_unique_flink_delivered_orders {}
      column: avg_hub_to_customer_distance_km {}
      filters: [
        orders_cl.is_successful_order : "yes",
        global_filters_and_parameters.datasource_filter: "last 12 months"
      ]
    }
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
    type: number
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

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures       ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: avg_hub_to_customer_distance_km {
    group_label: "> Operations / Logistics"
    label: "AVG Hub to Customer Distance (km)"
    description: "Average distance between hub and customer dropoff in kilometers (most direct path / straight line)."
    hidden:  no
    type: average
    value_format_name: decimal_2
  }

  measure: sum_orders {
    group_label: "> Basic Counts"
    label: "# Orders"
    description: "Count of Orders (Excl. Cancellations and Missed Orders, Incl. External and Click&Collect Orders)"
    type: sum
    value_format_name: decimal_0
    sql: ${cnt_orders} ;;
  }

  measure: cnt_click_and_collect_orders {
    group_label: "> Basic Counts"
    label: "# Click & Collect Orders"
    description: "Count of Click & Collect Orders"
    hidden:  no
    type: sum
    value_format_name: decimal_0
    }

  measure: cnt_daas_orders {
    group_label: "> Basic Counts"
    label: "# DaaS Orders"
    description: "Count of Delivery as a Service Orders (e.g. Uber Direct)"
    hidden:  no
    type: sum
    value_format_name: decimal_0
  }

  measure: share_of_daas_orders_over_all_internal_orders {
    group_label:  "> Operations / Logistics"
    label: "% DaaS Orders"
    description: "Share of DaaS orders over total number of internal orders"
    type: number
    sql: ${cnt_daas_orders} / NULLIF(${cnt_internal_orders}, 0);;
    value_format: "0.0%"
  }

  measure: cnt_internal_orders {
    group_label: "> Basic Counts"
    label: "# Internal Orders"
    description: "Count of Internal Orders. All orders placed via Flink App."
    hidden:  no
    type: sum
    value_format_name: decimal_0
  }

  measure: cnt_external_orders {
    group_label: "> Basic Counts"
    label: "# External Orders"
    description: "Count of External orders (orders placed via marketplace integrations like Wolt, UberEats, etc.)"
    type: sum
    value_format_name: decimal_1
  }

  measure: cnt_ubereats_orders {
    group_label: "> Basic Counts"
    label: "# Ubereats Orders"
    description: "Count of Ubereats Orders"
    hidden:  yes
    type: sum
    value_format_name: decimal_0
    }

  measure: number_of_unique_flink_delivered_orders {
    alias: [cnt_rider_orders]
    group_label: "> Basic Counts"
    label: "# Flink Delivered Orders"
    description: "Count of Successful Orders (excl. Cancelled, Click & Collect and External Orders) that require riders"
    hidden:  no
    value_format_name: decimal_0
    type: sum
    }

  measure: number_of_rider_required_orders {
    group_label: "> Basic Counts"
    label: "# RR Orders"
    hidden: yes
    description: "Count of Successful Rider Required Orders (excl. Cancelled, Click & Collect and External Orders) that require riders. Include Flink delivered orders and DaaS orders."
    value_format_name: decimal_0
    type: number
    sql: ${cnt_daas_orders}+${number_of_unique_flink_delivered_orders}  ;;
  }

  measure: avg_number_items {
    group_label: "> Basic Counts"
    label: "AVG # Items"
    description: "Average number of items per order"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_picking_time_per_item {
    group_label: "> Operations / Logistics"
    label: "AVG Pick-Pack Handling Time Per Item (Seconds)"
    description: "Computed as Pick-Pack Handling Time / # Items Picked. Outliers excluded (<0min or >30min)"
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
    group_label: "> Stacked Orders"
    label: "% Stacked Orders"
    description: "The % of orders that were part of a stacked delivery. (Share of internal orders only)"
    sql: ${cnt_stacked_orders} / NULLIF(${cnt_internal_orders}-${cnt_click_and_collect_orders}-${cnt_daas_orders}, 0) ;;
    type: number
    value_format_name: percent_1
  }

  measure: pct_double_stacked_orders {
    label: "% Double-Stacked Orders"
    description: "The % of orders that were part of a 2-order stacked delivery. (Share of internal orders only)"
    group_label: "> Stacked Orders"
    sql: ${cnt_stacked_orders_double_stack} / nullif(${cnt_internal_orders}-${cnt_click_and_collect_orders}-${cnt_daas_orders} ,0) ;;
    type: number
    value_format_name: percent_1
  }

  measure: pct_triple_stacked_orders {
    label: "% Triple-Stacked Orders"
    description: "The % of orders that were part of a 3-order stacked delivery. (Share of internal orders only)"
    group_label: "> Stacked Orders"
    sql: ${cnt_stacked_orders_triple_stack} / nullif(${cnt_internal_orders}-${cnt_click_and_collect_orders}-${cnt_daas_orders} ,0) ;;
    type: number
    value_format_name: percent_1
  }

  measure: pct_stacked_orders_with_triple_stacks {
    label: "% Stacked Orders With Triple-Stacking"
    description: "The % of stacked orders that were part of 3-order stacks."
    group_label: "> Stacked Orders"
    sql: ${cnt_stacked_orders_triple_stack} / nullif(${cnt_stacked_orders} ,0) ;;
    type: number
    value_format_name: percent_1
  }

  measure: pct_external_orders {
    group_label: "> Basic Counts"
    label: "% External Orders"
    description: "Share of external orders (# External Orders / # Orders)"
    type: number
    value_format_name: percent_1
    sql: ${cnt_external_orders} / NULLIF(${sum_orders} ,0);;
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
    description: "Average distance between hub and customer dropoff in kilometers(most direct path / straight line). For stacked orders, it is the average distance from previous customer."
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
    value_format_name: decimal_1
    type: average
    hidden: yes
  }

  measure: avg_estimated_queuing_time_for_rider_minutes {
    group_label: "> Operations / Logistics"
    label: "AVG Estimated Queuing Time for Riders"
    value_format_name: decimal_1
    type: average
    hidden: yes
  }

  measure: avg_waiting_for_picker_time {
    group_label: "> Operations / Logistics"
    label: "AVG Waiting For Picker Time (Minutes)"
    description: "Average picker acceptance-related queuing - from order offered to hub to order started being picked.
    Outliers excluded (>120min). If offered to hub time is not available (no dispatching event), takes the time from order created to picking started"
    value_format_name: decimal_1
    type: average
  }

  measure: avg_waiting_for_rider_decision_time {
    alias: [avg_acceptance_time, avg_rider_queuing_time, avg_waiting_for_rider_time]
    group_label: "* Operations / Logistics *"
    label: "AVG Waiting for Rider Decision Time (Minutes)"
    description: "Average time an order spent waiting for rider acceptance. Outliers excluded (<0min or >120min)"
    type: average
    value_format_name: decimal_1
  }

  measure: avg_waiting_for_available_rider_time_minutes {
    alias: [avg_withheld_from_rider_time_minutes]
    group_label: "* Operations / Logistics *"
    label: "AVG Waiting For Available Rider Time (Minutes)"
    description: "Average time an order waited for an available rider in order to be offered. Outliers excluded (<0min or >120min)"
    type: average
    value_format_name: decimal_1
  }

  measure: avg_waiting_for_trip_readiness_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "AVG Waiting For Trip Readiness Time (Minutes)"
    description: "Average time an order waited for other orders in the stack to be ready. Outliers excluded (<0min or >120min)"
    type: average
    value_format_name: decimal_1
  }

  measure: avg_rider_preparing_for_trip_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "AVG Rider Preparing For Trip Time (Minutes)"
    description: "Average time between Claimed and On Route state changes. Signifies the time a rider needed to scan containers and start the trip. Outliers excluded (<0min or >60min)"
    type: average
    value_format_name: decimal_1
  }

  measure: avg_number_of_offered_to_riders_events {
    group_label: "* Operations / Logistics *"
    label: "AVG Offered To Riders Events"
    description: "Average number of Offered to Riders events orders had. Multiple events might mean offers were rejected by riders or expired."
    type: average
    value_format_name: decimal_1
  }

  measure: avg_number_of_withheld_from_riders_events {
    group_label: "* Operations / Logistics *"
    label: "AVG Withheld From Riders Events"
    description: "Average number of Withheld From Riders events orders had. Multiple events might mean an order's trip changed several times."
    type: average
    value_format_name: decimal_1
  }

  measure: avg_withheld_from_picking_time_minutes {
    group_label: "> Operations / Logistics"
    label: "AVG Withheld From Picking Time (Minutes)"
    description: "Average dispatch-related (withheld) queuing time - from order created to order offered to hub for picking. Outliers excluded (<0min or >120min)"
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

  measure: avg_pick_pack_handling_time_minutes  {
    alias: [avg_picking_time]
    group_label: "> Operations / Logistics"
    label: "AVG Pick-Pack Handling Time (Minutes)"
    description: "AVG time it took for the picker to pick the order and pack it. In minutes. Outliers excluded (<0min or >30min).
    It corresponds to the duration between the times at which the picker clicked on 'Start Picking' and 'Finish Picking'."
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
    label: "AVG Targeted Fulfillment Time (Minutes)"
    description: "Average internal targeted delivery time for hub ops."
    value_format_name: decimal_1
    type: average
  }

  measure: avg_riding_to_hub_time {
    group_label: "> Operations / Logistics"
    label: "AVG Riding to Hub time (Minutes)"
    description: "Average riding time from customer location back to the hub (<1min or >30min)."
    value_format_name: decimal_1
    type: average
  }

  measure: avg_riding_to_customer_time {
    group_label: "> Operations / Logistics"
    label: "AVG Riding To Customer Time (Minutes)"
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

  measure: sum_rider_handling_time_minutes {
    group_label: "> Operations / Logistics"
    label: "SUM Rider Handling Times (Minutes)"
    hidden:  no
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_rider_handling_time_hours {
    group_label: "> Operations / Logistics"
    label: "SUM Rider Handling Times (Hours)"
    hidden:  no
    type: number
    value_format_name: decimal_1
    sql: ${sum_rider_handling_time_minutes}/60 ;;
  }


  measure: avg_rider_handling_time_seconds {
    group_label: "> Operations / Logistics"
    label: "AVG Rider Handling Time (Seconds)"
    description: "Average total rider handling time: riding to customer + at customer + riding to hub"
    value_format_name: decimal_1
    sql: ${avg_rider_handling_time}*60 ;;
  }

  measure: cnt_stacked_orders {
    group_label: "> Stacked Orders"
    label: "# Orders - Stacked Order"
    description: "Count of orders that were part of a stacked delivery."
    type: sum
    value_format_name: decimal_0
  }

  measure: cnt_stacked_orders_double_stack {
    label: "# Double-Stacked Orders"
    description: "The number of orders that were part of a 2-order stacked delivery."
    group_label: "> Stacked Orders"
    type: sum
    value_format: "0"
  }

  measure: cnt_stacked_orders_triple_stack {
    label: "# Triple-Stacked Orders"
    description: "The number of orders that were part of a 3-order stacked delivery."
    group_label: "> Stacked Orders"
    type: sum
    value_format: "0"
  }

  measure: avg_estimated_queuing_time_by_position {
    group_label: "> Operations / Logistics"
    label: "AVG Estimated Queuing Time (Minutes)"
    value_format_name: decimal_1
    sql:
      case
        when {% parameter ops.position_parameter %} = 'Rider' THEN ${avg_estimated_queuing_time_for_rider_minutes}
        when {% parameter ops.position_parameter %} = 'Picker' THEN ${avg_estimated_queuing_time_for_picker_minutes}
        else null
      end ;;
  }

  measure:  avg_waiting_time_by_position {
    alias: [avg_queuing_time_by_position]
    group_label: "> Operations / Logistics"
    label: "AVG Waiting Time (Minutes)"
    value_format_name: decimal_1
    sql:
      case
        when {% parameter ops.position_parameter %} = 'Rider' THEN ${avg_waiting_for_rider_decision_time}
        when {% parameter ops.position_parameter %} = 'Picker' THEN ${avg_waiting_for_picker_time}
        else null
      end ;;
  }

  measure: avg_daily_orders{
    group_label: "> Basic Counts"
    label: "AVG # Daily Orders"
    description: "AVG number of daily orders.
    Computed as the number of orders divided by the number of open days, over the selected timeframe."
    type: number
    sql: (${sum_orders})/ NULLIF(${cnt_unique_date},0);;
    value_format_name:decimal_2
  }

  measure: cnt_unique_date {
    group_label: "> Basic Counts"
    label: "# Unique Date"
    description: "Count of Unique Dates"
    hidden:  no
    type: count_distinct
    value_format_name: decimal_0
  }

  measure: dynamic_kpi_1 {
    type: number
    label: "Dynamic KPI 1"
    label_from_parameter: kpi_1
    description: "This field is based on the chosen KPI"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter kpi_1 %} = 'AVG Fulfillment Time' then ${avg_fulfillment_time}
          when {% parameter kpi_1 %} = 'Rider UTR' then ${ops.utr_rider}
          when {% parameter kpi_1 %} = '% Stacked Orders' then ${pct_stacked_orders}
          when {% parameter kpi_1 %} = 'AVG Delivery Distance' then ${avg_delivery_distance_km}
          when {% parameter kpi_1 %} = 'AVG Riding to Customer Time' then ${avg_riding_to_customer_time}
          when {% parameter kpi_1 %} = 'AVG # Daily Orders' then ${avg_daily_orders}
          when {% parameter kpi_1 %} = 'AVG Waiting for Rider Decision Time' then ${avg_waiting_for_rider_decision_time}
          else null
      end ;;
  }

  measure: dynamic_kpi_2 {
    type: number
    label_from_parameter: kpi_2
    label: "Dynamic KPI 2"
    description: "This field is based on the chosen KPI"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter kpi_2 %} = 'AVG Fulfillment Time' then ${avg_fulfillment_time}
          when {% parameter kpi_2 %} = 'Rider UTR' then ${ops.utr_rider}
          when {% parameter kpi_2 %} = '% Stacked Orders' then ${pct_stacked_orders}
          when {% parameter kpi_2 %} = 'AVG Delivery Distance' then ${avg_delivery_distance_km}
          when {% parameter kpi_2 %} = 'AVG Riding to Customer Time' then ${avg_riding_to_customer_time}
          when {% parameter kpi_2 %} = 'AVG # Daily Orders' then ${avg_daily_orders}
          when {% parameter kpi_2 %} = 'AVG Waiting for Rider Decision Time' then ${avg_waiting_for_rider_decision_time}
          else null
      end ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: kpi_1 {
    type: string
    label: "KPI 1"
    allowed_value: { value: "AVG Fulfillment Time" }
    allowed_value: { value: "Rider UTR" }
    allowed_value: { value: "% Stacked Orders" }
    allowed_value: { value: "AVG Delivery Distance" }
    allowed_value: { value: "AVG Riding to Customer Time" }
    allowed_value: { value: "AVG # Daily Orders" }
    allowed_value: { value: "AVG Waiting for Rider Decision Time" }
  }

  parameter: kpi_2 {
    type: string
    label: "KPI 2"
    allowed_value: { value: "AVG Fulfillment Time" }
    allowed_value: { value: "Rider UTR" }
    allowed_value: { value: "% Stacked Orders" }
    allowed_value: { value: "AVG Delivery Distance" }
    allowed_value: { value: "AVG Riding to Customer Time" }
    allowed_value: { value: "AVG # Daily Orders" }
    allowed_value: { value: "AVG Waiting for Rider Decision Time" }
  }

}
