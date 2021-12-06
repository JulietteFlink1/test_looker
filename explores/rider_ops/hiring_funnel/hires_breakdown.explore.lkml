include: "/views/bigquery_tables/reporting_layer/rider_ops/hiring_funnel/*.view"

explore: hired_applicants {
  hidden: no
  label: "Hires Breakdown"
  view_label: "Hires Breakdown"
  description: "Breakdown by contract type, position, hire date"
  group_label: "Rider Ops"

  access_filter: {
    field: hired_applicants.country
    user_attribute: country_iso
  }

  access_filter: {
    field: hired_applicants.city
    user_attribute: city
  }

}
