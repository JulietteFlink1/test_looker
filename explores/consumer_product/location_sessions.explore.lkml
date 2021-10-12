include: "/views/projects/consumer_product/location_segment_sessions.view.lkml"

explore: location_sessions {
  view_name: location_segment_sessions
  label: "Location Segment-based Sessions"
  view_label: "Location Segment-based Sessions"
  group_label: "In-app tracking data"
  description: "Location-centered tracking events in sessions format"
}
