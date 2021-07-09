include: "/cleaning/order_fulfillment_clean.view.lkml"
include: "/cleaning/order_fulfillment_facts_clean.view.lkml"
include: "/explores/base_explores/base_orders.explore"

explore: base_order_fulfillment {
  #group_label: "01) Performance"
  #label: "Order Fulfillment"
  description: "This is the clean version of order fulfillment data"
  extends: [base_orders]
  #view_label: "Order Fulfillment Clean"
  # The additional things you want to add or change
  # in the new Explore
  join: order_fulfillment_clean {
    sql_on: ${base_orders.country_iso} = ${order_fulfillment_clean.country_iso} and
      ${base_orders.id} = ${order_fulfillment_clean.order_id};;
    type: left_outer
    relationship: one_to_many
  }

  join: order_fulfillment_facts_clean {
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_fulfillment_facts_clean.country_iso} = ${order_fulfillment_clean.country_iso} AND
      ${order_fulfillment_facts_clean.order_fulfillment_id} = ${order_fulfillment_clean.id} ;;
  }
}
