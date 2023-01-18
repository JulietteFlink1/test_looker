# Owner: Lauti Ruiz

# Description: This view shows data about the item-supplier combination (from who we can order an item and if it's available)
#              according to our ERP Systems.
#              Until 2023-01-20 this data comes from Lexbizz ERP,
#              after that date, comes from Oracle.

# Lexbizz : curated.lexbizz_item_vendor ->> Until 2023-01-20
# Oracle : curated.oracle_item_supplier_daily ->> From 2023-01-20


view: erp_item_supplier {
  sql_table_name: `flink-data-prod.curated.erp_item_supplier`
    ;;

#############################################
############## Date Dimensions ##############
#############################################

  dimension_group: ingestion {
    type: time
    timeframes: [
      date
    ]
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
    description: "Date on which data was extracted from an external tool/api and stored into a BigQuery table."
    group_label: "Dates & Timestamps"
  }

#############################################
############## IDs Dimensions ###############
#############################################

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    primary_key: yes
    hidden: yes
  }

  dimension: vendor_id {
    label: "Supplier ID"
    type: string
    sql: ${TABLE}.vendor_id ;;
    description: "The supplier ID as defined in Oracle -
                  which is a representation of a supplier and its related supplier-location"
  }

#############################################
################ Flag Dimensions ############
#############################################

  dimension: is_active {
    label: "Is Active"
    type: yesno
    sql: ${TABLE}.is_active ;;
    description: "This boolean field indicates,
                  if a product from a particular supplier is active (product-supplier combination)."
  }

  dimension: is_primary_supplier {
    label: "Is primary Supplier"
    type: yesno
    sql: ${TABLE}.is_primary_supplier ;;
    description: "This boolean field indicates, if a supplier is the primary supplier for a given SKU"
  }

#############################################
############## General Dimensions ###########
#############################################

  dimension: country_iso {
    label: "Country ISO"
    type: string
    sql: ${TABLE}.country_iso ;;
    description: "2-letter country code."
  }

  dimension: edi {
    label: "EDI"
    type: string
    sql: ${TABLE}.edi ;;
    description: "Transaction codes that correspond to information in business documents between Flink and Suppliers."
  }

  dimension: min_order_qty {
    label: "Min Order Quantity"
    type: number
    sql: ${TABLE}.min_order_qty ;;
    description: "Minimun quantity of a product that we have to order from a supplier"
  }

  dimension: purchase_unit {
    label: "Purchase Unit"
    type: string
    sql: ${TABLE}.purchase_unit ;;
    description: "The ERP defined puchase unit code of a product. It defines, which aggregation was bought (examples: STÜCK, PK14, PK06)"
  }

  dimension: sku {
    label: "SKU"
    type: string
    sql: ${TABLE}.sku ;;
    description: "SKU of the product, as available in the backend."
  }

  dimension: vendor_location {
    label: "Supplier Location"
    type: string
    sql: ${TABLE}.vendor_location ;;
    description: "Location from where the Supplier is doing the distribution."
  }

  dimension: vendor_name {
    label: "Supplier Name"
    type: string
    sql: ${TABLE}.vendor_name ;;
    description: "Name of the supplier/vendor of a product (e.g. REWE or Carrefour)."
  }

#############################################
################## Measures #################
#############################################

  measure: count {
    type: count
    drill_fields: [vendor_name]
  }
}
