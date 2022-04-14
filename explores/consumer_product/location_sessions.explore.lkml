include: "/views/projects/consumer_product/location_segment_sessions.view.lkml"

explore: location_sessions {
  hidden: yes
  view_name: location_segment_sessions
  label: "Address Sessions"
  view_label: "Address Sessions"
  group_label: "Consumer Product"
  description: "Address-centered tracking events in sessions format"
}
