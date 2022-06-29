include: "/marketing/views/bigquery_reporting/offline_customer_acquisition_cost.view.lkml"

explore: offline_customer_acquisition_cost {
  hidden: yes
  view_name: offline_customer_acquisition_cost
  label: "Offline Marketing CAC"
  view_label: "Offline"
  group_label: "Marketing"
  description: "Cost of customer acquisition for offline channels"

}
