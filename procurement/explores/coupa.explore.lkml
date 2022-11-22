include: "/*/**/coupa_budgeting.view.lkml"
include: "/*/**/coupa_orders_and_invoices_merged.view.lkml"
include: "/**/hubs_ct.view"
include: "/**/global_filters_and_parameters.view.lkml"

# This explore provides information about the budget, orders and invoices of hubs.
# Author: Victor Breda
# Created: 2022-11-22

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

  access_filter: {
    field: coupa_budgeting.country_iso
    user_attribute: country_iso
  }

  join: hubs {
    from: hubs_ct
    view_label: "Hubs"
    sql_on: ${coupa_budgeting.hub_code} = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: coupa_orders_and_invoices_merged {
    view_label: "Orders"
    sql_on: ${coupa_budgeting.hub_code} = ${coupa_orders_and_invoices_merged.hub_code}
    and ${coupa_budgeting.period_name} = ${coupa_orders_and_invoices_merged.period_name}
    and ${coupa_budgeting.cost_center_id} = ${coupa_orders_and_invoices_merged.cost_center_id}
    and case when ${coupa_budgeting.gl_account_id} is null
                then 1 = 1
              else ${coupa_budgeting.gl_account_id} = ${coupa_orders_and_invoices_merged.gl_account_id}
        end
    and {% condition global_filters_and_parameters.datasource_filter %} ${coupa_orders_and_invoices_merged.order_created_date} {% endcondition %} ;;
    relationship: one_to_many
    type: left_outer
  }

}
