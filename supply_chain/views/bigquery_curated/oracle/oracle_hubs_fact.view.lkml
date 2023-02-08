# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: oracle_hubs_fact {
#   hidden: yes

#   join: oracle_hubs_fact__history {
#     view_label: "Oracle Hubs Fact: History"
#     sql: LEFT JOIN UNNEST(${oracle_hubs_fact.history}) as oracle_hubs_fact__history ;;
#     relationship: one_to_many
#   }
# }

view: oracle_hubs_fact {
  sql_table_name: `flink-data-prod.curated.oracle_hubs_fact`
    ;;

  dimension: alphabetical_hub_id {
    type: string
    sql: ${TABLE}.alphabetical_hub_id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: current_state__acquiration {
    type: time
    description: "The date, when the physical location of a hub was bought"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.current_state.acquiration_date ;;
  }

  dimension: current_state__csn_number {
    type: string
    description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
    sql: ${TABLE}.current_state.csn_number ;;
    group_label: "Current State"
    group_item_label: "Csn Number"
  }

  dimension: current_state__last_dml_type {
    type: string
    description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
    sql: ${TABLE}.current_state.last_dml_type ;;
    group_label: "Current State"
    group_item_label: "Last Dml Type"
  }

  dimension_group: current_state__launch {
    type: time
    description: "Date when a hub was launched."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.current_state.launch_date ;;
  }

  dimension: current_state__local_currency {
    type: string
    description: "Currency ISO code."
    sql: ${TABLE}.current_state.local_currency ;;
    group_label: "Current State"
    group_item_label: "Local Currency"
  }

  dimension: current_state__store_manager {
    type: string
    description: "The hub manager of a given hub"
    sql: ${TABLE}.current_state.store_manager ;;
    group_label: "Current State"
    group_item_label: "Store Manager"
  }

  dimension_group: current_state__termination {
    type: time
    description: "Date when a hub was terminated."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.current_state.termination_date ;;
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
    type: string
    description: "The location identifier according to our ERP systems of a hub"
    sql: ${TABLE}.gln ;;
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

  dimension: hub_id {
    type: string
    description: "The identifier of a hub according to Oracle"
    sql: ${TABLE}.hub_id ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: hub_size {
    type: string
    description: "Physical size/space of a hub (measured as S, M or L)."
    sql: ${TABLE}.hub_size ;;
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

  dimension: table_uuid {
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  measure: count {
    type: count
    drill_fields: [hub_name]
  }
}

# view: oracle_hubs_fact__history {
#   dimension_group: acquiration {
#     type: time
#     description: "The date, when the physical location of a hub was bought"
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     datatype: date
#     sql: acquiration_date ;;
#   }

#   dimension: csn_number {
#     type: number
#     description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
#     sql: csn_number ;;
#   }

#   dimension: last_dml_type {
#     type: string
#     description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
#     sql: last_dml_type ;;
#   }

#   dimension_group: launch {
#     type: time
#     description: "Date when a hub was launched."
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     datatype: date
#     sql: launch_date ;;
#   }

#   dimension: local_currency {
#     type: string
#     description: "Currency ISO code."
#     sql: local_currency ;;
#   }

#   dimension: oracle_hubs_fact__history {
#     type: string
#     description: "A bigquery array of structs object, that provides an ordered list of all modifications of a given table in Oracle."
#     hidden: yes
#     sql: oracle_hubs_fact__history ;;
#   }

#   dimension: store_manager {
#     type: string
#     description: "The hub manager of a given hub"
#     sql: store_manager ;;
#   }

#   dimension_group: termination {
#     type: time
#     description: "Date when a hub was terminated."
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     datatype: date
#     sql: ${TABLE}.termination_date ;;
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
