view: event_product_added_to_cart {
  sql_table_name: `flink-data-prod.curated.event_product_added_to_cart` ;;
  view_label: "Event Product Added To Cart"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# ======= IDs ======= #

  dimension: event_uuid {
    group_label: "IDs"
    label: "Event UUID"
    description: "Unique identifier of an event"
    primary_key: yes
    type: string
    sql: ${TABLE}.event_uuid ;;
  }
  dimension: user_id {
    group_label: "IDs"
    label: "User ID"
    description: "User ID generated upon user registration"
    type: string
    sql: ${TABLE}.user_id ;;
  }
  dimension: anonymous_id {
    group_label: "IDs"
    label: "Anonymous ID"
    description: "User ID set by Segment"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: device_id {
    group_label: "IDs"
    label: "Device ID"
    description: "ID of an device"
    type: string
    sql: ${TABLE}.device_id ;;
  }
  dimension: category_id {
    group_label: "IDs"
    label: "Category ID"
    description: "ID of product's category"
    type: string
    sql: ${TABLE}.category_id ;;
  }

  dimension: sub_category_id {
    group_label: "IDs"
    label: "Sub-Category ID"
    description: "ID of product's sub-category"
    type: string
    sql: ${TABLE}.sub_category_id ;;
  }

# ======= Generic Dimensions ======= #

  dimension: is_user_logged_in {
    group_label: "Generic Dimensions"
    label: "Is User Logged-in"
    description: "Whether a user was logged-in when an event was triggered"
    type: yesno
    sql: ${TABLE}.is_user_logged_in ;;
  }
  dimension: has_selected_address {
    group_label: "Generic Dimensions"
    label: "Is Address Selected"
    description: "Whether a user had selected address when an event was triggered"
    type: yesno
    sql: ${TABLE}.has_selected_address ;;
  }
  dimension: event_name {
    group_label: "Generic Dimensions"
    label: "Event Name"
    description: "Name of the event triggered"
    type: string
    sql: ${TABLE}.event_name ;;
  }
  dimension: page_path {
    group_label: "Generic Dimensions"
    label: "Page Path"
    description: "Page path on web"
    type: string
    sql: ${TABLE}.page_path ;;
  }

# ======= Device Dimensions ======= #

  dimension: platform {
    group_label: "Device Dimensions"
    label: "Platform"
    description: "Platform is either iOS, Android or Web"
    type: string
    sql: ${TABLE}.platform ;;
  }
  dimension: device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "Device type is one of: ios, android, windows, macintosh, linux or other"
    type: string
    sql: ${TABLE}.device_type ;;
  }
  dimension: device_model {
    group_label: "Device Dimensions"
    label: "Device Model"
    description: "Model of the device"
    type: string
    sql: ${TABLE}.device_model ;;
  }
  dimension: os_version {
    group_label: "Device Dimensions"
    label: "OS Version"
    description: "Version of the operating system"
    type: string
    sql: ${TABLE}.os_version ;;
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
    sql: ${device_type} || '-' || ${app_version} ;;
  }

# ======= Location Dimension ======= #

  dimension: locale {
    group_label: "Location Dimensions"
    label: "Locale"
    description: "Language code | Coutnry, region code"
    type: string
    sql: ${TABLE}.locale ;;
  }
  dimension: timezone {
    group_label: "Location Dimensions"
    label: "Timezone"
    description: "Timezone of user's device"
    type: string
    sql: ${TABLE}.timezone ;;
  }
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
  dimension: product_sku_per_user {
    group_label: "Product Dimensions"
    label: "Product SKU + Anonymous ID"
    description: "SKU of the product concatenated with Anonymous ID. Necessary to count distinct SKUs per user"
    type: string
    sql: ${product_sku} || " - " || ${anonymous_id} ;;
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
    sql: ${TABLE}.product_price ;;
  }
  dimension: original_price {
    group_label: "Product Dimensions"
    label: "Product Price (Original)"
    description: "Original price of the product before discount"
    type: number
    sql: ${TABLE}.original_price ;;
  }
  dimension: is_discount_applied {
    group_label: "Product Dimensions"
    label: "Is Product Discount Applied"
    description: "Whether a discount was applied on a product."
    type: yesno
    sql: case
        when ${TABLE}.is_discount_applied = true then 'Yes'
        when ${TABLE}.is_discount_applied = false then 'No'
        when ${TABLE}.is_discount_applied is null then 'Unkown'
      end ;;
  }
  dimension: category_name {
    group_label: "Product Dimensions"
    label: "Category Name"
    description: "Name of a category where product was listed"
    type: string
    sql: ${TABLE}.category_name ;;
  }
  dimension: sub_category_name {
    group_label: "Product Dimensions"
    label: "Sub-Category name"
    description: "Name of a sub-category where product was listed"
    type: string
    sql: ${TABLE}.sub_category_name ;;
  }
  dimension: product_placement {
    group_label: "Product Dimensions"
    label: "Product Placement"
    description: "Placement in the app where product was listed, e.i. search, pdp, category"
    type: string
    # this was a temporary fix af a tracking issue
    sql: case when ${TABLE}.product_placement = 'swimlane' and ${TABLE}.category_id = 'last-bought' then 'last_bought'
       else ${TABLE}.product_placement
       end;;
  }
  dimension: is_product_placement_any_reco {
    group_label: "Product Dimensions"
    label: "Is Recommendation Product Placement"
    description: "Whether product placement was recommendation or last bought"
    type: yesno
    # this was a temporary fix af a tracking issue
    sql: ${product_placement}="recommendation" or ${product_placement}="last_bought";;
  }
  dimension: screen_name {
    group_label: "Product Dimensions"
    label: "Screen Name"
    description: "Name of the screen."
    type: string
    sql: ${TABLE}.screen_name ;;
  }

# ======= Dates / Timestamps =======

  dimension_group: event {
    group_label: "Date / Timestamp"
    label: "Event"
    description: "Timestamp of when an event happened"
    type: time
    timeframes: [
      time,
      date,
      week,
      quarter
    ]
    sql: ${TABLE}.event_timestamp ;;
    datatype: timestamp
  }

# ======= HIDDEN Dimension ======= #

  dimension_group: received_at {
    hidden: yes
    type: time
    timeframes: [
      date
    ]
    sql: ${TABLE}.received_at ;;
    datatype: timestamp
  }
  dimension: search_query_id {
    hidden: yes
    type: string
    sql: ${TABLE}.search_query_id ;;
  }
  dimension: list_position {
    hidden: yes
    group_label: "Product Dimensions"
    label: "Placement Position"
    description: "Placement of the UI element"
    type: number
    sql: ${TABLE}.list_position ;;
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: events {
    group_label: "Basic Counts"
    label: "# Total Products"
    description: "Number of events trigegred by users"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: logged_in_users {
    group_label: "Basic Counts"
    label: "# Registered Users"
    description: "Number of users who logged-in during a day"
    type: count_distinct
    sql: ${TABLE}.user_id ;;
  }
  measure: anonymous_users {
    group_label: "Basic Counts"
    label: "# All Users"
    description: "Number of all users regardless of their login status."
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }
  measure: products {
    group_label: "Basic Counts"
    label: "# Unique Products"
    description: "Number of unique products added to cart"
    type: count_distinct
    sql: ${TABLE}.product_sku ;;
  }
  measure: original_product_price{
    group_label: "Monetary Measures"
    label: "Original Product Price"
    description: "Product price before discount"
    type: sum
    value_format_name: decimal_2
    sql: ${original_price} ;;
  }
  measure: actual_product_price{
    group_label: "Monetary Measures"
    label: "Product Price"
    description: "Product price shows to a user (if discount applied then with a discount)"
    type: sum
    value_format_name: decimal_2
    sql: ${product_price} ;;
  }
  measure: sum_product_value {
    group_label: "Monetary Measures"
    label: "AIV - Average Item Value"
    description: "Sum of value of product price / sum all products"
    type: number
    value_format_name: decimal_2
    sql: ${actual_product_price} / ${events} ;;
  }
  measure: discount {
    hidden: yes
    group_label: "Monetary Measures"
    label: "Sum Product Discount"
    description: "Sum of Product discounts applied on add-to-cart event (no Cart Discount)"
    type: number
    value_format_name: decimal_2
    sql: (${original_product_price} - ${actual_product_price}) * -1 ;;
  }

########################################
##### events per product placement #####
########################################

  measure: placement_cart {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Cart"
    description: "Number of events trigegred by users from cart product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "cart"]
  }
  measure: placement_category {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Category"
    description: "Number of events trigegred by users from category product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "category"]
  }
  measure: placement_search {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Search"
    description: "Number of events trigegred by users from search product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "search"]
  }
  measure: placement_last_bought{
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Last bought"
    description: "Number of events trigegred by users from last_bought product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "last_bought"]
  }
  measure: placement_pdp {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - PDP"
    description: "Number of events trigegred by users"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "pdp"]
  }
  measure: placement_swimlane {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Swimlane"
    description: "Number of events trigegred by users from swimlane product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "swimlane"]
  }
  measure: placement_favourites {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Favourites"
    description: "Number of events trigegred by users from favourites product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "favourites"]
  }
  measure: placement_recommendation {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Recommendation"
    description: "Number of events trigegred by users from recommendation product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "recommendation"]
  }
  measure: placement_any_recommendation {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Any Recommendation"
    description: "Number of events trigegred by users from recommendation OR last-bought product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [is_product_placement_any_reco: "yes"]
  }
  measure: placement_recipes {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Recipes"
    description: "Number of events trigegred by users from recipes product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "recipes"]
  }
  measure: placement_collection {
    group_label: "# Add-to-cart Events per Placement"
    label: "# Products - Collection"
    description: "Number of events trigegred by users from collection product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "collection"]
  }

########################################
##### Users  per product placement #####
########################################

  measure: placement_cart_users {
    group_label: "# Users per Placement"
    label: "# Users - Cart"
    description: "Number of users who added to the cart from cart placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "cart"]
  }
  measure: placement_category_users {
    group_label: "# Users per Placement"
    label: "# Users - Category"
    description: "Number of users who added to the cart from category placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "category"]
  }
  measure: placement_search_users {
    group_label: "# Users per Placement"
    label: "# Users - Search"
    description: "Number of users who added to the cart from search placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "search"]
  }
  measure: placement_last_bought_users{
    group_label: "# Users per Placement"
    label: "# Users - Last bought"
    description: "Number of users who added to the cart from last_bought placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "last_bought"]
  }
  measure: placement_pdp_users {
    group_label: "# Users per Placement"
    label: "# Users - PDP"
    description: "Number of users who added to the cart from PDP placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "pdp"]
  }
  measure: placement_swimlane_users {
    group_label: "# Users per Placement"
    label: "# Users - Swimlane"
    description: "Number of users who added to the cart from swimlane placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "swimlane"]
  }
  measure: placement_favourites_users {
    group_label: "# Users per Placement"
    label: "# Users - Favourites"
    description: "Number of users who added to the cart from favourites placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "favourites"]
  }
  measure: placement_recommendation_users {
    group_label: "# Users per Placement"
    label: "# Users - Recommendation"
    description: "Number of users who added to the cart from recommendation placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "recommendation"]
  }
  measure: placement_any_recommendation_users {
    group_label: "# Users per Placement"
    label: "# Users - Any Recommendation"
    description: "Number of users who added to the cart from recommendation OR last-bought placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [is_product_placement_any_reco: "yes"]
  }
  measure: placement_recipes_users {
    group_label: "# Users per Placement"
    label: "# Users - Recipes"
    description: "Number of users who added to the cart from recipes placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "recipes"]
  }
  measure: placement_collection_users {
    group_label: "# Users per Placement"
    label: "# Users - Collection"
    description: "Number of users who added to the cart from collection placement"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
    filters: [product_placement: "collection"]
  }

 #########################################
 ##### User level metrics - ATC rate #####
 #########################################

  measure: atc_cart {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Cart"
    description: "Number of users with add-to-cart with Cart product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_cart_users} / ${anonymous_users};;
  }
  measure: atc_category {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Category"
    description: "Number of users with add-to-cart with Category product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_category_users} / ${anonymous_users};;
  }
  measure: atc_search {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Search"
    description: "Number of users with add-to-cart with Search product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_search_users} / ${anonymous_users};;
  }
  measure: atc_last_bought{
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Last bought"
    description: "Number of users with add-to-cart with Last Bought product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_last_bought_users} / ${anonymous_users};;
  }
  measure: atc_pdp {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - PDP"
    description: "Number of users with add-to-cart with PDP product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_pdp_users} / ${anonymous_users};;
  }
  measure: atc_swimlane {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Swimlane"
    description: "Number of users with add-to-cart with Swimlane product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_swimlane_users} / ${anonymous_users};;
  }
  measure: atc_favourites {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Favourites"
    description: "Number of users with add-to-cart with Favourites product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_favourites_users} / ${anonymous_users};;
  }
  measure: atc_recommendation {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Recommendation"
    description: "Number of users with add-to-cart with Recommendation product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_recommendation_users} / ${anonymous_users};;
  }
  measure: atc_any_recommendation {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Any Recommendation"
    description: "Number of users with add-to-cart with Recommendation or Last-Bought product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_any_recommendation_users} / ${anonymous_users};;
  }
  measure: atc_recipes {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Recipes"
    description: "Number of users with add-to-cart with Recipes product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_recipes_users} / ${anonymous_users};;
  }
  measure: atc_collection {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Collection"
    description: "Number of users with add-to-cart with Collection product placement / # total users"
    type: number
    value_format_name: percent_1
    sql: ${placement_collection_users} / ${anonymous_users};;
  }
}
