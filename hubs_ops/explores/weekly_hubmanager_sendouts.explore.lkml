include: "/**/weekly_hubmanager_sendouts.view.lkml"
include: "/**/hubs_ct.view.lkml"


explore: weekly_hubmanager_sendouts {
  view_name: weekly_hubmanager_sendouts
  hidden:  no
  label: "Hub Manager Sendouts"
  view_label: "Hub Manager Sendouts"

  join: hubs_ct {
    view_label: "Hubs"
    sql_on: ${hubs_ct.hub_code}=${weekly_hubmanager_sendouts.hub_code};;
    type: left_outer
    relationship: many_to_one
  }
}
