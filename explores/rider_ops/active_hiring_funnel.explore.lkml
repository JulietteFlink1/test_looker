include: "/views/projects/rider_ops/fountain_funnel_pipeline.view"

explore: fountain_funnel_pipeline {
  hidden: no
  label: "Active Hiring Funnel"
  view_label: "Active Hiring Funnel"
  description: "Rider/Picker Funnel Latest Snapshot"
  group_label: "Rider Ops"

  access_filter: {
    field: fountain_funnel_pipeline.country
    user_attribute: country_iso
  }

  access_filter: {
    field: fountain_funnel_pipeline.city
    user_attribute: city
  }

}
