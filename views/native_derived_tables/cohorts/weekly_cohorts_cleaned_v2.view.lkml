# If necessary, uncomment the line below to include explore_source.
# include: "orders_customers.explore.lkml"

view: weekly_cohorts_cleaned_v2 {
  derived_table: {
    explore_source: orders_customers_cleaned_v2 {
      column: first_order_week { field: customers_metrics_cleaned_v2.first_order_week }
      column: cnt_unique_customers { field: orders_cl_cleaned_v2.cnt_unique_customers }
      column: sum_gmv_gross { field: orders_cl_cleaned_v2.sum_gmv_gross }
      column: weeks_time_since_sign_up { field: customers_metrics_cleaned_v2.weeks_time_since_sign_up }
      column: country_iso { field: customers_metrics_cleaned_v2.country_iso }
      column: sum_discount_amt { field: orders_cl_cleaned_v2.sum_discount_amt }
      filters: {
        field: hubs.country
        value: ""
      }
      filters: {
        field: hubs.hub_name
        value: ""
      }
      filters: {
        field: orders_cl_cleaned_v2.is_internal_order
        value: "no"
      }
      filters: {
        field: orders_cl_cleaned_v2.is_successful_order
        value: "yes"
      }
      filters: {
        field: orders_cl_cleaned_v2.created_date
        value: "after 2021/01/25"
      }
      filters: {
        field: customers_metrics_cleaned_v2.weeks_time_since_sign_up
        value: "0"
      }
    }
  }
  dimension: first_order_week {
    type: date_week
  }
  dimension: cnt_unique_customers {
    label: "* User Metrics * # Unique Customers"
    description: "Count of Unique Customers identified via their Email"
    value_format: "0"
    type: number
  }
  dimension: sum_gmv_gross {
    label: "* User Metrics * SUM GMV (Gross)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    value_format: "\"€\"0.0,\" K\""
    type: number
  }
  dimension: weeks_time_since_sign_up {
    value_format: "0"
    type: duration_week
  }
  dimension: country_iso {}
  dimension: sum_discount_amt {
    label: "* User Metrics * SUM Discount Amount"
    description: "Sum of Discount amount applied on orders"
    value_format: "\"€\"0.0,\" K\""
    type: number
  }
}
