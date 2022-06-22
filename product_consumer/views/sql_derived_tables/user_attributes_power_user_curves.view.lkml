view: user_attributes_power_user_curves {
  derived_table: {
    sql:  with daily_user_aggregates as (
        select *
        from `flink-data-dev.reporting.user_attributes_daily_user_aggregates`
        where
         date_diff(visit_date, first_visit_date, DAY) < 28
      )

      select
      daily_unique_customer_uuid
      , country_iso
      , platform
      , is_active_user
      , first_visit_date
      , first_order_date
      , has_converted
      , number_of_days_to_first_order
      , number_of_visits_to_first_order
      , max(visit_rank)                  as visits_28d
      , sum(if(number_of_daily_orders>0,1,0)) as orders_28d
      , sum(number_of_daily_orders)      as sum_orders_28d
      , sum(number_of_discounted_orders) as discounted_orders_28d
      from daily_user_aggregates
      group by 1,2,3,4,5,6,7,8,9
      ;;
  }


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
    sql: ${TABLE}.platform ;;
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
    sql: ${TABLE}.visits_28d  ;;
  }

  dimension: orders_in_28d {
    description: "Amount of days with orders in 28 days since first visit"
    type: number
    sql: ${TABLE}.orders_28d  ;;
  }

  dimension: sum_orders_28d {
    description: "Amount of orders in 28 days since first visit"
    type: number
    sql: ${TABLE}.sum_orders_28d  ;;
    }

  dimension: discounted_orders_28d {
    description: "Amount of discounted orders in 28 days since first visit"
    type: number
    sql: ${TABLE}.discounted_orders_28d  ;;
  }

  ############ Measures   ############

  measure: count_users {
    description: "Unique count of visitors"
    type: count_distinct
    sql: ${TABLE}.daily_unique_customer_uuid ;;
  }

  measure: count_users_who_converted {
    description: "Unique count of visitors who made a first order"
    type: count_distinct
    sql: ${TABLE}.daily_unique_customer_uuid ;;
    filters: [has_converted: "yes"]
  }


}
