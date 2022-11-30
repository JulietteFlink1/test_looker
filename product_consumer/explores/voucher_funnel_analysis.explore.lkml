# Owner: Product Analytics, Natalia Wierzbowska

# Main Stakeholder:
# - Consumer Product


include: "/**/voucher_funnel_analysis.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: voucher_funnel_analysis {
  from:  voucher_funnel_analysis
  view_name: voucher_funnel_analysis
  hidden: yes
  group_label: "Product - Consumer"



  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${event_date_partition_date} {% endcondition %};;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 14 days",
      voucher_funnel_analysis.country_iso: "",
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

}
