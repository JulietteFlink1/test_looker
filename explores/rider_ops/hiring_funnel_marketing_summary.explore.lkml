include: "/views/projects/rider_ops/hiring_funnel_marketing_summary.view"

explore: hiring_funnel_marketing_summary {
  hidden: no
  label: "Hiring Funnel Marketing Summary"
  view_label: "Hiring Funnel Marketing Summary"
  description: "Rider/Picker leads, hires, marketing spend, days to hire, etc."
  group_label: "09) Rider Ops"

  access_filter: {
    field: hiring_funnel_marketing_summary.country
    user_attribute: country_iso
  }

  access_filter: {
    field: hiring_funnel_marketing_summary.city
    user_attribute: city
  }

}
