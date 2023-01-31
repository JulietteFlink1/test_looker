include: "/**/*.view"
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
      number_of_products_with_goodwill_issues_dim,
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
      number_of_products_with_undefined_issues_dim,
      external_provider,
      is_not_on_shelf_issue_external,
      number_of_unique_orders_with_products_not_on_shelf_issue_pre_external,
      number_of_unique_orders_with_perished_products_issues_pre_external,
      number_of_unique_orders_with_damaged_products_pre_external,
      number_of_unique_orders_with_products_having_undefined_issues_pre_external,
      number_of_orders_with_pre_delivery_issues_external,
      pct_pre_order_issue_rate_per_total_orders_external,
      pct_pre_order_issue_rate_per_total_items_picked_external,
      pct_pre_order_fulfillment_rate_external,
      pct_not_on_shelf_issue_rate_external,
      qualifies_for_post_delivery_issues
    ]
  }

  #Non external orders (regular flink + click & collect/in store payments)
  #     -> covered by 'not is_external_order'
  #Doordash orders
  #     -> covered by 'is_external_order and is_last_mile_order'
  dimension: qualifies_for_post_delivery_issues {
    type: yesno
    hidden: yes
    label: "Can Have Post Delivery Issues"
    description: "True if an order can have post delivery issue. This includes all regular Flink orders,
    Click & Collect, and Doordash orders. Those that do not qualify for post-delivery issues are Wolt, UE
    and Carrefour orders."
    sql: (${is_external_order} and ${is_last_mile_order})
    or not ${is_external_order} ;;
  }


  measure: number_of_unique_orders {
    alias: [cnt_total_orders]
    type: count_distinct
    sql: ${order_uuid};;
    hidden: yes
    group_label: "> Delivery Issues"
  }

  measure: number_of_unique_orders_that_qualify_for_post_issues {
    alias: [cnt_total_orders_not_crf]
    type: count_distinct
    sql: ${order_uuid};;
    hidden: yes
    group_label: "> Delivery Issues"
    filters: [qualifies_for_post_delivery_issues: "yes"]
  }

  measure: number_of_unique_orders_that_do_not_qualify_for_post_issues {
    alias: [cnt_total_orders_crf]
    type: count_distinct
    sql: ${order_uuid};;
    hidden: yes
    group_label: "> Delivery Issues External"
    filters: [qualifies_for_post_delivery_issues: "no"]
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

  measure: number_of_unique_lineitems_order_qualifies_for_post_issues {
    alias: [cnt_total_picks_not_crf]
    type: count_distinct
    sql: ${order_lineitem_uuid} ;;
    hidden: yes
    group_label: "> Delivery Issues"
    filters: [qualifies_for_post_delivery_issues: "yes"]
  }

  measure: number_of_unique_lineitems_order_does_not_qualify_for_post_issues {
    alias: [cnt_total_picks_crf]
    type: count_distinct
    sql: ${order_lineitem_uuid} ;;
    hidden: yes
    group_label: "> Delivery Issues External"
    filters: [qualifies_for_post_delivery_issues: "no"]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~  START Issue Reasons - BASE   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: return_reason {
    type: string
    label: "Return Reason"
    group_label: "> Delivery Issues"
    description: "The reason an order-lineitem was returned, as shown in Commercetools."
    sql: lower(${TABLE}.return_reason) ;;
  }

  measure: number_of_orders_with_delivery_issues {
    alias: [cnt_delivery_issues]
    label: "# Orders Delivery Issues (Post- + Pre-Delivery)"
    description: "# Orders with delivery issues (Pre + Post), excludes External orders that do not qualify
    for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"
    type: number
    sql:
          ${number_of_unique_orders_with_product_not_on_shelf_issues_pre}  +
          ${number_of_unique_orders_with_damaged_products_pre}             +
          ${number_of_unique_orders_with_perished_products_issues_pre}     +

          ${number_of_unique_orders_with_products_not_on_shelf_issue_post}             +
          ${number_of_unique_orders_with_damaged_products_issue_post}                  +
          ${number_of_unique_orders_with_perished_products_issue_post}                 +
          ${number_of_unique_orders_with_missing_product_issue_post}                   +
          ${number_of_unique_orders_with_swapped_products_issue_post}                  +
          ${number_of_unique_orders_with_products_having_item_description_issue_post}  +
          ${number_of_unique_orders_with_products_having_bad_quality_issue_post}       +
          ${number_of_unique_orders_with_wrong_product_issues_post}                    +
          ${number_of_unique_orders_with_products_having_undefined_issues_post}
      ;;
  }

  measure: number_of_orders_with_pre_delivery_issues {
    alias: [cnt_pre_delivery_issues]

    label:       "# Orders Pre-Delivery Issues"
    description: "# Orders with Pre delivery issues, excludes External orders that do not qualify
    for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: ${number_of_unique_orders_with_product_not_on_shelf_issues_pre} +
         ${number_of_unique_orders_with_damaged_products_pre}            +
         ${number_of_unique_orders_with_perished_products_issues_pre}
    ;;

    value_format_name: decimal_0

  }

  measure: number_of_orders_with_post_delivery_issues {
    alias: [cnt_post_delivery_issues]

    label:       "# Orders Post-Delivery Issues"
    description: "# Orders with Post delivery issues, excludes External orders that do not qualify
    for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql:  ${number_of_unique_orders_with_products_not_on_shelf_issue_post}       +
          ${number_of_unique_orders_with_damaged_products_issue_post}            +
          ${number_of_unique_orders_with_perished_products_issue_post}           +
          ${number_of_unique_orders_with_missing_product_issue_post}                   +
          ${number_of_unique_orders_with_swapped_products_issue_post}                  +
          ${number_of_unique_orders_with_products_having_item_description_issue_post}  +
          ${number_of_unique_orders_with_products_having_bad_quality_issue_post}       +
          ${number_of_unique_orders_with_wrong_product_issues_post}                    +
          ${number_of_unique_orders_with_products_having_undefined_issues_post}
        ;;

    value_format_name: decimal_0

  }

  # ~~~~~~~~~~~~  END Issue Reasons - BASE   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~  START Issue Reasons - Granular Metrics   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # >>> PRE + POST Order Issues  :: START

  measure: number_of_unique_orders_with_perished_light_issues_post {
    alias: [count_perished_light]

    label: "# Orders Perished Light"
    description: "The number of orders, that had issues with perished light products and were claimed through the Customer Service.
    Not counted in # Post Delivery Issues nor # Delivery Issues, excludes External orders that do not qualify
    for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_perished_light_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]
  }

  measure: number_of_unique_orders_with_goodwill_issues_post {
    alias: [count_goodwill]

    label: "# Orders Goodwill"
    description: "The number of orders, that had issues with products refunded out of goodwill.
    These occur when we refund a product that is still ok/that the hub confirmed they packed,
    because the request comes from a 'good' customer, and we do not have proof.
    The customer is then flagged so that such cases do not re-occur.
    Not counted in # Post Delivery Issues nor # Delivery Issues, excludes External orders that do not qualify
    for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_goodwill_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]
  }

  measure: number_of_unique_orders_with_perished_products_issue_post {
    alias: [cnt_perished_products_post]

    label:       "# Orders Perished Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with perished products and were claimed through the Customer Service.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_perished_issues_post_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0

  }

  measure: number_of_unique_orders_with_perished_products_issues_pre {
    alias: [cnt_perished_products_pre]

    label:       "# Orders Perished Products (Pre Delivery Issues)"
    description: "The number of orders, that had issues with perished products and were identified in the picking process (Swipe).
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour. "
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_perished_issues_pre_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0
  }

  measure: number_of_unique_orders_with_products_not_on_shelf_issue_post {
    alias: [cnt_products_not_on_shelf_post]

    label:       "# Orders Products not on shelf (Post Delivery Issues)"
    description: "The number of orders, that had issues with products not being in stock and were claimed through the Customer Service.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_products_not_on_shelf_issues_post_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0
  }

  measure: number_of_unique_orders_with_product_not_on_shelf_issues_pre  {
    alias: [cnt_products_not_on_shelf_pre]

    label:       "# Orders Products not on shelf (Pre Delivery Issues)"
    description: "The number of orders, that had issues with products not being in stock and were identified in the picking process (Swipe).
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_products_not_on_shelf_issues_pre_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0

  }

  measure: number_of_unique_orders_with_damaged_products_issue_post {
    alias: [cnt_damaged_products_post]

    label: "# Orders Damaged Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with damaged products and were claimed through the Customer Service.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_damaged_products_issues_post_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0

  }
  measure: number_of_unique_orders_with_damaged_products_pre {
    alias: [cnt_damaged_products_pre]

    label: "# Orders Damaged Products (Pre Delivery Issues)"
    description: "The number of orders, that had issues with damaged products and were identified in the picking process (Swipe).
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_damaged_products_issues_pre_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0

  }
  # >>> PRE + POST Order Issues  :: END



  # >>> POST Order Issues  :: START
  measure: number_of_unique_orders_with_missing_product_issue_post {
    alias: [cnt_missing_products]

    label:       "# Orders Missing Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with missing products.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_missing_products_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0

  }

  measure: number_of_unique_orders_with_wrong_product_issues_post {
    alias: [cnt_wrong_products]

    label:       "# Orders Wrong Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with wrong products.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_wrong_products_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0

  }

  measure: number_of_unique_orders_with_swapped_products_issue_post {
    alias: [cnt_swapped_products]

    label:       "# Orders Swapped Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with swapped products.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_swapped_products_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0

  }

  measure: number_of_unique_orders_with_cancelled_product_issues_post {
    alias: [cnt_cancelled_products]

    # This metric is not part of the issue rates, as the customer vóluntary cancelled a product.
    label:       "# Orders Cancelled Products (Post Delivery Issues)"
    description: "The number of orders, that had issues with cancelled products.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_cancelled_products_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0
  }

  measure: number_of_unique_orders_with_products_having_item_description_issue_post {
    alias: [cnt_products_item_description_issues]

    label:       "# Orders Products Issue Item Description (Post Delivery Issues)"
    description: "The number of orders, that had issues related to item descriptions.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_item_description_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0

  }

  measure: number_of_unique_orders_with_products_having_bad_quality_issue_post {
    alias: [cnt_products_bad_quality_issues]

    label:       "# Orders Products Issue Item Quality (Post Delivery Issues)"
    description: "The number of orders, that had issues related to item quality.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_item_quality_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0

  }

  measure: number_of_unique_orders_with_products_having_undefined_issues_post {
    alias: [cnt_undefined_issues]

    label:       "# Orders Unknown Issues (Post Delivery Issues)"
    description: "The number of orders, that had issues that could not be mapped to known issue groups (see Return Reason to check the specific issue reason).
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_undefined_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "yes"]

    value_format_name: decimal_0
    hidden: no

  }
  # >>> POST Order Issues  :: END

  ### ORDERS THAT DO NOT QUALIFY FOR POST DELIVERY ISSUES ###

  measure: number_of_unique_orders_with_product_not_on_shelf_issues_pre_external {
    alias: [cnt_product_not_on_shelf_pre_crf]

    label:       "# External Orders Products Not On Shelf (Pre Delivery Issues)"
    description: "The number of external orders, that had issues with product not on shelf issue (Pre)"
    group_label: "> Delivery Issues External"
    hidden:  yes

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_products_not_on_shelf_issues_pre_dim: ">0" ,
      qualifies_for_post_delivery_issues: "no"]

    value_format_name: decimal_0

  }

  measure: number_of_unique_orders_with_products_not_on_shelf_issue_post_external {
    alias: [cnt_product_not_on_shelf_post_crf]

    label:       "# External Orders Products Not On Shelf (Post Delivery Issues)"
    description: "The number of external orders, that had issues with product not on shelf issue (Post)"
    group_label: "> Delivery Issues External"
    hidden:  yes

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_products_not_on_shelf_issues_post_dim: ">0" ,
      qualifies_for_post_delivery_issues: "no"]

    value_format_name: decimal_0

  }

  dimension: is_not_on_shelf_issue_external {
    alias: [is_not_on_shelf_issue_crf]
    type: yesno
    hidden:  yes
    sql: ${number_of_products_with_products_not_on_shelf_issues_post_dim} > 0 OR
      ${number_of_products_with_products_not_on_shelf_issues_pre_dim} > 0;;
  }

  measure: number_of_unique_orders_with_products_not_on_shelf_issue_pre_external {
    alias: [count_products_not_on_shelf_issues_carrefour]

    label:       "# External Orders Products Not On Shelf (Pre Delivery Issues)"
    description: "The number of external orders, that had issues with product not on shelf issue"
    group_label: "> Delivery Issues External"

    type: count_distinct
    sql: ${order_uuid}  ;;
    filters: [is_not_on_shelf_issue_external: "yes" ,
      qualifies_for_post_delivery_issues: "no"]

    value_format_name: decimal_0

  }

  measure: number_of_unique_orders_with_perished_products_issues_pre_external {
    alias: [cnt_perished_products_pre_crf]

    label:       "# External Orders Perished Products (Pre Delivery Issues)"
    description: "The number of external orders, that had issues with perished products and were identified in the picking process (Swipe) "
    group_label: "> Delivery Issues External"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_perished_issues_pre_dim: ">0",
      qualifies_for_post_delivery_issues: "no"]

    value_format_name: decimal_0
  }

  measure: number_of_unique_orders_with_damaged_products_pre_external {
    alias: [cnt_damaged_products_pre_crf]

    label: "# External Orders Damaged Products (Pre Delivery Issues)"
    description: "The number of external orders, that had issues with damaged products and were identified in the picking process (Swipe)"
    group_label: "> Delivery Issues External"
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_damaged_products_issues_pre_dim: ">0",
      qualifies_for_post_delivery_issues: "no"]

    value_format_name: decimal_0
  }

  measure: number_of_unique_orders_with_products_having_undefined_issues_pre_external {
    alias: [cnt_undefined_issues_crf]

    label:       "# External Orders Unknown Issues (Pre Delivery Issues)"
    description: "The number of external orders, that had issues with unknown issue groups (see Return Reason to check the specific issue reasons)"
    group_label: "> Delivery Issues External"

    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [number_of_products_with_undefined_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "no"]

    value_format_name: decimal_0
    hidden: no
  }

  measure: number_of_unique_orders_with_post_delivery_issues_external {
    alias: [cnt_post_delivery_issues_crf]

    label:       "# External Orders Post-Delivery Issues"
    description: "# External Orders with Issues, that are detected post-delivery. Should not happen as customer
    should not be able to reach our customer support."
    group_label: "> Delivery Issues External"

    type: count_distinct
    sql: ${order_uuid};;
    filters: [number_of_products_with_post_delivery_issues_dim: ">0",
      qualifies_for_post_delivery_issues: "no"]
  }

  #here include undefined issues as they must be pre order issue
  measure: number_of_orders_with_pre_delivery_issues_external {
    alias: [cnt_pre_delivery_issues_crf]

    label:       "# External Orders Pre-Delivery Issues"
    description: "# External Orders with Issues, that are detected pre-delivery."
    group_label: "> Delivery Issues External"

    type: number
    sql: ${number_of_unique_orders_with_products_not_on_shelf_issue_pre_external}    +
           ${number_of_unique_orders_with_perished_products_issues_pre_external} +
           ${number_of_unique_orders_with_damaged_products_pre_external}         +
           ${number_of_unique_orders_with_products_having_undefined_issues_pre_external}
      ;;
  }

  measure: pct_pre_order_issue_rate_per_total_orders_external {
    alias: [pct_pre_order_issue_rate_per_total_orders_crf]

    label:       "% External Orders Partial Fulfillment (preoder)"
    group_label: "> Delivery Issues External"
    description: "The percentage of external orders, that had pre-delivery issues"

    type: number
    sql:  ${number_of_orders_with_pre_delivery_issues_external}
            / nullif(${number_of_unique_orders_that_do_not_qualify_for_post_issues} ,0);;

    value_format_name: percent_2

  }

  measure: pct_pre_order_issue_rate_per_total_items_picked_external {
    alias: [pct_pre_order_issue_rate_per_total_items_picked_crf]

    label:       "% External Orders Item Unfulfilled (preorder)"
    group_label: "> Delivery Issues External"
    description: "The percentage of unique SKUs per external order, that had pre-delivery issues."

    type: number
    sql:  ${number_of_orders_with_pre_delivery_issues_external}
            / nullif(${number_of_unique_lineitems_order_does_not_qualify_for_post_issues} ,0);;

    value_format_name: percent_2

  }

  measure: pct_pre_order_fulfillment_rate_external {
    alias: [pct_pre_order_fulfillment_rate_crf]

    label:       "% External Orders Pre-Order Fulfillment"
    group_label: "> Delivery Issues External"
    description: "The percentage of external orders, that had no pre-delivery issues."

    type: number
    sql: 1 - ${pct_pre_order_issue_rate_per_total_orders_external} ;;

    value_format_name: percent_2

  }

  measure: pct_not_on_shelf_issue_rate_external {
    alias: [pct_not_on_shelf_issue_rate_crf]

    label:       "% External Orders Goods Not On Shelf Issue"
    group_label: "> Delivery Issues External"
    description: "% External orders with products not on shelf issues."

    type: number
    sql: (${number_of_unique_orders_with_products_not_on_shelf_issue_pre_external})
            / nullif( ${number_of_unique_orders_that_do_not_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  ## END CARREFOUR ##

  # ~~~~~~~~~~~~    END Issue Reasons - Granular Metrics   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~  START Percentages   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: pct_pre_order_issue_rate_per_total_orders {

    label:       "% Orders Partial Fulfillment (preoder)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had pre-delivery issues.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."

    type: number
    sql:  ${number_of_orders_with_pre_delivery_issues}
            / nullif(${number_of_unique_orders_that_qualify_for_post_issues} ,0);;

    value_format_name: percent_2

  }

  measure: pct_post_order_issue_rate_per_total_orders {

    label:       "% Orders Issue (post order)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders, that had post-delivery issues.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."

    type: number
    sql:  ${number_of_orders_with_post_delivery_issues}
            / nullif(${number_of_unique_orders_that_qualify_for_post_issues} ,0);;

    value_format_name: percent_2

  }

  measure: pct_hub_related_post_order_issue_rate_per_total_orders {

    label:       "% Orders Issue (post order hub related)"
    group_label: "> Delivery Issues"
    description: "The percentage of orders that had hub related post-delivery issues
    (Missing Product, Wrong Product, Damaged, Perished, Swapped).
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."

    type: number
    sql:  (${number_of_unique_orders_with_damaged_products_issue_post} +
          ${number_of_unique_orders_with_perished_products_issue_post} +
          ${number_of_unique_orders_with_missing_product_issue_post}   +
          ${number_of_unique_orders_with_swapped_products_issue_post}  +
          ${number_of_unique_orders_with_wrong_product_issues_post})
                / nullif(${number_of_unique_orders_that_qualify_for_post_issues} ,0);;

    value_format_name: percent_2

  }

  measure: pct_pre_order_issue_rate_per_total_items_picked {

    label:       "% Orders Item Unfulfilled (preorder)"
    description: "The percentage of unique SKUs per order, that had pre-delivery issues.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql:  ${number_of_orders_with_pre_delivery_issues}
            / nullif(${number_of_unique_lineitems_order_qualifies_for_post_issues} ,0);;

    value_format_name: percent_2

  }


  measure: pct_pre_order_fulfillment_rate {

    label:       "% Orders Pre-Order Fulfillment"
    description: "The percentage of orders, that had no pre-delivery issues.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: 1 - ${pct_pre_order_issue_rate_per_total_orders} ;;

    value_format_name: percent_2

  }

  # >>>


  measure: pct_not_on_shelf_issue_rate {

    label:       "% Orders Goods Not On Shelf Issue"
    description: "The percentage of orders that had issues with Goods Not On Shelf, either Pre or Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: (${number_of_unique_orders_with_product_not_on_shelf_issues_pre} + ${number_of_unique_orders_with_products_not_on_shelf_issue_post})
            / nullif( ${number_of_unique_orders_that_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_missing_product_issue_rate {

    label:       "% Orders Missing Product Issue"
    description: "The percentage of orders that had issues with Missing Products, Post Delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: ${number_of_unique_orders_with_missing_product_issue_post}
            / nullif( ${number_of_unique_orders_that_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_damaged_product_issue_rate {

    label:       "% Orders Damaged Product Issue"
    description: "The percentage of orders that had issues with Damaged Products, either Pre or Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: (${number_of_unique_orders_with_damaged_products_pre} + ${number_of_unique_orders_with_damaged_products_issue_post})
            / nullif( ${number_of_unique_orders_that_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_cancelled_product_issue_rate {

    label:       "% Orders Cancelled Product Issue"
    description: "The percentage of orders that had issues with Cancelled Products, Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: ${number_of_unique_orders_with_cancelled_product_issues_post}
            / nullif( ${number_of_unique_orders_that_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_perished_product_issue_rate {

    label:       "% Orders Perished Product Issue"
    description: "The percentage of orders that had issues with Cancelled Products, either Pre or Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: (${number_of_unique_orders_with_perished_products_issues_pre} + ${number_of_unique_orders_with_perished_products_issue_post})
            / nullif( ${number_of_unique_orders_that_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_wrong_product_issue_rate {

    label:       "% Orders Wrong Product Issue"
    description: "The percentage of orders that had issues with Wrong Products, Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: ${number_of_unique_orders_with_wrong_product_issues_post}
            / nullif( ${number_of_unique_orders_that_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_swapped_product_issue_rate {

    label:       "% Orders Swapped Product Issue"
    description: "The percentage of orders that had issues with Swapped Products, Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: ${number_of_unique_orders_with_swapped_products_issue_post}
            / nullif( ${number_of_unique_orders_that_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_products_item_description_issues {

    label:       "% Orders Item Description Issue"
    description: "The percentage of orders that had issues with the Item Descriptions, Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: ${number_of_unique_orders_with_products_having_item_description_issue_post}
            / nullif( ${number_of_unique_orders_that_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  measure: pct_products_bad_quality_issues {

    label:       "% Orders Item Quality Issue"
    description: "The percentage of orders that had issues due to the Item Quality, Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: ${number_of_unique_orders_with_products_having_bad_quality_issue_post}
            / nullif( ${number_of_unique_orders_that_qualify_for_post_issues} ,0 ) ;;

    value_format_name: percent_2

  }

  # ~~~~~~~ Perished Light & Goodwill
  measure: pct_orders_perished_light {

    label: "% Orders Perished Light Issue"
    description: "The percentage of orders that had issues with Perished Light Products, Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: ${number_of_unique_orders_with_perished_light_issues_post}
            / nullif(${number_of_unique_orders_that_qualify_for_post_issues},0) ;;

    value_format_name: percent_2
  }

  measure: pct_orders_goodwill {

    label: "% Orders Goodwill Issue"
    description: "The percentage of orders that had issues with products refunded out of goodwill, Post delivery.
    Excludes External orders that do not qualify for post-delivery issues: Wolt, UE, Carrefour."
    group_label: "> Delivery Issues"

    type: number
    sql: ${number_of_unique_orders_with_goodwill_issues_post}
            / nullif(${number_of_unique_orders_that_qualify_for_post_issues},0) ;;

    value_format_name: percent_2
  }



  # ~~~~~~~~~~~~  END Percentages   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



}
