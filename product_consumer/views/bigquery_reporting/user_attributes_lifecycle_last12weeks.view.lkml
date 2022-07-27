view: user_attributes_lifecycle_last12weeks {
  sql_table_name: `flink-data-prod.reporting.user_attributes_lifecycle_last12weeks`
    ;;


  dimension: customer_uuid {
    type: string
    sql: ${TABLE}.customer_uuid ;;
  }


  #========= Measures =========#

  measure: cnt_customers {
    label: "# Customers"
    type: count_distinct
    sql: ${customer_uuid} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: total_gmv_min {
    type: min
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_percentile_50 {
    type: median
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }
  measure: total_gmv_max {
    type: max
    sql: ${avg_gmv_gross}*${number_of_days_ordering} ;;
    value_format_name: eur
  }

  measure: avg_number_of_days_ordering {
    type: average
    sql: ${number_of_days_ordering};;
  }

  measure: avg_number_of_days_visiting {
    type: average
    sql: ${number_of_days_visited};;
  }

  measure: number_of_days_visiting_min {
    type: min
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_50 {
    type: median
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${number_of_days_visited} ;;
  }
  measure: number_of_days_visiting_max {
    type: max
    sql: ${number_of_days_visited} ;;
  }

  measure: avg_gmv_min {
    type: min
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_50 {
    type: median
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }
  measure: avg_gmv_max {
    type: max
    sql: ${avg_gmv_gross} ;;
    value_format_name: eur
  }

  measure: days_since_last_order_min {
    type: min
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_50 {
    type: median
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${days_since_last_order} ;;
  }
  measure: days_since_last_order_max {
    type: max
    sql: ${days_since_last_order} ;;
  }

  measure: days_since_last_visit_min {
    type: min
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_50 {
    type: median
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${days_since_last_visit} ;;
  }
  measure: days_since_last_visit_max {
    type: max
    sql: ${days_since_last_order} ;;
  }

  measure: number_of_days_ordering_min {
    type: min
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_25 {
    type: percentile
    percentile: 25
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_50 {
    type: median
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_75 {
    type: percentile
    percentile: 75
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_percentile_95 {
    type: percentile
    percentile: 95
    sql: ${number_of_days_ordering} ;;
  }
  measure: number_of_days_ordering_max {
    type: max
    sql: ${number_of_days_ordering} ;;
  }

  #========= Monetary =========#

  dimension: avg_gmv_gross_tier_2 {
    group_label: "* Monetary Values *"
    label: "Average GMV (tiered, 2 EUR)"
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70]
    style: relational
    sql: ${avg_gmv_gross} ;;
  }

  dimension: amt_gmv_gross {
    group_label: "* Monetary Values *"
    label: "GMV Gross"
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: amt_gmv_net {
    group_label: "* Monetary Values *"
    label: "GMV Net"
    type: number
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: amt_revenue_gross {
    group_label: "* Monetary Values *"
    label: "Revenue Gross"
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: amt_revenue_net {
    group_label: "* Monetary Values *"
    label: "Revenue Net"
    type: number
    sql: ${TABLE}.amt_revenue_net ;;
  }

  dimension: avg_gmv_gross {
    group_label: "* Monetary Values *"
    label: "Average GMV Gross"
    type: number
    sql: ${TABLE}.avg_gmv_gross ;;
  }

  dimension: avg_gmv_net {
    group_label: "* Monetary Values *"
    label: "Average GMV Net"
    type: number
    sql: ${TABLE}.avg_gmv_net ;;
  }

  dimension: avg_revenue_gross {
    group_label: "* Monetary Values *"
    label: "Average Revenue Gross"
    type: number
    sql: ${TABLE}.avg_revenue_gross ;;
  }

  dimension: avg_revenue_net {
    group_label: "* Monetary Values *"
    label: "Average Revenue Net"
    type: number
    sql: ${TABLE}.avg_revenue_net ;;
  }


  #========= User Attributes =========#

  dimension: first_country_iso {
    group_label: "* User Attributes *"
    type: string
    sql: ${TABLE}.first_country_iso ;;
  }

  dimension_group: first_order {
    group_label: "* User Attributes *"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: first_order_platform {
    group_label: "* User Attributes *"
    type: string
    sql: ${TABLE}.first_order_platform ;;
  }

  dimension_group: first_visit {
    group_label: "* User Attributes *"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.first_visit_date ;;
  }

  dimension: first_visit_platform {
    group_label: "* User Attributes *"
    type: string
    sql: ${TABLE}.first_visit_platform ;;
  }

  dimension: is_xdevice_conversion {
    group_label: "* User Attributes *"
    type: yesno
    sql: ${TABLE}.is_xdevice_conversion ;;
  }

  dimension: number_of_days_to_first_order {
    group_label: "* User Attributes *"
    type: number
    sql: ${TABLE}.number_of_days_to_first_order ;;
  }

  dimension: number_of_visits_to_first_order {
    group_label: "* User Attributes *"
    type: number
    sql: ${TABLE}.number_of_visits_to_first_order ;;
  }


  #========= Recency =========#

  dimension: days_since_last_visit {
    group_label: "* Recency Values *"
    type: number
    sql: date_diff(${execution_date}, ${last_visit_date}, day) ;;
  }

  dimension: days_since_last_order {
    group_label: "* Recency Values *"
    type: number
    sql: date_diff(${execution_date}, ${last_order_date}, day) ;;
  }

  dimension_group: last_order {
    group_label: "* Recency Values *"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_order_date ;;
  }

  dimension_group: last_visit {
    group_label: "* Recency Values *"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_visit_date ;;
  }


  #========= Frequency =========#

  dimension: avg_days_between_orders {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.avg_days_between_orders ;;
  }

  dimension: avg_days_between_visits {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.avg_days_between_visits ;;
  }

  dimension: number_of_days_ordering {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.number_of_days_ordering ;;
  }

  dimension: number_of_days_visited {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.number_of_days_visited ;;
  }

  dimension: number_of_orders {
    group_label: "* Frequency Values*"
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: order_to_visit_ratio_tier {
    group_label: "* Frequency Values*"
    label: "Order To Visit Ratio (tiered, 0.05)"
    type: tier
    tiers: [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1]
    style: relational
    sql: ${order_to_visit_ratio} ;;
  }

  dimension: order_to_visit_ratio {
    group_label: "* Frequency Values*"
    type: number
    sql: 1.0* ${number_of_days_ordering}/${number_of_days_visited} ;;
    value_format_name: decimal_2
  }

  dimension_group: execution {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      day_of_week_index,
      day_of_week,
      day_of_month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.execution_date ;;
  }

  dimension_group: oldest_order {
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.oldest_order_date ;;
  }

  dimension_group: oldest_visit {
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.oldest_visit_date ;;
  }
}
