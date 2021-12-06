view: erp_product_hub_vendor_assignment {
  view_label: "* ERP/Lexbizz data *"
  sql_table_name: `flink-data-prod.curated.erp_product_hub_vendor_assignment`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========

  dimension: erp_vendor_name {
    label: "Vendor Name"
    description: "The vendor of the SKU"
    type: string
    sql: ${TABLE}.erp_vendor_name ;;
  }

  dimension: erp_item_replenishment_substitute_group {
    label: "Replinshment Group (ERP)"
    description: "Defines groups of items, that are considerred equal in terms of replenishment"
    type: string
    sql: ${TABLE}.erp_item_replenishment_substitute_group ;;
  }

  dimension_group: ingestion {
    label: "Assignment"
    description: "The date in time (the historical status), a specifc vendor is/was assigned to deliver a specified SKU to a hub"
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
  }



  # =========  status   =========
  dimension: is_warehouse_active {
    label: "Is Warehouse Active"
    description: "Shows ERP status of a vendors warehouse"
    group_label: ">> ERP status"
    type: yesno
    sql: ${TABLE}.is_warehouse_active ;;
  }

  dimension: item_at_warehouse_status {
    label: "Item @ Warehouse Status (ERP)"
    description: "The status of a specific SKU at a warehouse of a vendor."
    group_label: ">> ERP status"
    type: string
    sql: ${TABLE}.item_at_warehouse_status ;;
  }

  dimension: erp_item_status {
    label: "Item Status (ERP)"
    description: "The status of a product in ERP"
    group_label: ">> ERP status"
    type: string
    sql: ${TABLE}.erp_item_status ;;
  }

  dimension: erp_vendor_status {
    label: "Vendor Status (ERP)"
    description: "The status of the vendor in ERP"
    group_label: ">> ERP status"
    type: string
    sql: ${TABLE}.erp_vendor_status ;;
  }



  # =========  hidden   =========
  dimension: country_iso {
    # only for joining
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: sku {
    # only for joining
    type: string
    sql: ${TABLE}.sku ;;
    hidden: yes
  }

  dimension: hub_code {
    # only for joining
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: is_hub_active {
    label: "Is Hub Active"
    type: yesno
    sql: ${TABLE}.is_hub_active ;;
    hidden: yes
  }

  dimension: erp_hub_name {
    label: "Hub Name (ERP)"
    description: "The hub name as shown in ERP"
    type: string
    sql: ${TABLE}.erp_hub_name ;;
    hidden: yes
  }



  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: erp_hub_id {
    type: string
    sql: ${TABLE}.erp_hub_id ;;
    hidden: yes
  }

  dimension: erp_vendor_id {
    type: string
    sql: ${TABLE}.erp_vendor_id ;;
    hidden: yes
  }

  dimension: erp_warehouse_id {
    label: "Warehouse ID"
    description: "The ID of a warehouse, associated to a vendor. One warehouse can supply to 1-n Flink hubs"
    type: string
    sql: ${TABLE}.erp_warehouse_id ;;
    hidden: no
  }

  dimension: erp_vendor_location_id {
    type: string
    sql: ${TABLE}.erp_vendor_location_id ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: count {
    type: count
  }


}
