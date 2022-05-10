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
    group_label: "Order Date"
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
    group_label: "Refund Date"
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
    type: yesno
    sql: ${TABLE}.is_free_delivery_discount ;;
  }

  dimension: is_external_order {
    type: yesno
    sql: ${TABLE}.is_external_order ;;
  }

  dimension: is_successful_order {
    type: yesno
    sql: ${TABLE}.is_successful_order ;;
  }

  dimension: order_status {
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
    type: string
    hidden: yes
    sql: ${TABLE}.payment_type ;;
  }

  dimension: payment_method {
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: amt_rider_tip {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_rider_tip ;;
  }

######## ITEMS ############
  dimension: items_price_net {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_net ;;
  }

  dimension: items_price_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_gross ;;
  }

  dimension: items_price_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_reduced_net ;;
  }

  dimension: items_price_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_reduced_gross ;;
  }

  dimension: items_price_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_special_net ;;
  }

  dimension: items_price_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_special_gross ;;
  }

  dimension: items_price_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_standard_net ;;
  }

  dimension: items_price_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.items_price_standard_gross ;;
  }

  dimension: vat_items_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_items_reduced ;;
  }

  dimension: vat_items_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_items_standard ;;
  }

  dimension: amt_total_deposit {
    hidden: yes
    type: number
    sql: ${TABLE}.deposit_amount_gross ;;
  }

  dimension: deposit_amount_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.deposit_amount_standard_gross ;;
  }

  dimension: deposit_amount_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.deposit_amount_reduced_gross ;;
  }

  dimension: deposit_amount_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.deposit_amount_special_gross ;;
  }

  dimension: deposit_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.deposit_amount_standard_net ;;
  }

  dimension: deposit_amount_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.deposit_amount_reduced_net ;;
  }

  dimension: deposit_amount_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.deposit_amount_special_net ;;
  }

  dimension: deposit_amount_net {
    hidden: yes
    type: number
    sql: ${TABLE}.deposit_amount_net ;;
  }

  dimension: quantity_deposit {
    hidden: yes
    type: number
    sql: ${TABLE}.quantity_deposit ;;
  }

  dimension: vat_items_special{
    hidden: yes
    type: number
    sql: ${TABLE}.vat_items_special ;;
  }

  dimension: vat_items_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_items_total ;;
  }

############## DELIVERY FEES #############
  dimension: delivery_fee_net {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_net ;;
  }

  dimension: delivery_fee_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_gross ;;
  }

  dimension: delivery_fee_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_reduced_net ;;
  }

  dimension: delivery_fee_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_standard_net ;;
  }

  dimension: delivery_fee_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_special_net ;;
  }

  dimension: delivery_fee_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_reduced_gross ;;
  }

  dimension: delivery_fee_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_standard_gross ;;
  }

  dimension: delivery_fee_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_fee_special_gross ;;
  }

  dimension: vat_delivery_fee_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_delivery_fee_reduced ;;
  }

  dimension: vat_delivery_fee_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_delivery_fee_standard ;;
  }

  dimension: vat_delivery_fee_special {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_delivery_fee_special ;;
  }

  dimension: vat_delivery_fee_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_delivery_fee_total ;;
  }


  ############## DISCOUNTS #############

  dimension: discount_amount_net {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_net ;;
  }

  dimension: discount_amount_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_gross ;;
  }

  dimension: discount_amount_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_reduced_net ;;
  }

  dimension: discount_amount_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_reduced_gross ;;
  }

  dimension: discount_amount_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_special_net ;;
  }

  dimension: discount_amount_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_special_gross ;;
  }

  dimension: discount_amount_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_standard_gross ;;
  }

  dimension: discount_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.discount_amount_standard_net ;;
  }

  dimension: vat_discount_amount_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_discount_amount_reduced ;;
  }

  dimension: vat_discount_amount_special {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_discount_amount_special ;;
  }

  dimension: vat_discount_amount_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_discount_amount_standard ;;
  }

  dimension: vat_discount_amount_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_discount_amount_total ;;
  }

  ############### REFUNDS #############

  dimension: refund_amount_net {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_net ;;
  }

  dimension: refund_amount_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_gross ;;
  }

  dimension: refund_amount_reduced_net {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_reduced_net ;;
  }

  dimension: refund_amount_standard_net {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_standard_net ;;
  }

  dimension: refund_amount_special_net {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_special_net ;;
  }

  dimension: refund_amount_reduced_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_reduced_gross ;;
  }

  dimension: refund_amount_standard_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_standard_gross ;;
  }

  dimension: refund_amount_special_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.refund_amount_special_gross ;;
  }

  dimension: vat_refund_amount_reduced {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_refund_amount_reduced ;;
  }

  dimension: vat_refund_amount_standard {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_refund_amount_standard ;;
  }

  dimension: vat_refund_amount_special{
    hidden: yes
    type: number
    sql: ${TABLE}.vat_refund_amount_special ;;
  }

  dimension: vat_refund_amount_total {
    hidden: yes
    type: number
    sql: ${TABLE}.vat_refund_amount_total ;;
  }


######## TOTALS #########

  dimension: total_net {
    hidden: yes
    type: number
    sql: ${TABLE}.total_net ;;
  }

  dimension: total_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.total_gross ;;
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
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_net} ;;
  }

  measure: sum_items_price_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_gross} ;;
  }

  measure: sum_items_price_reduced_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_reduced_gross} ;;
  }

  measure: sum_items_price_reduced_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_reduced_net} ;;
  }

  measure: sum_items_price_special_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_special_gross} ;;
  }

  measure: sum_items_price_special_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_special_net} ;;
  }

  measure: sum_items_price_standard_gross {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_standard_gross} ;;
  }

  measure: sum_items_price_standard_net {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${items_price_standard_net} ;;
  }

  measure: sum_vat_items_reduced {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_reduced} ;;
  }

  measure: sum_vat_items_special {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_special} ;;
  }

  measure: sum_vat_items_standard {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_standard} ;;
  }

  measure: sum_vat_items_total {
    group_label: "* Items *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_items_total} ;;
  }


  ##################### Delivery Fees ##########################


  measure: sum_delivery_fee_net {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_net} ;;
  }

  measure: sum_delivery_fee_gross {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_gross} ;;
  }

  measure: sum_delivery_fee_reduced_net {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_reduced_net} ;;
  }


  measure: sum_delivery_fee_standard_net {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_standard_net} ;;
  }

  measure: sum_delivery_fee_special_net {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_special_net} ;;
  }

  measure: sum_delivery_fee_special_gross {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_special_gross} ;;
  }

  measure: sum_delivery_fee_reduced_gross {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_reduced_gross} ;;
  }

  measure: sum_delivery_fee_standard_gross {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${delivery_fee_standard_gross} ;;
  }

  measure: sum_vat_delivery_fee_reduced {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_reduced} ;;
  }

  measure: sum_vat_delivery_fee_standard {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_standard} ;;
  }

  measure: sum_vat_delivery_fee_special {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_special} ;;
  }

  measure: sum_vat_delivery_fee_total {
    group_label: "* Delivery Fee *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_delivery_fee_total} ;;
  }


    ##################### Discounts  ##########################


  measure: sum_discount_amount_net {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_net} ;;
  }

  measure: sum_discount_amount_gross {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_gross} ;;
  }


  measure: sum_discount_amount_reduced_net {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_reduced_net} ;;
  }

  measure: sum_discount_amount_standard_net {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_standard_net} ;;
  }

  measure: sum_discount_amount_special_net {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_special_net} ;;
  }

  measure: sum_discount_amount_reduced_gross {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_reduced_gross} ;;
  }

  measure: sum_discount_amount_special_gross {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_special_gross} ;;
  }

  measure: sum_discount_amount_standard_gross {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${discount_amount_standard_gross} ;;
  }

  measure: sum_vat_discount_amount_reduced {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_reduced} ;;
  }

  measure: sum_vat_discount_amount_standard {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_standard} ;;
  }

  measure: sum_vat_discount_amount_special {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_special} ;;
  }

  measure: sum_vat_discount_amount_total {
    group_label: "* Discounts *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_discount_amount_total} ;;
  }

  measure: sum_discount_amount_free_delivery_gross {
    group_label: "* Discounts *"
    value_format: "#,##0.00€"
    type: sum
    hidden: yes
    sql: ${discount_free_delivery_gross} ;;
  }



    #####################  Refunds  ##########################


  measure: sum_refund_amount_net {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_net} ;;
  }

  measure: sum_refund_amount_gross {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_gross} ;;
  }

  measure: sum_refund_amount_reduced_net {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_reduced_net} ;;
  }

  measure: sum_refund_amount_standard_net {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_standard_net} ;;
  }

  measure: sum_refund_amount_special_net {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_special_net} ;;
  }

  measure: sum_refund_amount_reduced_gross {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_reduced_gross} ;;
  }

  measure: sum_refund_amount_standard_gross {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_standard_gross} ;;
  }

  measure: sum_refund_amount_special_gross {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${refund_amount_special_gross} ;;
  }

  measure: sum_vat_refund_amount_reduced {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_refund_amount_reduced} ;;
  }

  measure: sum_vat_refund_amount_standard {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_refund_amount_standard} ;;
  }

  measure: sum_vat_refund_amount_special {
    group_label: "* Refunds *"
    type: sum
    value_format: "#,##0.00€"
    sql: ${vat_refund_amount_special} ;;
  }

  measure: sum_vat_refund_amount_total {
    group_label: "* Refunds *"
    value_format: "#,##0.00€"
    type: sum
    sql: ${vat_refund_amount_total} ;;
  }


    #####################  Total VAT  ##########################

  measure: sum_total_gross {
    group_label: "* Total *"
    type: sum
    description: "Items Gross + DF Gross - Discounts Gross - Refunds Gross"
    value_format: "#,##0.00€"
    sql: ${total_gross} ;;
  }

  measure: sum_total_net {
    group_label: "* Total *"
    type: sum
    description: "Items Net + DF Net - Discounts Net - Refunds Net"
    value_format: "#,##0.00€"
    sql: ${total_net} ;;
  }

  measure: sum_total_vat {
    group_label: "* Total *"
    type: sum
    description: "Total Gross - Total Net"
    value_format: "#,##0.00€"
    sql: ${total_vat} ;;
  }

  ################# Rider Tip

  measure: sum_rider_tip {
    group_label: "* Rider Tips *"
    value_format: "#,##0.00€"
    type: sum
    sql: ${amt_rider_tip} ;;
  }


################# Rider Tip

  measure: sum_amt_total_deposit {
    group_label: "* Deposit *"
    label: "Gross Deposit"
    description: "Tax and Discount don't apply to deposit"
    value_format: "#,##0.00€"
    type: sum
    sql: ${amt_total_deposit} ;;
  }

  measure: sum_deposit_amount_standard_gross {
    group_label: "* Deposit *"
    label: "Deposit Amount Standard Gross"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_standard_gross} ;;
  }

  measure: sum_deposit_amount_reduced_gross {
    group_label: "* Deposit *"
    label: "Deposit Amount Reduced Gross"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_reduced_gross} ;;
  }

  measure: sum_deposit_amount_special_gross {
    group_label: "* Deposit *"
    label: "Deposit Amount Special Gross"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_special_gross} ;;
  }

  measure: sum_deposit_amount_net {
    group_label: "* Deposit *"
    label: "Net Deposit"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_net} ;;
  }

  measure: sum_deposit_amount_standard_net {
    group_label: "* Deposit *"
    label: "Deposit Amount Standard Net"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_standard_net} ;;
  }

  measure: sum_deposit_amount_reduced_net {
    group_label: "* Deposit *"
    label: "Deposit Amount Reduced Net"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_reduced_net} ;;
  }

  measure: sum_deposit_amount_special_net {
    group_label: "* Deposit *"
    label: "Deposit Amount Special Net"
    description: ""
    value_format: "#,##0.00€"
    type: sum
    sql: ${deposit_amount_special_net} ;;
  }

  measure: sum_quantity_deposit {
    group_label: "* Deposit *"
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
