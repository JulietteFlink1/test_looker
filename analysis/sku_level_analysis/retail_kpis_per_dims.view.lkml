# If necessary, uncomment the line below to include explore_source.
# include: "retail_kpis.explore.lkml"

view: retail_kpis_per_dims {
  derived_table: {
    explore_source: retail_orders_explore {
      column: sum_item_price_net         { field: order_orderline.sum_item_price_net }
      column: equalized_revenue          { field: retail_kpis_equalized_revenue.equalized_revenue }
      column: equalized_revenue_current  { field: retail_kpis_equalized_revenue.equalized_revenue_current }
      column: equalized_revenue_previous { field: retail_kpis_equalized_revenue.equalized_revenue_previous }

      column: name          { field: product_category.name }
      column: product_sku   { field: order_orderline.product_sku }
      column: created_date  { field: retail_orders_explore.created_date}

      derived_column: test {
        sql: SUM(sum_item_price_net) OVER (PARTITION BY name) ;;
      }

      # derived_column: equalized_revenue_per_subcategory {
      #   sql: SUM(equalized_revenue) OVER (PARTITION BY name) ;;
      # }



      # bind_all_filters: yes
    }
  }


  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(${product_sku}, CAST(${created_date} AS STRING) ) ;;
  }


  dimension: name {}

  dimension: product_sku {}

  dimension: created_date {
    label: "* Orders * Order Date"
    description: "Order Placement Date/Time"
    type: date
  }

  dimension: test {

  }
}
