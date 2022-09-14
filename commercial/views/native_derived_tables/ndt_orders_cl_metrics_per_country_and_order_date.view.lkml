# Owner: Andreas Stueber
# Created for: Commercial Team
# Description: This view provide absolute metrics per day and country iso, so that the Commercial team can e.g. compare the revenue contribution of a specific category compared to the whole order/customer volume

include: "/**/order_orderline_cl_retail_customized.explore.lkml"

# If necessary, uncomment the line below to include explore_source.
# include: "order_orderline_cl_retail_customized.explore.lkml"

view: ndt_orders_cl_metrics_per_country_and_order_date {

  derived_table: {

    explore_source: order_orderline_cl_retail_customized {

      column: created_date               { field: orders_cl.created_date }
      column: country_iso                { field: hubs.country_iso }
      column: number_of_orders           { field: orders_cl.cnt_orders }
      column: number_of_unique_customers { field: orders_cl.cnt_unique_customers }

      bind_all_filters: no

      filters: [global_filters_and_parameters.datasource_filter: "last 1 year"]
    }
  }

  dimension: pk {
    hidden: yes
    primary_key: yes
    sql: concat(${created_date}, ${country_iso}) ;;
  }

  dimension: created_date {
    label: "Orders Order Date"
    description: "Order Placement Time/Date"
    type: date
  }
  dimension: country_iso {
    description: ""
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden Fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: number_of_daily_orders {
    label: "# Orders (per order-date & hub)"
    description: "Count of Orders on a date and hub level"

    sql: ${TABLE}.number_of_orders ;;
    value_format_name: decimal_0
    type: number
    hidden: no
  }
  dimension: number_of_daily_unique_customers {
    label: "# Unique Customers (per order-date & hub)"
    description: "Count of Unique Customers identified via their Customer UUID aggregated on a order-date and hub level"

    sql: ${TABLE}.number_of_unique_customers ;;
    value_format: "0"
    type: number
    hidden: no
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Exposed Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  measure: sum_number_of_orders {
    label: "# Orders (per order-date & hub)"
    description: "Count of Orders on a date and hub level"

    type: sum
    sql: ${number_of_daily_orders} ;;
    value_format_name: decimal_0

    hidden: no
  }

  measure: sum_number_of_unique_customers {
    label: "# Unique Customers (per order-date & hub)"
    description: "Count of Unique Customers identified via their Customer UUID aggregated on a order-date and hub level"
    value_format: "0"
    type: sum
    sql: ${number_of_daily_unique_customers} ;;
    hidden: no
  }

}
