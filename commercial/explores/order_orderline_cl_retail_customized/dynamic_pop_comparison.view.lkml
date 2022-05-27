# If necessary, uncomment the line below to include explore_source.
include: "order_orderline_cl_retail_customized.explore.lkml"

view: dynamic_pop_comparison {
  derived_table: {
    explore_source: order_orderline_cl_retail_customized {
      column: country_iso { field: hubs.country_iso }
      column: created_raw { field: orderline.created_raw }
      column: created_date { field: orderline.created_date }
      column: sku { field: products.product_sku }
      column: product_name { field: products.product_name }
      column: hub_code { field: hubs.hub_code }
      column: city { field: hubs.city }
      column: category { field: products.category}
      column: subcategory { field: products.subcategory}
      column: cnt_orders { field: orders_cl.cnt_orders }
      column: sum_item_price_gross { field: orderline.sum_item_price_gross}
      column: sum_item_quantity { field: orderline.sum_item_quantity}
      derived_column: unique_id {
        sql: concat(sku, country_iso, created_raw, hub_code) ;;
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

      # Only works if joined to the table it is derived on, then you only have define smallest level dimensions
      # and the measures you want to aggregate
      bind_all_filters: yes

    }
  }

  ## Define dimensions
  dimension: unique_id {
    hidden: yes
    primary_key: yes
    label: "Unique ID"
  }

  dimension: country_iso {
    hidden: yes
    label: "Country Iso"
  }

  dimension: created_raw {
    hidden: yes
    label: "Order Date"
    type: date_raw

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

  dimension: product_name {
    hidden: yes
    label: "Product Name"
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

  dimension: hub_code {
    hidden: yes
    label: "Hub Code"
    type: string
  }

  dimension: city {
    hidden: yes
    label: "City"
    type: string
  }

  dimension: cnt_orders {
    hidden: yes
    label: "* Orders * # Orders"
    description: "Count of successful Orders"
    value_format: "0"
    type: number
  }

  dimension: sum_item_price_gross {
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


## ------------------ USER FILTERS  ------------------ ##

  filter: first_period_filter {
    view_label: "* Dynamic PoP *"
    description: "Choose the first date range to compare against. This must be before the second period"
    type: date
  }

  filter: second_period_filter {
    view_label: "* Dynamic PoP *"
    description: "Choose the second date range to compare to. This must be after the first period"
    type: date
  }

## ------------------ HIDDEN HELPER DIMENSIONS  ------------------ ##

  dimension: days_from_start_first {
    view_label: "* Dynamic PoP *"
    hidden: yes
    type: number
    sql: DATEDIFF('day',  {% date_start first_period_filter %}, ${created_date}) ;;
  }

  dimension: days_from_start_second {
    view_label: "* Dynamic PoP *"
    hidden: yes
    type: number
    sql: DATEDIFF('day',  {% date_start second_period_filter %}, ${created_date}) ;;
  }

## ------------------ DIMENSIONS TO PLOT ------------------ ##

  dimension: days_from_first_period {
    view_label: "* Dynamic PoP *"
    description: "Select for Grouping (Rows)"
    type: number
    sql:
        CASE
        WHEN ${days_from_start_second} >= 0
        THEN ${days_from_start_second}
        WHEN ${days_from_start_first} >= 0
        THEN ${days_from_start_first}
        END;;
  }


  dimension: period_selected {
    view_label: "* Dynamic PoP *"
    label: "First or second period"
    description: "Select for Comparison (Pivot)"
    type: string
    sql:
        CASE
            WHEN {% condition first_period_filter %}${created_raw} {% endcondition %}
            THEN 'First Period'
            WHEN {% condition second_period_filter %}${created_raw} {% endcondition %}
            THEN 'Second Period'
            END ;;
  }

## Filtered measures
# SUM Item Prices Sold (gross)
  measure: second_period_sum_item_price_gross {
    view_label: "* Dynamic PoP *"
    label: "Second P. - SUM Item Prices Sold (gross)"
    type: sum
    sql: ${sum_item_price_gross};;
    group_label: "SUM Item Prices Sold (gross)"
    filters: [period_selected: "Second Period"]
  }

  measure: first_period_sum_item_price_gross {
    view_label: "* Dynamic PoP *"
    label: "Second P. - SUM Item Prices Sold (gross)"
    type: sum
    sql: ${sum_item_price_gross};;
    group_label: "SUM Item Prices Sold (gross)"
    filters: [period_selected: "First Period"]
  }

  measure: sum_item_price_gross_pop_change {
    view_label: "* Dynamic PoP *"
    label: "% PoP - SUM Item Prices Sold (gross)"
    type: number
    sql: (1.0 * ${second_period_sum_item_price_gross} / NULLIF(${first_period_sum_item_price_gross} ,0)) - 1 ;;
    group_label: "SUM Item Prices Sold (gross)"
    value_format_name: percent_2
  }

  dimension: ytd_only {hidden:yes}
  dimension: mtd_only {hidden:yes}
  dimension: wtd_only {hidden:yes}

}
