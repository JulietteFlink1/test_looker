view: issue_rate {
  derived_table: {
    sql: with issues_orders as
      (
          select
          CASE WHEN JSON_EXTRACT_SCALAR(orders.metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
          WHEN JSON_EXTRACT_SCALAR(orders.metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
          ELSE JSON_EXTRACT_SCALAR(orders.metadata, '$.warehouse') end as warehouse,
          date(orders.created, 'Europe/Berlin') as date,
          count(distinct if(cs.problem_group = 'Wrong Order', order_nr__, null)) as wrong_order,
          count(distinct if(cs.problem_group = 'Wrong Product', order_nr__, null)) as wrong_product,
          count(distinct if(cs.problem_group = 'Perished Product', order_nr__, null)) as perished_product,
          count(distinct if(cs.problem_group = 'Missing Product', order_nr__, null)) as missing_product,
          count(distinct if (cs.problem_group is not null, order_nr__, null)) as orders_with_issues
          from `flink-backend.saleor_db_global.order_order` orders
          left join `flink-backend.gsheet_cs_issues.CS_issues_post_delivery` cs
          on substr(cs.hub, 1, 2) = orders.country_iso and cs.order_nr__ = orders.id
          group by 1, 2
      ),

      orders_per_hub as
      (
          select CASE WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
          WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
          ELSE JSON_EXTRACT_SCALAR(metadata, '$.warehouse') end as warehouse,
          date(created, 'Europe/Berlin') as date,
          count(distinct id) as count_orders
          from `flink-backend.saleor_db_global.order_order`
          where status in ('fulfilled', 'partially fulfilled') and
          user_email NOT LIKE '%goflink%' AND user_email NOT LIKE '%pickery%' AND LOWER(user_email) NOT IN ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com', 'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com', 'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')
          group by 1, 2
      )

      select orders_per_hub.date,
      hubs.hub_name,
      hubs.country,
      hubs.country_iso,
      hubs.city,
      wrong_order,
      wrong_product,
      perished_product,
      missing_product,
      orders_with_issues,
      orders_per_hub.count_orders
      from issues_orders
      left join orders_per_hub
      on issues_orders.warehouse = orders_per_hub.warehouse and issues_orders.date = orders_per_hub.date
      left join `flink-backend.gsheet_store_metadata.hubs` hubs
      on issues_orders.warehouse = lower(hubs.hub_code)
      order by 1 desc, 2, 3
       ;;
  }



  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension_group: date {
    label: "Order date"
    description: "Order date"
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${date};;
    datatype: date
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: wrong_order {
    type: number
    sql: ${TABLE}.wrong_order ;;
  }

  dimension: wrong_product {
    type: number
    sql: ${TABLE}.wrong_product ;;
  }

  dimension: perished_product {
    type: number
    sql: ${TABLE}.perished_product ;;
  }

  dimension: missing_product {
    type: number
    sql: ${TABLE}.missing_product ;;
  }

  dimension: orders_with_issues {
    type: number
    sql: ${TABLE}.orders_with_issues ;;
  }

  dimension: count_orders {
    type: number
    sql: ${TABLE}.count_orders ;;
  }

  ##### Measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: sum_wrong_order_issues {
    type: sum
    sql: ${wrong_order} ;;
  }

  measure: sum_wrong_product_issues {
    type: sum
    sql: ${wrong_product} ;;
  }

  measure: sum_perished_product_issues {
    type: sum
    sql: ${perished_product} ;;
  }

  measure: sum_missing_product_issues {
    type: sum
    sql: ${missing_product} ;;
  }

  measure: sum_orders_with_issues {
    type: sum
    sql: ${orders_with_issues} ;;
  }

  measure: sum_total_orders {
    type: sum
    sql: ${count_orders} ;;
  }


  set: detail {
    fields: [
      date,
      hub_name,
      country,
      country_iso,
      wrong_order,
      wrong_product,
      perished_product,
      missing_product,
      orders_with_issues,
      count_orders
    ]
  }
}
