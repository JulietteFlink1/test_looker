include: "/**/quinyx_raw_data_monitoring.view.lkml"


explore: quinyx_raw_data_monitoring {
  group_label: "Internal"
  view_label: "Quinyx Raw Data Monitoring"
  label: "Quinyx Raw Data Monitoring"
  description: "Daily Aggregation of number of rows based on extraction timestamps and loading method. This explore will be used to monitor Quinyx missing data over time."
  hidden: yes
}
