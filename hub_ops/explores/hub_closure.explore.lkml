include: "/**/hub_closure_rate.view.lkml"
include: "/**/hubs_ct.view.lkml"


explore: hub_closure {
  hidden: yes
  view_name: hub_closure_rate
  label: "Hub Closure"
  view_label: "Hub Closure"

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso
  }

join: hubs_ct {
  view_label: "Hubs"
  sql_on: ${hubs_ct.hub_code}=${hub_closure_rate.hub_code};;
  type: left_outer
  relationship: many_to_one
}
}
