view: order_order {
  sql_table_name: `flink-backend.pickery_saleor_db.order_order`
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
  dimension_group: delivery {
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
    sql: TIMESTAMP(JSON_EXTRACT_SCALAR(${TABLE}.metadata, '$.deliveryTime')) ;;
  }

  dimension: fulfilment_time {
    type: number
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${TABLE}.metadata, '$.deliveryTime')),${TABLE}.created, SECOND) / 60 ;;
  }

  dimension_group: time_diff_between_x {
    type: duration
    sql_start: ${created_raw} ;;
    sql_end: ${order_fulfillment.created_raw} ;;
  }

  dimension: is_fulfilment_less_than_1_minute {
    type: yesno
    sql: ${fulfilment_time} < 1 ;;
  }

  dimension: is_fulfilment_more_than_30_minute {
    type: yesno
    sql: ${fulfilment_time} > 30 ;;
  }

  measure: avg_delivery_time {
    label: "AVG Delivery Time"
    description: "Average Delivery Time considering from order placement to delivery"
    hidden:  no
    type: average
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${TABLE}.metadata, '$.deliveryTime')),${TABLE}.created, SECOND) / 60;;
    value_format: "0.0"
  }

  measure: avg_delivery_time_filterd {
    label: "AVG Delivery Time Filtered"
    description: "Average Delivery Time considering from order placement to delivery"
    hidden:  no
    type: average
    sql: ${fulfilment_time};;
    value_format: "0.0"
    filters: [is_fulfilment_less_than_1_minute: "no", is_fulfilment_more_than_30_minute: "no"]
  }

  measure: avg_delivery_time_filterd_rank_1 {
    label: "AVG Delivery Time Filtered rank 1"
    description: "Average Delivery Time considering from order placement to delivery"
    hidden:  no
    type: average
    sql: ${fulfilment_time};;
    value_format: "0.0"
    filters: [order_fulfilment_facts.is_first_order: "yes"]
  }


  measure: avg_basket_size_gross {
    label: "AVG Basket Size (Gross)"
    description: "Average value of orders considering total gross order values."
    hidden:  no
    type: average_distinct
    sql_distinct_key: id;;
    sql: ${TABLE}.total_gross_amount;;
    value_format: "0.00"
  }

  measure: avg_basket_size_net {
    label: "AVG Basket Size (Net)"
    description: "Average value of orders considering total net order values."
    hidden:  no
    type: average_distinct
    sql_distinct_key: id;;
    sql: ${TABLE}.total_net_amount;;
    value_format: "0.00"
  }

  measure: sum_revenue_gross {
    label: "SUM Revenue (Gross)"
    description: "Sum of value of orders considering total gross order values."
    hidden:  no
    type: sum_distinct
    sql_distinct_key: id;;
    sql: ${TABLE}.total_gross_amount;;
    value_format: "0.00"
  }

  measure: sum_revenue_net {
    label: "SUM Revenue (Net)"
    description: "Sum of value of orders considering total net order values."
    hidden:  no
    type: sum_distinct
    sql_distinct_key: id;;
    sql: ${TABLE}.total_net_amount;;
    value_format: "0.00"
  }

  measure: cnt_unique_customers {
    label: "# Unique Customers"
    description: "Count of Unique Customers identified via their Email"
    hidden:  no
    type: count_distinct
    sql_distinct_key: id;;
    sql: ${TABLE}.user_email;;
    value_format: "0"
  }

  measure: cnt_unique_orders {
    label: "# Orders"
    description: "Count of successful Orders"
    hidden:  no
    type: count_distinct
    sql_distinct_key: id;;
    sql: ${TABLE}.id;;
    value_format: "0"
  }

  measure: cnt_unique_orders_new {
    label: "# Orders New"
    description: "Count of successful Orders"
    hidden:  no
    type: count_distinct
    # sql_distinct_key: id;;
    sql: ${id};;
    value_format: "0"
    filters: [user_order_facts.is_first_order : "yes"]
  }

  measure: cnt_unique_orders_existing {
    label: "# Orders Existing"
    description: "Count of successful Orders"
    hidden:  no
    type: count_distinct
    # sql_distinct_key: id;;
    sql: ${id};;
    value_format: "0"
    filters: [user_order_facts.is_first_order : "no"]
  }
}
