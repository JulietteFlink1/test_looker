include: "/views/projects/rider_ops/rider_staffing_report.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

explore: rider_staffing_report {
  hidden: yes
  label: "Orders and Riders Staffing Data"
  view_label: "Orders and Riders Staffing Data"
  group_label: "Rider Ops"

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: hubs {
    from: hubs_ct
    sql_on:
    ${rider_staffing_report.hub_name} = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
