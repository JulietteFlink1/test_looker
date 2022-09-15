include: "/**/vehicle_suppliers.view"
include: "/**/vehicle_damages.view"
include: "/**/hubs_ct.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: fleet_management {
  from: vehicle_suppliers
  view_label: "Vehicles & Suppliers"

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${fleet_management.created_date} {% endcondition %} ;;

  always_filter: {
    filters:  [
      fleet_management.supplier_name: "",
      fleet_management.supplier_code: "",
      fleet_management.operational_status: "",
      global_filters_and_parameters.datasource_filter: "last 2 years",
      fleet_management.country_iso: "",
      fleet_management.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
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
    relationship: many_to_one
  }
}
