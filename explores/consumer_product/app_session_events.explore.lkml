include: "/views/bigquery_tables/curated_layer/app_session_events.view.lkml"


explore: app_session_events {
  label: "App Session Events"
  view_label: "App Events - Sessions"
  group_label: "In-app tracking data"
  description: "App events per session"
  always_filter: {
    filters:  [
      app_session_events.event_start_at_date: "last 7 days",
      app_session_events.event_name: ""
    ]
  }
}
