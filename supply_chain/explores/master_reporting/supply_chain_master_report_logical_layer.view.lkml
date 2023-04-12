
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

# This calculation is needed in order to get the total quantities inbounded with DESADVs assigned.
# This is because we don't have DESADVs for every Supplier, that's why we need to exclude those inbounds from Suppliers without DESADVs.

  measure: sum_units_inbounded_for_desadv_fill_rate_calculation{
    type: sum
    sql: ${number_of_items_inbounded} ;;
    label: "# Units Inbounded (with DESADVs)"
    group_label: "Inventory Metrics"
    description: "Total number of items inbounded during the inbounding process with DESADVs assigned."
    value_format_name: decimal_1
    filters: [is_dispatch_notifications_assigned_for_inbound_calculation: "yes"]
  }

  measure: pct_fill_rate_desadvs_inbounds{
    type: number
    sql: safe_divide(${sum_units_inbounded_for_desadv_fill_rate_calculation}, ${sum_selling_units_delivered}) ;;
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
    required_access_grants: [can_access_pricing, can_access_pricing_margins]
  }

  measure: avg_buying_price_net {
    type: average
    sql: ${avg_amt_buying_price_net} ;;
    label: "AVG Buying Price Net"
    group_label: "Monetary Metrics"
    description: "Average item buying price net,
    this price comes from Lexbizz and refers to our price towards the vendor - (confidential data)."
    value_format_name: eur
    required_access_grants: [can_access_pricing, can_access_pricing_margins]
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



  measure: sum_of_items_ordered__desadv {
    type: sum
    sql: ${items_ordered__desadv} ;;
    label: "# Delivered Items (DESADVs)"
    # group_label: ""
    description: "Sum of items, that have been delivered according to the dispatch notification (DESADV)"
    value_format_name: decimal_0
  }

  measure: sum_of_items__desadv {
    type: sum
    sql: ${items__desadv} ;;
    label: "# Total Quantity (DESADV)"
    # group_label: ""
    description: "Sum of items, that have been delivered according to the dispatch notification (DESADV)"
    value_format_name: decimal_0
  }


### DESADV <> Inbound
# OTIFIQ

  measure: sum_of_items_otifiq_stric__desadvs {
    type: sum
    sql: ${items_otifiq_stric__desadvs} ;;
    label: "# OTIFIQ Strict (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | OTIFIQ"
    description: "Sum of items, that were delivered on time, in full and in quality (DESADV > Inbound)"
    value_format_name: decimal_0
  }

  measure: share_of_items_otific_stric__desadv_with_sum_of_items_ordered__desadv {
    label: "% OTIFIQ strict (DESADV > Inbound)"
    description: "Share of on time, in full and in quality DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | OTIFIQ"
    type: number
    sql: safe_divide(${sum_of_items_otifiq_stric__desadvs}, ${sum_of_items_ordered__desadv}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_otifiq_relax_lim__desadv  {
    type: sum
    sql: ${items_otifiq_relax_lim__desadv} ;;
    label: "# OTIFIQ Relaxed lim (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | OTIFIQ"
    description: "Sum of items delivered on time and in quality (DESADV > Inbound).
                  An over-delivered quantity is limited to the item quantity stated on the DESADV"
    value_format_name: decimal_0
  }

  measure: share_of_items__otifiq_relax_lim__desadv_with_sum_of_items__desadv {
    label: "% OTIFIQ relaxed quantity lim. (DESADV > Inbound)"
    description: "Relative amount of on time and in quality fulfilled quantities (DESADV > Inbound) compared to overall DESADV quantities, where an overdelivered quantity is limited to the DESADV quantity"
    group_label: "DESADV >> Inbound | OTIFIQ"
    type: number
    sql: safe_divide(${sum_of_items_otifiq_relax_lim__desadv}, ${sum_of_items__desadv}) ;;
    value_format_name: percent_0
  }

# On Time

  measure: sum_of_items_inbounded_on_time__desadv  {
    type: sum
    sql: ${items_inbounded_on_time__desadv} ;;
    label: "# On time delivery (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | On Time"
    description: "Sum of items delivered on time (DESADV > Inbound)"
    value_format_name: decimal_0
  }

  measure: share_of_items_inbounded_on_time__desadv_with_sum_of_items_ordered__desadv {
    label: "% On Time delivery (DESADV > Inbound)"
    description: "Share of on time delivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | On Time"
    type: number
    sql: safe_divide(${sum_of_items_inbounded_on_time__desadv}, ${sum_of_items_ordered__desadv}) ;;
    value_format_name: percent_0
  }

# In Full


  measure: sum_of_items_inbounded_in_full_strict__desadv {
    type: sum
    sql: ${items_inbounded_in_full_strict__desadv} ;;
    label: "# In full delivery (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | In Full"
    description: "Sum of items delivered in full (DESADV > Inbound)"
    value_format_name: decimal_0
  }

  measure: share_of_items_inbounded_in_full_strict__desadv_with_sum_of_items_ordered__desadv {
    label: "% In Full strict (DESADV > Inbound)"
    description: "Share of in full delivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | In Full"
    type: number
    sql: safe_divide(${sum_of_items_inbounded_in_full_strict__desadv}, ${sum_of_items_ordered__desadv}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_inbounded__desadv {
    type: sum
    sql: ${items_inbounded__desadv} ;;
    label: "# Inbounded Items (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | In Full"
    description: "Sum of fullfilled quantities (DESADV > Inbound)"
    value_format_name: decimal_0
  }

  measure: share_of_items_inbounded__desadv_with_sum_of_items__desadv {
    label: "% In Full relaxed (DESADV > Inbound)"
    description: "Relative amount of fullfilled quantities (DESADV > Inbound) compared to overall DESADV quantities "
    group_label: "DESADV >> Inbound | In Full"
    type: number
    sql: safe_divide(${sum_of_items_inbounded__desadv}, ${sum_of_items__desadv}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_inbounded_limited__desadv {
    type: sum
    sql: ${items_inbounded_limited__desadv} ;;
    label: "# Inbounded Items lim. (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | In Full"
    description: "Sum of fullfilled quantities limited (DESADV > Inbound)"
    value_format_name: decimal_0
  }

  measure: share_of_items_inbounded_limited__desadv_with_sum_of_items__desadv {
    label: "% In Full relaxed lim. (DESADV > Inbound)"
    description: "Relative amount of fullfilled quantities (DESADV > Inbound) compared to overall DESADV quantities - limited."
    group_label: "DESADV >> Inbound | In Full"
    type: number
    sql: safe_divide(${sum_of_items_inbounded_limited__desadv}, ${sum_of_items__desadv}) ;;
    value_format_name: percent_0
  }

# In Quality


  measure: sum_of_items_inbounded_in_quality__desadv {
    type: sum
    sql: ${items_inbounded_in_quality__desadv} ;;
    label: "# Inbounded Items in Quality (DESADVs <> Inbounds)"
    group_label: "DESADV >> Inbound | In Quality"
    description: "Sum of items delivered in quality (DESADV > Inbound)"
    value_format_name: decimal_0
  }

  measure:  share_of_items_inbounded_in_quality__desadv_with_sum_of_items_inbounded__desadv {
    label: "% In Quality (DESADV > Inbound)"
    description: "Share of in quality delivered order lines (DESADV > Inbound) compared to all inbounded order lines "
    group_label: "DESADV >> Inbound | In Quality"
    type: number
    sql: safe_divide(${sum_of_items_inbounded_in_quality__desadv}, ${sum_of_items_inbounded__desadv}) ;;
    value_format_name: percent_0
  }

## PO <> Inbounds

  measure: sum_of_items_ordered__po {
    type: sum
    sql: ${items_ordered__po} ;;
    label: "# Ordered Items (PO)"
    # group_label: ""
    description: "Sum of items, that have been ordered"
    value_format_name: decimal_0
  }

  measure: sum_of_items__po {
    type: sum
    sql: ${items__po} ;;
    label: "# Total Quantity (PO)"
    # group_label: ""
    description: "Sum of items, that have been ordered (PO)"
    value_format_name: decimal_0
  }

# OTIFIQ

  measure: sum_of_items_otifiq_stric__po {
    type: sum
    sql: ${items_otifiq_stric__po} ;;
    label: "# OTIFIQ Strict (PO <> Inbounds)"
    group_label: "PO >> Inbound | OTIFIQ"
    description: "Sum of items that were delivered on time, in full and in quality (PO > Inbound) "
    value_format_name: decimal_0
  }

  measure: share_of_items_otifiq_stric__po_with_sum_of_items_ordered__po {
    label: "% OTIFIQ strict (PO > Inbound)"
    description: "Share of on time, in full and in quality order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | OTIFIQ"
    type: number
    sql: safe_divide(${sum_of_items_otifiq_stric__po}, ${sum_of_items_ordered__po}) ;;
    value_format_name: percent_0
  }

  measure: share_of_items_otifiq_relax_lim__po_with_sum_of_items__po {
    label: "% OTIFIQ relaxed quantity lim. (PO > Inbound)"
    description: "Relative amount of on time and in quality fulfilled quantities (PO > Inbound) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> Inbound | OTIFIQ"
    type: number
    sql: safe_divide(${sum_of_items_otifiq_relax_lim__po}, ${sum_of_items__po});;
    value_format_name: percent_0
  }

  measure: sum_of_items_otifiq_relax_lim__po {
    type: sum
    sql: ${items_otifiq_relax_lim__po} ;;
    label: "# OTIFIQ Relaxed lim (PO <> Inbounds)"
    group_label: "PO >> Inbound | OTIFIQ"
    description: "Sum of items delivered on time and in quality (PO > Inbound). An over-delivered quantity is limited to the item quantity stated on the PO"
    value_format_name: decimal_0
  }


  # On Time

  measure: share_of_items_inbounded_on_time__po_with_sum_of_items_ordered__po {
    label: "% On Time delivery (PO > Inbound)"
    description: "Share of on time delivered order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | On Time"
    type: number
    sql: safe_divide(${sum_of_items_inbounded_on_time__po}, ${sum_of_items_ordered__po}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_inbounded_on_time__po {
    type: sum
    sql: ${items_inbounded_on_time__po} ;;
    label: "# On time delivery (PO <> Inbounds)"
    group_label: "PO >> Inbound | On Time"
    description: "Sum of items delivered on time (PO > Inbound)"
    value_format_name: decimal_0
  }


# In Full

  measure: share_of_items_inbounded_in_full_strict__po_with_sum_of_items_ordered__po {
    label: "% In Full strict (PO > Inbound)"
    description: "Share of in full delivered order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | In Full"
    type: number
    sql: safe_divide(${sum_of_items_inbounded_in_full_strict__po}, ${sum_of_items_ordered__po}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_inbounded_in_full_strict__po {
    type: sum
    sql: ${items_inbounded_in_full_strict__po} ;;
    label: "# In full delivery (PO <> Inbounds)"
    group_label: "PO >> Inbound | In Full"
    description: "Sum of items delivered in full (PO > Inbound)"
    value_format_name: decimal_0
  }

  measure: share_of_items_inbounded__po_with_sum_of_items__po {
    label: "% In Full relaxed (PO > Inbound)"
    description: "Relative amount of fullfilled quantities (PO > Inbound) compared to overall ordered quantities "
    group_label: "PO >> Inbound | In Full"
    type: number
    sql: safe_divide(${sum_of_items_inbounded__po} , ${sum_of_items__po});;
    value_format_name: percent_0
  }

  measure: sum_of_items_inbounded__po {
    type: sum
    sql: ${items_inbounded__po} ;;
    label: "# Inbounded Items (PO <> Inbounds)"
    group_label: "PO >> Inbound | In Full"
    description: "Sum of fullfilled quantities (PO > Inbound)"
    value_format_name: decimal_0
  }

  measure: share_of_items_inbounded_limited__po_with_sum_of_items__po {
    label: "% In Full relaxed lim. (PO > Inbound)"
    description: "Relative amount of fullfilled quantities (PO > Inbound) compared to overall ordered quantities limited"
    group_label: "PO >> Inbound | In Full"
    type: number
    sql: safe_divide(${sum_of_items_inbounded_limited__po} , ${sum_of_items__po});;
    value_format_name: percent_0
  }

  measure: sum_of_items_inbounded_limited__po {
    type: sum
    sql: ${items_inbounded_limited__po} ;;
    label: "# Inbounded Items lim (PO <> Inbounds)"
    group_label: "PO >> Inbound | In Full"
    description: "Sum of fullfilled quantities limited (PO > Inbound)"
    value_format_name: decimal_0
  }


## In Quality

  measure:  share_of_items_inbounded_in_quality__po_with_sum_of_items_inbounded__po {
    label: "% In Quality (PO > Inbound)"
    description: "Share of in quality delivered order lines (PO > Inbound) compared to all inbounded order lines"
    group_label: "PO >> Inbound | In Quality"
    type: number
    sql: safe_divide(${sum_of_items_inbounded_in_quality__po}, ${sum_of_items_inbounded__po}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_inbounded_in_quality__po {
    type: sum
    sql: ${items_inbounded_in_quality__po} ;;
    label: "# Inbounded Items in Quality (PO <> Inbounds)"
    group_label: "PO >> Inbound | In Quality"
    description: "Sum of items delivered in quality (PO > Inbound"
    value_format_name: decimal_0
  }


## PO <> DESADVs
##OTIF

  measure: share_of_items_ordered_on_time_in_full__po_desadv_with_sum_of_items_ordered__po {
    label: "% OTIF strict (PO > DESADV)"
    description: "Share of on time and in full order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | OTIF"
    type: number
    sql: safe_divide(${sum_of_items_ordered_on_time_in_full__po_desadv}, ${sum_of_items_ordered__po}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_ordered_on_time_in_full__po_desadv {
    type: sum
    sql: ${items_ordered_on_time_in_full__po_desadv} ;;
    label: "# OTIF strict (PO > DESADV)"
    group_label: "PO >> DESADV | OTIF"
    description: "Sum of items delivered on time and in full (PO > DESADV)"
    value_format_name: decimal_0
  }

  measure: share_of_items_ordered_on_time_limited__po_desadv_with_sum_of_items__po {
    label: "% OTIF relaxed quantity lim. (PO > DESADV)"
    description: "Relative amount of on time fulfilled quantities (PO > DESADV) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> DESADV | OTIF"
    type: number
    sql: safe_divide(${sum_of_items_ordered_on_time_limited__po_desadv}, ${sum_of_items__po}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_ordered_on_time_limited__po_desadv {
    type: sum
    sql: ${items_ordered_on_time_limited__po_desadv} ;;
    label: "# OTIF relaxed quantity lim. (PO > DESADV)"
    group_label: "PO >> DESADV | OTIF"
    description: "Sum of items fulfilled on time (PO > DESADV), An over-delivered quantity is limited to the item quantity stated on the PO"
    value_format_name: decimal_0
  }

## On Time

  measure: share_of_items_ordered_and_delivered_on_time__po_desadv_with_sum_of_items_ordered__po {

    label: "% On Time Delivery (PO > DESADV)"
    description: "Share of on time delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | On Time"
    type: number
    sql: safe_divide(${sum_of_items_ordered_and_delivered_on_time__po_desadv}, ${sum_of_items_ordered__po}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_ordered_and_delivered_on_time__po_desadv {
    type: sum
    sql: ${items_ordered_and_delivered_on_time__po_desadv} ;;
    label: "# On Time Delivery (PO > DESADV)"
    group_label: "PO >> DESADV | On Time"
    description: "Sum of items, that have been ordered and have been delivered at the promised delivery date - (PO > DESADV)"
    value_format_name: decimal_0
  }

## In Full

  measure: share_of_items_ordered_in_full__po_desadv_with_sum_of_items_ordered__po {
    label: "% In Full strict (PO > DESADV)"
    description: "Share of in full delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | In Full"
    type: number
    sql: safe_divide(${sum_of_items_ordered_in_full__po_desadv}, ${sum_of_items_ordered__po}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_ordered_in_full__po_desadv{
    type: sum
    sql: ${items_ordered_in_full__po_desadv} ;;
    label: "# In Full delivery (PO > DESADV)"
    group_label: "PO >> DESADV | In Full"
    description: "Sum of items delivered in full (PO > DESADV)"
    value_format_name: decimal_0
  }

  measure: share_of_items_ordered_desadv_with_po__po_desadv_with_sum_of_items__po {
    label: "% In Full relaxed (PO > DESADV)"
    description: "Relative amount of fullfilled quantities (PO > DESADV) compared to overall ordered quantities "
    group_label: "PO >> DESADV | In Full"
    type: number
    sql: safe_divide(${sum_of_items_ordered_desadv_with_po__po_desadv}, ${sum_of_items__po}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_ordered_desadv_with_po__po_desadv {
    type: sum
    sql: ${items_ordered_desadv_with_po__po_desadv} ;;
    label: "# Filled Quantities (PO > DESADV)"
    group_label: "PO >> DESADV | In Full"
    description: "Sum of fullfilled quantities (PO > DESADV)"
    value_format_name: decimal_0
  }

  measure: share_of_items_ordered_desadv_with_po_limited__po_desadv_with_sum_of_items__po {
    label: "% In Full relaxed lim (PO > DESADV)"
    description: "Relative amount of fullfilled quantities (PO > DESADV) compared to overall ordered quantities limited"
    group_label: "PO >> DESADV | In Full"
    type: number
    sql: safe_divide(${sum_of_items_ordered_desadv_with_po_limited__po_desadv}, ${sum_of_items__po}) ;;
    value_format_name: percent_0
  }

  measure: sum_of_items_ordered_desadv_with_po_limited__po_desadv {
    type: sum
    sql: ${items_ordered_desadv_with_po_limited__po_desadv} ;;
    label: "# Filled Quantities lim. (PO > DESADV)"
    group_label: "PO >> DESADV | In Full"
    description: "Sum of fullfilled quantities limited (PO > DESADV)"
    value_format_name: decimal_0
  }

}
