view: checkout_duplicated_order_analysis {
  derived_table: {
    sql: WITH base as (
    SELECT  anonymous_id
    , order_date
    , order_week
    , order_timestamp
    , amt_gmv_gross
    , order_number
    , order_id
    , cart_id
    , number_of_distinct_skus
    , number_of_items
    , is_first_order
    , is_successful_order
    , customer_email
    , DENSE_RANK() OVER (PARTITION BY customer_email, order_date, amt_gmv_gross, number_of_items order by order_timestamp) as rank_day_orders_gmv -- based on gmv
     , null as diff_between_subsequent_orders
    FROM `flink-data-prod.curated.orders`
    WHERE DATE(order_timestamp) BETWEEN "2021-06-01" AND "2021-11-17"
    AND is_successful_order = true
    )

    , calcs AS (
    SELECT customer_email
        , order_date
        , order_week
        , case when number_of_duplications > 1 then true else false end as has_duplicated_order
        , number_of_duplications
        , first_order
        , timestamp_diff(last_timestamp,first_timestamp, MINUTE) as min_diff_order_created
    FROM (
        SELECT DISTINCT
            customer_email
            , order_date
            , order_week
            , LAST_VALUE(rank_day_orders_gmv) OVER (partition by customer_email, order_date, amt_gmv_gross, number_of_items order by order_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as number_of_duplications
            , FIRST_VALUE(is_first_order) OVER (partition by customer_email, order_date, amt_gmv_gross, number_of_items order by order_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as first_order
            , FIRST_VALUE(order_timestamp) OVER (partition by customer_email, order_date, amt_gmv_gross, number_of_items order by order_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as first_timestamp
            , LAST_VALUE(order_timestamp) OVER (partition by customer_email, order_date, amt_gmv_gross, number_of_items order by order_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as last_timestamp
    FROM base
    ))

    SELECT
          cast(order_date as string) as order_date
        , order_week
        , number_of_duplications
        , has_duplicated_order
        , first_order
        , count(distinct customer_email) as customer_email_count
        , avg(min_diff_order_created) as avg_min_diff_order_created
    FROM calcs
    GROUP BY 1,2,3,4,5
     ORDER BY 1,2,3,4,5
  ;;

  }

  # dimension: order_date {
  #   group_label: "Order Date"
  #   type: string
  #   sql: ${TABLE}.order_date ;;
  # }

  #   dimension_group: order_date {
  #   type: time
  #   timeframes: [date, week, month, year]
  #   datatype: date
  #   sql: ${TABLE}.order_date;;
  #   }

  dimension_group: order {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.order_date AS DATE) ;;
    datatype: date
  }

    dimension: number_of_duplications {
      type: number
      sql: ${TABLE}.number_of_duplications ;;
    }

  dimension: has_duplicated_order {
    type: yesno
    sql: ${TABLE}.has_duplicated_order ;;
  }

    dimension: first_order {
      type: yesno
      sql: ${TABLE}.first_order ;;
    }

    dimension: customer_email_count {
      hidden: yes
      type: number
      sql: ${TABLE}.customer_email_count ;;
    }

    dimension: avg_min_diff_order_created {
      type: number
      sql: ${TABLE}.avg_min_diff_order_created ;;
    }


  measure: sum_custromer_count {
    label: "# Unique Customers"
    type: sum
    sql: ${customer_email_count} ;;
  }

  measure: sum_custromer_count_correct_orders {
    label: "# Unique Customers with Single Orders"
    type: sum
    sql: ${customer_email_count} ;;
    filters: [has_duplicated_order: "no"]
  }

  measure: sum_custromer_count_with_duplicated_orders {
    label: "# Unique Customers with Duplicated Orders"
    type: sum
    sql: ${customer_email_count} ;;
    filters: [has_duplicated_order: "yes"]
  }

}
