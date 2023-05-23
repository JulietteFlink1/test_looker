# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around waste waterfall bucketing created by the Supply Chain Performance team

view: waste_waterfall {
  sql_table_name: `flink-supplychain-prod.curated.waste_waterfall_latest`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # =========  __main__   =========

  dimension: bucket {
    type: string
    sql: ${TABLE}.bucket ;;
    label: "Bucket"
    description: "Bucket allocated to product-location for waste topics"
    hidden: no
  }

  dimension: parent_bucket {
    type: string
    sql: ${TABLE}.parent_bucket ;;
    label: "Parent Bucket"
    description: "Bucket allocated to product-location for waste topics on a parent level"
    hidden: no
  }

  dimension: delisted_flag {
    type: number
    sql: ${TABLE}.flag_delisted ;;
    label: "Delisted Flag"
    group_label: "Markers"
    description: "Shows flag for delisted Product-Locations"
    hidden: no
  }

  dimension: erp_demand_planning_master_category {
    type: string
    sql: ${TABLE}.master_category ;;
    label: "Master Category"
    description: "Global Master Category for product-location"
    hidden: no
  }

  dimension: erp_product_hub_vendor_assignment_v2_vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
    label: "Vendor ID"
    description: "Vendor ID of product-location"
    hidden: no
  }

  dimension: erp_product_hub_vendor_assignment_v2_vendor_name {
    type: string
    sql: ${TABLE}.vendor_name ;;
    label: "Vendor Name"
    description: "Vendor Name of product-location"
    hidden: no
  }

  dimension: hu_rotation {
    type: number
    sql: ${TABLE}.flag_hu_rotation_index ;;
    label: "HU Rotation"
    description: "HU Rotation for product-location"
    hidden: no
  }

  dimension: hubs_ct_country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    label: "Country ISO"
    description: "Geographical information of product-location"
    hidden: no
  }

  dimension: incorrect_pu_flag {
    type: number
    sql: ${TABLE}.flag_incorrect_pu ;;
    label: "Incorrect PU Flag"
    group_label: "Markers"
    description: "Shows flag for incorrect flag"
    hidden: no
  }

  dimension: inventory_changes_daily_change_reason {
    type: string
    sql: ${TABLE}.change_reason ;;
    label: "Inventory change reason"
    description: "Inventory change reason as per Stock Changelog"
    hidden: no
  }

  dimension: inventory_changes_daily_hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
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
    sql: ${TABLE}.report_week ;;
    label: "Reporting Week"
    description: "Reporting week for th Product-Location"
    hidden: no
  }

  dimension: inventory_changes_daily_parent_sku {
    type: string
    sql: cast(${TABLE}.parent_sku as string) ;;
    label: "Parent SKU"
    description: "Parent SKU for Product-Location"
    hidden: no
  }

  dimension: inventory_changes_daily_sku {
    type: number
    sql: ${TABLE}.sku ;;
    label: "SKU"
    description: "SKU for Product-Location"
    hidden: no
  }

  dimension: inventory_changes_daily_sum_outbound_waste_eur {
    type: number
    sql: ${TABLE}.outbound_waste_eur ;;
    label: "Sum Outbound Waste (eur)"
    description: "Amount of Waste for Product-Location"
    hidden: no
  }

  dimension: low_performer {
    type: number
    sql: ${TABLE}.flag_low_performer ;;
    label: "Low performer flag"
    group_label: "Markers"
    description: "Flag that shows low performing Product-Locations"
    hidden: no
  }

  dimension: over_forecast_flag {
    type: number
    sql: ${TABLE}.flag_over_forecast ;;
    label: "Over Forecast flag"
    group_label: "Markers"
    description: "Flag for over forecasted Product-Location"
    hidden: no
  }

  dimension: over_inbound {
    type: number
    sql: ${TABLE}.flag_over_inbound ;;
    label: "Over Inbound flag"
    group_label: "Markers"
    description: "Flag for over inbounded Product-Location"
    hidden: no
  }

  dimension: products_category {
    type: string
    sql: ${TABLE}.category ;;
    label: "Products Category"
    description: "Products Category for Product-Location"
    hidden: no
  }

  dimension: promotion_flag {
    type: number
    sql: ${TABLE}.flag_promotion ;;
    label: "Promotion Flag"
    group_label: "Markers"
    description: "Shows flag for Product-Locations with promotion + waste "
    hidden: no
  }

  dimension: shelf_life {
    type: number
    sql: ${TABLE}.shelf_life ;;
    label: "Shelf Life"
    description: "Shelf Life of Product-Location"
    hidden: no
  }

  dimension: sku_hub_day_level_orders_product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    label: "Orders Product Name"
    description: "Orders Product Name for Product-Location"
    hidden: no
  }

  dimension: sl1_too_early_flag {
    type: number
    sql: ${TABLE}.flag_sl1_too_early ;;
    label: "Too Early Flag"
    group_label: "Markers"
    description: "Too Early Flag for Product-Location"
    hidden: no
  }

  dimension: too_early_out_slgreater1_flag {
    type: number
    sql: ${TABLE}.flag_too_early_out_sl_greater1 ;;
    label: "Too Early Outbound SL>1 flag"
    group_label: "Markers"
    description: "Too Early Outbound SL>1 flag for Product-Location"
    hidden: no
  }

  dimension: volatility_index {
    type: number
    sql: ${TABLE}.flag_risky_product_index ;;
    label: "Risky Product Index Flag"
    group_label: "Markers"
    description: "Flag for Risky Products' Index for Product-Location"
    hidden: no
  }

  dimension: effective_fcst_90_pct {
    type: number
    sql: ${TABLE}.flag_effective_fcst_90_pct ;;
    label: "Effective Forecast <90% flag"
    group_label: "Markers"
    description: "Flag to determine if the Product-Location has recieved on that specific day less than 90% of the defined forecast"
    hidden: no
  }

  dimension: fcst_sales_in_stock {
    type: number
    sql: ${TABLE}.flag_fcst_sales_in_stock ;;
    label: "Forecast Sales in stock flag"
    group_label: "Markers"
    description: "Flag for verifying if existing forecasted sales are still on stock for product-location"
    hidden: no
  }

  dimension: zero_sales_fcst_grt0 {
    type: number
    sql: ${TABLE}.flag_zero_sales_fcst_greater0 ;;
    label: "Zero Sales Forecast Greater 0 flag"
    group_label: "Markers"
    description: "Flag for verifying there no sales but the forecast is greater than 0 for product-location"
    hidden: no
  }

  dimension: flag_freezer_issue {
    type: number
    sql: ${TABLE}.flag_freezer_issue ;;
    label: "Fridge/Freezer Breakdown Flag"
    group_label: "Markers"
    description: "Flag for waste caused by a fridge or freezer breakage in spotting abnormal damaged waste on those products (waste > inbound, several sku in damaged...)"
    hidden: no
  }

  dimension: flag_aircon_issue {
    type: number
    sql: ${TABLE}.flag_aircon_issue ;;
    label: "Air-conditioner issue flag"
    group_label: "Markers"
    description: "Flag for waste caused by air-conditionner issues in spotting abnormal damaged waste on Chocolate as this category is likely to melt when AC issue and high temperature."
    hidden: no
  }

  dimension: flag_dry_drinks {
    type: number
    sql: ${TABLE}.flag_dry_drinks ;;
    label: "Dry/Drinks Expired Flag"
    group_label: "Markers"
    description: "Remainder expired waste for Dry and Drinks products, as it is not likely to happen often (<0.5% waste target)"
    hidden: no
  }

  dimension: flag_missing_outbound {
    type: number
    sql: ${TABLE}.flag_missing_outbound ;;
    label: "Missing Outbound flag"
    group_label: "Markers"
    description: "verifying if there is a missing outbound for product-location"
    hidden: no
  }

  dimension: flag_frozen {
    type: number
    sql: ${TABLE}.flag_frozen ;;
    label: "Frozen Expired Flag"
    group_label: "Markers"
    description: "Remainder expired waste for Frozen products, as it is not likely to happen often (<0.5% waste target)"
    hidden: no
  }

  dimension: flag_abnormal_pu {
    type: number
    sql: ${TABLE}.flag_abnormal_pu ;;
    label: "Abnormal PU Flag"
    group_label: "Markers"
    description: "Flag for when a Purchase Unit changed abnormally on a Purchase Orders vs the median PU over the last 4 weeks"
    hidden: no
  }

  dimension: flag_very_low_performer {
    type: number
    sql: ${TABLE}.flag_very_low_performer ;;
    label: "Very Low Performer Flag"
    group_label: "Markers"
    description: "Same logic that the Low Performer bucket but selecting as Very Low Perf when the Low Performer Index < 0.2. As a reminder, Low Performer product when the index < 1."
    hidden: no
  }


  dimension: week {
    type: number
    sql: ${TABLE}.week_number ;;
    label: "Week Number"
    description: "Week number for Product-Locations registered in waste"
    hidden: no
  }

  dimension_group: ingestion {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ingestion_timestamp ;;
    label: "Ingestion Date"
    description: "Shows the ingestion date in BQ from the Waste Knime flow"
    hidden: no
  }



  measure: count {
    type: count
    drill_fields: [erp_product_hub_vendor_assignment_v2_vendor_name, sku_hub_day_level_orders_product_name]
  }
}
