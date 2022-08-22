include: "/admin/*.view"



explore: admin_looker_query_costs  {

  from: looker_query_cost_reporting_tmp
  hidden: yes
}
