# Owner: Product Analytics, Farzana Amin

# Main Stakeholder:
# - Consumer Product

include: "/**/favourites_analysis_part1.view.lkml"

explore: favourites_analysis_part1 {
  from:  favourites_analysis_part1
  view_name: favourites_analysis_part1
  hidden: yes

  label: "Favourites Analysis"
  description: ""
  group_label: "Product - Consumer"

}
