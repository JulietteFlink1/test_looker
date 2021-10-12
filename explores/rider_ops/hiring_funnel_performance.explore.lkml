include: "/views/projects/rider_ops/hiring_funnel_performance_summary.view"

explore: hiring_funnel_performance_summary {
  hidden: no
  label: "Hiring Funnel Performance Summary"
  view_label: "Hiring Funnel Performance Summary"
  description: "Rider/Picker leads, hires, marketing spend, days to hire, etc."
  group_label: "Rider Ops"

  access_filter: {
    field: hiring_funnel_performance_summary.country
    user_attribute: country_iso
  }

  access_filter: {
    field: hiring_funnel_performance_summary.city
    user_attribute: city
  }

}
