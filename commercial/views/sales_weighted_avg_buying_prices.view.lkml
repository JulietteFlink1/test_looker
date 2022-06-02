
view: sales_weighted_avg_buying_prices {
  derived_table: {
    explore_source: order_lineitems_margins {
      column: order_lineitem_uuid {field:orderline.order_lineitem_uuid}
      column: sku {field:orderline.product_sku}
      column: hub_code {field: orderline.hub_code}
      column: created {field:orderline.created_date}
      column: quantity_sold{field:orderline.quantity}
      column: buying_price {field:erp_buying_prices.vendor_price}
    }

  }

  dimension: order_lineitem_uuid {
    type: string
    primary_key: yes
    hidden: yes
    group_label: "> IDs"
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

  measure: sum_quantity_sold {
    label: "SUM Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    hidden:  no
    type: sum
    sql: ${quantity_sold};;
    value_format: "0"
    group_label: "> Absolute Metrics"
  }

  ###### metrics   ######

  dimension: quantity_per_buying_price {
    type: number
    hidden: yes
    sql:  (${quantity_sold} * ${buying_price})  ;;

  }

  measure: sum_quantity_per_buying_price {
    type: sum
    hidden: yes
    sql: ${quantity_per_buying_price};;

  }

  measure: weighted_buying_price {
    label: "Sales Weighted Buying Price"
    type: number
    value_format_name: euro_accounting_2_precision
    sql: ${sum_quantity_per_buying_price} / nullif (${sum_quantity_sold},0);;
  }

}
