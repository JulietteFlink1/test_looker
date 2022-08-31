include: "/**/*.view"
include: "/**/*.explore"

explore: fountain_rejection_breakdown {
  hidden: yes
  label: "Hiring Funnel Rejection Breakdown"
  view_label: "Hiring Funnel Rejection Breakdown"
  description: "Rider/Picker Rejection Reason Breakdown"
  group_label: "Rider Ops"

  access_filter: {
    field: fountain_rejection_breakdown.country
    user_attribute: country_iso
  }

}
