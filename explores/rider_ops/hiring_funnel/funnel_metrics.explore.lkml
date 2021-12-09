include: "/views/bigquery_tables/reporting_layer/rider_ops/hiring_funnel/*.view"

explore: avg_proc_time {
  hidden: no
  label: "Funnel Metrics"
  view_label: "Funnel Metrics"
  description: "Average time in days to stage by applied date. Active funnel."
  group_label: "Rider Ops"

  access_filter: {
    field: avg_proc_time.country
    user_attribute: country_iso
  }

  access_filter: {
    field: avg_proc_time.city
    user_attribute: city
  }

  join: active_funnel {
    sql_on: ${avg_proc_time.country} = ${active_funnel.country}
            and ${avg_proc_time.city} = ${active_funnel.city}
            and ${avg_proc_time.stage_title} = ${active_funnel.stage_title}
            and ${avg_proc_time.position} = ${active_funnel.position}
            and ${avg_proc_time.applied_date} = ${active_funnel.applied_date};;
    type: left_outer
    relationship: one_to_many
  }

}
