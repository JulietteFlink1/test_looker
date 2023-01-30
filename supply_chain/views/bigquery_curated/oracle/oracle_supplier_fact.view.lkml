# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: oracle_supplier_fact {
#   hidden: yes

#   join: oracle_supplier_fact__history {
#     view_label: "Oracle Supplier Fact: History"
#     sql: LEFT JOIN UNNEST(${oracle_supplier_fact.history}) as oracle_supplier_fact__history ;;
#     relationship: one_to_many
#   }
# }

view: oracle_supplier_fact {
  sql_table_name: `flink-data-dev.curated.oracle_supplier_fact`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: created_at_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at_timestamp ;;
  }

  dimension: current_state__csn_number {
    type: number
    description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
    sql: ${TABLE}.current_state.csn_number ;;
    group_label: "Current State"
    group_item_label: "Csn Number"
  }

  dimension: current_state__currency {
    type: string
    description: "Three character ISO code for the currency which was used for processing the payment."
    sql: ${TABLE}.current_state.currency ;;
    group_label: "Current State"
    group_item_label: "Currency"
  }

  dimension: current_state__last_dml_type {
    type: string
    description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
    sql: ${TABLE}.current_state.last_dml_type ;;
    group_label: "Current State"
    group_item_label: "Last Dml Type"
  }

  dimension: current_state__supplier_name {
    type: string
    description: "Name of the supplier/vendor of a product (e.g. REWE or Carrefour)."
    sql: ${TABLE}.current_state.supplier_name ;;
    group_label: "Current State"
    group_item_label: "Supplier Name"
  }

  dimension: current_state__supplier_parent_name {
    type: string
    sql: ${TABLE}.current_state.supplier_parent_name ;;
    group_label: "Current State"
    group_item_label: "Supplier Parent Name"
  }

  dimension: current_state__supplier_site {
    type: string
    description: "Site of the supplier/vendor of a product, defined as Supplier Name + Location."
    sql: ${TABLE}.current_state.supplier_site ;;
    group_label: "Current State"
    group_item_label: "Supplier Site"
  }

  dimension: current_state__supplier_status {
    type: string
    description: "The activity status of a supplier as defined in our ERP system"
    sql: ${TABLE}.current_state.supplier_status ;;
    group_label: "Current State"
    group_item_label: "Supplier Status"
  }

  dimension: current_state__tax_region {
    type: number
    description: "The tax-region of a supplier"
    sql: ${TABLE}.current_state.tax_region ;;
    group_label: "Current State"
    group_item_label: "Tax Region"
  }

  dimension: current_state__terms {
    type: string
    description: "The terms of a supplier"
    sql: ${TABLE}.current_state.terms ;;
    group_label: "Current State"
    group_item_label: "Terms"
  }

  dimension_group: current_state__valid_from_timestamp {
    type: time
    description: "This timestamp defines from which time the data of a given row is valid"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.current_state.valid_from_timestamp ;;
  }

  dimension_group: current_state__valid_to_timestamp {
    type: time
    description: "This timestamp defines until which time the data of a given row is valid"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.current_state.valid_to_timestamp ;;
  }

  dimension: gln {
    type: number
    description: "The location identifier according to our ERP systems"
    sql: ${TABLE}.gln ;;
  }

  dimension: history {
    hidden: yes
    sql: ${TABLE}.history ;;
  }

  dimension: number_of_historical_changes {
    type: number
    description: "This index provides a count of how many row-changes have been performed to a given object in Oracle."
    sql: ${TABLE}.number_of_historical_changes ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street {
    type: string
    sql: ${TABLE}.street ;;
  }

  dimension: supplier_id {
    type: number
    description: "The supplier ID as defined in Oracle - which is a representation of a supplier and its related supplier-location"
    sql: ${TABLE}.supplier_id ;;
  }

  dimension: supplier_parent_id {
    type: number
    description: "ID of a supplier/vendor as define in our ERP system"
    sql: ${TABLE}.supplier_parent_id ;;
  }

  dimension: table_uuid {
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
  }

  measure: count {
    type: count
    drill_fields: [current_state__supplier_name, current_state__supplier_parent_name]
  }
}

# view: oracle_supplier_fact__history {
#   dimension: csn_number {
#     type: number
#     description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
#     sql: csn_number ;;
#   }

#   dimension: currency {
#     type: string
#     description: "Three character ISO code for the currency which was used for processing the payment."
#     sql: currency ;;
#   }

#   dimension: last_dml_type {
#     type: string
#     description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
#     sql: last_dml_type ;;
#   }

#   dimension: oracle_supplier_fact__history {
#     type: string
#     description: "A bigquery array of structs object, that provides an ordered list of all modifications of a given table in Oracle."
#     hidden: yes
#     sql: oracle_supplier_fact__history ;;
#   }

#   dimension: supplier_name {
#     type: string
#     description: "Name of the supplier/vendor of a product (e.g. REWE or Carrefour)."
#     sql: supplier_name ;;
#   }

#   dimension: supplier_parent_name {
#     type: string
#     sql: supplier_parent_name ;;
#   }

#   dimension: supplier_site {
#     type: string
#     description: "Site of the supplier/vendor of a product, defined as Supplier Name + Location."
#     sql: supplier_site ;;
#   }

#   dimension: supplier_status {
#     type: string
#     description: "The activity status of a supplier as defined in our ERP system"
#     sql: supplier_status ;;
#   }

#   dimension: tax_region {
#     type: number
#     description: "The tax-region of a supplier"
#     sql: tax_region ;;
#   }

#   dimension: terms {
#     type: string
#     description: "The terms of a supplier"
#     sql: terms ;;
#   }

#   dimension_group: valid_from_timestamp {
#     type: time
#     description: "This timestamp defines from which time the data of a given row is valid"
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: valid_from_timestamp ;;
#   }

#   dimension_group: valid_to_timestamp {
#     type: time
#     description: "This timestamp defines until which time the data of a given row is valid"
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: valid_to_timestamp ;;
#   }
# }
