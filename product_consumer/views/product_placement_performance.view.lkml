view: product_placement_performance {
  sql_table_name: `flink-data-prod.reporting.product_placement_performance`
    ;;
  view_label: "Product Placement Performance"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= Device Dimensions ======= #

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
    sql: ${TABLE}.hub_code ;;
  }
  dimension: country_iso {
    group_label: "Location Dimensions"
    label: "Country ISO"
    description: "ISO country"
    type: string
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
  dimension: product_name {
    group_label: "Product Dimensions"
    label: "Product Name"
    description: "Name of the product"
    type: string
    sql: ${TABLE}.product_name ;;
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
    description: "Name of a category where product was listed"
    type: string
    sql: case when ${TABLE}.product_placement in ('category','pdp')
              then ${TABLE}.category_name
         else null
         end ;;
  }
  dimension: subcategory_name {
    group_label: "Product Dimensions"
    label: "Sub-Category Name"
    description: "Name of a sub-category where product was listed"
    type: string
    sql: case when ${TABLE}.product_placement in ('category','pdp')
              then ${TABLE}.subcategory_name
         else null
         end ;;
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
  dimension: origin_screen {
    group_label: "Product Dimensions"
    label: "Screen Name"
    description: "Name of the screen."
    type: string
    sql: ${TABLE}.origin_screen ;;
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
    sql: ${TABLE}.is_added_to_favourites ;;
  }

  dimension: is_order_placed {
    group_label: "Event Flags"
    type: yesno
    sql: ${TABLE}.is_order_placed ;;
  }

  # ======= HIDDEN Dimension ======= #

  dimension: product_placement_uuid {
    hidden: yes
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    type: string
    sql: ${TABLE}.event_uuid ;;
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
    sql: ${TABLE}.is_pdp_viewed or ${TABLE}.is_product_add_to_cart ;;
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
  measure: orders {
    group_label: "Product Metrics"
    label: "# Ordered Products "
    description: "Number of orders with the product"
    type: sum
    sql: ${TABLE}.number_of_orders ;;
  }
  measure: number_of_clicks {
    group_label: "Product Metrics"
    label: "# Products clicked (PDP or ATC)"
    description: "Number of products clicked. Can be either PDP or ATC"
    type: count_distinct
    sql: ${product_placement_uuid} ;;
    filters: [is_pdp_or_atc: "yes" ]
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
    description: "# ordered products / # products with Add-to-Cart"
    value_format_name: percent_2
    sql: ${orders} / nullif(${add_to_carts},0);;
  }
  measure: impression_to_order_rate{
    group_label: "Rates (%)"
    label: "Impression to Order Rate"
    type: number
    description: "# ordered products / # total products impressions"
    value_format_name: percent_2
    sql: ${orders} / nullif(${impressions},0);;
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
    label: "# Users with impressions"
    description: "Number of users with impressions"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_product_impression: "yes"]
  }
  measure: users_with_add_to_carts {
    group_label: "User Metrics"
    label: "# Users with add to cart"
    description: "Number of users with add to cart"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_product_add_to_cart: "yes"]
  }
  measure: users_with_removed_from_cart {
    group_label: "User Metrics"
    label: "# Users with removed to cart"
    description: "Number of users with removed to cart"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_product_removed_from_cart: "yes"]
  }
  measure: users_with_pdp_viewed {
    group_label: "User Metrics"
    label: "# Users with pdp viewed"
    description: "Number of users with pdp viewed"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_pdp_viewed: "yes"]
  }
  measure: users_with_add_to_favourites {
    group_label: "User Metrics"
    label: "# Users with add to favourites"
    description: "Number of users with add to favourites"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_added_to_favourites: "yes"]
  }
  measure: users_with_orders {
    group_label: "User Metrics"
    label: "# Users with orders"
    description: "Number of users with orders"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_order_placed: "yes"]
  }
}
