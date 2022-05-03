# Owner: Brandon Beckett
# Created: 2022-04-25
# Main Stakeholder: Pricing Team
#
# Questions that can be answered:
# - Understanding historical price changes for Gorillas products.

# April 26, 2022 Note, joins need to be fixed. Currently have some issues. Committing as is for testing.


include: "/competitive_intelligence/views/**/*.view.lkml"

explore: gorillas_pricing_hist {

  label:       "Gorillas Historical Pricing Data"
  description: "This explore give us a view of all historical pricing data from Gorillas
  and allows us to view Gorillas' price changes over time."
  group_label: "Competitive Intelligence"
  view_label:  "Gorillas Pricing Hist"

  hidden: yes

  join: gorillas_products {
    from: gorillas_products
    sql_on: ${gorillas_products.product_id} = ${gorillas_pricing_hist.product_id} ;;
            relationship: one_to_many
            type: left_outer
  }

  join: gorillas_categories {
    from: gorillas_categories
    sql_on: ${gorillas_categories.product_id} = ${gorillas_pricing_hist.product_id};;
    relationship: one_to_many
    type:  left_outer
  }

  join: gorillas_hubs {
    from:  gorillas_hubs
    sql_on: ${gorillas_hubs.hub_id} = ${gorillas_categories.hub_id} ;;
    relationship: one_to_many
    type:  left_outer
  }

}
