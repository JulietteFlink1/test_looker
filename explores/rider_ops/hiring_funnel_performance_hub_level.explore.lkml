include: "/views/projects/rider_ops/hiring_funnel_performance_summary_hub_level.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

explore: hiring_funnel_performance_summary_hub_level {
  hidden: yes
  label: "Hiring Funnel Performance Summary Hub Level"
  view_label: "Hiring Funnel Performance Summary Hub Level"
  description: "Rider/Picker leads, hires, marketing spend, days to hire, etc."
  group_label: "Rider Ops"

  access_filter: {
    field: hiring_funnel_performance_summary_hub_level.country
    user_attribute: country_iso
  }

  access_filter: {
    field: hiring_funnel_performance_summary_hub_level.city
    user_attribute: city
  }


  join: hubs {
    from: hubs_ct
    sql_on:
          lower(${hiring_funnel_performance_summary_hub_level.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }


}
