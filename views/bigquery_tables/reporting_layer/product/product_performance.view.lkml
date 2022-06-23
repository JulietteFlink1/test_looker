view: product_performance {
  sql_table_name: `flink-data-prod.curated.product_performance`
      ;;

  view_label: "* Product Performance *"
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      country,
      city,
      hub_code,
      device_type
      ]
  }

########### DIMENSIONS ###########
    ## IDs

    dimension: product_event_uuid {
      group_label: "IDs"
      type: string
      description: "Unique identifier per row"
      sql: ${TABLE}.product_event_uuid ;;
      primary_key: yes
      hidden: yes
    }
    dimension: product_sku {
      group_label: "IDs"
      label: "Product SKU"
      type: string
      description: "Product SKU"
      sql: ${TABLE}.product_sku ;;
      hidden: no
    }
    dimension: session_id {
      group_label: "IDs"
      label: "Session ID"
      type: string
      description: "Session ID"
      sql: ${TABLE}.session_id ;;
    }
    dimension: user_id  {
      group_label: "IDs"
      label: "User ID"
      type: string
      description: "User ID populated upon registration"
      sql: ${TABLE}.user_id  ;;
      hidden: yes
    }
    dimension: anonymous_id {
      group_label: "IDs"
      label: "Anonymous ID"
      type: string
      description: "Anonymou ID populated by Segment as a user identifier"
      sql: ${TABLE}.anonymous_id ;;
    }
    dimension: order_number {
      group_label: "IDs"
      label: "Order Number"
      type: string
      description: "Order number per order"
      sql: ${TABLE}.order_number ;;
    }
    dimension: order_uuid {
      group_label: "IDs"
      label: "Order UUID"
      type: string
      description: "Unique order identifier as a concatenation of country_iso and order_id"
      sql: ${TABLE}.order_uuid ;;
    }
    dimension: category_id {
      group_label: "IDs"
      type: string
      description: "Category ID"
      sql: ${TABLE}.category_id ;;
      hidden: yes
    }
    dimension: subcategory_id {
      group_label: "IDs"
      type: string
      description: "Sub-category ID"
      sql: ${TABLE}.subcategory_id ;;
      hidden: yes
    }

    ## Device attributes

    dimension: platform {
      group_label: "Device Dimensions"
      type: string
      description: "Platform where session appeared >> app"
      sql: ${TABLE}.platform ;;
      hidden: yes
    }
    dimension: device_type {
      group_label: "Device Dimensions"
      type: string
      description: "Device type is either iOS or Android"
      sql: ${TABLE}.device_type ;;
    }
    dimension: app_version {
      group_label: "Device Dimensions"
      type: string
      description: "App realease version"
      sql: ${TABLE}.app_version ;;
    }

    ## GENERIC: Dates / Timestamp

    dimension_group: event_at {
      group_label: "Date Dimensions"
      label: "Event"
      description: "Date of an event"
      datatype: date
      type: time
      timeframes: [
        date,
        day_of_week,
        week,
        month,
        year
        ]
      sql: ${TABLE}.event_date ;;
    }

    ## PRODUCT dimensions

  dimension: product_slug {
    group_label: "Product Dimensions"
    description: "A cleaned name of the product"
    type: string
    sql: ${TABLE}.product_slug ;;
  }
  dimension: product_name {
    group_label: "Product Dimensions"
    description: "A full name of the product"
    type: string
    sql: ${TABLE}.product_name ;;
  }
  dimension: category_name {
    group_label: "Product Dimensions"
    description: "A name of the product category"
    type: string
    sql: ${TABLE}.category_name ;;
  }
  dimension: subcategory_name {
    group_label: "Product Dimensions"
    description: "A name of the product sub-category"
    type: string
    sql: ${TABLE}.subcategory_name ;;
  }
  dimension: product_placement {
    group_label: "Product Dimensions"
    description: "Place where product appeared in the app, there are 7: Cart, Catergory, Favourites, Last Bought, PDP, Search, Swimlane"
    type: string
    sql: ${TABLE}.product_placement ;;
  }
  dimension: origin_screen {
    group_label: "Product Dimensions"
    description: "Where screen originated, e.g. users can use Favourites from either Home or User Profile."
    type: string
    sql: ${TABLE}.origin_screen ;;
  }
  dimension: pdp_origin {
    group_label: "Product Dimensions"
    description: "Where frm PDP (Product Detail Page) originated, can be: Cart, Category, Favourites, Last Bought, Search Swimlane"
    type: string
    sql: ${TABLE}.pdp_origin ;;
  }
  dimension: currency {
    group_label: "Product Dimensions"
    description: "A currency of the product"
    type: string
    sql: ${TABLE}.currency ;;
  }

  ## PRODUCT BOOLEANS
  dimension: is_product_added_to_cart {
    group_label: "Product Booleans"
    description: "Boolean if product was added to cart during the same session"
    type: yesno
    sql: ${TABLE}.is_product_added_to_cart ;;
  }
  dimension: is_product_removed_from_cart {
    group_label: "Product Booleans"
    description: "Boolean if product was removed from cart during the same session"
    type: yesno
    sql: ${TABLE}.is_product_removed_from_cart ;;
  }
  dimension: is_product_added_to_favourites {
    group_label: "Product Booleans"
    description: "Boolean if product was added to favourites during the same session"
    type: yesno
    sql: ${TABLE}.is_product_added_to_favourites ;;
  }
  dimension: is_product_details_viewed {
    group_label: "Product Booleans"
    description: "Boolean if product was viewed (PDP) during the same session"
    type: yesno
    sql: ${TABLE}.is_product_details_viewed ;;
  }
  dimension: is_product_purchased {
    group_label: "Product Booleans"
    description: "Boolean is product was purchased during the same session"
    type: yesno
    sql: ${TABLE}.is_product_purchased ;;
  }

    ## Hub attributes
    dimension: city {
      group_label: "Hub Dimensions"
      type: string
      sql: ${TABLE}.city ;;
    }
    dimension: hub_code {
    group_label: "Hub Dimensions"
    description: "Hub code"
    type: string
    sql: ${TABLE}.hub_code ;;
  }
    dimension: country_iso {
      group_label: "Hub Dimensions"
      type: string
      sql: ${TABLE}.country_iso ;;
      hidden: yes
    }
    dimension: country {
      group_label: "Hub Dimensions"
      type: string
      case: {
        when: {
          sql: ${TABLE}.country_iso = "DE" ;;
          label: "Germany"
        }
        when: {
          sql: ${TABLE}.country_iso = "FR" ;;
          label: "France"
        }
        when: {
          sql: ${TABLE}.country_iso = "NL" ;;
          label: "Netherlands"
        }
        when: {
          sql: ${TABLE}.country_iso = "AT" ;;
          label: "Austria"
        }
        else: "Other / Unknown"
      }
    }

    ################ Measures from dimensions #################
    ## MONETARY DIMENSIONS ##

    dimension: first_cart_value {
      type: number
      group_label: "Monetary Dimensions"
      label: "First Cart Value (Gross)"
      description: "Gross value of the cart / basket upon the first visit during the same session"
      sql: ${TABLE}.first_cart_value ;;
      hidden: no
    }
    dimension: last_cart_value {
      type: number
      group_label: "Monetary Dimensions"
      label: "Last Cart Value (Gross)"
      description: "Gross value of the cart / basket upon the last visit during the same session"
      sql: ${TABLE}.last_cart_value ;;
      hidden: no
    }
    dimension: product_revenue {
      type: number
      group_label: "Monetary Dimensions"
      label: "Product Value (Gross)"
      description: "Gross value generated by a product"
      sql: ${TABLE}.product_revenue ;;
      hidden: no
    }

    ################ Measures ################

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of unique users identified via anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }
   measure: cnt_unique_sessions {
    label: "# Unique Sessions"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of unique sessions based on sessions_uuid"
    hidden:  no
    type: count_distinct
    sql: ${session_id};;
    value_format_name: decimal_0
  }
  measure: cnt_unique_skus {
    label: "# Unique Products"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of unique product skus"
    hidden:  no
    type: count_distinct
    sql: ${product_sku};;
    value_format_name: decimal_0
  }
  measure: cnt_unique_order_uuid {
    label: "# Unique Orders"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of unique orders"
    hidden:  no
    type: count_distinct
    sql: ${order_uuid};;
    value_format_name: decimal_0
  }
  ### Quantity metrics ###

  measure: product_ordered_quantity {
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "# Products Purchased"
    description: "Quantity of ordered products"
    type: sum
    hidden: no
    sql: ${TABLE}.ordered_quantity;;
  }
  measure: product_added_to_cart_quantity {
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "# Products Added to Cart"
    description: "Quantity of products added to cart"
    type: sum
    hidden: no
    sql: ${TABLE}.product_added_to_cart_quantity;;
  }
  measure: product_removed_from_cart_quantity {
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "# Products Removed from Cart"
    description: "Quantity of products removed from cart"
    type: sum
    hidden: no
    sql: ${TABLE}.product_removed_from_cart_quantity;;
  }
  measure: product_added_to_favourites_quantity {
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "# Products Added to Favourites"
    description: "Quantity of products added to favourites"
    type: sum
    hidden: no
    sql: ${TABLE}.product_added_to_favourites_quantity;;
  }
  measure: product_details_viewed_quantity {
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "# Products Viewed (on PDP)"
    description: "Quantity of products viewed (when PDP happened)"
    type: sum
    hidden: no
    sql: ${TABLE}.product_details_viewed_quantity;;
  }

  ## Monetary Values ##

  measure: amt_first_cart_value_gross {
    group_label: "Monetary Values"
    label: "First Cart Value Amount (Gross)"
    description: "Sum of the cart value upon the first view of the cart during the same session (incl. VAT)"
    type: sum
    hidden: no
    sql: ${first_cart_value} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: amt_last_cart_value_gross {
    group_label: "Monetary Values"
    label: "Last Cart Value Amount (Gross)"
    description: "Sum of the cart value upon the last view of the cart during the same session (incl. VAT)"
    type: sum
    hidden: no
    sql: ${last_cart_value} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: avg_first_cart_value_gross {
    group_label: "Monetary Values"
    label: "ACV First View (Gross)"
    description: "Average Cart Value (ACV) upon the first cart view during the same session (incl. VAT)"
    type: average
    hidden: no
    sql: ${first_cart_value} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: avg_last_cart_value_gross {
    group_label: "Monetary Values"
    label: "ACV Last View (Gross)"
    description: "Average Cart Value (ACV) upon the last cart view during the same session (incl. VAT)"
    type: average
    hidden: no
    sql: ${last_cart_value} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: amt_product_revenue_gross {
    group_label: "Monetary Values"
    label: "Product Value (Gross)"
    description: "Sum of the product value gross (incl. VAT)"
    type: sum
    hidden: no
    sql: ${product_revenue} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: avg_product_revenue_gross {
    group_label: "Monetary Values"
    label: "AVG Product Value (Gross)"
    description: "Average product value gross (incl. VAT)"
    type: average
    hidden: no
    sql: ${product_revenue} ;;
    value_format_name: euro_accounting_2_precision
  }

  ## CONVERSION ##

  measure: cnt_is_product_purchased {
    type: count
    filters: [is_product_purchased: "yes"]
    hidden: yes
  }
  measure: cnt_is_product_added_to_cart {
    type: count
    filters: [is_product_added_to_cart: "yes"]
    hidden: yes
  }
  measure: product_conversion{
    group_label: "Conversions"
    label: "Product Conversion"
    description: "Product purchased / product added to cart"
    type: number
    value_format_name: percent_2
    sql: ${product_ordered_quantity}/NULLIF(${product_added_to_cart_quantity},0);;
  }
  measure: product_pdp_to_cart_conversion{
    group_label: "Conversions"
    label: "PDP to Cart Conversion"
    description: "Product added to cart / product viewed (PDP)"
    type: number
    value_format_name: percent_2
    sql: ${product_added_to_cart_quantity}/NULLIF(${product_details_viewed_quantity},0);;
  }
  }
