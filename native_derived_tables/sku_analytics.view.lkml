# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: sku_analytics {
  derived_table: {
    explore_source: order_order {
      column: warehouse_name {}
      column: created_week {}
      column: product_sku { field: order_orderline.product_sku }
      column: unit_price_gross_amount { field: order_orderline.unit_price_gross_amount }
      column: unit_price_net_amount { field: order_orderline.unit_price_net_amount }
      column: sum_item_price_net {field: order_orderline.sum_item_price_net}
      column: sum_item_price_gross {field: order_orderline.sum_item_price_gross}
      # column: quantity { field: order_orderline.quantity }
      # column: quantity_fulfilled { field: order_orderline.quantity_fulfilled }
      column: cnt_orders {}
      column: id {}
      column: hub_code_lowercase { field: hubs.hub_code_lowercase }
      column: city { field: hubs.city }
      column: country { field: hubs.country }
      column: created_date {}
      column: product_name { field: order_orderline.product_name }
      column: category { field: parent_category.name }
      column: sub_category { field: product_category.name }
      column: sum_item_price_gross { field: order_orderline.sum_item_price_gross }
      column: sum_item_quantity { field: order_orderline.sum_item_quantity }
      column: shipping_price_gross_amount {}
      column: total_gross_amount {}
      column: status {}
      column: sum_revenue_gross {}
      column: sum_gmv_gross {}
      derived_column: max_hubs_sku_sold {
        sql: count(distinct hub_code_lowercase) over (partition by created_date, product_sku) ;;
      }
      derived_column: total_sum_item_price_net {
        sql: sum(sum_item_price_net) over (partition by created_date) ;;
      }
      # derived_column: last_price_change {
      #   sql: if(
      #         (lag(unit_price_gross_amount) over (partition by product_sku order by created_date)) <> unit_price_gross_amount
      #         , created_date
      #         , null
      #         );;
      # }

      filters: {
        field: order_order.is_internal_order
        value: "no"
      }
      filters: {
        field: order_order.is_successful_order
        value: "yes"
      }
    }
  }
  dimension: warehouse_name {
    label: "Warehouse Name"
    hidden: yes
  }
  # dimension: created_week {
  #   label: "* Orders * Order Week"
  #   description: "Order Placement Date/Time"
  #   type: date_week
  # }
  dimension: product_sku {
    label: "Product SKU"
  }
  dimension: unit_price_gross_amount {
    label: "Unit Price Gross Amount"
    type: number
  }
  dimension: quantity {
    label: "Quantity"
    type: number
  }
  dimension: quantity_fulfilled {
    label: "Quantity Fulfilled"
    type: number
  }

  # TBD - in how many orders was a sku compared to all orders
  dimension: cnt_orders {
    label: "# Orders"
    description: "Count of successful Orders"
    value_format: "0"
    type: number
    hidden: yes
  }

  dimension: country {

  }

  dimension: id {
    label: "Order ID"
    value_format: "0"
    type: number
    hidden: yes
  }
  dimension: hub_code_lowercase {
    label: "Hub Code Lowercase"
  }
  dimension: city {
    label: "City"
  }
  dimension: created_date {
    label: "Order Date"
    description: "Order Placement Date/Time"
    type: date
  }
  dimension_group: gr_created_date {
    label: "Order Date Group"
    sql: cast(${created_date} as timestamp) ;;
    type: time
  }

  dimension: product_name {
    label: "Product Name"
  }
  dimension: sum_item_price_gross {
    label: "* Order Line Items * SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    value_format_name: eur
    type: number
    hidden: yes
  }
  dimension: sum_item_quantity {
    label: "* Order Line Items * SUM Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    value_format: "0"
    type: number
    hidden: yes
  }
  dimension: shipping_price_gross_amount {
    label: "Shipping Price Gross Amount"
    type: number
    hidden: yes
  }
  dimension: total_gross_amount {
    label: "Total Gross Amount"
    type: number
    hidden: yes
  }
  dimension: status {
    label: "* Orders * Status"
  }
  dimension: sum_revenue_gross {
    label: "SUM Revenue (gross)"
    description: "Sum of Revenue (GMV after subsidies) incl. VAT"
    value_format_name: eur
    type: number
    hidden: yes
  }
  dimension: sum_gmv_gross {
    label: "SUM GMV (Gross)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    value_format_name: eur
    type: number
    hidden: yes
  }
  dimension: sub_category {
    label: "Product Sub-Category"

  }
  dimension: category {
    label: "Product Category"

  }





  measure: distinct_hubs_sold {
    type: count_distinct
    label: "# Unique Hubs SKU sold"
    sql:  ${hub_code_lowercase};;
    value_format_name: decimal_1
  }
  measure: percent_hubs_covered {
    label: "% Hubs with SKU"
    type: percent_of_total
    sql: ${distinct_hubs_sold} ;;
    direction: "column"
  }


  measure: distinct_days_sold {
    label: "# Days SKU sold"
    type: count_distinct
    sql: ${created_date} ;;
    value_format_name: decimal_1
  }
  measure: percent_distinct_days_sold {
    label: "% SKU sold on possible open days"
    type: percent_of_total
    sql: ${distinct_days_sold};;
    direction: "column"
  }


  measure: sum_item_price_net {
    label: "Item Price (Net)"
    type: sum
    value_format_name: eur
  }
  measure: daily_revenue_equalized {
    label: "Daily Revenue equalized"
    type: number
    sql: ${sum_item_price_net} / nullif(${distinct_days_sold},0) / nullif(${distinct_hubs_sold},0);;
    value_format_name: eur
  }

  # TBD - maybe delete
  dimension: max_total_daily_revenue {
      type: number
      sql:  ${TABLE}.total_sum_item_price_net;;
      value_format_name: eur
      hidden: yes
  }

  measure: percent_of_total_daily_revenue {
    label: "% SKU of total Revenue"
    type: percent_of_total
    sql:  ${sum_item_price_net};;
    direction: "column"
  }
  measure: percent_of_total_daily_revenue_equalized {
    label: "% SKU of total daily revenue equalized"
    type: percent_of_total
    sql:  ${daily_revenue_equalized};;
    direction: "column"
  }



}
