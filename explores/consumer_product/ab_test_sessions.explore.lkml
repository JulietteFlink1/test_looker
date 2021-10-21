include: "/views/projects/consumer_product/ab_test_sessions.view.lkml"

explore: ab_test_sessionst {
  hidden: no
  view_name:  ab_test_sessions
  label: "A/B Test sessions"
  view_label: "A/B Test sessions"
  group_label: "In-app tracking data"
  description: "A/B Test sessions"
}
