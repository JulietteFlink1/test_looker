include: "/views/bigquery_tables/gsheets/all_rider_nps.view.lkml"

explore: all_rider_nps {
  hidden:no
  from: all_rider_nps
  label: "Rider NPS"
  view_label: "Rider NPS"
  group_label: "18) People Ops"
  description: "Rider NPS Results"
  }
