include: "/views/**/*.view"
view: +orderline {

  set: orders_core_fields {
    fields: [
      pct_pre_order_fulfillment_rate,
      pct_pre_order_issue_rate_per_total_items_picked,
      pct_pre_order_issue_rate_per_total_orders,
      pct_post_order_issue_rate_per_total_orders,
      pct_hub_related_post_order_issue_rate_per_total_orders,
      delivery_issue_groups,
      number_of_products_with_perished_light_issues_dim,
      number_of_products_with_perished_issues_pre_dim,
      number_of_products_with_perished_issues_post_dim,
      number_of_products_with_products_not_on_shelf_issues_pre_dim,
      number_of_products_with_products_not_on_shelf_issues_post_dim,
      number_of_products_with_damaged_products_issues_pre_dim,
      number_of_products_with_damaged_products_issues_post_dim,
      number_of_products_with_missing_products_issues_dim,
      number_of_products_with_wrong_products_issues_dim,
      number_of_products_with_swapped_products_issues_dim,
      number_of_products_with_cancelled_products_issues_dim,
      number_of_products_with_item_description_issues_dim,
      number_of_products_with_item_quality_issues_dim,
      number_of_products_with_undefined_issues_dim

    ]
  }


  measure: cnt_total_orders {
    type: count_distinct
    sql: ${order_uuid};;
    hidden: yes
    group_label: "> Delivery Issues"
  }

  measure: count_order_lineitems {
    type: count_distinct
    label: "# Lineitems"
    group_label: "> Delivery Issues Products"
    hidden:  yes
    sql: ${order_lineitem_uuid} ;;
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

  measure: cnt_delivery_issues {
    label: "# Orders Delivery Issues (Post- + Pre-Delivery)"
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

    label:       "# Orders Pre-Delivery Issues"
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

    label:       "# Orders Post-Delivery Issues"
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


  # >>> PRE + POST Order Issues  :: START

  measure: count_perished_light {
    label: "# Orders Perished Light"
    description: "The number of orders, that had issues with perished light products and were claimed through the Customer Service.
                  Not counted in # Post Delivery Issues nor # Delivery Issues"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_perished_light_issues_dim: ">0"]
  }

  measure: cnt_perished_products_post {

    label:       "# Orders Perished Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with perished products and were claimed through the Customer Service"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_perished_issues_post_dim: ">0"]

    value_format_name: decimal_0

  }
  measure: cnt_perished_products_pre {

    label:       "# Orders Perished Products (Pre Delivery Issues)"
    description: "The number of orders, that had issues with perished products and were identified in the picking process (Swipe) "
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_perished_issues_pre_dim: ">0"]

    value_format_name: decimal_0

  }


  measure: cnt_products_not_on_shelf_post {

    label:       "# Orders Products not on shelf (Post Delivery Issues)"
    description: "The number of orders, that had issues with products not being in stock and were claimed through the Customer Service"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_products_not_on_shelf_issues_post_dim: ">0"]

    value_format_name: decimal_0

  }
  measure: cnt_products_not_on_shelf_pre {

    label:       "# Orders Products not on shelf (Pre Delivery Issues)"
    description: "The number of orders, that had issues with products not being in stock and were identified in the picking process (Swipe)"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_products_not_on_shelf_issues_pre_dim: ">0"]

    value_format_name: decimal_0

  }


  measure: cnt_damaged_products_post {
    label: "# Orders Damaged Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with damaged products and were claimed through the Customer Service"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_damaged_products_issues_post_dim: ">0"]

    value_format_name: decimal_0

  }
  measure: cnt_damaged_products_pre {
    label: "# Orders Damaged Products (Pre Delivery Issues)"
    description: "The number of orders, that had issues with damaged products and were identified in the picking process (Swipe)"
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_damaged_products_issues_pre_dim: ">0"]

    value_format_name: decimal_0

  }
  # >>> PRE + POST Order Issues  :: END



  # >>> POST Order Issues  :: START
  measure: cnt_missing_products {

    label:       "# Orders Missing Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with missing products"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_missing_products_issues_dim: ">0"]

    value_format_name: decimal_0

  }

  measure: cnt_wrong_products {

    label:       "# Orders Wrong Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with wrong products"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_wrong_products_issues_dim: ">0"]

    value_format_name: decimal_0

  }

  measure: cnt_swapped_products {

    label:       "# Orders Swapped Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with swapped products"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_swapped_products_issues_dim: ">0"]

    value_format_name: decimal_0

  }

  measure: cnt_cancelled_products {

    # This metric is not part of the issue rates, as the customer vóluntary cancelled a product.
    label:       "# Orders Cancelled Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with cancelled products"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_cancelled_products_issues_dim: ">0"]

    value_format_name: decimal_0

  }

  measure: cnt_products_item_description_issues {

    label:       "# Orders Products Issue Item Description (Post Delivery Issues)"
    description: "The number of orders, that had issues related to item descriptions"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_item_description_issues_dim: ">0"]

    value_format_name: decimal_0

  }

  measure: cnt_products_bad_quality_issues {

    label:       "# Orders Products Issue Item Quality (Post Delivery Issues)"
    description: "The number of orders, that had issues related to item quality"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_item_quality_issues_dim: ">0"]

    value_format_name: decimal_0

  }

  measure: cnt_undefined_issues {

    label:       "# Orders Unknown Issues (Post Delivery Issues)"
    description: "The number of orders, that had issues with unknown issue groups (see Return Reason to check the specific issue reasons)"
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_undefined_issues_dim: ">0"]

    value_format_name: decimal_0
    hidden: no

  }
  # >>> POST Order Issues  :: END


  # ~~~~~~~~~~~~    END Issue Reasons - Granular Metrics   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~  START Percentages   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: pct_pre_order_issue_rate_per_total_orders {

    label:       "% Orders Partial Fulfillment (preoder)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had pre-delivery issues"

    type: number
    sql:  ${cnt_pre_delivery_issues} / nullif(${cnt_total_orders} ,0);;

    value_format_name: percent_2

  }

  measure: pct_post_order_issue_rate_per_total_orders {

    label:       "% Orders Issue (post order)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had post-delivery issues"

    type: number
    sql:  ${cnt_post_delivery_issues} / nullif(${cnt_total_orders} ,0);;

    value_format_name: percent_2

  }

  measure: pct_hub_related_post_order_issue_rate_per_total_orders {

    label:       "% Orders Issue (post order hub related)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders that had hub related post-delivery issues
    (Missing Product, Wrong Product, Damaged, Perished, Swapped)"

    type: number
    sql:  (${cnt_damaged_products_post}+
          ${cnt_perished_products_post}+
          ${cnt_missing_products}+
          ${cnt_swapped_products}+
          ${cnt_wrong_products})/ nullif(${cnt_total_orders} ,0);;

    value_format_name: percent_2

  }

  measure: pct_pre_order_issue_rate_per_total_items_picked {

    label:       "% Orders Item Unfulfilled (preorder)"
    group_label: "> Delivery Issues"
    description: "The percentage of unique SKUs per order, that had pre-delivery issues"

    type: number
    sql:  ${cnt_pre_delivery_issues} / nullif(${cnt_total_picks} ,0);;

    value_format_name: percent_2

  }

  measure: pct_pre_order_fulfillment_rate {

    label:       "% Orders Pre-Order Fulfillment"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had no pre-delivery issues"

    type: number
    sql: 1 - ${pct_pre_order_issue_rate_per_total_orders} ;;

    value_format_name: percent_2

  }


  # >>>


  measure: pct_not_on_shelf_issue_rate {

    label:       "% Orders Goods Not On Shelf Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: (${cnt_products_not_on_shelf_pre} + ${cnt_products_not_on_shelf_post}) / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_missing_product_issue_rate {

    label:       "% Orders Missing Product Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_missing_products} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_damaged_product_issue_rate {

    label:       "% Orders Damaged Product Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: (${cnt_damaged_products_pre} + ${cnt_damaged_products_post}) / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_cancelled_product_issue_rate {

    label:       "% Orders Cancelled Product Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_cancelled_products} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_perished_product_issue_rate {

    label:       "% Orders Perished Product Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: (${cnt_perished_products_pre} + ${cnt_perished_products_post}) / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_wrong_product_issue_rate {

    label:       "% Orders Wrong Product Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_wrong_products} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_swapped_product_issue_rate {

    label:       "% Orders Swapped Product Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_swapped_products} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_products_item_description_issues {

    label:       "% Orders Item Description Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_products_item_description_issues} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_products_bad_quality_issues {

    label:       "% Orders Item Quality Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: ${cnt_products_bad_quality_issues} / nullif( ${cnt_total_orders} ,0 ) ;;

    value_format_name: percent_2

  }

  # ~~~~~~~ Perished Light
  measure: pct_orders_perished_light {

    label: "% Orders Perished Light Issue"
    group_label: "> Delivery Issues"

    type: number
    sql: ${count_perished_light} / nullif(${cnt_total_orders},0) ;;

    value_format_name: percent_2
  }



  # ~~~~~~~~~~~~  END Percentages   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



}
