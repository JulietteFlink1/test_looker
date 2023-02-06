# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# - Last Mile Tech Team

# Questions that can be answered
# - User interaction with rider landing page

include: "/**/*/daily_rider_landing_page_events.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"


explore: daily_rider_landing_page_events {
  from:  daily_rider_landing_page_events
  view_name: daily_rider_landing_page_events
  hidden: no

  label: "Daily Rider Landing Page Events"
  description: "This explore provides an overview of all behavioural events originating from rider landing page"
  group_label: "Product - Last Mile"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} date(${event_timestamp_date}) {% endcondition %};;


  access_filter: {
    field: daily_rider_landing_page_events.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}
}
