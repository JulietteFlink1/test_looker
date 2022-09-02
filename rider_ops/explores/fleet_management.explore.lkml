include: "/**/vehicle_suppliers.view"
include: "/**/vehicle_damages.view"


explore: fleet_management {
  from: vehicle_suppliers
  view_label: "Vehicles & Suppliers"

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  join: vehicle_damages {
    view_label: "Vehicle Damages"
    sql_on: ${fleet_management.updated_at_week} = ${vehicle_damages.vehicle_id}
        and ${fleet_management.supplier_id} = ${vehicle_damages.supplier_id};;
    type: left_outer
    relationship: one_to_many
  }
}
