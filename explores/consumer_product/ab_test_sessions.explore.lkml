include: "/views/projects/consumer_product/ab_test_sessions.view.lkml"

explore: ab_test_sessionst {
  hidden: yes
  view_name:  ab_test_sessions
  label: "A/B Test sessions"
  view_label: "A/B Test sessions"
  group_label: "Consumer Product"
  description: "A/B Test sessions"
}
