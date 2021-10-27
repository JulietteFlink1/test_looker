include: "/views/bigquery_tables/reporting_layer/rider_ops/city_level_employees_capacity.view.lkml"

explore: city_level_employees_capacity {
  hidden: no
  label: "City level employees capacity"
  view_label: "Employees City Level Capacity"
  description: "City employees operational KPIs, worked hours, planned hours, no_show hours, etc."
  group_label: "Rider Ops"


}
