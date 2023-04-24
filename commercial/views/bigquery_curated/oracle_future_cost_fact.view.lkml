# Owner: Andreas Stueber
# Created: 2023.04.24
# Purpose: Provide the Commercial team the cost-data (also for future dates) based on the oracle_future_cost_fact


view: oracle_future_cost_fact {

  view_label: "Spot Cost Data"
  sql_table_name: `flink-data-prod.curated.oracle_future_cost_fact` ;;
  required_access_grants: [can_access_pricing_margins]

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Generic fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_item_at_location_deleted {
    type: yesno
    description: "True if an item-location combination was deleted"
    sql: ${TABLE}.is_item_at_location_deleted ;;
  }

  dimension: location_id {
    type: number
    description: "The Id of a location (a hub, warehouse, etc) according to our ERP system Oracle"
    sql: ${TABLE}.location_id ;;
  }

  dimension: location_type {
    type: string
    description: "The location type refers to either hubs or warehouses (which are basically distribution centers)"
    sql: ${TABLE}.location_type ;;
  }

  dimension: number_of_historical_changes {
    type: number
    sql: ${TABLE}.number_of_historical_changes ;;
    group_label: "Historical Data"
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
    hidden: yes
    primary_key: yes
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -   Current Status
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension_group: active {
    label: "Active"
    type: time
    description: "Date that the item/supplier/country/location combinations costs becomes active."
    timeframes: [
      date
    ]
    datatype: date
    sql: ${TABLE}.current_state.active_date ;;
    group_label: "Current State"
  }

  dimension_group: calculation {
    label: "Calculation"
    type: time
    description: "Date when the cost was last calculated."
    timeframes: [
      date
    ]
    datatype: date
    sql: ${TABLE}.current_state.calculation_date ;;
    group_label: "Current State"
  }

  dimension_group: valid_from {
    label: "Valid From"
    type: time
    description: "This timestamp defines from which time the data of a given row is valid"
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.current_state.valid_from_timestamp ;;
    group_label: "Current State"
  }

  dimension_group: valid_to {
    label: "Valid To"
    type: time
    description: "This timestamp defines until which time the data of a given row is valid"
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.current_state.valid_to_timestamp ;;
    group_label: "Current State"
  }

  dimension: amt_base_cost_net {
    required_access_grants: [can_access_pricing_margins]

    label: "Base Cost (Net)"
    type: number
    description: "Base cost of the SKU/supplier/country at the given location. This is the same cost that is on the item_supp_country table."
    sql: ${TABLE}.current_state.amt_base_cost_net ;;
    group_label: "Current State"
    value_format_name: eur
  }

  dimension: amt_dead_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]

    label: "Dead Net Net Cost (Net)"
    type: number
    description: "Dead net net cost of the SKU/supplier/country at the given location. This is the net net cost minus any deal components designated as applying to dead net net cost on DEAL_DETAIL."
    sql: ${TABLE}.current_state.amt_dead_net_net_cost_net ;;
    group_label: "Current State"
    value_format_name: eur
  }

  dimension: amt_net_cost_net {
    required_access_grants: [can_access_pricing_margins]

    label: "Net Cost (Net)"
    type: number
    description: "Net cost of the SKU/supplier/country at the given location. This is the base cost minus any deal components designated as applying to net cost on DEAL_DETAIL."
    sql: ${TABLE}.current_state.amt_net_cost_net ;;
    group_label: "Current State"
    value_format_name: eur
  }

  dimension: amt_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]

    label: "Net Net Cost (Net)"
    type: number
    description: "Net net cost of the SKU/supplier/country at the given location. This is the net cost minus any deal components designated as applying to net net cost on DEAL_DETAIL."
    sql: ${TABLE}.current_state.amt_net_net_cost_net ;;
    group_label: "Current State"
    value_format_name: eur
  }

  dimension: amt_pricing_cost_net {
    required_access_grants: [can_access_pricing_margins]

    label: "Pricing Cost (Net)"
    type: number
    description: "Cost to be used to in pricing reviews. Pricing cost is the cost that will be interfaced with Oracle Price Management for use in pricing decisions."
    sql: ${TABLE}.current_state.amt_pricing_cost_net ;;
    group_label: "Current State"
    value_format_name: eur
  }

  dimension: cost_change_id {
    label: "Cost Change ID"
    type: number
    description: "Identifies the cost change that affected the costs for the sku/supplier/country/location/active date combination."
    sql: ${TABLE}.current_state.cost_change_id ;;
    group_label: "Current State"
  }

  dimension: csn_number {
    label: "CAN Number"
    type: number
    description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
    sql: ${TABLE}.current_state.csn_number ;;
    group_label: "Current State"
    hidden: yes
  }

  dimension: default_cost_type {
    label: "Default Cost Type"
    type: string
    description: "Indicates the cost used to compute values in cost-related fields for this table. Valid values are, Base Cost (BC) and Negotiated Item Cost (NIC)."
    sql: ${TABLE}.current_state.default_cost_type ;;
    group_label: "Current State"
  }

  dimension: default_cost_type_id {
    label: "Default Cost Type ID"
    type: string
    description: "Indicates the cost used to compute values in cost-related fields for this table. Valid values are, Base Cost (BC) and Negotiated Item Cost (NIC)."
    sql: ${TABLE}.current_state.default_cost_type_id ;;
    group_label: "Current State"
  }

  dimension: is_active_date_start_date {
    label: "Is Active Date Start Date"
    type: yesno
    description: "True, if this record in future_cost is the start date of a cost event or holds. False, if this record in future_cost is the reset date of a cost event."
    sql: ${TABLE}.current_state.is_active_date_start_date ;;
    group_label: "Current State"
  }

  dimension: origin_country_iso {
    label: "Origin Country Iso"
    type: string
    description: "The country, where a product was produced"
    sql: ${TABLE}.current_state.origin_country_iso ;;
    group_label: "Current State"
  }

  dimension: reclassification_number {
    label: "Reclassification Number"
    type: number
    description: "Identifies the reclassification that affected the costs for the sku/supplier/country/location/active date combination."
    sql: ${TABLE}.current_state.reclassification_number ;;
    group_label: "Current State"
  }

  measure: count {
    type: count
    drill_fields: [supplier_name]
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Historical Status
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: history {
    hidden: yes
    sql: ${TABLE}.history ;;
  }
}

# The name of this view in Looker is "Oracle Future Cost Fact History"
view: oracle_future_cost_fact__history {

  view_label: "Spot Cost Data"

  dimension_group: active {
    type: time
    description: "Date that the item/supplier/country/location combinations costs becomes active."
    group_label: "Historical Data"
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: active_date ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Amt Base Cost Net" in Explore.

  dimension: amt_base_cost_net {
    required_access_grants: [can_access_pricing_margins]

    type: number
    label: "Base Cost (Net)"
    description: "Base cost of the SKU/supplier/country at the given location. This is the same cost that is on the item_supp_country table."
    group_label: "Historical Data"
    sql: amt_base_cost_net ;;
    value_format_name: eur
  }

  dimension: amt_dead_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]

    type: number
    label: "Dead Net Net Cost (Net)"
    description: "Dead net net cost of the SKU/supplier/country at the given location. This is the net net cost minus any deal components designated as applying to dead net net cost on DEAL_DETAIL."
    group_label: "Historical Data"
    sql: amt_dead_net_net_cost_net ;;
    value_format_name: eur
  }

  dimension: amt_net_cost_net {
    required_access_grants: [can_access_pricing_margins]

    type: number
    label: "Net Cost (Net)"
    description: "Net cost of the SKU/supplier/country at the given location. This is the base cost minus any deal components designated as applying to net cost on DEAL_DETAIL."
    group_label: "Historical Data"
    sql: amt_net_cost_net ;;
  }

  dimension: amt_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]

    type: number
    label: "Net Net Cost (Net)"
    description: "Net net cost of the SKU/supplier/country at the given location. This is the net cost minus any deal components designated as applying to net net cost on DEAL_DETAIL."
    group_label: "Historical Data"
    sql: amt_net_net_cost_net ;;
    value_format_name: eur
  }

  dimension: amt_pricing_cost_net {
    required_access_grants: [can_access_pricing_margins]

    type: number
    label: "Pricing Cost (Net)"
    description: "Cost to be used to in pricing reviews. Pricing cost is the cost that will be interfaced with Oracle Price Management for use in pricing decisions."
    group_label: "Historical Data"
    sql: amt_pricing_cost_net ;;
    value_format_name: eur
  }

  dimension_group: calculation {
    type: time
    description: "Date when the cost was last calculated."
    group_label: "Historical Data"
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: calculation_date ;;
  }

  dimension: cost_change_id {
    type: number
    label: "Cost Change ID"
    description: "Identifies the cost change that affected the costs for the sku/supplier/country/location/active date combination."
    group_label: "Historical Data"
    sql: cost_change_id ;;
  }

  dimension: csn_number {
    type: number
    label: "CSN Number"
    description: "This is an Oracle standard field that refers to the commit number of an Oracle update or insert event. Every change to a table in Oracle is linked to a specific csn commit number"
    group_label: "Historical Data"
    sql: csn_number ;;
    hidden: yes
  }

  dimension: default_cost_type {
    type: string
    description: "Indicates the cost used to compute values in cost-related fields for this table. Valid values are, Base Cost (BC) and Negotiated Item Cost (NIC)."
    group_label: "Historical Data"
    sql: default_cost_type ;;
  }

  dimension: default_cost_type_id {
    type: string
    description: "Indicates the cost used to compute values in cost-related fields for this table. Valid values are, Base Cost (BC) and Negotiated Item Cost (NIC)."
    group_label: "Historical Data"
    sql: default_cost_type_id ;;
  }

  dimension: is_active_date_start_date {
    type: yesno
    description: "True, if this record in future_cost is the start date of a cost event or holds. False, if this record in future_cost is the reset date of a cost event."
    group_label: "Historical Data"
    sql: is_active_date_start_date ;;
  }

  dimension: last_dml_type {
    type: string
    description: "This is an Oracle standard field that indicates the kind of update, that was performed to a table row (I=Insert, U=Update, D=Delete, NULL=initial data load)"
    group_label: "Historical Data"
    sql: last_dml_type ;;
  }

  # This field is hidden, which means it will not show up in Explore.
  # If you want this field to be displayed, remove "hidden: yes".

  dimension: oracle_future_cost_fact__history {
    type: string
    description: "A bigquery array of structs object, that provides an ordered list of all modifications of a given table in Oracle."
    group_label: "Historical Data"
    hidden: yes
    sql: oracle_future_cost_fact__history ;;
  }

  dimension: origin_country_iso {
    type: string
    description: "The country, where a product was produced"
    sql: origin_country_iso ;;
  }

  dimension: reclassification_number {
    type: number
    description: "Identifies the reclassification that affected the costs for the sku/supplier/country/location/active date combination."
    group_label: "Historical Data"
    sql: reclassification_number ;;
  }

  dimension_group: valid_from {
    type: time
    description: "This timestamp defines from which time the data of a given row is valid"
    group_label: "Historical Data"
    timeframes: [
      time,
      date
    ]
    sql: valid_from_timestamp ;;
  }

  dimension_group: valid_to {
    type: time
    description: "This timestamp defines until which time the data of a given row is valid"
    group_label: "Historical Data"
    timeframes: [
      time,
      date
    ]
    sql: valid_to_timestamp ;;
  }
}
