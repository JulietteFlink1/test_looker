# Owner: Nazrin Guliyeva
# Main Stakeholder: Rider Growth Team
# Questions that can be answered: All questions around hiring

include: "/**/hiring_summary.view"
include: "/**/hubs_ct.view"

explore: hiring_summary {
  group_label: "Rider Ops"
  view_label: "Hiring Summary"
  label: "Hiring Summary"
  description: "Hiring summary breakdown by country, city, hub code, channel etc."
  hidden: yes


  always_filter: {
    filters:  [
      hiring_summary.last_transitioned_date: "last 7 days",
      hubs.country: ""
    ]
  }

  join: hubs {
    from: hubs_ct
    view_label: "Hub Data"
    sql_on:
    lower(${hiring_summary.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
