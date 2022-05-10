include: "/competitive_intelligence/views/bigquery_curated/adhoc_gorillas_mov.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/gorillas_hubs.view.lkml"
include: "/competitive_intelligence/views/bigquery_reporting/gorillas_daily_orders.view.lkml"


explore: adhoc_gorillas_mov {
  view_name: adhoc_gorillas_mov
  label: "* Gorillas MOV changes *"
  hidden: yes
  group_label: "8) Competitive Intelligence"
  description: "Active Hubs of all providers"


  join: gorillas_hubs {
    from:  gorillas_hubs
    sql_on: ${gorillas_hubs.hub_id} = ${adhoc_gorillas_mov.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: gorillas_daily_orders {
    from:  gorillas_daily_orders
    sql_on: ${gorillas_daily_orders.hub_id} = ${adhoc_gorillas_mov.hub_id} and ${gorillas_daily_orders.order_date} = ${adhoc_gorillas_mov.date_scraped} ;;
    relationship: many_to_one
    type:  left_outer
  }
}
