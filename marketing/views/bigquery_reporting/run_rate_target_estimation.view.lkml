view: run_rate_target_estimation {
  sql_table_name: `flink-data-dev.dbt_jdavies_reporting.run_rate_target_estimation`;;

  ##DIMENSIONS


  dimension: country_iso {
    label: "Country ISO"
    group_label: "> Dimensions"
    description: ""
    type: string
    hidden: no
    sql: ${TABLE}.country_iso ;;
  }

  dimension: order_month {
    group_label: "> Dimensions"
    label: "Order Month"
    description: ""
    type: date
    datatype: date
    hidden: no
    sql: ${TABLE}.order_month ;;
  }

  dimension: order_date {
    group_label: "> Dimensions"
    label: "Order Date"
    description: ""
    type: date
    datatype: date
    hidden: no
    sql: ${TABLE}.order_date ;;
  }

  dimension: customer_monthly_activity_status {
    group_label: "> Dimensions"
    label: "Customer Monthly Activity Status"
    description: ""
    type: string
    hidden: no
    sql: ${TABLE}.customer_monthly_activity_status ;;
  }

  dimension: run_rate_metric {
    group_label: "> Dimensions"
    label: "Run Rate Metric"
    description: ""
    type: string
    hidden: no
    sql: ${TABLE}.run_rate_metric ;;
  }

  dimension: daily_cumulative_amount {
    group_label: "> Dimensions"
    label: "Daily Cumulative Amount"
    description: ""
    type: number
    hidden: no
    sql: ${TABLE}.daily_cumulative_amount ;;
  }

  dimension: running_average_order_month {
    group_label: "> Dimensions"
    label: "Running Average Order Month"
    description: ""
    type: date
    datatype: date
    hidden: no
    sql: ${TABLE}.running_average_order_month ;;
  }

  dimension: historic_data_sample_size {
    group_label: "> Dimensions"
    label: "Running Average Sample Size"
    description: ""
    type: number
    hidden: no
    sql: ${TABLE}.historic_data_sample_size ;;
  }

  dimension: target_monthly_value {
    group_label: "> Dimensions"
    label: "Target Monthly Value"
    description: ""
    type: number
    hidden: no
    sql: ${TABLE}.target_monthly_value ;;
  }

  dimension: percent_of_monthly_goal_completed_rolling_average {
    group_label: "> Dimensions"
    label: "AVG Monthly Completed Goal Completion"
    description: ""
    type: number
    hidden: no
    sql: ${TABLE}.percent_of_monthly_goal_completed_rolling_average ;;
  }


  dimension: historic_expected_completion_rate {
    group_label: "> Dimensions"
    label: "Expected Daily Completion Value"
    description: ""
    type: number
    hidden: no
    sql: ${TABLE}.historic_expected_completion_rate ;;
  }

  dimension: end_of_month_projected_value {
    group_label: "> Dimensions"
    label: "Projected End of Month Value"
    description: ""
    type: number
    hidden: yes
    sql: ${TABLE}.end_of_month_projected_value ;;
  }


  dimension: end_of_month_projected_value_target_monthly_value_delta {
    group_label: "> Dimensions"
    label: "Projected End of Month Value Target Monthly Value Delta"
    description: ""
    type: number
    hidden: yes
    sql: ${TABLE}.end_of_month_projected_value_target_monthly_value_delta ;;
  }

  ## Measures

  measure: sum_daily_cumulative_amount {
    group_label: "> Measures"
    label: "SUM Daily Cumulative Amount"
    description: ""
    hidden: no
    type: sum
    sql: ${daily_cumulative_amount} ;;
  }

  measure: sum_historic_expected_completion_rate {
    group_label: "> Measures"
    label: "SUM Expected Daily Completion Value"
    description: ""
    type: sum
    hidden: no
    sql: ${historic_expected_completion_rate} ;;
  }

  measure: sum_end_of_month_projected_value {
    group_label: "> Measures"
    label: "SUM End of Month Projected Value"
    description: ""
    type: sum
    hidden: no
    sql: ${end_of_month_projected_value} ;;
  }

  measure: sum_target_monthly_value {
    group_label: "> Measures"
    label: "SUM Target Monthly Value"
    description: ""
    type: sum
    hidden: no
    sql: ${target_monthly_value} ;;
  }


}
