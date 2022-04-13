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
  dimension: category_name {
    group_label: "Product Dimensions"
    label: "Category Name"
    description: "Name of a category where product was listed"
    type: string
    sql: ${TABLE}.category_name ;;
  }
  dimension: subcategory_name {
    group_label: "Product Dimensions"
    label: "Sub-Category Name"
    description: "Name of a sub-category where product was listed"
    type: string
    sql: ${TABLE}.subcategory_name ;;
  }
  dimension: product_placement {
    group_label: "Product Dimensions"
    label: "Product Placement"
    description: "Placement in the app where product was listed, e.i. search, pdp, category"
    type: string
    sql: case when ${TABLE}.product_placement in ('checkout','cart') then 'cart'
              else ${TABLE}.product_placement
              end ;;
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

  # ======= HIDDEN Dimension ======= #

  dimension: product_placement_uuid {
    hidden: yes
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    type: string
    sql: ${TABLE}.event_uuid ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures      ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: logged_in_users {
    group_label: "User Metrics"
    label: "# Registered Users"
    description: "Number of users who logged-in during a day"
    type: sum
    sql: ${TABLE}.number_of_logged_in_users ;;
  }
  measure: anonymous_users {
    group_label: "User Metrics"
    label: "# All Users"
    description: "Number of all users regardless of their login status."
    type: sum
    sql: ${TABLE}.number_of_users ;;
  }
  measure: products {
    group_label: "Product Metrics"
    label: "# Unique Products"
    description: "Number of unique products added to cart"
    type: count_distinct
    sql: ${TABLE}.product_sku ;;
  }
  # ======= Product Event Level Measures =======

  measure: impressions {
    hidden: yes
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
  measure: click_through_rate {
    hidden: yes
    group_label: "Rates (%)"
    label: "Click-Through Rate (CTR)"
    type: number
    description: "# products with either PDP or Add-to-Cart / # total product impressions"
    value_format_name: percent_2
    sql: (${add_to_carts} + ${pdps}) / nullif(${impressions},0);;
  }
  measure: impression_to_atc_rate {
    hidden: yes
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
    hidden: yes
    group_label: "Rates (%)"
    label: "Impression to Order Rate"
    type: number
    description: "# ordered products / # total products impressions"
    value_format_name: percent_2
    sql: ${orders} / nullif(${impressions},0);;
  }

  # ======= User Level Measures =======
  measure: users_with_impressions {
    group_label: "Product Metrics"
    label: "# Products Added to Cart"
    description: "Number of unique products added to cart"
    type: sum
    sql: ${TABLE}.number_of_users_with_impressions ;;
  }
  measure: users_with_add_to_carts {
    group_label: "Product Metrics"
    label: "# Products Added to Cart"
    description: "Number of unique products added to cart"
    type: sum
    sql: ${TABLE}.number_of_users_with_add_to_carts ;;
  }
  measure: users_with_removed_from_carts {
    group_label: "Product Metrics"
    label: "# Products Removed from Cart"
    description: "Number of unique products removed from cart"
    type: sum
    sql: ${TABLE}.number_of_users_with_removed_from_carts ;;
  }
  measure: users_with_pdp_viewed {
    group_label: "Product Metrics"
    label: "# PDPs"
    description: "Number of PDPs (product details viewed) per product"
    type: sum
    sql: ${TABLE}.number_of_users_with_pdp_views ;;
  }
  measure: users_with_add_to_favourites {
    group_label: "Product Metrics"
    label: "# Favourite Products"
    description: "Number of unique products added to favourites"
    type: sum
    sql: ${TABLE}.number_of_users_with_added_to_favourites ;;
  }
  measure: users_with_orders {
    group_label: "Product Metrics"
    label: "# Ordered Products "
    description: "Number of orders with the product"
    type: sum
    sql: ${TABLE}.number_of_users_with_order ;;
  }
}
