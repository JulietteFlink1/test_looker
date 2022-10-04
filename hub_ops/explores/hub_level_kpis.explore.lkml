include: "/**/hub_level_kpis.view"
include: "/**/hub_leaderboard_current.view"
include: "/**/hub_leaderboard_previous.view"
include: "/**/top_5_category_change_type.view"
include: "/**/hubs_ct.view"
include: "/**/weekly_hubmanager_sendouts.view"

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

  join: top_5_category_change_type {
    view_label: "* Inventory Changes Daily *"
    sql_on: ${hub_level_kpis.hub_code} = ${top_5_category_change_type.hub_code} ;;
    relationship: many_to_many
    type: left_outer
  }

  join: weekly_hubmanager_sendouts {
    view_label: "* Weekly Hubmnager Sendouts *"
    sql_on: ${hub_level_kpis.hub_code} = ${weekly_hubmanager_sendouts.hub_code} ;;
    relationship: many_to_many
    type: left_outer
  }

}
