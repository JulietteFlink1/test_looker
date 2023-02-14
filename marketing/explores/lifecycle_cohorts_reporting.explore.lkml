include: "/*/**/braze_lifecycle_cohorts.view.lkml"

explore: lifecycle_cohorts_reporting {

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    BASE TABLE
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  hidden: no
  view_name: braze_lifecycle_cohorts
  label: "Braze Canvas Analytics"
  view_label: "CRM"
  group_label: "Marketing"
  description: "Reporting on CRM Lifecycle Canvas Cohorts"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    FILTER & SETTINGS
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  always_filter: {
    filters: [
      braze_lifecycle_cohorts.cohort_date: "last 2 months",
      braze_lifecycle_cohorts.canvas_name: "",
      braze_lifecycle_cohorts.canvas_variation_name: "",
      braze_lifecycle_cohorts.is_control_group: ""
    ]
  }

}
