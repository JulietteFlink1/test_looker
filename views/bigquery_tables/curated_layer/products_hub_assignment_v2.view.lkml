view: products_hub_assignment_v2 {
  sql_table_name: `flink-data-dev.curated.products_hub_assignment_v2`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: report_date {
    type: date
    datatype: date
    sql: ${TABLE}.report_date ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_most_recent_record {
    type: yesno
    sql: ${TABLE}.is_most_recent_record ;;
  }


  dimension: ct_final_decision_is_sku_assigned_to_hub {
    label: "Is SKU Assigned (CT)"
    type: yesno
    sql: ${TABLE}.ct_final_decision_is_sku_assigned_to_hub ;;
  }

  dimension: erp_final_decision_is_sku_assigned_to_hub {
    label: "Is SKU Assigned (ERP)"
    type: yesno
    sql: ${TABLE}.erp_final_decision_is_sku_assigned_to_hub ;;
  }

  dimension: is_sku_assigned_to_hub {
    label: "Is SKU Assigned (Final)"
    type: yesno
    sql: ${TABLE}.is_sku_assigned_to_hub ;;
  }

  # =========  ERP Data   =========

  dimension: erp_is_hub_active {
    group_label: "ERP Fields"
    type: yesno
    sql: ${TABLE}.erp_is_hub_active ;;
  }

  dimension: erp_is_warehouse_active {
    group_label: "ERP Fields"
    type: yesno
    sql: ${TABLE}.erp_is_warehouse_active ;;
  }

  dimension: erp_item_at_warehouse_status {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_item_at_warehouse_status ;;
  }

  dimension: erp_item_status {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_item_status ;;
  }

  dimension: erp_vendor_id {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_vendor_id ;;
  }

  dimension: erp_vendor_location_id {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_vendor_location_id ;;
    hidden: yes
  }

  dimension: erp_vendor_name {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_vendor_name ;;
  }

  dimension: erp_vendor_status {
    group_label: "ERP Fields"
    type: string
    sql: ${TABLE}.erp_vendor_status ;;
  }

  dimension: leading_sku_replenishment_substitute_group {
    group_label: "ERP Fields"
    label: "Replenishment Group - Leading SKU"
    type: string
    sql: ${TABLE}.leading_sku_replenishment_substitute_group ;;
  }

  dimension: replenishment_substitute_group {
    group_label: "ERP Fields"
    label: "Replenishment Group"
    type: string
    sql: ${TABLE}.replenishment_substitute_group ;;
  }

  dimension: ct_is_published_globally {
    label: "Is Published (CT)"
    type: yesno
    sql: ${TABLE}.ct_is_published_globally ;;
    hidden: no
  }

  dimension: ct_is_published_per_hub {
    label: "Is SKU assigned to Hub (CT)"
    type: yesno
    sql: ${TABLE}.ct_is_published_per_hub ;;
    hidden: no
  }


  # =========  hidden   =========



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

  measure: cnt_unique_skus {
    label: "# unique SKUs"
    type: count_distinct
    sql: ${sku} ;;
  }


}
