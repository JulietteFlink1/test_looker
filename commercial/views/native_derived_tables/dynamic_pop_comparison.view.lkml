include: "/**/order_orderline_cl.explore.lkml"

view: dynamic_pop_comparison {
  derived_table: {
    explore_source: order_orderline_cl {
      column: country_iso          { field: orderline.country_iso }
      column: created_raw          { field: orderline.created_raw }
      column: sku                  { field: orderline.product_sku }
      column: hub_code             { field: orderline.hub_code }
      column: order_uuid           { field: orderline.order_uuid }
      column: sum_item_price_gross { field: orderline.sum_item_price_gross}
      column: sum_item_quantity    { field: orderline.sum_item_quantity}
      derived_column: unique_id {
        sql: concat(sku, country_iso, created_raw, hub_code) ;;
      }
    }
  }

  ## ---- Hidden dimensions needed for calculations  ---- ##

  dimension: unique_id {
    hidden: yes
    primary_key: yes
    label: "Unique ID"
  }

  dimension: created_raw {
    hidden: yes
    label: "Order Date"
    type: date_raw
  }

  dimension: order_uuid {
    hidden: yes
    type: string
    group_label: "*IDs*"
    label: "Order UUID"
  }

  dimension: country_iso {
    hidden: yes
    label: "Country Iso"
  }

  dimension: sku {
    hidden: yes
    label: "SKU"
    type: string
  }

  dimension: hub_code {
    hidden: yes
    label: "Hub Code"
    type: string
  }

  dimension: sum_item_quantity {
    hidden: yes
    label: "SUM Item Quantity Sold"
    description: "Sum of Item Quantity Sold"
    value_format: "0"
    type: number
  }

  dimension: sum_item_price_gross {
    hidden: yes
    label: "Sum Item Prices Sold (Gross)"
    description: "Sum of Item Prices Sold (Gross)"
    value_format_name: eur_0
    type: number
  }

  ## ----- FILTERS  ---- ##

  filter: first_period_filter {
    label: "Select First Time Period"
    view_label: "Period over Period (PoP) Comparison"
    type: date
    description: "Select the time range. This filter is used alongside the 'Select 2nd Time Period filter', to be able to compare different time frames to each other. "
  }

  filter: second_period_filter {
    label: "Select Second Time Period"
    view_label: "Period over Period (PoP) Comparison"
    type: date
    description: "Select the time range. This filter is used alongside the 'Select 1st Time Period' filter, to be able to compare different time frames to each other. "
  }

  ## ---- Dimensions  ---- ##

  dimension: period_selected {
    view_label: "Period over Period (PoP) Comparison"
    label: "Filtered Time Period (First/Second)"
    description: "This dimension only has 2 values: First or Second, representing time periods selected in filters ('Select First Time Period' and 'Select Second Time Period' filters). Use this dimension to see metrics per filtered time period."
    type: string
    sql:
        CASE
            WHEN {% condition first_period_filter %}${created_raw} {% endcondition %}
            THEN 'First Time Period'
            WHEN {% condition second_period_filter %}${created_raw} {% endcondition %}
            THEN 'Second Time Period'
            END ;;
  }

  ## ---- Measures  ---- ##

  measure: first_period_cnt_orders {
    view_label: "Period over Period (PoP) Comparison"
    label: "First Time Period: # Orders"
    type: count_distinct
    sql: ${order_uuid};;
    filters: [period_selected: "First Time Period"]
    value_format_name: decimal_0
    description: "# Orders for the period defined in 'Select First Time Period' filter"
  }

  measure: second_period_cnt_orders {
    view_label: "Period over Period (PoP) Comparison"
    label: "Second Time Period: # Orders"
    type: count_distinct
    sql: ${order_uuid};;
    filters: [period_selected: "Second Time Period"]
    value_format_name: decimal_0
    description: "# Orders for the period defined in 'Select Second Time Period' filter"
  }

  measure: cnt_orders_pop_change {
    view_label: "Period over Period (PoP) Comparison"
    label: "% PoP (# Orders)"
    type: number
    sql: (1.0 * ${second_period_cnt_orders} / NULLIF(${first_period_cnt_orders} ,0)) - 1 ;;
    value_format_name: percent_2
    description: "% Difference in '# Orders' between time periods defined via 'Select First Time Period' and 'Select Second Time Period' filters."

  }

  measure: first_period_sum_item_price_gross {
    view_label: "Period over Period (PoP) Comparison"
    label: "First Time Period: SUM Item Prices Sold (Gross)"
    type: sum
    sql: ${sum_item_price_gross};;
    filters: [period_selected: "First Time Period"]
    value_format_name: euro_accounting_2_precision
    description: "'SUM Item Prices Sold (Gross)' for the period defined in 'Select First Time Period' filter"
  }

  measure: second_period_sum_item_price_gross {
    view_label: "Period over Period (PoP) Comparison"
    label: "Second Time Period: SUM Item Prices Sold (Gross)"
    type: sum
    sql: ${sum_item_price_gross};;
    filters: [period_selected: "Second Time Period"]
    value_format_name: euro_accounting_2_precision
    description: "'SUM Item Prices Sold (Gross)' for the period defined in 'Select Second Time Period' filter"
  }

  measure: sum_item_price_gross_pop_change {
    view_label: "Period over Period (PoP) Comparison"
    label: "% PoP (SUM Item Prices Sold (Gross))"
    type: number
    sql: (1.0 * ${second_period_sum_item_price_gross} / NULLIF(${first_period_sum_item_price_gross} ,0)) - 1 ;;
    value_format_name: percent_2
    description: "% Difference in 'SUM Item Prices Sold (Gross)' between time periods defined via 'Select First Time Period' and 'Select Second Time Period' filters."
  }

  measure: first_period_sum_item_quantity {
    view_label: "Period over Period (PoP) Comparison"
    label: "First Time Period: SUM Item Quantity Sold"
    type: sum
    sql: ${sum_item_quantity};;
    filters: [period_selected: "First Time Period"]
    value_format_name: decimal_0
    description: "'SUM Item Quantity Sold' for the period defined in 'Select First Time Period' filter"
  }

  measure: second_period_sum_item_quantity {
    view_label: "Period over Period (PoP) Comparison"
    label: "Second Time Period: SUM Item Quantity Sold"
    type: sum
    sql: ${sum_item_quantity};;
    filters: [period_selected: "Second Time Period"]
    value_format_name: decimal_0
    description: "'SUM Item Quantity Sold' for the period defined in 'Select Second Time Period' filter"
  }

  measure: sum_item_quantity_pop_change {
    view_label: "Period over Period (PoP) Comparison"
    label: "% PoP (SUM Item Quantity Sold)"
    type: number
    sql: (1.0 * ${second_period_sum_item_quantity} / NULLIF(${first_period_sum_item_quantity} ,0)) - 1 ;;
    value_format_name: percent_2
    description: "% Difference in 'SUM Item Quantity Sold' between time periods defined via 'Select First Time Period' and 'Select Second Time Period' filters."
  }


}
