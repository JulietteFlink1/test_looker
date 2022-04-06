view: checkout_duplicated_order_analysis {
  derived_table: {
    sql: WITH base as (
    SELECT  anonymous_id
    , order_date
    , order_week
    , platform
    , order_timestamp
    , amt_gmv_gross
    , order_number
    , order_id
    , order_uuid
    , cart_id
    , number_of_distinct_skus
    , number_of_items
    , is_first_order
    , is_successful_order
    , customer_email
    , DENSE_RANK() OVER (PARTITION BY customer_email, platform, order_date, amt_gmv_gross, number_of_items order by order_timestamp) as rank_day_orders_gmv -- based on gmv
     , null as diff_between_subsequent_orders
    FROM `flink-data-prod.curated.orders`
    WHERE DATE(order_timestamp) >= "2022-01-01"
    AND is_successful_order = true
    )

    , chargebacks as (
    SELECT distinct order_uuid
    , booking_date
    , payment_method
    , country_iso
    , main_amount
    , record_type
    , split(modification_merchant_reference, "_")[safe_ordinal(1)] as cart_id
    FROM `flink-data-prod.curated.psp_transactions`
    where DATE(booking_timestamp) >= '2022-01-01' and record_type = 'Chargeback'
    )


    , raw as (
        SELECT b.*
        , CASE WHEN c.order_uuid IS NULL THEN 0 ELSE 1 end as chargeback_dummy
        FROM base as b
        LEFT JOIN chargebacks as c ON b.order_uuid = c.order_uuid
    )

     , calcs AS (
    SELECT
          customer_email
        , order_date
        , order_week
        , platform
        , chargeback_dummy
        , case when number_of_duplications > 1 then true else false end as has_duplicated_order
        , number_of_duplications
        , first_order
        , timestamp_diff(last_timestamp,first_timestamp, MINUTE) as min_diff_order_created
    FROM (
        SELECT DISTINCT
            customer_email
            , order_date
            , order_week
            , platform
            , chargeback_dummy
            , LAST_VALUE(rank_day_orders_gmv) OVER (partition by customer_email, platform, order_date, amt_gmv_gross, number_of_items order by order_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as number_of_duplications
            , FIRST_VALUE(is_first_order) OVER (partition by customer_email, platform, order_date, amt_gmv_gross, number_of_items order by order_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as first_order
            , FIRST_VALUE(order_timestamp) OVER (partition by customer_email, platform, order_date, amt_gmv_gross, number_of_items order by order_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as first_timestamp
            , LAST_VALUE(order_timestamp) OVER (partition by customer_email, platform, order_date, amt_gmv_gross, number_of_items order by order_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as last_timestamp
    FROM raw
    )

    )

    SELECT
          cast(order_date as string) as order_date
        , order_week
        , CASE WHEN lower(platform) LIKE 'andr%' THEN 'Android' ELSE platform end as platform
        , number_of_duplications
        , has_duplicated_order
        , first_order
        , SUM(chargeback_dummy) as total_chargebacks
        , count(distinct customer_email) as customer_email_count
        , avg(min_diff_order_created) as avg_min_diff_order_created
    FROM calcs
    GROUP BY 1,2,3,4,5,6
     ORDER BY 1,2,3,4,5,6
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

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
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

  dimension: total_chargebacks {
    hidden: yes
    type: number
    sql: ${TABLE}.total_chargebacks ;;
  }

    dimension: avg_min_diff_order_created {
      type: number
      sql: ${TABLE}.avg_min_diff_order_created ;;
    }


### Measures

  measure: sum_customer_count {
    label: "# Unique Customers"
    type: sum
    sql: ${customer_email_count} ;;
  }

  measure: sum_chargebacks_total {
    label: "# Total Chargebacks"
    type: sum
    sql: ${total_chargebacks} ;;
  }

  measure: sum_customer_count_correct_orders {
    label: "# Unique Customers with Single Orders"
    type: sum
    sql: ${customer_email_count} ;;
    filters: [has_duplicated_order: "no"]
  }

  measure: sum_customer_count_with_duplicated_orders {
    label: "# Unique Customers with Duplicated Orders"
    type: sum
    sql: ${customer_email_count} ;;
    filters: [has_duplicated_order: "yes"]
  }

  measure: customers_affected_rate {
    label: "% Customers Affected"
    type: number
    sql: NULLIF(${sum_customer_count_with_duplicated_orders},0)/NULLIF(${sum_customer_count},0) ;;
    value_format_name: percent_2
  }

  measure: chargeback_rate {
    label: "% Orders Chargebacked"
    description: "Chargeback rate out of all duplicated orders"
    type: number
    sql: NULLIF(${sum_chargebacks_total},0)/NULLIF(${sum_customer_count_with_duplicated_orders},0) ;;
    value_format_name: percent_2
  }

}
