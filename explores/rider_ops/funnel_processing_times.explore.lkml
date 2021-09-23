include: "/views/projects/rider_ops/fountain_avg_proc_time.view"

explore: fountain_avg_proc_time {
  hidden: no
  label: "Funnel Avg. Processing Times"
  view_label: "Funnel Avg. Processing Times"
  description: "Funnel Avg. Processing Times"
  group_label: "09) Rider Ops"

  access_filter: {
    field: fountain_avg_proc_time.country
    user_attribute: country_iso
  }

  access_filter: {
    field: fountain_avg_proc_time.city
    user_attribute: city
  }

}
