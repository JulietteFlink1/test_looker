include: "/views/bigquery_tables/curated_layer/app_session_events.view.lkml"


explore: app_session_events {
  label: "App Events per Session"
  view_label: "App Events - Sessions"
  group_label: "In-app tracking data"
  description: "App events per session"
  always_filter: {
    filters:  [
      app_session_events.event_start_at_date: "",
      app_session_events.event_name: ""
    ]
  }
}
