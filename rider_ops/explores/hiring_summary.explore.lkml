# Owner: Nazrin Guliyeva
# Main Stakeholder: Rider Growth Team
# Questions that can be answered: All questions around hiring

include: "/**/hiring_summary.view"
include: "/**/hubs_ct.view"

explore: hiring_summary {
  group_label: "Rider Ops"
  label: "Hiring Summary"
  description: "Hiring summary breakdown by country, city, hub code, channel etc."
  # It is possible in Hiring Summary table to have country/city but not hub code. Therefore, we do not need those fields from Hub Data
  {fields: [ALL_FIELDS*, -hubs.hub_code, -hubs.city, -hubs.country_iso]}


  access_filter: {
    field: hiring_summary.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters:  [
      hiring_summary.last_transitioned_date: "last 7 days",
      hiring_summary.country_iso: ""
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
