include: "/views/bigquery_tables/reporting_layer/**/*.view"
include: "/views/bigquery_tables/curated_layer/**/*.view"
include: "/views/native_derived_tables/general/hub_leaderboard/*.view"


explore: hub_level_kpis {
  hidden: yes

  join: hubs {
    from: hubs_ct
    sql_on: ${hub_level_kpis.hub_code} = ${hubs.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: hub_leaderboard_current {
    view_label: "* Hub Level KPIS *"
    sql_on: ${hub_level_kpis.hub_code} = ${hub_leaderboard_current.hub_code} ;;
    relationship: many_to_one
    type: left_outer
    fields: [score_hub_leaderboard]
  }

  join: hub_leaderboard_previous {
    view_label: "* Hub Level KPIS *"
    sql_on: ${hub_level_kpis.hub_code} = ${hub_leaderboard_previous.hub_code} ;;
    relationship: many_to_one
    type: left_outer
    fields: [score_hub_leaderboard]
  }


}
