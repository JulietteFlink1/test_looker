include: "/marketing/views/bigquery_reporting/run_rate_target_estimation.view.lkml"

explore: run_rate_target_estimation {
  hidden: no
  label: "Run Rates Forecasting"
  view_label: "Targets"
  group_label: "Marketing"
  description: "Comparing Monthly Targets with real data and forecasting for the end of the month"

}
