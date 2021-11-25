include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: psp_transactions {
  from: psp_transactions
  view_label: "* PSP Transactions *"
  group_label: "Finance"

join: orders {
  view_label: "* Orders *"
  from: orders
  sql_on: psp_transactions.order_uuid = orders.order_uuid ;;
  type: left_outer
  relationship: many_to_one
  }

  join: hubs {
    from: hubs_ct
    view_label: "* Hubs *"
    sql_on: lower(${orders.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: "* Shifts *"
    sql_on: ${orders.created_date} = ${shyftplan_riders_pickers_hours.date} and
      ${hubs.hub_code}          = lower(${shyftplan_riders_pickers_hours.hub_name});;
    relationship: many_to_one
    type: left_outer
  }

}
