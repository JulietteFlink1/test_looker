# Owner: Brandon Beckett
# Created: 2022-07-26
# Main Stakeholder: Pricing Team
#
# Questions that can be answered:
# - What products and prices does REWE currently offer?
# - What REWE products have changed price in the past week?
# - What products does REWE sell that have different prices accross different regions?


include: "/**/rewe_products.view.lkml"


explore: rewe_products {

  label:       "REWE Products and Prices"
  description: "This explore provides a view of all REWE products and prices"
  group_label: "Competitive Intelligence"
  view_label:  "REWE Products"

  hidden: yes

}

# Need to join Flink matches here
