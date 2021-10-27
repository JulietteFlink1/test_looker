# If necessary, uncomment the line below to include explore_source.
# include: "order_orderline_cl.explore.lkml"

  view: sku_level_sales_data {
    derived_table: {
      explore_source: order_orderline_cl {
        column: product_sku { field: products.product_sku }
        column: sum_item_quantity { field: orderline.sum_item_quantity }
        column: sum_item_price_gross { field: orderline.sum_item_price_gross }
        filters: {
          field: orders_cl.is_successful_order
          value: "yes"
        }
        filters: {
          field: orders_cl.created_date
          value: "14 days"
        }
        filters: {
          field: hubs.country
          value: ""
        }
        filters: {
          field: hubs.hub_name
          value: ""
        }
        filters: {
          field: orderline.created_date
          value: "14 days"
        }
      }
    }
    dimension: product_sku {
      label: "* Product Data * SKU"
    }
    dimension: sum_item_quantity {
      label: "* Order Lineitems * SUM Item Quantity sold"
      description: "Quantity of Order Line Items sold"
      value_format: "0"
      type: number
    }
    dimension: sum_item_price_gross {
      label: "* Order Lineitems * SUM Item Prices sold (gross)"
      description: "Sum of sold Item prices (incl. VAT)"
      value_format: "'€'#,##0.00"
      type: number
    }
}
