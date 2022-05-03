include: "/competitive_intelligence/views/bigquery_curated/gorillas_promise_time.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/gorillas_hubs.view.lkml"

explore:  gorillas_promise_time {
  hidden: yes
  label: "Gorillas Promise Time"
  view_label: "Gorillas Promise Time"
  group_label: "Competitive Intel"
  description: "Competitive Intelligence Data"

  join: gorillas_hubs {
    from:  gorillas_hubs
    sql_on: ${gorillas_hubs.hub_id} = ${gorillas_promise_time.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

}
