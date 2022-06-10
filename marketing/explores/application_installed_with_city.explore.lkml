include: "/marketing/views/sql_derived_tables/application_installed_with_city.view.lkml"

explore: application_installed_with_city {
  view_name: application_installed_with_city
  label: "Application Installs With City"
  view_label: "Application Installs With City"
  group_label: "Marketing"
  description: "User according to AnonymousID (Segment) installation time and city"
}
