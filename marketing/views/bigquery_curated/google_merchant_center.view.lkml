# Creator: Andreas Stueber
# When: 2023-06-08
# Purpose: Give the performnance marketing team access to the Google Merchant Cetner data in Looker



# The name of this view in Looker is "Google Merchant Center"
view: google_merchant_center {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `flink-data-dev.dbt_astueber_curated.google_merchant_center`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Country Iso" in Explore.

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: availability {
    type: string
    description: "Field indicating, if a product is in stock or out-of-stock"
    sql: ${TABLE}.current_state.availability ;;

    group_item_label: "Availability"
  }

  dimension: channel {
    type: string
    description: "Marketing channel category."
    sql: ${TABLE}.current_state.channel ;;

    group_item_label: "Channel"
  }

  dimension: condition {
    type: string
    description: "Applied condition within the Google Merchant Center"
    sql: ${TABLE}.current_state.condition ;;

    group_item_label: "Condition"
  }

  dimension: content_language {
    type: string
    description: "The language of the marketing content"
    sql: ${TABLE}.current_state.content_language ;;

    group_item_label: "Content Language"
  }

  dimension: currency {
    type: string
    description: "Currency ISO code."
    sql: ${TABLE}.current_state.currency ;;

    group_item_label: "Currency"
  }

  dimension: destinations__destination_approved_countries {
    type: string
    description: "List of countries, the product is approved for in Google Merchant Center"
    sql: ${TABLE}.current_state.destinations.destination_approved_countries ;;
    group_label: "Destinations"
    group_item_label: "Destination Approved Countries"
  }

  dimension: destinations__destination_disapproved_countries {
    type: string
    description: "List of contries, the product was rejected in Google Merchant Center"
    sql: ${TABLE}.current_state.destinations.destination_disapproved_countries ;;
    group_label: "Destinations"
    group_item_label: "Destination Disapproved Countries"
  }

  dimension: destinations__destination_name {
    type: string
    description: "Name of the destination of a product in Google Merchant Center"
    sql: ${TABLE}.current_state.destinations.destination_name ;;
    group_label: "Destinations"
    group_item_label: "Destination Name"
  }

  dimension: destinations__destination_pending_countries {
    type: string
    description: "List of countries, the product aproval is pending in Google Merchant Center"
    sql: ${TABLE}.current_state.destinations.destination_pending_countries ;;
    group_label: "Destinations"
    group_item_label: "Destination Pending Countries"
  }

  dimension: destinations__destination_status {
    type: string
    description: "Status of the integration to a destination of a product in Google Merchant Center"
    sql: ${TABLE}.current_state.destinations.destination_status ;;
    group_label: "Destinations"
    group_item_label: "Destination Status"
  }

  dimension: flink_cateogry {
    type: string
    description: "Name of the category to which product was assigned, (not ERP category)."
    sql: ${TABLE}.current_state.flink_cateogry ;;

    group_item_label: "Flink Cateogry"
  }

  dimension: flink_subcategory {
    type: string
    description: "Name of the subcategory to which product was assigned, (not ERP subcategory)."
    sql: ${TABLE}.current_state.flink_subcategory ;;

    group_item_label: "Flink Subcategory"
  }

  dimension: google_brand_id {
    type: string
    description: "Brand ID according to Google Merchant Center"
    sql: ${TABLE}.current_state.google_brand_id ;;

    group_item_label: "Google Brand ID"
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: google_expiration {
    type: time
    description: "Timestamp, when the uploaded product data gets invalid in the Google Merchant Center"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.current_state.google_expiration_timestamp ;;
  }

  dimension: google_product_category_full {
    type: string
    description: "The full categorisation of a product according to Google Merchant Center (Level 1 Category >> Level 2 Category >> ...)"
    sql: ${TABLE}.current_state.google_product_category_full ;;

    group_item_label: "Google Product Category Full"
  }

  dimension: google_product_category_id {
    type: number
    description: "ID of the Google Merchant Center-defined product category"
    sql: ${TABLE}.current_state.google_product_category_id ;;

    group_item_label: "Google Product Category ID"
  }

  dimension: google_product_category_level_1 {
    type: string
    description: "Level 1 of the categorisation of a product according to the Google Merchant Center"
    sql: ${TABLE}.current_state.google_product_category_level_1 ;;

    group_item_label: "Google Product Category Level 1"
  }

  dimension: google_product_category_level_2 {
    type: string
    description: "Level 2 of the categorisation of a product according to the Google Merchant Center"
    sql: ${TABLE}.current_state.google_product_category_level_2 ;;

    group_item_label: "Google Product Category Level 2"
  }

  dimension: google_product_category_level_3 {
    type: string
    description: "Level 3 of the categorisation of a product according to the Google Merchant Center"
    sql: ${TABLE}.current_state.google_product_category_level_3 ;;

    group_item_label: "Google Product Category Level 3"
  }

  dimension: gtin {
    type: string
    description: "Global Trade Item Number is an identifier for trade items."
    sql: ${TABLE}.current_state.gtin ;;

    group_item_label: "Gtin"
  }

  dimension: issues__issue_applicable_countries {
    type: string
    description: "List of countries, the issue in Google Merchant Center applies to"
    sql: ${TABLE}.current_state.issues.issue_applicable_countries ;;
    group_label: "Issues"
    group_item_label: "Issue Applicable Countries"
  }

  dimension: issues__issue_attribute_name {
    type: string
    description: "Attribute names for the issue in Google Merchant Center"
    sql: ${TABLE}.current_state.issues.issue_attribute_name ;;
    group_label: "Issues"
    group_item_label: "Issue Attribute Name"
  }

  dimension: issues__issue_code {
    type: string
    description: "Issue code of a rejected item in Google Merchant Center"
    sql: ${TABLE}.current_state.issues.issue_code ;;
    group_label: "Issues"
    group_item_label: "Issue Code"
  }

  dimension: issues__issue_destination {
    type: string
    description: "Destination, that is affected by the issue in Google Merchant Center"
    sql: ${TABLE}.current_state.issues.issue_destination ;;
    group_label: "Issues"
    group_item_label: "Issue Destination"
  }

  dimension: issues__issue_detailed_description {
    type: string
    description: "Detailed description of the issue in Google Merchant Center"
    sql: ${TABLE}.current_state.issues.issue_detailed_description ;;
    group_label: "Issues"
    group_item_label: "Issue Detailed Description"
  }

  dimension: issues__issue_documentation {
    type: string
    description: "Link to the documentation page for the issue in Google Merchant Center"
    sql: ${TABLE}.current_state.issues.issue_documentation ;;
    group_label: "Issues"
    group_item_label: "Issue Documentation"
  }

  dimension: issues__issue_resolution {
    type: string
    description: "Information on who to solve the issue in Google Merchant Center"
    sql: ${TABLE}.current_state.issues.issue_resolution ;;
    group_label: "Issues"
    group_item_label: "Issue Resolution"
  }

  dimension: issues__issue_servability {
    type: string
    description: "Information whether products are still servable in Google Merchant Center given the issue"
    sql: ${TABLE}.current_state.issues.issue_servability ;;
    group_label: "Issues"
    group_item_label: "Issue Servability"
  }

  dimension: issues__issue_short_description {
    type: string
    description: "Short description of the issue in Google Merchant Center"
    sql: ${TABLE}.current_state.issues.issue_short_description ;;
    group_label: "Issues"
    group_item_label: "Issue Short Description"
  }

  dimension: number_of_google_categories {
    type: number
    description: "The number of categories levels defined by Google Merchant Center"
    sql: ${TABLE}.current_state.number_of_google_categories ;;

    group_item_label: "Number of Google Categories"
  }

  dimension: original_price {
    type: number
    description: "Gross price of a product, including the deposit value."
    sql: ${TABLE}.current_state.original_price ;;

    group_item_label: "Original Price"
  }

  dimension: price_class {
    type: string
    description: "Price classification for a product (currently more/less than 10 EUR )"
    sql: ${TABLE}.current_state.price_class ;;

    group_item_label: "Price Class"
  }

  dimension: product_brand {
    type: string
    description: "Brand a product belongs to."
    sql: ${TABLE}.current_state.product_brand ;;

    group_item_label: "Product Brand"
  }

  dimension: product_deep_link {
    type: string
    description: "Link to the Flink-webpage for a given product"
    sql: ${TABLE}.current_state.product_deep_link ;;

    group_item_label: "Product Deep Link"
  }

  dimension: product_description {
    type: string
    description: "The description of a product in CommerceTools"
    sql: ${TABLE}.current_state.product_description ;;

    group_item_label: "Product Description"
  }

  dimension: product_image_link {
    type: string
    description: "Link to the destination, where the image of a product is stored"
    sql: ${TABLE}.current_state.product_image_link ;;

    group_item_label: "Product Image Link"
  }

  dimension: product_name {
    type: string
    description: "Name of the product, as specified in the backend."
    sql: ${TABLE}.current_state.product_name ;;

    group_item_label: "Product Name"
  }

  dimension_group: product_upload {
    type: time
    description: "Timestamp, when the product data was uploaded to Google Merchant Center"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.current_state.product_upload_timestamp ;;
  }

  dimension: selling_price {
    type: number
    description: "Price of the product for which user bought an item, also includes discounted values (including VAT)."
    sql: ${TABLE}.current_state.selling_price ;;

    group_item_label: "Selling Price"
  }

  dimension: google_merchant_id {
    type: number
    description: "The ID of a merchant (account) in Google Merchant Center"
    sql: ${TABLE}.google_merchant_id ;;
  }

  dimension: google_product_id {
    type: string
    description: "The ID of a product defined by the Google Merchant Center"
    sql: ${TABLE}.google_product_id ;;
  }

  # This field is hidden, which means it will not show up in Explore.
  # If you want this field to be displayed, remove "hidden: yes".

  dimension: history {
    hidden: yes
    sql: ${TABLE}.history ;;
  }

  dimension: number_of_historical_changes {
    type: number
    description: "This index provides a count of how many row-changes have been performed to a given object in Oracle."
    sql: ${TABLE}.number_of_historical_changes ;;
  }

  dimension: sku {
    type: string
    description: "SKU of the product, as available in the backend."
    sql: ${TABLE}.sku ;;
  }

  dimension: table_uuid {
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  measure: count {
    type: count
    drill_fields: [product_name, issues__issue_attribute_name, destinations__destination_name]
  }
}



# The name of this view in Looker is "Google Merchant Center History"
view: google_merchant_center__history {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Availability" in Explore.

  dimension: availability {
    type: string
    description: "Field indicating, if a product is in stock or out-of-stock"
    sql: availability ;;
  }

  dimension: channel {
    type: string
    description: "Marketing channel category."
    sql: channel ;;
  }

  dimension: condition {
    type: string
    description: "Applied condition within the Google Merchant Center"
    sql: condition ;;
  }

  dimension: content_language {
    type: string
    description: "The language of the marketing content"
    sql: content_language ;;
  }

  dimension: currency {
    type: string
    description: "Currency ISO code."
    sql: currency ;;
  }

  dimension: destinations__destination_approved_countries {
    type: string
    description: "List of countries, the product is approved for in Google Merchant Center"
    sql: ${TABLE}.destinations.destination_approved_countries ;;
    group_label: "Destinations"
    group_item_label: "Destination Approved Countries"
  }

  dimension: destinations__destination_disapproved_countries {
    type: string
    description: "List of contries, the product was rejected in Google Merchant Center"
    sql: ${TABLE}.destinations.destination_disapproved_countries ;;
    group_label: "Destinations"
    group_item_label: "Destination Disapproved Countries"
  }

  dimension: destinations__destination_name {
    type: string
    description: "Name of the destination of a product in Google Merchant Center"
    sql: ${TABLE}.destinations.destination_name ;;
    group_label: "Destinations"
    group_item_label: "Destination Name"
  }

  dimension: destinations__destination_pending_countries {
    type: string
    description: "List of countries, the product aproval is pending in Google Merchant Center"
    sql: ${TABLE}.destinations.destination_pending_countries ;;
    group_label: "Destinations"
    group_item_label: "Destination Pending Countries"
  }

  dimension: destinations__destination_status {
    type: string
    description: "Status of the integration to a destination of a product in Google Merchant Center"
    sql: ${TABLE}.destinations.destination_status ;;
    group_label: "Destinations"
    group_item_label: "Destination Status"
  }

  dimension: flink_cateogry {
    type: string
    description: "Name of the category to which product was assigned, (not ERP category)."
    sql: flink_cateogry ;;
  }

  dimension: flink_subcategory {
    type: string
    description: "Name of the subcategory to which product was assigned, (not ERP subcategory)."
    sql: flink_subcategory ;;
  }

  dimension: google_brand_id {
    type: string
    description: "Brand ID according to Google Merchant Center"
    sql: google_brand_id ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: google_expiration {
    type: time
    description: "Timestamp, when the uploaded product data gets invalid in the Google Merchant Center"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: google_expiration_timestamp ;;
  }

  # This field is hidden, which means it will not show up in Explore.
  # If you want this field to be displayed, remove "hidden: yes".

  dimension: google_merchant_center__history {
    type: string
    description: "A bigquery array of structs object, that provides an ordered list of all modifications of a given table in Oracle."
    hidden: yes
    sql: google_merchant_center__history ;;
  }

  dimension: google_product_category_full {
    type: string
    description: "The full categorisation of a product according to Google Merchant Center (Level 1 Category >> Level 2 Category >> ...)"
    sql: google_product_category_full ;;
  }

  dimension: google_product_category_id {
    type: number
    description: "ID of the Google Merchant Center-defined product category"
    sql: google_product_category_id ;;
  }

  dimension: google_product_category_level_1 {
    type: string
    description: "Level 1 of the categorisation of a product according to the Google Merchant Center"
    sql: google_product_category_level_1 ;;
  }

  dimension: google_product_category_level_2 {
    type: string
    description: "Level 2 of the categorisation of a product according to the Google Merchant Center"
    sql: google_product_category_level_2 ;;
  }

  dimension: google_product_category_level_3 {
    type: string
    description: "Level 3 of the categorisation of a product according to the Google Merchant Center"
    sql: google_product_category_level_3 ;;
  }

  dimension: gtin {
    type: string
    description: "Global Trade Item Number is an identifier for trade items."
    sql: gtin ;;
  }

  dimension: issues__issue_applicable_countries {
    type: string
    description: "List of countries, the issue in Google Merchant Center applies to"
    sql: ${TABLE}.issues.issue_applicable_countries ;;
    group_label: "Issues"
    group_item_label: "Issue Applicable Countries"
  }

  dimension: issues__issue_attribute_name {
    type: string
    description: "Attribute names for the issue in Google Merchant Center"
    sql: ${TABLE}.issues.issue_attribute_name ;;
    group_label: "Issues"
    group_item_label: "Issue Attribute Name"
  }

  dimension: issues__issue_code {
    type: string
    description: "Issue code of a rejected item in Google Merchant Center"
    sql: ${TABLE}.issues.issue_code ;;
    group_label: "Issues"
    group_item_label: "Issue Code"
  }

  dimension: issues__issue_destination {
    type: string
    description: "Destination, that is affected by the issue in Google Merchant Center"
    sql: ${TABLE}.issues.issue_destination ;;
    group_label: "Issues"
    group_item_label: "Issue Destination"
  }

  dimension: issues__issue_detailed_description {
    type: string
    description: "Detailed description of the issue in Google Merchant Center"
    sql: ${TABLE}.issues.issue_detailed_description ;;
    group_label: "Issues"
    group_item_label: "Issue Detailed Description"
  }

  dimension: issues__issue_documentation {
    type: string
    description: "Link to the documentation page for the issue in Google Merchant Center"
    sql: ${TABLE}.issues.issue_documentation ;;
    group_label: "Issues"
    group_item_label: "Issue Documentation"
  }

  dimension: issues__issue_resolution {
    type: string
    description: "Information on who to solve the issue in Google Merchant Center"
    sql: ${TABLE}.issues.issue_resolution ;;
    group_label: "Issues"
    group_item_label: "Issue Resolution"
  }

  dimension: issues__issue_servability {
    type: string
    description: "Information whether products are still servable in Google Merchant Center given the issue"
    sql: ${TABLE}.issues.issue_servability ;;
    group_label: "Issues"
    group_item_label: "Issue Servability"
  }

  dimension: issues__issue_short_description {
    type: string
    description: "Short description of the issue in Google Merchant Center"
    sql: ${TABLE}.issues.issue_short_description ;;
    group_label: "Issues"
    group_item_label: "Issue Short Description"
  }

  dimension: number_of_google_categories {
    type: number
    description: "The number of categories levels defined by Google Merchant Center"
    sql: number_of_google_categories ;;
  }

  dimension: original_price {
    type: number
    description: "Gross price of a product, including the deposit value."
    sql: original_price ;;
  }

  dimension: price_class {
    type: string
    description: "Price classification for a product (currently more/less than 10 EUR )"
    sql: price_class ;;
  }

  dimension: product_brand {
    type: string
    description: "Brand a product belongs to."
    sql: product_brand ;;
  }

  dimension: product_deep_link {
    type: string
    description: "Link to the Flink-webpage for a given product"
    sql: product_deep_link ;;
  }

  dimension: product_description {
    type: string
    description: "The description of a product in CommerceTools"
    sql: product_description ;;
  }

  dimension: product_image_link {
    type: string
    description: "Link to the destination, where the image of a product is stored"
    sql: product_image_link ;;
  }

  dimension: product_name {
    type: string
    description: "Name of the product, as specified in the backend."
    sql: product_name ;;
  }

  dimension_group: product_upload {
    type: time
    description: "Timestamp, when the product data was uploaded to Google Merchant Center"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: product_upload_timestamp ;;
  }

  dimension: selling_price {
    type: number
    description: "Price of the product for which user bought an item, also includes discounted values (including VAT)."
    sql: selling_price ;;
  }
}
