# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team

# Provides data related to the most important Supply Chain KPIs combined in one place:
# Availability
# Fill Rate
# Waste
# GMV

view: supply_chain_master_report {
  sql_table_name: `flink-data-dev.dbt_lruiz_reporting.supply_chain_master_report`
    ;;

set: drill_fields_set {
  fields: [country_iso,
           hub_code,
           product_name,
           product_brand,
           vendor_name,
           parent_sku]
}

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

  dimension: report_date_dynamic {
    label: "Report Date (Dynamic)"
    sql:
    {% if global_filters_and_parameters.timeframe_picker._parameter_value == 'Date' %}
      ${report_date}
    {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Week' %}
      ${report_week}
    {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Month' %}
      ${report_month}
    {% endif %};;
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
    group_label: ""
    description: "The ID of a supplier/vendor as define in our ERP system Lexbizz"
  }

############################################################
###################### Dimension ###########################
############################################################

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    label: "Country ISO"
    group_label: ""
    description: "2-letter country code."
    drill_fields: [drill_fields_set*]
  }

  dimension: country_name {
    type: string
    sql: case
            when ${country_iso} = "DE" then "Germany"
            when ${country_iso} = "NL" then "Netherlands"
            when ${country_iso} = "FR" then "France"
            when ${country_iso} = "AT" then "Austria"
         end ;;
    label: "Country Name"
    group_label: ""
    description: "Country Name."
    map_layer_name: countries
    drill_fields: [drill_fields_set*]
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
    group_label: ""
    description: "Code of a hub identical to back-end source tables."
    drill_fields: [drill_fields_set*]
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
    label: "Hub Name"
    group_label: ""
    description: "Name assigned to a hub based on the combination of country ISO code, city and district."
    drill_fields: [drill_fields_set*]
  }

  dimension: parent_sku {
    type: string
    sql: ${TABLE}.parent_sku ;;
    label: "Parent SKU"
    group_label: ""
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    drill_fields: [drill_fields_set*]
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    label: "Product Name"
    group_label: "Product Data"
    description: "The name of the product, as specified in the backend."
    drill_fields: [drill_fields_set*]
  }

  dimension: max_shelf_life_days {
    type: number
    sql: ${TABLE}.max_shelf_life_days ;;
    label: "Max Shelf Life (days)"
    group_label: ""
    description: "The sku's max amount of days on shelf."
    drill_fields: [drill_fields_set*]
  }

  dimension: vendor_name {
    type: string
    sql: ${TABLE}.vendor_name ;;
    label: "Vendor Name"
    group_label: ""
    description: "The name of the supplier/vendor of a product (e.g. REWE or Carrefour)."
    drill_fields: [drill_fields_set*]
  }

  dimension: erp_category {
    type: string
    sql: ${TABLE}.erp_category ;;
    label: "Product Category (ERP)"
    group_label: "Product Data"
    description: "The category of the product, as available in the backend tables."
    drill_fields: [drill_fields_set*]
  }

  dimension: ct_category {
    type: string
    sql: ${TABLE}.ct_category ;;
    label: "Product Category (CT)"
    group_label: "Product Data"
    description: "Name of the category to which product was assigned, (not ERP category)."
    drill_fields: [drill_fields_set*]
  }

  dimension: erp_subcategory {
    type: string
    sql: ${TABLE}.erp_subcategory ;;
    label: "Product Sub-Category (ERP)"
    group_label: "Product Data"
    description: "The Subcategory of the product, as available in the backend tables."
    drill_fields: [drill_fields_set*]
  }

  dimension: ct_subcategory {
    type: string
    sql: ${TABLE}.ct_subcategory ;;
    label: "Product Sub-Category (CT)"
    group_label: "Product Data"
    description: "Name of the subcategory to which product was assigned, (not ERP subcategory)."
    drill_fields: [drill_fields_set*]
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
    label: "Product Brand (CT)"
    group_label: "Product Data"
    description: "The brand a product belongs to."
    drill_fields: [drill_fields_set*]
  }

  dimension: product_erp_brand {
    type: string
    sql: ${TABLE}.product_erp_brand ;;
    label: "Product Brand (ERP)"
    group_label: "Product Data"
    description: "The brand a product belongs to (ERP)."
    drill_fields: [drill_fields_set*]
  }

  dimension: ct_substitute_group {
    type: string
    sql: ${TABLE}.ct_substitute_group ;;
    label: "Substitute Group (CT)"
    group_label: "Product Data"
    description: "The substitute group according to CommerceTools defining substitute products from the customer perspective."
    drill_fields: [drill_fields_set*]
  }

  dimension: ct_replenishment_substitute_group {
    type: string
    sql: ${TABLE}.ct_replenishment_substitute_group ;;
    label: "Replenishment Substitute Group (CT)"
    group_label: "Product Data"
    description: "The replenishment substitute group defined by the Supply Chain team to tag substitute products for replenishment."
    drill_fields: [drill_fields_set*]
  }

  dimension: erp_substitute_group {
    type: string
    sql: ${TABLE}.erp_substitute_group ;;
    label: "Substitute Group (ERP)"
    group_label: "Product Data"
    description: "The substitute group according to the ERP defining substitute products."
    drill_fields: [drill_fields_set*]
  }

  dimension: erp_replenishment_substitute_group {
    type: string
    sql: ${TABLE}.erp_replenishment_substitute_group ;;
    label: "Replenishment Substitute Group (ERP)"
    group_label: "Product Data"
    description: "The replenishment substitute group defined by the Supply Chain team to tag substitute products for replenishment."
    drill_fields: [drill_fields_set*]
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
################### Monetary Dimension #####################
##############            HIDDEN            ################
############################################################

  dimension: amt_total_gmv_selling_price_gross {
    type: number
    sql: ${TABLE}.amt_total_gmv_selling_price_gross ;;
    hidden: yes
    label: "GMV Selling Price Gross"
    group_label: "Monetary Metrics"
  }

  dimension: amt_total_gmv_buying_price_net {
    type: number
    sql: ${TABLE}.amt_total_gmv_buying_price_net ;;
    hidden: yes
    label: "GMV Buying Price Net"
    group_label: "Monetary Metrics"
    required_access_grants: [can_view_buying_information]
  }

  dimension: amt_waste_selling_price_gross {
    type: number
    sql: ${TABLE}.amt_waste_selling_price_gross ;;
    hidden: yes
    label: "€ Outbound (Waste) Gross - (Selling Price)"
    group_label: "Monetary Metrics"
  }

  dimension: amt_waste_buying_price_net {
    type: number
    sql: ${TABLE}.amt_waste_buying_price_net ;;
    hidden: yes
    label: "€ Outbound (Waste) Net - (Buying Price)"
    group_label: "Monetary Metrics"
    required_access_grants: [can_view_buying_information]
  }

  dimension: avg_amt_buying_price_net {
    type: number
    sql: ${TABLE}.avg_amt_buying_price_net ;;
    label: "Buying Price Net"
    group_label: "Price Dimensions"
    required_access_grants: [can_view_buying_information]
  }

  dimension: avg_amt_selling_price_gross {
    type: number
    sql: ${TABLE}.avg_amt_selling_price_gross ;;
    label: "Selling Price Gross"
    group_label: "Price Dimensions"
  }

###################################################
###### Advanced Supplier Matching Dimensions ######
###############      HIDDEN.     ##################
###################################################

  dimension: items_ordered__desadv {
    type: number
    sql: ${TABLE}.sum_of_items_ordered__desadv ;;
    label: "# Delivered Items (DESADVs)"
    group_label: "DESADVs <> Inbounds"
    description: "The number of SKUs, that have been delivered according to the dispatch notification (DESADV)"
    hidden: yes
  }

  dimension: items_otifiq_stric__desadvs {
    type: number
    sql: ${TABLE}.sum_of_items_otifiq_stric__desadvs ;;
    label: "# OTIFIQ Strict (DESADVs <> Inbounds)"
    group_label: "DESADVs <> Inbounds"
    description: "Number of on time, in full and in quality DESADV lines (DESADV > Inbound)"
    hidden: yes
  }

  dimension: items__desadv {
    type: number
    sql: ${TABLE}.sum_of_items__desadv ;;
    label: "# Total Quantity (DESADVs)"
    group_label: "DESADVs <> Inbounds"
    description: "The total number of units, that have been delivered according to the dispatch notification (DESADV)"
    hidden: yes
  }

  dimension: items_otifiq_relax_lim__desadv  {
    type: number
    sql: ${TABLE}.sum_of_items_otifiq_relax_lim__desadv ;;
    label: "# OTIFIQ Relaxed lim (DESADVs <> Inbounds)"
    group_label: "DESADVs <> Inbounds"
    description: "Total amount of on time and in quality fulfilled quantities (DESADV > Inbound), where an overdelivered quantity is limited to the DESADV quantity"
    hidden: yes
  }

  dimension: items_inbounded_on_time__desadv  {
    type: number
    sql: ${TABLE}.sum_of_items_inbounded_on_time__desadv ;;
    label: "# On time delivery (DESADVs <> Inbounds)"
    group_label: "DESADVs <> Inbounds"
    description: "Number of on time delivered DESADV lines (DESADV > Inbound)"
    hidden: yes
  }

  dimension: items_inbounded_in_full_strict__desadv {
    type: number
    sql: ${TABLE}.sum_of_items_inbounded_in_full_strict__desadv ;;
    label: "# In full delivery (DESADVs <> Inbounds)"
    group_label: "DESADVs <> Inbounds"
    description: "Number of in full delivered DESADV lines (DESADV > Inbound)"
    hidden: yes
  }

  dimension: items_inbounded__desadv {
    type: number
    sql: ${TABLE}.sum_of_items_inbounded__desadv ;;
    label: "# Inbounded Items (DESADVs <> Inbounds)"
    group_label: "DESADVs <> Inbounds"
    description: "Total amount of fullfilled quantities"
    hidden: yes
  }

  dimension: items_inbounded_in_quality__desadv {
    type: number
    sql: ${TABLE}.sum_of_items_inbounded_in_quality__desadv ;;
    label: "# Inbounded Items in Quality (DESADVs <> Inbounds)"
    group_label: "DESADVs <> Inbounds"
    description: "Share of in quality delivered order lines"
    hidden: yes
  }

  dimension: items_ordered__po {
    type: number
    sql: ${TABLE}.sum_of_items_ordered__po ;;
    label: "# Ordered Items (PO)"
    group_label: "PO <> Inbounds"
    description: "The number of SKUs, that have been ordered"
    hidden: yes
  }

  dimension: items_otifiq_stric__po {
    type: number
    sql: ${TABLE}.sum_of_items_otifiq_stric__po ;;
    label: "# OTIFIQ Strict (PO <> Inbounds)"
    group_label: "PO <> Inbounds"
    description: "Number of on time, in full and in quality order lines (PO > Inbound)"
    hidden: yes
  }

  dimension: items__po {
    type: number
    sql: ${TABLE}.sum_of_items__po ;;
    label: "# Total Quantity (PO)"
    group_label: "PO <> Inbounds"
    description: "The total number of units, that have been ordered (PO)"
    hidden: yes
  }

  dimension: items_otifiq_relax_lim__po {
    type: number
    sql: ${TABLE}.sum_of_items_otifiq_relax_lim__po ;;
    label: "# OTIFIQ Relaxed lim (PO <> Inbounds)"
    group_label: "PO <> Inbounds"
    description: "Total amount of on time and in quality fulfilled quantities (PO > Inbound), where an overdelivered quantity is limited to the PO quantity"
    hidden: yes
  }

  dimension: items_inbounded_on_time__po {
    type: number
    sql: ${TABLE}.sum_of_items_inbounded_on_time__po ;;
    label: "# On time delivery (PO <> Inbounds)"
    group_label: "PO <> Inbounds"
    description: "Number of on time delivered PO lines (PO > Inbound)"
    hidden: yes
  }

  dimension: items_inbounded_in_full_strict__po {
    type: number
    sql: ${TABLE}.sum_of_items_inbounded_in_full_strict__po ;;
    label: "# In full delivery (PO <> Inbounds)"
    group_label: "PO <> Inbounds"
    description: "Number of in full delivered PO lines (PO > Inbound)"
    hidden: yes
  }

  dimension: items_inbounded__po {
    type: number
    sql: ${TABLE}.sum_of_items_inbounded__po ;;
    label: "# Inbounded Items (PO <> Inbounds)"
    group_label: "PO <> Inbounds"
    description: "Total amount of fullfilled quantities (PO > Inbound)"
    hidden: yes
  }

  dimension: items_inbounded_in_quality__po {
    type: number
    sql: ${TABLE}.sum_of_items_inbounded_in_quality__po ;;
    label: "# Inbounded Items in Quality (PO <> Inbounds)"
    group_label: "PO <> Inbounds"
    description: "Share of in quality delivered order lines (PO > Inbound)"
    hidden: yes
  }

  dimension: items_ordered_on_time_in_full__po_desadv {
    type: number
    sql: ${TABLE}.sum_of_items_ordered_on_time_in_full__po_desadv ;;
    label: "# OTIF strict (PO > DESADV)"
    group_label: "PO <> DESADVs"
    description: "Number of on time and in full order lines (PO > DESADV)"
    hidden: yes
  }

  dimension: items_ordered_on_time_limited__po_desadv {
    type: number
    sql: ${TABLE}.sum_of_items_ordered_on_time_limited__po_desadv ;;
    label: "# OTIF relaxed quantity lim. (PO > DESADV)"
    group_label: "PO <> DESADVs"
    description: "Total amount of on time fulfilled quantities (PO > DESADV), where an overdelivered quantity is limited to the PO quantity"
    hidden: yes
  }

  dimension: items_ordered_and_delivered_on_time__po_desadv {
    type: number
    sql: ${TABLE}.sum_of_items_ordered_and_delivered_on_time__po_desadv ;;
    label: "# On Time Delivery (PO > DESADV)"
    group_label: "PO <> DESADVs"
    description: "The number of SKUs, that have been ordered and have been delivered at the promised delivery date - (PO > DESADV)"
    hidden: yes
  }

  dimension: items_ordered_in_full__po_desadv{
    type: number
    sql: ${TABLE}.sum_of_items_ordered_in_full__po_desadv ;;
    label: "# In Full delivery (PO > DESADV)"
    group_label: "PO <> DESADVs"
    description: "Number of in full delivered order lines (PO > DESADV)"
    hidden: yes
  }

  dimension: items_ordered_desadv_with_po__po_desadv {
    type: number
    sql: ${TABLE}.sum_of_items_ordered_desadv_with_po__po_desadv ;;
    label: "# Filled Quantities (PO > DESADV)"
    group_label: "PO <> DESADVs"
    description: "Sum of fullfilled quantities (PO > DESADV)"
    hidden: yes
  }



  measure: count {
    type: count
    hidden: yes
    drill_fields: [hub_name, vendor_name, product_name]
  }

}
