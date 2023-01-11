# Owner: Lauti Ruiz

# Description: This view shows hubs data according to our ERP Systems. Until 2023-01-20 this data comes from Lexbizz ERP,
# after that date, comes from Oracle.

# Lexbizz : curated.lexbizz_hub ->> Until 2023-01-20
# Oracle : curated.oracle_hubs_daily ->> From 2023-01-20


view: erp_hubs {
  sql_table_name: `flink-data-prod.curated.erp_hubs`
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
    description: "Date on which data was extracted from an external tool/api and stored into a BigQuery table."
    sql: ${TABLE}.ingestion_date ;;
    group_label: "Dates & Timestamps"
  }

  dimension_group: launch {
    type: time
    timeframes: [
      date,
      week
    ]
    datatype: date
    description: "Date when the hub was launched"
    sql: ${TABLE}.launch_date ;;
    group_label: "Dates & Timestamps"
  }

  dimension_group: termination {
    type: time
    timeframes: [
      date,
      week
    ]
    datatype: date
    description: "Upfront date set when the hub will be close"
    sql: ${TABLE}.termination_date ;;
    group_label: "Dates & Timestamps"
  }

#############################################
############## IDs Dimensions ###############
#############################################

  dimension: table_uuid {
    type: string
    description: "Generic identifier of a table in that represent 1 unique row."
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes

  }

  dimension: buyer_id {
    label: "Buyer ID"
    type: string
    description: "Buyer ID of Flink as defined in ERP"
    group_label: "IDs"
    sql: ${TABLE}.buyer_id ;;
  }

  dimension: company_id {
    label: "Company ID"
    type: string
    description: "Company ID as defined in ERP"
    group_label: "IDs"
    sql: ${TABLE}.company_id ;;
  }

  dimension: hub_id {
    label: "Hub ID"
    type: string
    description: "The alphabetical identifier of a hub"
    group_label: "IDs"
    sql: ${TABLE}.hub_id ;;
  }

  dimension: hub_id_number {
    label: "Hub Number ID"
    type: number
    value_format_name: id
    description: "The numeric identifier of a hub, coming from Oracle"
    group_label: "IDs"
    sql: ${TABLE}.hub_id_number ;;
  }


#############################################
############ General Dimensions #############
#############################################

  dimension: city {
    label: "City"
    type: string
    sql: ${TABLE}.city ;;
    description: "City where a hub is located."
    group_label: "Geographic Data"
  }

  dimension: country_hub {
    label: "Country"
    type: string
    sql: ${TABLE}.country_hub ;;
    description: "Country where a hub is located."
    group_label: "Geographic Data"
  }

  dimension: country_iso {
    label: "Country ISO"
    type: string
    sql: ${TABLE}.country_iso ;;
    description: "2-letter country code."
    group_label: "Geographic Data"
  }

  dimension: gln {
    label: "GLN"
    type: string
    sql: ${TABLE}.gln ;;
    description: "The location identifier according to our ERP systems"
    group_label: "Hub Attribute"
  }

  dimension: hub_code {
    label: "Hub Code"
    type: string
    sql: ${TABLE}.hub_code ;;
    description: "Code of a hub identical to back-end source tables."
    group_label: "Hub Attribute"
  }

  dimension: hub_name {
    label: "Hub Name"
    type: string
    sql: ${TABLE}.hub_name ;;
    description: "Name assigned to a hub based on the combination of country ISO code, city and district."
    group_label: "Hub Attribute"
  }

  dimension: hub_size {
    label: "Hub Size"
    type: string
    sql: ${TABLE}.hub_size ;;
    description: "Physical size/space of a hub (measured as S, M or L)."
    group_label: "Hub Attribute"
  }

  dimension: postal_code {
    label: "Zip Code"
    type: string
    sql: ${TABLE}.postal_code ;;
    description: "Zip Code where a hub is located."
    group_label: "Geographic Data"
  }

  dimension: state {
    label: "State"
    type: string
    sql: ${TABLE}.state ;;
    description: "State where a hub is located."
    group_label: "Geographic Data"
  }

  dimension: street {
    label: "Street"
    type: string
    sql: ${TABLE}.street ;;
    description: "Street where a hub is located."
    group_label: "Geographic Data"
  }


#############################################
############ General Dimensions #############
#############################################

  dimension: is_hub_active {
    label: "Is Hub Active"
    type: yesno
    sql: ${TABLE}.is_hub_active ;;
    description: "This boolean field indicates, whether of not a hub is active."
    group_label: "Hub Attribute"
  }


#############################################
################ Measures ###################
#############################################


  measure: count {
    type: count
    drill_fields: [hub_name]
  }
}
