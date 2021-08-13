view: orderline {
  sql_table_name: `flink-data-prod.curated.order_lineitems`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: no
    hidden: yes
    type: string
    sql: ${TABLE}.lineitem_id ;;
  }

  dimension: amt_discount {
    type: number
    sql: ${TABLE}.amt_discount ;;
  }

  dimension: amt_revenue_gross {
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: amt_total_price_gross {
    type: number
    sql: ${TABLE}.amt_total_price_gross ;;
  }

  dimension: amt_total_price_net {
    type: number
    sql: ${TABLE}.amt_total_price_net ;;
  }

  dimension: unit_price_gross_amount {
    type: number
    sql: ${TABLE}.amt_unit_price_gross ;;
  }

  dimension: unit_price_net_amount {
    type: number
    sql: ${TABLE}.amt_unit_price_net ;;
  }

  dimension: variant_id {
    type: number
    sql: null ;;
  }

  dimension: variant_name {
    type: string
    sql: null ;;
  }

  dimension: backend_source {
    type: string
    sql: ${TABLE}.backend_source ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: is_shipping_required {
    type: yesno
    hidden: yes
    sql: null ;;
  }

  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
  }

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
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
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

  dimension: product_category_erp {
    label: "Category Name"
    type: string
    sql: ${TABLE}.product_category_erp ;;
  }

  dimension: name {
    label: "Product Name"
    group_label: "* Product Attributes *"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_name_erp {
    type: string
    sql: ${TABLE}.product_name_erp ;;
  }

  dimension: product_shelf_no {
    type: string
    sql: ${TABLE}.product_shelf_no ;;
  }

  dimension: slug {
    type: string
    sql: ${TABLE}.product_slug ;;
  }

  dimension: product_subcategory_erp {
    type: string
    label: "Subcategory Name"
    sql: ${TABLE}.product_subcategory_erp ;;
  }

  dimension: product_substitute_group {
    type: string
    sql: ${TABLE}.product_substitute_group ;;
  }

  dimension: product_unit {
    type: number
    sql: ${TABLE}.product_unit ;;
  }

  dimension: product_uom {
    type: string
    sql: ${TABLE}.product_uom ;;
  }

  dimension: product_uuid {
    type: string
    sql: ${TABLE}.product_uuid ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: quantity_fulfilled {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: product_sku {
    type: number
    sql: ${TABLE}.sku ;;
    value_format_name: id
  }

  dimension: tax_rate {
    type: number
    sql: ${TABLE}.tax_rate ;;
  }

  dimension: translated_product_name {
    type: string
    sql: null ;;
  }

  dimension: translated_variant_name {
    type: string
    sql: null ;;
  }

  dimension: order_lineitem_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.order_lineitem_uuid ;;
  }

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
  }

  measure: sum_item_quantity_fulfilled {
    label: "SUM Item Quantity fulfilled"
    description: "Quantity of Order Line Items fulfilled"
    hidden:  no
    type: sum
    sql: ${quantity_fulfilled};;
    value_format: "0"
  }

  measure: sum_item_price_gross {
    label: "SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_item_price_net {
    label: "SUM Item Prices sold (net)"
    description: "Sum of sold Item prices (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_item_price_fulfilled_gross {
    label: "SUM Item Prices fulfilled (gross)"
    description: "Sum of fulfilled Item prices (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_item_price_fulfilled_net {
    label: "SUM Item Prices fulfilled (net)"
    description: "Sum of fulfilled Item prices (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: ctn_skus {
    type: count_distinct
    label: "AVG SKUS"
    sql: ${product_sku} ;;
    value_format_name: decimal_1
  }

  ###################### orderline facts

  measure: avg_daily_item_quantity_today {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (today)"
    description: "Average Daily Quantity of Products sold considering only the current day"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "today"]
    value_format: "0"
  }

  measure: avg_daily_item_quantity_last_1d {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (prev day)"
    description: "Average Daily Quantity of Products sold considering only the previous day"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "1 day ago"]
    value_format: "0"
  }

  measure: sum_item_quantity_last_3d {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (last 3d)"
    description: "Quantity of Order Line Items sold in the previous 3 days"
    hidden:  yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "3 days ago for 3 days"]
    value_format: "0"
  }

  measure: sum_item_quantity_last_30d {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (last 30d)"
    description: "Quantity of Order Line Items sold in the previous 30 days"
    hidden:  yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "30 days ago for 30 days"]
    value_format: "0"
  }

  measure: avg_daily_item_quantity_last_3d {
    group_label: "* Sold Quantities *"
    label: "# AVG daily sales (last 3d)"
    description: "Average Daily Quantity of Products sold considering the previous 3 days"
    hidden:  no
    type: number
    sql: ${sum_item_quantity_last_3d} / 3;;
    value_format: "0.00"
  }

  measure: sum_item_quantity_last_7d {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (last 7d)"
    description: "Quantity of Order Line Items sold in the previous 7 days"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "7 days ago for 7 days"]
    value_format: "0.0"
  }

  measure: avg_daily_item_quantity_last_7d {
    group_label: "* Sold Quantities *"
    label: "# AVG daily sales (last 7d)"
    description: "Average Daily Quantity of Products sold considering the previous 7 days"
    hidden:  no
    type: number
    sql: ${sum_item_quantity_last_7d} / 7;;
    value_format: "0.0"
  }

  measure: pct_stock_range_1d {
    group_label: "* Operations / Logistics *"
    label: "Stock Range [days, based on 1d avg.]"
    description: "Current stock divided by 1d AVG Daily Sales"
    hidden:  no
    type: number
    sql: null;;
    value_format: "0.0"
  }

  measure: pct_stock_range_3d {
    group_label: "* Operations / Logistics *"
    label: "Stock Range [days, based on 3d avg.]"
    description: "Current stock divided by 3d AVG Daily Sales"
    hidden:  no
    type: number
    sql: null;;
    value_format: "0.0"
  }

  measure: pct_stock_range_7d {
    group_label: "* Operations / Logistics *"
    label: "Stock Range [days, based on 7d avg.]"
    description: "Current stock divided by 7d AVG Daily Sales"
    hidden:  no
    type: number
    sql: null;;
    value_format: "0.0"
  }

  measure: number_of_orderlines {
    type: count
    drill_fields: [id, name]
  }
}
