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
    label: "Is Discount Applied"
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
    label: "# Total Products"
    description: "Number of events trigegred by users"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: logged_in_users {
    label: "# Registered Users"
    description: "Number of users who logged-in during a day"
    type: count_distinct
    sql: ${TABLE}.user_id ;;
  }
  measure: logged_in_anonymous_users {
    label: "# All Users"
    description: "Number of all users regardless of their login status."
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }
  measure: products {
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
    description: "Sum of discounts applied on add-to-cart event (no voucher)"
    type: number
    value_format_name: decimal_2
    sql: (${original_product_price} - ${actual_product_price}) * -1 ;;
  }

### events per product placement ###
  measure: placement_cart {
    group_label: "# Events / # Products per Placement"
    label: "# Products - Cart"
    description: "Number of events trigegred by users from cart product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "cart"]
  }
  measure: placement_category {
    group_label: "# Events / # Products per Placement"
    label: "# Products - Category"
    description: "Number of events trigegred by users from category product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "category"]
  }
  measure: placement_search {
    group_label: "# Events / # Products per Placement"
    label: "# Products - Search"
    description: "Number of events trigegred by users from search product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "search"]
  }
  measure: placement_last_bought{
    group_label: "# Events / # Products per Placement"
    label: "# Products - Last bought"
    description: "Number of events trigegred by users from last_bought product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "last_bought"]
  }
  measure: placement_pdp {
    group_label: "# Events / # Products per Placement"
    label: "# Products - PDP"
    description: "Number of events trigegred by users"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "pdp"]
  }
  measure: placement_swimlane {
    group_label: "# Events / # Products per Placement"
    label: "# Products - Swimlane"
    description: "Number of events trigegred by users from swimlane product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "swimlane"]
  }
  measure: placement_favourites {
    group_label: "# Events / # Products per Placement"
    label: "# Products - Favourites"
    description: "Number of events trigegred by users from favourites product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "favourites"]
  }
  measure: placement_recommendation {
    group_label: "# Events / # Products per Placement"
    label: "# Products - Recommendation"
    description: "Number of events trigegred by users from recommendation product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "recommendation"]
  }
  measure: placement_recipes {
    group_label: "# Events / # Products per Placement"
    label: "# Products - Recipes"
    description: "Number of events trigegred by users from recipes product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "recipes"]
  }
  measure: placement_collection {
    group_label: "# Events / # Products per Placement"
    label: "# Products - Collection"
    description: "Number of events trigegred by users from collection product placement"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
    filters: [product_placement: "collection"]
  }

  ### ATC rates

  measure: atc_cart {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Cart"
    description: "ATC (add-to-cart) Rate from product placem events from ent. #cart / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_cart} / ${events};;
  }
  measure: atc_category {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Category"
    description: "ATC (add-to-cart) Rate from product placement. events from  #category / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_category} / ${events};;
  }
  measure: atc_search {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Search"
    description: "ATC (add-to-cart) Rate from product placemen events from t. #search / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_search} / ${events};;
  }
  measure: atc_last_bought{
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Last bought"
    description: "ATC (add-to-cart) Rate from product placement. #l events from ast_bought / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_last_bought} / ${events};;
  }
  measure: atc_pdp {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - PDP"
    description: "ATC (add-to-cart) Rate from product place events from ment. #pdp / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_pdp} / ${events};;
  }
  measure: atc_swimlane {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Swimlane"
    description: "ATC (add-to-cart) Rate from product placement. events from  #swimlane / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_swimlane} / ${events};;
  }
  measure: atc_favourites {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Favourites"
    description: "ATC (add-to-cart) Rate from product placement. # events from favourites / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_favourites} / ${events};;
  }
  measure: atc_recommendation {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Recommendation"
    description: "ATC (add-to-cart) Rate from product placement. # events from recommendation / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_recommendation} / ${events};;
  }
  measure: atc_recipes {
    group_label: "Add-to-cart Rates"
    label: "ATC rate - Recipes"
    description: "ATC (add-to-cart) Rate from product placement. # events from recipes / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_recipes} / ${events};;
  }
  measure: atc_collection {
    group_label: "Add-to-cart Rates"
    description: "ATC (add-to-cart) Rate from product placement. # events from collection / # total events"
    type: number
    value_format_name: percent_1
    sql: ${placement_collection} / ${events};;
  }
}
