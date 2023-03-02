# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: oracle_item_location_fact {
#   hidden: yes

#   join: oracle_item_location_fact__history {
#     view_label: "Oracle Item Location Fact: History"
#     sql: LEFT JOIN UNNEST(${oracle_item_location_fact.history}) as oracle_item_location_fact__history ;;
#     relationship: one_to_many
#   }
# }

view: oracle_item_location_fact {
  sql_table_name: `flink-data-prod.curated.oracle_item_location_fact`
    ;;

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: current_state__created_at_timestamp {
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
    sql: ${TABLE}.current_state.created_at_timestamp ;;
  }

  dimension: current_state__csn_number {
    type: string
    description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
    sql: ${TABLE}.current_state.csn_number ;;
    group_label: "Current State"
    group_item_label: "Csn Number"
  }

  dimension: current_state__item_at_location_status {
    label: "Item At Location Status (of today)"
    type: string
    description: "The assignment status of a given product to a given hub as defined in Oracle. This field shows the status as of today and NOT the history of status changes"
    sql: ${TABLE}.current_state.item_at_location_status ;;
  }

  dimension: current_state__item_status {
    type: string
    sql: ${TABLE}.current_state.item_status ;;
    group_label: "Current State"
    group_item_label: "Item Status"
  }

  dimension: current_state__last_dml_type {
    type: string
    description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
    sql: ${TABLE}.current_state.last_dml_type ;;
    group_label: "Current State"
    group_item_label: "Last Dml Type"
  }

  dimension: current_state__primary_country {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.current_state.primary_country ;;
    group_label: "Current State"
    group_item_label: "Primary Country"
  }

  dimension: current_state__primary_supplier_id {
    type: string
    description: "ID of a supplier/vendor as define in our ERP system - This is the primary supplier for a given product and hub"
    sql: ${TABLE}.current_state.primary_supplier_id ;;
    group_label: "Current State"
    group_item_label: "Primary Supplier ID"
  }

  dimension: current_state__primary_supplier_name {
    type: string
    description: "Name of the supplier/vendor of a product (e.g. REWE or Carrefour). - This is the primary supplier for a given product and hub"
    sql: ${TABLE}.current_state.primary_supplier_name ;;
    group_label: "Current State"
    group_item_label: "Primary Supplier Name"
  }

  dimension: current_state__primary_supplier_site {
    type: string
    description: "Site of the supplier/vendor of a product, defined as Supplier Name + Location. - This is the primary supplier for a given product and hub"
    sql: ${TABLE}.current_state.primary_supplier_site ;;
    group_label: "Current State"
    group_item_label: "Primary Supplier Site"
  }

  dimension_group: current_state__status_update_timestamp {
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
    sql: ${TABLE}.current_state.status_update_timestamp ;;
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

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: location_id {
    type: string
    description: "The identifier of a hub according to Oracle"
    sql: ${TABLE}.location_id ;;
  }

  dimension: location_type {
    type: string
    description: "The location type refers to either hubs or warehouses (which are basically distribution centers)"
    sql: ${TABLE}.location_type ;;
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

  dimension: table_uuid {
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: warehouse_id {
    type: string
    sql: ${TABLE}.warehouse_id ;;
  }

  measure: count {
    type: count
    drill_fields: [current_state__primary_supplier_name]
  }
}

# view: oracle_item_location_fact__history {
#   dimension_group: created_at_timestamp {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: created_at_timestamp ;;
#   }

#   dimension: csn_number {
#     type: number
#     description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
#     sql: csn_number ;;
#   }

#   dimension: item_at_location_status {
#     type: string
#     description: "The assignment status of a given product to a given hub as defined in Oracle"
#     sql: item_at_location_status ;;
#   }

#   dimension: item_status {
#     type: string
#     sql: item_status ;;
#   }

#   dimension: last_dml_type {
#     type: string
#     description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
#     sql: last_dml_type ;;
#   }

#   dimension: oracle_item_location_fact__history {
#     type: string
#     description: "A bigquery array of structs object, that provides an ordered list of all modifications of a given table in Oracle."
#     hidden: yes
#     sql: oracle_item_location_fact__history ;;
#   }

#   dimension: primary_country {
#     type: string
#     description: "Country ISO based on 'hub_code'."
#     sql: primary_country ;;
#   }

#   dimension: primary_supplier_id {
#     type: number
#     description: "ID of a supplier/vendor as define in our ERP system - This is the primary supplier for a given product and hub"
#     sql: primary_supplier_id ;;
#   }

#   dimension: primary_supplier_name {
#     type: string
#     description: "Name of the supplier/vendor of a product (e.g. REWE or Carrefour). - This is the primary supplier for a given product and hub"
#     sql: primary_supplier_name ;;
#   }

#   dimension: primary_supplier_site {
#     type: string
#     description: "Site of the supplier/vendor of a product, defined as Supplier Name + Location. - This is the primary supplier for a given product and hub"
#     sql: primary_supplier_site ;;
#   }

#   dimension_group: status_update_timestamp {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: status_update_timestamp ;;
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
