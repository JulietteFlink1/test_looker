# If necessary, uncomment the line below to include explore_source.
# include: "supply_chain.explore.lkml"

view: mean_and_std{
  derived_table: {
    explore_source: supply_chain {
      column: created_date         { field: order_lineitems.created_date }
      column: hub_code              { field: hubs_ct.hub_code }
      column: product_sku           { field: products.product_sku }
      column: sum_item_price_gross  { field: order_lineitems.sum_item_price_gross }
      bind_all_filters: yes
    }
  }

  dimension: tabel_uuid {
    hidden: yes
    sql: concat(${created_date},${hub_code},${product_sku}) ;;
    primary_key: yes
  }

  dimension: created_date {
    label: "Order Date"
    description: "Order Placement Date"
    hidden: yes
    type: date
    }
  dimension: hub_code {
    label: "Hub Code"
    description: ""
    hidden: yes
  }
  dimension: product_sku {
    label: "SKU"
    description: ""
    hidden: yes
  }
  dimension: sum_item_price_gross {
    label: "SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    type: number
    hidden: yes
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~   Measures   ~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

measure: mean_item_price_gross {
  label: "Mean Item Price Gross ori"
  hidden: yes
  sql: ${sum_item_price_gross} ;;
  type: average
  value_format_name: decimal_2
}


measure: std_item_price_gross {
  label: "StD Item Price Gross"
  hidden: yes
  type: number
 # sql_distinct_key: ${created_date} ;;
  sql: round(stddev(${sum_item_price_gross}), 2) ;;
}

  measure: var_item_price_gross {
    label: "Var Item Price Gross"
    hidden: yes
    type: number
    sql: round(variance(${sum_item_price_gross}), 2) ;;
  }

measure: key_index {
  label: "Key Index"
  hidden: yes
  type: number
  sql: round(${mean_item_price_gross} / nullif(${std_item_price_gross}, 0), 2) ;;
}


}
