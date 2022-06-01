include: "/marketing/views/bigquery_reporting/customer_acquisition_cost.view.lkml"

explore: customer_acquisition_cost {
  hidden: no
  view_name: customer_acquisition_cost
  label: "Online Marketing CAC"
  view_label: "Online"
  group_label: "Marketing"
  description: "Cost of customer acquisition for online channels"
  always_filter: {
    filters:  [
      customer_acquisition_cost.report_week: "2022/01/03 to 2022/05/31"
    ]
  }

}
