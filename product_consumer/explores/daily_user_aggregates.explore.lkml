# Owner: Product Analytics, Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - user based conversions

include: "/product_consumer/views/bigquery_reporting/daily_user_aggregates.view"
include: "/product_consumer/views/bigquery_reporting/web_attribution.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: daily_user_aggregates {
  from:  daily_user_aggregates
  view_name: daily_user_aggregates
  hidden: no

  label: "Daily User Aggregates"
  description: "This explore provides an aggregated overview of Flink active users, including monetary values and conversion metrics (both App & Web)"
  group_label: "Product - Consumer"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date_at_date} {% endcondition %}
                    and ${event_date_at_date}<= CURRENT_DATE();;
#                   Adding event_date<= current_date to avoid displaying the future events

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      daily_user_aggregates.country_iso: "",
      daily_user_aggregates.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: web_attribution {
    view_label: "Daily Web Attribution"
    fields: [web_attribution.utm_source, web_attribution.utm_medium,
      web_attribution.utm_campaign,web_attribution.utm_campaign_content,
      web_attribution.utm_campaign_term,web_attribution.campaign_id,
      web_attribution.adgroup_id, web_attribution.creative_id,
      web_attribution.landing_page,web_attribution.is_homepage_visit,
      web_attribution.is_webshop_visit,web_attribution.is_recipe_lp_visit,
      web_attribution.is_city_lp_visit,web_attribution.page_referrer
    ]
    sql_on: ${web_attribution.event_date_date} = ${daily_user_aggregates.event_date_at_date}
      and ${web_attribution.anonymous_id} = ${daily_user_aggregates.user_uuid};;
    type: left_outer
    relationship: one_to_one
  }


}
