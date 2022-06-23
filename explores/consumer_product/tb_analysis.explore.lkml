# include: "/views/projects/consumer_product/order_placed_tb_analysis.view.lkml"
include: "/views/projects/consumer_product/tracking_events_analysis.view.lkml"

explore: tb_analysis {
  hidden: yes
  view_name:  tracking_events_analysis
  label: "TB Analysis"
  view_label: "TB Analysis"
  group_label: "Consumer Product"
  description: "TB Analysis Of Event Sizes"
}
