include: "/**/rider_hub_nps.view.lkml"

explore: all_rider_nps {
  hidden:yes
  from: rider_hub_nps
  label: "Rider NPS"
  view_label: "Rider NPS"
  group_label: "Rider Ops"
  description: "Rider NPS Results"

  access_filter: {
    field: all_rider_nps.country_iso
    user_attribute: country_iso
  }}
