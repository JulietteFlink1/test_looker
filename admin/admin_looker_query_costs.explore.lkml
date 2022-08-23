# Owner:
# Andreas Stüber
#
# Main Stakeholder:
# - Data Team (internal)

#
# Questions that can be answered
# - what looks and dashboards are:
#    1. most often used
#    2. scanning the most gigabyges
#    2. generating the highest costs

include: "/admin/*.view"



explore: admin_looker_query_costs  {

  from: looker_query_costs
  hidden: yes

  always_filter: {
    filters: [
      admin_looker_query_costs.partition_timestamp_date: "last 7 days"
    ]
  }
}
