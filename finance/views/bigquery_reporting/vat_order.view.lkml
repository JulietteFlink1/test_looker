view: vat_order {
  derived_table: {
    sql:select * from `flink-data-prod.reporting.vat_order`
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_uuid {
    hidden: no
    group_label: "> IDs"
    primary_key: yes
    type: string
    sql: concat(${country_iso},'_',${order_id}) ;;
  }

  dimension: order_id {
    group_label: "> IDs"
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: country_iso {
    group_label: "> Geographic"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: order {
    group_label: "> Order Date"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension_group: refund {
    group_label: "> Refund Date"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.refund_date ;;
  }




  dimension: user_email {
    type: string
    sql: ${TABLE}.user_email ;;
  }

  dimension: is_free_delivery_discount {
    group_label: "> Order Dimensions"
    type: yesno
    sql: ${TABLE}.is_free_delivery_discount ;;
  }

  dimension: is_external_order {
    group_label: "> Order Dimensions"
    type: yesno
    sql: ${TABLE}.is_external_order ;;
  }

  dimension: is_successful_order {
    group_label: "> Order Dimensions"
    type: yesno
    sql: ${TABLE}.is_successful_order ;;
  }

  dimension: order_status {
    group_label: "> Order Dimensions"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: discount_free_delivery_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.discount_free_delivery_gross ;;
  }



  dimension: hub_name {
    group_label: "> Geographic"
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: hub_code {
    group_label: "> Geographic"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: tax_rate_weighted {
    type: number
    sql: ${TABLE}.tax_rate_weighted ;;
  }

  dimension: cost_center {
    group_label: "> Geographic"
    type: string
    sql: ${TABLE}.cost_center ;;
  }

  dimension: payment_type {
    group_label: "> Order Dimensions"
    type: string
    hidden: yes
    sql: ${TABLE}.payment_type ;;
  }

  dimension: payment_method {
    group_label: "> Order Dimensions"
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: amt_rider_tip {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_rider_tip_gross ;;
  }

######## ITEMS ############
  dimension: items_price_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_items_price_net ;;
  }

  dimension: items_price_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_items_price_gross ;;
  }

  dimension: items_price_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_items_price_reduced_net ;;
  }

  dimension: items_price_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_items_price_reduced_gross ;;
  }

  dimension: items_price_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_items_price_special_net ;;
  }

  dimension: items_price_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_items_price_special_gross ;;
  }

  dimension: items_price_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_items_price_standard_net ;;
  }

  dimension: items_price_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_items_price_standard_gross ;;
  }

  dimension: vat_items_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_items_price_reduced ;;
  }

  dimension: vat_items_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_items_price_standard ;;
  }

  dimension: amt_total_deposit {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_deposit_gross ;;
  }

  dimension: deposit_amount_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_deposit_standard_gross ;;
  }

  dimension: deposit_amount_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_deposit_reduced_gross ;;
  }

  dimension: deposit_amount_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_deposit_special_gross ;;
  }

  dimension: deposit_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_deposit_standard_net ;;
  }

  dimension: deposit_amount_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_deposit_reduced_net ;;
  }

  dimension: deposit_amount_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_deposit_special_net ;;
  }

  dimension: deposit_amount_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_deposit_net ;;
  }

  dimension: quantity_deposit {
    hidden: yes
    type: number
    sql: ${TABLE}.quantity_deposit ;;
  }

  dimension: vat_items_special{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_items_price_special ;;
  }

  dimension: vat_items_total {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_items_price_total ;;
  }

############## DELIVERY FEES #############
  dimension: delivery_fee_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_delivery_fee_net ;;
  }

  dimension: delivery_fee_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_delivery_fee_gross ;;
  }

  dimension: delivery_fee_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_delivery_fee_reduced_net ;;
  }

  dimension: delivery_fee_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_delivery_fee_standard_net ;;
  }

  dimension: delivery_fee_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_delivery_fee_special_net ;;
  }

  dimension: delivery_fee_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_delivery_fee_reduced_gross ;;
  }

  dimension: delivery_fee_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_delivery_fee_standard_gross ;;
  }

  dimension: delivery_fee_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_delivery_fee_special_gross ;;
  }

  dimension: vat_delivery_fee_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_delivery_fee_reduced ;;
  }

  dimension: vat_delivery_fee_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_delivery_fee_standard ;;
  }

  dimension: vat_delivery_fee_special {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_delivery_fee_special ;;
  }

  dimension: vat_delivery_fee_total {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_delivery_fee_total ;;
  }


  ############## DISCOUNTS #############

  dimension: discount_amount_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_net ;;
  }

  dimension: discount_amount_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: discount_amount_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_reduced_net ;;
  }

  dimension: discount_amount_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_reduced_gross ;;
  }

  dimension: discount_amount_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_special_net ;;
  }

  dimension: discount_amount_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_special_gross ;;
  }

  dimension: discount_amount_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_standard_gross ;;
  }

  dimension: discount_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_standard_net ;;
  }

  dimension: vat_discount_amount_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_discount_reduced ;;
  }

  dimension: vat_discount_amount_special {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_discount_special ;;
  }

  dimension: vat_discount_amount_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_discount_standard ;;
  }

  dimension: vat_discount_amount_total {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_discount_total ;;
  }

  ########### Product Discounts

  dimension: discount_products_amount_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_products_net ;;
  }

  dimension: discount_products_amount_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_products_gross ;;
  }

  dimension: discount_products_amount_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_products_reduced_net ;;
  }

  dimension: discount_products_amount_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_products_reduced_gross ;;
  }

  dimension: discount_products_amount_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_products_special_net ;;
  }

  dimension: discount_products_amount_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_products_special_gross ;;
  }

  dimension: discount_products_amount_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_products_standard_gross ;;
  }

  dimension: discount_products_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_discount_products_standard_net ;;
  }

  dimension: vat_discount_products_amount_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_discount_products_reduced ;;
  }

  dimension: vat_discount_products_amount_special {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_discount_products_special ;;
  }

  dimension: vat_discount_products_amount_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_discount_products_standard ;;
  }

  dimension: vat_discount_products_amount_total {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_discount_products_total ;;
  }
  ############### REFUNDS #############

  dimension: refund_amount_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_net ;;
  }

  dimension: refund_amount_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_gross ;;
  }

  dimension: total_refund_amount_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_total_refund_gross ;;
  }

  dimension: refund_amount_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_reduced_net ;;
  }

  dimension: refund_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_standard_net ;;
  }

  dimension: refund_amount_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_special_net ;;
  }

  dimension: refund_amount_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_reduced_gross ;;
  }

  dimension: refund_amount_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_standard_gross ;;
  }

  dimension: refund_amount_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_special_gross ;;
  }

  dimension: vat_refund_amount_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_reduced ;;
  }

  dimension: vat_refund_amount_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_standard ;;
  }

  dimension: vat_refund_amount_special{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_special ;;
  }

  dimension: vat_refund_amount_total {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_total ;;
  }

  dimension: amt_refund_delivery_fee_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_delivery_fee_standard_gross ;;
  }

  dimension: amt_refund_delivery_fee_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_delivery_fee_standard_net ;;
  }

  dimension: amt_refund_delivery_fee_special_gross{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_delivery_fee_special_gross ;;
  }

  dimension: amt_refund_delivery_fee_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_delivery_fee_special_net ;;
  }

  dimension: amt_refund_delivery_fee_reduced_gross{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_delivery_fee_reduced_gross ;;
  }

  dimension: amt_refund_delivery_fee_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_delivery_fee_reduced_net ;;
  }

  dimension: amt_refund_delivery_fee_gross{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_delivery_fee_gross ;;
  }

  dimension: amt_refund_delivery_fee_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_delivery_fee_net ;;
  }

  dimension: amt_vat_refund_delivery_fee_total {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_delivery_fee_total ;;
  }

  dimension: amt_vat_refund_delivery_fee_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_delivery_fee_standard ;;
  }

  dimension: amt_vat_refund_delivery_fee_special {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_delivery_fee_special ;;
  }

  dimension: amt_vat_refund_delivery_fee_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_delivery_fee_reduced ;;
  }

  dimension: amt_refund_deposit_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_deposit_standard_gross ;;
  }

  dimension: amt_refund_deposit_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_deposit_standard_net ;;
  }

  dimension: amt_refund_deposit_special_gross{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_deposit_special_gross ;;
  }

  dimension: amt_refund_deposit_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_deposit_special_net ;;
  }

  dimension: amt_refund_deposit_reduced_gross{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_deposit_reduced_gross ;;
  }

  dimension: amt_refund_deposit_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_deposit_reduced_net ;;
  }

  dimension: amt_refund_deposit_gross{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_deposit_gross ;;
  }

  dimension: amt_refund_deposit_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_deposit_net ;;
  }

  dimension: amt_vat_refund_deposit_total {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_deposit_total ;;
  }

  dimension: amt_vat_refund_deposit_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_deposit_standard ;;
  }

  dimension: amt_vat_refund_deposit_special {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_deposit_special ;;
  }

  dimension: amt_vat_refund_deposit_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_deposit_reduced ;;
  }

  dimension: amt_refund_items_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_items_standard_gross ;;
  }

  dimension: amt_refund_items_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_items_standard_net ;;
  }

  dimension: amt_refund_items_special_gross{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_items_special_gross ;;
  }

  dimension: amt_refund_items_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_items_special_net ;;
  }

  dimension: amt_refund_items_reduced_gross{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_items_reduced_gross ;;
  }

  dimension: amt_refund_items_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_items_reduced_net ;;
  }

  dimension: amt_refund_items_gross{
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_items_gross ;;
  }

  dimension: amt_refund_items_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_items_net ;;
  }

  dimension: amt_vat_refund_items_total {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_items_total ;;
  }

  dimension: amt_vat_refund_items_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_items_standard ;;
  }

  dimension: amt_vat_refund_items_special {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_items_special ;;
  }

  dimension: amt_vat_refund_items_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_vat_refund_items_reduced ;;
  }

  dimension: amt_refund_rider_tip_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_rider_tip_gross ;;
  }


######## TOTALS #########

  dimension: total_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_revenue_net ;;
  }

  dimension: total_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: total_gross_bins {
    hidden: no
    type: string
    sql: case when ${total_gross} < 10 THEN '<10'
          when ${total_gross}  >= 10 and ${total_gross}  < 12 THEN '10-12'
          when ${total_gross}  >= 12 and ${total_gross}  < 14 THEN '12-14'
          when ${total_gross}  >= 14 and ${total_gross}  < 20 THEN '14-20'
          when ${total_gross}  >= 20 and ${total_gross}  < 30 THEN '20-30'
          when ${total_gross}  >= 30 THEN '>30' end;;
  }

  dimension: total_item_delivery_fee_bins {
    hidden: no
    type: string
    sql: case when ${items_price_gross} + ${delivery_fee_gross} < 10 THEN '<10'
          when ${items_price_gross} + ${delivery_fee_gross}  >= 10 and ${items_price_gross} + ${delivery_fee_gross}   < 12 THEN '10-12'
          when ${items_price_gross} + ${delivery_fee_gross}   >= 12 and ${items_price_gross} + ${delivery_fee_gross}  < 14 THEN '12-14'
          when ${items_price_gross} + ${delivery_fee_gross}  >= 14 and ${items_price_gross} + ${delivery_fee_gross}  < 20 THEN '14-20'
          when ${items_price_gross} + ${delivery_fee_gross}  >= 20 and ${items_price_gross} + ${delivery_fee_gross} < 30 THEN '20-30'
          when ${items_price_gross} + ${delivery_fee_gross} >= 30 THEN '>30' end;;
  }


  dimension: total_vat {
    hidden: yes
    type: number
    sql: ${TABLE}.total_VAT ;;
  }


  ############################  Measures   #######################

  ############################  Items.     #######################
  measure: sum_items_price_net {
    group_label: "> Items"
    label: "SUM Item Price (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_net} ;;
  }

  measure: sum_items_price_gross {
    group_label: "> Items"
    label: "SUM Item Price (Gross)"
    description: "SUM of Items Price incl. VAT before deduction of Product and Cart Discounts"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_gross} ;;
  }

  measure: sum_items_price_reduced_gross {
    group_label: "> Items"
    label: "SUM Item Price Reduced (Gross)"
    description: "SUM of Items Price with Reduced tax rate incl.VAT before deduction of Product and Cart Discounts"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_reduced_gross} ;;
  }

  measure: sum_items_price_reduced_net {
    description: "SUM of Items Price with Reduced tax rate excl. VAT before deduction of Product and Cart Discounts"
    group_label: "> Items"
    label: "SUM Item Price Reduced (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_reduced_net} ;;
  }

  measure: sum_items_price_special_gross {
    description: "SUM of Items Price with Special tax rate incl.VAT before deduction of Product and Cart Discounts"
    group_label: "> Items"
    label: "SUM Item Price Sepcial (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_special_gross} ;;
  }

  measure: sum_items_price_special_net {
    group_label: "> Items"
    description: "SUM of Items Price with Special tax rate excl. VAT before deduction of Product and Cart Discounts"
    label: "SUM Item Price Sepcial (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_special_net} ;;
  }

  measure: sum_items_price_standard_gross {
    description: "SUM of Items Price with Standard tax rate incl.VAT before deduction of Product and Cart Discounts"
    group_label: "> Items"
    label: "SUM Item Price Standard (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_standard_gross} ;;
  }

  measure: sum_items_price_standard_net {
    description: "SUM of Items Price with Standard tax rate excl. VAT before deduction of Product and Cart Discounts"
    group_label: "> Items"
    label: "SUM Item Price Standard (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_standard_net} ;;
  }

  measure: sum_vat_items_reduced {
    group_label: "> Items"
    description: "SUM Items Price Reduced Gross - SUM Items Price Reduced Net"
    label: "SUM VAT Item Price Reduced"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_reduced} ;;
  }

  measure: sum_vat_items_special {
    group_label: "> Items"
    label: "SUM VAT Item Price Special"
    description: "SUM Items Price Special Gross - SUM Items Price Special Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_special} ;;
  }

  measure: sum_vat_items_standard {
    group_label: "> Items"
    label: "SUM VAT Item Price Standard"
    description: "SUM Items Price Standard Gross - SUM Items Price Standard Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_standard} ;;
  }

  measure: sum_vat_items_total {
    label: "SUM VAT Item Price Total"
    group_label: "> Items"
    description: "SUM Items Price Gross - SUM Items Price Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_total} ;;
  }


  ##################### Delivery Fees ##########################


  measure: sum_delivery_fee_net {
    group_label: "> Delivery Fee"
    label: "SUM Delivery Fee (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_net} ;;
  }

  measure: sum_delivery_fee_gross {
    group_label: "> Delivery Fee"
    label: "SUM Delivery Fee (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_gross} ;;
  }

  measure: sum_delivery_fee_reduced_net {
    group_label: "> Delivery Fee"
    label: "SUM Delivery Fee Reduced (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_reduced_net} ;;
  }


  measure: sum_delivery_fee_standard_net {
    group_label: "> Delivery Fee"
    label: "SUM Delivery Fee Standard (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_standard_net} ;;
  }

  measure: sum_delivery_fee_special_net {
    group_label: "> Delivery Fee"
    label: "SUM Delivery Fee Special (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_special_net} ;;
  }

  measure: sum_delivery_fee_special_gross {
    group_label: "> Delivery Fee"
    label: "SUM Delivery Fee Special (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_special_gross} ;;
  }

  measure: sum_delivery_fee_reduced_gross {
    group_label: "> Delivery Fee"
    label: "SUM Delivery Fee Reduced (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_reduced_gross} ;;
  }

  measure: sum_delivery_fee_standard_gross {
    group_label: "> Delivery Fee"
    label: "SUM Delivery Fee Standard (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_standard_gross} ;;
  }

  measure: sum_vat_delivery_fee_reduced {
    group_label: "> Delivery Fee"
    label: "SUM VAT Delivery Fee Reduced"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_reduced} ;;
  }

  measure: sum_vat_delivery_fee_standard {
    group_label: "> Delivery Fee"
    label: "SUM VAT Delivery Fee Standard"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_standard} ;;
  }

  measure: sum_vat_delivery_fee_special {
    group_label: "> Delivery Fee"
    label: "SUM VAT Delivery Fee Special"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_special} ;;
  }

  measure: sum_vat_delivery_fee_total {
    group_label: "> Delivery Fee"
    label: "SUM VAT Delivery Fee Total"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_total} ;;
  }


  ##################### Discounts  ##########################


  measure: sum_discount_amount_net {
    group_label: "> Discounts"
    label: "SUM Discounts (Net)"
    description: "Include all Cart Discounts and Product Discounts"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_net} ;;
  }

  measure: sum_discount_amount_gross {
    group_label: "> Discounts"
    label: "SUM Discounts (Gross)"
    description: "Include all Cart Discounts and Product Discounts"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_gross} ;;
  }


  measure: sum_discount_amount_reduced_net {
    group_label: "> Discounts"
    label: "SUM Discounts Reduced (Net)"
    description: "Include all Cart Discounts and Product Discounts"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_reduced_net} ;;
  }

  measure: sum_discount_amount_standard_net {
    group_label: "> Discounts"
    label: "SUM Discounts Standard (Net)"
    description: "Include all Cart Discounts and Product Discounts"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_standard_net} ;;
  }

  measure: sum_discount_amount_special_net {
    description: "Include all Cart Discounts and Product Discounts"
    group_label: "> Discounts"
    label: "SUM Discounts Special (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_special_net} ;;
  }

  measure: sum_discount_amount_reduced_gross {
    description: "Include all Cart Discounts and Product Discounts"
    group_label: "> Discounts"
    label: "SUM Discounts Reduced (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_reduced_gross} ;;
  }

  measure: sum_discount_amount_special_gross {
    description: "Include all Cart Discounts and Product Discounts"
    group_label: "> Discounts"
    label: "SUM Discounts Special (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_special_gross} ;;
  }

  measure: sum_discount_amount_standard_gross {
    description: "Include all Cart Discounts and Product Discounts"
    group_label: "> Discounts"
    label: "SUM Discounts Standard (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_standard_gross} ;;
  }

  measure: sum_vat_discount_amount_reduced {
    description: "Include all Cart Discounts and Product Discounts"
    group_label: "> Discounts"
    label: "SUM VAT Discounts Reduced"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_reduced} ;;
  }

  measure: sum_vat_discount_amount_standard {
    description: "Include all Cart Discounts and Product Discounts"
    group_label: "> Discounts"
    label: "SUM VAT Discounts Standard"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_standard} ;;
  }

  measure: sum_vat_discount_amount_special {
    description: "Include all Cart Discounts and Product Discounts"
    group_label: "> Discounts"
    label: "SUM VAT Discounts Special"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_special} ;;
  }

  measure: sum_vat_discount_amount_total {
    description: "Include all Cart Discounts and Product Discounts"
    group_label: "> Discounts"
    label: "SUM VAT Discounts Total"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_total} ;;
  }

  measure: sum_discount_amount_free_delivery_gross {
    group_label: "> Discounts"
    label: "SUM Free Delivery Discounts (Gross)"
    value_format: "#,##0.00€"
    type: sum
    hidden: yes
    sql: ${discount_free_delivery_gross} ;;
  }


  ################## Product Discounts

  measure: sum_discount_products_amount_net {
    group_label: "> Product Discounts"
    label: "SUM Product Discounts (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_products_amount_net} ;;
  }

  measure: sum_discount_products_amount_gross {
    group_label: "> Product Discounts"
    label: "SUM Product Discounts (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_products_amount_gross} ;;
  }


  measure: sum_discount_products_amount_reduced_net {
    group_label: "> Product Discounts"
    label: "SUM Product Discounts Reduced (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_products_amount_reduced_net} ;;
  }

  measure: sum_discount_products_amount_standard_net {
    group_label: "> Product Discounts"
    label: "SUM Product Discounts Standard (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_products_amount_standard_net} ;;
  }

  measure: sum_discount_products_amount_special_net {
    group_label: "> Product Discounts"
    label: "SUM Product Discounts Special (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_products_amount_special_net} ;;
  }

  measure: sum_discount_products_amount_reduced_gross {
    group_label: "> Product Discounts"
    label: "SUM Product Discounts Reduced (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_products_amount_reduced_gross} ;;
  }

  measure: sum_discount_products_amount_special_gross {
    group_label: "> Product Discounts"
    label: "SUM Product Discounts Special (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_products_amount_special_gross} ;;
  }

  measure: sum_discount_products_amount_standard_gross {
    group_label: "> Product Discounts"
    label: "SUM Product Discounts Standard (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_products_amount_standard_gross} ;;
  }

  measure: sum_vat_discount_products_amount_reduced {
    group_label: "> Product Discounts"
    label: "SUM VAT Product Discounts Reduced"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_products_amount_reduced} ;;
  }

  measure: sum_vat_discount_products_amount_standard {
    group_label: "> Product Discounts"
    label: "SUM VAT Product Discounts Standard"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_products_amount_standard} ;;
  }

  measure: sum_vat_discount_products_amount_special {
    group_label: "> Product Discounts"
    label: "SUM VAT Product Discounts Special"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_products_amount_special} ;;
  }

  measure: sum_vat_discount_products_amount_total {
    group_label: "> Product Discounts"
    label: "SUM VAT Product Discounts Total"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_products_amount_total} ;;
  }


  #####################  Refunds  ##########################


  measure: sum_refund_amount_net {
    group_label: "> Refunds"
    description: "Before 2022-07-01: Total Net Refunds paid via Adyen. After 2022-07-01: Total Net Refunds paid excluding Tips Refunds and double payments."
    label: "SUM Refunds (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_net} ;;
  }

  measure: sum_refund_amount_gross {
    group_label: "> Refunds"
    label: "SUM Refunds (Gross)"
    description: "Before 2022-07-01: Total Gross Refunds paid via Adyen. After 2022-07-01: Total Gross Refunds paid excluding Tips Refunds and double payments."
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_gross} ;;
  }

  measure: sum_total_refund_amount_gross {
    group_label: "> Refunds"
    label: "SUM All Refunds (Gross)"
    description: "Total Refunds paid via Adyen. Excluding double payment starting from 2022-07-01. Include Items, Deposit, Delivery Fee and Tips Refunds."
    type: sum
    value_format: "#,##0.00€"
    sql: ${total_refund_amount_gross} ;;
  }

  measure: sum_refund_amount_reduced_net {
    group_label: "> Refunds"
    label: "SUM Refunds Reduced (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_reduced_net} ;;
  }

  measure: sum_refund_amount_standard_net {
    group_label: "> Refunds"
    label: "SUM Refunds Standard (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_standard_net} ;;
  }

  measure: sum_refund_amount_special_net {
    group_label: "> Refunds"
    label: "SUM Refunds Special (Net)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_special_net} ;;
  }

  measure: sum_refund_amount_reduced_gross {
    group_label: "> Refunds"
    label: "SUM Refunds Reduced (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_reduced_gross} ;;
  }

  measure: sum_refund_amount_standard_gross {
    group_label: "> Refunds"
    label: "SUM Refunds Standard (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_standard_gross} ;;
  }

  measure: sum_refund_amount_special_gross {
    group_label: "> Refunds"
    label: "SUM Refunds Special (Gross)"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_special_gross} ;;
  }

  measure: sum_vat_refund_amount_reduced {
    group_label: "> Refunds"
    label: "SUM VAT Refunds Reduced"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_refund_amount_reduced} ;;
  }

  measure: sum_vat_refund_amount_standard {
    group_label: "> Refunds"
    label: "SUM VAT Refunds Standard"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_refund_amount_standard} ;;
  }

  measure: sum_vat_refund_amount_special {
    group_label: "> Refunds"
    label: "SUM VAT Refunds Special"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_refund_amount_special} ;;
  }

  measure: sum_vat_refund_amount_total {
    group_label: "> Refunds"
    label: "SUM VAT Refunds Total"
    value_format: "#,##0.00€"
    type: sum
    sql: ${vat_refund_amount_total} ;;
  }

  measure: sum_amt_refund_delivery_fee_net {
    group_label: "> Refunds Delivery Fee"
    label: "SUM Refund Delivery Fee Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_delivery_fee_net} ;;
  }

  measure: sum_amt_refund_delivery_fee_gross {
    group_label: "> Refunds Delivery Fee"
    label: "SUM Refund Delivery Fee Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_delivery_fee_gross} ;;
  }

  measure: sum_amt_refund_delivery_fee_reduced_net {
    group_label: "> Refunds Delivery Fee"
    label: "SUM Refund Delivery Fee Reduced Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_delivery_fee_reduced_net} ;;
  }

  measure: sum_amt_refund_delivery_fee_standard_net {
    group_label: "> Refunds Delivery Fee"
    label: "SUM Refund Delivery Fee Standard Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_delivery_fee_standard_net} ;;
  }

  measure: sum_amt_refund_delivery_fee_special_net {
    group_label: "> Refunds Delivery Fee"
    label: "SUM Refund Delivery Fee Special Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_delivery_fee_special_net} ;;
  }

  measure: sum_amt_refund_delivery_fee_reduced_gross {
    group_label: "> Refunds Delivery Fee"
    label: "SUM Refund Delivery Fee Reduced Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_delivery_fee_reduced_gross} ;;
  }

  measure: sum_amt_refund_delivery_fee_standard_gross {
    group_label: "> Refunds Delivery Fee"
    label: "SUM Refund Delivery Fee Standard Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_delivery_fee_standard_gross} ;;
  }

  measure: sum_amt_refund_delivery_fee_special_gross {
    group_label: "> Refunds Delivery Fee"
    label: "SUM Refund Delivery Fee Special Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_delivery_fee_special_gross} ;;
  }

  measure: sum_amt_vat_refund_delivery_fee_reduced {
    group_label: "> Refunds Delivery Fee"
    label: "SUM VAT Refund Delivery Fee Reduced"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_vat_refund_delivery_fee_reduced} ;;
  }

  measure: sum_amt_vat_refund_delivery_fee_standard {
    group_label: "> Refunds Delivery Fee"
    label: "SUM VAT Refund Delivery Fee Standard"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_vat_refund_delivery_fee_standard} ;;
  }

  measure: sum_amt_vat_refund_delivery_fee_special {
    group_label: "> Refunds Delivery Fee"
    label: "SUM VAT Refund Delivery Fee Special"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_vat_refund_delivery_fee_special} ;;
  }

  measure: sum_amt_vat_refund_delivery_fee_total {
    group_label: "> Refunds Delivery Fee"
    label: "SUM VAT Refund Delivery Fee Total"
    value_format: "#,##0.00€"
    type: sum
    sql: ${amt_vat_refund_delivery_fee_total} ;;
  }

  ######### Items Refunds

  measure: sum_amt_refund_items_net {
    group_label: "> Refunds Items"
    label: "SUM Refund Items Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_items_net} ;;
  }

  measure: sum_amt_refund_items_gross {
    group_label: "> Refunds Items"
    label: "SUM Refund Items Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_items_gross} ;;
  }

  measure: sum_amt_refund_items_reduced_net {
    group_label: "> Refunds Items"
    label: "SUM Refund Items Reduced Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_items_reduced_net} ;;
  }

  measure: sum_amt_refund_items_standard_net {
    group_label: "> Refunds Items"
    label: "SUM Refund Items Standard Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_items_standard_net} ;;
  }

  measure: sum_amt_refund_items_special_net {
    group_label: "> Refunds Items"
    label: "SUM Refund Items Special Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_items_special_net} ;;
  }

  measure: sum_amt_refund_items_reduced_gross {
    group_label: "> Refunds Items"
    label: "SUM Refund Items Reduced Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_items_reduced_gross} ;;
  }

  measure: sum_amt_refund_items_standard_gross {
    group_label: "> Refunds Items"
    label: "SUM Refund Items Standard Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_items_standard_gross} ;;
  }

  measure: sum_amt_refund_items_special_gross {
    group_label: "> Refunds Items"
    label: "SUM Refund Items Special Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_items_special_gross} ;;
  }

  measure: sum_amt_vat_refund_items_reduced {
    group_label: "> Refunds Items"
    label: "SUM VAT Refund Items Reduced"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_vat_refund_items_reduced} ;;
  }

  measure: sum_amt_vat_refund_items_standard {
    group_label: "> Refunds Items"
    label: "SUM VAT Refund Items Standard"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_vat_refund_items_standard} ;;
  }

  measure: sum_amt_vat_refund_items_special {
    group_label: "> Refunds Items"
    label: "SUM VAT Refund Items Special"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_vat_refund_items_special} ;;
  }

  measure: sum_amt_vat_refund_items_total {
    group_label: "> Refunds Items"
    label: "SUM VAT Refund Items Total"
    value_format: "#,##0.00€"
    type: sum
    sql: ${amt_vat_refund_items_total} ;;
  }

  ###### Deposit Refunds

  measure: sum_amt_refund_deposit_net {
    group_label: "> Refunds Deposit"
    label: "SUM Refund Deposit Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_deposit_net} ;;
  }

  measure: sum_amt_refund_deposit_gross {
    group_label: "> Refunds Deposit"
    label: "SUM Refund Deposit Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_deposit_gross} ;;
  }

  measure: sum_amt_refund_deposit_reduced_net {
    group_label: "> Refunds Deposit"
    label: "SUM Refund Deposit Reduced Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_deposit_reduced_net} ;;
  }

  measure: sum_amt_refund_deposit_standard_net {
    group_label: "> Refunds Deposit"
    label: "SUM Refund Deposit Standard Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_deposit_standard_net} ;;
  }

  measure: sum_amt_refund_deposit_special_net {
    group_label: "> Refunds Deposit"
    label: "SUM Refund Deposit Special Net"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_deposit_special_net} ;;
  }

  measure: sum_amt_refund_deposit_reduced_gross {
    group_label: "> Refunds Deposit"
    label: "SUM Refund Deposit Reduced Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_deposit_reduced_gross} ;;
  }

  measure: sum_amt_refund_deposit_standard_gross {
    group_label: "> Refunds Deposit"
    label: "SUM Refund Deposit Standard Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_deposit_standard_gross} ;;
  }

  measure: sum_amt_refund_deposit_special_gross {
    group_label: "> Refunds Deposit"
    label: "SUM Refund Deposit Special Gross"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_refund_deposit_special_gross} ;;
  }

  measure: sum_amt_vat_refund_deposit_reduced {
    group_label: "> Refunds Deposit"
    label: "SUM VAT Refund Deposit Reduced"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_vat_refund_deposit_reduced} ;;
  }

  measure: sum_amt_vat_refund_deposit_standard {
    group_label: "> Refunds Deposit"
    label: "SUM VAT Refund Deposit Standard"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_vat_refund_deposit_standard} ;;
  }

  measure: sum_amt_vat_refund_deposit_special {
    group_label: "> Refunds Deposit"
    label: "SUM VAT Refund Deposit Special"
    type: sum
    value_format: "#,##0.00€"
    sql: ${amt_vat_refund_deposit_special} ;;
  }

  measure: sum_amt_vat_refund_deposit_total {
    group_label: "> Refunds Deposit"
    label: "SUM VAT Refund Deposit Total"
    value_format: "#,##0.00€"
    type: sum
    sql: ${amt_vat_refund_deposit_total} ;;
  }

  #####################  Total VAT  ##########################

  measure: sum_total_gross {
    group_label: "> Total"
    type: sum
    label: "SUM Revenue (Gross) after Refunds & Discounts deduction"
    description: "Items Gross + DF Gross - Discounts Gross - Refunds Gross"
    value_format: "#,##0.00€"
    sql: ${total_gross} ;;
  }

  measure: sum_total_net {
    group_label: "> Total"
    type: sum
    label: "SUM Revenue (Net) after Refunds & Discounts deduction"
    description: "Items Net + DF Net - Discounts Net - Refunds Net"
    value_format: "#,##0.00€"
    sql: ${total_net} ;;
  }

  measure: sum_total_vat {
    group_label: "> Total"
    type: sum
    label: "SUM VAT Order Total"
    description: "Revenue (Gross) - Revenue (Net). After Deduction of Discounts and Refunds."
    value_format: "#,##0.00€"
    sql: ${total_vat} ;;
  }

  ################# Rider Tip

  measure: sum_rider_tip {
    group_label: "> Rider Tips"
    value_format: "#,##0.00€"
    label: "SUM Rider Tips (Gross)"
    type: sum
    sql: ${amt_rider_tip} ;;
  }

  measure: sum_refund_rider_tip {
    group_label: "> Rider Tips"
    label: "SUM Refunds Rider Tips (Gross)"
    value_format: "#,##0.00€"
    type: sum
    sql: ${amt_refund_rider_tip_gross} ;;
  }


################# Rider Tip

  measure: sum_amt_total_deposit {
    group_label: "> Deposit"
    label: "SUM Deposit (Gross)"
    description: "Discount don't apply to deposit"
    value_format: "#,##0.00€"
    type: sum
    sql: ${amt_total_deposit} ;;
  }

  measure: sum_deposit_amount_standard_gross {
    group_label: "> Deposit"
    label: "SUM Deposit Standard (Gross)"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_standard_gross} ;;
  }

  measure: sum_deposit_amount_reduced_gross {
    group_label: "> Deposit"
    label: "SUM Deposit Reduced (Gross)"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_reduced_gross} ;;
  }

  measure: sum_deposit_amount_special_gross {
    group_label: "> Deposit"
    label: "SUM Deposit Special (Gross)"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_special_gross} ;;
  }

  measure: sum_deposit_amount_net {
    group_label: "> Deposit"
    label: "SUM Deposit (Net)"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_net} ;;
  }

  measure: sum_deposit_amount_standard_net {
    group_label: "> Deposit"
    label: "SUM Deposit Standard (Net)"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_standard_net} ;;
  }

  measure: sum_deposit_amount_reduced_net {
    group_label: "> Deposit"
    label: "SUM Deposit Reduced (Net)"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_reduced_net} ;;
  }

  measure: sum_deposit_amount_special_net {
    group_label: "> Deposit"
    label: "SUM Deposit Special (Net)"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_special_net} ;;
  }

  measure: sum_quantity_deposit {
    group_label: "> Deposit"
    label: "Quantity Deposit"
    description: "Quantity of Items for which the customer paid a deposit"
    type: sum
    sql: ${quantity_deposit} ;;
  }




  set: detail {
    fields: [
    ]
  }
}
