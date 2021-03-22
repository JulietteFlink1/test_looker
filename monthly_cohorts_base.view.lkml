# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: monthly_cohorts_stable_base {
  derived_table: {
    explore_source: order_order {
      column: first_order_month { field: user_order_facts.first_order_month }
      column: months_time_since_sign_up {}
      column: cnt_unique_customers {}
      filters: {
        field: order_order.is_internal_order
        value: "no"
      }
      filters: {
        field: order_order.is_successful_order
        value: "yes"
      }
      filters: {
        field: order_order.created_date
        value: "after 2021/01/25"
      }
      filters: {
        field: order_order.months_time_since_sign_up
        value: "0"
      }
    }
  }
  dimension: first_order_month {
    label: "Users First Order Month"
    type: date_month
  }
  dimension: months_time_since_sign_up {
    label: "Orders Months Time Since Sign Up"
    value_format: "0"
    type: duration_month
  }
  dimension: cnt_unique_customers {
    label: "Cohort Size"
    description: "Cohort Base as count of unique customers"
    value_format: "0"
    type: number
  }
}
