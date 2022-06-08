view: sales_weighted_avg_buying_prices {
  derived_table: {
    explore_source: order_lineitems_margins {
      column: order_lineitem_uuid {field:orderline.order_lineitem_uuid}
      column: product_sku {field:orderline.product_sku}
      column: hub_code {field: orderline.hub_code}
      column: created_date {field:orderline.created_date}
      column: quantity {field:orderline.quantity}
      column: vendor_price {field:erp_buying_prices.vendor_price}
    }

  }


  dimension: order_lineitem_uuid {
    type: string
    primary_key: yes
    hidden: no
    group_label: "> IDs"
  }

  dimension: product_sku {
    type: string
    label: "Product SKU"
    value_format_name: id
  }

  dimension: hub_code {
    type: string
    label: "Hub Code"
  }

  dimension: created_date {
    label: "Order Dare"
    type: date
  }

  dimension: quantity {
    label: "Quantity Sold"
    type: number
    group_label: "> Monetary Dimensions"
  }


  dimension: vendor_price {
    label: "Buying Price"
    type: number
    value_format_name: decimal_4

  }

  measure: sum_quantity_sold {
    label: "SUM Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    hidden:  no
    type: sum
    sql: ${quantity};;
    value_format: "0"
    group_label: "> Absolute Metrics"
  }

  ###### metrics   ######

  dimension: quantity_per_buying_price {
    type: number
    hidden: yes
    sql:  (${quantity} * ${vendor_price})  ;;

  }

  measure: sum_quantity_per_buying_price {
    type: sum
    hidden: yes
    sql: ${quantity_per_buying_price};;

  }

  measure: weighted_buying_price {
    label: "€ Sales Weighted Buying Price"
    type: number
    value_format_name: euro_accounting_2_precision
    sql: ${sum_quantity_per_buying_price} / nullif (${sum_quantity_sold},0);;
  }

}
