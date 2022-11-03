# Owner: Product Analytics, Galina Larina

# Main Stakeholder:
# - Consumer Product
# - Post Order

# Questions that can be answered
# - order based contact rates

include: "/product_consumer/views/bigquery_reporting/daily_post_order_contact_rate_aggregates.view"
include: "/**/global_filters_and_parameters.view.lkml"


explore: daily_post_order_contact_rate_aggregates {
  from:  daily_post_order_contact_rate_aggregates
  view_name: daily_post_order_contact_rate_aggregates
  hidden: no

  label: "Daily Post Order Contact Rate Aggregates"
  description: "This explore provides an aggregated overview of Post Order metrics on order-level (both App & Web)"
  group_label: "Consumer Product"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date_date} {% endcondition %};;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      daily_post_order_contact_rate_aggregates.country_iso: "",
      daily_post_order_contact_rate_aggregates.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }
}
