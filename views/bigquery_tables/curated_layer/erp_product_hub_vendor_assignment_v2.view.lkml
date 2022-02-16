view: erp_product_hub_vendor_assignment_v2 {
  sql_table_name: `flink-data-prod.curated.erp_product_hub_vendor_assignment_v2`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set: join_fields {
    fields: [
      report_date,
      hub_code,
      sku,
      vendor_id
    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========

  # - - - - - - - - - - - - - START: Item-Level Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: edi {

    label:       "EDI"
    description: "The buying ID for an item in Lexbizz"
    group_label: "> Item Level ERP Data"

    type: string
    sql: ${TABLE}.edi ;;

  }

  dimension: item_category {

    label:       "Category"
    description: "The category of an item according to Lexbizz"
    group_label: "> Item Level ERP Data"

    type: string
    sql: ${TABLE}.item_category ;;
  }

  dimension: item_name {

    label:       "Name"
    description: "The name of an item according to Lexbizz"
    group_label: "> Item Level ERP Data"

    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: item_replenishment_substitute_group {

    label:       "Replenishment Substitute Group (RSG)"
    description: "The replenishment group of an item according to Lexbizz. Here, multiple SKUs are part of a group - for the replenishment process, it is important to only source ONE of the SKUs in the group"
    group_label: "> Item Level ERP Data"

    type: string
    sql: ${TABLE}.item_replenishment_substitute_group ;;

  }

  dimension: item_status {

    label:       "Item Status"
    description: "The item status of an item according to Lexbizz"
    group_label: "> Item Level ERP Data"

    type: string
    sql: ${TABLE}.item_status ;;

  }

  dimension: item_at_vendor_status {

    label:       "Item at Vendor status"
    description: "The status indicating, if a vendor is supplying the given SKU"
    group_label: "> Item Level ERP Data"

    type: yesno
    sql: ${TABLE}.item_at_vendor_status ;;
  }

  dimension: item_substitute_group {

    label:       "Substitute Group"
    description: "The substitute group of an item according to Lexbizz. Here, multiple SKUs are part of a group - for the customer, it is important to only source ONE of the SKUs in the group in stock"
    group_label: "> Item Level ERP Data"

    type: string
    sql: ${TABLE}.item_substitute_group ;;
  }

  dimension: noos_item {

    label:       "Is NOOS Item"
    description: "Identifier to filter for very important SKUs that should never be out of stock (NOOS) according to Lexbizz"
    group_label: "> Item Level ERP Data"

    type: yesno
    sql: ${TABLE}.noos_item ;;
  }

  dimension: noos_leading_product {

    label:       "Is NOOS Leading Product"
    description: "tbd"
    group_label: "> Item Level ERP Data"

    type: yesno
    sql: ${TABLE}.noos_leading_product ;;
    hidden: yes
  }

  # - - - - - - - - - - - - - END: Item-Level Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




  # - - - - - - - - - - - - - START: Hub-Level Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: hub_id {

    label:       "Hub ID"
    description: "The hub id of a Flink hub according to Lexbizz"
    group_label: "> Hub Level ERP Data"

    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: hub_name {

    label:       "Hub Name"
    description: "The hub name of a Flink hub according to Lexbizz"
    group_label: "> Hub Level ERP Data"

    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: hub_type {

    label:       "Hub Type"
    description: "The hub type of a Flink hub according to Lexbizz - the type is dependent on the size and is classified in t-shirt sizes"
    group_label: "> Hub Level ERP Data"

    type: string
    sql: ${TABLE}.hub_type ;;
  }
  dimension: is_hub_active {

    label:       "Is Hub Active"
    description: "Boolean, that indicates, if a hub is active according to Lexbizz"
    group_label: "> Hub Level ERP Data"

    type: yesno
    sql: ${TABLE}.is_hub_active ;;
  }

  # - - - - - - - - - - - - -   END: Hub-Level Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




  # - - - - - - - - - - - - - START: Warehouse-Level Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: warehouse_id {

    label:       "Warehouse ID"
    description: "ID of a vendors warehouse according to Lexbizz"
    group_label: "> Warehouse Level ERP Data"

    type: string
    sql: ${TABLE}.warehouse_id ;;
  }

  dimension: warehouse_name {

    label:       "Warehouse Name"
    description: "Name of a vendors warehouse according to Lexbizz"
    group_label: "> Warehouse Level ERP Data"

    type: string
    sql: ${TABLE}.warehouse_name ;;
  }

  dimension: is_warehouse_active {

    label:       "Is Warehouse Active"
    description: "Boolean, that indicates, if a vendors warehouse is active according to Lexbizz and thus delivers to related Flink hubs"
    group_label: "> Warehouse Level ERP Data"

    type: yesno
    sql: ${TABLE}.is_warehouse_active ;;
  }



  dimension: item_at_warehouse_status {

    label:       "Item at Warehouse Status"
    description: "Status, that defines, if a given SKU is stored in a suppliers warehouse and thus can be delivered to Flink hubs."
    group_label: "> Warehouse Level ERP Data"

    type: string
    sql: ${TABLE}.item_at_warehouse_status ;;
  }
  # - - - - - - - - - - - - -   END: Warehouse-Level Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




  # - - - - - - - - - - - - - START: Vendor-Level Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: vendor_class {

    label:       "Vendor Class"
    description: "Classification of a vendor according to lexbizz"
    group_label: "> Vendor Level ERP Data"

    type: string
    sql: ${TABLE}.vendor_class ;;
  }

  dimension: vendor_id {

    label:       "Vendor ID"
    description: "Identifier of a vendor in lexbizz"
    group_label: "> Vendor Level ERP Data"

    type: string
    sql: ${TABLE}.vendor_id ;;
  }

  dimension: vendor_location {

    label:       "Vendor Location ID"
    description: "Identifier of a vendors location according to lexbizz"
    group_label: "> Vendor Level ERP Data"

    type: string
    sql: ${TABLE}.vendor_location ;;
  }

  dimension: vendor_name {

    label:       "Vendor Name"
    description: "Name of a vendor in lexbizz"
    group_label: "> Vendor Level ERP Data"

    type: string
    sql: ${TABLE}.vendor_name ;;
  }

  dimension: vendor_status {

    label:       "Vendor Status"
    description: "Status of a vendor according to lexbizz - it determines, whether a vendor is actively supplying to Flink"
    group_label: "> Vendor Level ERP Data"

    type: string
    sql: ${TABLE}.vendor_status ;;
  }
  # - - - - - - - - - - - - -   END: Vendor-Level Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




  # - - - - - - - - - - - - - START: Pricing Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: currency {

    required_access_grants: [can_view_buying_information]

    label:       "Curreny"
    description: "The currency of the buying price in lexbizz"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: is_promotional {

    required_access_grants: [can_view_buying_information]

    label:       "Is Price Promotional"
    description: "Boolean indicating, if the buying price in lexbizz is part of a promotion"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: yesno
    sql: ${TABLE}.is_promotional ;;
  }

  dimension_group: valid_from {

    required_access_grants: [can_view_buying_information]

    label:       "Price Valid From"
    description: "The start date, from which the buying price in lexbizz is valid"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.valid_from_date ;;
  }

  dimension_group: valid_to {

    required_access_grants: [can_view_buying_information]

    label:       "Price Valid To"
    description: "The end date, to which the buying price in lexbizz is valid"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.valid_to_date ;;
  }


  dimension: price_per_unit {

    required_access_grants: [can_view_buying_information]

    label:       "Buying Price per Unit"
    description: "The buying price per unit"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: number
    sql: ${TABLE}.price_per_unit ;;
  }

  dimension: price_unit {

    required_access_grants: [can_view_buying_information]

    label:       "Buying Price Unit"
    description: "The unit, for which the Buying Price is valid "
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: number
    sql: ${TABLE}.price_unit ;;
  }


  dimension: unit_of_measure {

    required_access_grants: [can_view_buying_information]

    label:       "Unit of Measure"
    description: "Identifier to filter for very important SKUs that should never be out of stock (NOOS) according to Lexbizz"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: string
    sql: ${TABLE}.unit_of_measure ;;

  }

  measure: avg_vendor_price {

    required_access_grants: [can_view_buying_information]

    label:       "AVG Buying Price"
    description: "The average buying price"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: average
    sql: ${price_per_unit} ;;

    value_format_name: decimal_4
  }
  # - - - - - - - - - - - - -   END: Pricing Data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




  # =========  hidden   =========
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }


  dimension_group: report {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
    hidden: yes
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    hidden: yes
  }





  # =========  IDs   =========

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


















  measure: count {
    type: count
    drill_fields: [hub_name, vendor_name, item_name, warehouse_name]
  }
}
