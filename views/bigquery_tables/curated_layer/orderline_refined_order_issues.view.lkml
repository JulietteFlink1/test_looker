include: "/views/**/*.view"
view: +orderline {

  set: orders_core_fields {
    fields: [
      pct_pre_order_fulfillment_rate,
      pct_pre_order_issue_rate_per_total_items_picked,
      pct_pre_order_issue_rate_per_total_orders,
      pct_post_order_issue_rate_per_total_orders,
      delivery_issue_groups,
    ]
  }

  dimension: return_reason {
    type: string
    label: "Return Reason"
    group_label: "> Delivery Issues"
    description: "The reason, why and order-lineitem was returned as shown in Commercetools"
    sql: lower(${TABLE}.return_reason) ;;
  }

  dimension: delivery_issue_groups {
    type: string
    label: "Delivery Issue Groups"
    group_label: "> Delivery Issues"
    description: "The delivery issue groups based on CommerceTools"
    sql:

      case
          when ${return_reason} like '%missing%'            then 'missing product'
          when ${return_reason} like '%wrong%'              then 'wrong product'
          when ${return_reason} like '%perished%'
            or ${return_reason} = 'goods_spoiled'           then 'perished product'
          when ${return_reason} like '%swapped%'            then 'swapped product'
          when ${return_reason} like '%damage%'             then 'damaged product'
          when ${return_reason} like '%cancel%'             then 'cancelled product'
          when ${return_reason} like '%goods_not_on_shelf%'
            or ${return_reason} like '%out of stock%'
            or ${return_reason} like '%out_of_stock%'
            or ${return_reason} like '%not in stock%'
                                                            then 'goods not on shelf'
          -- no other match
          when ${return_reason} like '%miss%'               then 'missing product'

          when ${return_reason} is not null                 then 'undefined group'
      end

    ;;
  }

  dimension: delivery_issue_stage {
    type: string
    label: "Delivery Issue Stage"
    description: "Classifies delivery issues in either Pre-Delivery Issues (source: picker) or Post-Delivery Issues (source: customer)"
    group_label: "> Delivery Issues"
    sql:
      case
          when ${delivery_issue_groups} = 'goods not on shelf'  then 'pre-delivery issues'
          when ${delivery_issue_groups} is not null
           and ${delivery_issue_groups} != 'goods not on shelf' then 'post-delivery issues'
      end
    ;;
  }

  measure: cnt_missing_products {
    label: "# Missing Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with missing products"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "missing product"]
  }

  measure: cnt_wrong_products {
    label: "# Wrong Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with wrong products"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "wrong product"]
  }

  measure: cnt_perished_products {
    label: "# Perished Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with perished products"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "perished product"]
  }

  measure: cnt_swapped_products {
    label: "# Swapped Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with swapped products"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "swapped product"]
  }

  measure: cnt_damaged_products {
    label: "# Damaged Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with damaged products"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "damaged product"]
  }

  measure: cnt_cancelled_products {
    label: "# Cancelled Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with cancelled products"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "cancelled product"]
  }

  measure: cnt_products_not_on_shelf {
    label: "# Products not on shelf (Pre Delivery Issues)"
    description: "The number of orders, that had issues with products before delivery"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "goods not on shelf"]
  }

  measure: cnt_undefined_issues {
    label: "# Unknown Issues (Post Delivery Issues)"
    description: "The number of orders, that had issues with unknown issue groups (see Return Reason to check the specific issue reasons)"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "undefined group"]
    hidden: yes
  }

  measure: cnt_delivery_issues {
    label: "# Delivery Issues (Post- + Pre-Delivery)"
    group_label: "> Delivery Issues"
    type: number
    sql: ${cnt_cancelled_products} +
         ${cnt_damaged_products} +
         ${cnt_missing_products} +
         ${cnt_perished_products} +
         ${cnt_swapped_products} +
         ${cnt_wrong_products} +
         ${cnt_undefined_issues} +
         ${cnt_products_not_on_shelf}
        ;;
  }

  measure: cnt_pre_delivery_issues {
    label: "# Pre-Delivery Issues"
    description: "Order-Issues, that are detected pre-delivery"
    group_label: "> Delivery Issues"
    type: number
    sql: ${cnt_products_not_on_shelf} ;;
  }

  measure: cnt_post_delivery_issues {
    label: "# Post-Delivery Issues"
    description: "Order-Issues, that are detected post-delivery"
    group_label: "> Delivery Issues"
    type: number
    sql:  ${cnt_cancelled_products} +
          ${cnt_damaged_products} +
          ${cnt_missing_products} +
          ${cnt_perished_products} +
          ${cnt_swapped_products} +
          ${cnt_wrong_products} +
          ${cnt_undefined_issues}
        ;;
  }

  measure: cnt_total_orders {
    type: count_distinct
    sql: ${order_uuid};;
    hidden: yes
    group_label: "> Delivery Issues"
  }

  measure: cnt_total_picks {
    type: count_distinct
    sql: ${order_lineitem_uuid} ;;
    hidden: yes
    group_label: "> Delivery Issues"
  }

  measure: pct_pre_order_issue_rate_per_total_orders {
    label: "% Partial fulfillment Rate (preoder)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had pre-delivery issues"
    type: number
    sql:  ${cnt_pre_delivery_issues} / nullif(${cnt_total_orders} ,0);;
    value_format_name: percent_2
  }

  measure: pct_post_order_issue_rate_per_total_orders {
    label: "% Post-Order Issue Rate (per Total Orders)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had post-delivery issues"
    type: number
    sql:  ${cnt_post_delivery_issues} / nullif(${cnt_total_orders} ,0);;
    value_format_name: percent_2
  }

  measure: pct_pre_order_issue_rate_per_total_items_picked {
    label: "% Pre-Order Issue Rate (per Total Picks)"
    group_label: "> Delivery Issues"
    description: "The percentage of unique SKUs per order, that had pre-delivery issues"
    type: number
    sql:  ${cnt_pre_delivery_issues} / nullif(${cnt_total_picks} ,0);;
    value_format_name: percent_2
  }

  measure: pct_pre_order_fulfillment_rate {
    label: "% Pre-Order Fulfillment Rate"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had no pre-delivery issues"
    type: number
    sql: 1 - ${pct_pre_order_issue_rate_per_total_orders} ;;
    value_format_name: percent_2
  }




  measure: pct_missing_product_issue_rate {
    label: "% Missing Product Issue Rate"
    group_label: "> Delivery Issues"
    type: number
    sql: ${cnt_missing_products} / nullif( ${cnt_total_orders} ,0 ) ;;
    value_format_name: percent_2
  }

  measure: pct_damaged_product_issue_rate {
    label: "% Damaged Product Issue Rate"
    group_label: "> Delivery Issues"
    type: number
    sql: ${cnt_damaged_products} / nullif( ${cnt_total_orders} ,0 ) ;;
    value_format_name: percent_2
  }

  measure: pct_cancelled_product_issue_rate {
    label: "% Cancelled Product Issue Rate"
    group_label: "> Delivery Issues"
    type: number
    sql: ${cnt_cancelled_products} / nullif( ${cnt_total_orders} ,0 ) ;;
    value_format_name: percent_2
  }

  measure: pct_perished_product_issue_rate {
    label: "% Perished Product Issue Rate"
    group_label: "> Delivery Issues"
    type: number
    sql: ${cnt_perished_products} / nullif( ${cnt_total_orders} ,0 ) ;;
    value_format_name: percent_2
  }

  measure: pct_wrong_product_issue_rate {
    label: "% Wrong Product Issue Rate"
    group_label: "> Delivery Issues"
    type: number
    sql: ${cnt_wrong_products} / nullif( ${cnt_total_orders} ,0 ) ;;
    value_format_name: percent_2
  }

  measure: pct_swapped_product_issue_rate {
    label: "% Swapped Product Issue Rate"
    group_label: "> Delivery Issues"
    type: number
    sql: ${cnt_swapped_products} / nullif( ${cnt_total_orders} ,0 ) ;;
    value_format_name: percent_2
  }



}
