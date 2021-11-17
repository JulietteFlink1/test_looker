view: orderline {
  sql_table_name: `flink-data-prod.curated.order_lineitems`
    ;;
  view_label: "* Order Lineitems *"
  drill_fields: [id]

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    group_label: "> Geographic Data"
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: quantity {
    label: "Quantity Sold"
    type: number
    sql: ${TABLE}.quantity ;;
    group_label: "> Monetary Dimensions"
  }

  dimension: quantity_fulfilled {
    label: "Quantity Fulfilled"
    type: number
    sql: ${TABLE}.quantity ;;
    group_label: "> Monetary Dimensions"
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.sku ;;
    value_format_name: id
    group_label: "> IDs"
  }



  # =========  hidden   =========
  dimension: is_shipping_required {
    type: yesno
    hidden: yes
    sql: null ;;
  }


  # =========  IDs   =========
  dimension: id {
    primary_key: no
    hidden: yes
    type: string
    sql: ${TABLE}.lineitem_id ;;
    group_label: "> IDs"
  }

  dimension: variant_id {
    type: number
    sql: null ;;
    group_label: "> IDs"
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
    group_label: "> IDs"
  }

  dimension: product_uuid {
    type: string
    sql: ${TABLE}.product_uuid ;;
    group_label: "> IDs"
  }

  dimension: order_lineitem_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.order_lineitem_uuid ;;
    group_label: "> IDs"
  }

  # =========  Monetary Dims   =========
  dimension: amt_discount {
    label: "Discount Amount"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_discount ;;
  }

  dimension: amt_revenue_gross {
    label: "Revenue Gross"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: amt_total_price_gross {
    label: "Total Price Gross"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_total_price_gross ;;
  }

  dimension: amt_total_price_net {
    label: "Total Price Net"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_total_price_net ;;
  }

  dimension: unit_price_gross_amount {
    label: "Unit Price Gross"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_unit_price_gross ;;
  }

  dimension: unit_price_net_amount {
    label: "Unit Price Net"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_unit_price_net ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
    group_label: "> Monetary Dimensions"
  }

  dimension: tax_rate {
    type: number
    sql: ${TABLE}.tax_rate ;;
    group_label: "> Monetary Dimensions"
  }


  # =========  Product Dims   =========
  dimension: product_category_erp {
    label: "Category Name"
    group_label: "> Product Attributes"
    type: string
    sql: ${products.category} ;;
  }

  dimension: true_erp_product_category {
    label: "Category Name (ERP)"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.product_category_erp ;;
  }

  dimension: true_erp_product_subcategory {
    label: "Subcategory Name (ERP)"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.product_subcategory_erp ;;
  }

  dimension: name {
    label: "Product Name"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_name_erp {
    label: "Product Name (ERP)"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.product_name_erp ;;
  }

  dimension: product_shelf_no {
    label: "Shelf Number"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.product_shelf_no ;;
  }

  dimension: slug {
    label: "Product Slug"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.product_slug ;;
  }

  dimension: product_subcategory_erp {
    type: string
    label: "Subcategory Name"
    group_label: "> Product Attributes"
    sql: ${products.subcategory} ;;
  }

  dimension: product_substitute_group {
    label: "Substitute Group"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.product_substitute_group ;;
  }

  dimension: product_unit {
    label: "Product Unit"
    group_label: "> Product Attributes"
    type: number
    sql: ${TABLE}.product_unit ;;
  }

  dimension: product_uom {
    label: "Unit of Measure"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.product_uom ;;
  }

  dimension: variant_name {
    label: "Variant Name"
    group_label: "> Product Attributes"
    type: string
    sql: null ;;
  }

  dimension: ean {
    label: "EAN"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: brand {
    label: "Brand"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: translated_product_name {
    type: string
    sql: null ;;
    hidden: yes
  }

  dimension: translated_variant_name {
    type: string
    sql: null ;;
    hidden: yes
  }


  # =========  Admin Dims   =========
  dimension: backend_source {
    type: string
    sql: ${TABLE}.backend_source ;;
    group_label: "> Admin Data"
  }


  # =========  Dates &  Timestamps   =========
  dimension_group: last_modified {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_at ;;
    group_label: "> Dates & Timestamps"
  }

  dimension_group: created {
    group_label: "> Dates & Timestamps"
    label: "Order"
    description: "Order Placement Date"
    type: time
    timeframes: [
      raw,
      minute15,
      minute30,
      hour_of_day,
      hour,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_timestamp ;;
    datatype: timestamp
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ##########
  ## SUMS ##
  ##########

  measure: sum_item_quantity {
    label: "SUM Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    hidden:  no
    type: sum
    sql: ${quantity};;
    value_format: "0"
    group_label: "> Absolute Metrics"
  }

  measure: sum_item_quantity_fulfilled {
    label: "SUM Item Quantity fulfilled"
    description: "Quantity of Order Line Items fulfilled"
    hidden:  no
    type: sum
    sql: ${quantity_fulfilled};;
    value_format: "0"
    group_label: "> Absolute Metrics"
  }

  measure: sum_item_price_gross {
    label: "SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_gross};;
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_item_price_net {
    label: "SUM Item Prices sold (net)"
    description: "Sum of sold Item prices (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_net};;
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_item_price_fulfilled_gross {
    label: "SUM Item Prices fulfilled (gross)"
    description: "Sum of fulfilled Item prices (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_gross};;
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_item_price_fulfilled_net {
    label: "SUM Item Prices fulfilled (net)"
    description: "Sum of fulfilled Item prices (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_net};;
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: ctn_skus {
    type: count_distinct
    label: "# Unqiue SKUS"
    sql: ${product_sku} ;;
    value_format_name: decimal_1
    group_label: "> Absolute Metrics"
  }

  measure: sum_revenue_gross {
    label: "SUM of Gross Revenue"
    sql: ${amt_revenue_gross} ;;
    type: sum
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  ###################### orderline facts

  measure: avg_daily_item_quantity_today {
    group_label: "> Sold Quantities"
    label: "# Total Sales (today)"
    description: "Average Daily Quantity of Products sold considering only the current day"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "today"]
    value_format: "0"
  }

  measure: avg_daily_item_quantity_last_1d {
    group_label: "> Sold Quantities"
    label: "# Total Sales (prev day)"
    description: "Average Daily Quantity of Products sold considering only the previous day"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "1 day ago"]
    value_format: "0"
  }

  measure: sum_item_quantity_last_3d {
    group_label: "> Sold Quantities"
    label: "# Total Sales (last 3d)"
    description: "Quantity of Order Line Items sold in the previous 3 days"
    hidden:  yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "3 days ago for 3 days"]
    value_format: "0"
  }

  measure: sum_item_quantity_last_30d {
    group_label: "> Sold Quantities"
    label: "# Total Sales (last 30d)"
    description: "Quantity of Order Line Items sold in the previous 30 days"
    hidden:  yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "30 days ago for 30 days"]
    value_format: "0"
  }

  measure: avg_daily_item_quantity_last_3d {
    group_label: "> Sold Quantities"
    label: "# AVG daily sales (last 3d)"
    description: "Average Daily Quantity of Products sold considering the previous 3 days"
    hidden:  no
    type: number
    sql: ${sum_item_quantity_last_3d} / 3;;
    value_format: "0.00"
  }

  measure: sum_item_quantity_last_7d {
    group_label: "> Sold Quantities"
    label: "# Total Sales (last 7d)"
    description: "Quantity of Order Line Items sold in the previous 7 days"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "7 days ago for 7 days"]
    value_format: "0.0"
  }

  measure: avg_daily_item_quantity_last_7d {
    group_label: "> Sold Quantities"
    label: "# AVG daily sales (last 7d)"
    description: "Average Daily Quantity of Products sold considering the previous 7 days"
    hidden:  no
    type: number
    sql: ${sum_item_quantity_last_7d} / 7;;
    value_format: "0.0"
  }

  measure: sum_item_quantity_last_14d {
    group_label: "> Sold Quantities"
    label: "# Total Sales (last 14d)"
    description: "Quantity of Order Line Items sold in the previous 14 days"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "14 days ago for 14 days"]
    value_format: "0.0"
  }

  measure: avg_daily_item_quantity_last_14d {
    group_label: "> Sold Quantities"
    label: "# AVG daily sales (last 14d)"
    description: "Average Daily Quantity of Products sold considering the previous 14 days"
    hidden:  no
    type: number
    sql: ${sum_item_quantity_last_14d} / 14;;
    value_format: "0.0"
  }

  measure: sum_item_price_gross_14d {
    label: "SUM Item Prices sold (gross) - Last 14 days"
    description: "Sum of sold Item prices (incl. VAT) - in the Last 14 days"
    hidden:  no
    type: sum
    sql: ${quantity} * ${unit_price_gross_amount};;
    value_format_name: eur
    filters: [created_date: "14 days ago for 14 days"]
    group_label: "> Monetary Metrics"
  }

  measure: sum_item_price_gross_7d {
    label: "SUM Item Prices sold (gross) - Last 7 days"
    description: "Sum of sold Item prices (incl. VAT) - in the Last 14 days"
    hidden:  no
    type: sum
    sql: ${quantity} * ${unit_price_gross_amount};;
    value_format_name: eur
    filters: [created_date: "7 days ago for 7 days"]
    group_label: "> Monetary Metrics"
  }

  measure: number_of_orderlines {
    label: "# Order Lineitems"
    group_label: "> Absolute Metrics"
    type: count
    drill_fields: [id, name]
  }
}
