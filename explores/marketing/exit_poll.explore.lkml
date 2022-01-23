include: "/views/bigquery_tables/curated_layer/mktg_exit_poll.view"

explore: mktg_exit_poll {
  hidden: no

  group_label: "Marketing"
  label: "Exit Poll"
  description: "Exit poll responses"


  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: shipping_city
    user_attribute: city
  }

}
