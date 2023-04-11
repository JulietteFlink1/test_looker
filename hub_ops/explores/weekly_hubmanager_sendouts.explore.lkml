include: "/**/weekly_hubmanager_sendouts.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/hub_gdrive_folder_ids.view.lkml"


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

  ## Join this view in order to be able to query folder IDs via Looker SDK here: https://github.com/goflink/data-looker-api
  join: hub_gdrive_folder_ids {
    view_label: ""
    sql_on: ${hubs_ct.hub_code}=${hub_gdrive_folder_ids.hub_code};;
    relationship: one_to_one
    type: left_outer
  }
}
