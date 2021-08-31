include: "/views/bigquery_tables/reporting_layer/**/*.view"
include: "/views/bigquery_tables/curated_layer/**/*.view"
include: "/views/native_derived_tables/general/hub_leaderboard/hub_leaderboard_shift_metrics.view"


explore: hub_level_kpis {
  hidden: yes

  join: hubs {
    from: hubs_ct
    sql_on: ${hub_level_kpis.hub_code} = ${hubs.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }


}
