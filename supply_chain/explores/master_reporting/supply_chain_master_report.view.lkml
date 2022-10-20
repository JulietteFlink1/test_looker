# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team

# Provides data related to the most important Supply Chain KPIs

view: supply_chain_master_report {
  sql_table_name: `flink-data-dev.dbt_lruiz_reporting.supply_chain_master_report`
    ;;

############################################################
################### Date Dimension #########################
############################################################


  dimension_group: report {
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
  }

############################################################
##################### ID Dimension #########################
############################################################

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    primary_key: yes
    hidden: yes
  }

  dimension: vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
    label: "Vendor ID"
    group_label: "IDs"
    description: "The ID of a supplier/vendor as define in our ERP system Lexbizz"
  }

############################################################
###################### Dimension ###########################
############################################################

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    label: "Country ISO"
    group_label: "Geographic Data"
    description: "2-letter country code."
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
    group_label: "Geographic Data"
    description: "Code of a hub identical to back-end source tables."
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
    label: "Hub Name"
    group_label: "Geographic Data"
    description: "Name assigned to a hub based on the combination of country ISO code, city and district."
  }

  dimension: parent_sku {
    type: string
    sql: ${TABLE}.parent_sku ;;
    label: "Parent SKU"
    group_label: "Product Data"
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    label: "Product Name"
    group_label: "Product Data"
    description: "The name of the product, as specified in the backend."
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    label: "Product Category"
    group_label: "Product Data"
    description: "The category of the product, as available in the backend tables."
  }

  dimension: max_shelf_life_days {
    type: number
    sql: ${TABLE}.max_shelf_life_days ;;
    label: "Max Shelf Life (days)"
    group_label: "Product Data"
    description: "The sku's max amount of days on shelf."
  }

  dimension: vendor_name {
    type: string
    sql: ${TABLE}.vendor_name ;;
    label: "Vendor Name"
    group_label: "Product Data"
    description: "The name of the supplier/vendor of a product (e.g. REWE or Carrefour)."
}

############################################################
###################### Numeric Dimension ###################
##################          HIDDEN          ################
############################################################
  dimension: number_of_handling_units_delivered {
    type: number
    sql: ${TABLE}.number_of_handling_units_delivered ;;
    hidden: yes
    label: "Units delivered in Hand. U (DESADVs)"
    group_label: "Absolut Metrics"
  }

  dimension: number_of_selling_units_delivered {
    type: number
    sql: ${TABLE}.number_of_selling_units_delivered ;;
    hidden: yes
    label: "Units delivered in Sell. U (DESADVs)"
    group_label: "Absolut Metrics"
  }

  dimension: number_of_handling_units_ordered {
    type: number
    sql: ${TABLE}.number_of_handling_units_ordered ;;
    hidden: yes
    label: "Units Ordered in Hand. U (PO)"
    group_label: "Absolut Metrics"
  }

  dimension: number_of_selling_units_ordered {
    type: number
    sql: ${TABLE}.number_of_selling_units_ordered ;;
    hidden: yes
    label: "Units Ordered in Sell. U (PO)"
    group_label: "Absolut Metrics"
  }

  dimension: number_of_hours_oos {
    type: number
    sql: ${TABLE}.number_of_hours_oos ;;
    hidden: yes
    label: "Number of hours OOS"
    group_label: "Availability Metrics"
  }

  dimension: number_of_hours_oos_with_cutoff_hours {
    type: number
    sql: ${TABLE}.number_of_hours_oos_with_cutoff_hours ;;
    hidden: yes
    label: "Number of hours OOS (With Cutoff)"
    group_label: "Availability Metrics"
  }

  dimension: number_of_hours_open {
    type: number
    sql: ${TABLE}.number_of_hours_open ;;
    hidden: yes
    label: "Number of hours Open"
    group_label: "Availability Metrics"
  }

  dimension: number_of_hours_open_with_cutoff_hours {
    type: number
    sql: ${TABLE}.number_of_hours_open_with_cutoff_hours ;;
    hidden: yes
    label: "# Number of hours Open (With Cutoff)"
    group_label: "Availability Metrics"
  }

  dimension: number_of_items_sold {
    type: number
    sql: ${TABLE}.number_of_items_sold ;;
    hidden: yes
    label: "Number of Items Sold"
    group_label: "GMV Metrics"
  }

  dimension: number_items_with_delivery_issue {
    type: number
    sql: ${TABLE}.number_items_with_delivery_issue ;;
    hidden: yes
    label: " Number of Items with Delivery Issues"
    group_label: "Inventory Metrics"
  }

  dimension: number_of_items_inbounded {
    type: number
    sql: ${TABLE}.number_of_items_inbounded ;;
    hidden: yes
    label: "Number of Items Inbounded"
    group_label: "Inventory Metrics"
  }

  dimension: number_of_items_waste {
    type: number
    sql: ${TABLE}.number_of_items_waste ;;
    hidden: yes
    label: "Number of Items Waste"
    group_label: "Inventory Metrics"
  }
############################################################
###################### Measures ###################
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

#Availability

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

#Availability with cut off

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

### GMV Metrics

  measure: sum_items_sold{
    type: sum
    sql: ${number_of_items_sold} ;;
    label: "# Items Sold"
    description: "Total number of units sold"


    value_format_name: decimal_1
  }

### Inventory Metrics

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

## Fill rate

  measure: pct_fill_rate_po_inbounds{
    type: number
    sql: safe_divide(${sum_units_inbounded}, ${sum_selling_units_ordered}) ;;
    label: "% Fill Rate (PO<>Inbounds)"
    group_label: "Inventory Metrics"
    description: "The percentage of selling units on a purchase order that were actually inbounded"

    value_format_name: percent_1
  }

  measure: pct_fill_rate_desadvs_inbounds{
    type: number
    sql: safe_divide(${sum_units_inbounded}, ${sum_selling_units_delivered}) ;;
    label: "% Fill Rate (DESADVs<>Inbounds)"
    group_label: "Inventory Metrics"
    description: "The percentage of selling units on a dispatch notification that were actually inbounded"

    value_format_name: percent_1
  }

############################################################
################### Monetary Dimension #####################
##############            HIDDEN            ################
############################################################

  dimension: amt_total_gmv_gross {
    type: number
    sql: ${TABLE}.amt_total_gmv_gross ;;
    hidden: yes
    label: "GMV Gross"
    group_label: "Monetary Metrics"
  }

  dimension: amt_waste_selling_price_gross {
    type: number
    sql: ${TABLE}.amt_waste_selling_price_gross ;;
    hidden: yes
    label: "€ Outbound (Waste) Gross"
    group_label: "Monetary Metrics"
  }

  dimension: avg_amt_buying_price_net {
    type: number
    sql: ${TABLE}.avg_amt_buying_price_net ;;
    hidden: yes
    label: "Buying Price Net"
    group_label: "Monetary Metrics"
  }

  dimension: avg_amt_discount_price {
    type: number
    sql: ${TABLE}.avg_amt_discount_price ;;
    hidden: yes
    label: "Discount Price"
    group_label: "Monetary Metrics"
  }

  dimension: avg_amt_product_price_gross {
    type: number
    sql: ${TABLE}.avg_amt_product_price_gross ;;
    hidden: yes
    label: "Product Price Gross"
    group_label: "Monetary Metrics"
  }

  dimension: avg_amt_selling_price_gross {
    type: number
    sql: ${TABLE}.avg_amt_selling_price_gross ;;
    hidden: yes
    label: "Selling Price Gross"
    group_label: "Monetary Metrics"
  }

############################################################
####################### Price Measure ######################
############################################################


  measure: sum_amt_total_gmv_gross {
    type: sum
    sql: ${amt_total_gmv_gross} ;;
    label: "€ GMV Gross"
    group_label: "Monetary Metrics"
    description: "Total GMV Gross translated as the total amount Sold in Euro per Hub and Parent SKU"

    value_format_name: eur
  }

  measure: sum_amt_waste_selling_price_gross {
    type: sum
    sql: ${amt_waste_selling_price_gross} ;;
    label: "€ Outbound (Waste) Gross"
    group_label: "Monetary Metrics"
    description: "Total amount outbounded as waste calculated as
                  ('total quantity waste') * (when we have 'avg_amt_discount_price' if not 'avg_amt_product_price_gross')."

    value_format_name: eur
  }

  measure: avg_buying_price_net {
    type: average
    sql: ${avg_amt_buying_price_net} ;;
    label: "AVG Buying Price Net"
    group_label: "Monetary Metrics"
    description: "Average item buying price net (confidential data)."

    value_format_name: eur

    required_access_grants: [can_view_buying_information]
  }


  measure: avg_discount_price {
    type: average
    sql: ${avg_amt_discount_price} ;;
    label: "AVG Discount Price"
    group_label: "Monetary Metrics"
    description: "Average item discount price."

    value_format_name: eur
  }


  measure: avg_product_price_gross {
    type: average
    sql: ${avg_amt_product_price_gross} ;;
    label: "AVG Product Price Gross"
    group_label: "Monetary Metrics"
    description: "Average product price gross."

    value_format_name: eur
  }


  measure: avg_selling_price_gross {
    type: average
    sql: ${avg_amt_selling_price_gross} ;;
    label: "AVG Selling Price Gross"
    group_label: "Monetary Metrics"
    description: "Average item selling price (Gross)."

    value_format_name: eur
  }



  measure: count {
    type: count
    hidden: yes
    drill_fields: [hub_name, vendor_name, product_name]
  }

}
