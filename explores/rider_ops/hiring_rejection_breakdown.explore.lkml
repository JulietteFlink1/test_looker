include: "/views/projects/rider_ops/fountain_rejection_breakdown.view"

explore: fountain_rejection_breakdown {
  hidden: no
  label: "Hiring Funnel Rejection Breakdown"
  view_label: "Hiring Funnel Rejection Breakdown"
  description: "Rider/Picker Rejection Reason Breakdown"
  group_label: "Rider Ops"

  access_filter: {
    field: fountain_rejection_breakdown.country
    user_attribute: country_iso
  }

  access_filter: {
    field: fountain_rejection_breakdown.city
    user_attribute: city
  }

}
