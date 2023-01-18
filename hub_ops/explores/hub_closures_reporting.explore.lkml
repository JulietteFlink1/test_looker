include: "/**/hub_turf_closures_30min.view.lkml"
include: "/**/hub_turf_closures_daily.view.lkml"
include: "/**/hubs_ct.view.lkml"


explore: hub_closures_reporting {
  view_name: hub_turf_closures_daily
  label: "Hub Closures"
  view_label: "Hub Closures (Daily)"

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso
  }

  join: hub_turf_closures_30min {
    view_label: "Hub Closures (30min)"
    sql_on: ${hub_turf_closures_30min.hub_code}=${hub_turf_closures_daily.hub_code}
        and coalesce(${hub_turf_closures_30min.turf_id},'') = coalesce(${hub_turf_closures_daily.turf_id},'')
        and ${hub_turf_closures_30min.start_date}=${hub_turf_closures_daily.report_date}
        and ${hub_turf_closures_30min.cleaned_comment}=${hub_turf_closures_daily.cleaned_comment};;
    type: left_outer
    relationship: one_to_many
  }

  join: hubs_ct {
    view_label: "Hubs"
    sql_on: ${hubs_ct.hub_code}=${hub_turf_closures_daily.hub_code};;
    type: left_outer
    relationship: many_to_one
  }
}
