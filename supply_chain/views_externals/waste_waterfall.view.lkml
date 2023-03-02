view: waste_waterfall {
  sql_table_name: `flink-supplychain-prod.curated.waste_waterfall`
    ;;

  dimension: bucket {
    type: string
    sql: ${TABLE}.bucket ;;
  }

  dimension: delisted_flag {
    type: number
    sql: ${TABLE}.delisted_flag ;;
  }

  dimension: erp_demand_planning_master_category {
    type: string
    sql: ${TABLE}.erp_demand_planning_master_category ;;
  }

  dimension: erp_product_hub_vendor_assignment_v2_vendor_id {
    type: string
    sql: ${TABLE}.erp_product_hub_vendor_assignment_v2_vendor_id ;;
  }

  dimension: erp_product_hub_vendor_assignment_v2_vendor_name {
    type: string
    sql: ${TABLE}.erp_product_hub_vendor_assignment_v2_vendor_name ;;
  }

  dimension: hu_rotation {
    type: number
    sql: ${TABLE}.HU_Rotation ;;
  }

  dimension: hubs_ct_country_iso {
    type: string
    sql: ${TABLE}.hubs_ct_country_iso ;;
  }

  dimension: incorrect_pu_flag {
    type: number
    sql: ${TABLE}.incorrect_PU_flag ;;
  }

  dimension: inventory_changes_daily_change_reason {
    type: string
    sql: ${TABLE}.inventory_changes_daily_change_reason ;;
  }

  dimension: inventory_changes_daily_hub_code {
    type: string
    sql: ${TABLE}.inventory_changes_daily_hub_code ;;
  }

  dimension_group: inventory_changes_daily_inventory_change_week {
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
    sql: ${TABLE}.inventory_changes_daily_inventory_change_week ;;
  }

  dimension: inventory_changes_daily_parent_sku {
    type: string
    sql: cast(${TABLE}.inventory_changes_daily_parent_sku as string) ;;
  }

  dimension: inventory_changes_daily_sku {
    type: number
    sql: ${TABLE}.inventory_changes_daily_sku ;;
  }

  dimension: inventory_changes_daily_sum_outbound_waste_eur {
    type: number
    sql: ${TABLE}.inventory_changes_daily_sum_outbound_waste_eur ;;
  }

  dimension: low_performer {
    type: number
    sql: ${TABLE}.low_performer ;;
  }

  dimension: over_forecast_flag {
    type: number
    sql: ${TABLE}.over_forecast_flag ;;
  }

  dimension: over_inbound {
    type: number
    sql: ${TABLE}.over_inbound ;;
  }

  dimension: products_category {
    type: string
    sql: ${TABLE}.products_category ;;
  }

  dimension: promotion_flag {
    type: number
    sql: ${TABLE}.Promotion_flag ;;
  }

  dimension: shelf_life {
    type: number
    sql: ${TABLE}.shelf_life ;;
  }

  dimension: sku_hub_day_level_orders_product_name {
    type: string
    sql: ${TABLE}.sku_hub_day_level_orders_product_name ;;
  }

  dimension: sl1_too_early_flag {
    type: number
    sql: ${TABLE}.SL1_Too_early_flag ;;
  }

  dimension: too_early_out_slgreater1_flag {
    type: number
    sql: ${TABLE}.too_early_out_SLgreater1_flag ;;
  }

  dimension: volatility_index {
    type: number
    sql: ${TABLE}.volatility_index ;;
  }

  dimension: week {
    type: number
    sql: ${TABLE}.Week ;;
  }

  measure: count {
    type: count
    drill_fields: [erp_product_hub_vendor_assignment_v2_vendor_name, sku_hub_day_level_orders_product_name]
  }
}
