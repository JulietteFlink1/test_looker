include: "/views/sql_derived_tables/moon_distance.view.lkml"

explore: moon_distance {
  group_label: "Rider Ops"
  label: "Moon Travel Distance"
  description: "Rider Travel Distance in comparison to the distance between earth to the moon"
  hidden: yes
}
