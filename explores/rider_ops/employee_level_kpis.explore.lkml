include: "/views/bigquery_tables/reporting_layer/rider_ops/employee_level_kpis.view.lkml"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

explore: employee_level_kpis {
  group_label: "Rider Ops"
  view_label: "* Employee Level KPIs *"
  label: "Employee Level KPIs"
  description: "Daily aggregation of shift and ops related kpis as well as employment info in per distinct hub employee and position"
  hidden: no


  always_filter: {
    filters:  [
      employee_level_kpis.shift_date: "last 14 days",
      position_name:"rider",
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }

  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${employee_level_kpis.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
