include: "/views/projects/rider_ops/hiring_funnel_performance_summary.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

explore: hiring_funnel_performance_summary {
  hidden: yes
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


    join: hubs {
      from: hubs_ct
      sql_on:
          lower(${hiring_funnel_performance_summary.city}) = lower(${hubs.city}) ;;
      relationship: many_to_one
      type: left_outer
    }


}
