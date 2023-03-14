# Owner: Product Analytics, Natalia Wierzbowska

# Main Stakeholder:
# - Consumer Product

include: "/**/*/web_attribution.view.lkml"
include: "/**/*/daily_user_aggregates.view.lkml"
include: "/**/*/daily_events.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: web_attribution {
  from:  web_attribution
  view_name: web_attribution
  view_label: "Daily Web Attribution"
  hidden: yes

  label: "Web Attribution Model"
  description: "This explore provides web attribution model for a daily active user on Flink Web"
  group_label: "Product - Consumer"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${web_attribution.event_date_date} {% endcondition %};;

  # always_filter: {
  #   filters: [
  #     web_attribution.event_date_date: "last 7 days"
  #     ]
  # }

  join: daily_user_aggregates {
    view_label: "Daily User Aggregates"
    fields: [daily_user_aggregates.is_address_deliverable, daily_user_aggregates.is_product_added_to_cart,
      daily_user_aggregates.is_cart_viewed,daily_user_aggregates.is_checkout_viewed,
      daily_user_aggregates.is_order_placed,daily_user_aggregates.is_account_registration_viewed,
      daily_user_aggregates.is_account_registration_succeeded,daily_user_aggregates.is_account_login_succeeded,
      daily_user_aggregates.is_sms_verification_request_viewed, daily_user_aggregates.is_sms_verification_confirmed,
      daily_user_aggregates.is_voucher_redemption_attempted, daily_user_aggregates.is_voucher_applied_succeeded,
      daily_user_aggregates.is_active_user, daily_user_aggregates.country_iso, daily_user_aggregates.is_user_logged_in,
      daily_user_aggregates.is_new_user,
    ]
    sql_on: ${web_attribution.event_date_date} = ${daily_user_aggregates.event_date_at_date}
      and ${web_attribution.anonymous_id} = ${daily_user_aggregates.user_uuid};;
    type: left_outer
    relationship: one_to_one
  }


  join: daily_events {
    view_label: "Daily Events"
    fields: [daily_events.event_name, daily_events.component_name,
      daily_events.component_value,daily_events.component_content,
      daily_events.screen_name, daily_events.component_variant,
      daily_events.event_date, daily_events.country_iso
    ]
    sql_on: ${web_attribution.event_date_date} = ${daily_events.event_date}
      and ${web_attribution.anonymous_id} = ${daily_events.anonymous_id};;
    type: left_outer
    relationship: one_to_many
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }
}
