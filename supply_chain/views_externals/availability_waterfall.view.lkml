# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around availability waterfall bucketing created by the Supply Chain Performance team


view: availability_waterfall {
  sql_table_name: `flink-supplychain-prod.curated.availability_waterfall_latest`
    ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# =========  __main__   =========

  dimension: block_flag {
    type: number
    sql: ${TABLE}.flag_order_delivery_block ;;
    label: "Block Flag"
    group_label: "Flags"
    description: "Flag to mark order / delivery block flag"
    hidden: no
  }

  dimension: bucket {
    type: string
    sql: ${TABLE}.bucket ;;
    label: "Bucket"
    description: "Bucket allocated to product-location for availability topics"
    hidden: no
  }

  dimension: co_mrp_flag {
    type: number
    sql: ${TABLE}.flag_co_mrp ;;
    label: "CO-MRP Flag"
    group_label: "Flags"
    description: "Flag that shows Product-Location as 'CO-MRP' in Relex Order Type"
    hidden: no
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    label: "Country ISO"
    description: "Geographical information of Product-Location"
    hidden: no
  }

  dimension: country_sum_of_hours_oos {
    type: number
    sql: ${TABLE}.country_sum_of_hours_oos ;;
    label: "Sum # Hours OOS - Country"
    description: "Sum of Hours out of stock based on Knime Raw Availability Data on Country level"
    hidden: no
  }

  dimension: country_sum_of_hours_open {
    type: number
    sql: ${TABLE}.country_sum_of_hours_open ;;
    label: "Sum # Hours Open - Country"
    description: "Sum of Hours out of stock based on Knime Raw Availability Data on Country level"
    hidden: no
  }

  dimension: ct_substitute_group {
    type: string
    sql: ${TABLE}.ct_substitute_group ;;
    label: "Substitute Group CT"
    description: "Substitute Group as shown in CommerceTools"
    hidden: no
  }

  dimension: delivery_issue_flag {
    type: number
    sql: ${TABLE}.flag_delivery_issue ;;
    label: "Delivery Issues Flag"
    group_label: "Flags"
    description: "Flag that shows  if a Product-Locations is having delivery issues"
    hidden: no
  }

  dimension: first_inbound_flag {
    type: number
    sql: ${TABLE}.flag_new_product_location ;;
    label: "First Inbound Flag"
    group_label: "Flags"
    description: "Flag that shows if the Product-Location has had its first inbound in the reporting week. Used for New Product Location bucket"
    hidden: no
  }

  dimension: fr_missing_ods {
    type: number
    sql: ${TABLE}.flag_fr_missing_ods ;;
    label: "FR Missing ODS"
    group_label: "Flags"
    description: "Flag that shows if the Product-Location has been identified as missing in Carrefour Order Delivery Schedule"
    hidden: no
  }

  dimension: frequent_oos_flag {
    type: number
    sql: ${TABLE}.flag_frequent_oos;;
    label: "Frequent OOS Flag"
    group_label: "Flags"
    description: "Flag that shows if the Product-Location has been identified as going OOS at least 3 times in the reporting week"
    hidden: no
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    hidden: no
  }

  dimension: hub_status {
    type: string
    sql: ${TABLE}.flag_hub_status ;;
    label: "Hub Status"
    description: "Shows the status of the hub (ex: hub is active / inactive)"
    hidden: no
  }

  dimension: hubs_ct_is_active_hub {
    type: string
    sql: ${TABLE}.hubs_ct_is_active_hub ;;
    label: "Hubs CT Is Active Hub"
    description: "Shows if hub is active on CommerceTools side"
    hidden: no
  }

  dimension: incorrect_pu_flag {
    type: number
    sql: ${TABLE}.flag_wrong_purchase_units ;;
    label: "Wrong Purchase Units Flag"
    group_label: "Flags"
    description: "Shows if Product Location has Incorrect Purchase Units assigned"
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
    description: "Shows the ingestion date in BQ from the Avalablility Knime flow"
    hidden: no
  }

  dimension: late_inbound_flag {
    type: number
    sql: ${TABLE}.flag_late_inbound ;;
    label: "Late Inbound Flag"
    group_label: "Flags"
    description: "Shows if Product Location has had a late inbound"
    hidden: no
  }

  dimension: long_term_oos_flag {
    type: number
    sql: ${TABLE}.flag_long_term_oos ;;
    label: "Long Term OOS flag"
    group_label: "Flags"
    description: "Shows if the Product Location has has long term Out of stock"
    hidden: no
  }

  dimension: new_hub_flag {
    type: number
    sql: ${TABLE}.flag_new_hub ;;
    label: "New Hub Flag"
    group_label: "Flags"
    description: "Shows if hub is recently created (14 days) -> new hub"
    hidden: no
  }

  dimension: newly_reactived_flag {
    type: number
    sql: ${TABLE}.flag_newly_reactived ;;
    label: "Newly (RE)activated flag"
    group_label: "Flags"
    description: "Shows if the Product Location has been newly (re)activated"
    hidden: no
  }

  dimension: no_inbound_all_hubs_flag {
    type: number
    sql: ${TABLE}.flag_no_inbound_all_hubs ;;
    label: "No Inbound All Hubs Flag"
    group_label: "Flags"
    description: "Shows if there has been no inbound in all hubs for Product Location"
    hidden: no
  }

  dimension: no_orders_flag {
    type: number
    sql: ${TABLE}.flag_no_orders ;;
    label: "No Orders Flag"
    group_label: "Flags"
    description: "Shows if Product Location has had no orders in the week"
    hidden: no
  }

  dimension: oos_hours {
    type: number
    sql: ${TABLE}.oos_hours ;;
    label: "Sum # Hours OOS"
    description: "Sum of Hours out of stock based on Knime Raw Availability Data"
    hidden: no
  }

  dimension: opening_hours {
    type: number
    sql: ${TABLE}.opening_hours ;;
    label: "Sum # Hours Open"
    description: "Sum of Hours out of stock based on Knime Raw Availability Data"
    hidden: no
  }

  dimension: parent_bucket {
    type: string
    sql: ${TABLE}.parent_bucket ;;
    label: "Parent Bucket"
    description: "Department represented for tackling the availability bucket main issue"
    hidden: no
  }

  dimension: parent_category {
    type: string
    sql: ${TABLE}.parent_category ;;
    label: "Parent Category"
    description: "Parent Category of Product Location"
    hidden: no
  }

  dimension: pct_in_stock {
    type: number
    sql: ${TABLE}.pct_in_stock ;;
    label: "% In Stock"
    description: "Percentage In Stock based on Knime Raw Availability Data"
    hidden: no
  }

  dimension: pct_oos {
    type: number
    sql: ${TABLE}.pct_oos ;;
    label: "% Out Of Stock"
    description: "Percentage Out of stock based on Knime Raw Availability Data"
    hidden: no
  }

  dimension: po_inbound_less_80pct_flag {
    type: number
    sql: ${TABLE}.flag_po_inbound_less_80pct ;;
    label: "PO Inbound <80% Flag"
    group_label: "Flags"
    description: "Shows if quantity inbounded was less than 80% compared to PO information for Product Location"
    hidden: no
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    label: "Product Name"
    description: "Product Name based on Knime Raw Availability Data"
    hidden: no
  }

  dimension: promotion_filter {
    type: string
    sql: ${TABLE}.promotion_filter ;;
    label: "Promotion Filter"
    description: "Filter that shows if promotion exists for Availability Product-Locations"
    hidden: no
  }

  dimension: promotion_flag {
    type: number
    sql: ${TABLE}.flag_promotion ;;
    label: "Promotion Flag"
    group_label: "Flags"
    description: "Flag that shows the promotion on Availability Product-Locations"
    hidden: no
  }

  dimension: promotion_no_disc_flag {
    type: number
    sql: ${TABLE}.flag_promotion_no_discount ;;
    label: "Promotion No Discount Flag"
    group_label: "Flags"
    description: "Shows if it fits in Promotion on date with no discount"
    hidden: no
  }

  dimension: really_long_term_oos_flag {
    type: number
    sql: ${TABLE}.flag_really_long_term_oos ;;
    label: "Really Long Term OOS Flag"
    group_label: "Flags"
    description: "Marked if Product Location is 2 weeks out of stock"
    hidden: no
  }

  dimension: replenishment_group {
    type: string
    sql: ${TABLE}.replenishment_group ;;
    label: "Replenishment Group"
    description: "Replenishment substitute group defined by the Supply Chain team to tag substitute products for replenishment."
    hidden: no
  }

  dimension_group: report_week {
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
    label: "Report Week"
    description: "Report Week used to assign the product-location information to buckets"
    hidden: no
  }

  dimension: risky_flag {
    type: number
    sql: ${TABLE}.flag_risky_product ;;
    label: "Volatile Products Flag"
    group_label: "Flags"
    description: "Flag for Volatile Product-Locations"
    hidden: no
  }

  dimension: sales_greater_forecast {
    type: number
    sql: ${TABLE}.flag_sales_greater_forecast ;;
    label: "Sales > Forecast Flag"
    group_label: "Flags"
    description: "Sum of Hours out of stock based on Knime Raw Availability Data on Country level"
    hidden: no
  }

  dimension: sku {
    type: string
    sql: cast(${TABLE}.sku as string) ;;
    label: "SKU"
    description: "product number used for identification"
    hidden: no
  }

  dimension: sl1_too_early_out_flag {
    type: number
    sql: ${TABLE}.flag_sl1_too_early_outbound ;;
    label: "SL1 Too Early Outbound Flag"
    group_label: "Flags"
    description: "Shows if the Shelf Life 1 Product has been outbounded early"
    hidden: no
  }

  dimension: sl1_too_late_inb_flag {
    type: number
    sql: ${TABLE}.flag_sl1_too_late_inbound ;;
    label: "SL1 Too Late Inbounded Flag"
    group_label: "Flags"
    description: "Shows if Shelf Life 1 Product has been inbounded too late"
    hidden: no
  }

  dimension: space_rest_flag {
    type: number
    sql: ${TABLE}.flag_shelf_space_restrictions ;;
    label: "Space Restrictions Flag"
    group_label: "Flags"
    description: "Shows the Product-Locations with Space Restrictions found on RELEX"
    hidden: no
  }

  dimension: sub_category {
    type: string
    sql: ${TABLE}.sub_category ;;
    label: "Sub Category"
    description: "Subcategory of the product, as available in the backend tables."
    hidden: no
  }

  dimension: supplier_id {
    type: string
    sql: ${TABLE}.supplier_id ;;
    label: "Supplier ID"
    description: "ID of a supplier/vendor as define in our ERP system"
    hidden: no
  }

  dimension: supplier_name {
    type: string
    sql: ${TABLE}.supplier_name ;;
    label: "Supplier Name"
    description: "Name of the supplier/vendor of a product (e.g. REWE or Carrefour)."
    hidden: no
  }

  dimension: supplier_oos_flag {
    type: number
    sql: ${TABLE}.flag_supplier_oos ;;
    label: "Supplier Out Of Stock Flag"
    group_label: "Flags"
    description: "Flags the Rewe supplier out of stock"
    hidden: no
  }

  dimension: sl1_too_late_delivery {
    type: number
    sql: ${TABLE}.flag_sl1_late_delivery ;;
    label: "Shelf Life 1 Late Delivery flag"
    group_label: "Flags"
    description: "Flags Shelf Life 1 Late deliveries"
    hidden: no
  }

  dimension: technical_issue_flag {
    type: number
    sql: ${TABLE}.flag_technical_issue ;;
    label: "Technical Issue Flag"
    group_label: "Flags"
    description: "Shows Product-Locations that encountered a technical issue for the week (Order Status = NotSent)"
    hidden: no
  }

  dimension: too_early_out_slgreater1_flag {
    type: number
    sql: ${TABLE}.flag_too_early_outbound_sl_greater1;;
    label: "Too Early Outbounded SL>1 flag"
    group_label: "Flags"
    description: "Flag for Shelf Life 1 Product-Locations that are outbounded too early"
    hidden: no
  }

  dimension: under_fcst_flag {
    type: number
    sql: ${TABLE}.flag_under_forecast ;;
    label: "Under Forecast Flag"
    group_label: "Flags"
    description: "Shows if product-location has been underforecasted in RELEX"
    hidden: no
  }

  dimension: rewe_main {
    type: number
    sql: ${TABLE}.flag_rewe_main ;;
    label: "Rewe Main Flag"
    group_label: "Flags"
    description: "Shows if product-location is part of rewe assortment and out of stock"
    hidden: no
  }

  dimension: flag_discontinued {
    type: number
    sql: ${TABLE}.flag_discontinued ;;
    label: "Discontinued Flag"
    group_label: "Flags"
    description: "Shows if product-location is marked to be discontinued"
    hidden: no
  }

  dimension: zero_inbound_prior_week {
    type: number
    sql: ${TABLE}.flag_zero_inbound_prior_week ;;
    label: "Zero Inbound prior week flag"
    group_label: "Flags"
    description: "Shows if product-location had zero inbounds the prior week"
    hidden: no
  }

  dimension: parent_inactive_child_active {
    type: number
    sql: ${TABLE}.flag_parent_inactive_child_active ;;
    label: "Zero Inbound prior week flag"
    group_label: "Flags"
    description: "Shows if product-location had zero inbounds the prior week"
    hidden: no
  }

  dimension: heavy_discount {
    type: number
    sql: ${TABLE}.flag_heavy_discount ;;
    label: "Heavy Discount flag"
    group_label: "Flags"
    description: "Shows if product-location had heavy discounts in the week"
    hidden: no
  }

  dimension: batch_trigger {
    type: number
    sql: ${TABLE}.flag_batch_trigger ;;
    label: "Batch Trigger flag"
    group_label: "Flags"
    description: "Shows if product-location had a batch trigger in the week"
    hidden: no
  }

  dimension: legacy_supplier_id {
    type: string
    sql: ${TABLE}.legacy_supplier_id ;;
    label: "Legacy Supplier ID"
    description: "Old format of supplier ID"
    hidden: no
  }

  measure: count {
    type: count
    drill_fields: [product_name, supplier_name]
    hidden: yes
  }

}
