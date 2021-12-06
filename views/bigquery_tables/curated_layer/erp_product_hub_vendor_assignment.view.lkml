view: erp_product_hub_vendor_assignment {
  sql_table_name: `flink-data-prod.curated.erp_product_hub_vendor_assignment`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========

  dimension: erp_vendor_name {
    type: string
    sql: ${TABLE}.erp_vendor_name ;;
  }

  dimension: erp_hub_name {
    type: string
    sql: ${TABLE}.erp_hub_name ;;
  }

  dimension: erp_item_status {
    type: string
    sql: ${TABLE}.erp_item_status ;;
  }

  dimension: erp_vendor_status {
    type: string
    sql: ${TABLE}.erp_vendor_status ;;
  }

  dimension: erp_item_replenishment_substitute_group {
    type: string
    sql: ${TABLE}.erp_item_replenishment_substitute_group ;;
  }

  dimension: is_hub_active {
    type: yesno
    sql: ${TABLE}.is_hub_active ;;
  }

  dimension: is_warehouse_active {
    type: yesno
    sql: ${TABLE}.is_warehouse_active ;;
  }

  dimension: item_at_warehouse_status {
    type: string
    sql: ${TABLE}.item_at_warehouse_status ;;
  }


  dimension_group: ingestion {
    label: "Assignment"
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
