include: "/**/employees_hub_level_capacity.view.lkml"
include: "/**/orders_cl.explore"

explore: employees_hub_level_capacity {
  hidden: yes
  label: "Employees Hub Level Capacity"
  view_label: "Employees Hub Level Capacity"
  description: "Hub employees operational KPIs, worked hours, planned hours, no_show hours, etc."
  group_label: "Rider Ops"
  extends: [orders_cl]

  join: employees_hub_level_capacity {
    view_label: "* Employees_hub Level Capacity*"
    sql_on: lower(${orders_cl.hub_code}) = ${employees_hub_level_capacity.hub_code}
      and ${employees_hub_level_capacity.shift_week_date} = ${orders_cl.order_date};;
    relationship: one_to_many
    type: left_outer
  }

}
