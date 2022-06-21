view: user_attributes_lifecycle_first28days {
  sql_table_name: `reporting.user_attributes_lifecycle_first28days`
    ;;

  measure: cnt_customers {
    label: "# Customers"
    type: count_distinct
    sql: ${customer_uuid} ;;
  }


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
