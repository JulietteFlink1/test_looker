include: "/**/*.view"
include: "/**/*.explore"


explore: web_orders {
  extends: [orders_cl]
  #view_name: orders_cl  # needs to be set in order that the base_explore can be extended and referenced properly
  hidden: yes

  # group_label: "01) Performance"
  # label: "Orders"
  # description: "General Business Performance - Orders, Revenue, etc."
  #view_label: "* Orders *"

  always_filter: {
    filters:  [
      orders_cl.is_successful_order: "yes",
      web_orders.order_date: "after 2021-09-20",
      hubs.country: "",
      hubs.hub_name: "",
      web_orders.platform: "web"
    ]
  }
  access_filter: {
    field: orders_cl.country_iso
    user_attribute: country_iso
  }

  join: web_orders {
    from: web_orders
    sql_on: ${orders_cl.country_iso}   = ${web_orders.country_iso} AND
      ${orders_cl.order_number}  =       ${web_orders.order_number} ;;
    relationship: one_to_one
    type: full_outer

  }

  join: hubs {
    from: hubs_ct
    view_label: "* Hubs *"
    sql_on: lower(${orders_cl.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: "* Shifts *"
    sql_on: ${orders_cl.created_date} = ${shyftplan_riders_pickers_hours.date} and
      ${hubs.hub_code}          = lower(${shyftplan_riders_pickers_hours.hub_name});;
    relationship: many_to_one
    type: left_outer
  }

  join: nps_after_order {
    from: nps_after_order_cl
    view_label: "* NPS CL*"
    sql_on: ${orders_cl.country_iso}   = ${nps_after_order.country_iso} AND
      ${orders_cl.order_number}  =       ${nps_after_order.order_number} ;;
    relationship: one_to_many
    type: left_outer

  }

  # join: issue_rates_clean {
  #   view_label: "* Order Issues on Hub-Level *"
  #   sql_on: ${hubs.hub_code}           =  ${issue_rates_clean.hub_code} and
  #     ${orders_cl.date}          =  ${issue_rates_clean.date_dynamic};;
  #   relationship: many_to_one # decided against one_to_many: on this level, many orders have hub-level issue-aggregates
  #   type: left_outer
  # }

  join: cs_post_delivery_issues {
    view_label: "* Post Delivery Issues on Order-Level *"
    sql_on: ${orders_cl.country_iso} = ${cs_post_delivery_issues.country_iso} AND
      ${cs_post_delivery_issues.order_nr_} = ${orders_cl.order_number};;
    relationship: one_to_many
    type: left_outer
  }

}
