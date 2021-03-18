view: products_mba {

  derived_table: {
    sql:
      with order_ranks as
      (
              SELECT
                        order_order.id,
                        row_number() over (partition by user_email order by order_order.id) as user_order_rank
                      FROM `flink-backend.saleor_db.order_order` order_order
                      where order_order.status IN ('fulfilled', 'partially fulfilled')
      ),

      top_product as
      (
              select
              product_name as products_names,
              'product' as type,
              case
              when
                      (b.total_gross_amount + b.discount_amount) < 10 then 'Less than 10'
              when
                      (b.total_gross_amount + b.discount_amount) >= 10 and
                      (b.total_gross_amount + b.discount_amount) < 20 then 'Between 10 and 20'
              when
                      (b.total_gross_amount + b.discount_amount) >= 20 and
                      (b.total_gross_amount + b.discount_amount) < 30 then 'Between 20 and 30'
              else 'More than 30' end as AOV_cat,
              CASE WHEN JSON_EXTRACT_SCALAR(b.metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
                      WHEN JSON_EXTRACT_SCALAR(b.metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
                      ELSE JSON_EXTRACT_SCALAR(b.metadata, '$.warehouse') end as warehouse,
                      user_order_rank,
              --avg(b.total_net_amount + b.discount_amount) as avg_AOV,
              count(distinct(order_id)) as cnt_orders
              from `flink-backend.saleor_db.order_orderline` a
              left join `flink-backend.saleor_db.order_order` b
              on a.order_id = b.id
              left join order_ranks
              on a.order_id=order_ranks.id
              where b.status in ('fulfilled', 'partially fulfilled')
              --and b.user_email not LIKE '%goflink%' OR b.user_email not LIKE '%pickery%'
              --OR LOWER(b.user_email) not IN
              --('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
              --'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com',
              --'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')

              group by 1, 2, 3, 4, 5
              order by 4 desc
      ),

      top_pair_bundles as
      (
      select
              product_1 || '//' || product_2 as products_names,
              'pair_bundle' as type,
              AOV_cat,
              warehouse,
              user_order_rank,
              --avg(AOV) as avg_AOV,
              count(distinct(tempo.order_id)) as cnt_orders
              from
              (
                      select
                      a.order_id,
                      user_order_rank,
                      a.product_name as product_1,
                      b.product_name as product_2,
                      case
                              when
                                      (c.total_gross_amount + c.discount_amount) < 10 then 'Less than 10'
                              when
                                      (c.total_gross_amount + c.discount_amount) >= 10 and
                                      (c.total_gross_amount + c.discount_amount) < 20 then 'Between 10 and 20'
                              when
                                      (c.total_gross_amount + c.discount_amount) >= 20 and
                                      (c.total_gross_amount + c.discount_amount) < 30 then 'Between 20 and 30'
                              else 'More than 30' end as AOV_cat,
                      --(c.total_net_amount + c.discount_amount) as AOV,
                      CASE WHEN JSON_EXTRACT_SCALAR(c.metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
                      WHEN JSON_EXTRACT_SCALAR(c.metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
                      ELSE JSON_EXTRACT_SCALAR(c.metadata, '$.warehouse') end as warehouse
                      from `flink-backend.saleor_db.order_orderline` a,
                      `flink-backend.saleor_db.order_orderline` b
                      left join `flink-backend.saleor_db.order_order` c
                      on a.order_id = c.id
                      left join order_ranks
                      on a.order_id=order_ranks.id
                      where
                      a.order_id=b.order_id and
                      a.product_sku != b.product_sku and
                      a.product_sku < b.product_sku and
                      c.status in ('fulfilled', 'partially fulfilled')
                      --and c.user_email not LIKE '%goflink%' OR c.user_email not LIKE '%pickery%'
                      --OR LOWER(c.user_email) not IN
                      --('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
                      --'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com',
                      --'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')

              ) tempo
              group by 1, 2, 3, 4, 5
              order by 3 desc
      ),

      top_triplet_bundles as
      (
              select product_1 || '//' || product_2 || '//' || product_3 as products_names,
              'triplet_bundle' as type,
              AOV_cat,
              warehouse,
              user_order_rank,
              --avg(AOV) as avg_AOV,
              count(distinct(tempo.order_id)) as cnt_orders
              from
              (
                      select
                      a.order_id,
                      user_order_rank,
                      a.product_name as product_1,
                      b.product_name as product_2,
                      c.product_name as product_3,
                      case
                              when
                                      (d.total_gross_amount + d.discount_amount) < 10 then 'Less than 10'
                              when
                                      (d.total_gross_amount + d.discount_amount) >= 10 and
                                      (d.total_gross_amount + d.discount_amount) < 20 then 'Between 10 and 20'
                              when
                                      (d.total_gross_amount + d.discount_amount) >= 20 and
                                      (d.total_gross_amount + d.discount_amount) < 30 then 'Between 20 and 30'
                              else 'More than 30' end as AOV_cat,
                      --(d.total_net_amount + d.discount_amount) as AOV,
                      CASE WHEN JSON_EXTRACT_SCALAR(d.metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
                      WHEN JSON_EXTRACT_SCALAR(d.metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
                      ELSE JSON_EXTRACT_SCALAR(d.metadata, '$.warehouse') end as warehouse
                      from `flink-backend.saleor_db.order_orderline` a,
                      `flink-backend.saleor_db.order_orderline` b,
                      `flink-backend.saleor_db.order_orderline` c
                      left join `flink-backend.saleor_db.order_order` d
                      on a.order_id = d.id
                      left join order_ranks
                      on a.order_id=order_ranks.id
                      where
                      a.order_id = b.order_id and
                      a.order_id = c.order_id and
                      a.product_sku != b.product_sku and
                      a.product_sku != c.product_sku and
                      b.product_sku != c.product_sku and
                      a.product_sku < b.product_sku and
                      a.product_sku < c.product_sku and
                      b.product_sku < c.product_sku and
                      d.status in ('fulfilled', 'partially fulfilled')
                      --and d.user_email not LIKE '%goflink%' OR d.user_email not LIKE '%pickery%'
                      --OR LOWER(d.user_email) not IN
                      --('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
                      --'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com',
                      --'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')

              ) tempo
              group by 1, 2, 3, 4, 5
              order by 3 desc
      )

      select * from top_product
      union all
      select * from top_pair_bundles
      union all
      select * from top_triplet_bundles
      ;;

  }

  dimension: product_names {
    type: string
    sql: ${TABLE}.products_names ;;
  }

  dimension: bundle_size {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: aov_cat {
    type: string
    sql: ${TABLE}.AOV_cat ;;
  }

  dimension: warehouse {
    type: string
    sql: ${TABLE}.warehouse ;;
  }

  dimension: order_rank {
    type: number
    sql: ${TABLE}.user_order_rank ;;
  }

  #dimension: aov {
  #  type: number
  #  sql: ${TABLE}.avg_AOV ;;
  #}

  dimension: cnt_orders {
    type: number
    sql: ${TABLE}.cnt_orders ;;
  }

  ########## Measures ########

  #measure: avg_aov {
  #  type: average
  #  value_format_name: decimal_2
  #  sql: ${aov} ;;
  #}

  measure: sum_orders {
    type: sum
    value_format_name: decimal_2
    sql: ${cnt_orders} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      product_names,
      bundle_size,
      aov_cat,
      warehouse,
      cnt_orders
    ]
  }

}
