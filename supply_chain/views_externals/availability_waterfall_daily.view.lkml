# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around availability waterfall bucketing created by the Supply Chain Performance team on a daily level

view: availability_waterfall_daily {
  sql_table_name: `flink-supplychain-prod.availability_waterfall_daily.availability_waterfall`
    ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: bucket {
    type: string
    sql: ${TABLE}.bucket ;;
    label: "Bucket"
    description: "Bucket allocated to product-location for availability topics"
    hidden: no
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    label: "Country ISO"
    description: "Geographical information of Product-Location"
    hidden: yes
  }


  dimension: flag_batch_size_greater_max_op {
    type: number
    sql: ${TABLE}.flag_batch_size_greater_max_op ;;
    group_label: "Flags"
    label: "Batch Size greater than Maximum Order Parameter flag"
    description: "Flag that shows Shelf space restriction, with the condition that the batch size is greater than the maximum order parameter."
    hidden: no
  }

  dimension: flag_delivery_issues {
    type: number
    sql: ${TABLE}.flag_delivery_issues ;;
    group_label: "Flags"
    label: "Flag Delivery Issues"
    description: "Flag that shows if a Product-Locations is having delivery issues."
    hidden: no
  }

  dimension: flag_rewe_oos_supplier_id {
    type: number
    sql: ${TABLE}.flag_rewe_oos_supplier_id ;;
    group_label: "Flags"
    label: "Flag Rewe OOS Supplier ID"
    description: "Flag that marks the majority (>=60%) of supplied hubs where the desadv value was 0 within the 5 days prior to the out of stock date."
    hidden: no
  }

  dimension: flag_discounts {
    type: number
    sql: ${TABLE}.flag_discounts ;;
    label: "Discounts Flag"
    group_label: "Flags"
    description: "Flag that shows if product-location had discounts in the reported day"
    hidden: no
  }

  dimension: flag_evening_inbound {
    type: number
    sql: ${TABLE}.flag_evening_inbound ;;
    label: "Flag Evening Inbound"
    group_label: "Flags"
    description: "Flag that shows if product-location had inbounds in the evening in the reported day"
    hidden: no
  }

  dimension: flag_inbound_issue {
    type: number
    sql: ${TABLE}.flag_inbound_issue ;;
    label: "Flag Inbound Issue"
    group_label: "Flags"
    description: "Flag that shows if product-location had issues with the inbounding process in the reported day"
    hidden: no
  }

  dimension: flag_incorrect_purchase_unit {
    type: number
    sql: ${TABLE}.flag_incorrect_purchase_unit ;;
    label: "Flag Incorrect Purchase Unit"
    group_label: "Flags"
    description: "Flag that shows if product-location had incorrect purchase units assigned"
    hidden: no
  }

  dimension: flag_long_term {
    type: number
    sql: ${TABLE}.flag_long_term ;;
    label: "Flag Long Term Out of Stock"
    group_label: "Flags"
    description: "Flag that shows if product-location was out of stock for long term (greater than 7 days)"
    hidden: no
  }

  dimension: flag_new_hub {
    type: number
    sql: ${TABLE}.flag_new_hub ;;
    label: "Flag New Hub"
    group_label: "Flags"
    description: "Flag that shows if product-location is assigned to a new hub"
    hidden: no
  }

  dimension: flag_new_product_location {
    type: number
    sql: ${TABLE}.flag_new_product_location ;;
    label: "Flag New Product Location"
    group_label: "Flags"
    description: "Flag that shows if product-location has been newly (re)assigned"
    hidden: no
  }

  dimension: flag_no_intro_date {
    type: number
    sql: ${TABLE}.flag_no_intro_date ;;
    label: "Flag No Intro Date"
    group_label: "Flags"
    description: "Flag that shows if product-location had no intro date in the ERP system assigned"
    hidden: no
  }

  dimension: flag_order_delivery_blocks {
    type: number
    sql: ${TABLE}.flag_order_delivery_blocks ;;
    label: "Flag Order Delivery Blocks"
    group_label: "Flags"
    description: "Flag that shows if product-location had an active order delivery block within RELEX in the reported day"
    hidden: no
  }

  dimension: flag_order_issue {
    type: number
    sql: ${TABLE}.flag_order_issue ;;
    label: "Flag Order Issue"
    group_label: "Flags"
    description: "Flag that shows if product-location had issues with the ordering process in the reported day"
    hidden: no
  }

  dimension: flag_parent_inactive_child_active {
    type: number
    sql: ${TABLE}.flag_parent_inactive_child_active ;;
    label: "Flag Parent Inactive Child Active"
    group_label: "Flags"
    description: "Flag that shows if product-location is active on a child SKU level, but inactive on a parent SKU level"
    hidden: no
  }

  dimension: flag_po_inbound_80_pct {
    type: number
    sql: ${TABLE}.flag_po_inbound_80_pct ;;
    label: "Flag PO and Inbound <80%"
    group_label: "Flags"
    description: "Flag that shows if product-location had inbounds less than 80% of the initial quantity specified in the PO"
    hidden: no
  }

  dimension: flag_po_no_inbound_supplier_id {
    type: number
    sql: ${TABLE}.flag_po_no_inbound_supplier_id ;;
    label: "Flag PO and Inbound <80% (Supplier ID level)"
    group_label: "Flags"
    description: "Flag that shows if product-location had inbounds less than 80% of the initial quantity specified in the PO on an aggregated supplier ID level"
    hidden: no
  }

  dimension: flag_really_long_term {
    type: number
    sql: ${TABLE}.flag_really_long_term ;;
    label: "Flag Really Long Term Out of Stock"
    group_label: "Flags"
    description: "Flag that shows if product-location was out of stock for really long term (greater than 14 days)"
    hidden: no
  }

  dimension: flag_rewe_oos_other {
    type: number
    sql: ${TABLE}.flag_rewe_oos_other ;;
    label: "Flag Rewe Out of Stock (Other)"
    group_label: "Flags"
    description: "Flag that shows whether the desadv value was 0 within the 5 days preceding the out of stock date."
    hidden: no
  }

  dimension: flag_sales_greater_than_max_op {
    type: number
    sql: ${TABLE}.flag_sales_greater_than_max_op ;;
    label: "Flag Sales Greater than Maximum Order parameter"
    group_label: "Flags"
    description: "Flag that shows Shelf space restrictions, with the condition that the sales are greater than 2 times versus the maximum order parameter."
    hidden: no
  }


  dimension: flag_sales_grtr_fcst {
    type: number
    sql: ${TABLE}.flag_sales_grtr_fcst ;;
    label: "Flag Sales greater than Forecast"
    group_label: "Flags"
    description: "Flag that shows that the product-location's sales are greater than its forecast in the reported day"
    hidden: no
  }

  dimension: flag_sl1_late_delivery {
    type: number
    sql: ${TABLE}.flag_sl1_late_delivery ;;
    label: "Flag Late Delivery (Shelf Life 1)"
    group_label: "Flags"
    description: "Flag that shows if the shelf life 1 product-location had late deliveries in the reported day"
    hidden: no
  }

  dimension: flag_sl1_late_inbound {
    type: number
    sql: ${TABLE}.flag_sl1_late_inbound ;;
    label: "Flag Late Inbound (Shelf Life 1)"
    group_label: "Flags"
    description: "Flag that shows if the shelf life 1 product-location had late inbounds in the reported day"
    hidden: no
  }

  dimension: flag_sl_greater_1_too_early_outbound {
    type: number
    sql: ${TABLE}.flag_sl_greater_1_too_early_outbound ;;
    label: "Flag Too Early Outbound (Shelf Life 1)"
    group_label: "Flags"
    description: "Flag that shows if the shelf life 1 product-location were outbounded too early in the reported day"
    hidden: no
  }

  dimension: flag_technical_issues {
    type: number
    sql: ${TABLE}.flag_technical_issues ;;
    label: "Flag Technical Issues"
    group_label: "Flags"
    description: "Flag that shows if the product-location had technical issues when the order request was created"
    hidden: no

  }

  dimension: flag_under_forecast {
    type: number
    sql: ${TABLE}.flag_under_forecast ;;
    label: "Flag Under Forecast"
    group_label: "Flags"
    description: "Flag that shows if the product-location was underforecasted within RELEX"
    hidden: no
  }

  dimension: flag_waste_outbound_before_cutoff {
    type: number
    sql: ${TABLE}.flag_waste_outbound_before_cutoff ;;
    label: "Flag Waste Outbound before cutoff"
    group_label: "Flags"
    description: "Flag that shows the product-location is generating waste and at the same time is outbounded before cutoff reported day"
    hidden: no
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    hidden: yes


  }

  dimension: is_active_hub {
    type: string
    sql: ${TABLE}.is_active_hub ;;
    label: "Is active hub "
    description: "Shows if hub is active for product-location"
    hidden: no
  }

  dimension: is_noos {
    type: yesno
    sql: ${TABLE}.is_noos ;;
    label: "Is Never Out of Stock"
    group_label: "Flags"
    description: "Flag that shows if product-location is marked as Never Out of Stock (NOoS)"
    hidden: no
  }

  dimension: lost_sales_eur {
    type: number
    sql: ${TABLE}.lost_sales_eur ;;
    label: "Lost Sales (EUR)"
    description: "Shows the value (in EUR) of the lost revenue due to Out-of-Stock reasons"
    hidden: no
  }

  dimension: lost_sales_units {
    type: number
    sql: ${TABLE}.lost_sales_units ;;
    label: "Lost Sales (Units)"
    description: "Shows the amount of units of the lost revenue due to Out-of-Stock reasons"
    hidden: no

  }

  dimension: parent_bucket {
    type: string
    sql: ${TABLE}.parent_bucket ;;
    label: "Parent bucket"
    description: "Department represented for tackling the availability bucket main issue"
    hidden: no
  }

  dimension: parent_sku {
    type: string
    sql: ${TABLE}.parent_sku ;;
    label: "Parent SKU"
    description: "Product number used for identification"
    hidden: yes

  }

  dimension: rank_basket_starter {
    type: number
    sql: ${TABLE}.rank_basket_starter ;;
    label: "Basket Starter Rank"
    group_label: "Rankers"
    description: "Ranks items in descending order based on the count of orders for items that are first added (rank 1) in the basket"
    hidden: no
  }

  dimension: rank_corrected_sales_eur {
    type: number
    sql: ${TABLE}.rank_corrected_sales_eur ;;
    label: "Corrected Sales (EUR) Rank"
    group_label: "Rankers"
    description: "Ranks items in descending order based on the amount of lost sales for items that are added in the basket"
    hidden: no
  }

  dimension: rank_corrected_sales_units {
    type: number
    sql: ${TABLE}.rank_corrected_sales_units ;;
    label: "Corrected Sales (Units) Rank"
    group_label: "Rankers"
    description: "Ranks items in descending order based on the amount of lost sales units for items that are added in the basket"
    hidden: no
  }

  dimension: rank_sequence_added {
    type: number
    sql: ${TABLE}.rank_sequence_added ;;
    label: "Corrected Sales (Units) Rank"
    group_label: "Rankers"
    description: "Shows the rank of the item-location based on the likehood of the customer adding in the item the basket as first item (per hub ranked) "
    hidden: no
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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
    description: "Shows the report date in BigQuery from the Avalablility Daily Knime flow"
    hidden: no
  }


  dimension: vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
    label: "Supplier ID"
    description: "ID of a supplier/vendor as defined in our ERP system"
    hidden: yes
  }

}
