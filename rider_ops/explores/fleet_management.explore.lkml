include: "/**/vehicle_suppliers.view"
include: "/**/vehicle_damages.view"
include: "/**/vehicle_uptime_metrics.view"
include: "/**/vehicle_damages_daily.view"
include: "/**/hubs_ct.view"

explore: fleet_management {
  from: vehicle_suppliers
  view_label: "Vehicles & Suppliers"

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters:  [
      fleet_management.supplier_name: "",
      fleet_management.supplier_code: "",
      fleet_management.operational_status: "",
      vehicle_uptime_metrics.report_date: "",
      fleet_management.country_iso: "",
      fleet_management.hub_code: ""
    ]
  }

  join: vehicle_damages {
    view_label: "Vehicle Damages"
    sql_on: ${fleet_management.vehicle_id} = ${vehicle_damages.vehicle_id}
        and ${fleet_management.supplier_id} = ${vehicle_damages.supplier_id};;
    type: left_outer
    relationship: one_to_many
  }

  join: vehicle_uptime_metrics {
    view_label: "Vehicle Uptime Metrics"
    sql_on: ${fleet_management.supplier_id} = ${vehicle_uptime_metrics.supplier_id}
        and ${fleet_management.hub_code} = ${vehicle_uptime_metrics.hub_code}
        and ${fleet_management.vehicle_id} = ${vehicle_uptime_metrics.vehicle_id} ;;
    type: left_outer
    relationship: one_to_many
  }

  join: vehicle_damages_daily {
    view_label: "Vehicle Uptime Metrics"
    sql_on: ${vehicle_uptime_metrics.supplier_id} = ${vehicle_damages_daily.supplier_id}
    and ${vehicle_uptime_metrics.vehicle_id} = ${vehicle_damages_daily.vehicle_id}
    and ${vehicle_uptime_metrics.report_date} = ${vehicle_damages_daily.report_date};;
    type: left_outer
    relationship: one_to_many
  }

  join: hubs_ct {
    view_label: "Hubs"
    sql_on: ${fleet_management.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }

}
