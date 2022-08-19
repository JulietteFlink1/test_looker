include: "/**/looker_query_cost_exports.view"



explore: admin_looker_query_costs  {

  from: looker_query_cost_exports
  hidden: yes
}
