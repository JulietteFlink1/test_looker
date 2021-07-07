include: "/cleaning/order_base.view.lkml"
include: "/user_order_facts.view.lkml"

explore: order_base {
  label: "Order Base"
  view_label: "* Order Base *"
  view_name: order_base
  group_label: "01) Performance"
  description: "This is the most basic Order Explore"
  always_filter: {
    filters:  [
      order_base.is_internal_order: "no",
      order_base.is_successful_order: "yes",
      order_base.created_date: "after 2021-01-25"
    ]
  }
}
