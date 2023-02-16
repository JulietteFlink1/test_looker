view: product_placement_performance {
  sql_table_name: `flink-data-prod.reporting.product_placement_performance` ;;
  view_label: "Product Placement Performance"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= Device Dimensions ======= #

  dimension: order_uuid {
    group_label: "Product Dimensions"
    label: "Order UUID"
    description: "Unique identifier for an order"
    type: string
    sql: ${TABLE}.order_uuid ;;
  }
  dimension: platform {
    group_label: "Device Dimensions"
    label: "Platform"
    description: "Platform of a device: app or web"
    type: string
    sql: ${TABLE}.platform ;;
  }
  dimension: device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "Type of the device used"
    type: string
    sql: ${TABLE}.device_type ;;
  }
 dimension: app_version {
    group_label: "Device Dimensions"
    label: "App Version"
    description: "Version of the app"
    type: string
    sql: ${TABLE}.app_version ;;
  }
  dimension: full_app_version {
    group_label: "Device Dimensions"
    type: string
    description: "Concatenation of device_type and app_version"
    sql: case when ${TABLE}.device_type in ('ios','android') then (${TABLE}.device_type || '-' || ${TABLE}.app_version ) end ;;
  }

  # ======= Location Dimension ======= #

  dimension: hub_code {
    group_label: "Location Dimensions"
    label: "Hub Code"
    description: "Hub Code"
    type: string
    hidden: yes
    sql: ${TABLE}.hub_code ;;
  }
  dimension: country_iso {
    group_label: "Location Dimensions"
    label: "Country ISO"
    description: "ISO country"
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  # ======= Product Dimensions =======

  dimension: product_sku {
    group_label: "Product Dimensions"
    label: "Product SKU"
    description: "SKU of the product"
    type: string
    sql: ${TABLE}.product_sku ;;
  }
  dimension: product_position {
    group_label: "Product Dimensions"
    label: "Product Position"
    description: "Position of a product within a swimlane / grid, start counting from 1 from top left corner."
    type: number
    sql: ${TABLE}.product_position ;;
  }
  dimension: product_price {
    group_label: "Product Dimensions"
    label: "Product Price"
    description: "Price of the product"
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.product_price ;;
  }
  dimension: swimlane_name {
    group_label: "Product Dimensions"
    label: "Swimlane Name"
    description: "Name of a swimlane where products were shown"
    type: string
    sql: case when ${TABLE}.product_placement in ('swimlane')
              then ${TABLE}.category_name
         else null
         end ;;
  }
  dimension: category_name {
    group_label: "Product Dimensions"
    label: "Category Name"
    description: "For categories, the name of the category where the product was listed. For collections, the name of the collection. For other product placements, the highest level collection name (only where applicable)."
    type: string
  }
  dimension: subcategory_name {
    group_label: "Product Dimensions"
    label: "Sub-Category Name"
    description: "For categories, the name of the sub-category where the product was listed. For collections, the name of the sub-collection. For other product placements, the granular sub-grouping (only where applicable)."
    type: string
  }
  dimension: product_placement {
    group_label: "Product Dimensions"
    label: "Product Placement"
    description: "Placement in the app where product was listed, e.i. search, pdp, category"
    type: string
    sql: case when ${TABLE}.product_placement in ('checkout','cart') then 'cart'
              else ${TABLE}.product_placement
              end;;
  }
  dimension: pdp_origin {
    group_label: "Product Dimensions"
    label: "PDP Origin"
    description: "From where (which product placement in the app) PDP came"
    type: string
    sql: ${TABLE}.pdp_origin ;;
  }
  dimension: screen_name {
    group_label: "Product Dimensions"
    label: "Screen Name"
    description: "Name of the screen."
    type: string
    sql: ${TABLE}.screen_name ;;
  }

  dimension: is_product_out_of_stock {
    group_label: "Product Dimensions"
    label: "Is Product OoS"
    description: "Boolean whether a product was Out-of-Stock on an impression (when users saw the product)"
    type: yesno
    sql: ${TABLE}.is_product_out_of_stock ;;
  }

  # ======= Dates / Timestamps =======

  dimension_group: event {
    group_label: "Date Dimensions"
    label: "Event"
    description: "Timestamp of when an event happened"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.event_date ;;
    datatype: date
  }

    # ======= Event Flags ======= #

  dimension: is_product_impression {
    group_label: "Event Flags"
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_product_impression ;;
  }

  dimension: is_product_add_to_cart {
    group_label: "Event Flags"
    type: yesno
    sql: ${TABLE}.is_product_add_to_cart ;;
  }

  dimension: is_product_removed_from_cart {
    group_label: "Event Flags"
    type: yesno
    sql: ${TABLE}.is_product_removed_from_cart ;;
  }

  dimension: is_pdp_viewed {
    group_label: "Event Flags"
    type: yesno
    sql: ${TABLE}.is_pdp_viewed ;;
  }

  dimension: is_added_to_favourites {
    group_label: "Event Flags"
    type: yesno
    sql: ${TABLE}.is_product_added_to_favourites ;;
  }

  dimension: is_order_placed {
    group_label: "Event Flags"
    type: yesno
    sql: ${TABLE}.is_order_placed ;;
  }

  dimension: is_context_available {
    group_label: "Event Flags"
    label: "Is Context Available"
    description: "If the backend product context was available for a product impression event. The Out of Stock rate depends on this context"
    type: yesno
    sql: ${TABLE}.is_context_available;;
  }

  # ======= HIDDEN Dimension ======= #

  dimension: product_placement_uuid {
    hidden: yes
    primary_key: yes
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    type: string
    sql: ${TABLE}.product_placement_uuid ;;
  }

  dimension: anonymous_id {
    hidden: yes
    group_label: "IDs"
    label: "Anonymous Id"
    description: "User ID set by Segment"
    type: string
    sql: ${TABLE}.anonymous_id ;;
    }

  dimension: is_pdp_or_atc {
    hidden: yes
    group_label: "Event Flags"
    type: yesno
    sql: coalesce(${TABLE}.is_product_add_to_cart, ${TABLE}.is_pdp_viewed) ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures      ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: products {
    group_label: "Product Metrics"
    label: "# Unique Products"
    description: "Number of unique products added to cart"
    type: count_distinct
    sql: ${TABLE}.product_sku ;;
  }
  measure: out_of_stock_products {
    group_label: "Product Metrics"
    label: "# OoS Products (Unique)"
    description: "Unique number of products which were out of stock when saw by users (on an impression level)"
    type: count_distinct
    sql: ${TABLE}.product_sku ;;
    filters: [is_product_out_of_stock: "yes"]
  }
  measure: out_of_stock_products_total {
    group_label: "Product Metrics"
    label: "# OoS Products (Total)"
    description: "Total number of products which were out of stock when saw by users (on an impression level)"
    type: count
    filters: [is_product_out_of_stock: "yes"]
  }
  measure: orders {
    group_label: "Product Metrics"
    label: "# Orders "
    description: "Number of unique orders based on order_uuid"
    type: count_distinct
    sql: ${TABLE}.order_uuid ;;
  }
  measure: ordered_products { ## name should not be changed as charts would break
    group_label: "Product Metrics"
    label: "# Orders with the product added from the placement"
    description: "Number of unique products placed - if the quantity ordered is higher than one, this metric will still only be one."
    type: count_distinct
    sql: ${product_placement_uuid} ;;
    filters: [is_order_placed: "yes"]
  }
  measure: amt_total_price_net {
    hidden: no
    group_label: "Product Metrics"
    label: "SUM Item Prices Sold (net)"
    description: "Sum of all items sold, net value."
    type: sum
    value_format_name: decimal_2
    sql: ${TABLE}.product_price ;;
    filters: [is_order_placed: "yes"]
  }

  # ======= Product Event Level Measures =======

  measure: impressions {
    group_label: "Product Metrics"
    label: "# Impressions"
    description: "Number of unique impressions per product"
    type: sum
    sql: ${TABLE}.number_of_product_impressions ;;
  }
  measure: add_to_carts {
    group_label: "Product Metrics"
    label: "# Products Added to Cart"
    description: "Number of unique products added to cart"
    type: sum
    sql: ${TABLE}.number_of_product_add_to_carts ;;
  }
  measure: removed_from_carts {
    group_label: "Product Metrics"
    label: "# Products Removed from Cart"
    description: "Number of unique products removed from cart"
    type: sum
    sql: ${TABLE}.number_of_product_removed_from_carts ;;
  }
  measure: pdps {
    group_label: "Product Metrics"
    label: "# PDPs"
    description: "Number of PDPs (product details viewed) per product"
    type: sum
    sql: ${TABLE}.number_of_pdp_views ;;
  }
  measure: favourites {
    group_label: "Product Metrics"
    label: "# Favourite Products"
    description: "Number of unique products added to favourites"
    type: sum
    sql: ${TABLE}.number_of_added_to_favourites ;;
  }
  measure: number_of_clicks {
    group_label: "Product Metrics"
    label: "# Products Clicked (PDP or ATC)"
    description: "Number of products clicked. Can be either PDP or ATC"
    type: count
    # sql: ${product_placement_uuid} ;;
    filters: [is_pdp_or_atc: "yes" ]
  }

  measure: sum_of_time_on_screen_seconds{
    group_label: "Product Metrics"
    label: "Sum of Time on Screen in Seconds"
    type: sum
    description: "Sum of seconds a product sku was exposed on the screen aggregated by anonymous_id and product placement"
    filters: [is_product_impression: "yes" ]
    sql: ${TABLE}.sum_of_time_on_screen_seconds ;;
  }

  measure: click_through_rate {
    group_label: "Rates (%)"
    label: "Click-Through Rate (CTR)"
    type: number
    description: "# products with either PDP or Add-to-Cart / # total product impressions"
    value_format_name: percent_2
    sql: (${number_of_clicks}) / nullif(${impressions},0);;
  }
  measure: impression_to_atc_rate {
    group_label: "Rates (%)"
    label: "Impression to Add-to-Cart Rate"
    type: number
    description: "# products with Add-to-Cart / # total product impressions"
    value_format_name: percent_2
    sql: ${add_to_carts} / nullif(${impressions},0);;
  }
  measure: atc_to_order_rate {
    group_label: "Rates (%)"
    label: "Add-to-Cart to Order Rate"
    type: number
    description: "# orders / # products with Add-to-Cart"
    value_format_name: percent_2
    sql: ${ordered_products} / nullif(${add_to_carts},0);;
  }
  measure: impression_to_order_rate{
    group_label: "Rates (%)"
    label: "Impression to Order Rate"
    type: number
    description: "# orders / # total products impressions"
    value_format_name: percent_2
    sql: ${ordered_products} / nullif(${impressions},0);;
  }
  measure: out_of_stock_rate{
    group_label: "Rates (%)"
    label: "Out-ot-Stock Rate (OoS)"
    type: number
    description: "# OoS products / # total products impressions"
    value_format_name: percent_2
    sql: ${out_of_stock_products_total} / nullif(${impressions},0);;
  }

  # ======= User Level Measures =======
  measure: number_of_users {
    group_label: "User Metrics"
    label: "# Users"
    description: "Number of users"
    type: count_distinct
    sql: ${anonymous_id} ;;
  }

  measure: users_with_impressions {
    group_label: "User Metrics"
    label: "# Users with Impressions"
    description: "Number of users with impressions"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_product_impression: "yes"]
  }
  measure: users_with_add_to_carts {
    group_label: "User Metrics"
    label: "# Users with Add-to-Cart"
    description: "Number of users with add to cart"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_product_add_to_cart: "yes"]
  }
  measure: users_with_removed_from_cart {
    group_label: "User Metrics"
    label: "# Users with Removed-from-Cart"
    description: "Number of users with removed to cart"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_product_removed_from_cart: "yes"]
  }
  measure: users_with_pdp_viewed {
    group_label: "User Metrics"
    label: "# Users with PDP Viewed"
    description: "Number of users with pdp viewed"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_pdp_viewed: "yes"]
  }
  measure: users_with_add_to_favourites {
    group_label: "User Metrics"
    label: "# Users with Add-to-Favourites"
    description: "Number of users with add to favourites"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_added_to_favourites: "yes"]
  }
  measure: users_with_orders {
    group_label: "User Metrics"
    label: "# Users with Orders"
    description: "Number of users with orders"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_order_placed: "yes"]
  }
  measure: users_with_out_of_stock_products {
    group_label: "User Metrics"
    label: "# Users with OoS Products"
    description: "Number of users who saw products which were out of stock"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_product_out_of_stock: "yes"]
  }
}
