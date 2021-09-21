view: map_customer_email_id {
  derived_table: {
    sql: WITH saelor_customers AS (
        SELECT  lower(customer_email) as customer_email
              , country_iso
              , phone_number
              , sign_up_timestamp
              , 'saelor' as backed_source
        FROM (
                SELECT
                   country_iso
                 , customer_email
                 , phone_number
                 , id
                 , created as sign_up_timestamp
                 , hub_name
                 , row_number() over(partition by customer_email order by created asc) as rank -- changed partition by from country_iso, phone_number to achieve unique customer_email (aligning with ct logic)
                FROM (
                        SELECT  order_order.country_iso,
                                user_email as customer_email,
                                address.phone as phone_number,
                                order_order.id,
                                order_order.created,
                                CASE WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
                                WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
                                ELSE JSON_EXTRACT_SCALAR(metadata, '$.warehouse') end as hub_name
                        FROM `flink-data-prod.saleor_prod_global.order_order` order_order
                        left join `flink-data-prod.saleor_prod_global.account_address` address
                            on order_order.country_iso = address.country_iso and order_order.shipping_address_id = address.id
                            where order_order.status in ('fulfilled', 'partially fulfilled')) a
                    )
        where rank=1
        and phone_number is not null
        order by 1 asc
)

, ct_customers AS (
SELECT
            lower(customer_email) as customer_email
          , country_iso
          , phone_number
          , sign_up_timestamp
          , 'commercetools' as backed_source
 FROM `flink-data-prod.curated.customers`
)
,curated_customers AS (
    SELECT * FROM saelor_customers
    UNION ALL
    SELECT * FROM ct_customers
),
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
),
map_data AS(
  SELECT customer_email
       , customer_id
       , country_iso
       , sign_up_timestamp_customer_id
  FROM customer_map_clean
  WHERE rank = 1
  GROUP BY 1,2,3,4
)
SELECT customer_email
    , customer_id
    , country_iso
    , sign_up_timestamp_customer_id
    , COUNT(DISTINCT customer_email) OVER (PARTITION BY country_iso, customer_id) as num_other_emails
FROM map_data
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

  measure: cnt_distinct_email {
    type: count_distinct
    sql: ${customer_email} ;;
  }

  measure: cnt_distinct_id {
    type: count_distinct
    sql: ${customer_id} ;;
  }

  dimension: num_other_emails_dim {
    description: "Number of Emails associated with the user, based on the phone number"
    label: "# Distinct Emails per User"
    type: number
    sql: ${TABLE}.num_other_emails ;;
  }

  measure: num_other_emails {
    type: sum
    sql: ${num_other_emails_dim} ;;
  }

  measure: email_list {
    type: string
    sql: STRING_AGG(distinct ${customer_email}) ;;
  }
  set: detail {
    fields: [customer_email, customer_id, country_iso, sign_up_timestamp_customer_id_time]
  }
}
