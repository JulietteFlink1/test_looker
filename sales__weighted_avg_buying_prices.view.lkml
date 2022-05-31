
view: sales_weighted_avg_buying_prices {
  derived_table: {
    explore_source: order_orderline_margins {
      column: sku {field:orderline.product_sku}
      column: hub_code {field: orderline.hub_code}
      column: last_modified {field:orderline.last_modified}
      column: created {field:orderline.created}
      column: quantity_sold{field:orderline.quantity}
      column: buying_price {field:erp_buying_prices.vendor_price}
    bind_all_filters: yes
    }
  }

  dimension: sku {
    type: string
    label: "Product SKU"
    value_format_name: id
  }

  dimension: hub_code {
    type: string
    label: "Hub Code"
  }

  dimension: quantity_sold {
    label: "Quantity Sold"
    type: number
    group_label: "> Monetary Dimensions"
  }

  dimension_group: last_modified {
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
    group_label: "> Dates & Timestamps"
  }

  dimension_group: created {
    group_label: "> Dates & Timestamps"
    label: "Order"
    description: "Order Placement Date"
    type: time
    timeframes: [
      raw,
      minute15,
      minute30,
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
    datatype: timestamp
  }

  dimension: buying_price {
    label: "Buying Price"
    type: number
    value_format_name: decimal_4
  }





  }
