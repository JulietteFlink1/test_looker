# Owner: Galina Larina
# Created: 2022-11-25

# This view contains aggregated data on a product sku and product placements levels


view: product_placement_performance_aggregates {
  sql_table_name: `flink-data-prod.reporting.product_placement_performance_aggregates`;;
  view_label: "Product Placement Performance Aggregates"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Sets    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  set: dimensions {
    fields: [
      product_placement_aggr_uuid,
      country_iso,
      hub_code,
      platform
    ]
  }

  set: product_dimensions {
    fields: [
      product_placement,
      screen_name,
      category_name,
      subcategory_name,
      pdp_origin,
      product_sku
    ]
  }

  set: flags {
    fields: [
      is_exposed_to_impressions,
      is_discount_applied
    ]
  }

  set: user_measures {
    fields: [
      count_of_distinct_users_with_product_impression,
      count_of_distinct_users_with_product_added_to_cart,
      count_of_distinct_users_with_product_removed_from_cart,
      count_of_distinct_users_with_pdp_viewed,
      count_of_distinct_users_with_order_placed
    ]
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= Dimensions ======= #

  dimension: product_placement_aggr_uuid {
    group_label: "Dimensions"
    label: "Event UUID"
    type: string
    primary_key: yes
    hidden: yes
    description: "A unique identifier of an product sku for each product placement."
    sql: ${TABLE}.product_placement_aggr_uuid ;;
  }

  dimension: country_iso {
    group_label: "Dimensions"
    label: "Country ISO"
    type: string
    hidden: no
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    label: "Hub Code"
    group_label: "Dimensions"
    type: string
    hidden: no
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: platform {
    label: "Platform"
    group_label: "Dimensions"
    type: string
    hidden: no
    description: "Platform which user used, can be 'web', 'android' or 'ios'."
    sql: ${TABLE}.platform ;;
  }

  # ======= Product Dimensions ======= #

  dimension: product_placement {
    group_label: "Product Dimensions"
    label: "Product Placement"
    description: "Placement in the app where product was listed, i.e. search, pdp, category"
    type: string
    sql: case when ${TABLE}.product_placement in ('checkout','cart') then 'cart'
              else ${TABLE}.product_placement
              end;;
  }

  dimension: screen_name {
    group_label: "Product Dimensions"
    label: "Screen Name"
    description: "Name of the screen."
    type: string
    sql: ${TABLE}.screen_name ;;
  }

  dimension: category_name {
    group_label: "Product Dimensions"
    label: "Category Name"
    description: "For categories, the name of the category where the product was listed. For collections, the name of the collection. For other product placements, the highest level collection name (only where applicable)."
    type: string
    sql: ${TABLE}.category_name ;;
  }

  dimension: subcategory_name {
    group_label: "Product Dimensions"
    label: "Sub-Category Name"
    description: "For categories, the name of the sub-category where the product was listed. For collections, the name of the sub-collection. For other product placements, the granular sub-grouping (only where applicable)."
    type: string
    sql: ${TABLE}.subcategory_name ;;
  }

  dimension: pdp_origin {
    group_label: "Product Dimensions"
    label: "PDP Origin"
    description: "Product placement where the user clicked through to the Product Details Page"
    type: string
    sql: ${TABLE}.pdp_origin ;;
  }

  dimension: product_sku {
    group_label: "Product Dimensions"
    label: "Product SKU"
    description: "SKU of the product"
    type: string
    sql: ${TABLE}.product_sku ;;
  }


# ======= Flags ======= #

  dimension: is_exposed_to_impressions {
    group_label: "Flags"
    label: "Is Exposed To Impressions"
    type: yesno
    description: "If a user was exposed to product impressions in this placement"
    sql: ${TABLE}.is_exposed_to_impressions ;;
  }

  dimension: is_discount_applied {
    group_label: "Flags"
    label: "Is Discount Applied"
    type: yesno
    description: "If a discount was applied to a product"
    sql: ${TABLE}.is_discount_applied ;;
  }

  # =======  User Measures ======= #

  dimension: count_of_distinct_users_with_product_impression {
    group_label: "User Measures"
    label: "Count of users with product impression."
    type: number
    description: "Count of Distinct Users with Product Impression"
    sql: ${TABLE}.count_of_distinct_users_with_product_impression ;;
  }

  dimension: count_of_distinct_users_with_product_added_to_cart {
    group_label: "User Measures"
    label: "Count of users with product added to cart."
    type: number
    description: "Count of Distinct Users with Product Added to Cart"
    sql: ${TABLE}.count_of_distinct_users_with_product_added_to_cart ;;
  }

  dimension: count_of_distinct_users_with_product_removed_from_cart {
    group_label: "User Measures"
    label: "Count of users with product removed from cart."
    type: number
    description: "Count of Distinct Users with Product Removed from Cart"
    sql: ${TABLE}.count_of_distinct_users_with_product_removed_from_cart ;;
  }

  dimension: count_of_distinct_users_with_pdp_viewed {
    group_label: "User Measures"
    label: "Count of users with PDP viewed."
    type: number
    description: "Count of Distinct Users with Product Details Page Viewed"
    sql: ${TABLE}.count_of_distinct_users_with_pdp_viewed ;;
  }

  dimension: count_of_distinct_users_with_order_placed {
    group_label: "User Measures"
    label: "Count of users placed an order"
    type: number
    description: "Count of distinct users who placed an order with the product_sku and from that product_placements."
    sql: ${TABLE}.count_of_distinct_users_with_order_placed ;;
  }


  # =======  Date Timestamp ======= #

  dimension_group: event_date {
    group_label: "Date Timestamp"
    label: "Event Date"
    type: time
    timeframes: [
      date
    ]
    datatype: date
    sql: ${TABLE}.event_date ;;
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures    ~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  ######## * Numbers * ########

  measure: number_of_users_exposed_to_product{
    type: sum
    group_label: "* Numbers *"
    label: "Number of Users Exposed to Product"
    hidden:  no
    sql: ${count_of_distinct_users_with_product_impression} ;;
    filters: [is_exposed_to_impressions: "yes"]
  }

  measure: number_of_users_with_product_added_to_cart{
    type: sum
    group_label: "* Numbers *"
    label: "Number of Users Added Product to Cart"
    hidden:  no
    sql: ${count_of_distinct_users_with_product_added_to_cart} ;;
    filters: [is_exposed_to_impressions: "yes"]
  }

  measure: number_of_users_with_order_placed{
    type: sum
    group_label: "* Numbers *"
    label: "Number of Users Placed an Order"
    hidden:  no
    sql: ${count_of_distinct_users_with_order_placed} ;;
    filters: [is_exposed_to_impressions: "yes"]
  }

  ######## * Percentages * ########

  measure: pct_users_added_product_to_cart {
    group_label: "* Percentages *"
    label: "% Users Added Product to Cart"
    description: "# Users added product to cart divided by the total # users."
    type: number
    sql: (1.0 * ${number_of_users_with_product_added_to_cart}) / NULLIF(${number_of_users_exposed_to_product}, 0) ;;
    value_format_name: percent_1
  }

  measure: pct_users_placed_order {
    group_label: "* Percentages *"
    label: "% Users Placed an Order"
    description: "# Users who placed an order divided by the total # users."
    type: number
    sql: (1.0 * ${number_of_users_with_order_placed}) / NULLIF(${number_of_users_exposed_to_product}, 0) ;;
    value_format_name: percent_1
  }
}
