view: hub_level_kpis {
  view_label: "* Hub Level KPIS *"
  sql_table_name: `flink-data-prod.reporting.hub_level_kpis`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: hub_level_kpi_uuid {
    type: string
    sql: ${TABLE}.hub_level_kpi_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # =========  __main__   =========

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: hub_start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.hub_start_date ;;
  }

  dimension_group: order_hidden {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
    hidden: yes
  }

  dimension_group: order {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: timestamp
    sql: (${TABLE}.partition_timestamp) ;;
  }

  dimension: is_successful_order {
    type: yesno
    sql: ${TABLE}.is_successful_order ;;
  }

  dimension_group: time_since_hub_start {
    type: duration
    intervals: [day, week, month, year]
    sql_start: ${hub_start_date} ;;
    sql_end: current_date() ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # =========  Order Kpis   =========
  measure: sum_number_of_distinct_skus {
    group_label: ">> Order KPIs"
    type: sum
    sql: ${TABLE}.number_of_distinct_skus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_number_of_items {
    group_label: ">> Order KPIs"
    type: sum
    sql: ${TABLE}.number_of_items ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_number_of_orders {
    group_label: ">> Order KPIs"
    label: "# Orders"
    type: sum
    sql: ${TABLE}.number_of_orders ;;
    value_format_name: decimal_0
  }

  measure: percent_of_total_orders_col {
    group_label: ">> Order KPIs"
    label: "% Of Total Orders (Column)"
    direction: "column"
    type: percent_of_total
    sql: ${sum_number_of_orders} ;;
  }

  measure: percent_of_total_orders_pivot {
    group_label: ">> Order KPIs"
    label: "% Of Total Orders (Pivot)"
    direction: "row"
    type: percent_of_total
    sql: ${sum_number_of_orders} ;;
  }

  measure: avg_unique_skus_per_order {
    group_label: ">> Order KPIs"
    label: "AVG # SKUs per Order"
    type: number
    sql: ${sum_number_of_distinct_skus} / nullif(${sum_number_of_orders},0) ;;
   value_format_name: decimal_1
  }

  measure: avg_items_per_order {
    group_label: ">> Order KPIs"
    label: "AVG # Items per Order"
    type: number
    sql: ${sum_number_of_items} / nullif(${sum_number_of_orders},0) ;;
    value_format_name: decimal_1
  }

  measure: sum_amt_gmv_gross {
    group_label: ">> Order KPIs"
    label: "Sum GMV gross"
    type: sum
    sql:${TABLE}.amt_gmv_gross;;
    value_format_name: eur
    hidden: yes
  }

  measure: sum_amt_gmv_net {
    group_label: ">> Order KPIs"
    label: "Sum GMV net"
    type: sum
    sql:${TABLE}.amt_gmv_net;;
    value_format_name: eur
    hidden: yes
  }

  measure: avg_order_value_gross {
    group_label: ">> Order KPIs"
    label: "AVG Order Value (Gross)"
    description: "Average value of orders considering total gross order values. Includes fees (gross), before deducting discounts."
    type: number
    sql: ${sum_amt_gmv_gross} / nullif(${sum_number_of_orders},0);;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_order_value_net {
    group_label: ">> Order KPIs"
    label: "AVG Order Value (Net)"
    description: "Average value of orders considering total net order values. Includes fees (net), before deducting discounts."
    type: number
    sql: ${sum_amt_gmv_net} / nullif(${sum_number_of_orders},0);;
    value_format_name: euro_accounting_2_precision
  }

  # =========  Operations Kpis   =========

  measure: sum_number_of_orders_with_delivery_eta_available {
    group_label: ">> Operations KPIs"
    label: "# Orders with PDT available"
    description: "Count of Orders where a promised delivery time is available"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_with_delivery_eta_available ;;
  }

  measure: sum_number_of_orders_delayed_under_0_min {
    group_label: ">> Operations KPIs"
    label: "# Orders delivered in time"
    description: "Count of Orders delivered no later than promised delivery time"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_delayed_under_0_min ;;
  }

  measure: sum_number_of_orders_delayed_over_5_min {
    group_label: ">> Operations KPIs"
    label: "# Orders delivered late >5min"
    description: "Count of Orders delivered >5min later than promised delivery time"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_delayed_over_5_min ;;
  }

  measure: sum_number_of_orders_delayed_over_10_min {
    group_label: ">> Operations KPIs"
    label: "# Orders delivered late >10min"
    description: "Count of Orders delivered >10min later than promised delivery time"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_delayed_over_10_min ;;
  }

  measure: sum_number_of_orders_delayed_over_15_min {
    group_label: ">> Operations KPIs"
    label: "# Orders delivered late >15min"
    description: "Count of Orders delivered >15min later than promised delivery time"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_delayed_over_15_min ;;
  }


  measure: pct_delivery_in_time{
    group_label: ">> Operations KPIs"
    label: "% Orders delivered in time"
    description: "Share of orders delivered no later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${sum_number_of_orders_delayed_under_0_min} / NULLIF(${sum_number_of_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_5_min{
    group_label: ">> Operations KPIs"
    label: "% Orders delayed >5min"
    description: "Share of orders delivered >5min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${sum_number_of_orders_delayed_over_5_min} / NULLIF(${sum_number_of_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_10_min{
    group_label: ">> Operations KPIs"
    label: "% Orders delayed >10min"
    description: "Share of orders delivered >10min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${sum_number_of_orders_delayed_over_10_min} / NULLIF(${sum_number_of_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_15_min{
    group_label: ">> Operations KPIs"
    label: "% Orders delayed >15min"
    description: "Share of orders delivered >15min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${sum_number_of_orders_delayed_over_15_min} / NULLIF(${sum_number_of_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }



  # =========  NPS Kpis   =========

  measure: sum_number_of_nps_responses {
    group_label: ">> NPS KPIs"
    label: "# NPS Responses"
    type: sum
    sql: ${TABLE}.number_of_nps_responses ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_passives {
    group_label: ">> NPS KPIs"
    label: "# Passives"
    type: sum
    sql: ${TABLE}.number_of_passives ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_detractors {
    group_label: ">> NPS KPIs"
    label: "# Detractors"
    type: sum
    sql: ${TABLE}.number_of_detractors ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_promoter {
    group_label: ">> NPS KPIs"
    label: "# Promoters"
    type: sum
    sql: ${TABLE}.number_of_promoter ;;
    value_format_name: decimal_0
  }

  measure: pct_detractors{
    group_label: ">> NPS KPIs"
    label: "% Detractors"
    description: "Share of Detractors over total Responses"
    hidden:  no
    type: number
    sql: ${sum_number_of_detractors} / NULLIF(${sum_number_of_nps_responses}, 0);;
    value_format: "0%"
  }

  measure: pct_passives{
    group_label: ">> NPS KPIs"
    label: "% Passives"
    description: "Share of Passives over total Responses"
    hidden:  no
    type: number
    sql: ${sum_number_of_passives} / NULLIF(${sum_number_of_nps_responses}, 0);;
    value_format: "0%"
  }

  measure: pct_promoters{
    group_label: ">> NPS KPIs"
    label: "% Promoters"
    description: "Share of Promoters over total Responses"
    hidden:  no
    type: number
    sql: ${sum_number_of_promoter} / NULLIF(${sum_number_of_nps_responses}, 0);;
    value_format: "0%"
  }

  measure: nps_score{
    group_label: ">> NPS KPIs"
    label: "% NPS"
    description: "NPS Score (After Order)"
    hidden:  no
    type: number
    sql: ${pct_promoters} - ${pct_detractors};;
    value_format: "0%"
  }

  # =========  Order Issue Kpis   =========
  measure: number_of_order_lineitems_damaged_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems Damaged"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_damaged_product ;;
  }

  measure: number_of_order_lineitems_missing_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems Missing"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_missing_product ;;
  }

  measure: number_of_order_lineitems_perished_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems Perished"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_perished_product ;;
  }

  measure: number_of_order_lineitems_with_issues {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems with Issues"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_with_issues ;;
  }

  measure: number_of_order_lineitems_wrong_order {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems Wrong Order "
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_wrong_order ;;
    hidden: yes
  }

  measure: number_of_order_lineitems_wrong_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems Wrong Product"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_wrong_product ;;
  }

  measure: number_of_orders_damaged_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders Damaged Product"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_damaged_product ;;
  }

  measure: number_of_orders_missing_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders Missing Product"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_missing_product ;;
  }

  measure: number_of_orders_perished_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders Perished Product"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_perished_product ;;
  }

  measure: number_of_orders_with_issues {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders with Issues"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_with_issues ;;
  }

  measure: number_of_orders_wrong_order {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders Wrong Order"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_wrong_order ;;
  }

  measure: number_of_orders_wrong_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders Wrong Product"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_wrong_product ;;
  }


  measure: pct_orders_with_issues {
    group_label: ">> Issue Rate KPIs"
    label: "% Issue Rate"
    description: "The number of orders that have issues (the sum of: Wrong Product, Wrong Order, Perished Product, Missing Product and Damaged Product) divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_order_lineitems_with_issues}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }

  measure: pct_orders_missing_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Missing Products"
    description: "The number of orders with missing products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_order_lineitems_missing_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_wrong_order {
    group_label: ">> Issue Rate KPIs"
    label: "% Wrong Orders"
    description: "The number of orders with completely wrong baskets delivered divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_order_lineitems_wrong_order}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_perished_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Perished Products"
    description: "The number of orders with perished products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_order_lineitems_perished_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_wrong_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Wrong Products "
    description: "The number of orders with wrong products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_order_lineitems_wrong_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_damaged_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Damaged Products"
    description: "The number of orders with damaged products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_order_lineitems_damaged_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }

}
