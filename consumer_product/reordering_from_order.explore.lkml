include: "/views/sql_derived_tables/reordering_from_order.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: reordering_from_order {
  hidden: no
  view_name:  reordering_from_order
  label: "Reordering Timing"
  view_label: "Reordering Timing"
  group_label: "Consumer Product"
  description: "Reordering Timing"

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${reordering_from_order.order_timestamp_date} {% endcondition %} ;;

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

}
