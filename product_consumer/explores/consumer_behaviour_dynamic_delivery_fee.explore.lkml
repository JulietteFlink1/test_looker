# Owner: Product Analytics

include: "/product_consumer/views/bigquery_reporting/consumer_behaviour_dynamic_delivery_fee.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: consumer_behaviour_dynamic_delivery_fee {
  view_name: consumer_behaviour_dynamic_delivery_fee
  label: "Consumer Behaviour DDF"
  view_label: "Consumer Behaviour DDF"
  group_label: "Consumer Product"
  description: "Effects of DDF on Consumer Behaviour"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;


  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
