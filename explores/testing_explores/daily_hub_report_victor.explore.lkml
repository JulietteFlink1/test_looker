include: "/views/bigquery_tables/flink-data-dev/sandbox_victor/hub_daily_report_victor.view.lkml"

explore: hub_daily_report_victor {
  from: hub_daily_report_victor
  view_name: hub_daily_report_victor
  group_label: "testing_explores"
  description: "This explore provides information on daily hub performances"

  hidden: yes
}
