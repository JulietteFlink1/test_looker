view: product_placement_performance_excluding_impressions {
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

  dimension: order_uuid {
    group_label: "Product Dimensions"
    label: "Order UUID"
    description: "Unique identifier for an order"
    type: string
    sql: ${TABLE}.order_uuid ;;
  }
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
  dimension: screen_name {
    group_label: "Product Dimensions"
    label: "Screen Name"
    description: "Name of the screen."
    type: string
    sql: ${TABLE}.screen_name ;;
  }

  # ======= Product Flags =======

  dimension: is_order_placed {
    group_label: "Product Flags"
    label: "Is Order Placed"
    description: "Boolen whether product was ordered."
    type: yesno
    sql: ${TABLE}.is_order_placed ;;
  }
  dimension: is_product_add_to_cart {
    group_label: "Product Flags"
    label: "Is Product Added to Cart"
    description: "Boolen whether product was added to cart."
    type: yesno
    sql: ${TABLE}.is_product_add_to_cart ;;
  }
  dimension: is_product_removed_from_cart {
    group_label: "Product Flags"
    label: "Is Product Removed from Cart"
    description: "Boolen whether product was removed from cart."
    type: yesno
    sql: ${TABLE}.is_product_removed_from_cart ;;
  }
  dimension: is_pdp_viewed {
    group_label: "Product Flags"
    label: "Is Product Viewed (PDP)"
    description: "Boolen whether product was viewed / clicked."
    type: yesno
    sql: ${TABLE}.is_pdp_viewed ;;
  }
  dimension: is_product_added_to_favourites {
    group_label: "Product Flags"
    label: "Is Product Added to Favourites"
    description: "Boolen whether product was addded to favourites."
    type: yesno
    sql: ${TABLE}.is_product_added_to_favourites ;;
  }

  # ======= Dates / Timestamps =======

  dimension_group: event {
    group_label: "Date Dimensions"
    label: "Event"
    description: "Timestamp of when an event happened"
    type: time
    datatype: date
    timeframes: [
      date,
      week,
      month,
      quarter
    ]
    sql: ${TABLE}.event_date ;;
  }
  dimension: event_date_granularity {
    group_label: "Date Dimensions"
    label: "Event Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    hidden:  yes
    sql:
      {% if timeframe_picker._parameter_value == 'Day' %}
        ${event_date}
      {% elsif timeframe_picker._parameter_value == 'Week' %}
        ${event_week}
      {% elsif timeframe_picker._parameter_value == 'Month' %}
        ${event_month}
      {% endif %};;
  }

  parameter: timeframe_picker {
    group_label: "Date Dimensions"
    label: "Event Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  # ======= HIDDEN Dimension ======= #

  dimension: product_placement_uuid {
    hidden: yes
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    type: string
    sql: ${TABLE}.product_placement_uuid ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures      ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

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
  measure: anonymous_users {
    group_label: "User Metrics"
    label: "# All Users"
    description: "Number of all users regardless of their login status."
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }
  measure: products {
    group_label: "Product Metrics"
    label: "# Unique Products"
    description: "Number of unique products added to cart"
    type: count_distinct
    sql: ${TABLE}.product_sku ;;
  }

  # ======= Product Event Level Measures =======

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
  measure: orders { ## name should not be changed as charts would break
    group_label: "Product Metrics"
    label: "# Ordered Products"
    description: "Number of unique products placed"
    type: count_distinct
    sql: ${product_placement_uuid} ;;
    filters: [is_order_placed: "yes"]
  }
  measure: unique_orders {
    group_label: "Product Metrics"
    label: "# Orders"
    description: "Number of unique orders placed."
    type: count_distinct
    sql: ${TABLE}.order_uuid ;;
  }
  measure: atc_to_order_rate {
    group_label: "Rates (%)"
    label: "Add-to-Cart to Order Rate"
    type: number
    description: "# ordered products / # products with Add-to-Cart"
    value_format_name: percent_2
    sql: ${orders} / nullif(${add_to_carts},0);;
  }
}
