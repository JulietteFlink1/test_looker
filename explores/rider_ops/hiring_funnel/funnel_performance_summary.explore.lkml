include: "/views/bigquery_tables/reporting_layer/rider_ops/hiring_funnel/*.view"

explore: funnel_performance_summary {
  hidden: no
  label: "Hiring Funnel Performance Summary"
  view_label: "Hiring Funnel Performance Summary"
  description: "Rider/Picker leads, hires, marketing spend, days to hire, etc."
  group_label: "Rider Ops"

  access_filter: {
    field: funnel_performance_summary.country
    user_attribute: country_iso
  }

  access_filter: {
    field: funnel_performance_summary.city
    user_attribute: city
  }

  join: funnel_marketing_summary {
    sql_on: ${funnel_marketing_summary.country} = ${funnel_performance_summary.country}
            and ${funnel_marketing_summary.city} = ${funnel_performance_summary.city}
            and ${funnel_marketing_summary.channel} = ${funnel_performance_summary.channel}
            and ${funnel_marketing_summary.position} = ${funnel_performance_summary.position}
            and ${funnel_marketing_summary.source_date} = ${funnel_performance_summary.report_date};;
    type: left_outer
    relationship: one_to_many
  }

  join: rejection_breakdown {
    sql_on: ${funnel_performance_summary.country} = ${rejection_breakdown.country}
            and ${funnel_performance_summary.city} = ${rejection_breakdown.city}
            and ${funnel_performance_summary.position} = ${rejection_breakdown.position}
            and ${funnel_performance_summary.report_date} = ${rejection_breakdown.rejection_date};;
    type: left_outer
    relationship: many_to_many
  }

}
