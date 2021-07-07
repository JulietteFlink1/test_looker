include: "/cleaning/order_base.view.lkml"
include: "/explores/cleaning_ricardo/order_base.explore"
include: "/user_order_facts.view.lkml"

explore: user_order_facts {
  #from: order_base
  extends: [order_base]
  view_label: "User Order Facts"
  # The additional things you want to add or change
  # in the new Explore
  join: user_order_facts {
    sql_on: ${order_base.country_iso} = ${user_order_facts.country_iso} and
      ${order_base.user_email} = ${user_order_facts.user_email};;
    type: left_outer
    relationship: many_to_one
  }
}
