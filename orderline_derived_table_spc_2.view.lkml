view: orderline_derived_table_spc_2 {
  derived_table: {
    explore_source: order_orderline_cl_updated_hourly {
      column: created_date { field: orderline.created_date }
      column: hub_code { field: orderline.hub_code }
      column: product_sku { field: orderline.product_sku }
      column: number_of_orderlines { field: orderline.number_of_orderlines }
      column: sum_item_quantity { field: orderline.sum_item_quantity }
      column: count_order_uuid { field: orderline.count_order_uuid }
      filters: {
        field: orders_cl.is_successful_order
        value: "yes"
      }
      filters: {
        field: hubs.hub_name
        value: ""
      }
      filters: {
        field: hubs.country
        value: ""
      }
    }
  }

  dimension: created_date {
    label: "* Order Lineitems * Order Date"
    description: "Order Placement Date"
    type: date
  }
  dimension: hub_code {
    label: "* Order Lineitems * Hub Code"
    description: ""
  }
  dimension: product_sku {
    label: "* Order Lineitems * Product SKU"
    description: ""
    value_format: "0"
  }
  dimension: number_of_orderlines {
    label: "* Order Lineitems * # Order Lineitems"
    description: ""
    type: number
  }
  dimension: sum_item_quantity {
    label: "* Order Lineitems * SUM Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    value_format: "0"
    type: number
  }
  dimension: count_order_uuid {
    label: "* Order Lineitems * Count Order"
    description: ""
    value_format: "0"
    type: number
  }
}
