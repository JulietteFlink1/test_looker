include: "/views/sql_derived_tables/daily_rider_no_show.view.lkml"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

explore: daily_rider_no_show {
  group_label: "Rider Ops"
  view_label: "*Daily Rider No Show*"
  label: "Daily Rider No Show"
  hidden: yes



  always_filter: {
    filters:  [
      daily_rider_no_show.shift_date: "last 7 days",
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }

  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${daily_rider_no_show.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
