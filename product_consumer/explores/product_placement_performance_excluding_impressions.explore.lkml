# Owner: Product Analytics, Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - user based conversions
# this dashboard has a SQL always where clause to limit the volume of data queried.

include: "/product_consumer/views/bigquery_reporting/product_placement_performance_excluding_impressions.view"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/orders.view"
include: "/**/products.view"

explore: product_placement_performance_excluding_impressions {
  from:  product_placement_performance_excluding_impressions
  view_name: product_placement_performance_excluding_impressions
  hidden: no

  label: "Product Placement Performance"
  description: "This explore provides an aggregated overview of product performance and its placement in the app & web.
                This explore is built on front-end data, and is subset to the limitations of front-end tracking. We can not, and do not, expect 100% accuracy compared to the Orders & Order Line Items explores.
                We consider the Orders Explore to be the source of truth.
                This report uses daily last-in first-out attribution logic - if a user has a cart that persists for more than one day the product placements will not be included in this report.
                It excludes impressions data.
                 This explore is time limited, and will only return data for the last complete month, and the current month.
                "
  group_label: "Product - Consumer"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${product_placement_performance_excluding_impressions.event_date} {% endcondition %}
                    and ${product_placement_performance_excluding_impressions.event_date} > current_date() - 29
                    and ${country_iso} is not null;;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 1 days",
      product_placement_performance_excluding_impressions.country_iso: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: orders {
    fields: [orders.status]
    sql_on: ${orders.order_uuid} = ${product_placement_performance_excluding_impressions.order_uuid}
            and {% condition global_filters_and_parameters.datasource_filter %} ${orders.order_date} {% endcondition %} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: products {
    view_label: "Product Data (CT)"
    sql_on: ${products.product_sku} = ${product_placement_performance_excluding_impressions.product_sku}
            and ${products.country_iso} = ${product_placement_performance_excluding_impressions.country_iso} ;;
    relationship: many_to_one
    type: left_outer
    fields: [product_attributes*]
  }

}
