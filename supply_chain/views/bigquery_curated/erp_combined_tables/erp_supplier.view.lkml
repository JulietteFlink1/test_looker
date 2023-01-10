# Owner: Lauti Ruiz

# Description: This view shows the combination between erp sources:
# Lexbizz : curated.lexbizz_vendor ->> Until 2023-01-12
# Oracle : curated.oracle_supplier_daily ->> From 2023-01-12


view: erp_supplier {
  sql_table_name: `flink-data-prod.curated.erp_supplier`
    ;;

#############################################
############## Date Dimensions ##############
#############################################

  dimension_group: created_at_timestamp {
    type: time
    timeframes: [
      time,
      date,
      week
    ]
    sql: ${TABLE}.created_at_timestamp ;;
    description: "The creation date and time of a record"
  }

  dimension_group: ingestion {
    type: time
    timeframes: [
      date
    ]
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
  }

  dimension_group: last_modified_timestamp {
    type: time
    timeframes: [
      time,
      date,
      week
    ]
    sql: ${TABLE}.last_modified_timestamp ;;
    description: "The timestamp, when a given record was modified. Timestamp when an supplier attribute (e.g. status) was modified."
  }

#############################################
################ IDs Dimensions #############
#############################################

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    hidden: yes
    primary_key: yes
  }

  dimension: vendor_id {
    label: "Supplier ID"
    type: string
    sql: ${TABLE}.vendor_id ;;
    description: "The supplier ID as defined in Oracle - which is a representation of a supplier and its related supplier-location"
  }

  dimension: supplier_parent_id {
    label: "Parent Supplier ID"
    type: number
    sql: ${TABLE}.supplier_parent_id ;;
    description: "The Parent supplier ID as defined in Oracle - which is groups every Child Supplier ID and its related supplier-location"
  }

#############################################
############## General Dimensions ###########
#############################################

  dimension: city {
    label: "Supplier City"
    type: string
    sql: ${TABLE}.city ;;
    description: "Supplier city of origin"
  }

  dimension: country_iso {
    label: "Country ISO"
    type: string
    sql: ${TABLE}.country_iso ;;
    description: "2-letter country code."
  }

  dimension: country_vendor {
    label: "Supplier Country"
    type: string
    sql: ${TABLE}.country_vendor ;;
    description: "Supplier country of origin"
  }

  dimension: currency {
    label: "Currency"
    type: string
    sql: ${TABLE}.currency ;;
    description: "Currency ISO code."
  }

  dimension: gln {
    label: "Supplier GLN"
    type: string
    sql: ${TABLE}.gln ;;
    description: "The location identifier according to our ERP systems "
  }

  dimension: postal_code {
    label: "Supplier Zip Code"
    type: string
    sql: ${TABLE}.postal_code ;;
    description: "Zip Code of origin of a supplier."
  }

  dimension: street {
    label: "Supplier street"
    type: string
    sql: ${TABLE}.street ;;
    description: "Street where a supplier is located."
  }

  dimension: tax_calculation_mode {
    label: "Tax Calculation Mode"
    type: string
    sql: ${TABLE}.tax_calculation_mode ;;
    description: "Tax calculation method applied for a particular supplier."
  }

  dimension: tax_zone {
    label: "Tax Zone"
    type: string
    sql: ${TABLE}.tax_zone ;;
    description: "Tax calculation zone applied for a particular supplier."
  }

  dimension: terms {
    label: "Terms"
    type: string
    sql: ${TABLE}.terms ;;
    description: "The terms of a supplier."
  }

  dimension: vendor_class {
    label: "Supplier Class"
    type: string
    sql: ${TABLE}.vendor_class ;;
    description: "Classification of a supplier according to the ERP."

  }

  dimension: vendor_name {
    label: "Supplier Name"
    type: string
    sql: ${TABLE}.vendor_name ;;
    description: "Name of the supplier/vendor of a product (e.g. REWE or Carrefour)."
  }

  dimension: vendor_status {
    label: "Supplier Status"
    type: string
    sql: ${TABLE}.vendor_status ;;
    description: "The activity status of a supplier as defined in our ERP system"
  }


#############################################
################## Measure ##################
#############################################

  measure: count {
    type: count
    drill_fields: [vendor_name]
  }
}
