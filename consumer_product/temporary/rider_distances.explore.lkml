include: "/views/sql_derived_tables/tmp_rider_distances.view.lkml"

explore: rider_distances {
  hidden: yes
  view_name:  tmp_rider_distances
  label: "Rider distances"
  view_label: "Rider distances"
  group_label: "Consumer Product"
}
