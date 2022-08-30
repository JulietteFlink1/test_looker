include: "/marketing/views/bigquery_curated/mktg_exit_poll.view.lkml"

explore: mktg_exit_poll {
  hidden: no

  group_label: "Marketing"
  label: "Exit Poll"
  description: "Exit poll responses"


  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }


}
