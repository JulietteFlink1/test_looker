view: power_user_curves {
  sql_table_name: `flink-data-dev.sandbox_natalia.customer_lifecycle_28d` ;;

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

  dimension: country_iso {
    description: "Country (based on first visit)"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: platform {
    description: "Platform (based on first visit)"
    type: string
    sql: ${TABLE}.platform ;;
  }

  # dimension: anonymous_id {
  #   description: "Unique anonymous_id"
  #   type: string
  #   sql: ${TABLE}.anonymous_id ;;
  #   primary_key: yes
  #   hidden: yes
  # }

  dimension: user_id {
    description: "Unique user_uuid"
    type: string
    sql: ${TABLE}.user_uuid ;;
    primary_key: yes
    hidden: yes
  }

  dimension: has_first_order {
    description: "Flag on user first order (Y/N)"
    type: yesno
    sql: ${TABLE}.has_converted ;;
  }

  dimension: num_days_to_first_order {
    description: "Amount of days until user made first order"
    type: number
    sql: ${TABLE}.num_days_to_first_order ;;
  }

  dimension: num_visits_to_first_order {
    description: "Amount of visits until user made first order"
    type: number
    sql: ${TABLE}.num_visits_to_first_order ;;
  }

  dimension: visits_in_28d {
    description: "Amount of days (visits) in 28 days since first visit"
    type: number
    sql: ${TABLE}.visits_28d  ;;
  }

  dimension: orders_in_28d {
    description: "Amount of orders in 28 days since first visit"
    type: number
    sql: ${TABLE}.orders_28d  ;;
  }

  measure: count_users {
    description: "Unique count of visitors"
    type: count_distinct
    sql: ${TABLE}.user_uuid ;;
  }

  measure: count_users_with_order {
    description: "Unique count of visitors who made a first order"
    type: count_distinct
    sql: ${TABLE}.user_uuid ;;
    filters: [has_first_order: "yes"]
  }

}
