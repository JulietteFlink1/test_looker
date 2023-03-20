include: "/marketing/views/bigquery_reporting/offline_customer_acquisition_cost.view.lkml"

explore: offline_customer_acquisition_cost {
  hidden: no
  view_name: offline_customer_acquisition_cost
  label: "Offline Marketing CAC"
  view_label: "Offline"
  group_label: "Marketing"
  description: "Cost of customer acquisition for offline channels"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#  - - - - - - - - - -    FILTER & SETTINGS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  always_filter: {
    filters: [
      offline_customer_acquisition_cost.report_week: "last 4 weeks",
      offline_customer_acquisition_cost.date_granularity: "Week",
      offline_customer_acquisition_cost.country_iso: "",
      offline_customer_acquisition_cost.channel: "",
      offline_customer_acquisition_cost.network: ""

    ]
  }

  access_filter: {
    field: offline_customer_acquisition_cost.country_iso
    user_attribute: country_iso
  }

}
