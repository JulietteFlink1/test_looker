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
    description: "The quantity of products, that have been sold in an order. It excludes sampled products (products that were partially or completely sponsored by the producer)"
    alias: [quantity_fulfilled]
    type: number
    sql: ${TABLE}.quantity ;;
    group_label: "> Monetary Dimensions"
  }

  dimension: quantity_sampled {
    label: "Quantity Sampled"
    description: "The quantity of 'sampled' products - promotional products that were partially or completely sponsored by the producer."
    type: number
    sql: ${TABLE}.quantity_sampled ;;
    group_label: "> Monetary Dimensions"
  }

  dimension: quantity_returned {
    label: "Quantity Returned"
    type: number
    sql: ${TABLE}.quantity_returned ;;
    group_label: "> Monetary Dimensions"
  }

  dimension: return_reason {
    label: "Return Reason"
    type: number
    sql: ${TABLE}.return_reason ;;
    group_label: "> Monetary Dimensions"
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.sku ;;
    value_format_name: id
    group_label: "> IDs"
  }

  dimension: is_successful_order {
    label: "Is Successful Order"
    type: yesno
    sql: ${TABLE}.is_successful_order ;;
  }

  dimension: external_provider {
    type: string
    label: "External Provider"
    sql: ${TABLE}.external_provider ;;
  }

  dimension: is_external_order {
    type: yesno
    label: "Is External Order"
    sql: ${TABLE}.is_external_order ;;
  }

  dimension: is_last_mile_order {
    type: yesno
    sql: ${TABLE}.is_last_mile_order ;;
    description: "TRUE if the order is delivered by Flink's riders.
    Not click and collect order, not created through an external provider (e.g. uber-eats and wolt).
    Doordash orders are included as they are delivered by Flink's riders."
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
  dimension: amt_discount_gross {
    label: "Discount Amount (Gross)"
    group_label: "> Monetary Dimensions"
    type: number
    value_format_name: euro_accounting_0_precision
    sql: ${TABLE}.amt_discount ;;
  }

  dimension: amt_discount_net {
    label: "Discount Amount (Net)"
    group_label: "> Monetary Dimensions"
    type: number
    value_format_name: euro_accounting_0_precision
    sql: ${TABLE}.amt_discount/(1+${tax_rate}) ;;
  }

  dimension: amt_discount_products_gross {
    label: "Product Discount Amount (Gross)"
    group_label: "> Monetary Dimensions"
    type: number
    value_format_name: euro_accounting_0_precision
    sql: ${TABLE}.amt_discount_products_gross ;;
  }

  dimension: amt_discount_products_net {
    label: "Product Discount Amount (Net)"
    group_label: "> Monetary Dimensions"
    type: number
    value_format_name: euro_accounting_0_precision
    sql: ${TABLE}.amt_discount_products_net ;;
  }

  dimension: amt_revenue_gross {
    label: "Revenue Gross"
    group_label: "> Monetary Dimensions"
    description: "SUM of Item Sold Prices after deduction of all discounts (Cart and Product Discounts)"
    type: number
    sql: ${amt_total_price_gross} - ${amt_discount_gross} ;;
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

  dimension: amt_total_price_after_product_discount_gross {
    label: "Total Price Gross (After Product Discount)"
    description: "Unit Price of the Product after Deduction of Product discounts multiplied by Quantity Sold. incl. VAT"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_total_price_after_product_discount_gross ;;
  }

  dimension: amt_total_price_after_product_discount_net {
    label: "Total Price Net (After Product Discount)"
    description: "Unit Price of the Product after Deduction of Product discounts multiplied by Quantity Sold. excl. VAT"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_total_price_after_product_discount_net ;;
  }

  dimension: unit_price_after_product_discount_net {
    label: "Unit Price Net (After Product Discount)"
    description: "Unit Price of the Product after Deduction of Product discounts. excl. VAT"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_unit_price_after_product_discount_net ;;
  }

  dimension: unit_price_after_product_discount_gross {
    label: "Unit Price Gross (After Product Discount)"
    description: "Unit Price of the Product after Deduction of Product discounts. incl. VAT"
    group_label: "> Monetary Dimensions"
    type: number
    sql: ${TABLE}.amt_unit_price_after_product_discount_gross ;;
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

  dimension: amt_refund_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_refund_net;;
    group_label: "> Monetary Dimensions"
  }

  dimension: amt_refund_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_refund_gross;;
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

  dimension: is_charity_sku {

    label:       "Is Charity SKU"
    description: "This boolean is TRUE, in case a SKU refers to a donation SKU and is FALSE, if not"
    group_label: "> Product Attributes"

    type: yesno
    sql: ${TABLE}.is_charity_sku ;;

  }

  dimension: is_sampled_item {
    label: "Is Sampled Item"
    description: "TRUE if the line-item of an order is a sponsored product by the product manufacturer."
    group_label: "> Product Attributes"
    type: yesno
    sql: ${TABLE}.is_sampled_item ;;
  }

  dimension: product_sample_type {
    label: "Product Sample Type"
    description: "This field defines the type of a sampled product and can have the values {commercial_sample, marketing_sample}. commercial_samples are fully funded by the producer, whereas marketing_samples are covered by both, Flink and the producer as part of a deal."
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.product_sample_type ;;
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

  dimension: amt_unit_deposit {
    type: string
    sql: ${TABLE}.amt_unit_deposit;;
    hidden: yes
  }

  dimension: amt_total_deposit {
    type: string
    sql: ${TABLE}.amt_total_deposit;;
    hidden: yes
  }

  dimension: amt_buying_price_net_eur {
    required_access_grants: [can_access_pricing_margins]
    type: number
    sql: ${TABLE}.amt_buying_price_net_eur;;
    hidden: yes
  }

  dimension: amt_weighted_average_cost_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "Buying Price (Net)"
    description: "Buying price, that can be used for product sales. It resembles the weighted buying price of the current stock. This is done (in Oracle) to ensure that we value the inventory at any given day with the average value of our current stock (and not with the most recent buying price to place a supplier order). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${TABLE}.amt_buying_price_weighted_rolling_average_net_eur ;;
    value_format_name: decimal_4
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
      day_of_week_index,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_timestamp ;;
    datatype: timestamp
  }

  dimension: order_date_utc {
    hidden: yes
    convert_tz: no
    sql: date(${TABLE}.order_timestamp) ;;
    datatype: date
    type: date
  }


  ############# Delivery Issue

  dimension: delivery_issue_stage {

    label: "Delivery Issue Stage"
    description: "Classifies delivery issues in either Pre delivery (source: picker) or Post delivery (source: customer care)"
    group_label: "> Delivery Issues"

    type: string
    sql: ${TABLE}.delivery_issue_stage ;;
  }

  dimension: delivery_issue_groups {

    label: "Delivery Issue Groups"
    description: "The delivery issue groups based on CT"
    group_label: "> Delivery Issues"

    type: string
    sql: ${TABLE}.return_reason ;;
  }

  dimension: number_of_products_with_perished_light_issues_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_perished_light_issues ;;
  }
  dimension: number_of_products_with_perished_issues_post_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_perished_issues_post;;
  }

  dimension: number_of_products_with_perished_issues_pre_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_perished_issues_pre;;
  }

  dimension: number_of_products_with_products_not_on_shelf_issues_pre_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_products_not_on_shelf_issues_pre;;
  }

  dimension: number_of_products_with_products_not_on_shelf_issues_post_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_products_not_on_shelf_issues_post;;
  }

  dimension: number_of_products_with_damaged_products_issues_pre_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_damaged_products_issues_pre;;
  }

  dimension: number_of_products_with_damaged_products_issues_post_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_damaged_products_issues_post;;
  }

  dimension: number_of_products_with_missing_products_issues_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_missing_products_issues ;;
  }

  dimension: number_of_products_with_wrong_products_issues_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_wrong_products_issues ;;
  }

  dimension: number_of_products_with_swapped_products_issues_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_swapped_products_issues ;;
  }

  dimension: number_of_products_with_cancelled_products_issues_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_cancelled_products_issues ;;
  }

  dimension: number_of_products_with_item_description_issues_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_item_description_issues ;;
  }

  dimension: number_of_products_with_item_quality_issues_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_item_quality_issues ;;
  }

  dimension: number_of_products_with_goodwill_issues_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_goodwill_issues ;;
  }

  dimension: number_of_products_with_undefined_issues_dim {

    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_products_with_undefined_issues ;;
  }

  dimension: number_of_products_with_post_delivery_issues_dim {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_products_with_post_delivery_issues ;;
  }

  ########### SINGLE USE PLASTIC FEES ##########

  dimension: amt_sup_fee_gross_eur {
    type: number
    label: "AMT SUP Fee (Gross)"
    hidden: yes
    sql: ${TABLE}.amt_sup_fee_gross_eur ;;
  }

  dimension: amt_sup_fee_net_eur {
    type: number
    label: "AMT SUP Fee (Net)"
    hidden: yes
    sql: ${TABLE}.amt_sup_fee_net_eur ;;
  }

  dimension: amt_refund_sup_fee_gross_eur {
    type: number
    label: "AMT Refund SUP Fee (Gross)"
    hidden: yes
    sql: ${TABLE}.amt_refund_sup_fee_gross_eur ;;
  }

  dimension: amt_refund_sup_fee_net_eur {
    type: number
    label: "AMT Refund SUP Fee (Net)"
    hidden: yes
    sql: ${TABLE}.amt_refund_sup_fee_net_eur ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ##########
  ## SUMS ##
  ##########

  measure: sum_item_quantity {
    label: "SUM Item Quantity Sold"
    alias: [sum_item_quantity_fulfilled]
    description: "The quantity of products, that have been sold in an order. It excludes sampled products (products that were partially or completely sponsored by the producer)"
    hidden:  no
    type: sum
    sql: ${quantity};;
    value_format: "0"
    group_label: "> Absolute Metrics"
  }

  measure: sum_item_quantity_sampled {
    label: "SUM Item Quantity Sampled"
    description: "The quantity of products, that have been sold in an order. It excludes sampled products (products that were partially or completely sponsored by the producer)"
    type: sum
    sql: ${quantity_sampled};;
    value_format: "0"
    group_label: "> Absolute Metrics"
  }

  measure: sum_item_quantity_returned {
    label: "SUM Item Quantity Returned"
    description: "Quantity of Order Line Items returned"
    hidden:  no
    type: sum
    sql: ${quantity_returned};;
    value_format: "0"
    group_label: "> Absolute Metrics"
  }

  measure: sum_item_price_gross {
    label: "SUM Item Prices Sold (gross)"
    alias: [sum_item_price_fulfilled_gross]
    description: "Sum of sold Item prices (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_gross};;
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_item_price_net {
    label: "SUM Item Prices Sold (net)"
    alias: [sum_item_price_fulfilled_net]
    description: "Sum of sold Item prices (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${amt_total_price_net};;
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_item_price_after_product_discount_gross {
    label: "SUM Item Prices sold After Product Discount (gross)"
    alias: [sum_item_price_fulfilled_after_product_discount_gross]
    description: "Total Price of sold Items after Deduction of Product Discounts. incl. VAT"
    hidden:  no
    type: sum
    sql: ${amt_total_price_after_product_discount_gross};;
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_item_price_after_product_discount_net {
    label: "SUM Item Prices Sold After Product Discount (net)"
    alias: [sum_item_price_fulfilled_after_product_discount_net]
    description: "Total Price of sold Items after Deduction of Product Discounts. excl. VAT"
    hidden:  no
    type: sum
    sql: ${amt_total_price_after_product_discount_net};;
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_discount_amt_gross {
    group_label: "> Monetary Metrics"
    label: "SUM Discount Amount (Gross)"
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_discount_gross} ;;
  }

  measure: sum_discount_amt_net {
    label: "SUM Discount Amount (Net)"
    group_label: "> Monetary Metrics"
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_discount_net} ;;
  }

  measure: sum_amt_discount_products_gross {
    group_label: "> Monetary Metrics"
    label: "SUM Product Discount Amount (Gross)"
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_discount_products_gross} ;;
  }

  measure: sum_amt_discount_products_net {
    group_label: "> Monetary Metrics"
    label: "SUM Product Discount Amount (Net)"
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_discount_products_net} ;;
  }


  measure: ctn_skus {
    type: count_distinct
    label: "# Unique SKUS"
    sql: ${product_sku} ;;
    value_format_name: decimal_1
    group_label: "> Absolute Metrics"
  }

  measure: sum_revenue_gross {
    label: "SUM of Gross Revenue"
    sql: ${amt_revenue_gross} ;;
    description: "SUM of Item Sold Prices after deduction of all discounts (Cart and Product Discounts)"
    type: sum
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_amt_refund_gross {
    label: "SUM Refund (Gross)"
    description: "Refund amount on item level, incl. VAT. Does NOT include Deposit, Storage Fee, Delivery Fee refunds."
    sql: ${amt_refund_gross} ;;
    type: sum
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_amt_refund_net {
    label: "SUM Refund (Net)"
    description: "Refund amount on item level, excl. VAT. Does NOT include Deposit, Storage Fee, Delivery Fee refunds."
    sql: ${amt_refund_net} ;;
    type: sum
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

  measure: sum_total_deposit {
    label: "SUM Gross Deposit (paid by customer)"
    description: "SUM of the Total Gross Deposit paid by customer. Before Flink was always paying the deposit"
    sql: ${amt_total_deposit} ;;
    type: sum
    value_format_name: euro_accounting_2_precision
    group_label: "> Monetary Metrics"
  }

############### SINGLE USE PLASTIC FEES ################

  measure: sum_amt_sup_fee_gross_eur {
    type: sum
    group_label: "> Monetary Metrics"
    label: "SUM SUP Fee (Gross)"
    description: "Gross amount of Single Use Plastic fee paid by the customer."
    sql: ${amt_sup_fee_gross_eur} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_sup_fee_net_eur {
    type: sum
    group_label: "> Monetary Metrics"
    label: "SUM SUP Fee (Net)"
    description: "Net amount of Single Use Plastic fee paid by the customer."
    sql: ${amt_sup_fee_net_eur} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_refund_sup_fee_gross_eur {
    type: sum
    group_label: "> Monetary Metrics"
    label: "SUM Refund SUP Fee (Gross)"
    description: "Gross amount of Single Use Plastic fee refunded to the customer."
    sql: ${amt_refund_sup_fee_gross_eur} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_refund_sup_fee_net_eur {
    type: sum
    group_label: "> Monetary Metrics"
    label: "SUM Refund SUP Fee (Net)"
    description: "Net amount of Single Use Plastic fee refunded to the customer."
    sql: ${amt_refund_sup_fee_net_eur} ;;
    value_format_name: euro_accounting_2_precision
  }


  measure: count_order_uuid {
    label: "Count Order"
    sql: ${order_uuid} ;;
    type: count_distinct
    value_format: "0"
    group_label: "> Absolute Metrics"
  }


  ############# Delivery Issues #############


  measure: number_of_products_with_delivery_issues {

    label: "# Products Delivery Issues"
    description: "Number of products that had a delivery issue. Cancelled are not taken into account."
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_delivery_issues;;
  }

  measure: number_of_products_with_pre_delivery_issues {

    label: "# Products Pre Delivery Issues"
    description: "Number of products that had a pre-delivery issue."
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_pre_delivery_issues;;
  }

  measure: number_of_products_with_post_delivery_issues {

    label: "# Products Post Delivery Issues"
    description: "Number of products that had a post-delivery issue."
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_post_delivery_issues;;
  }

  measure: number_of_products_with_perished_light_issues {

    label: "# Products Perished Light"
    description: "Number of products, that had perished_light issues (Post-delivery)"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_perished_light_issues ;;
  }

  measure: number_of_products_with_perished_issues_pre {

    label: "# Products Perished (Pre Delivery)"
    description: "The number of products, that had perished issues and were identified in the picking process (Swipe) "
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_perished_issues_pre;;
  }

  measure: number_of_products_with_perished_issues_post {

    label: "# Products Perished (Post Delivery)"
    description: "The number of products, that had perished issues and were and were claimed through the Customer Service"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_perished_issues_post;;
  }

  measure: number_of_products_with_products_not_on_shelf_issues_pre {

    label: "# Products not on shelf (Pre Delivery)"
    description: "The number of products, that were not in stock and were identified in the picking process (Swipe)"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_products_not_on_shelf_issues_pre;;
  }

  measure: number_of_products_with_products_not_on_shelf_issues_post {

    label: "# Products not on shelf (Post Delivery)"
    description: "The number of products, that were not in stock and were claimed through the Customer Service"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_products_not_on_shelf_issues_post;;
  }

  measure: number_of_products_with_damaged_products_issues_pre {

    label: "# Products Damaged (Pre Delivery)"
    description: "The number of products, that were damaged and were identified in the picking process (Swipe)"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_damaged_products_issues_pre;;
  }

  measure: number_of_products_with_damaged_products_issues_post {

    label: "# Products Damaged (Post Delivery)"
    description: "The number of products, that were damaged and were claimed through the Customer Service"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_damaged_products_issues_post;;
  }

  measure: number_of_products_with_missing_products_issues {

    label: "# Products Missing (Post Delivery)"
    description: "The number of missing products"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_missing_products_issues ;;
  }

  measure: number_of_products_with_wrong_products_issues {

    label: "# Products Wrong (Post Delivery)"
    description: "The number of wrong products"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_wrong_products_issues ;;
  }

  measure: number_of_products_with_swapped_products_issues {

    label: "# Products Swapped Products (Post Delivery)"
    description: "The number of products that were swapped"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_swapped_products_issues ;;
  }

  measure: number_of_products_with_cancelled_products_issues {

    # This metric is not part of the issue rates, as the customer voluntary cancelled a product.
    label:  "# Products Cancelled (Post Delivery)"
    description: "The number of products that were cancelled"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_cancelled_products_issues ;;
  }

  measure: number_of_products_with_item_description_issues {

    label: "# Products Issue Item Description (Post Delivery)"
    description: "The number of products, that had issues related to item descriptions"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_item_description_issues ;;
  }

  measure: number_of_products_with_item_quality_issues {

    label: "# Products Issue Item Quality (Post Delivery)"
    description: "The number of products, that had issues related to item quality"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_item_quality_issues ;;
  }

  measure: number_of_products_with_goodwill_issues {

    label: "# Products Issue Goodwill (Post Delivery)"
    description: "The number of products, that had issues related to goodwill"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_goodwill_issues ;;
  }

  measure: number_of_products_with_undefined_issues {

    label:       "# Products Unknown Issues (Post Delivery)"
    description: "The number of products, that had issues with unknown issue groups (see Return Reason to check the specific issue reasons)"
    group_label: "> Delivery Issues Products"

    type: sum
    sql: ${TABLE}.number_of_products_with_undefined_issues ;;
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

  measure: avg_item_value_gross {
    label: "AVG Item Value (Gross)"
    description: "AIV represents the Average value of items (incl. VAT). Excludes fees (gross), before deducting discounts."
    hidden: no
    type:number
    sql: ${sum_item_price_gross} / nullif(${count_order_uuid},0) ;;
    value_format_name: eur
    group_label: "> Monetary Metrics"
  }

  measure: avg_item_value_net {
    label: "AVG Item Value (Net)"
    description: "AIV represents the Average value of items (excl. VAT). Excludes fees (net), before deducting discounts."
    hidden: no
    type:number
    sql: ${sum_item_price_net} / nullif(${count_order_uuid},0) ;;
    value_format_name: eur
    group_label: "> Monetary Metrics"
  }

  measure: avg_item_value_after_product_discount_gross {
    label: "AVG Item Value After Product Discount (Gross)"
    description: "AIV represents the Average value of items (incl. VAT). Excludes fees (gross), after deducting Product Discounts. before deducting Cart Discounts."
    hidden: no
    type:number
    sql: ${sum_item_price_after_product_discount_gross} / nullif(${count_order_uuid},0) ;;
    value_format_name: eur
    group_label: "> Monetary Metrics"
  }

  measure: avg_item_value_after_product_discount_net {
    label: "AVG Item Value After Product Discount (Net)"
    description: "AIV represents the Average value of items (excl. VAT). Excludes fees (gross), after deducting Product Discounts. before deducting Cart Discounts."
    hidden: no
    type:number
    sql: ${sum_item_price_after_product_discount_net} / nullif(${count_order_uuid},0) ;;
    value_format_name: eur
    group_label: "> Monetary Metrics"
  }

  measure: number_of_orderlines {
    label: "# Order Lineitems"
    group_label: "> Absolute Metrics"
    type: count
    drill_fields: [id, name]
  }

  ########## Parameters

  #########  Dynamic measures


  measure: sum_item_price_sold_gross_dynamic {
    group_label: "> Dynamic Monetary Metrics"
    label: "SUM Items Price Sold Gross (Dynamic)"
    alias: [sum_item_price_fulfilled_gross_dynamic]
    description: "To be used together with the Is After Product Discounts Deduction parameter."
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == 'true' %}
    ${sum_item_price_after_product_discount_gross}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == 'false' %}
    ${sum_item_price_gross}
    {% endif %}
    ;;
  }

  measure: sum_item_price_sold_net_dynamic {
    group_label: "> Dynamic Monetary Metrics"
    label: "SUM Items Price Sold Net (Dynamic)"
    alias: [sum_item_price_fulfilled_net_dynamic]
    description: "To be used together with the Is After Product Discounts Deduction parameter."
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == 'true' %}
    ${sum_item_price_after_product_discount_net}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == 'false' %}
    ${sum_item_price_net}
    {% endif %}
    ;;
  }

  measure: avg_item_value_gross_dynamic {
    group_label: "> Dynamic Monetary Metrics"
    label: "AVG Item Value (Dynamic) (Gross)"
    description: "AIV represents the Average value of items (incl. VAT). Excludes fees (gross). before deducting Cart Discounts. To be used together with the Is After Product Discounts Deduction parameter."
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == 'true' %}
    ${avg_item_value_after_product_discount_gross}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == 'false' %}
    ${avg_item_value_gross}
    {% endif %}
    ;;
  }

  measure: avg_item_value_net_dynamic {
    group_label: "> Dynamic Monetary Metrics"
    label: "AVG Item Value (Dynamic) (Net)"
    description: "AIV represents the Average value of items (incl. VAT). Excludes fees (gross). before deducting Cart Discounts. To be used together with the Is After Product Discounts Deduction parameter."
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == 'true' %}
    ${avg_item_value_after_product_discount_net}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == 'false' %}
    ${avg_item_value_net}
    {% endif %}
    ;;
  }

####################################################################################################################################
####################################################################################################################################
################################################ Demand Planning ###################################################################
####################################################################################################################################
####################################################################################################################################


  #Needed for wtd calculation

  dimension_group: current_date_t_1 {
    label: "Current Date - 1"
    type: time
    timeframes: [
      date,
      week,
      month,
      day_of_week_index,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: date_sub(current_date(), interval 1 day) ;;
    hidden: yes
  }

  dimension: until_today {
    type: yesno
    sql: ${created_day_of_week_index} <= ${current_date_t_1_day_of_week_index} AND
      ${created_day_of_week_index} >= 0 ;;
    hidden: yes
  }

  #Sold Quantities

  #Daily


  measure: sum_item_quantity_t_1 {
    group_label: "Demand Planning"
    label: "# Total Sales t-1"
    description: "Quantity of Order Line Items sold in the previous t-1"
    hidden: yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "yesterday"]
    value_format: "0.0"
  }

  measure: sum_item_quantity_t_2 {
    group_label: "Demand Planning"
    label: "# Total Sales t-2"
    description: "Quantity of Order Line Items sold in the previous t-2"
    hidden: yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "2 days ago"]
    value_format: "0.0"
  }

  measure: sum_item_quantity_t_3 {
    group_label: "Demand Planning"
    label: "# Total Sales t-3"
    description: "Quantity of Order Line Items sold in the previous t-3"
    hidden: yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "3 days ago"]
    value_format: "0.0"
  }

  measure: sum_item_quantity_t_4 {
    group_label: "Demand Planning"
    label: "# Total Sales t-4"
    description: "Quantity of Order Line Items sold in the previous t-4"
    hidden: yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "4 days ago"]
    value_format: "0.0"
  }


  #weekly

  measure: sum_item_quantity_w_1 {
    group_label: "Demand Planning"
    label: "# Total Sales w-1"
    description: "Quantity of Order Line Items sold in the previous w-1"
    hidden: yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "1 week ago"]
    value_format: "0.0"
  }


  measure: sum_item_quantity_w_2 {
    group_label: "Demand Planning"
    label: "# Total Sales w-2"
    description: "Quantity of Order Line Items sold in the previous w-2"
    hidden: yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "2 weeks ago"]
    value_format: "0.0"
  }

  measure: sum_item_quantity_w_3 {
    group_label: "Demand Planning"
    label: "# Total Sales w-3"
    description: "Quantity of Order Line Items sold in the previous w-3"
    hidden: yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "3 weeks ago"]
    value_format: "0.0"
  }

  measure: sum_item_quantity_w_4 {
    group_label: "Demand Planning"
    label: "# Total Sales w-4"
    description: "Quantity of Order Line Items sold in the previous w-4"
    hidden: yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "4 weeks ago"]
    value_format: "0.0"
  }


#w2d

  measure: sum_item_quantity_wtd {
    group_label: "Demand Planning"
    label: "# Total Sales WtD"
    description: "Quantity of Order Line Items sold in the previous - WtD"
    hidden: yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "this week", until_today: "yes"]
    value_format: "0.0"
  }

  measure: sum_item_quantity_wtd_w_1 {
    group_label: "Demand Planning"
    label: "# Total Sales WtD w-1"
    description: "Quantity of Order Line Items sold in the previous - Previous week WtD"
    hidden:  yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "1 week ago", until_today: "yes"]
    value_format: "0.0"
  }

  #calculations

  measure: sum_item_quantity_wow_wtd {
    group_label: "Demand Planning"
    label: "# Total Sales WOW Growth - WtD"
    description: "Quantity of Order Line Items sold in the previous - WtD WoW Growth"
    hidden: yes
    type: number
    sql: (${sum_item_quantity_wtd} - ${sum_item_quantity_wtd_w_1}) / nullif(${sum_item_quantity_wtd_w_1}, 0);;
    value_format_name: percent_1
  }

  measure: sum_item_quantity_wow_w_1_vs_w_2 {
    group_label: "Demand Planning"
    label: "# Total Sales WOW Growth (w-1 vs w-2)"
    description: "Quantity of Order Line Items sold in the previous - WoW Growth (w-1 vs w-2)"
    hidden: yes
    type: number
    sql: (${sum_item_quantity_w_1} - ${sum_item_quantity_w_2}) / nullif(${sum_item_quantity_w_2}, 0);;
    value_format_name: percent_1
  }

  ### --------------------------- POP STARTS --------------------------- ###

  ## ----- POP: Filters  ---- ##

  filter: first_period_filter {
    label: "Select First Time Period"
    view_label: "Period over Period (PoP) Comparison"
    type: date
    description: "Select the time range. This filter is used alongside the 'Select Second Time Period filter', to be able to compare different time frames to each other. "
  }

  filter: second_period_filter {
    label: "Select Second Time Period"
    view_label: "Period over Period (PoP) Comparison"
    type: date
    description: "Select the time range. This filter is used alongside the 'Select First Time Period' filter, to be able to compare different time frames to each other. "
  }

  ## ---- POP: Dimensions  ---- ##

  dimension: period_selected {
    view_label: "Period over Period (PoP) Comparison"
    label: "Filtered Time Period (First/Second)"
    description: "This dimension only has 2 values: First or Second, representing time periods selected in filters ('Select First Time Period' and 'Select Second Time Period' filters). Use this dimension to see metrics per filtered time period."
    type: string
    sql:
        CASE
            WHEN {% condition first_period_filter %} ${created_raw} {% endcondition %}
            THEN 'First Time Period'
            WHEN {% condition second_period_filter %} ${created_raw} {% endcondition %}
            THEN 'Second Time Period'
            END ;;
  }

  ## ---- POP: Measures  ---- ##

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
    sql: ${amt_total_price_gross};;
    filters: [period_selected: "First Time Period"]
    value_format_name: euro_accounting_2_precision
    description: "'SUM Item Prices Sold (Gross)' for the period defined in 'Select First Time Period' filter"
  }

  measure: second_period_sum_item_price_gross {
    view_label: "Period over Period (PoP) Comparison"
    label: "Second Time Period: SUM Item Prices Sold (Gross)"
    type: sum
    sql: ${amt_total_price_gross};;
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
    sql: ${quantity};;
    filters: [period_selected: "First Time Period"]
    value_format_name: decimal_0
    description: "'SUM Item Quantity Sold' for the period defined in 'Select First Time Period' filter"
  }

  measure: second_period_sum_item_quantity {
    view_label: "Period over Period (PoP) Comparison"
    label: "Second Time Period: SUM Item Quantity Sold"
    type: sum
    sql: ${quantity};;
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

  ### --------------------------- POP ENDS --------------------------- ###
}
