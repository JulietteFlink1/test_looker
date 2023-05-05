# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - This explore shows the most important KPIs for Supply Chain team combined in the same place.
# In here we can see:
         # Availability
         # Waste
         # Fill Rate
         # GMV


include: "/supply_chain/explores/master_reporting/supply_chain_master_report.view"
include: "/supply_chain/explores/master_reporting/native_derived_tables/ndt_waste_risk_index_calculation.view"
include: "/supply_chain/explores/master_reporting/native_derived_tables/ndt_handling_unit_rotation.view"
include: "/core/views/config/global_filters_and_parameters.view"
include: "/**/hubs_ct.view"
include: "/supply_chain/views/bigquery_curated/sku_promotions_date_ranges_definition.view.lkml"



explore: supply_chain_master {

  hidden: no

  persist_with: flink_daily_datagroup

  label: "Supply Chain Master Explore"
  group_label: "Supply Chain"

  from: supply_chain_master_report

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${supply_chain_master.report_date} {% endcondition %} ;;

  always_filter: {filters: [global_filters_and_parameters.datasource_filter: "8 days ago for 7 days"]}

  access_filter: {
    field: country_iso
    user_attribute: country_iso

  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: hubs {
    from: hubs_ct
    view_label: "Hubs"
    sql_on: lower(${supply_chain_master.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: ndt_waste_risk_index_calculation {
    view_label: "Supply Chain Master"
    sql_on: ${supply_chain_master.hub_code}     = ${ndt_waste_risk_index_calculation.hub_code} and
            ${supply_chain_master.parent_sku}   = ${ndt_waste_risk_index_calculation.parent_sku} and
            ${supply_chain_master.report_date}  = ${ndt_waste_risk_index_calculation.report_date};;
    relationship: many_to_one
    type: left_outer

  }

  join: ndt_handling_unit_rotation {
    view_label: "Supply Chain Master"
    sql_on: ${supply_chain_master.hub_code}     = ${ndt_handling_unit_rotation.hub_code} and
            ${supply_chain_master.parent_sku}   = ${ndt_handling_unit_rotation.parent_sku} and
            ${supply_chain_master.report_date}  = ${ndt_handling_unit_rotation.report_date};;
    relationship: many_to_one
    type: left_outer

  }

  join: sku_promotions_date_ranges_definition {
    view_label: "Supply Chain Master"
    sql_on: ${supply_chain_master.hub_code}     = ${sku_promotions_date_ranges_definition.hub_code} and
            ${supply_chain_master.parent_sku}   = ${sku_promotions_date_ranges_definition.parent_sku} and
            ${supply_chain_master.report_date} between ${sku_promotions_date_ranges_definition.valid_from_date} and ${sku_promotions_date_ranges_definition.valid_to_date};;
    relationship: one_to_one
    type: left_outer

    fields: [sku_promotions_date_ranges_definition.is_promotional_sku]

  }

  join: sku_promotions_valid_dates_definition_ranges {
    from: sku_promotions_date_ranges_definition
    view_label: "Supply Chain Master"
    sql_on: ${supply_chain_master.hub_code}     = ${sku_promotions_valid_dates_definition_ranges.hub_code} and
            ${supply_chain_master.parent_sku}   = ${sku_promotions_valid_dates_definition_ranges.parent_sku} and
            ${sku_promotions_valid_dates_definition_ranges.valid_to_date} >= ${supply_chain_master.report_date};;
    relationship: many_to_one
    type: left_outer

    fields: [sku_promotions_valid_dates_definition_ranges.valid_from_date, sku_promotions_valid_dates_definition_ranges.valid_to_date]

  }

}
