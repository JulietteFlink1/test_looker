# If necessary, uncomment the line below to include explore_source.
#include: "order_orderline_cl.explore.lkml"

view: dynamically_filtered_measures {
  derived_table: {
    explore_source: order_orderline_cl {
      column: country_iso { field: orderline.country_iso }
      column: created_date { field: orderline.created_date }
      column: sku { field: products.product_sku }
      column: product_name { field: products.product_name }
      column: hub_code { field: hubs.hub_code }
      column: city { field: hubs.city }
      column: category { field: orderline.product_category_erp}
      column: subcategory { field: orderline.product_subcategory_erp}
      column: cnt_orders { field: orders_cl.cnt_orders }
      column: revenue_gross { field: orderline.sum_item_price_gross}
      column: sum_item_quantity { field: orderline.sum_item_quantity}
      derived_column: unique_id {
        sql: concat(sku, country_iso, created_date, hub_code) ;;
      }

      filters: [
        global_filters_and_parameters.datasource_filter: ""
      ]
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
      #bind_all_filters: yes

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
    group_label: "Product Attributes"
    suggest_dimension: sku
  }

  filter: product_name_filter {
    type: string
    label: "Product Name Dynamic Filter"
    group_label: "Product Attributes"
    suggest_dimension: product_name
  }

  filter: category_filter {
    type: string
    label: "Parent Category Dynamic Filter"
    group_label: "Product Attributes"
    suggest_dimension: category
  }
  filter: sub_category_filter {
    type: string
    label: "Sub-Category Dynamic Filter"
    group_label: "Product Attributes"
    suggest_dimension: subcategory
  }

  filter: hub_code_filter {
    type: string
    label: "Hub Code Dynamic Filter"
    group_label: "Geographic Dimensions"
    suggest_dimension: hub_code
  }

  filter: city_filter {
    type: string
    label: "City Dynamic Filter"
    group_label: "Geographic Dimensions"
    suggest_dimension: city
  }

  filter: country_iso_filter {
    type: string
    label: "Country ISO Dynamic Filter"
    group_label: "Geographic Dimensions"
    suggest_dimension: country_iso
  }

  # filter: created_date_filter {
  #   type: date
  #   label: "Date Dynamic Filter"
  #   group_label: "Time Dimensions"
  #   suggest_dimension: created_date
  # }


  ############### Dynamically filtered dimensions

  dimension: sku_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition sku_filter %} ${sku} {% endcondition %} ;;
  }

  dimension: product_name_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition product_name_filter %} ${product_name} {% endcondition %} ;;
  }

  dimension: category_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition category_filter %} ${category} {% endcondition %} ;;
  }

  dimension: sub_category_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition sub_category_filter %} ${subcategory} {% endcondition %} ;;
  }

  dimension: hub_code_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition hub_code_filter %} ${hub_code} {% endcondition %} ;;
  }

  dimension: city_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition city_filter %} ${city} {% endcondition %} ;;
  }

  dimension: country_iso_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition country_iso_filter %} ${country_iso} {% endcondition %} ;;
  }

  # dimension: created_date_satisfies_filter {
  #   type: yesno
  #   hidden: yes
  #   sql: {% condition created_date_filter %} ${created_date} {% endcondition %} ;;
  # }

  ############### Dynamically filtered measures

  measure: revenue_dynamic_filter {
    type: sum
    sql: ${revenue_gross} ;;
    label: "SUM Item Prices Sold (gross) - Dynamic Filter"
    description: "Sum of Item Prices Sold with dynamic filters applied"
    value_format_name: euro_accounting_2_precision
    filters: [sku_satisfies_filter: "yes", product_name_satisfies_filter: "yes",
      category_satisfies_filter: "yes", sub_category_satisfies_filter: "yes",
      hub_code_satisfies_filter: "yes", city_satisfies_filter: "yes",
      country_iso_satisfies_filter: "yes"]
  }

  measure: quantity_dynamic_filter {
    type: sum
    sql: ${sum_item_quantity} ;;
    label: "SUM Item Quantity Sold - Dynamic Filter"
    description: "Sum of Item Quantity Sold with dynamic filters applied"
    value_format: "0"
    filters: [sku_satisfies_filter: "yes", product_name_satisfies_filter: "yes",
      category_satisfies_filter: "yes", sub_category_satisfies_filter: "yes",
      hub_code_satisfies_filter: "yes", city_satisfies_filter: "yes",
      country_iso_satisfies_filter: "yes"]
  }

  #measure: cnt_orders_dynamic_filter {
  #  type: sum
  #  sql: ${cnt_orders} ;;
  #  label: "# of Orders - Dynamic Filter"
  #  description: "# of Orders with dynamic filters applied. Note that you no not apply smaller than order filters"
  #  value_format: "0"
  #  filters: [sku_satisfies_filter: "yes", product_name_satisfies_filter: "yes",
  #    category_satisfies_filter: "yes", sub_category_satisfies_filter: "yes",
  #    hub_code_satisfies_filter: "yes", city_satisfies_filter: "yes",
  #    country_iso_satisfies_filter: "yes"]
  #}

}
