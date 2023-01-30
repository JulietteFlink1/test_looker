# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: oracle_item_supplier_fact {
#   hidden: yes

#   join: oracle_item_supplier_fact__history {
#     view_label: "Oracle Item Supplier Fact: History"
#     sql: LEFT JOIN UNNEST(${oracle_item_supplier_fact.history}) as oracle_item_supplier_fact__history ;;
#     relationship: one_to_many
#   }
# }

view: oracle_item_supplier_fact {
  sql_table_name: `flink-data-dev.curated.oracle_item_supplier_fact`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: current_state__csn_number {
    type: number
    description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
    sql: ${TABLE}.current_state.csn_number ;;
    group_label: "Current State"
    group_item_label: "Csn Number"
  }

  dimension: current_state__edi {
    type: string
    description: "Transaction codes that correspond to information in business documents between Flink and Suppliers."
    sql: ${TABLE}.current_state.edi ;;
    group_label: "Current State"
    group_item_label: "Edi"
  }

  dimension: current_state__is_primary_supplier {
    type: yesno
    description: "This boolean field indicates, if a supplier is the primary supplier for a given SKU"
    sql: ${TABLE}.current_state.is_primary_supplier ;;
    group_label: "Current State"
    group_item_label: "Is Primary Supplier"
  }

  dimension: current_state__last_dml_type {
    type: string
    description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
    sql: ${TABLE}.current_state.last_dml_type ;;
    group_label: "Current State"
    group_item_label: "Last Dml Type"
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

  dimension: history {
    hidden: yes
    sql: ${TABLE}.history ;;
  }

  dimension: number_of_historical_changes {
    type: number
    description: "This index provides a count of how many row-changes have been performed to a given object in Oracle."
    sql: ${TABLE}.number_of_historical_changes ;;
  }

  dimension: sku {
    type: string
    description: "SKU of the product, as available in the backend."
    sql: ${TABLE}.sku ;;
  }

  dimension: supplier_id {
    type: number
    description: "The supplier ID as defined in Oracle - which is a representation of a supplier and its related supplier-location"
    sql: ${TABLE}.supplier_id ;;
  }

  dimension: supplier_name {
    type: string
    description: "Name of the supplier/vendor of a product (e.g. REWE or Carrefour)."
    sql: ${TABLE}.supplier_name ;;
  }

  dimension: supplier_site {
    type: string
    description: "Site of the supplier/vendor of a product, defined as Supplier Name + Location."
    sql: ${TABLE}.supplier_site ;;
  }

  dimension: table_uuid {
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
  }

  measure: count {
    type: count
    drill_fields: [supplier_name]
  }
}

# view: oracle_item_supplier_fact__history {
#   dimension: csn_number {
#     type: number
#     description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
#     sql: csn_number ;;
#   }

#   dimension: edi {
#     type: string
#     description: "Transaction codes that correspond to information in business documents between Flink and Suppliers."
#     sql: edi ;;
#   }

#   dimension: is_primary_supplier {
#     type: yesno
#     description: "This boolean field indicates, if a supplier is the primary supplier for a given SKU"
#     sql: is_primary_supplier ;;
#   }

#   dimension: last_dml_type {
#     type: string
#     description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
#     sql: last_dml_type ;;
#   }

#   dimension: oracle_item_supplier_fact__history {
#     type: string
#     description: "A bigquery array of structs object, that provides an ordered list of all modifications of a given table in Oracle."
#     hidden: yes
#     sql: oracle_item_supplier_fact__history ;;
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
