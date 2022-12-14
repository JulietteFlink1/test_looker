# Owner: Product Analytics, Farzana Amin

# Main Stakeholder:
# - Consumer Product

include: "/**/favourites_analysis_part2.view.lkml"

explore: favourites_analysis_part2 {
  from:  favourites_analysis_part2
  view_name: favourites_analysis_part2
  hidden: yes

  label: "Favourites Analysis Part 2"
  description: ""
  group_label: "Product - Consumer"

}
