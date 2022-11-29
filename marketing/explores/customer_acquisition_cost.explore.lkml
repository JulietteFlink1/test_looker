include: "/*/**/customer_acquisition_cost.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: customer_acquisition_cost {

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    BASE TABLE
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  hidden: no
  view_name: customer_acquisition_cost
  label: "Online Marketing CAC"
  view_label: "Online"
  group_label: "Marketing"
  description: "Cost of customer acquisition for online channels"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    FILTER & SETTINGS
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  always_filter: {
    filters: [
      customer_acquisition_cost.report_week: "last 4 weeks",
      customer_acquisition_cost.date_granularity: "Week",
      customer_acquisition_cost.campaign_country: "",
      customer_acquisition_cost.partner_name: ""

    ]
  }

}
