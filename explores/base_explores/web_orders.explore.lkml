include: "/views/**/web_orders.view.lkml"
include: "/views/bigquery_tables/curated_layer/orders.view"
include: "/views/extended_tables/orders_using_hubs.view"
include: "/views/projects/cleaning/shyftplan_riders_pickers_hours_clean.view"
include: "/views/projects/cleaning/issue_rates_clean.view"

include: "/views/bigquery_tables/curated_layer/hubs_ct.view"
include: "/views/bigquery_tables/curated_layer/nps_after_order_cl.view"
include: "/views/bigquery_tables/curated_layer/cs_post_delivery_issues.view"

include: "/explores/base_explores/orders_cl.explore"

explore: web_orders {
  view_name: web_orders
  label: "Web Orders"
  view_label: "Web Orders"
  description: "Temporary Explore to see performance of Web orders after Web Launch"
  hidden: yes

  #fields: [ALL_FIELDS*, -view.field1]

  always_filter: {
    filters:  [
      web_orders.is_successful_order: "yes",
      web_orders.order_timestamp_date: "after 2021-01-25",
      web_orders.country_iso: "",
      web_orders.hub_name: ""
    ]
  }
  access_filter: {
    field: web_orders.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: web_orders.city
    user_attribute: city
  }

  # join: hubs {
  #   from: hubs_ct
  #   view_label: "* Hubs *"
  #   sql_on: lower(${web_orders.hub_code}) = ${hubs.hub_code} ;;
  #   relationship: many_to_one
  #   type: left_outer
  # }

  # join: issue_rates_clean {
  #   view_label: "* Order Issues on Hub-Level *"
  #   sql_on: ${hubs.hub_code}           =  ${issue_rates_clean.hub_code} and
  #     ${web_orders.order_date}          =  ${issue_rates_clean.date_dynamic};;
  #   relationship: many_to_one # decided against one_to_many: on this level, many orders have hub-level issue-aggregates
  #   type: left_outer
  # }

  # join: cs_post_delivery_issues {
  #   view_label: "* Post Delivery Issues on Order-Level *"
  #   sql_on: ${web_orders.country_iso} = ${cs_post_delivery_issues.country_iso} AND
  #     ${cs_post_delivery_issues.order_nr_} = ${web_orders.order_number};;
  #   relationship: one_to_many
  #   type: left_outer
  # }


}
