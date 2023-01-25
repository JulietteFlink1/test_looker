
include: "/supply_chain/explores/master_reporting/supply_chain_master_report.view"

view: +supply_chain_master_report {


############################################################
################## Availability Measures ###################
############################################################

  measure: sum_hours_oos{
    type: sum
    sql: ${number_of_hours_oos} ;;
    label: "# Hours OOS"
    group_label: "Availability Metrics"
    description: "The total number of hours that a SKU was OOS on a particular location"
    value_format_name: decimal_1
  }

  measure: sum_hours_oos_with_cutoff_hours{
    type: sum
    sql: ${number_of_hours_oos_with_cutoff_hours} ;;
    label: "# Hours OOS (With Cutoff)"
    group_label: "Availability Metrics"
    description: "The total number of hours that a SKU was OOS on a particular location (With Cutoff Hours)"
    value_format_name: decimal_1
  }

  measure: sum_hours_open{
    type: sum
    sql: ${number_of_hours_open} ;;
    label: "# Hours Open"
    group_label: "Availability Metrics"
    description: "The total number of hours that a Hub was open"
    value_format_name: decimal_1
  }

  measure: sum_hours_open_with_cutoff_hours{
    type: sum
    sql: ${number_of_hours_open_with_cutoff_hours} ;;
    label: "# Hours Open (With Cutoff)"
    group_label: "Availability Metrics"
    description: "The total number of hours that a Hub was open (With Cutoff Hours)"
    value_format_name: decimal_1
  }

### In Stock / Out of Stock

  measure: pct_out_of_stock {
    type: number
    sql: safe_divide(${sum_hours_oos}, ${sum_hours_open});;
    label: "% Out of Stock"
    group_label: "Availability Metrics"
    description: "Percentage of an SKU not available during the day calculated as (Total Hours OOS / Total Hours Open)"
    value_format_name: percent_1
  }

  measure: pct_in_stock {
    type: number
    sql: 1 - ${pct_out_of_stock};;
    label: "% In Stock"
    group_label: "Availability Metrics"
    description: "Percentage of an SKU available during the day calculated as (1 - % Out of Stock)"
    value_format_name: percent_1
  }

### In Stock / Out of Stock - With Cutoff hours

  measure: pct_out_of_stock_with_cutoff {
    type: number
    sql: safe_divide(${sum_hours_oos_with_cutoff_hours}, ${sum_hours_open_with_cutoff_hours});;
    label: "% Out of Stock (Cutoff Hours)"
    group_label: "Availability Metrics"
    description: "Percentage of an SKU not available during the day calculated as (Total Hours OOS / Total Hours Open) - With Cutoff Hours"
    value_format_name: percent_1
  }

  measure: pct_in_stock_with_cutoff {
    type: number
    sql: 1 - ${pct_out_of_stock_with_cutoff};;
    label: "% In Stock (Cutoff Hours)"
    group_label: "Availability Metrics"
    description: "Percentage of an SKU available during the day calculated as (1 - % Out of Stock) - With Cutoff Hours"
    value_format_name: percent_1
  }


############################################################
##################### Inventory Measures ###################
############################################################

### Inventory

  measure: sum_units_with_delivery_issues{
    type: sum
    sql: ${number_items_with_delivery_issue} ;;
    label: "# Units with Delivery Issues"
    group_label: "Inventory Metrics"
    description: "Total number of items outbounded as waste with the reason (product-delivery-damaged, product-delivery-expired)."
    value_format_name: decimal_1
  }

  measure: sum_units_inbounded{
    type: sum
    sql: ${number_of_items_inbounded} ;;
    label: "# Units Inbounded"
    group_label: "Inventory Metrics"
    description: "Total number of items inbounded during the inbounding process."
    value_format_name: decimal_1
  }

  measure: sum_units_waste{
    type: sum
    sql: ${number_of_items_waste} ;;
    label: "# Units Waste"
    group_label: "Inventory Metrics"
    description: "Total number of items outbounded as waste."
    value_format_name: decimal_1
  }

### DESADVs

  measure: sum_handling_units_delivered{
    type: sum
    sql: ${number_of_handling_units_delivered} ;;
    hidden: yes
    label: "# Units delivered in Hand. U (DESADVs)"
    group_label: "Inventory Metrics"
    description: "Total number of handling units that have been delivered to a hub.
    1 handling unit contains N selling units. The N is defined in the Quantity Per Handling Unit measure"
    value_format_name: decimal_1
  }

  measure: sum_selling_units_delivered{
    type: sum
    sql: ${number_of_selling_units_delivered} ;;
    label: "# Units Delivered in Sell. U (DESADVs)"
    group_label: "Inventory Metrics"
    description: "Total number of selling units that have been delivered to a hub."
    value_format_name: decimal_1
  }

### Purchase Orders

  measure: sum_handling_units_ordered{
    type: sum
    sql: ${number_of_handling_units_ordered} ;;
    hidden: yes
    label: "# Units Ordered in Hand. U (PO)"
    group_label: "Inventory Metrics"
    description: "Total number of handling units that have been ordered in a hub.
    1 handling unit contains N selling units. The N is defined in the Quantity Per Handling Unit measure"
    value_format_name: decimal_1
  }

  measure: sum_selling_units_ordered{
    type: sum
    sql: ${number_of_selling_units_ordered} ;;
    label: "# Units Ordered in Sell. U (PO)"
    group_label: "Inventory Metrics"
    description: "Total number of selling units that have been ordered in a hub."
    value_format_name: decimal_1
  }

### Fill rate

## PO <> Inbounds

  measure: pct_fill_rate_po_inbounds{
    type: number
    sql: safe_divide(${sum_units_inbounded}, ${sum_selling_units_ordered}) ;;
    label: "% Fill Rate (PO<>Inbounds)"
    group_label: "Inventory Metrics"
    description: "The percentage of selling units on a purchase order that were actually inbounded"
    value_format_name: percent_1
  }

## DESADVs <> Inbounds

  measure: pct_fill_rate_desadvs_inbounds{
    type: number
    sql: safe_divide(${sum_units_inbounded}, ${sum_selling_units_delivered}) ;;
    label: "% Fill Rate (DESADVs<>Inbounds)"
    group_label: "Inventory Metrics"
    description: "The percentage of selling units on a dispatch notification that were actually inbounded"
    value_format_name: percent_1
  }


############################################################
####################### Price Measures #####################
############################################################


  measure: sum_amt_total_gmv_selling_price_gross {
    type: sum
    sql: ${amt_total_gmv_selling_price_gross} ;;
    label: "€ GMV (Selling Price Gross Valuation)"
    group_label: "Monetary Metrics"
    description: "Total GMV Gross translated as the total amount Sold in Euro per Hub and Parent SKU (Valuated on Selling Price Gross)"
    value_format_name: eur
  }

  measure: sum_amt_total_gmv_buying_price_net {
    type: sum
    sql: ${amt_total_gmv_buying_price_net} ;;
    label: "€ GMV (Buying Price Net Valuation)"
    group_label: "Monetary Metrics"
    description: "Total GMV Net translated as the total amount Sold in Euro per Hub and Parent SKU (Valuated on Buying Price Net)"
    value_format_name: eur
  }

  measure: sum_amt_waste_selling_price_gross {
    type: sum
    sql: ${amt_waste_selling_price_gross} ;;
    label: "€ Outbound (Waste) Gross - (Selling Price)"
    group_label: "Monetary Metrics"
    description: "Total amount outbounded as waste in euro (Selling Price valuation)
    calculated as 'total quantity waste' * 'selling price gross'."
    value_format_name: eur
  }

  measure: sum_amt_waste_buying_price_net {
    type: sum
    sql: ${amt_waste_buying_price_net} ;;
    label: "€ Outbound (Waste) Net - (Buying Price)"
    group_label: "Monetary Metrics"
    description: "Total amount outbounded as waste in euro (Buying Price valuation)
    calculated as 'total quantity waste' * 'buying price net'."
    value_format_name: eur
    required_access_grants: [can_view_buying_information]
  }

  measure: avg_buying_price_net {
    type: average
    sql: ${avg_amt_buying_price_net} ;;
    label: "AVG Buying Price Net"
    group_label: "Monetary Metrics"
    description: "Average item buying price net,
    this price comes from Lexbizz and refers to our price towards the vendor - (confidential data)."
    value_format_name: eur
    required_access_grants: [can_view_buying_information]
  }

  measure: avg_selling_price_gross {
    type: average
    sql: ${avg_amt_selling_price_gross} ;;
    label: "AVG Selling Price Gross"
    group_label: "Monetary Metrics"
    description: "Average item selling price, refers to the discounted price that users
    see in the app in case is set, otherwise refers to the official price of a SKU (Gross)."
    value_format_name: eur
  }

############################################################
##################### GMV/Waste ############################
############################################################


  measure: sum_items_sold{
    type: sum
    sql: ${number_of_items_sold} ;;
    label: "# Items Sold"
    description: "Total number of units sold"
    value_format_name: decimal_1
  }

# Waste Quote (#Items) - sum of outbounded inventory as waste / number of sold items in the same hub-sku-date combination

  measure: waste_quote  {
  type: number
  sql: safe_divide(${sum_units_waste}, ${sum_items_sold}) ;;
  label: "% Waste Quote (Items)"
  group_label: "Inventory Metrics"
  description: "Share of items outbounded as waste over the total of items sold"
  value_format_name: percent_1
  }

# Waste Ratio (Item - Revenue) - (sum of outbounded inventory as waste * item price) / revenue of sold products in the same hub-sku-date combination

  measure: waste_ratio  {
    type: number
    sql: safe_divide(${sum_amt_waste_selling_price_gross}, ${sum_amt_total_gmv_selling_price_gross}) ;;
    label: "% Waste Ratio (Item-Revenue) - Selling Price Valuation "
    group_label: "Inventory Metrics"
    description: "Ratio of waste over the total GMV Gross - Selling Price Valuation "
    value_format_name: percent_1
  }

  measure: waste_ratio_buying_price  {
    type: number
    sql: safe_divide(${sum_amt_waste_buying_price_net}, ${sum_amt_total_gmv_buying_price_net}) ;;
    label: "% Waste Ratio (Item-Revenue) - Buying Price Valuation "
    group_label: "Inventory Metrics"
    description: "Ratio of waste over the total GMV Gross - Buying Price Valuation "
    value_format_name: percent_1
  }



###################################################
####### Advanced Supplier Matching Measures #######
###################################################



  measure: sum_ordered_items_desadvs {
    type: sum
    sql: ${ordered_items_desadvs} ;;
    label: "# Delivered Items (DESADVs)"
    # group_label: ""
    description: "The number of SKUs, that have been delivered according to the dispatch notification (DESADV)"
  }

  measure: sum_total_quantity_desadvs {
    type: sum
    sql: ${total_quantity_desadvs} ;;
    label: "# Total Quantity (DESADV)"
    # group_label: ""
    description: "The total number of units, that have been delivered according to the dispatch notification (DESADV)"
  }


### DESADV <> Inbound
# OTIFIQ

  measure: sum_otifiq_stric_desadvs {
    type: sum
    sql: ${otifiq_stric_desadvs} ;;
    label: "# OTIFIQ Strict (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | OTIFIQ"
    description: "Number of on time, in full and in quality DESADV lines (DESADV > Inbound)"
  }

  measure: pct_desadv_otifiq_stric {
    label: "% OTIFIQ strict (DESADV > Inbound)"
    description: "Share of on time, in full and in quality DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${sum_otifiq_stric_desadvs}, ${sum_ordered_items_desadvs}) ;;
    value_format_name: percent_0
  }

  measure: sum_quantity_otifiq_relax_lim_desadvs  {
    type: sum
    sql: ${quantity_otifiq_relax_lim_desadvs} ;;
    label: "# OTIFIQ Relaxed lim (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | OTIFIQ"
    description: "Total amount of on time and in quality fulfilled quantities (DESADV > Inbound), where an overdelivered quantity is limited to the DESADV quantity"
  }

  measure: pct_desadv_otifiq_relaxed_limited {
    label: "% OTIFIQ relaxed quantity lim. (DESADV > Inbound)"
    description: "Relative amount of on time and in quality fulfilled quantities (DESADV > Inbound) compared to overall DESADV quantities, where an overdelivered quantity is limited to the DESADV quantity"
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${sum_quantity_otifiq_relax_lim_desadvs}, ${sum_total_quantity_desadvs}) ;;
    value_format_name: percent_0
  }

# On Time

  measure: sum_inbounded_items_on_time_desadvs  {
    type: sum
    sql: ${inbounded_items_on_time_desadvs} ;;
    label: "# On time delivery (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | On Time"
    description: "Number of on time delivered DESADV lines (DESADV > Inbound)"
  }

  measure: pct_desadv_inbounded_items_on_time {
    label: "% On Time delivery (DESADV > Inbound)"
    description: "Share of on time delivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | On Time"

    type: number
    sql: safe_divide(${sum_inbounded_items_on_time_desadvs}, ${sum_ordered_items_desadvs}) ;;
    value_format_name: percent_0
  }

# In Full


  measure: sum_inbounded_in_full_strict_desadvs {
    type: sum
    sql: ${inbounded_in_full_strict_desadvs} ;;
    label: "# In full delivery (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | In Full"
    description: "Number of in full delivered DESADV lines (DESADV > Inbound)"
  }

  measure: pct_desadv_inbounded_in_full {
    label: "% In Full strict (DESADV > Inbound)"
    description: "Share of in full delivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | In Full"

    type: number
    sql: safe_divide(${sum_inbounded_in_full_strict_desadvs}, ${sum_ordered_items_desadvs}) ;;
    value_format_name: percent_0
  }

  measure: sum_quantity_inbounded_desadv {
    type: sum
    sql: ${quantity_inbounded_desadv} ;;
    label: "# Inbounded Items (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | In Full"
    description: "Total amount of fullfilled quantities"
  }

  measure: pct_desadv_fill_rate {
    label: "% In Full relaxed (DESADV > Inbound)"
    description: "Relative amount of fullfilled quantities (DESADV > Inbound) compared to overall DESADV quantities "
    group_label: "DESADV >> Inbound | In Full"

    type: number
    sql: safe_divide(${sum_quantity_inbounded_desadv}, ${sum_total_quantity_desadvs}) ;;
    value_format_name: percent_0
  }

# In Quality


  measure: sum_quantity_inbounded_in_quality_desadv {
    type: sum
    sql: ${quantity_inbounded_in_quality_desadv} ;;
    label: "# Inbounded Items in Quality (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | In Quality"
    description: "Share of in quality delivered order lines"
  }

  measure:  pct_desadv_items_inbounded_in_quality {
    label: "% In Quality (DESADV > Inbound)"
    description: "Share of in quality delivered order lines (DESADV > Inbound) compared to all inbounded order lines "
    group_label: "DESADV >> Inbound | In Quality"

    type: number
    sql: safe_divide(${sum_quantity_inbounded_in_quality_desadv}, ${sum_quantity_inbounded_desadv}) ;;
    value_format_name: percent_0
  }

## PO <> Inbounds

  measure: sum_ordered_item_purchase_order {
    type: sum
    sql: ${ordered_item_purchase_order} ;;
    label: "# Ordered Items (PO)"
    # group_label: ""
    description: "The number of SKUs, that have been ordered"
  }

  measure: sum_total_quantity_purchase_order {
    type: sum
    sql: ${total_quantity_purchase_order} ;;
    label: "# Total Quantity (PO)"
    # group_label: ""
    description: "The total number of units, that have been ordered (PO)"
  }

# OTIFIQ

  measure: sum_otifiq_stric_purchase_order {
    type: sum
    sql: ${otifiq_stric_purchase_order} ;;
    label: "# OTIFIQ Strict (PO <> Inbounds)"
    group_label: "PO >> Inbound | OTIFIQ"
    description: "Number of on time, in full and in quality order lines (PO > Inbound)"
  }

  measure: pct_po_otifiq_stric {
    label: "% OTIFIQ strict (PO > Inbound)"
    description: "Share of on time, in full and in quality order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${sum_otifiq_stric_purchase_order}, ${sum_ordered_item_purchase_order}) ;;
    value_format_name: percent_0
  }

  measure: pct_po_otifiq_relaxed_limited {
    label: "% OTIFIQ relaxed quantity lim. (PO > Inbound)"
    description: "Relative amount of on time and in quality fulfilled quantities (PO > Inbound) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${sum_quantity_otifiq_relax_lim_purchase_order}, ${sum_total_quantity_purchase_order});;
    value_format_name: percent_0
  }

  measure: sum_quantity_otifiq_relax_lim_purchase_order {
    type: sum
    sql: ${quantity_otifiq_relax_lim_purchase_order} ;;
    label: "# OTIFIQ Relaxed lim (PO <> Inbounds)"
    group_label: "PO >> Inbound | OTIFIQ"
    description: "Total amount of on time and in quality fulfilled quantities (PO > Inbound), where an overdelivered quantity is limited to the PO quantity"
  }


  # On Time

  measure: pct_po_inbounded_items_on_time {
    label: "% On Time delivery (PO > Inbound)"
    description: "Share of on time delivered order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | On Time"

    type: number
    sql: safe_divide(${sum_inbounded_items_on_time_purchase_order}, ${sum_ordered_item_purchase_order}) ;;
    value_format_name: percent_0
  }

  measure: sum_inbounded_items_on_time_purchase_order {
    type: sum
    sql: ${inbounded_items_on_time_purchase_order} ;;
    label: "# On time delivery (PO <> Inbounds)"
    group_label: "PO >> Inbound | On Time"
    description: "Number of on time delivered PO lines (PO > Inbound)"
  }


# In Full

  measure: pct_po_inbounded_in_full {
    label: "% In Full strict (PO > Inbound)"
    description: "Share of in full delivered order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | In Full"

    type: number
    sql: safe_divide(${sum_inbounded_in_full_strict_purchase_order}, ${sum_ordered_item_purchase_order}) ;;
    value_format_name: percent_0
  }

  measure: sum_inbounded_in_full_strict_purchase_order {
    type: sum
    sql: ${inbounded_in_full_strict_purchase_order} ;;
    label: "# In full delivery (PO <> Inbounds)"
    group_label: "PO >> Inbound | In Full"
    description: "Number of in full delivered PO lines (PO > Inbound)"
  }

  measure: pct_po_fill_rate {
    label: "% In Full relaxed (PO > Inbound)"
    description: "Relative amount of fullfilled quantities (PO > Inbound) compared to overall ordered quantities "
    group_label: "PO >> Inbound | In Full"

    type: number
    sql: safe_divide(${sum_quantity_inbounded_purchase_order} , ${sum_total_quantity_purchase_order});;
    value_format_name: percent_0
  }

  measure: sum_quantity_inbounded_purchase_order {
    type: sum
    sql: ${quantity_inbounded_purchase_order} ;;
    label: "# Inbounded Items (PO <> Inbounds)"
    group_label: "PO >> Inbound | In Full"
    description: "Total amount of fullfilled quantities (PO > Inbound)"
  }

## In Quality

  measure:  pct_po_items_inbounded_in_quality {
    label: "% In Quality (PO > Inbound)"
    description: "Share of in quality delivered order lines (PO > Inbound) compared to all inbounded order lines"
    group_label: "PO >> Inbound | In Quality"

    type: number
    sql: safe_divide(${sum_quantity_inbounded_in_quality_purchase_order}, ${sum_quantity_inbounded_purchase_order}) ;;
    value_format_name: percent_0
  }

  measure: sum_quantity_inbounded_in_quality_purchase_order {
    type: sum
    sql: ${quantity_inbounded_in_quality_purchase_order} ;;
    label: "# Inbounded Items in Quality (PO <> Inbounds)"
    group_label: "PO >> Inbound | In Quality"
    description: "Share of in quality delivered order lines (PO > Inbound)"
  }


## PO <> DESADVs
##OTIF

  measure: pct_ordered_items_on_time_in_full {
    label: "% OTIF strict (PO > DESADV)"
    description: "Share of on time and in full order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | OTIF"

    type: number
    sql: safe_divide(${sum_ordered_items_on_time_in_full}, ${sum_ordered_item_purchase_order}) ;;
    value_format_name: percent_0
  }

  measure: sum_ordered_items_on_time_in_full {
    type: sum
    sql: ${ordered_items_on_time_in_full} ;;
    label: "# OTIF strict (PO > DESADV)"
    group_label: "PO >> DESADV | OTIF"
    description: "Number of on time and in full order lines (PO > DESADV)"
  }

  measure: pct_ordered_items_quantity_desadv_on_time_in_full_limited {
    label: "% OTIF relaxed quantity lim. (PO > DESADV)"
    description: "Relative amount of on time fulfilled quantities (PO > DESADV) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> DESADV | OTIF"

    type: number
    sql: safe_divide(${sum_ordered_items_quantity_desadv_on_time_limited}, ${sum_total_quantity_purchase_order}) ;;
    value_format_name: percent_0
  }

  measure: sum_ordered_items_quantity_desadv_on_time_limited {
    type: sum
    sql: ${ordered_items_quantity_desadv_on_time_limited} ;;
    label: "# OTIF relaxed quantity lim. (PO > DESADV)"
    group_label: "PO >> DESADV | OTIF"
    description: "Total amount of on time fulfilled quantities (PO > DESADV), where an overdelivered quantity is limited to the PO quantity"
  }

## On Time

  measure: pct_po_desadv_on_time_delivery {

    label: "% On Time Delivery (PO > DESADV)"
    description: "Share of on time delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | On Time"

    type: number
    sql: safe_divide(${sum_ordered_items_delivered_on_time}, ${sum_ordered_item_purchase_order}) ;;
    value_format_name: percent_0
  }

  measure: sum_ordered_items_delivered_on_time {
    type: sum
    sql: ${ordered_items_delivered_on_time} ;;
    label: "# On Time Delivery (PO > DESADV)"
    group_label: "PO >> DESADV | On Time"
    description: "The number of SKUs, that have been ordered and have been delivered at the promised delivery date - (PO > DESADV)"
  }

## In Full

  measure: pct_ordered_items_in_full {
    label: "% In Full strict (PO > DESADV)"
    description: "Share of in full delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | In Full"
    type: number
    sql: safe_divide(${sum_ordered_items_in_full}, ${sum_ordered_item_purchase_order}) ;;
    value_format_name: percent_0
  }

  measure: sum_ordered_items_in_full{
    type: sum
    sql: ${ordered_items_in_full} ;;
    label: "# In Full delivery (PO > DESADV)"
    group_label: "PO >> DESADV | In Full"
    description: "Number of in full delivered order lines (PO > DESADV)"
  }

  measure: pct_ordered_items_quantity_po_desadv_fill_rate {
    label: "% In Full relaxed (PO > DESADV)"
    description: "Relative amount of fullfilled quantities (PO > DESADV) compared to overall ordered quantities "
    group_label: "PO >> DESADV | In Full"

    type: number
    sql: safe_divide(${sum_ordered_items_quantity_desadv_with_po}, ${sum_total_quantity_purchase_order}) ;;
    value_format_name: percent_0
  }

  measure: sum_ordered_items_quantity_desadv_with_po {
    type: sum
    sql: ${ordered_items_quantity_desadv_with_po} ;;
    label: "# Filled Quantities (PO > DESADV)"
    group_label: "PO >> DESADV | In Full"
    description: "Sum of fullfilled quantities (PO > DESADV)"
  }

}
