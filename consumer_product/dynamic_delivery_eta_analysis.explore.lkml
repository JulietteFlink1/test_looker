include: "/**/dynamic_delivery_eta_analysis.view.lkml"

explore: dynamic_delivery_eta_analysis {
  hidden: yes
  view_name: dynamic_delivery_eta_analysis
  label: "[internal] Delivery ETA analysis"
  view_label: "[internal] Delivery ETA analysis"
  group_label: "Consumer Product"
}
