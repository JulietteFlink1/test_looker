view: web_orders {
  derived_table: {
    sql: SELECT
          w.order_number
          , o.country_iso
          , o.hub_code
          , o.hub_name
          , o.shipping_city
          , o.order_date
          , o.order_timestamp
          , o.discount_code
          , o.discount_amount
          , o.customer_email
          , o.amt_gmv_gross
          , o.amt_gmv_net
          , o.is_successful_order
          , o.is_discounted_order
          , o.is_first_order
          , o.number_of_items
      FROM `flink-data-prod.flink_website_production.order_completed` w
      LEFT JOIN `flink-data-prod.curated.orders` o on o.order_number = w.order_number
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.shipping_city ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: order_date {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension_group: order_timestamp {
    type: time
    sql: ${TABLE}.order_timestamp ;;
  }

  dimension: discount_code {
    type: string
    sql: ${TABLE}.discount_code ;;
  }

  dimension: customer_email {
    type: string
    hidden: yes
    sql: ${TABLE}.customer_email ;;
  }

  dimension: amt_gmv_gross {
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: amt_gmv_net {
    type: number
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: discount_amount {
    type: number
    sql: ${TABLE}.discount_amount ;;
  }

  dimension: is_successful_order {
    type: string
    sql: ${TABLE}.is_successful_order ;;
  }

  dimension: is_discounted_order {
    type: string
    sql: ${TABLE}.is_discounted_order ;;
  }

  dimension: is_first_order {
    type: string
    sql: ${TABLE}.is_first_order ;;
  }

  dimension: number_of_items {
    type: number
    sql: ${TABLE}.number_of_items ;;
  }

  set: detail {
    fields: [
      order_number,
      country_iso,
      hub_code,
      hub_name,
      order_date,
      order_timestamp_time,
      discount_code,
      customer_email,
      amt_gmv_gross,
      amt_gmv_net,
      is_successful_order,
      is_discounted_order,
      is_first_order,
      number_of_items
    ]
  }

  dimension_group: Dates {
    group_label: "* Dates and Timestamps *"
    label: "Order"
    description: "Order Placement Date"
    type: time
    timeframes: [
      raw,
      hour_of_day,
      hour,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_timestamp ;;
    datatype: timestamp
  }

  measure: avg_order_value_gross {
    group_label: "* Monetary Values *"
    label: "AVG Order Value (Gross)"
    description: "Average value of orders considering total gross order values. Includes fees (gross), before deducting discounts."
    hidden:  no
    type: average
    sql: ${amt_gmv_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_order_value_net {
    group_label: "* Monetary Values *"
    label: "AVG Order Value (Net)"
    description: "Average value of orders considering total net order values. Includes fees (net), before deducting discounts."
    hidden:  no
    type: average
    sql: ${amt_gmv_net};;
    value_format_name: euro_accounting_2_precision
  }

  dimension: gmv_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: gmv_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_net ;;
  }

  measure: sum_quantity_fulfilled {
    label: "Quantity"
    description: "Fulfilled Quantity"
    type: sum
    sql: ${number_of_items} ;;
  }

  measure: avg_number_items {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "AVG # items"
    description: "Average number of items per order"
    hidden:  no
    type: number
    sql: ${sum_quantity_fulfilled}/nullif(${cnt_orders},0);;
    value_format_name: decimal_1
  }

  measure: cnt_orders {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders"
    description: "Count of successful Orders"
    hidden:  no
    type: count
    value_format: "0"
  }

  dimension: customer_type {
    group_label: "* User Dimensions *"
    type: string
    sql: CASE WHEN ${is_first_order} is True
      THEN 'New Customer' ELSE 'Existing Customer' END ;;
  }

  measure: cnt_unique_orders_new_customers {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders New Customers"
    description: "Count of successful Orders placed by new customers (Acquisitions)"
    hidden:  no
    type: count
    value_format: "0"
    filters: [customer_type: "New Customer"]
  }

  measure: cnt_orders_with_discount {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders with Discount"
    description: "Count of successful Orders with some Discount applied"
    hidden:  no
    type: count
    filters: [discount_amount: ">0"]
    value_format: "0"
  }
}
