view: user_order_facts {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql:
    with users as
    (
    SELECT
            country_iso
            , user_email
            , COUNT(DISTINCT id) AS lifetime_orders
            , SUM(total_gross_amount) AS lifetime_revenue_gross
            , SUM(total_net_amount) AS lifetime_revenue_net
            , MIN(id) AS first_order_id
            , MAX(id) AS latest_order_id
            , MIN(created) AS first_order
            , MAX(created) AS latest_order
            , COUNT(DISTINCT FORMAT_TIMESTAMP('%Y%m', created)) AS number_of_distinct_months_with_orders
            , COUNT(DISTINCT FORMAT_TIMESTAMP('%Y%W', created)) AS number_of_distinct_weeks_with_orders
          FROM `flink-backend.saleor_db_global.order_order` order_order
          GROUP BY country_iso, user_email
    ),

    agg_products_by_user as
    (
    select
      orders.country_iso,
      orders.user_email,
      orderline.product_name,
      sum(orderline.quantity) as sum_quantity
      from `flink-backend.saleor_db_global.order_order` orders
      left join `flink-backend.saleor_db_global.order_orderline` orderline
      on orders.country_iso = orderline.country_iso and orders.id = orderline.order_id
      group by 1, 2, 3
    ),

    categories_by_user as
    (
    select
      orders.country_iso,
      orders.user_email,
      orderline.product_sku,
      orderline.product_name,
      pcategory.name as category_name
      from `flink-backend.saleor_db_global.order_order` orders
      left join `flink-backend.saleor_db_global.order_orderline` orderline
      on orders.country_iso = orderline.country_iso and orders.id = orderline.order_id
      left join `flink-backend.saleor_db_global.product_productvariant` pvariant
      on orderline.country_iso = pvariant.country_iso and orderline.product_sku=pvariant.sku
      left join `flink-backend.saleor_db_global.product_product` pproduct
      on pvariant.country_iso = pproduct.country_iso and pvariant.id=pproduct.id
      left join `flink-backend.saleor_db_global.product_category` pcategory
      on pproduct.country_iso = pcategory.country_iso and pproduct.category_id=pcategory.id
    ),

    agg_categories_by_user as
    (
      select country_iso, user_email, category_name, count(*) as cnt_categories
      from categories_by_user
      group by 1, 2, 3
    ),

    ranked_categories as
    (
      select country_iso, user_email, category_name, cnt_categories, ROW_NUMBER() OVER ( PARTITION BY country_iso, user_email ORDER BY cnt_categories desc) AS rank
      from agg_categories_by_user
    ),

    ranked_products as
    (
    select country_iso, user_email, product_name, sum_quantity, ROW_NUMBER() OVER ( PARTITION BY country_iso, user_email ORDER BY sum_quantity desc) AS rank
    from agg_products_by_user
    ),

    top_1_category as
    (
      select country_iso, user_email, category_name
      from ranked_categories
      where rank=1
    ),

    top_2_category as
    (
      select country_iso, user_email, category_name
      from ranked_categories
      where rank=2
    ),

    top_1_products as
    (
    select country_iso, user_email, product_name
    from ranked_products
    where rank=1
    ),

    top_2_products as
    (
    select country_iso, user_email, product_name
    from ranked_products
    where rank=2
    ),

    top_3_products as
    (
    select country_iso, user_email, product_name
    from ranked_products
    where rank=3
    ),

    order_day as
    (
    select country_iso,
    user_email,
    extract(DAYOFWEEK from created) as day_of_week,
    count(*) as day_count
    from `flink-backend.saleor_db_global.order_order`
    group by 1, 2, 3
    ),

    order_hour as
    (
    select country_iso,
    user_email,
    extract(HOUR from created) as hour,
    count(*) as hour_count
    from `flink-backend.saleor_db_global.order_order`
    group by 1, 2, 3
    ),

    favourite_day as
    (
    select country_iso,
    user_email,
    day_of_week,
    ROW_NUMBER() OVER ( PARTITION BY country_iso, user_email ORDER BY day_count desc) AS rank
    from order_day
    ),

    favourite_time as
    (
    select country_iso, user_email,
    hour,
    ROW_NUMBER() OVER ( PARTITION BY country_iso, user_email ORDER BY hour_count desc) AS rank
    from order_hour
    ),

    latest_order_with_voucher as
    (
      select orders.country_iso,
      orders.user_email,
      MAX(orders.created) as latest_order_with_voucher
      from `flink-backend.saleor_db_global.order_order` orders
      where orders.voucher_id is not null
      group by 1, 2
    )

    select
    users.country_iso,
    users.user_email,
    users.lifetime_orders,
    users.lifetime_revenue_gross,
    users.lifetime_revenue_net,
    users.first_order_id,
    users.latest_order_id,
    users.first_order,
    users.latest_order,
    users.number_of_distinct_months_with_orders,
    top_1_products.product_name as top_1_product,
    top_2_products.product_name as top_2_product,
    top_3_products.product_name as top_3_product,
    top_1_category.category_name as top_1_category,
    top_2_category.category_name as top_2_category,
    case when day_of_week in (7, 1) then 'weekend' else 'week' end as favourite_order_day,
    case when hour > 0 and hour <= 12 then 'morning'
      when hour > 12 and hour <= 17 then 'afternoon'
        when hour > 17 and hour <= 20 then 'evening'
          when hour > 20 then 'night' end as favourite_order_hour,
    latest_order_with_voucher.latest_order_with_voucher as last_order_with_voucher
    from users
    left join top_1_products
    on users.country_iso=top_1_products.country_iso and users.user_email=top_1_products.user_email
    left join top_2_products
    on users.country_iso=top_2_products.country_iso and users.user_email=top_2_products.user_email
    left join top_3_products
    on users.country_iso=top_3_products.country_iso and users.user_email=top_3_products.user_email
    left join top_1_category
    on users.country_iso=top_1_category.country_iso and users.user_email=top_1_category.user_email
    left join top_2_category
    on users.country_iso=top_2_category.country_iso and users.user_email=top_2_category.user_email
    left join favourite_day
    on users.country_iso=favourite_day.country_iso and users.user_email=favourite_day.user_email
    left join favourite_time
    on users.country_iso=favourite_time.country_iso and users.user_email=favourite_time.user_email
    left join latest_order_with_voucher
    on users.country_iso=latest_order_with_voucher.country_iso and users.user_email=latest_order_with_voucher.user_email
    where favourite_day.rank = 1
    and favourite_time.rank = 1
    order by 2 desc
 ;;
  }

  dimension: first_order_id {
    label: "First Order ID"
    type: number
    sql: ${TABLE}.first_order_id ;;
  }

  dimension: latest_order_id {
    label: "Latest Order ID"
    type: number
    sql: ${TABLE}.latest_order_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: user_email {
    primary_key: no
    hidden: no
    type: number
    sql: ${TABLE}.user_email ;;
  }

  dimension: unique_id {
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${user_email}) ;;
  }

  dimension_group: first_order {
    type: time
    # datatype: timestamp
    sql: ${TABLE}.first_order ;;
  }

  dimension: is_first_order {
    type: yesno
    sql: ${first_order_date} IS NOT NULL ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  dimension: number_of_distinct_weeks_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_weeks_with_orders ;;
  }

  dimension: days_betw_first_and_last_order {
    description: "Days between first and latest order"
    type: number
    sql: TIMESTAMP_DIFF(${TABLE}.latest_order, ${TABLE}.first_order, DAY)+1 ;;
  }

  dimension: days_as_customer_tiered {
    type: tier
    tiers: [0, 1, 7, 14, 21, 28, 30, 60, 90, 120]
    sql: ${days_betw_first_and_last_order} ;;
    style: integer
  }

  ##### Lifetime Behavior - Order Counts ######

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: repeat_customer {
    description: "Lifetime Count of Orders > 1"
    type: yesno
    sql: ${lifetime_orders} > 1 ;;
  }

  dimension: lifetime_orders_tier {
    type: tier
    tiers: [0, 1, 2, 3, 5, 10]
    sql: ${lifetime_orders} ;;
    style: integer
  }

  ##### Lifetime Behavior - Revenue ######

  dimension: lifetime_revenue_gross {
    type: number
    sql: ${TABLE}.lifetime_revenue_gross ;;
  }

  dimension: lifetime_revenue_net {
    type: number
    sql: ${TABLE}.lifetime_revenue_net ;;
  }


  dimension: lifetime_revenue_tier {
    type: tier
    tiers: [0, 25, 50, 100, 200, 500, 1000]
    sql: ${lifetime_revenue_gross} ;;
    style: integer
  }


  ##### Lifetime Behaviour - Favourite products & categories ######

  dimension: top_1_product {
    type: string
    sql: ${TABLE}.top_1_product ;;
  }

  dimension: top_2_product {
    type: string
    sql: ${TABLE}.top_2_product ;;
  }

  dimension: top_3_product {
    type: string
    sql: ${TABLE}.top_3_product ;;
  }

  dimension: top_1_category {
    type: string
    sql: ${TABLE}.top_1_category ;;
  }

  dimension: top_2_category {
    type: string
    sql: ${TABLE}.top_2_category ;;
  }

  ###### Lifetime Behaviour - Favourite delivery times ######

  dimension: favourite_order_day {
    type: string
    sql: ${TABLE}.favourite_order_day ;;
  }

  dimension: favourite_order_hour {
    type: string
    sql: ${TABLE}.favourite_order_hour ;;
  }

  ###### Lifetime Behaviour - Last order with voucher

  dimension: last_order_with_voucher {
    type: date
    sql: ${TABLE}.last_order_with_voucher ;;
  }

####### Measures ########


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: new_customer_orders {
    type: count
    filters: [lifetime_orders: "=1"]
  }

  measure: returning_customer_orders {
    type: count
    filters: [lifetime_orders: ">1"]
  }

  measure: average_lifetime_orders {
    type: average
    value_format_name: decimal_2
    sql: ${lifetime_orders} ;;
  }

  measure: average_lifetime_revenue {
    type: average
    value_format_name: eur
    sql: ${lifetime_revenue_gross} ;;
  }


  set: detail {
    fields: [
      user_email,
      lifetime_orders,
      lifetime_revenue_gross,
      lifetime_revenue_net,
      first_order_id,
      first_order_time,
      latest_order_time,
      number_of_distinct_months_with_orders
    ]
  }
}
