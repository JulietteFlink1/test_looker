# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around waste waterfall bucketing created by the Supply Chain Performance team on a daily level


view: waste_waterfall_daily {
  sql_table_name: `flink-supplychain-prod.curated.waste_waterfall_daily` ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


 dimension: bucket {
  type: string
  sql: ${TABLE}.bucket ;;
  label: "Bucket (Daily level)"
  description: "Bucket allocated to product-location for waste topics based on MECE Logic (mutually exclusive and collectively exhaustive)"
  hidden: no
}

 dimension: country_iso {
  type: string
  sql: ${TABLE}.country_iso ;;
  label: "Country ISO"
  description: "Geographical information of Product-Location"
  hidden: no
}

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    label: "Products Category"
    description: "Products Category for Product-Location"
    hidden: no
  }

  dimension: change_reason {
    type: string
    sql: ${TABLE}.change_reason ;;
    label: "Inventory Change Reason"
    description: "Inventory change reason as per Stock Changelog"
    hidden: no
  }

  dimension: erp_vendor_id {
    type: string
    sql: ${TABLE}.erp_vendor_id ;;
    label: "Supplier ID"
    description: "Supplier ID of product-location"
    hidden: no
  }

  dimension: erp_vendor_name {
    type: string
    sql: ${TABLE}.erp_vendor_name ;;
    label: "Supplier Name"
    description: "Supplier Name of product-location"
    hidden: no
  }

  dimension: is_abnormal_pu {
    type: yesno
    sql: ${TABLE}.flag_abnormal_pu ;;
    label: "Is Abnormal Purchase Units Flag"
    group_label: "Flags"
    description: "Identifies products which have abnormal purchase units: median purchase units over the last 28 days are smaller than 50% of the purchase units for the report date"
    hidden: no
  }

  dimension: is_aircon_issue {
    type: yesno
    sql: ${TABLE}.flag_aircon_issue ;;
    label: "Is Air-conditioner issue Flag"
    group_label: "Flags"
    description: "Identifies waste caused by air-conditionner issues in spotting abnormal damaged waste on Chocolate as this category is likely to melt when AC issue and high temperature."
    hidden: no
  }

  dimension: is_delisted {
    type: yesno
    sql: ${TABLE}.flag_delisted ;;
    label: "Is Delisted Flag"
    group_label: "Flags"
    description: "Identifies Product-Locations that have been delisted"
    hidden: no
  }

  dimension: is_dry_drinks {
    type: yesno
    sql: ${TABLE}.flag_dry_drinks ;;
    label: "Dry/Drinks Expired Flag"
    group_label: "Flags"
    description: "Identifies remaining expired waste for Dry and Drinks products, as it is not likely to happen often (<0.5% waste target)"
    hidden: no
  }

  dimension: is_fcst_greater_sales {
    type: yesno
    sql: ${TABLE}.flag_fcst_greater_sales ;;
    label: "Is Forecast Greater than Sales Flag"
    group_label: "Flags"
    description: "Identifies if 90% of the total forecast is greater than total corrected sales on a report date level for product-location"
    hidden: no
  }

  dimension: is_freezer_issue {
    type: yesno
    sql: ${TABLE}.flag_freezer_issue ;;
    label: "Fridge/Freezer Breakdown Flag"
    group_label: "Flags"
    description: "Identifies waste caused by a fridge or freezer breakage in spotting abnormal damaged waste on those products (waste > inbound, several sku in damaged...)"
    hidden: no
  }

  dimension: is_frozen {
    type: yesno
    sql: ${TABLE}.flag_frozen ;;
    label: "Is Frozen Expired Flag"
    group_label: "Flags"
    description: "Identifies remaining expired waste for Frozen products, as it is not likely to happen often (<0.5% waste target)"
    hidden: no
  }

  dimension: is_incorrect_pu {
    type: yesno
    sql: ${TABLE}.flag_incorrect_pu ;;
    label: "Is Incorrect Purchase Units Flag"
    group_label: "Flags"
    description: "Identifies product-locations that Have Fill Rate above 150% in more than 10 hubs in that week. 80% of all inbounds must have had an inbound issue"
    hidden: no
  }

  dimension: is_low_performer {
    type: yesno
    sql: ${TABLE}.flag_low_performer ;;
    group_label: "Flags"
    label: "Is Low Performer Flag"
    description: "Identifies that product-locations are showing low performance"
    hidden: no
  }

  dimension: is_over_fcst {
    type: yesno
    sql: ${TABLE}.flag_over_fcst ;;
    label: "Is Over Forecast flag"
    group_label: "Flags"
    description: "Identifies over forecasted Product-Locations"
    hidden: no
  }

  dimension: is_over_inbound {
    type: yesno
    sql: ${TABLE}.flag_over_inbound ;;
    label: "Over Inbound flag"
    group_label: "Flags"
    description: "Identifies over inbounded Product-Locations"
    hidden: no
  }

  dimension: is_promotion {
    type: yesno
    sql: ${TABLE}.flag_promotion ;;
    label: "Is in Promotion Flag"
    group_label: "Flags"
    description: "Identifies Product-Locations with promotion + waste "
    hidden: no
  }

  dimension: is_human_error {
    type: yesno
    sql: ${TABLE}.flag_human_error ;;
    label: "Is Human Error Flag"
    group_label: "Flags"
    description: "Identifies Product-Locations on which an operator did a important positive correction before outbounding the whole quantity "
    hidden: no
  }

  dimension: is_co_mrp {
    type: yesno
    sql: ${TABLE}.flag_co_mrp ;;
    label: "Is Co MRP Flag"
    group_label: "Flags"
    description: "Enables us to track Effective Order Model from Relex (ordering constraint)"
    hidden: no
  }

  dimension: is_sl1_too_early {
    type: yesno
    sql: ${TABLE}.flag_sl1_too_early ;;
    label: "Shelf Life 1 Too Early Flag"
    group_label: "Flags"
    description: "Identifies Shelf Life 1 products outbound expired or Too Good To Go not within the 2h before closing and after 4pm"
    hidden: no
  }

  dimension: is_slgreater1_too_early {
    type: yesno
    sql: ${TABLE}.flag_slgreater1_too_early ;;
    label: "Shelf Life >1 Too Early Flag"
    group_label: "Flags"
    description: "Identifies expired outbound or too good to go outbound before expiry date"
    hidden: no

  }

  dimension: hu_rotation_index {
    type: number
    sql: ${TABLE}.hu_rotation_index ;;
    label: "HU Rotation Index"
    description: "Handling Units Rotation for product-location"
    hidden: no
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
    description: "Hub Code for Product-Location"
    hidden: no
  }

  dimension_group: ingestion {
    type: time
    timeframes: [date, week, month, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
    label: "Ingestion Date"
    description: "Ingestion date of workflow run for the output of the waste waterfall data"
    hidden: no
  }

  dimension: is_noos {
    type: yesno
    sql: ${TABLE}.is_noos ;;
    label: "Is Never Out Of Stock (NOOS)"
    description: "Boolean. Shows if the item-location is marked as an item that should never be out of stock"
    hidden: no
  }

  dimension: master_category {
    type: string
    sql: ${TABLE}.master_category ;;
    label: "Master Category"
    description: "Global Master Category for product-location"
    hidden: no
  }

  dimension: outbound_waste_eur {
    type: number
    sql: ${TABLE}.outbound_waste_eur ;;
    label: "Sum Outbound Waste (EUR)"
    description: "Amount of Waste for Product-Location"
    hidden: no
  }

  dimension: outbound_waste_item {
    type: number
    sql: ${TABLE}.outbound_waste_item ;;
    label: "Sum Outbound Waste (Units)"
    description: "Amount of Items that have been marked as waste for Product-Location"
    hidden: no
  }

  dimension: parent_bucket {
    type: string
    sql: ${TABLE}.parent_bucket ;;
    label: "Parent Bucket"
    description: "Bucket allocated to product-location for waste topics on a parent level"
    hidden: no
  }

  dimension: parent_sku {
    type: string
    sql: ${TABLE}.parent_sku ;;
    label: "Parent SKU"
    description: "Parent SKU for Product-Location"
    hidden: no
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    label: "Product Name"
    description: "Product Name for Product-Location"
    hidden: no
  }

  dimension: is_robbery {
    type: yesno
    sql: ${TABLE}.flag_robbery ;;
    label: "Is Robbery Flag"
    group_label: "Flags"
    description: "Marks potential hub robbery when we saw a high waste peak on several sku for the drinks or Cigarettes."
    hidden: no
  }

  dimension_group: report {
    type: time
    timeframes: [date, week, month, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
    label: "Report Date"
    description: "Reporting date for the Product-Location"
    hidden: no
  }

  dimension: risky_index {
    type: number
    sql: ${TABLE}.risky_index ;;
    label: "Risky Products Index"
    description: "Risky Products' Index for Product-Location"
    hidden: no
  }

  dimension: report_date_dynamic {
    label: "Report Date (Dynamic)"
    datatype: date
    type: date
    sql:
    {% if global_filters_and_parameters.timeframe_picker._parameter_value == 'Date' %}
      ${report_date}
    {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Week' %}
      ${report_week}
    {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Month' %}
      ${report_month}
    {% endif %};;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    label: "SKU"
    description: "SKU for Product-Location"
    hidden: no
  }

}
