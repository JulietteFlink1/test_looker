# If necessary, uncomment the line below to include explore_source.
# include: "orders_customers.explore.lkml"

view: monthly_cohorts {
  derived_table: {
    explore_source: orders_customers {
      column: first_order_month { field: customers_metrics.first_order_month }
      column: cnt_unique_customers { field: orders_cl.cnt_unique_customers }
      column: sum_gmv_gross { field: orders_cl.sum_gmv_gross }
      column: months_time_since_sign_up { field: customers_metrics.months_time_since_sign_up }
      column: country_iso { field: customers_metrics.country_iso }
      column: sum_discount_amt { field: orders_cl.sum_discount_amt }
      filters: {
        field: hubs.country
        value: ""
      }
      filters: {
        field: hubs.hub_name
        value: ""
      }
      filters: {
        field: orders_cl.is_successful_order
        value: "yes"
      }
      filters: {
        field: orders_cl.created_date
        value: "after 2021/01/25"
      }
      filters: {
        field: customers_metrics.months_time_since_sign_up
        value: "0"
      }
    }
  }
  dimension: first_order_month {
    type: date_month
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
  dimension: months_time_since_sign_up {
    value_format: "0"
    type: duration_month
  }
  dimension: country_iso {}
  dimension: sum_discount_amt {
    label: "* User Metrics * SUM Discount Amount"
    description: "Sum of Discount amount applied on orders"
    value_format: "\"€\"0.0,\" K\""
    type: number
  }
}
