view: curated_customers_cleaned_dev {
  derived_table: {
    sql: WITH
      curated_customers as (
      SELECT
                  lower(customer_email) as customer_email
                , first_order_country as country_iso
                , first_order_phone_number as phone_number
                , account_created_at_timestamp as sign_up_timestamp
                , 'commercetools' as backed_source
       FROM `flink-data-dev.curated.customers`
      ),

      curated_customers_cleaned as
      ( select * from ( with
      customer_map AS (
          SELECT *
              , CONCAT(country_iso, "_", phone_number_cleaned) as customer_id
              , FIRST_VALUE(sign_up_timestamp) OVER (PARTITION BY CONCAT(country_iso, "_", phone_number_cleaned) ORDER BY sign_up_timestamp) as sign_up_timestamp_customer_id
          FROM (
      SELECT
                  customer_email
                , phone_number
                , CASE
                       WHEN phone_number LIKE '%+%' AND LEFT(SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),4),1) = '0' THEN SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),5)
                       WHEN phone_number LIKE '%+%' THEN SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),4)
                       WHEN LEFT(phone_number,2) = '00' THEN SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),5)
                       WHEN LEFT(phone_number,1) = '0' AND LEFT(phone_number,2) != '00' THEN SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),2)
                       ELSE REGEXP_REPLACE(phone_number, ' ', '' )
                  END as phone_number_cleaned
                , sign_up_timestamp
                , country_iso
                , backed_source
       FROM curated_customers
      --  where phone_number != ''
      --    and phone_number not like '000%'
      )t
      )
      , customer_map_clean AS (
      SELECT
              customer_email
            -- , customer_email_cleaned
            , case when phone_number_cleaned like '00%' then concat(country_iso,"_",customer_email)
                   when phone_number_cleaned = ''       then concat(country_iso,"_",customer_email)
                  else customer_id
              end as customer_id
            , country_iso
            , phone_number
            , phone_number_cleaned
            , sign_up_timestamp
            , sign_up_timestamp_customer_id
            , backed_source
            , DENSE_RANK() OVER(PARTITION BY customer_email ORDER BY sign_up_timestamp_customer_id ASC) as rank
      FROM customer_map
      GROUP BY 1,2,3,4,5,6,7,8
      )

      SELECT customer_email
           , customer_id
           , country_iso
           , sign_up_timestamp_customer_id
      FROM customer_map_clean
      WHERE rank = 1
      GROUP BY 1,2,3,4  )
      )
      select * from curated_customers_cleaned
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: sign_up_timestamp_customer_id {
    type: time
    sql: ${TABLE}.sign_up_timestamp_customer_id ;;
  }

  set: detail {
    fields: [customer_email, customer_id, country_iso, sign_up_timestamp_customer_id_time]
  }
}

# view: curated_customers_cleaned_dev {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
