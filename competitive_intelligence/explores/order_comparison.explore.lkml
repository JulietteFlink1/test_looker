include: "/competitive_intelligence/views/**/*.view.lkml"
include: "/competitive_intelligence/explores/**/*.explore.lkml"
include: "/explores/base_explores/orders_cl.explore.lkml"

explore: competitive_intelligence_order_comparison {
  view_name: competitive_intelligence_order_comparison
  label: "* Order Comparison *"
  view_label: "* Order Comparison *"
  hidden: yes
  group_label: "8) Competitive Intelligence"
  description: "Order Comparison of Flink & Gorillas"
}
