# If necessary, uncomment the line below to include explore_source.
# include: "supply_chain.explore.lkml"

view: waste_index {
  derived_table: {
    explore_source: supply_chain {
      column: hub_code { field: hubs_ct.hub_code }
      column: product_sku { field: products.product_sku }
      column: sum_item_price_gross { field: order_lineitems.sum_item_price_gross }
      column: mean_item_price_gross { field: mean_and_std.mean_item_price_gross }
      column: var_item_price_gross { field: mean_and_std.var_item_price_gross }
      column: std_item_price_gross { field: mean_and_std.std_item_price_gross }
      column: created_time { field: order_lineitems.created_time }
      column: key_index { field: mean_and_std.key_index }
     bind_all_filters: yes
    }
  }
  dimension: hub_code {
    label: "Hub Code"
    hidden: yes
    description: ""
  }
  dimension: product_sku {
    label: "SKU"
    hidden: yes
    description: ""
  }
  dimension: sum_item_price_gross {
    label: "SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    value_format: "#,##0.00"
    hidden: yes
    type: number
  }
  dimension: mean_item_price_gross {
    label: "Mean Item Price Gross"
    group_label: "> Waste Metrics"
    description: ""
    type: number
    value_format_name: decimal_2
  }
  dimension: var_item_price_gross {
    label: "Var Item Price Gross"
    group_label: "> Waste Metrics"
    description: ""
    type: number
  }
  dimension: std_item_price_gross {
    label: "StD Item Price Gross"
    group_label: "> Waste Metrics"
    description: ""
    type: number
  }
  dimension: created_time {
    label: "Order Time"
    hidden: yes
    description: "Order Placement Date"
    type: date_time
  }
  dimension: key_index {
    label: "Waste Index"
    group_label: "> Waste Metrics"
    description: ""
    type: number
  }
  dimension: table_uuid {
    primary_key: yes
    hidden: yes
    sql: concat(${created_time},${hub_code},${product_sku}) ;;
  }

  dimension: key_index_tier  {
    type: tier
    label: "Waste Risk Index Tier"
    group_label: "> Waste Metrics"
    tiers: [0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6]
    style: relational
    hidden: no
    sql: ${key_index} ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~   Measures   ~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: count_index {
    label: "Count Waste Risk Index"
    type: count_distinct
    hidden: no
    sql: ${product_sku} ;;
  }

}
