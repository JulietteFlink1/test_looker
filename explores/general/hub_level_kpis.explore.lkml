include: "/views/bigquery_tables/reporting_layer/**/*.view"
include: "/views/bigquery_tables/curated_layer/**/*.view"

explore: hub_level_kpis {
  hidden: yes

  join: hubs_ct {
    sql_on: ${hub_level_kpis.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }
}
