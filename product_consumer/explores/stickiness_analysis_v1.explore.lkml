# Owner: Product Analytics, Natalia Wierzbowska

# Main Stakeholder:
# - Consumer Product

include: "/**/stickiness_analysis_v1.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: stickiness_analysis_v1 {
  from:  stickiness_analysis_v1
  view_name: stickiness_analysis_v1
  hidden: yes

  label: "Stickiness Analysis"
  description: ""
  group_label: "Product - Consumer"

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${event_date_partition_date} {% endcondition %};;


  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 14 days",
      stickiness_analysis_v1.country_iso: "",
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

}
