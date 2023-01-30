# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: oracle_buying_prices_fact {
#   hidden: yes

#   join: oracle_buying_prices_fact__history {
#     view_label: "Oracle Buying Prices Fact: History"
#     sql: LEFT JOIN UNNEST(${oracle_buying_prices_fact.history}) as oracle_buying_prices_fact__history ;;
#     relationship: one_to_many
#   }
# }

view: oracle_buying_prices_fact {
  sql_table_name: `flink-data-dev.curated.oracle_buying_prices_fact`
    ;;

  required_access_grants: [can_view_buying_information]

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: current_state__amt_buying_price_net_eur {
    type: number
    description: "The buying price of a product we sell to the suppliers - this information is hub-specific."
    sql: ${TABLE}.current_state.amt_buying_price_net_eur ;;
    group_label: "Current State"
    group_item_label: "Amt Buying Price Net Eur"
  }

  dimension: current_state__amt_transactional_buying_price_net_eur {
    type: number
    description: "Buying price, that can be used for product sales.
    It resembles the weighted buying price of the current stock."
    sql: ${TABLE}.current_state.amt_transactional_buying_price_net_eur ;;
    group_label: "Current State"
    group_item_label: "Amt Transactional Buying Price Net Eur"
  }

  dimension: current_state__csn_number {
    type: number
    description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
    sql: ${TABLE}.current_state.csn_number ;;
    group_label: "Current State"
    group_item_label: "Csn Number"
  }

  dimension_group: current_state__first_received_timestamp {
    type: time
    description: "This timestamp indicates, when a given SKU was inbounded for the first time in a given hub"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.current_state.first_received_timestamp ;;
  }

  dimension: current_state__item_name {
    type: string
    description: "Name of the product, as specified in the backend."
    sql: ${TABLE}.current_state.item_name ;;
    group_label: "Current State"
    group_item_label: "Item Name"
  }

  dimension: current_state__last_dml_type {
    type: string
    description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
    sql: ${TABLE}.current_state.last_dml_type ;;
    group_label: "Current State"
    group_item_label: "Last Dml Type"
  }

  dimension_group: current_state__last_received_timestamp {
    type: time
    description: "This timestamp indicates, when a given SKU was inbounded for the last known time in a given hub"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.current_state.last_received_timestamp ;;
  }

  dimension: current_state__primary_country {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.current_state.primary_country ;;
    group_label: "Current State"
    group_item_label: "Primary Country"
  }

  dimension: current_state__primary_supplier_id {
    type: number
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
    type: number
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

  measure: count {
    type: count
    drill_fields: [current_state__item_name, current_state__primary_supplier_name]
  }
}

# view: oracle_buying_prices_fact__history {
#   dimension: amt_buying_price_net_eur {
#     type: number
#     description: "The buying price of a product we sell to the suppliers - this information is hub-specific."
#     sql: amt_buying_price_net_eur ;;
#   }

#   dimension: amt_transactional_buying_price_net_eur {
#     type: number
#     description: "Buying price, that can be used for product sales.
#     It resembles the weighted buying price of the current stock."
#     sql: amt_transactional_buying_price_net_eur ;;
#   }

#   dimension: csn_number {
#     type: number
#     description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
#     sql: csn_number ;;
#   }

#   dimension_group: first_received_timestamp {
#     type: time
#     description: "This timestamp indicates, when a given SKU was inbounded for the first time in a given hub"
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: first_received_timestamp ;;
#   }

#   dimension: item_name {
#     type: string
#     description: "Name of the product, as specified in the backend."
#     sql: item_name ;;
#   }

#   dimension: last_dml_type {
#     type: string
#     description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
#     sql: last_dml_type ;;
#   }

#   dimension_group: last_received_timestamp {
#     type: time
#     description: "This timestamp indicates, when a given SKU was inbounded for the last known time in a given hub"
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: last_received_timestamp ;;
#   }

#   dimension: oracle_buying_prices_fact__history {
#     type: string
#     description: "A bigquery array of structs object, that provides an ordered list of all modifications of a given table in Oracle."
#     hidden: yes
#     sql: oracle_buying_prices_fact__history ;;
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
