view: order_order {
  sql_table_name: `flink-backend.saleor_db.order_order`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }



  # dimension_group: _sdc_batched {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_batched_at ;;
  # }

  # dimension_group: _sdc_extracted {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_extracted_at ;;
  # }

  # dimension_group: _sdc_received {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_received_at ;;
  # }

  # dimension: _sdc_sequence {
  #   type: number
  #   sql: ${TABLE}._sdc_sequence ;;
  # }

  # dimension: _sdc_table_version {
  #   type: number
  #   sql: ${TABLE}._sdc_table_version ;;
  # }


  dimension: billing_address_id {
    type: number
    sql: ${TABLE}.billing_address_id ;;
  }

  dimension: checkout_token {
    type: string
    sql: ${TABLE}.checkout_token ;;
  }

  dimension_group: created {
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

  dimension: delivery_time {
    type: number
    hidden: yes
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')), TIMESTAMP(JSON_EXTRACT_SCALAR(${TABLE}.metadata, '$.trackingTimestamp')), SECOND) / 60 ;;
  }

  dimension: reaction_time {
    type: number
    hidden: yes
    sql: TIMESTAMP_DIFF(${order_fulfillment.created_raw},${TABLE}.created, SECOND) / 60 ;;
  }

  dimension: acceptance_time {
    type: number
    hidden: yes
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.trackingTimestamp')),${order_fulfillment.created_raw}, SECOND) / 60 ;;
  }

  dimension: fulfilment_time {
    type: number
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${metadata}, '$.deliveryTime')),${TABLE}.created, SECOND) / 60 ;;
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

  # measure: avg_delivery_time {
  #   label: "AVG Delivery Time"
  #   description: "Average Delivery Time considering from order placement to delivery"
  #   hidden:  yes
  #   type: average
  #   sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${TABLE}.metadata, '$.deliveryTime')),${TABLE}.created, SECOND) / 60;;
  #   value_format: "0.0"
  # }

  measure: avg_fulfillment_time {
    label: "AVG Fulfillment Time"
    description: "Average Fulfillment Time considering order placement to delivery. Outliers excluded (<1min or >30min)."
    hidden:  no
    type: average
    sql: ${fulfilment_time};;
    value_format: "0.0"
    filters: [is_fulfilment_less_than_1_minute: "no", is_fulfilment_more_than_30_minute: "no"]
  }

  measure: avg_delivery_time {
    label: "AVG Delivery Time"
    description: "Average Delivery Time considering delivery start to delivery completion."
    hidden:  no
    type: average
    sql: ${delivery_time};;
    value_format: "0.0"
  }

  measure: avg_reaction_time {
    label: "AVG Reaction Time"
    description: "Average Reaction Time of the Picker considering order placement to first fulfillment created"
    hidden:  no
    type: average
    sql:${reaction_time};;
    value_format: "0.0"
    filters: [order_fulfilment_facts.is_first_fulfillment: "yes"]
  }

  measure: avg_picking_time {
    label: "AVG Picking Time"
    description: "Average Picking Time considering first fulfillment to second fulfillment created"
    hidden:  no
    type: average
    sql:${time_diff_between_two_subsequent_fulfillments};;
    value_format: "0.0"
    filters: [order_fulfilment_facts.is_first_fulfillment: "yes"]
  }

  measure: avg_acceptance_time {
    label: "AVG Acceptance Time"
    description: "Average Acceptance Time of the Rider considering second fulfillment created until Tracking Timestamp"
    hidden:  no
    type: average
    sql:${acceptance_time};;
    value_format: "0.0"
    filters: [order_fulfilment_facts.is_second_fulfillment: "yes"]
  }

  measure: avg_basket_size_gross {
    label: "AVG Basket Size (Gross)"
    description: "Average value of orders considering total gross order values"
    hidden:  no
    type: average
    sql: ${total_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_basket_size_net {
    label: "AVG Basket Size (Net)"
    description: "Average value of orders considering total net order values"
    hidden:  no
    type: average
    sql: ${total_net_amount};;
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

  measure: sum_revenue_gross {
    label: "SUM Revenue (Gross)"
    description: "Sum of value of orders considering total gross order values"
    hidden:  no
    type: sum
    sql: ${total_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_revenue_net {
    label: "SUM Revenue (Net)"
    description: "Sum of value of orders considering total net order values"
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
    description: "Dividing Total Discount amounts over Total Revenue excl. Discounts"
    hidden:  no
    type: number
    sql: ${sum_discount_amt} / NULLIF( (${sum_revenue_gross} + ${sum_discount_amt}), 0);;
    value_format: "0%"
  }

}
