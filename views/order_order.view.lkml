view: order_order {
  sql_table_name: `flink-backend.saleor_db.order_order`
    ;;
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      id,
      warehouse_name,
      created_raw,
      user_email,
      customer_type,
      gmv_gross,
      discount_amount,
      delivery_eta_timestamp_raw,
      delivery_timestamp_raw
    ]
  }

  dimension: id {
    label: "Order ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: billing_address_id {
    type: number
    sql: ${TABLE}.billing_address_id ;;
  }

  dimension: checkout_token {
    type: string
    sql: ${TABLE}.checkout_token ;;
  }

  dimension_group: created {
    label: "Order"
    description: "Order Placement Date/Time"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created ;;
    datatype: timestamp
  }

  dimension_group: time_since_sign_up {
    type: duration
    sql_start: ${user_order_facts.first_order_raw} ;;
    sql_end: ${created_raw} ;;
  }

  parameter: date_granularity {
    type: string
    allowed_value: { value: "Day" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
  }

  dimension: date {
    label_from_parameter: date_granularity
    sql:
    CASE
      WHEN {% parameter date_granularity %} = 'Day'
        THEN CAST(${created_date} AS STRING)
      WHEN {% parameter date_granularity %} = 'Month'
        THEN CAST(${created_month} AS STRING)
      WHEN {% parameter date_granularity %} = 'Quarter'
        THEN CAST(${created_quarter} AS STRING)
      WHEN {% parameter date_granularity %} = 'Year'
        THEN CAST(${created_year} AS STRING)
      ELSE NULL
    END ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: customer_note {
    type: string
    sql: ${TABLE}.customer_note ;;
  }

  dimension: discount_amount {
    type: number
    sql: ${TABLE}.discount_amount ;;
  }

  dimension: discount_name {
    type: string
    sql: ${TABLE}.discount_name ;;
  }

  dimension: display_gross_prices {
    type: yesno
    sql: ${TABLE}.display_gross_prices ;;
  }

  dimension: language_code {
    type: string
    sql: ${TABLE}.language_code ;;
  }

  dimension: metadata {
    type: string
    sql: ${TABLE}.metadata ;;
  }

  dimension: private_metadata {
    type: string
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: shipping_address_id {
    type: number
    sql: ${TABLE}.shipping_address_id ;;
  }

  dimension: shipping_method_id {
    type: number
    sql: ${TABLE}.shipping_method_id ;;
  }

  dimension: shipping_method_name {
    type: string
    sql: ${TABLE}.shipping_method_name ;;
  }

  dimension: shipping_price_gross_amount {
    type: number
    sql: ${TABLE}.shipping_price_gross_amount ;;
  }

  dimension: shipping_price_net_amount {
    type: number
    sql: ${TABLE}.shipping_price_net_amount ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: token {
    type: string
    sql: ${TABLE}.token ;;
  }

  dimension: total_gross_amount {
    type: number
    sql: ${TABLE}.total_gross_amount ;;
  }

  dimension: total_net_amount {
    type: number
    sql: ${TABLE}.total_net_amount ;;
  }

  dimension: gmv_gross {
    type: number
    sql: ${TABLE}.total_gross_amount + ${discount_amount} ;;
  }

  dimension: gmv_net {
    type: number
    sql: ${TABLE}.total_net_amount  + ${discount_amount};;
  }

  dimension: tracking_client_id {
    type: string
    sql: ${TABLE}.tracking_client_id ;;
  }

  dimension: translated_discount_name {
    type: string
    sql: ${TABLE}.translated_discount_name ;;
  }

  dimension: user_email {
    type: string
    sql: ${TABLE}.user_email ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: voucher_id {
    type: number
    sql: ${TABLE}.voucher_id ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  measure: count {
    type: count
    drill_fields: [id, translated_discount_name, shipping_method_name, discount_name]
  }

  dimension: warehouse_name {
    type: string
    sql: JSON_EXTRACT_SCALAR(${metadata}, '$.warehouse') ;;
  }

  dimension: customer_type {
    type: string
    sql: CASE WHEN ${TABLE}.created = ${user_order_facts.first_order_raw} THEN 'New Customer' ELSE 'Existing Customer' END ;;
  }

  dimension: customer_location {
    type: location
    sql_latitude: ROUND( CAST( SPLIT((JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryCoordinates')), ',')[ORDINAL(1)] AS FLOAT64), 7);;
    sql_longitude: ROUND( CAST( SPLIT((JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryCoordinates')), ',')[ORDINAL(2)] AS FLOAT64), 7) ;;
  }

  dimension: delivery_eta_minutes {
    label: "Delivery ETA (min)"
    type: number
    sql: CAST(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryETA') AS INT64) ;;
  }

  dimension_group: delivery_eta_timestamp {
    label: "Delivery ETA Date/Timestamp"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: TIMESTAMP_ADD(${created_raw}, INTERVAL CAST((JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryETA')) AS INT64) MINUTE) ;;
  }

  dimension_group: delivery_timestamp {
    label: "Delivery Date/Timestamp"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')) ;;
  }

  dimension_group: tracking_timestamp {
    label: "Tracking Date/Timestamp"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.trackingTimestamp')) ;;
  }

  dimension: delivery_delay_since_eta {
    type: duration_minute
    sql_start: ${delivery_timestamp_raw} ;;
    sql_end: ${delivery_eta_timestamp_raw} ;;
  }

  dimension: delivery_time {
    type: number
    hidden: yes
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')), TIMESTAMP(JSON_EXTRACT_SCALAR(${TABLE}.metadata, '$.trackingTimestamp')), SECOND) / 60 ;;
  }

  dimension: reaction_time {
    type: number
    hidden: yes
    sql: TIMESTAMP_DIFF(${order_fulfillment.created_raw},${created_raw}, SECOND) / 60 ;;
  }

  dimension: acceptance_time {
    type: number
    hidden: yes
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.trackingTimestamp')),${order_fulfillment.created_raw}, SECOND) / 60 ;;
  }

  dimension: fulfilment_time {
    type: number
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')),${created_raw}, SECOND) / 60 ;;
  }

  # dimension: time_diff_between_order_created_and_fulfillment_created {
  #   type: number
  #   sql: TIMESTAMP_DIFF(${order_fulfillment.created_raw},${TABLE}.created, SECOND) / 60 ;;
  # }

  dimension: time_diff_between_two_subsequent_fulfillments {
    type: number
    sql: TIMESTAMP_DIFF(TIMESTAMP(leading_order_fulfillment_created_time), ${order_fulfillment.created_raw}, SECOND) / 60 ;;
  }

  dimension: is_fulfilment_less_than_1_minute {
    type: yesno
    sql: ${fulfilment_time} < 1 ;;
  }

  dimension: is_fulfilment_more_than_30_minute {
    type: yesno
    sql: ${fulfilment_time} > 30 ;;
  }

  dimension: is_acceptance_less_than_0_minute {
    type: yesno
    sql: ${acceptance_time} < 0 ;;
  }

  dimension: is_acceptance_more_than_30_minute {
    type: yesno
    sql: ${acceptance_time} > 30 ;;
  }

  dimension: is_reaction_less_than_0_minute {
    type: yesno
    sql: ${reaction_time} < 0 ;;
  }

  dimension: is_reaction_more_than_30_minute {
    type: yesno
    sql: ${reaction_time} > 30 ;;
  }

  dimension: is_delivery_less_than_0_minute {
    type: yesno
    sql: ${delivery_time} < 0 ;;
  }

  dimension: is_delivery_more_than_30_minute {
    type: yesno
    sql: ${delivery_time} > 30 ;;
  }

  dimension: is_picking_less_than_0_minute {
    type: yesno
    sql: ${time_diff_between_two_subsequent_fulfillments} < 0 ;;
  }

  dimension: is_picking_more_than_30_minute {
    type: yesno
    sql: ${time_diff_between_two_subsequent_fulfillments} > 30 ;;
  }

  dimension: is_delivery_eta_available {
    type: yesno
    sql: IF(${delivery_eta_minutes} IS NULL, FALSE, TRUE)  ;;
  }

  dimension: is_customer_location_available {
    type: yesno
    sql: IF(${customer_location::latitude} IS NULL, FALSE, TRUE)  ;;
  }

##############
## AVERAGES ##
##############

  measure: avg_promised_eta {
    label: "AVG Promised ETA"
    description: "Average Promised Fulfillment Time (ETA)"
    hidden:  no
    type: average
    sql: ${delivery_eta_minutes};;
    value_format: "0.0"
  }

  measure: avg_fulfillment_time {
    label: "AVG Fulfillment Time"
    description: "Average Fulfillment Time considering order placement to delivery. Outliers excluded (<1min or >30min)"
    hidden:  no
    type: average
    sql: ${fulfilment_time};;
    value_format: "0.0"
    filters: [is_fulfilment_less_than_1_minute: "no", is_fulfilment_more_than_30_minute: "no"]
  }

  measure: avg_delivery_time {
    label: "AVG Delivery Time"
    description: "Average Delivery Time considering delivery start to delivery completion. Outliers excluded (<0min or >30min)"
    hidden:  no
    type: average
    sql: ${delivery_time};;
    value_format: "0.0"
    filters: [is_delivery_less_than_0_minute: "no", is_delivery_more_than_30_minute: "no"]
  }

  measure: avg_reaction_time {
    label: "AVG Reaction Time"
    description: "Average Reaction Time of the Picker considering order placement to first fulfillment created. Outliers excluded (<0min or >30min)"
    hidden:  no
    type: average
    sql:${reaction_time};;
    value_format: "0.0"
    filters: [order_fulfilment_facts.is_first_fulfillment: "yes", is_reaction_less_than_0_minute: "no", is_reaction_more_than_30_minute: "no"]
  }

  measure: avg_picking_time {
    label: "AVG Picking Time"
    description: "Average Picking Time considering first fulfillment to second fulfillment created. Outliers excluded (<0min or >30min)"
    hidden:  no
    type: average
    sql:${time_diff_between_two_subsequent_fulfillments};;
    value_format: "0.0"
    filters: [order_fulfilment_facts.is_first_fulfillment: "yes", is_picking_less_than_0_minute: "no", is_picking_more_than_30_minute: "no"]
  }

  measure: avg_acceptance_time {
    label: "AVG Acceptance Time"
    description: "Average Acceptance Time of the Rider considering second fulfillment created until Tracking Timestamp. Outliers excluded (<0min or >30min)"
    hidden:  no
    type: average
    sql:${acceptance_time};;
    value_format: "0.0"
    filters: [order_fulfilment_facts.is_second_fulfillment: "yes", is_acceptance_less_than_0_minute: "no", is_acceptance_more_than_30_minute: "no"]
  }

  measure: avg_order_value_gross {
    label: "AVG Order Value (Gross)"
    description: "Average value of orders considering total gross order values. Includes fees (gross), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_order_value_net {
    label: "AVG Order Value (Net)"
    description: "Average value of orders considering total net order values. Includes fees (net), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_product_value_gross {
    label: "AVG Product Value (Gross)"
    description: "Average value of product items (incl. VAT). Excludes fees (gross), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_gross} - ${shipping_price_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_product_value_net {
    label: "AVG Product Value (Net)"
    description: "Average value of product items (excl. VAT). Excludes fees (net), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_net} - ${shipping_price_net_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_delivery_fee_gross {
    label: "AVG Delivery Fee (Gross)"
    description: "Average value of Delivery Fees (Gross)"
    hidden:  no
    type: average
    sql: ${shipping_price_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_delivery_fee_net {
    label: "AVG Delivery Fee (Net)"
    description: "Average value of Delivery Fees (Net)"
    hidden:  no
    type: average
    sql: ${shipping_price_net_amount};;
    value_format_name: euro_accounting_2_precision
  }

##########
## SUMS ##
##########

  measure: sum_gmv_gross {
    label: "SUM GMV (gross)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${gmv_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_gmv_net {
    label: "SUM GMV (net)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${gmv_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_revenue_gross {
    label: "SUM Revenue (gross)"
    description: "Sum of Revenue (GMV after subsidies) incl. VAT"
    hidden:  no
    type: sum
    sql: ${total_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_revenue_net {
    label: "SUM Revenue (net)"
    description: "Sum of Revenue (GMV after subsidies) excl. VAT"
    hidden:  no
    type: sum
    sql: ${total_net_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_discount_amt {
    label: "SUM Discount Amount"
    description: "Sum of Discount amount applied on orders"
    hidden:  no
    type: sum
    sql: ${discount_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_delivery_fee_gross {
    label: "SUM Delivery Fee (Gross)"
    description: "Sum of Delivery Fees (Gross) paid by Customers"
    hidden:  no
    type: sum
    sql: ${shipping_price_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_delivery_fee_net {
    label: "SUM Delivery Fee (Net)"
    description: "Sum of Delivery Fees (Net) paid by Customers"
    hidden:  no
    type: sum
    sql: ${shipping_price_net_amount};;
    value_format_name: euro_accounting_2_precision
  }

############
## COUNTS ##
############

  measure: cnt_unique_customers {
    label: "# Unique Customers"
    description: "Count of Unique Customers identified via their Email"
    hidden:  no
    type: count_distinct
    sql: ${user_email};;
    value_format: "0"
  }

  measure: cnt_orders {
    label: "# Orders"
    description: "Count of successful Orders"
    hidden:  no
    type: count
    value_format: "0"
  }

  measure: cnt_orders_with_discount {
    label: "# Orders with Discount"
    description: "Count of successful Orders with some Discount applied"
    hidden:  no
    type: count
    filters: [discount_amount: ">0"]
    value_format: "0"
  }

  measure: cnt_unique_orders_new_customers {
    label: "# Orders New Customers"
    description: "Count of successful Orders placed by new customers (Acquisitions)"
    hidden:  no
    type: count
    value_format: "0"
    filters: [customer_type: "New Customer"]
  }

  measure: cnt_unique_orders_existing_customers {
    label: "# Orders Existing Customers"
    description: "Count of successful Orders placed by returning customers"
    hidden:  no
    type: count
    value_format: "0"
    filters: [customer_type: "Existing Customer"]
  }

  measure: cnt_orders_with_delivery_eta_available {
    label: "# Orders with Delivery ETA available"
    description: "Count of Orders where a promised ETA is available"
    hidden:  no
    type: count
    filters: [is_delivery_eta_available: "yes"]
    value_format: "0"
  }

  measure: cnt_orders_delayed_over_5_min {
    label: "# Orders delivered late >5min"
    description: "Count of Orders delivered >5min later than promised ETA"
    hidden:  yes
    type: count
    filters: [delivery_delay_since_eta:">=5"]
    value_format: "0"
  }

  measure: cnt_orders_delayed_over_10_min {
    label: "# Orders delivered late >10min"
    description: "Count of Orders delivered >10min later than promised ETA"
    hidden:  yes
    type: count
    filters: [delivery_delay_since_eta:">=10"]
    value_format: "0"
  }

  measure: cnt_orders_delayed_over_15_min {
    label: "# Orders delivered late >15min"
    description: "Count of Orders delivered >15min later than promised ETA"
    hidden:  yes
    type: count
    filters: [delivery_delay_since_eta:">=15"]
    value_format: "0"
  }

################
## PERCENTAGE ##
################

  measure: pct_acquisition_share {
    label: "% Acquisition Share"
    description: "Share of New Customer Acquisitions over Total Orders"
    hidden:  no
    type: number
    sql: ${cnt_unique_orders_new_customers} / NULLIF(${cnt_orders}, 0);;
    value_format: "0%"
  }

  measure: pct_discount_order_share {
    label: "% Discount Order Share"
    description: "Share of Orders which had some Discount applied"
    hidden:  no
    type: number
    sql: ${cnt_orders_with_discount} / NULLIF(${cnt_orders}, 0);;
    value_format: "0%"
  }

  measure: pct_discount_value_of_gross_total{
    label: "% Discount Value Share"
    description: "Dividing Total Discount amounts over GMV"
    hidden:  no
    type: number
    sql: ${sum_discount_amt} / NULLIF(${sum_gmv_gross}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_5_min{
    label: "% Orders delayed >5min"
    description: "Share of orders delivered >5min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${cnt_orders_delayed_over_5_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_10_min{
    label: "% Orders delayed >10min"
    description: "Share of orders delivered >10min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${cnt_orders_delayed_over_10_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_15_min{
    label: "% Orders delayed >15min"
    description: "Share of orders delivered >15min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${cnt_orders_delayed_over_15_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }
}
