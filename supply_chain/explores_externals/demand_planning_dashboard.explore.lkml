# Owner:
# Daniel Tancu
#
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around demand planning
# - Questions around availability, waste and OTIFIQ topics

include: "/supply_chain/explores/master_reporting/supply_chain_master_report.view"
include: "/supply_chain/views_externals/availability_waterfall.view.lkml"
include: "/supply_chain/views_externals/promotions.view.lkml"
include: "/**/products_hub_assignment.view"
include: "/core/views/config/global_filters_and_parameters.view"
include: "/supply_chain/supply_chain_config.view.lkml"
include: "/core/views/bq_curated/hubs_ct.view.lkml"
include: "/pricing/views/bigquery_reporting/key_value_items.view.lkml"
include: "/core/views/bq_curated/products.view.lkml"

explore: demand_planning_dashboard_explore {

  from: supply_chain_master_report

  group_label: "Demand Planning"
  label: "Demand Planning Explore (Owned by Supply Chain team)"
  description: "Extended Supply Chain explore used for the Demand Planning Dashboard"
  hidden: no

# take all fields from the Supply Chain Master Explore and the required fields from other joined views
  fields: [ALL_FIELDS*]

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${demand_planning_dashboard_explore.report_date} {% endcondition %} ;;
  always_filter: {filters: [global_filters_and_parameters.datasource_filter: "8 days ago for 7 days"]}

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }
  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
 }

  join: supply_chain_config {
  sql: ;;
  relationship: one_to_one
 }

####################################################################################################################################
###################### Join hubs in order to get the city + hub is active (yes/no) fields ##########################################
####################################################################################################################################

join: hubs_ct {
  from: hubs_ct
  type: left_outer
  relationship: many_to_one
  sql_on:
     ${hubs_ct.hub_code} = ${demand_planning_dashboard_explore.hub_code}
    ;;

  fields: [hubs_ct.city, hubs_ct.city_tier,hubs_ct.is_active_hub]
 }

####################################################################################################################################
###################### Join key_value_times in order to get the is_kvi and kvi_date fields #########################################
####################################################################################################################################

join: key_value_items {
  from: key_value_items
  type: left_outer
  relationship: many_to_one

  sql_on:
     ${key_value_items.sku} = ${demand_planning_dashboard_explore.parent_sku} and
     ${key_value_items.kvi_date} >= current_date() - 6
    ;;

  fields: [key_value_items.is_kvi, key_value_items.kvi_ranking]
 }

####################################################################################################################################
###################### Join products_ct_merged_skus in order to get the rezeptkarte filtering fields ###############################
####################################################################################################################################

join: products {

  view_label: "Products (CT)"
  sql_on:
     ${demand_planning_dashboard_explore.parent_sku} = ${products.replenishment_substitute_group_parent_sku} and
     ${demand_planning_dashboard_explore.country_iso} = ${products.country_iso}
    ;;
  relationship: many_to_one
  type: left_outer
  fields: [products.is_rezeptkarte]
 }

####################################################################################################################################
###################### Join promotions in order to get the Product-Locations info on Promotion SKUs #######################################
####################################################################################################################################

join: promotions {
  view_label: "Promotions Data"
  sql_on:
     ${demand_planning_dashboard_explore.parent_sku} = ${promotions.sku} and
     ${demand_planning_dashboard_explore.report_date} = ${promotions.report_date}
    ;;
  relationship: many_to_one
  type: left_outer
 }

####################################################################################################################################
###################### Join availability_waterfall in order to get the avail. buckets fields #######################################
####################################################################################################################################

join: availability_waterfall {
  view_label: "Availability waterfall"
  sql_on:
     ${demand_planning_dashboard_explore.parent_sku} = ${availability_waterfall.sku} and
     ${demand_planning_dashboard_explore.hub_code} = ${availability_waterfall.hub_code} and
     ${demand_planning_dashboard_explore.report_week} = ${availability_waterfall.report_week_week} and
     ${demand_planning_dashboard_explore.vendor_id} = ${availability_waterfall.supplier_id} and
     ${availability_waterfall.ingestion_date} = date_trunc(current_date(),isoweek)
    ;;
  relationship: one_to_one
  type: left_outer
 }

}
