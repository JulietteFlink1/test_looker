include: "/cleaning/order_base.view.lkml"
include: "/cleaning/user_order_facts_clean.view.lkml"
#include: "/explores/cleaning_ricardo/order_base.explore"
include: "/explores/base_explores/base_orders.explore"
include: "/hub_order_facts.view.lkml"

explore: user_order_facts {
  group_label: "01) Performance"
  label: "User Order Facts Clean"
  description: "This is the clean version of user order facts"
  extends: [base_orders]
  view_label: "User Order Facts Clean"
  # The additional things you want to add or change
  # in the new Explore
  join: user_order_facts_clean {
    sql_on: ${base_orders.country_iso} = ${user_order_facts_clean.country_iso} and
      ${base_orders.user_email} = ${user_order_facts_clean.user_email};;
    type: left_outer
    relationship: many_to_one
  }

  join: hub_order_facts {
    sql_on: ${base_orders.country_iso} = ${hub_order_facts.country_iso} AND
      ${base_orders.warehouse_name} = ${hub_order_facts.warehouse_name}  ;;
      type: left_outer
      relationship: many_to_one
  }
}
