# If necessary, uncomment the line below to include explore_source.
#include: "order_orderline_cl.explore.lkml"

view: dynamically_filtered_measures {
  derived_table: {
    explore_source: order_orderline_cl {
      column: country_iso { field: orderline.country_iso }
      column: created_date { field: orderline.created_date }
      column: sku { field: orderline.product_sku }
      column: category { field: orderline.product_category_erp}
      column: subcategory { field: orderline.product_subcategory_erp}
      column: cnt_orders { field: orders_cl.cnt_orders }
      column: revenue_gross { field: orderline.sum_item_price_gross}
      column: sum_item_quantity { field: orderline.sum_item_quantity}
      derived_column: unique_id {
        sql: concat(sku, country_iso, created_date) ;;
      }
      # derived_column: pop_orders {
      #   sql:  (cnt_orders - LEAD(cnt_orders) OVER (PARTITION BY country_iso ORDER BY date DESC))
      #       /
      #       nullif(LEAD(cnt_orders) OVER (PARTITION BY country_iso ORDER BY date DESC), 0) ;;
      # }
      # derived_column: pop_revenue {
      #   sql:  (revenue_gross - LEAD(revenue_gross) OVER (PARTITION BY country_iso ORDER BY date DESC))
      #       /
      #       nullif(LEAD(revenue_gross) OVER (PARTITION BY country_iso ORDER BY date DESC), 0) ;;
      # }
    }
  }

  dimension: unique_id {
    hidden: yes
    primary_key: yes
    label: "Unique ID"
  }

  dimension: country_iso {
    hidden: yes
    label: "* Dynamic Filters * Country Iso"
  }

  dimension: created_date {
    hidden: yes
    label: "Order Date"
    type: date
  }

  dimension: sku {
    hidden: yes
    label: "SKU"
    type: string
  }

  dimension: category {
    hidden: yes
    label: "Parent Category"
    type: string
  }

  dimension: subcategory {
    hidden: yes
    label: "Sub-Category"
    type: string
  }

  dimension: cnt_orders {
    hidden: yes
    label: "* Orders * # Orders"
    description: "Count of successful Orders"
    value_format: "0"
    type: number
  }

  dimension: revenue_gross {
    hidden: yes
    label: "Sum Item Prices Sold (gross)"
    description: "Sum of Item Prices Sold (gross)"
    value_format_name: eur_0
    type: number
  }

  dimension: sum_item_quantity {
    hidden: yes
    label: "SUM Item Quantity Sold"
    description: "Sum of Item Quantity Sold"
    value_format: "0"
    type: number
  }

  # dimension: pop_orders {
  #   label: "PoP (Week) Orders Growth - Country"
  #   type: number
  #   value_format_name: percent_2
  #   hidden: yes
  # }

  # dimension: pop_revenue {
  #   label: "PoP (Week) Revenue Growth - Country"
  #   type: number
  #   value_format_name: percent_2
  #   hidden: yes
  # }

  ############### Measures

  # measure: pop_orders_max {
  #   type: average
  #   sql: ${pop_orders} ;;
  #   label: "PoP Orders - Country"
  #   group_label: "Weekly"
  #   value_format_name: percent_2
  # }

  # measure: pop_revenue_max {
  #   type: average
  #   sql: ${pop_revenue} ;;
  #   label: "PoP Revenue - Country"
  #   group_label: "Weekly"
  #   value_format_name: percent_2
  # }

  ############### Dynamic Filters

  filter: sku_filter {
    type: string
    label: "SKU Dynamic Filter"
    group_label: "SKU"
    suggest_dimension: sku
  }

  ############### Dynamically filtered dimensions

  dimension: sku_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition sku_filter %} ${sku} {% endcondition %} ;;
  }

  ############### Dynamically filtered measures

  measure: revenue_dynamic_filter_sku {
    type: sum
    sql: ${revenue_gross} ;;
    label: "SKU Filter: Revenue"
    description: "Sum of Item Prices Sold where SKU is SKU Dynamic Filter"
    group_label: "SKU"
    value_format_name: euro_accounting_2_precision
    filters: [sku_satisfies_filter: "yes"]
  }

}
