view: customer_metrics_cleaned_dev {
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
      ),

      orders_cleaned as (
        SELECT   o.*
              , cc.customer_email as customer_email_mapped
              , cc.customer_id as customer_id_mapped
              , cc.sign_up_timestamp_customer_id
          FROM `flink-data-prod.curated.orders` o
              LEFT JOIN curated_customers_cleaned cc
              ON lower(o.customer_email) = cc.customer_email
          WHERE  is_successful_order is true
            AND o.customer_email NOT IN ('qa@goflink.con','qa@gflink.com','qa@flink.com','qa@goflinkk.com',
                                              'qa@golink.com','qa@gofink.com','qa@gofilnk.com','qaa@goflink.com','qa@gofliink.com',
                                              'qa@goflin.com','qa@goflnik.com','qa@goflink.com','contact@goflink.com','.@gmail.com')
            AND o.customer_email != ''
            --and o.order_date < "2021-10-01" -- temp, to be changed/removed when the schedules are aligned
      ),
       first_orders AS (
      select *
          from (
                  select
                  orders.country_iso,
                  orders.customer_id_mapped,
                  orders.order_timestamp,
                  orders.order_number,
                  hubs.country,
                  hubs.city,
                  orders.hub_name,
                  orders.discount_code,
                  row_number() over (partition by customer_id_mapped, orders.country_iso order by order_timestamp asc) as order_rank
                  from orders_cleaned orders
                  left join `flink-data-prod.google_sheets.hub_metadata` hubs
                      on orders.hub_code = lower(hubs.hub_code)
                  where orders.is_successful_order is True
          )
      where order_rank=1
      )

      , latest_orders AS (
      select * from (
                  select
                  orders.country_iso,
                  orders.customer_id_mapped,
                  orders.order_number,
                  orders.order_timestamp,
                  row_number() over (partition by  customer_id_mapped, orders.country_iso order by order_timestamp desc) as order_rank
                  from orders_cleaned orders
                  where orders.is_successful_order is True
          )
      where order_rank=1
      )

      , users AS (
      SELECT
                    orders.country_iso
                  , orders.customer_id_mapped
                  , fo.order_number AS first_order_id
                  , fo.hub_name as first_order_hub
                  , fo.city as first_order_city
                  , fo.country
                  , case when fo.discount_code is not null then True else False end as is_discount_acquisition
                  , fo.discount_code as first_order_discount_code
                  , lo.order_number AS latest_order_id
                  , orders.sign_up_timestamp_customer_id
                  , fo.order_timestamp AS first_order
                  , lo.order_timestamp AS latest_order
                  , COUNT(DISTINCT orders.order_uuid) AS lifetime_orders
                  , SUM(orders.amt_revenue_gross) AS lifetime_revenue_gross
                  , SUM(orders.amt_revenue_net) AS lifetime_revenue_net
                  , COUNT(DISTINCT FORMAT_TIMESTAMP('%Y%m', orders.order_timestamp)) AS number_of_distinct_months_with_orders
      FROM orders_cleaned orders
      left join first_orders fo
          on orders.customer_id_mapped = fo.customer_id_mapped and orders.country_iso = fo.country_iso
      left join latest_orders lo
          on orders.customer_id_mapped = lo.customer_id_mapped and orders.country_iso = lo.country_iso
      where orders.is_successful_order is True

      GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
      )

      , orders_per_week_month AS (
      select
              country_iso,
              customer_id_mapped,
              case when
                  DATE_DIFF(CURRENT_DATE(),date(first_order), WEEK) > 0
              then
                  lifetime_orders / DATE_DIFF(CURRENT_DATE(),date(first_order), WEEK)
              else
                  null
              end as orders_per_week,
              case when
              DATE_DIFF(CURRENT_DATE(),date(first_order), MONTH) > 0
              then
                  lifetime_orders / DATE_DIFF(CURRENT_DATE(),date(first_order), MONTH) else null end as orders_per_month
      from  users
      )
      , reorders_28 AS (
          select
             users.country_iso,
             users.customer_id_mapped,
             count(distinct orders.order_uuid) as _28_day_reorder_number
      from users
      left join orders_cleaned orders
      on
          users.customer_id_mapped=orders.customer_id_mapped
      where
          date_diff(date(orders.order_timestamp), date(users.first_order) , DAY) <= 28
      and
          users.first_order_id != orders.order_uuid
      and orders.is_successful_order is True
      group by 1,2
      )

      , reorders_30 AS (
      select
             users.country_iso,
             users.customer_id_mapped,
             count(distinct(orders.order_uuid)) as _30_day_reorder_number
      from users
      left join orders_cleaned orders
      on
          users.customer_id_mapped=orders.customer_id_mapped
      where
          date_diff(date(orders.order_timestamp), date(users.first_order) , DAY) <= 30
      and
          users.first_order_id != orders.order_uuid
      and orders.is_successful_order is True
      group by 1,2
      )

      , latest_order_with_voucher AS (
      select
             orders.country_iso,
             orders.customer_id_mapped,
             MAX(orders.order_timestamp) as latest_order_with_voucher
      from  orders_cleaned  orders
      where orders.discount_code is not null
      and orders.is_successful_order is True
      group by 1,2
      )


      select distinct
          users.customer_id_mapped                                          as customer_id_mapped,
          users.country_iso                                                 as country_iso,
          cast(null as string)                                              as customer_id,
          users.lifetime_orders                                             as number_of_lifetime_orders,
          users.lifetime_revenue_gross                                      as amt_lifetime_revenue_gross,
          users.lifetime_revenue_net                                        as amt_lifetime_revenue_net,
          users.first_order_id                                              as first_order_uuid,
          users.country                                                     as first_order_country,
          users.first_order_city                                            as first_order_city,
          users.first_order_hub                                             as first_order_hub,
          users.is_discount_acquisition                                     as is_discount_acquisition,
          users.first_order_discount_code                                   as first_order_discount_code,
          users.latest_order_id                                             as latest_order_uuid,
          users.first_order                                                 as first_order_timestamp,
          users.latest_order                                                as latest_order_timestamp,
          users.number_of_distinct_months_with_orders                       as number_of_distinct_months_with_orders,
          NULL                                                              as top_1_product,
          NULL                                                              as top_2_product,
          NULL                                                              as top_3_product,
          NULL                                                              as top_1_category,
          NULL                                                              as top_2_category,
          NULL                                                              as favourite_order_day,
          NULL                                                              as favourite_order_hour,
          reorders_28._28_day_reorder_number,
          reorders_30._30_day_reorder_number,
          latest_order_with_voucher.latest_order_with_voucher               as last_order_with_voucher,
          orders_per_week_month.orders_per_week                             as avg_orders_per_week,
          orders_per_week_month.orders_per_month                            as avg_orders_per_month,
          NULL                                                              as delta_to_pdt_of_latest_oder,
          NULL                                                              as has_opted_out
          from  users
          left join orders_per_week_month
          on users.customer_id_mapped=orders_per_week_month.customer_id_mapped and users.country_iso = orders_per_week_month.country_iso
          left join reorders_28
          on users.customer_id_mapped=reorders_28.customer_id_mapped and users.country_iso = reorders_28.country_iso
          left join reorders_30
          on users.customer_id_mapped=reorders_30.customer_id_mapped and users.country_iso = reorders_30.country_iso
          left join latest_order_with_voucher
          on users.customer_id_mapped=latest_order_with_voucher.customer_id_mapped and users.country_iso = latest_order_with_voucher.country_iso
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: customer_id_mapped {
    type: string
    sql: ${TABLE}.customer_id_mapped ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: number_of_lifetime_orders {
    type: number
    sql: ${TABLE}.number_of_lifetime_orders ;;
  }

  dimension: amt_lifetime_revenue_gross {
    type: number
    sql: ${TABLE}.amt_lifetime_revenue_gross ;;
  }

  dimension: amt_lifetime_revenue_net {
    type: number
    sql: ${TABLE}.amt_lifetime_revenue_net ;;
  }

  dimension: first_order_uuid {
    type: string
    sql: ${TABLE}.first_order_uuid ;;
  }

  dimension: first_order_country {
    type: string
    sql: ${TABLE}.first_order_country ;;
  }

  dimension: first_order_city {
    type: string
    sql: ${TABLE}.first_order_city ;;
  }

  dimension: first_order_hub {
    type: string
    sql: ${TABLE}.first_order_hub ;;
  }

  dimension: is_discount_acquisition {
    type: string
    sql: ${TABLE}.is_discount_acquisition ;;
  }

  dimension: first_order_discount_code {
    type: string
    sql: ${TABLE}.first_order_discount_code ;;
  }

  dimension: latest_order_uuid {
    type: string
    sql: ${TABLE}.latest_order_uuid ;;
  }

  dimension_group: first_order_timestamp {
    type: time
    sql: ${TABLE}.first_order_timestamp ;;
  }

  dimension_group: latest_order_timestamp {
    type: time
    sql: ${TABLE}.latest_order_timestamp ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  dimension: top_1_product {
    type: number
    sql: ${TABLE}.top_1_product ;;
  }

  dimension: top_2_product {
    type: number
    sql: ${TABLE}.top_2_product ;;
  }

  dimension: top_3_product {
    type: number
    sql: ${TABLE}.top_3_product ;;
  }

  dimension: top_1_category {
    type: number
    sql: ${TABLE}.top_1_category ;;
  }

  dimension: top_2_category {
    type: number
    sql: ${TABLE}.top_2_category ;;
  }

  dimension: favourite_order_day {
    type: number
    sql: ${TABLE}.favourite_order_day ;;
  }

  dimension: favourite_order_hour {
    type: number
    sql: ${TABLE}.favourite_order_hour ;;
  }

  dimension: _28_day_reorder_number {
    type: number
    sql: ${TABLE}._28_day_reorder_number ;;
  }

  dimension: _30_day_reorder_number {
    type: number
    sql: ${TABLE}._30_day_reorder_number ;;
  }

  dimension_group: last_order_with_voucher {
    type: time
    sql: ${TABLE}.last_order_with_voucher ;;
  }

  dimension: avg_orders_per_week {
    type: number
    sql: ${TABLE}.avg_orders_per_week ;;
  }

  dimension: avg_orders_per_month {
    type: number
    sql: ${TABLE}.avg_orders_per_month ;;
  }

  dimension: delta_to_pdt_of_latest_oder {
    type: number
    sql: ${TABLE}.delta_to_pdt_of_latest_oder ;;
  }

  dimension: has_opted_out {
    type: number
    sql: ${TABLE}.has_opted_out ;;
  }

  set: detail {
    fields: [
      customer_id_mapped,
      country_iso,
      customer_id,
      number_of_lifetime_orders,
      amt_lifetime_revenue_gross,
      amt_lifetime_revenue_net,
      first_order_uuid,
      first_order_country,
      first_order_city,
      first_order_hub,
      is_discount_acquisition,
      first_order_discount_code,
      latest_order_uuid,
      first_order_timestamp_time,
      latest_order_timestamp_time,
      number_of_distinct_months_with_orders,
      top_1_product,
      top_2_product,
      top_3_product,
      top_1_category,
      top_2_category,
      favourite_order_day,
      favourite_order_hour,
      _28_day_reorder_number,
      _30_day_reorder_number,
      last_order_with_voucher_time,
      avg_orders_per_week,
      avg_orders_per_month,
      delta_to_pdt_of_latest_oder,
      has_opted_out
    ]
  }
}
