include: "/**/***/first_order_refund_analysis.view"
include: "/**/global_filters_and_parameters.view.lkml"



explore: first_order_refund_analysis {
  from:  first_order_refund_analysis
  view_name: first_order_refund_analysis
  hidden: yes

  # sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${order_date_date}} {% endcondition %};;

  # access_filter: {
  #   field: first_order_refund_analysis.country_iso
  #   user_attribute: country_iso
  # }

  # always_filter: {
  #   filters: [
  #     global_filters_and_parameters.datasource_filter: "last 30 days"
  #   ]
  # }

  # join: global_filters_and_parameters {
  #   sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
  #   type: left_outer
  #   relationship: many_to_one
  # }


}
