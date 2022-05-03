# Owner: Brandon Beckett
# Created: 2022-02-08
# Main Stakeholder: Pricing Team
#
# Questions that can be answered:
# - Understanding historical price changes for Gorillas products.
# - gorillas_products_hist data is usually hidden to avoid running expensive queries
# - however the _hist version of gorillas products is needed for this Pricing use case
#
# Jira Ticket: DATA-1780

include: "/competitive_intelligence/views/**/*.view.lkml"
include: "/**/global_filters_and_parameters.view"

explore: gorillas_products_hist {

  label:       "Gorillas Products Hist"
  description: "This explore give us a view of all historical scraped data from Gorillas
  and allows us to view Gorillas' price changes over time."
  group_label: "Competitive Intelligence"
  view_label:  "Gorillas Products Hist"

  hidden: yes

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 30 days"
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: gorillas_categories {
    from: gorillas_categories
    sql_on: ${gorillas_categories.hub_id} = ${gorillas_products_hist.hub_id} AND
            ${gorillas_categories.product_id} = ${gorillas_products_hist.product_id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: gorillas_hubs {
    from:  gorillas_hubs
    sql_on: ${gorillas_hubs.hub_id} = ${gorillas_categories.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: gorillas_pricing_hist {
    from:  gorillas_pricing_hist
    sql_on: ${gorillas_pricing_hist.hub_id} = ${gorillas_products_hist.hub_id} AND
            ${gorillas_pricing_hist.product_id} = ${gorillas_products_hist.product_id} AND
            ${gorillas_pricing_hist.scrape_date} = ${gorillas_products_hist.partition_timestamp_date};;
    relationship: one_to_one
    type: left_outer
  }
}
