include: "/**/vehicle_suppliers.view"
include: "/**/vehicle_damages.view"
include: "/**/hubs_ct.view"


explore: fleet_management {
  from: vehicle_suppliers
  view_label: "Vehicles & Suppliers"

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  join: vehicle_damages {
    view_label: "Vehicle Damages"
    sql_on: ${fleet_management.vehicle_id} = ${vehicle_damages.vehicle_id}
        and ${fleet_management.supplier_id} = ${vehicle_damages.supplier_id};;
    type: left_outer
    relationship: one_to_many
  }

  join: hubs_ct {
    view_label: "Hubs"
    sql_on: ${fleet_management.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: one_to_one
  }
}
