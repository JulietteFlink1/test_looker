view: user_attributes_lifecycle_first28days {
  sql_table_name: `flink-data-prod.reporting.user_attributes_lifecycle_first28days`
    ;;

  # -------- measures --------- #
  measure: cnt_customers {
    label: "# Customers"
    type: count_distinct
    sql: ${customer_uuid} ;;
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

  #----------------------------


  dimension: customer_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.customer_uuid ;;
  }

  dimension: amt_discount_gross {
    type: number
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: amt_discount_net {
    type: number
    sql: ${TABLE}.amt_discount_net ;;
  }

  dimension: amt_gmv_gross {
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: amt_gmv_net {
    type: number
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: amt_revenue_gross {
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: amt_revenue_net {
    type: number
    sql: ${TABLE}.amt_revenue_net ;;
  }

  dimension: avg_days_between_orders {
    type: number
    sql: ${TABLE}.avg_days_between_orders ;;
  }

  dimension: avg_days_between_visits {
    type: number
    sql: ${TABLE}.avg_days_between_visits ;;
  }

  dimension: avg_discount_gross {
    type: number
    sql: ${TABLE}.avg_discount_gross ;;
  }

  dimension: avg_discount_net {
    type: number
    sql: ${TABLE}.avg_discount_net ;;
  }

  dimension: avg_gmv_gross {
    type: number
    sql: ${TABLE}.avg_gmv_gross ;;
  }

  dimension: avg_gmv_net {
    type: number
    sql: ${TABLE}.avg_gmv_net ;;
  }

  dimension: avg_revenue_gross {
    type: number
    sql: ${TABLE}.avg_revenue_gross ;;
  }

  dimension: avg_revenue_net {
    type: number
    sql: ${TABLE}.avg_revenue_net ;;
  }

  dimension: first_country_iso {
    type: string
    sql: ${TABLE}.first_country_iso ;;
  }

  dimension_group: first_order {
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
    type: string
    sql: ${TABLE}.first_order_platform ;;
  }

  dimension_group: first_visit {
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
    type: string
    sql: ${TABLE}.first_visit_platform ;;
  }

  dimension: is_xdevice_conversion {
    type: yesno
    sql: ${TABLE}.is_xdevice_conversion ;;
  }

  dimension_group: last_order {
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

  dimension: number_of_days_ordering {
    type: number
    sql: ${TABLE}.number_of_days_ordering ;;
  }

  dimension: number_of_days_to_first_order {
    type: number
    sql: ${TABLE}.number_of_days_to_first_order ;;
  }

  dimension: number_of_days_visited {
    type: number
    sql: ${TABLE}.number_of_days_visited ;;
  }

  dimension: number_of_discounted_orders {
    type: number
    sql: ${TABLE}.number_of_discounted_orders ;;
  }

  dimension: number_of_orders {
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: number_of_visits_to_first_order {
    type: number
    sql: ${TABLE}.number_of_visits_to_first_order ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
