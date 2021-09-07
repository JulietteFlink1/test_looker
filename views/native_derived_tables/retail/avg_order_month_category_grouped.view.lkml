# If necessary, uncomment the line below to include explore_source.

# include: "avg_order_basket_per_category.explore.lkml"

view: avg_order_month_category_grouped {
  derived_table: {
    explore_source: avg_order_basket_per_category {
      column: created_date { field: orders_cl.order_date }
      column: cnt_unique_order_id {field: orders_cl.cnt_orders}
      column: sum_item_price_fulfilled_gross { field: orderline.sum_item_price_fulfilled_gross }
      column: product_category_erp { field: orderline.product_category_erp }

      bind_all_filters: yes
    }
  }

  dimension: id {
    sql: concat(cast(${created_date} as string), ${product_category_erp}) ;;
    primary_key: yes
    hidden: yes
  }


  dimension: created_date {
    label: "* Orderline Items * Order Date"
    description: "Order Placement Date"
    type: date
  }

  measure: sum_item_price_fulfilled_gross {
    label: "Orderline SUM Item Prices fulfilled (gross)"
    description: "Sum of fulfilled Item prices (incl. VAT)"
    value_format_name: eur
    type: sum
  }

  measure: cnt_unique_order_id {
    label: "count unique orders"
    description: "count unique orders"
    value_format_name: id
    type: count_distinct
  }
  dimension: product_category_erp {
    label: "Orderline Category Name"
  }
}
