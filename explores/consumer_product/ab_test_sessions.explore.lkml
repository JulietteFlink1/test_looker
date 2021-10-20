include: "/views/bigquery_tables/curated_layer/app_sessions.view.lkml"
include: "/views/projects/consumer_product/app_users.view.lkml"
include: "/views/bigquery_tables/curated_layer/app_session_events.view.lkml"

explore: ab_test_sessions {
  hidden: no
  view_name:  app_sessions
  label: "A/B test experiments - sessions"
  view_label: "A/B test experiments"
  group_label: "In-app tracking data"
  description: "A/B test experiments - mulitple tests"


join: app_users {
  from:  app_users
  view_label: "App Users"
  sql_on: ${app_sessions.anonymous_id} = ${app_users.anonymous_id} ;;
  relationship: many_to_one
  type: left_outer
}
  join: app_session_events {
    from:  app_session_events
    view_label: "App Session Events"
    sql_on: ${app_session_events.anonymous_id} = ${app_users.anonymous_id} ;;
    relationship: many_to_one
    type: left_outer
  }

}
