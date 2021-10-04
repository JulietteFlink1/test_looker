include: "/views/projects/consumer_product/order_placed_tb_analysis.view.lkml"

explore: tb_analysis {
  hidden: yes
  view_name:  order_placed_tb_analysis
  label: "TB Analysis"
  view_label: "TB Analysis"
  group_label: "10) In-app tracking data"
  description: "TB Analysis Of Event Sizes"
}
