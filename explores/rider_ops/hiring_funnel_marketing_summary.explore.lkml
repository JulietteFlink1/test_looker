include: "/views/projects/rider_ops/hiring_funnel_marketing_summary.view"
include: "/views/projects/rider_ops/hiring_funnel_performance_summary.view"

explore: hiring_funnel_marketing_summary {
  hidden: yes
  label: "Hiring Funnel Marketing Summary"
  view_label: "Hiring Funnel Marketing Summary"
  description: "Rider/Picker leads, hires, marketing spend, days to hire, etc."
  group_label: "Rider Ops"

  access_filter: {
    field: hiring_funnel_marketing_summary.country
    user_attribute: country_iso
  }


  join: hiring_funnel_performance_summary {
    sql_on: ${hiring_funnel_marketing_summary.country} = ${hiring_funnel_performance_summary.country}
            and ${hiring_funnel_marketing_summary.city} = ${hiring_funnel_performance_summary.city}
            and ${hiring_funnel_marketing_summary.channel} = ${hiring_funnel_performance_summary.channel}
            and ${hiring_funnel_marketing_summary.position} = ${hiring_funnel_performance_summary.position}
            and ${hiring_funnel_marketing_summary.start_date} = ${hiring_funnel_performance_summary.date_date};;
    type: left_outer
    relationship: many_to_one
  }

}
