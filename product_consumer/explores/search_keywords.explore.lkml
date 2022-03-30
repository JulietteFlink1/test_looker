# Owner: Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - what our customer look for > search query
# - CTR and CVR per market and hub

include: "/**/search_keywords.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: search_keywords {
  from:  search_keywords
  view_name: search_keywords
  hidden: yes

  label: "Search Keywords"
  description: "This explore provides search query information, 0 search results rate, which query was followed by add-to-cart or PDP (CTR or CVR)"
  group_label: "Consumer Product"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${received_at_date} {% endcondition %}
    and {% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      search_keywords.country_iso: "",
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
