# Owner: Product Analytics, Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - what our customer look for > search query
# - CTR and CVR per market and hub

include: "/product_consumer/views/bigquery_reporting/search_keywords.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: search_keywords {
  from:  search_keywords
  view_name: search_keywords
  hidden: no

  label: "Search Keywords"
  description: "This explore provides search query information, 0 search results rate, which query was followed by add-to-cart or PDP (CTR or CVR)"
  group_label: "Product - Consumer"

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${event_date_partition_date} {% endcondition %};;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 14 days",
      search_keywords.country_iso: "",
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

}
