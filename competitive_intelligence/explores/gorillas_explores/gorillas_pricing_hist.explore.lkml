# Owner: Brandon Beckett
# Created: 2022-04-25
# Main Stakeholder: Pricing Team
#
# Questions that can be answered:
# - Understanding historical price changes for Gorillas products.


include: "/competitive_intelligence/views/bigquery_curated/gorillas_pricing_hist.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/gorillas_products.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/gorillas_categories.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/gorillas_hubs.view.lkml"

explore: gorillas_pricing_hist {

  label:       "Gorillas Historical Pricing Data"
  description: "This explore give us a view of all historical pricing data from Gorillas
  and allows us to view Gorillas' price changes over time."
  group_label: "Competitive Intelligence"
  view_label:  "Gorillas Pricing Hist"

  hidden: yes

  join: gorillas_products {
    from: gorillas_products
    sql_on: ${gorillas_products.product_id} = ${gorillas_pricing_hist.product_id}
        and ${gorillas_products.hub_id} = ${gorillas_pricing_hist.hub_id};;
            relationship: one_to_one
            type: left_outer
  }

  join: gorillas_categories {
    from: gorillas_categories
    sql_on: ${gorillas_categories.product_id} = ${gorillas_products.product_id}
        and ${gorillas_categories.hub_id} = ${gorillas_products.hub_id};;
    relationship: one_to_many
    type:  left_outer
  }

  join: gorillas_hubs {
    from:  gorillas_hubs
    sql_on: ${gorillas_hubs.hub_id} = ${gorillas_categories.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

}
