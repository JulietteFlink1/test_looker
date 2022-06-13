# Owner: Product Analytics

include: "/product_consumer/views/bigquery_reporting/consumer_behaviour_dynamic_delivery_fee.view.lkml"
include: "/product_consumer/views/bigquery_reporting/daily_user_aggregates.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: consumer_behaviour_dynamic_delivery_fee {
  view_name: consumer_behaviour_dynamic_delivery_fee
  label: "Consumer Behaviour DDF"
  view_label: "Consumer Behaviour DDF"
  group_label: "Consumer Product"
  description: "Effects of DDF on Consumer Behaviour"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  join: daily_user_aggregates {
    from: daily_user_aggregates
    type: inner
    relationship: one_to_one
    sql_on: ${daily_user_aggregates.user_uuid}=${consumer_behaviour_dynamic_delivery_fee.user_uuid} ;;
    fields: [
      device_attributes*
      , location_attributes*
      , user_uuid
      , is_new_user
      , is_address_set
      , is_address_confirmed
      , is_home_viewed
      , is_checkout_viewed
      , is_order_placed
      , is_active_user
      , active_users
      , users_with_address
      , users_with_checkout_viewed
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
