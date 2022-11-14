include: "/*/**/coupa_budgeting.view.lkml"
include: "/*/**/coupa_ordering.view.lkml"
include: "/**/hubs_ct.view"
include: "/**/global_filters_and_parameters.view.lkml"



explore: coupa {
  from: coupa_budgeting
  view_name: coupa_budgeting
  group_label: "Procurement"
  view_label: "Budgeting"
  label: "Coupa"
  description: "This explore provides information on Coupa data."

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${coupa_budgeting.period_start_date} {% endcondition %} ;;

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
  fields: [datasource_filter]
  }

  join: hubs {
    from: hubs_ct
    view_label: "Hubs"
    sql_on: ${coupa_budgeting.hub_code} = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: coupa_ordering {
    view_label: "Orders"
    sql_on: ${coupa_budgeting.hub_code} = ${coupa_ordering.hub_code}
    and ${coupa_budgeting.period_name} = ${coupa_ordering.period_name}
    and {% condition global_filters_and_parameters.datasource_filter %} ${coupa_ordering.order_created_date} {% endcondition %} ;;
    relationship: many_to_many
    type: full_outer
  }

}
