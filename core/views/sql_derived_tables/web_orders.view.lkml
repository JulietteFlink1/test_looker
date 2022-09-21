view: web_orders {
  derived_table: {
    sql: SELECT
          w.order_number
          , o.order_uuid
          , o.country_iso
          , o.hub_code
          , o.hub_name
          , o.order_date
          , o.shipping_city
          , o.order_timestamp
          , o.discount_code
          , o.amt_discount_gross
          , o.customer_email
          , o.amt_gmv_gross
          , o.amt_gmv_net
          , o.is_successful_order
          , o.is_discounted_order
          , o.is_first_order
          , o.number_of_items
          , 'web' as platform
      FROM `flink-data-prod.flink_website_production.order_completed` w
      LEFT JOIN `flink-data-prod.curated.orders` o on o.order_number = w.order_number
       ;;
  }

  measure: count {
    type: count
    drill_fields: [core_dimensions*]
  }

  dimension: order_date {
    group_label: "* Dates and Timestamps *"
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
    hidden: yes
  }

  set: core_dimensions {
    fields: [
      country_iso,
      order_uuid,
      hub_code,
      order_timestamp,
      customer_type,
      gmv_gross
    ]
  }

  dimension: order_number {
    type: string
    group_label: "* IDs *"
    sql: ${TABLE}.order_number ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: order_uuid {
    type: string
    group_label: "* IDs *"
    primary_key: yes
    hidden: no
    sql: ${TABLE}.order_uuid ;;
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

  dimension: order_timestamp {
    type: date_time
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

  measure: sum_gmv_gross {
    group_label: "* Monetary Values *"
    label: "SUM GMV (Gross)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${gmv_gross};;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_gmv_net {
    group_label: "* Monetary Values *"
    label: "SUM GMV (Net)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${gmv_net};;
    value_format_name: euro_accounting_0_precision
  }


  dimension: discount_amount {
    type: number
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: is_successful_order {
    type: yesno
    sql: ${TABLE}.is_successful_order ;;
  }

  dimension: is_discounted_order {
    type: yesno
    sql: ${TABLE}.is_discounted_order ;;
  }

  dimension: is_first_order {
    type: yesno
    sql: ${TABLE}.is_first_order ;;
  }

  dimension: number_of_items {
    type: number
    sql: ${TABLE}.number_of_items ;;
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
      date,
      time,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_timestamp ;;
    datatype: timestamp
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

  measure: avg_order_value_gross {
    group_label: "* Monetary Values *"
    label: "AVG Order Value (Gross)"
    description: "Average value of orders considering total gross order values. Includes fees (gross), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_order_value_net {
    group_label: "* Monetary Values *"
    label: "AVG Order Value (Net)"
    description: "Average value of orders considering total net order values. Includes fees (net), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_net};;
    value_format_name: euro_accounting_2_precision
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
