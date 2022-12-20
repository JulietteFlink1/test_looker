include: "/*/**/braze_lifecycle_cohorts.view.lkml"

explore: lifecycle_cohorts_reporting {

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    BASE TABLE
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  hidden: no
  view_name: braze_lifecycle_cohorts
  label: "Canvas Lifecycle Cohorts"
  view_label: "CRM"
  group_label: "Marketing"
  description: "Cost of customer acquisition for online channels"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    FILTER & SETTINGS
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  always_filter: {
    filters: [
      braze_lifecycle_cohorts.cohort_date: "last 3 months",
      braze_lifecycle_cohorts.canvas_name: "",
      braze_lifecycle_cohorts.canvas_variation_name: "",
      braze_lifecycle_cohorts.in_control_group: ""
    ]
  }

}
