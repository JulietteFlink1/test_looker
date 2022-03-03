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

  dimension: is_hub_opened_14d {
    label: "Hub is Live more than 14 days?"
    type: yesno
    sql: ${hub_start_date} <= DATE_SUB(current_date(), Interval 14 day) ;;
  }

  dimension: is_hub_opened {
    label: "Hub is Live?"
    type: yesno
    sql: ${hub_start_date} <= current_date() ;;
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
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
    hidden: no
  }

  # dimension_group: order {
  #   type: time
  #   timeframes: [
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   datatype: timestamp
  #   sql: (${TABLE}.partition_timestamp) ;;
  # }

  dimension: is_current_7d {
    type: yesno
    sql: ${order_date} >= date_add(current_date(), interval -7 day) and ${order_date} < current_date() ;;
  }

  dimension: is_previous_7d {
    type: yesno
    sql: ${order_date} >= date_add(current_date(), interval -14 day) and ${order_date} < date_add(current_date(), interval -7 day) ;;
  }

  # approximation: usually the NPS survey is send the day after the order
  dimension_group: nps_survey {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: timestamp
    sql: timestamp_add(${TABLE}.partition_timestamp, Interval 1 day) ;;
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

  dimension: date_ {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Week' %}
      ${order_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${order_month}
    {% elsif date_granularity._parameter_value == 'Day' %}
      ${order_date}
    {% endif %};;
  }


##################################################################################
#                   DATA-1680
##################################################################################
  dimension: hub_tier {
    label: "Hub Tier"
    type: number
    sql: ${TABLE}.hub_tier ;;
  }
# ---------------------------------------------------------------------------------
  dimension: avg_daily_orders_previous_day {
    hidden: yes
    type: number
    sql: ${TABLE}.avg_daily_orders_previous_day ;;
  }

  dimension: avg_daily_orders_previous_month {
    hidden: yes
    type: number
    sql: ${TABLE}.avg_daily_orders_previous_month ;;
  }

  dimension: avg_daily_orders_previous_week {
    hidden: yes
    type: number
    sql: ${TABLE}.avg_daily_orders_previous_week ;;
  }

  dimension: order_bracket {
    label: "Daily Order Bracket"
    type: tier
    tiers: [0,150,300,450,600]
    style: integer
    sql:
        {% if date_granularity._parameter_value == 'Day' %}
        ${avg_daily_orders_previous_day}
        {% elsif date_granularity._parameter_value == 'Week' %}
        ${avg_daily_orders_previous_week}
        {% elsif date_granularity._parameter_value == 'Month' %}
        ${avg_daily_orders_previous_month}
        {% endif %} ;;
  }
# ---------------------------------------------------------------------------------
  dimension: is_orders_target_achieved_day {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_orders_target_achieved_day ;;
  }

  dimension: is_orders_target_achieved_month {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_orders_target_achieved_month ;;
  }

  dimension: is_orders_target_achieved_week {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_orders_target_achieved_week ;;
  }

  dimension: is_orders_target_achieved {
    label: "Is Orders Target Achieved"
    type: yesno
    sql:
        {% if date_granularity._parameter_value == 'Day' %}
        ${is_orders_target_achieved_day}
        {% elsif date_granularity._parameter_value == 'Week' %}
        ${is_orders_target_achieved_week}
        {% elsif date_granularity._parameter_value == 'Month' %}
        ${is_orders_target_achieved_month}
        {% endif %} ;;
  }
# ---------------------------------------------------------------------------------
  dimension: is_rider_utr_target_achieved_day {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_rider_utr_target_achieved_day ;;
  }

  dimension: is_rider_utr_target_achieved_month {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_rider_utr_target_achieved_month ;;
  }

  dimension: is_rider_utr_target_achieved_week {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_rider_utr_target_achieved_week ;;
  }

  dimension: is_rider_utr_target_achieved {
    label: "Is Rider UTR Target Achieved"
    type: yesno
    sql:
        {% if date_granularity._parameter_value == 'Day' %}
        ${is_rider_utr_target_achieved_day}
        {% elsif date_granularity._parameter_value == 'Week' %}
        ${is_rider_utr_target_achieved_week}
        {% elsif date_granularity._parameter_value == 'Month' %}
        ${is_rider_utr_target_achieved_month}
        {% endif %} ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
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

  measure: sum_number_of_adjusted_picker_orders {
    group_label: ">> Order KPIs"
    label: "# Orders"
    hidden: yes
    type: sum
    sql: ${TABLE}.number_of_adjusted_picker_orders ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_adjusted_rider_orders {
    group_label: ">> Order KPIs"
    label: "# Orders"
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_adjusted_rider_orders ;;
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

  # =========  Ops KPIs   =========

  measure: sum_number_of_orders_with_delivery_eta_available {
    group_label: ">> Ops KPIs"
    label: "# Orders with PDT available"
    description: "Count of Orders where a promised delivery time is available"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_with_delivery_eta_available ;;
  }

  measure: sum_number_of_orders_delayed_under_0_min {
    group_label: ">> Ops KPIs"
    label: "# Orders delivered in time"
    description: "Count of Orders delivered no later than promised delivery time"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_delayed_under_0_min ;;
  }

  measure: sum_number_of_orders_delayed_over_5_min {
    group_label: ">> Ops KPIs"
    label: "# Orders delivered late >5min"
    description: "Count of Orders delivered >5min later than promised delivery time"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_delayed_over_5_min ;;
  }

  measure: sum_number_of_orders_delayed_over_10_min {
    group_label: ">> Ops KPIs"
    label: "# Orders delivered late >10min"
    description: "Count of Orders delivered >10min later than promised delivery time"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_delayed_over_10_min ;;
  }

  measure: sum_number_of_orders_delayed_over_15_min {
    group_label: ">> Ops KPIs"
    label: "# Orders delivered late >15min"
    description: "Count of Orders delivered >15min later than promised delivery time"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_delayed_over_15_min ;;
  }


  measure: pct_delivery_in_time{
    group_label: ">> Ops KPIs"
    label: "% Orders delivered in time"
    description: "Share of orders delivered no later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${sum_number_of_orders_delayed_under_0_min} / NULLIF(${sum_number_of_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_5_min{
    group_label: ">> Ops KPIs"
    label: "% Orders delayed >5min"
    description: "Share of orders delivered >5min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${sum_number_of_orders_delayed_over_5_min} / NULLIF(${sum_number_of_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_10_min{
    group_label: ">> Ops KPIs"
    label: "% Orders delayed >10min"
    description: "Share of orders delivered >10min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${sum_number_of_orders_delayed_over_10_min} / NULLIF(${sum_number_of_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_15_min{
    group_label: ">> Ops KPIs"
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

  # -------------------------------------------------------------------------------------------------------------------------------------------
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

  measure: number_of_order_lineitems_swapped_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems Swapped Product"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_swapped_product ;;
  }

  measure: number_of_order_lineitems_cancelled_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems Cancelled Product"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_cancelled_product ;;
  }

  measure: number_of_order_lineitems_product_not_on_shelf {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems Not On Shelf (Pre-Order Issues)"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_product_not_on_shelf ;;
  }

  measure: number_of_order_lineitems_undefined_issue_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Order Lineitems Undefined Group of Product Issue"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_order_lineitems_undefined_issue_product ;;
  }


  # -------------------------------------------------------------------------------------------------------------------------------------------
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

  measure: number_of_orders_swapped_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders Swapped Product"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_swapped_product ;;
  }

  measure: number_of_orders_cancelled_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders Cancelled Product"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_cancelled_product ;;
  }

  measure: number_of_orders_product_not_on_shelf {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders Product Not On Shelf"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_product_not_on_shelf ;;
  }

  measure: number_of_orders_undefined_issue_product {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders Undefined Group of Product Issue"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_undefined_issue_product ;;
  }
  # -------------------------------------------------------------------------------------------------------------------------------------------

  measure: number_of_pre_order_issues {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders with Issues (Pre-Delivery)"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_orders_product_not_on_shelf ;;
  }

  measure: number_of_post_order_issues {
    group_label: ">> Issue Rate KPIs"
    label: "# Orders with Issues (Post-Delivery)"
    type: sum
    value_format_name: decimal_0
    sql: -- ${TABLE}.number_of_orders_cancelled_product       +
         ${TABLE}.number_of_orders_damaged_product         +
         ${TABLE}.number_of_orders_missing_product         +
         ${TABLE}.number_of_orders_perished_product        +
         ${TABLE}.number_of_orders_swapped_product         +
         ${TABLE}.number_of_orders_undefined_issue_product +
         ${TABLE}.number_of_orders_wrong_order             +
         ${TABLE}.number_of_orders_wrong_product

    ;;
  }


  measure: cnt_distinct_skus {
    label: "Unique Picks (Pre-Delivery)"
    description: "The number of unique SKUs, that had to be picked"
    group_label: ">> Issue Rate KPIs"
    type: sum
    hidden: yes
    sql: ${TABLE}.cnt_distinct_skus ;;
  }


  measure: pct_orders_with_issues {
    group_label: ">> Issue Rate KPIs"
    label: "% Issue Rate (post order)"
    description: "The number of orders that have issues (the sum of: Wrong Product, Wrong Order, Perished Product, Missing Product and Damaged Product) divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_post_order_issues}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }

  measure: pct_orders_with_issues_pre_delivery {
    group_label: ">> Issue Rate KPIs"
    label: "% Partial fulfillment Rate (preoder)"
    description: "The number of orders that have issues before order delivery (e.g. no product in shelf, out-of-stock)"
    type: number
    sql: (1.0 * ${number_of_pre_order_issues}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }

  measure: pct_pre_order_fulfillment_rate {
    label: "% Pre-Order Fulfillment Rate"
    group_label: ">> Issue Rate KPIs"
    description: "The percentage of orders, that had no pre-delivery issues"
    type: number
    sql: 1 - ${pct_orders_with_issues_pre_delivery} ;;
    value_format_name: percent_2
  }

  measure: pct_items_with_issues_pre_delivery {
    group_label: ">> Issue Rate KPIs"
    label: "% Item unfulfilled (preorder)"
    description: "The number of orders that have issues before order delivery (e.g. no product in shelf, out-of-stock)"
    type: number
    sql: (1.0 * ${number_of_pre_order_issues}) / NULLIF(${cnt_distinct_skus}, 0) ;;
    value_format_name: percent_1
  }



  measure: pct_orders_missing_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Missing Products"
    description: "The number of orders with missing products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_orders_missing_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_wrong_order {
    group_label: ">> Issue Rate KPIs"
    label: "% Wrong Orders"
    description: "The number of orders with completely wrong baskets delivered divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_orders_wrong_order}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_perished_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Perished Products"
    description: "The number of orders with perished products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_orders_perished_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_wrong_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Wrong Products "
    description: "The number of orders with wrong products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_orders_wrong_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_damaged_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Damaged Products"
    description: "The number of orders with damaged products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_orders_damaged_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }

  measure: pct_orders_swapped_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Swapped Products"
    description: "The number of orders with swapped products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_orders_swapped_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_cancelled_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Cancelled Products"
    description: "The number of orders with damaged products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_orders_cancelled_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }
  measure: pct_orders_undefined_issue_product {
    group_label: ">> Issue Rate KPIs"
    label: "% Undefined Group of Product Issue"
    description: "The number of orders with damaged products divided by the total number of orders."
    type: number
    sql: (1.0 * ${number_of_orders_undefined_issue_product}) / NULLIF(${sum_number_of_orders}, 0) ;;
    value_format_name: percent_1
  }

  # =========  UTR Kpis   =========
  measure: adjusted_orders_riders {
    group_label: ">> UTR KPIs"
    type: sum
    description: "exclude orders when total daily worked hour = 0"
    sql: ${TABLE}.number_of_adjusted_orders_riders ;;
    hidden: yes
  }



  measure: adjusted_orders_pickers {
    type: sum
    sql: ${TABLE}.number_of_adjusted_orders_pickers ;;
    hidden: yes
  }

  measure: rider_hours {
    group_label: ">> UTR KPIs"
    label: "Sum of Rider Hours"
    type: sum
    sql: ${TABLE}.number_of_rider_hours ;;
    value_format_name: decimal_1
  }

  measure: picker_hours {
    group_label: ">> UTR KPIs"
    label: "Sum of Picker Hours"
    type: sum
    sql: ${TABLE}.number_of_picker_hours ;;
    value_format_name: decimal_1
  }

  measure: rider_utr {
    group_label: ">> UTR KPIs"
    label: "AVG Rider UTR"
    hidden: no
    type: number
    sql: ${sum_number_of_adjusted_rider_orders} / NULLIF(${rider_hours}, 0);;
    value_format_name: decimal_2
  }

  measure: picker_utr {
    group_label: ">> UTR KPIs"
    label: "AVG Picker UTR"
    type: number
    hidden: no
    sql: ${sum_number_of_adjusted_rider_orders} / NULLIF(${picker_hours}, 0);;
    value_format_name: decimal_2

  }


  # =========  Shift KPIs   =========

  measure: sum_filled_ext_picker_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Assigned Ext. Picker"
    sql: ${TABLE}.number_of_filled_ext_picker_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_filled_ext_rider_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Assigned Ext. Rider"
    sql: ${TABLE}.number_of_filled_ext_rider_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_filled_ext_hours_total {
    group_label: ">> Shift KPIs"
    label: "Hours: Assigned Ext. Total"
    value_format_name: decimal_1
    type: number
    sql: ${sum_filled_ext_picker_hours} + ${sum_filled_ext_rider_hours} ;;
  }

  measure: sum_unfilled_rider_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Unassigned Rider"
    sql: if(
              (${sum_planned_rider_hours} - ${sum_filled_rider_hours}) < 0
            , 0
            , (${sum_planned_rider_hours} - ${sum_filled_rider_hours})
    ) ;;
    value_format_name: decimal_1
    type: number
    description: "Scheduled Hours - Assigned hours"
  }
  measure: sum_unfilled_picker_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Unassigned Picker"
    sql: if(
                (${sum_planned_picker_hours} - ${sum_filled_picker_hours}) < 0
              , 0
              , (${sum_planned_picker_hours} - ${sum_filled_picker_hours})
    );;
    value_format_name: decimal_1
    type: number
    description: "Scheduled Hours - Assigned hours"
  }

  measure: sum_unfilled_hours_total {
    group_label: ">> Shift KPIs"
    label: "Hours: Unassigned Total"
    description: "Scheduled Hours - Assigned hours"
    type: number
    value_format_name: decimal_1
    sql: ${sum_unfilled_picker_hours} + ${sum_unfilled_rider_hours} ;;

  }
  measure: sum_filled_no_show_picker_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: No Show Picker"
    description: "All shift hours that have no punch & accepted absense attached."
    sql: ${TABLE}.number_of_filled_no_show_picker_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_filled_no_show_rider_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: No Show Rider"
    description: "All shift hours that have no punch & accepted absense attached."
    sql: ${TABLE}.number_of_filled_no_show_rider_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_filled_no_show_hours_total {
    group_label: ">> Shift KPIs"
    label: "Hours: No Show Total"
    value_format_name: decimal_1
    type: number
    sql: ${sum_filled_no_show_picker_hours} + ${sum_filled_no_show_rider_hours} ;;
  }

  measure: sum_punched_rider_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Punched Rider"
    description: "All punched-in hours by actual punch in and out. I.e. Assigned Hours - No Show Hours."
    value_format_name: decimal_1
    type: number
    sql: ${sum_filled_rider_hours} - ${sum_filled_no_show_rider_hours} ;;
  }

  measure: sum_punched_picker_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Punched Picker"
    description: "All punched-in hours by actual punch in and out. I.e. Assigned Hours - No Show Hours."
    value_format_name: decimal_1
    type: number
    sql: ${sum_filled_picker_hours} - ${sum_filled_no_show_picker_hours} ;;
  }


  measure: sum_filled_picker_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Assigned Picker"
    sql: ${TABLE}.number_of_filled_picker_hours ;;
    value_format_name: decimal_1
    type: sum
    description: "All scheduled hours (hours from scheduled shifts), regardless if hours were worked or not.
                  Generated by Quinyx. Hub managers can manually adjust the generated shifts after."
  }
  measure: sum_planned_picker_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Scheduled Picker"
    sql: ${TABLE}.number_of_planned_picker_hours ;;
    value_format_name: decimal_1
    type: sum
    description: "Scheduled hours + Unassigned hours (hours from shifts that were created but were not assigned to anyone)"
  }
  measure: sum_filled_rider_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Assigned Rider"
    sql: ${TABLE}.number_of_filled_rider_hours ;;
    value_format_name: decimal_1
    type: sum
    description: "All scheduled hours (hours from scheduled shifts), regardless if hours were worked or not.
                  Generated by Quinyx. Hub managers can manually adjust the generated shifts after."
  }
  measure: sum_planned_rider_hours {
    group_label: ">> Shift KPIs"
    label: "Hours: Scheduled Rider"
    sql: ${TABLE}.number_of_planned_rider_hours ;;
    value_format_name: decimal_1
    type: sum
    description: "Scheduled hours + Unassigned hours (hours from shifts that were created but were not assigned to anyone)"
  }

  measure: pct_no_show {
    group_label: ">> Shift KPIs"
    label: "% No Show Shift Hours"
    description: "The percentage of planned and assigned shift hours with employees not showing up"
    type: number
    sql: (${sum_filled_no_show_rider_hours} + ${sum_filled_no_show_picker_hours}) / nullif((${sum_filled_picker_hours} + ${sum_filled_rider_hours}), 0) ;;
    value_format_name: percent_1
  }

  measure: pct_open_shifts {
    group_label: ">> Shift KPIs"
    label: "% Unassigned Shift Hours"
    description: "The percentage of scheduled shift hours that could not have been filled with employees. Unassigned Hours are all unassagned shift hours. I.e. Scheduled Hours - Assigned Hours"
    type: number
    sql: (${sum_unfilled_picker_hours} + ${sum_unfilled_rider_hours}) / nullif((${sum_planned_picker_hours} + ${sum_planned_rider_hours}) ,0) ;;
    value_format_name: percent_1
  }

  measure: pct_ext_shifts {
    group_label: ">> Shift KPIs"
    label: "% External Shift Hours"
    description: "The percentage of actual shift hours, that were performed by external employees"
    type: number
    sql: (${sum_filled_ext_picker_hours} + ${sum_filled_ext_rider_hours}) / nullif((${sum_filled_picker_hours} + ${sum_filled_rider_hours}), 0) ;;
    value_format_name: percent_1
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #   SCORING
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: score_delivery_in_time {
    group_label: ">> Hub Scores"
    label: "Score: Delivered in Time"
    sql: if(
            (2 * ${pct_delivery_in_time}*100 -100) < 0
            , 0
            , 2 * ${pct_delivery_in_time}*100 -100
            ) ;;
    type: number
    value_format_name: decimal_0
  }

  measure: score_delivery_late_over_5_min {
    group_label: ">> Hub Scores"
    label: "Score: Delivered late < 5min"
    sql: if(
            ( -10 * ${pct_delivery_late_over_5_min}*100 +100) < 0
            , 0
            , -10 * ${pct_delivery_late_over_5_min}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_nps_score {
    group_label: ">> Hub Scores"
    label: "Score: NPS"
    sql: if(
            (50/17 * ${nps_score}*100 +(-3300/17)) < 0
            , 0
            , 50/17 * ${nps_score}*100 +(-3300/17)
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_orders_with_issues {
    group_label: ">> Hub Scores"
    label: "Score: Order Issues"
    sql: if(
            (-40 * ${pct_orders_with_issues}*100 +100) < 0
            , 0
            , -40 * ${pct_orders_with_issues}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_no_show {
    group_label: ">> Hub Scores"
    label: "Score: No Show Shift Hours"
    sql: if(
            (-5 * ${pct_no_show}*100 +100) < 0
            , 0
            , -5 * ${pct_no_show}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_open_shifts {
    group_label: ">> Hub Scores"
    label: "Score: Unassigned Shift Hours"
    sql: if(
            (-5 * ${pct_open_shifts}*100 +100) < 0
            , 0
            , -5 * ${pct_open_shifts}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_ext_shifts {
    group_label: ">> Hub Scores"
    label: "Score: External Shift Hours"
    sql: if(
            (-5 * ${pct_ext_shifts}*100 +100) < 0
            , 0
            , -5 * ${pct_ext_shifts}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

# START --> REQUEST DATA-508
  measure: score_rider_utr {
    group_label: ">> Hub Scores"
    label: "Score: Rider UTR"
    sql: case when (50 * ${rider_utr} -50) < 0   then 0
              when (50 * ${rider_utr} -50) > 100 then 100
              else 50 * ${rider_utr} -50
          end;;
    type: number
    value_format_name: decimal_0
  }

  measure: score_picker_utr {
    group_label: ">> Hub Scores"
    label: "Score: Picker UTR"
    sql: case when (10 * ${picker_utr} -50) < 0   then 0
              when (10 * ${picker_utr} -50) > 100 then 100
              else 10 * ${picker_utr} -50
        end;;
    type: number
    value_format_name: decimal_0
  }
  # END --> REQUEST DATA-508

  measure: score_hub_leaderboard {
    group_label: ">> Hub Scores"
    label: "Hub Leaderboard Score"
    sql: 0.20 * ${score_delivery_in_time} +
        0.10 * ${score_delivery_late_over_5_min} +
        0.22 * ${score_orders_with_issues} +
        0.25 * ${score_nps_score} +
        0.01 * ${score_ext_shifts} +
        0.01 * ${score_open_shifts} +
        0.01 * ${score_no_show} +
        0.10 * ${score_picker_utr} +
        0.10 * ${score_rider_utr}
        ;;
    type: number
    value_format_name: decimal_0
  }



##################################################################################
#                   DATA-1680
##################################################################################

  measure: sum_orders_target {
    group_label: ">> Order KPIs"
    label: "# Orders Target"
    type: sum
    sql: ${TABLE}.daily_orders_target ;;
    value_format_name: decimal_0
  }

  measure: cnt_unique_hubs {
    group_label: ">> Ops KPIs"
    label: "# Hubs"
    type: count_distinct
    sql:  ${hub_code};;
  }

  measure: cnt_hubs_above_orders_target {
    hidden: yes
    type: count_distinct
    sql:
      {% if date_granularity._parameter_value == 'Day' %}
      if(is_orders_target_achieved_day=true,${hub_code},null)
      {% elsif date_granularity._parameter_value == 'Week' %}
      if(is_orders_target_achieved_week=true,${hub_code},null)
      {% elsif date_granularity._parameter_value == 'Month' %}
      if(is_orders_target_achieved_month=true,${hub_code},null)
      {% endif %} ;;
  }

  measure: pct_hubs_above_orders_target {
    group_label: ">> Ops KPIs"
    label: "% Hubs Above Orders Target"
    type: number
    sql: ${cnt_hubs_above_orders_target} / nullif(${cnt_unique_hubs},0) ;;
    value_format_name: percent_1
  }

  measure: cnt_hubs_above_rider_utr_target {
    hidden: yes
    type: count_distinct
    sql:
      {% if date_granularity._parameter_value == 'Day' %}
      if(is_rider_utr_target_achieved_day=true,${hub_code},null)
      {% elsif date_granularity._parameter_value == 'Week' %}
      if(is_rider_utr_target_achieved_week=true,${hub_code},null)
      {% elsif date_granularity._parameter_value == 'Month' %}
      if(is_rider_utr_target_achieved_month=true,${hub_code},null)
      {% endif %} ;;
  }

  measure: pct_hubs_above_rider_utr_target {
    group_label: ">> Ops KPIs"
    label: "% Hubs Above Rider UTR Target"
    type: number
    sql: ${cnt_hubs_above_rider_utr_target} / nullif(${cnt_unique_hubs},0) ;;
    value_format_name: percent_1
  }

  measure: rider_utr_target {
    group_label: ">> UTR KPIs"
    label: "Avg Rider UTR Target"
    type: average
    sql: ${TABLE}.rider_utr_target ;;
    value_format_name: decimal_2
  }

}
