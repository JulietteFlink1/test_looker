# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech

# Questions that can be answered
# - Questions around behavioural events coming from Hub One app

include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/products.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/event_inbound_progressed.view.lkml"
include: "/**/product_added_to_list_times.view.lkml"
include: "/**/product_added_to_list_times_clean.view.lkml"
include: "/**/hub_one_inbounding_aggregates.view.lkml"

explore: event_inbound_progressed {
  from:  event_inbound_progressed
  view_name: event_inbound_progressed
  hidden: no

  label: "Event Inbound Progressed"
  description: "This explore provides an overview of inbound_progressed event generated on Hub One.
                This explore is built on front-end data, and is subset to the limitations
                of front-end tracking."
  group_label: "Product - Hub Tech"


  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %}
    ${event_timestamp_date} {% endcondition %};;

  access_filter: {
    field: event_inbound_progressed.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      event_inbound_progressed.country_iso: "",
      event_inbound_progressed.hub_code: ""
    ]
  }

  always_join: [products]

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

join: hub_one_inbounding_aggregates {
  view_label: "3 Hub One Inbounding Aggregates"
  fields: [is_less_than_x_skus]
  sql_on: ${product_added_to_list.dropping_list_id}= ${hub_one_inbounding_aggregates.dropping_list_id}
  and {% condition global_filters_and_parameters.datasource_filter %}
        ${hub_one_inbounding_aggregates.event_date} {% endcondition %} ;;
  type: left_outer
  relationship: many_to_one
}

  join: product_added_to_list {
    view_label: "2 Product Added To List Times"
    sql_on: ${product_added_to_list.primary_key}= concat(${dropping_list_id}, ${country_iso},${product_sku}, ${method}) ;;
    type: left_outer
    relationship: one_to_many
  }

  join: product_added_to_list_clean {
    view_label: "2 Product Added To List Times"
    sql_on: ${product_added_to_list_clean.primary_key}= concat(${dropping_list_id}, ${hub_code},${product_sku}, ${method}) ;;
    type: left_outer
    relationship: one_to_many
  }

join: products {
  view_label: "4 Product Dimensions"
  fields: [product_name, category, subcategory, erp_category, erp_subcategory, units_per_handling_unit,
           erp_item_division_name, erp_item_group_name, erp_item_department_name, erp_item_class_name, erp_item_subclass_name]
  sql_on: ${products.product_sku} = ${event_inbound_progressed.product_sku};;
  type: left_outer
  relationship: one_to_one
}

join: hubs_ct {
  view_label: "5 Hub Dimensions"
  sql_on: ${event_inbound_progressed.hub_code} = ${hubs_ct.hub_code} ;;
  type: left_outer
  relationship: many_to_one
}

}
