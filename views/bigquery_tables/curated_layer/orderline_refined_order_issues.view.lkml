include: "/views/**/*.view"
view: +orderline {

  set: orders_core_fields {
    fields: [
      pct_pre_order_fulfillment_rate,
      pct_pre_order_issue_rate_per_total_items_picked,
      pct_pre_order_issue_rate_per_total_orders,
      pct_post_order_issue_rate_per_total_orders,
      delivery_issue_groups,
      hlp_pre_post_filter
    ]
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

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~  START Issue Reasons - BASE   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
            or ${return_reason} like '%perrished%'
            or ${return_reason} = 'purished'
            or ${return_reason} = 'goods_spoiled'           then 'perished product'
          when ${return_reason} like '%swapped%'            then 'swapped product'
          when ${return_reason} like '%damage%'             then 'damaged product'
          when ${return_reason} like '%cancel%'             then 'cancelled product'
          when ${return_reason} like '%not_on_shelf%'
            or ${return_reason} like '%out of stock%'
            or ${return_reason} like '%out_of_stock%'
            or ${return_reason} like '%not in stock%'
            or ${return_reason} = 'goods_not_shelf'
            or ${return_reason} = 'goods_not_on _shelf'
                                                            then 'goods not on shelf'
          -- no other match
          when ${return_reason} like '%miss%'
            or ${return_reason} = 'misisng'
            or ${return_reason} = 'mıssıng'
            or ${return_reason} = 'not received'            then 'missing product'

          when ${return_reason} like '%description%'        then 'item-description'

          when ${return_reason} like '%quality%'        then 'item-quality'

          when ${return_reason} is not null                 then 'undefined group'
      end

    ;;
  }

  dimension: delivery_issue_stage {

    label: "Delivery Issue Stage"
    description: "Classifies delivery issues in either Pre-Delivery Issues (source: picker) or Post-Delivery Issues (source: customer)"
    group_label: "> Delivery Issues"

    type: string
    sql:
      case
          when ${return_reason} in (
                              'goods_not_on_shelf',
                              'goods_damaged',
                              'goods_spoiled'
                                )
          then "pre-delivery issues"
          when ${return_reason} is not null
           and ${return_reason} not in (
                              'goods_not_on_shelf',
                              'goods_damaged',
                              'goods_spoiled'
                                )
            and ${return_reason} not like '%cancel%'
          then "post-delivery issues"
      end
    ;;


  }


  measure: cnt_delivery_issues {
    label: "# Delivery Issues (Post- + Pre-Delivery)"
    group_label: "> Delivery Issues"
    type: number
    sql:
          ${cnt_products_not_on_shelf_pre} +
          ${cnt_damaged_products_pre}      +
          ${cnt_perished_products_pre}     +

          ${cnt_products_not_on_shelf_post}       +
          ${cnt_damaged_products_post}            +
          ${cnt_perished_products_post}           +
          ${cnt_missing_products}                 +
          ${cnt_swapped_products}                 +
          ${cnt_products_item_description_issues} +
          ${cnt_products_bad_quality_issues}      +
          ${cnt_wrong_products}                   +
          ${cnt_undefined_issues}
        ;;
  }

  measure: cnt_pre_delivery_issues {

    label:       "# Pre-Delivery Issues"
    description: "Order-Issues, that are detected pre-delivery"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_products_not_on_shelf_pre} +
         ${cnt_damaged_products_pre}      +
         ${cnt_perished_products_pre}
    ;;

    value_format_name: decimal_0
  }

  measure: cnt_post_delivery_issues {

    label:       "# Post-Delivery Issues"
    description: "Order-Issues, that are detected post-delivery"
    group_label: "> Delivery Issues"

    type: number
    sql:  ${cnt_products_not_on_shelf_post}       +
          ${cnt_damaged_products_post}            +
          ${cnt_perished_products_post}           +
          ${cnt_missing_products}                 +
          ${cnt_swapped_products}                 +
          ${cnt_products_item_description_issues} +
          ${cnt_products_bad_quality_issues}      +
          ${cnt_wrong_products}                   +
          ${cnt_undefined_issues}
        ;;

    value_format_name: decimal_0
  }

  # ~~~~~~~~~~~~  END Issue Reasons - BASE   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~  START Issue Reasons - Granular Metrics   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: hlp_pre_post_filter {

    type: string
    sql:
      case
        when ${delivery_issue_groups} = "perished product"
         and ${delivery_issue_stage}  = "pre-delivery issues"
        then "pre_perished"

        when ${delivery_issue_groups} = "perished product"
         and ${delivery_issue_stage}  = "post-delivery issues"
        then "post_perished"

        when ${delivery_issue_groups} = "goods not on shelf"
         and ${delivery_issue_stage}  = "pre-delivery issues"
        then "pre_shelf"

        when ${delivery_issue_groups} = "goods not on shelf"
         and ${delivery_issue_stage}  = "post-delivery issues"
        then "post_shelf"

        when ${delivery_issue_groups} = "damaged product"
         and ${delivery_issue_stage}  = "pre-delivery issues"
        then "pre_damaged"

        when ${delivery_issue_groups} = "damaged product"
         and ${delivery_issue_stage}  = "post-delivery issues"
        then "post_damaged"

      end
    ;;
    hidden: yes

  }

  # >>> PRE + POST Order Issues  :: START
  measure: cnt_perished_products_post {

    label:       "# Perished Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with perished products and were claimed through the Customer Service"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [hlp_pre_post_filter: "post_perished"]

    value_format_name: decimal_0

  }
  measure: cnt_perished_products_pre {

    label:       "# Perished Products (Pre Delivery Issues)"
    description: "The number of orders, that had issues with perished products and were identified in the picking process (Swipe) "
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [hlp_pre_post_filter: "pre_perished"]

    value_format_name: decimal_0

  }


  measure: cnt_products_not_on_shelf_post {

    label:       "# Products not on shelf (Post Delivery Issues)"
    description: "The number of orders, that had issues with products not being in stock and were claimed through the Customer Service"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [hlp_pre_post_filter: "post_shelf"]

    value_format_name: decimal_0

  }
  measure: cnt_products_not_on_shelf_pre {

    label:       "# Products not on shelf (Pre Delivery Issues)"
    description: "The number of orders, that had issues with products not being in stock and were identified in the picking process (Swipe)"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [hlp_pre_post_filter: "pre_shelf"]

    value_format_name: decimal_0

  }


  measure: cnt_damaged_products_post {
    label: "# Damaged Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with damaged products and were claimed through the Customer Service"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [hlp_pre_post_filter: "post_damaged"]

    value_format_name: decimal_0

  }
  measure: cnt_damaged_products_pre {
    label: "# Damaged Products (Pre Delivery Issues)"
    description: "The number of orders, that had issues with damaged products and were identified in the picking process (Swipe)"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [hlp_pre_post_filter: "pre_damaged"]

    value_format_name: decimal_0

  }
  # >>> PRE + POST Order Issues  :: END



  # >>> POST Order Issues  :: START
  measure: cnt_missing_products {

    label:       "# Missing Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with missing products"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "missing product"]

    value_format_name: decimal_0

  }

  measure: cnt_wrong_products {

    label:       "# Wrong Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with wrong products"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "wrong product"]

    value_format_name: decimal_0

  }

  measure: cnt_swapped_products {

    label:       "# Swapped Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with swapped products"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "swapped product"]

    value_format_name: decimal_0

  }

  measure: cnt_cancelled_products {

    # This metric is not part of the issue rates, as the customer vóluntary cancelled a product.
    label:       "# Cancelled Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with cancelled products"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "cancelled product"]

    value_format_name: decimal_0

  }

  measure: cnt_products_item_description_issues {

    label:       "# Products Issue Item Description (Post Delivery Issues)"
    description: "The number of orders, that had issues related to item descriptions"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "item-description"]

    value_format_name: decimal_0

  }

  measure: cnt_products_bad_quality_issues {

    label:       "# Products Issue Item Quality (Post Delivery Issues)"
    description: "The number of orders, that had issues related to item quality"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "item-quality"]

    value_format_name: decimal_0

  }

  measure: cnt_undefined_issues {

    label:       "# Unknown Issues (Post Delivery Issues)"
    description: "The number of orders, that had issues with unknown issue groups (see Return Reason to check the specific issue reasons)"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [delivery_issue_groups: "undefined group"]

    value_format_name: decimal_0
    hidden: no

  }
  # >>> POST Order Issues  :: END


  # ~~~~~~~~~~~~    END Issue Reasons - Granular Metrics   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~  START Percentages   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: pct_pre_order_issue_rate_per_total_orders {

    label:       "% Partial fulfillment Rate (preoder)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had pre-delivery issues"

    type: number
    sql:  ${cnt_pre_delivery_issues} / nullif(${cnt_total_orders} ,0);;

    value_format_name: percent_2

  }

  measure: pct_post_order_issue_rate_per_total_orders {

    label:       "% Issue Rate (post order)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had post-delivery issues"

    type: number
    sql:  ${cnt_post_delivery_issues} / nullif(${cnt_total_orders} ,0);;

    value_format_name: percent_2

  }

  measure: pct_pre_order_issue_rate_per_total_items_picked {

    label:       "% Item unfulfilled (preorder)"
    group_label: "> Delivery Issues"
    description: "The percentage of unique SKUs per order, that had pre-delivery issues"

    type: number
    sql:  ${cnt_pre_delivery_issues} / nullif(${cnt_total_picks} ,0);;

    value_format_name: percent_2

  }

  measure: pct_pre_order_fulfillment_rate {

    label:       "% Pre-Order Fulfillment Rate"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had no pre-delivery issues"

    type: number
    sql: 1 - ${pct_pre_order_issue_rate_per_total_orders} ;;

    value_format_name: percent_2

  }


  # >>>


  measure: pct_not_on_shelf_issue_rate {

    label:       "% Goods Not On Shelf Issue Rate"
    group_label: "> Delivery Issues"

    type: number
    sql: (${cnt_products_not_on_shelf_pre} + ${cnt_products_not_on_shelf_post}) / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_missing_product_issue_rate {

    label:       "% Missing Product Issue Rate"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_missing_products} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_damaged_product_issue_rate {

    label:       "% Damaged Product Issue Rate"
    group_label: "> Delivery Issues"

    type: number
    sql: (${cnt_damaged_products_pre} + ${cnt_damaged_products_post}) / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_cancelled_product_issue_rate {

    label:       "% Cancelled Product Issue Rate"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_cancelled_products} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_perished_product_issue_rate {

    label:       "% Perished Product Issue Rate"
    group_label: "> Delivery Issues"

    type: number
    sql: (${cnt_perished_products_pre} + ${cnt_perished_products_post}) / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_wrong_product_issue_rate {

    label:       "% Wrong Product Issue Rate"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_wrong_products} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_swapped_product_issue_rate {

    label:       "% Swapped Product Issue Rate"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_swapped_products} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_products_item_description_issues {

    label:       "% Item Description Issue Rate"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_products_item_description_issues} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_products_bad_quality_issues {

    label:       "% Item Quality Issue Rate"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_products_bad_quality_issues} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  # ~~~~~~~~~~~~  END Percentages   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



}
