# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around really long term introduction date shifts. Shows product-locations that have suffered shifts to their introduction dates as part of a process.

include: "/supply_chain/views_externals/really_long_term_adjusted_intro_date.view.lkml"


explore: really_long_term_adjusted_intro_date_explore {

  from: really_long_term_adjusted_intro_date
  view_name: really_long_term_adjusted_intro_date
  group_label: "Supply Chain"
  label: "Really Long Term Adjusted Introduction Date Explore (Owned by Supply Chain)"
  description: "This explore shows on item-location-date level information regarding products that have suffered shifts to their introduction dates as part of a process owned by Supply Chain.
  This adjustment ensures that the product will not be displayed on the app, improving the customer experience.
  Additionally, it allows the supplier sufficient time to replenish the stock in collaboration with Flink's Supplier and Commercial teams."
  hidden: no

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

}
