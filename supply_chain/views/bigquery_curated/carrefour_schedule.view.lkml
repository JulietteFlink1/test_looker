# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team / Commercial (FR Team)

view: carrefour_schedule {
  sql_table_name: `flink-data-prod.curated.carrefour_schedule`
    ;;


########################################################################################################
############################################### Dates ##################################################
########################################################################################################

  dimension_group: assortment_end {
    type: time
    label: "Assortment End"
    group_label: "> Date Dimensions"
    description: "Date until which the assortment is available."
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.assortment_end_date ;;
  }

  dimension_group: ingestion {
    type: time
    label: "Ingestion (Historical Carrefour Schedule)"
    group_label: "> Date Dimensions"
    description: "Date that refers to the historical state of the carrefour-schedule (e.g. what was on the part of the carrefour schedule 1 week ago)"
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
  }

  dimension_group: assortment_start {
    type: time
    label: "Assortment Start"
    group_label: "> Date Dimensions"
    description: "Date from which the assortment is available."
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.assortment_start_date ;;
  }

  dimension_group: order {
    alias: [schedule_emited]
    type: time
    label: "Order"
    group_label: "> Date Dimensions"
    description: "Date at which the item can be ordered."
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: order_week {
    alias: [schedule_emited_week]
    label: "Order Week"
    group_label: "> Date Dimensions"
    type: number
    description: "Week at which the item can be ordered."
    sql: ${TABLE}.order_week ;;
  }

########################################################################################################
################################################ IDs ###################################################
########################################################################################################

  dimension: department_key {
    label: "Department Key"
    group_label: "> IDs"
    type: string
    description: "Carrefour ID of the category."
    sql: ${TABLE}.department_key ;;
  }

  dimension: ifls_key {
    label: "IFLS Key"
    group_label: "> IDs"
    type: string
    description: "IFLS ID (Carrefour identifier)."
    sql: ${TABLE}.ifls_key ;;
  }

  dimension: sender_gln_key {
    label: "Sender GLN Key"
    group_label: "> IDs"
    type: string
    description: "EAN of the sender (Carrefour warehouse)."
    sql: ${TABLE}.sender_gln_key ;;
  }

  dimension: site_gln_key {
    label: "Site GLN Key"
    group_label: "> IDs"
    type: string
    description: "EAN of the receiver (Flink warehouse)."
    sql: ${TABLE}.site_gln_key ;;
  }

  dimension: site_logistic_key {
    label: "Site Logistic Key"
    group_label: "> IDs"
    type: string
    description: "Warehouse code for Carrefour."
    sql: ${TABLE}.site_logistic_key ;;
  }

  dimension: table_uuid {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: warehouse_logistic_key {
    label: "Warehouse Logistic Key"
    group_label: "> IDs"
    type: string
    description: "Warehouse X supplier primary key for Carrefour."
    sql: ${TABLE}.warehouse_logistic_key ;;
  }

  dimension: barcode {
    label: "Barcode/EAN"
    group_label: "> IDs"
    type: string
    description: "Barcode/EAN."
    sql: ${TABLE}.barcode ;;
  }

  dimension: store_set_typology_key {
    label: "Store Set Typology Key"
    group_label: "> IDs"
    type: string
    description: "XXX: Couldn't get a clear meaning about this column."
    sql: ${TABLE}.store_set_typology_key ;;
  }

########################################################################################################
########################################## Geographic ##################################################
########################################################################################################
  dimension: country_iso {
    label: "Country ISO"
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    label: "Hub Code"
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

########################################################################################################
########################################## Numeric Dimension ###########################################
########################################################################################################

  dimension: order_minimum_quantity {
    label: "Order Minimum Quantity"
    group_label: "> Numeric Dimensions"
    type: number
    description: "Minimum quantity that can be ordered."
    sql: ${TABLE}.order_minimum_quantity ;;
  }

  dimension: order_multiplying_factor_quantity {
    label: "Order Multiplying Factor Quantity"
    group_label: "> Numeric Dimensions"
    type: number
    description: "Smallest value in units that can be ordered from Carrefour."
    sql: ${TABLE}.order_multiplying_factor_quantity ;;
  }


  dimension: parcel_outer_unit_quantity {
    label: "Parcel Outer Unit Quantity"
    group_label: "> Numeric Dimensions"
    type: number
    description: "Quantity of items per parcel."
    sql: ${TABLE}.parcel_outer_unit_quantity ;;
  }

  dimension: site_delivery_day_duration {
    label: "Site Delivery Day Duration"
    group_label: "> Numeric Dimensions"
    type: number
    description: "Time in days to deliver the products."
    sql: ${TABLE}.site_delivery_day_duration ;;
  }

  dimension: store_minimum_commercialization_day_duration {
    label: "Store Minimum Commercialization Day Duration"
    group_label: "> Numeric Dimensions"
    type: number
    description: "Store reception use-by period in days."
    sql: ${TABLE}.store_minimum_commercialization_day_duration ;;
  }

########################################################################################################
########################################## Product Dimension ###########################################
########################################################################################################

  dimension: class_group_name {
    label: "Class Group Name"
    group_label: "> Product Dimensions"
    type: string
    description: "Shelf name."
    sql: ${TABLE}.class_group_name ;;
  }

  dimension: class_name {
    label: "Class Name"
    group_label: "> Product Dimensions"
    type: string
    description: "Category/family name."
    sql: ${TABLE}.class_name ;;
  }

  dimension: department_name {
    label: "Department Name"
    group_label: "> Product Dimensions"
    type: string
    description: "Category name."
    sql: ${TABLE}.department_name ;;
  }

  dimension: item_name {
    label: "Item Name"
    group_label: "> Product Dimensions"
    type: string
    description: "Product name."
    sql: ${TABLE}.item_name ;;
  }

  dimension: parent_brand_name {
    label: "Parent Brand Name"
    group_label: "> Product Dimensions"
    type: string
    description: "Brand name."
    sql: ${TABLE}.parent_brand_name ;;
  }

  dimension: parent_sku {
    label: "Parent SKU"
    group_label: "> Product Dimensions"
    type: string
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    sql: ${TABLE}.parent_sku ;;
  }

  dimension: sub_class_name {
    label: "Sub Class Name"
    group_label: "> Product Dimensions"
    type: string
    description: "Sub-category/family name."
    sql: ${TABLE}.sub_class_name ;;
  }

  dimension: vat_rate {
    label: "Vat Rate"
    group_label: "> Product Dimensions"
    type: number
    description: "VAT rate."
    sql: ${TABLE}.vat_rate ;;
  }
########################################################################################################
############################################# Dimension ################################################
########################################################################################################


  dimension: sender_name {
    label: "Sender Name"
    type: string
    description: "Warehouse name for Carrefour."
    sql: ${TABLE}.sender_name ;;
  }

  dimension: site_name {
    label: "Site Name"
    type: string
    description: "Carrefour ID for our warehouses."
    sql: ${TABLE}.site_name ;;
  }

  dimension: week_type_code {
    label: "Week Type Code"
    type: string
    description: "Either I for odd week number or P for even week number."
    sql: ${TABLE}.week_type_code ;;
  }

  dimension: order_week_day_number {
    label: "Order Week Day Number"
    type: number
    description: "Week day at which the item can be ordered. Numbered 1 to 6 for Monday to Saturday."
    sql: ${TABLE}.order_week_day_number ;;
  }

  # https://goflink.atlassian.net/browse/DATA-4661
  dimension: item_width {
    label: "Item Width"
    description: "The width of a product"
    group_label: "> Product Dimensions"

    type: number
    sql:  ${TABLE}.item_width;;
  }

  dimension: item_length {
    label: "Item Length"
    description: "The length of a product"
    group_label: "> Product Dimensions"

    type: number
    sql:  ${TABLE}.item_length;;
  }

  dimension: item_height {
    label: "Item Height"
    description: "The height of a product"
    group_label: "> Product Dimensions"

    type: number
    sql:  ${TABLE}.item_height;;
  }

  dimension: ifls_width {
    label: "Handling Unit Width"
    description: "The width of a handling unit"
    group_label: "> Product Dimensions"

    type: number
    sql:  ${TABLE}.ifls_width;;
  }

  dimension: ifls_height {
    label: "Handling Unit Height"
    description: "The height of a handling unit"
    group_label: "> Product Dimensions"

    type: number
    sql:  ${TABLE}.ifls_height;;
  }

  dimension: ifls_length {
    label: "Handling Unit Length"
    description: "The length of a handling unit"
    group_label: "> Product Dimensions"

    type: number
    sql:  ${TABLE}.ifls_length;;
  }

  dimension: purchase_price {

    required_access_grants: [can_access_pricing, can_access_pricing_margins]

    label: "Buying Price"
    description: "The buying price of a product we sell to the suppliers - this information is hub-specific."
    group_label: "> Numeric Dimensions"

    type: number
    sql: ${TABLE}.purchase_price ;;
    value_format_name: decimal_4
  }

########################################################################################################
########################################### Measures ###################################################
########################################################################################################

  measure: count {
    type: count
    hidden: yes
  }
}
