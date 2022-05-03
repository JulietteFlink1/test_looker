include: "/**/candidate_application_status.view.lkml"
include: "/**/job_details.view.lkml"
include: "/**/job_positions.view.lkml"


explore: candidate_application_funnel {
  from: candidate_application_status
  hidden: yes
  group_label: "People"
  label: "Recruitment Funnel"
  view_label: "* Candidate Application Status *"
  description: "SR Data"

  join: job_details {
    view_label: "* Job Details *"
    sql_on: ${candidate_application_funnel.job_id} = ${job_details.job_uuid} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: job_positions {
    view_label: "* Job Positions *"
    sql_on: ${job_positions.job_id} = ${job_details.job_uuid} ;;
    type: left_outer
    relationship: one_to_many
  }

}
