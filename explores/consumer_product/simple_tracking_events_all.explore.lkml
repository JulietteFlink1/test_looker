include: "/views/projects/consumer_product/simple_tracking_events_all.view.lkml"

explore: simple_tracking_events_all {
  view_name: simple_tracking_events_all
  label: "Events All, Prev and Next"
  view_label: "Events All, Prev and Next"
  group_label: "Consumer Product"
  description: "This explore exposes the order of all tracking events and is suitable for checks on the absolute number of certain events. Also has fields previous_event and next_event to support more detailed selection."
  hidden: yes
}
