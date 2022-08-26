view: user_attributes_power_user_curves {
  sql_table_name: `flink-data-prod.reporting.user_attributes_all_users_first28days`;;


  dimension: daily_unique_customer_uuid {
    description: "Unique anonymous_id or customer_uuid"
    type: string
    sql: ${TABLE}.daily_unique_customer_uuid ;;
    primary_key: yes
    hidden: yes
  }

  dimension: country_iso {
    description: "Country (based on first visit)"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: platform {
    description: "Platform (based on first visit)"
    type: string
    sql: ${TABLE}.first_visit_platform ;;
  }

  dimension: is_active_user {
    description: "Active User"
    type: yesno
    sql: ${TABLE}.is_active_user ;;
  }

  dimension_group: first_visit_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.first_visit_date AS DATE) ;;
    datatype: date
  }

  dimension_group: first_order_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.first_order_date AS DATE) ;;
    datatype: date
  }

  dimension: has_converted {
    description: "User has converted (anytime)"
    type: yesno
    sql: ${TABLE}.has_converted ;;
  }

  dimension: number_of_days_to_first_order {
    description: "Amount of days until user made first order"
    type: number
    sql: ${TABLE}.number_of_days_to_first_order ;;
  }

  dimension: number_of_visits_to_first_order {
    description: "Amount of visits until user made first order"
    type: number
    sql: ${TABLE}.number_of_visits_to_first_order ;;
  }

  dimension: visits_in_28d {
    description: "Amount of days (visits) in 28 days since first visit"
    type: number
    sql: ${TABLE}.number_of_days_visited  ;;
  }

  dimension: orders_in_28d {
    description: "Amount of days with orders in 28 days since first visit"
    type: number
    sql: ${TABLE}.number_of_days_ordering  ;;
  }

  dimension: sum_orders_28d {
    description: "Amount of orders in 28 days since first visit"
    type: number
    sql: ${TABLE}.number_of_orders  ;;
    }

  dimension: discounted_orders_28d {
    description: "Amount of discounted orders in 28 days since first visit"
    type: number
    sql: ${TABLE}.number_of_discounted_orders  ;;
  }

  ############ Measures   ############

  measure: count_users {
    description: "Unique count of visitors"
    type: count_distinct
    sql: ${TABLE}.daily_unique_customer_uuid ;;
  }

  measure: count_visits {
    description: "Sum of visits in 28 days since first visit"
    type: sum
    sql: ${TABLE}.number_of_days_visited  ;;
  }

  measure: count_visits_with_orders {
    description: "Sum of visits with orders in 28 days since first visit"
    type: sum
    sql: ${TABLE}.number_of_days_ordering  ;;
  }

  measure: count_users_who_converted {
    description: "Unique count of visitors who made a first order"
    type: count_distinct
    sql: ${TABLE}.daily_unique_customer_uuid ;;
    filters: [has_converted: "yes"]
  }

  measure: count_users_who_converted_on_day0 {
    description: "Unique count of visitors who made a first order on first visit"
    type: count_distinct
    sql: ${TABLE}.daily_unique_customer_uuid ;;
    filters: [has_converted: "yes",number_of_days_to_first_order: "0" ]
  }

  measure: count_users_who_converted_on_day28 {
    description: "Unique count of visitors who made a first order on first visit"
    type: count_distinct
    sql: ${TABLE}.daily_unique_customer_uuid ;;
    filters: [has_converted: "yes",number_of_days_to_first_order: "<28" ]
  }




}
