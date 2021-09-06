include: "/views/sql_derived_tables/adjust_user_funnel.view.lkml"

explore: adjust_user_funnel {
  label: "Adjust user data"
  view_label: "Adjust user data"
  group_label: "06) Adjust app data"
  description: "Adjust first events by user"

  access_filter: {
    field: adjust_user_funnel._country_
    user_attribute: country_iso
  }

  access_filter: {
    field: adjust_user_funnel._city_
    user_attribute: city
  }
}
