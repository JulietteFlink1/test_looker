include: "/views/bigquery_tables/reporting_layer/rider_ops/city_level_employees_capacity.view.lkml"
include: "/views/bigquery_tables/reporting_layer/rider_ops/orders_aggregated.view.lkml"

explore: city_level_employees_capacity {
  hidden: no
  label: "City level employees capacity"
  view_label: "Employees City Level Capacity"
  description: "City employees operational KPIs, worked hours, planned hours, no_show hours, etc."
  group_label: "Rider Ops"


join: orders_aggregated {
view_label: "* Orders*"
sql_on: lower(${orders_aggregated.city}) = lower(${city_level_employees_capacity.city})
  and ${orders_aggregated.start_period_date} = ${city_level_employees_capacity.start_period_date}
  and ${orders_aggregated.end_period_date} = ${city_level_employees_capacity.end_period_date};;
relationship: many_to_one
type: left_outer
}


}
