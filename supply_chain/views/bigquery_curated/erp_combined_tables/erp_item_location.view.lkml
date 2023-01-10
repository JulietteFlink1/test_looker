# Owner: Lauti Ruiz

# Description: This view shows the combination between erp sources:
# Lexbizz : curated.lexbizz_item_warehouse ->> Until 2023-01-12
# Oracle : curated.oracle_item_location_daily ->> From 2023-01-12


view: erp_item_location {
  sql_table_name: `flink-data-prod.curated.erp_item_location`
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
  }

  dimension_group: introduction_timestamp {
    type: time
    timeframes: [
      time,
      date,
      week
    ]
    sql: ${TABLE}.introduction_timestamp ;;
    description: "The timestamp, when a given product was listed initially in a particular location"
  }

  dimension_group: last_modified_timestamp {
    type: time
    timeframes: [
      time,
      date,
      week
    ]
    sql: ${TABLE}.last_modified_timestamp ;;
    description: "The timestamp, when a given product was modified in a particular location"
  }

  dimension_group: termination_timestamp {
    type: time
    timeframes: [
      time,
      date,
      week
    ]
    sql: ${TABLE}.termination_timestamp ;;
    description: "The timestamp, when a given product was delisted in a particular location"
  }


#############################################
############## IDs Dimensions ###############
#############################################

  dimension: location_id {
    label: "Location ID"
    type: number
    sql: ${TABLE}.location_id ;;
    description: "The identifier of a hub location"
  }

  dimension: preferred_vendor_id {
    label: "Preferred Vendor ID"
    type: string
    sql: ${TABLE}.preferred_vendor_id ;;
    description: "The supplier ID as defined in Oracle - which is a representation of a supplier and its related supplier-location"
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    hidden: yes
    primary_key: yes
  }

  dimension: warehouse_id {
    label: "Warehouse ID"
    type: string
    sql: ${TABLE}.warehouse_id ;;
    description: "The warehouse_id as defined in Oracle, that identifies both, physical and virtual warehouses/distribution centers."
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

  dimension: hub_code {
    label: "Hub Code"
    type: string
    sql: ${TABLE}.hub_code ;;
    description: "Code of a hub identical to back-end source tables."

  }

  dimension: item_at_warehouse_status {
    label: "Item at Location Status"
    type: string
    sql: ${TABLE}.item_at_warehouse_status ;;
    description: "The assignment status of a given product to a given hub as defined in Oracle"
  }

  dimension: item_status {
    label: "Item Status"
    type: string
    sql: ${TABLE}.item_status ;;
    description: "The activity/listing status of a product according to our ERP system"
  }

  dimension: location_type {
    label: "Location Type"
    type: string
    sql: ${TABLE}.location_type ;;
    description: "The location type refers to either hubs or warehouses (which are basically distribution centers)"
  }

  dimension: preferred_vendor_location {
    label: "Preferred Supplier Location"
    type: string
    sql: ${TABLE}.preferred_vendor_location ;;
    description: ""
# This would be null from now on since there is no distinction for location anymore
    hidden: yes
  }

  dimension: safety_stock {
    label: "Safety Stock"
    type: number
    sql: ${TABLE}.safety_stock ;;
    description: "Minimun stock to have of a product to be safe in a particular location"
  }

  dimension: sku {
    label: "SKU"
    type: string
    sql: ${TABLE}.sku ;;
    description: "SKU of the product, as available in the backend."
  }


#############################################
################## Measures #################
#############################################

  measure: count {
    type: count
    drill_fields: []
  }
}
