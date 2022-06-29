include: "/views/onboarding_task_olya.view.lkml"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view.lkml"

explore: onboarding_task_olya {
  hidden: yes
  view_name:  onboarding_task_olya
  label: "Onboarding task Olya"


  join: hubs_ct {
    sql_on: ${hubs_ct.hub_code} =  ${onboarding_task_olya.hub_code} ;;
    type: left_outer
    relationship: one_to_one
  }

}
