include: "/**/quinyx_raw_data_monitoring.view.lkml"


explore: quinyx_raw_data_monitoring {
  group_label: "Internal"
  view_label: "Quinyx Raw Data Monitoring"
  label: "Quinyx Raw Data Monitoring"
  description: "Daily Aggregation of number of row based on extaction timestamp and loading mothod, this explore will be used in monitor Quinyx missing data over time"
  hidden: yes
}
