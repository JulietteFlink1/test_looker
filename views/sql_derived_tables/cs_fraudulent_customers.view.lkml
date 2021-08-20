view: cs_fraudulent_customers {
  derived_table: {
    sql: SELECT
          orders_cl_user_email,
          orders_cl_cnt_orders,
          cs_post_delivery_issues_cnt_unique_orders,
              cs_post_delivery_issues_cnt_unique_orders / NULLIF(orders_cl_cnt_orders, 0) AS cs_post_delivery_issues_pct_unique_contact_rate
      FROM
          (SELECT
                  orders_cl.customer_email  AS orders_cl_user_email,
                  COUNT(DISTINCT orders_cl.order_uuid ) AS orders_cl_cnt_orders,
                  COUNT(DISTINCT cs_post_delivery_issues.order_nr_ ) AS cs_post_delivery_issues_cnt_unique_orders,
                  COUNT(DISTINCT cs_post_delivery_issues.order_nr_ ) AS cs_post_delivery_issues_cnt_unique_orders_0,
                  COUNT(DISTINCT orders_cl.order_uuid ) AS orders_cl_cnt_orders_0,
                  COUNT(DISTINCT orders_cl.order_uuid ) AS orders_cl_cnt_orders_1
              FROM `flink-data-prod.curated.orders`
           AS orders_cl
      LEFT JOIN `flink-data-prod.curated.hubs`
           AS hubs ON lower(orders_cl.hub_code) = hubs.hub_code
      LEFT JOIN `flink-data-prod.curated.cs_post_delivery_issues`
           AS cs_post_delivery_issues ON orders_cl.country_iso = cs_post_delivery_issues.country_iso AND
            cs_post_delivery_issues.order_nr_ = orders_cl.order_id
              WHERE (orders_cl.partition_timestamp ) >= (TIMESTAMP('2021-01-25 00:00:00', 'Europe/Berlin')) AND (NOT (orders_cl.is_internal_order ) OR (orders_cl.is_internal_order ) IS NULL) AND (orders_cl.is_successful_order ) AND ((UPPER(( orders_cl.country_iso  )) LIKE UPPER('%') OR (( orders_cl.country_iso  ) IS NULL))) AND ((UPPER(( hubs.city  )) LIKE UPPER('%') OR (( hubs.city  ) IS NULL)))
              GROUP BY
                  1
              HAVING (( orders_cl_cnt_orders_1 ) > 2)) AS t3
      ORDER BY
          4 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: orders_cl_user_email {
    label: "User Email"
    primary_key:  yes
    type: string
    sql: ${TABLE}.orders_cl_user_email ;;
  }

  dimension: orders_cl_cnt_orders {
    label: "# Orders"
    type: number
    sql: ${TABLE}.orders_cl_cnt_orders ;;
  }

  dimension: cs_post_delivery_issues_cnt_unique_orders {
    label: "# Orders with Post Delivery Issue"
    type: number
    sql: ${TABLE}.cs_post_delivery_issues_cnt_unique_orders ;;
  }

  dimension: cs_post_delivery_issues_pct_unique_contact_rate {
    label: "% Orders with Post Delivery Issue"
    type: number
    sql: ${TABLE}.cs_post_delivery_issues_pct_unique_contact_rate ;;
  }

  measure: cnt_customers{
    label: "# Customers"
    type: count_distinct
    sql: ${orders_cl_user_email} ;;

  }
  set: detail {
    fields: [orders_cl_user_email, orders_cl_cnt_orders, cs_post_delivery_issues_cnt_unique_orders, cs_post_delivery_issues_pct_unique_contact_rate]
  }



}
