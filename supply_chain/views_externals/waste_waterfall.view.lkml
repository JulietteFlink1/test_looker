# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around waste waterfall bucketing created by the Supply Chain Performance team

view: waste_waterfall {
  sql_table_name: `flink-supplychain-prod.curated.waste_waterfall`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # =========  __main__   =========

  dimension: bucket {
    type: string
    sql: ${TABLE}.bucket ;;
    label: "Bucket"
    group_label: ""
    description: "Bucket allocated to product-location for waste topics"
    hidden: no
  }

  dimension: delisted_flag {
    type: number
    sql: ${TABLE}.delisted_flag ;;
    label: "Delisted Flag"
    group_label: "Markers"
    description: "Shows flag for delisted Product-Locations"
    hidden: no
  }

  dimension: erp_demand_planning_master_category {
    type: string
    sql: ${TABLE}.erp_demand_planning_master_category ;;
    label: "Master Category"
    group_label: ""
    description: "Global Master Category for product-location"
    hidden: no
  }

  dimension: erp_product_hub_vendor_assignment_v2_vendor_id {
    type: string
    sql: ${TABLE}.erp_product_hub_vendor_assignment_v2_vendor_id ;;
    label: "Vendor ID"
    group_label: ""
    description: "Vendor ID of product-location"
    hidden: no
  }

  dimension: erp_product_hub_vendor_assignment_v2_vendor_name {
    type: string
    sql: ${TABLE}.erp_product_hub_vendor_assignment_v2_vendor_name ;;
    label: "Vendor Name"
    group_label: ""
    description: "Vendor Name of product-location"
    hidden: no
  }

  dimension: hu_rotation {
    type: number
    sql: ${TABLE}.HU_Rotation ;;
    label: "HU Rotation"
    group_label: ""
    description: "HU Rotation for product-location"
    hidden: no
  }

  dimension: hubs_ct_country_iso {
    type: string
    sql: ${TABLE}.hubs_ct_country_iso ;;
    label: "Country ISO"
    group_label: ""
    description: "Geographical information of product-location"
    hidden: no
  }

  dimension: incorrect_pu_flag {
    type: number
    sql: ${TABLE}.incorrect_PU_flag ;;
    label: "Incorrect PU Flag"
    group_label: "Markers"
    description: "Shows flag for incorrect flag"
    hidden: no
  }

  dimension: inventory_changes_daily_change_reason {
    type: string
    sql: ${TABLE}.inventory_changes_daily_change_reason ;;
    label: "Inventory change reason"
    group_label: ""
    description: "Inventory change reason as per Stock Changelog"
    hidden: no
  }

  dimension: inventory_changes_daily_hub_code {
    type: string
    sql: ${TABLE}.inventory_changes_daily_hub_code ;;
    label: "Hub Code"
    group_label: ""
    description: "Hub Code for Product-Location"
    hidden: no
  }

  dimension_group: inventory_changes_daily_inventory_change_week {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.inventory_changes_daily_inventory_change_week ;;
    label: "Reporting Week"
    group_label: ""
    description: "Reporting week for th Product-Location"
    hidden: no
  }

  dimension: inventory_changes_daily_parent_sku {
    type: string
    sql: cast(${TABLE}.inventory_changes_daily_parent_sku as string) ;;
    label: "Parent SKU"
    group_label: ""
    description: "Parent SKU for Product-Location"
    hidden: no
  }

  dimension: inventory_changes_daily_sku {
    type: number
    sql: ${TABLE}.inventory_changes_daily_sku ;;
    label: "SKU"
    group_label: ""
    description: "SKU for Product-Location"
    hidden: no
  }

  dimension: inventory_changes_daily_sum_outbound_waste_eur {
    type: number
    sql: ${TABLE}.inventory_changes_daily_sum_outbound_waste_eur ;;
    label: "Sum Outbound Waste (eur)"
    group_label: ""
    description: "Amount of Waste for Product-Location"
    hidden: no
  }

  dimension: low_performer {
    type: number
    sql: ${TABLE}.low_performer ;;
    label: "Low performer flag"
    group_label: "Markers"
    description: "Flag for low performing Product-Locations"
    hidden: no
  }

  dimension: over_forecast_flag {
    type: number
    sql: ${TABLE}.over_forecast_flag ;;
    label: "Over Forecast flag"
    group_label: "Markers"
    description: "Flag for over forecasted Product-Location"
    hidden: no
  }

  dimension: over_inbound {
    type: number
    sql: ${TABLE}.over_inbound ;;
    label: "Over Inbound flag"
    group_label: "Markers"
    description: "Flag for over inbounded Product-Location"
    hidden: no
  }

  dimension: products_category {
    type: string
    sql: ${TABLE}.products_category ;;
    label: "Products Category"
    group_label: ""
    description: "Products Category for Product-Location"
    hidden: no
  }

  dimension: promotion_flag {
    type: number
    sql: ${TABLE}.Promotion_flag ;;
    label: "Promotion Flag"
    group_label: "Markers"
    description: "Shows flag for Product-Locations with promotion + waste "
    hidden: no
  }

  dimension: shelf_life {
    type: number
    sql: ${TABLE}.shelf_life ;;
    label: "Shelf Life"
    group_label: ""
    description: "Shelf Life of Product-Location"
    hidden: no
  }

  dimension: sku_hub_day_level_orders_product_name {
    type: string
    sql: ${TABLE}.sku_hub_day_level_orders_product_name ;;
    label: "Orders Product Name"
    group_label: ""
    description: "Orders Product Name for Product-Location"
    hidden: no
  }

  dimension: sl1_too_early_flag {
    type: number
    sql: ${TABLE}.SL1_Too_early_flag ;;
    label: "Too Early Flag"
    group_label: "Markers"
    description: "Too Early Flag for Product-Location"
    hidden: no
  }

  dimension: too_early_out_slgreater1_flag {
    type: number
    sql: ${TABLE}.too_early_out_SLgreater1_flag ;;
    label: "Too Early Outbound SL>1 flag"
    group_label: ""
    description: "Too Early Outbound SL>1 flag for Product-Location"
    hidden: no
  }

  dimension: volatility_index {
    type: number
    sql: ${TABLE}.volatility_index ;;
    label: "Volatility Index"
    group_label: ""
    description: "Volatility index for Product-Location"
    hidden: no
  }

  dimension: week {
    type: number
    sql: ${TABLE}.Week ;;
    label: "Week Number"
    group_label: "Week number for Product-Locations registered in waste"
    hidden: no
  }

  measure: count {
    type: count
    drill_fields: [erp_product_hub_vendor_assignment_v2_vendor_name, sku_hub_day_level_orders_product_name]
  }
}
