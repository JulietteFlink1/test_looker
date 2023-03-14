# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: oracle_items_fact {
#   hidden: yes

#   join: oracle_items_fact__history {
#     view_label: "Oracle Items Fact: History"
#     sql: LEFT JOIN UNNEST(${oracle_items_fact.history}) as oracle_items_fact__history ;;
#     relationship: one_to_many
#   }
# }

view: oracle_items_fact {
  sql_table_name: `flink-data-prod.curated.oracle_items_fact`
    ;;

  dimension: current_state__class_name {
    type: string
    description: "The class name relates to the 3rd highest order of grouping for products in Oracle"
    sql: ${TABLE}.current_state.class_name ;;
  }

  dimension: current_state__base_uom {
    type: string
    description: "The base unit of measure of a product"
    sql: ${TABLE}.current_state.base_uom ;;
    group_label: "Current State"
    group_item_label: "Base Uom"
  }

  dimension: current_state__csn_number {
    type: string
    description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
    sql: ${TABLE}.current_state.csn_number ;;
    group_label: "Current State"
    group_item_label: "Csn Number"
  }

  dimension: current_state__handling_unit_height {
    type: number
    sql: ${TABLE}.current_state.handling_unit_height ;;
    group_label: "Current State"
    group_item_label: "Handling Unit Height"
  }

  dimension: current_state__handling_unit_length {
    type: number
    sql: ${TABLE}.current_state.handling_unit_length ;;
    group_label: "Current State"
    group_item_label: "Handling Unit Length"
  }

  dimension: current_state__handling_unit_width {
    type: number
    sql: ${TABLE}.current_state.handling_unit_width ;;
    group_label: "Current State"
    group_item_label: "Handling Unit Width"
  }

  dimension: current_state__is_orderable {
    type: yesno
    description: "This boolean field is an indicator, whether an SKU is orderable by the Supply Chain department"
    sql: ${TABLE}.current_state.is_orderable ;;
    group_label: "Current State"
    group_item_label: "Is Orderable"
  }

  dimension: current_state__is_perishable {
    type: yesno
    description: "This boolean field is an indicator, whether an SKU can perish"
    sql: ${TABLE}.current_state.is_perishable ;;
    group_label: "Current State"
    group_item_label: "Is Perishable"
  }

  dimension: current_state__is_sellable {
    type: yesno
    description: "This boolean field is an indicator, whether an SKU is sellable"
    sql: ${TABLE}.current_state.is_sellable ;;
    group_label: "Current State"
    group_item_label: "Is Sellable"
  }

  dimension: current_state__item_height {
    type: number
    sql: ${TABLE}.current_state.item_height ;;
    group_label: "Current State"
    group_item_label: "Item Height"
  }

  dimension: current_state__item_length {
    type: number
    sql: ${TABLE}.current_state.item_length ;;
    group_label: "Current State"
    group_item_label: "Item Length"
  }

  dimension: current_state__item_name {
    type: string
    description: "Name of the product, as specified in the backend."
    sql: ${TABLE}.current_state.item_name ;;
    group_label: "Current State"
    group_item_label: "Item Name"
  }

  dimension: current_state__item_status {
    type: string
    description: "The activity/listing status of a product according to our ERP system"
    sql: ${TABLE}.current_state.item_status ;;
    group_label: "Current State"
    group_item_label: "Item Status"
  }

  dimension: current_state__item_weight {
    type: number
    sql: ${TABLE}.current_state.item_weight ;;
    group_label: "Current State"
    group_item_label: "Item Weight"
  }

  dimension: current_state__item_width {
    type: number
    sql: ${TABLE}.current_state.item_width ;;
    group_label: "Current State"
    group_item_label: "Item Width"
  }

  dimension: current_state__last_dml_type {
    type: string
    description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
    sql: ${TABLE}.current_state.last_dml_type ;;
    group_label: "Current State"
    group_item_label: "Last Dml Type"
  }

  dimension: current_state__purchase_uom {
    type: string
    sql: ${TABLE}.current_state.purchase_uom ;;
    group_label: "Current State"
    group_item_label: "Purchase Uom"
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

  dimension: current_state__department_name {
    type: string
    description: "The department name relates to the 2nd highest order of grouping for products in Oracle"
    sql: ${TABLE}.current_state.department_name ;;
  }

  dimension: current_state__division_name {
    type: string
    sql: ${TABLE}.current_state.division_name ;;
  }

  dimension: ean_13 {
    type: string
    description: "The 13 digit long EAN (European Article Number) code to identify a product"
    sql: ${TABLE}.ean_13 ;;
  }

  dimension: ean_8 {
    type: string
    description: "The 8 digit long EAN (European Article Number) code to identify a product"
    sql: ${TABLE}.ean_8 ;;
  }

  dimension: current_state__group_name {
    type: string
    description: "The group name relates to the higher order of grouping for products in Oracle"
    sql: ${TABLE}.current_state.group_name ;;
  }

  dimension: history {
    hidden: yes
    sql: ${TABLE}.history ;;
  }

  dimension: hub_type {
    type: string
    description: "The hub type indicates, to which kind of hubs a given product is usually assigned to. Hereby, an assignment to an M-hub indicates, that the product is usually offered in all M hubs or bigger (L hubs)"
    sql: ${TABLE}.hub_type ;;
  }

  dimension_group: introduction {
    type: time
    description: "The date, when a given product was listed initially"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.introduction_date ;;
  }

  dimension: manual_barcode {
    type: string
    description: "The manually entered code in Oracle, to identify a product - this is a customer field, necessary for some internal SC processes"
    sql: ${TABLE}.manual_barcode ;;
  }

  dimension: number_of_historical_changes {
    type: number
    description: "This index provides a count of how many row-changes have been performed to a given object in Oracle."
    sql: ${TABLE}.number_of_historical_changes ;;
  }

  dimension: parent_sku {
    type: string
    description: "Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    sql: ${TABLE}.parent_sku ;;
  }

  dimension: producer {
    type: string
    description: "The producing company of a product."
    sql: ${TABLE}.producer ;;
  }

  dimension: replenishment_substitute_group {
    type: string
    description: "The replenishment substitute group defined by the Supply Chain team to tag substitute products for replenishment."
    sql: ${TABLE}.replenishment_substitute_group ;;
  }

  dimension: shelf_life {
    type: string
    description: "The overall shelf live in days of a product until its best before date (BBD)"
    sql: ${TABLE}.shelf_life ;;
  }

  dimension: shelf_life_consumer {
    type: string
    description: "The minimum days a product should be consumable for a customer befores its best before date (BBD)"
    sql: ${TABLE}.shelf_life_consumer ;;
  }

  dimension: shelf_life_hub {
    type: string
    description: "The shelf live in days of a product defining how long a product can be stored in a hub until its best before date (BBD)"
    sql: ${TABLE}.shelf_life_hub ;;
  }

  dimension: sku {
    type: string
    description: "SKU of the product, as available in the backend."
    sql: ${TABLE}.sku ;;
  }

  dimension: storage_types {
    type: string
    description: "The type of storage, that is requried for a given product"
    sql: ${TABLE}.storage_types ;;
  }

  dimension: current_state__subclass_name {
    type: string
    description: "The sub-class name relates to the 4th highest order of grouping for products in Oracle"
    sql: ${TABLE}.current_state.subclass_name ;;
  }

  dimension: table_uuid {
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: temperature_zone {
    type: string
    sql: ${TABLE}.temperature_zone ;;
  }

  dimension_group: termination {
    type: time
    description: "The date, when a given product was delisted"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.termination_date ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      current_state__group_name,
      current_state__department_name,
      current_state__division_name,
      current_state__subclass_name,
      current_state__class_name,
      current_state__item_name
    ]
  }
}

# view: oracle_items_fact__history {
#   dimension: base_uom {
#     type: string
#     description: "The base unit of measure of a product"
#     sql: base_uom ;;
#   }

#   dimension: csn_number {
#     type: number
#     description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
#     sql: csn_number ;;
#   }

#   dimension: handling_unit_height {
#     type: number
#     sql: handling_unit_height ;;
#   }

#   dimension: handling_unit_length {
#     type: number
#     sql: handling_unit_length ;;
#   }

#   dimension: handling_unit_width {
#     type: number
#     sql: handling_unit_width ;;
#   }

#   dimension: is_orderable {
#     type: yesno
#     description: "This boolean field is an indicator, whether an SKU is orderable by the Supply Chain department"
#     sql: is_orderable ;;
#   }

#   dimension: is_perishable {
#     type: yesno
#     description: "This boolean field is an indicator, whether an SKU can perish"
#     sql: is_perishable ;;
#   }

#   dimension: is_sellable {
#     type: yesno
#     description: "This boolean field is an indicator, whether an SKU is sellable"
#     sql: is_sellable ;;
#   }

#   dimension: item_height {
#     type: number
#     sql: item_height ;;
#   }

#   dimension: item_length {
#     type: number
#     sql: item_length ;;
#   }

#   dimension: item_name {
#     type: string
#     description: "Name of the product, as specified in the backend."
#     sql: item_name ;;
#   }

#   dimension: item_status {
#     type: string
#     description: "The activity/listing status of a product according to our ERP system"
#     sql: item_status ;;
#   }

#   dimension: item_weight {
#     type: number
#     sql: item_weight ;;
#   }

#   dimension: item_width {
#     type: number
#     sql: item_width ;;
#   }

#   dimension: last_dml_type {
#     type: string
#     description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
#     sql: last_dml_type ;;
#   }

#   dimension: oracle_items_fact__history {
#     type: string
#     description: "A bigquery array of structs object, that provides an ordered list of all modifications of a given table in Oracle."
#     hidden: yes
#     sql: oracle_items_fact__history ;;
#   }

#   dimension: purchase_uom {
#     type: string
#     sql: purchase_uom ;;
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
