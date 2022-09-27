include: "/**/employee_level_kpis.view.lkml"
include: "/**/hubs_ct.view"

explore: employee_level_kpis {
  group_label: "Rider Ops"
  view_label: "Employee Level KPIs"
  label: "Employee Level KPIs"
  description: "Daily aggregation of shift, ops and NPS related kpis as well as employment info in per distinct hub employee and position"
  hidden: no


  always_filter: {
    filters:  [
      employee_level_kpis.shift_date: "last 7 days",
      employee_level_kpis.is_employed: "",
      employee_level_kpis.position_name:"",
      employee_level_kpis.assigned_position_name:"",
      hubs.country: "",
      hubs.hub_name: "",
      home_hub.country: "",
      home_hub.hub_name: ""
    ]
  }

  join: hubs {
    from: hubs_ct
    view_label: "Scheduled Hub"
    sql_on:
    lower(${employee_level_kpis.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

    join: home_hub {
      from: hubs_ct
      view_label: "Home Hub"
      sql_on:
          lower(${employee_level_kpis.home_hub_code}) = lower(${home_hub.hub_code}) ;;
      relationship: many_to_one
      type: left_outer
    }

}
