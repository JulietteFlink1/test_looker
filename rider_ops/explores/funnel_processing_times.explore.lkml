include: "/**/*.view"
include: "/**/*.explore"

explore: fountain_avg_proc_time {
  hidden: yes
  label: "Funnel Avg. Processing Times"
  view_label: "Funnel Avg. Processing Times"
  description: "Funnel Avg. Processing Times"
  group_label: "Rider Ops"

  access_filter: {
    field: fountain_avg_proc_time.country
    user_attribute: country_iso
  }

}
