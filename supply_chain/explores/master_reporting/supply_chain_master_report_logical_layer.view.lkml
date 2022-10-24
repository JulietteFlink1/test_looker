
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
##################### GMV/Waste ####################
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
  description: "Share of items outbounded as waste over the total of items sold"
  value_format_name: percent_1
  }

# Waste Ratio (Item - Revenue) - (sum of outbounded inventory as waste * item price) / revenue of sold products in the same hub-sku-date combination

  measure: waste_ratio  {
    type: number
    sql: safe_divide(${sum_amt_waste_selling_price_gross}, ${sum_amt_total_gmv_selling_price_gross}) ;;
    label: "% Waste Ratio (Item-Revenue) - Selling Price Valuation "
    description: "Ratio of waste over the total GMV Gross - Selling Price Valuation "
    value_format_name: percent_1
  }

  measure: waste_ratio_buying_price  {
    type: number
    sql: safe_divide(${sum_amt_waste_buying_price_net}, ${sum_amt_total_gmv_buying_price_net}) ;;
    label: "% Waste Ratio (Item-Revenue) - Buying Price Valuation "
    description: "Ratio of waste over the total GMV Gross - Buying Price Valuation "
    value_format_name: percent_1
  }

}
