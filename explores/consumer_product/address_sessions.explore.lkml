include: "/views/bigquery_tables/curated_layer/address_sessions.view.lkml"

explore: address_sessions {
  hidden: yes
  view_name: address_sessions
  label: "Address Sessions"
  view_label: "Address Sessions"
  group_label: "Consumer Product"
  description: "Address-centered tracking events in sessions format"
}
