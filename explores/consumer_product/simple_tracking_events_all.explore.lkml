include: "/views/projects/consumer_product/simple_tracking_events_all.view.lkml"

explore: simple_tracking_events_all {
  view_name: simple_tracking_events_all
  label: "Tracking Events Prev and Next Simple View"
  view_label: "Tracking Events Prev and Next Simple View"
  group_label: "In-app tracking data"
  description: "This explore exposes the order of all tracking events and is suitable for checks on the absolute number of certain events. Also has fields previous_event and next_event to support more detailed selection."
}
