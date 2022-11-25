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
  sql_table_name: `flink-data-prod.reporting.supply_chain_master_report`
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

  measure: count {
    type: count
    hidden: yes
    drill_fields: [hub_name, vendor_name, product_name]
  }

}
