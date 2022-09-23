include: "/**/employee_level_kpis.view.lkml"
include: "/**/employee_level_info.view.lkml"
include: "/**/hub_fleet_date_grid.view.lkml"
include: "/**/hubs_ct.view"

# explore: employee_level_kpis {
#   group_label: "Rider Ops"
#   view_label: "* Employee Level KPIs *"
#   label: "Employee Level KPIs"
#   description: "Daily aggregation of shift, ops and NPS related kpis as well as employment info in per distinct hub employee and position"
#   hidden: no

  explore: hub_fleet_date_grid {
    from: hub_fleet_date_grid
    group_label: "Rider Ops"
    view_label: "Date Grid"
    label: "Employee Level KPIs"
    hidden: no

  # always_filter: {
  #   filters:  [
  #     employee_level_kpis.shift_date: "last 7 days",
  #     employee_level_kpis.position_name:"rider",
  #     hubs.country: "",
  #     hubs.hub_name: ""
  #   ]
  # }

    join: employee_level_kpis {
      from: employee_level_kpis
      view_label: "Employee Level KPIs"
      sql_on: ${hub_fleet_date_grid.employment_id} = ${employee_level_kpis.employment_id}
        and ${hub_fleet_date_grid.shift_date} = ${employee_level_kpis.shift_date};;
      relationship: one_to_one
      type: left_outer
    }

    join: employee_level_info {
      from: employee_level_info
      view_label: "Employee Level Info"
      sql_on: ${hub_fleet_date_grid.employment_id} = ${employee_level_info.employment_id};;
      relationship: one_to_one
      type: left_outer
    }

  join: worked_hub {
    from: hubs_ct
    view_label: "Worked Hub"
    sql_on:
    lower(${employee_level_kpis.hub_code}) = lower(${worked_hub.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

    join: home_hub {
      from: hubs_ct
      view_label: "Home Hub"
      sql_on:
          lower(${hub_fleet_date_grid.hub_code}) = lower(${home_hub.hub_code}) ;;
      relationship: many_to_one
      type: left_outer
    }

}
