# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: weekly_cohorts_stable_base {
  derived_table: {
    explore_source: order_order {
      column: first_order_week { field: user_order_facts.first_order_week }
      column: weeks_time_since_sign_up {}
      column: cnt_unique_customers {}
      column: sum_gmv_gross {}
      column: sum_discount_amt {}
      column: country_iso {}
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
        field: order_order.weeks_time_since_sign_up
        value: "0"
      }
    }
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: first_order_week {
    label: "Users First Order Week"
    hidden: yes
    type: date_week
  }
  dimension: weeks_time_since_sign_up {
    label: "Orders Weeks Time Since Sign Up"
    value_format: "0"
    hidden: yes
    type: duration_week
  }
  dimension: cnt_unique_customers {
    label: "Cohort Size"
    description: "Cohort Base as count of unique customers"
    value_format: "0"
    hidden: yes
    type: number
  }
  dimension: sum_gmv_gross {
    label: "GMV (gross)"
    description: "Cohort Base as Total GMV generated by cohort"
    value_format: "\"€\"0.0,\" K\""
    hidden: yes
    type: number
  }
  dimension: sum_discount_amt {
    label: "Discount Value"
    description: "Cohort Base as Total Discount value generated by cohort"
    value_format: "\"€\"0.0,\" K\""
    hidden: yes
    type: number
  }
}
