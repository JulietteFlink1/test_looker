view: categories_mba {
  derived_table: {
    sql: with order_ranks as
          (
                  SELECT
                            order_order.id,
                            row_number() over (partition by user_email order by order_order.id) as user_order_rank
                          FROM `flink-backend.saleor_db.order_order` order_order
                          where order_order.status IN ('fulfilled', 'partially fulfilled')
          ),

          top_product as
                (
                        select category_names,
                        type,
                        AOV_cat,
                        warehouse,
                        user_order_rank,
                        total_cat_orders,
                        total_rank_orders,
                        count(distinct order_id) as cnt_orders
                        from (

                                      select category_names,
                                      type,
                                      AOV_cat,
                                      warehouse,
                                      user_order_rank,
                                      order_id,
                                      count(distinct order_id) over (partition by AOV_cat) as total_cat_orders,
                                      count(distinct order_id) over (partition by user_order_rank) as total_rank_orders
                                      from (

                                                      select
                                                      pcategory_parent.name as category_names,
                                                      'category' as type,
                                                      case
                                                      when
                                                              (b.total_gross_amount + b.discount_amount) < 10 then 'Less than 10'
                                                      when
                                                              (b.total_gross_amount + b.discount_amount) >= 10 and
                                                              (b.total_gross_amount + b.discount_amount) < 30 then 'Between 10 and 30'

                                                      else 'More than 30' end as AOV_cat,
                                                      CASE WHEN JSON_EXTRACT_SCALAR(b.metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
                                                              WHEN JSON_EXTRACT_SCALAR(b.metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
                                                              ELSE JSON_EXTRACT_SCALAR(b.metadata, '$.warehouse') end as warehouse,
                                                      user_order_rank,
                                                      order_id,
                                                      from `flink-backend.saleor_db.order_orderline` a
                                                      left join `flink-backend.saleor_db.order_order` b
                                                      on a.order_id = b.id
                                                      left join `flink-backend.saleor_db.product_productvariant` pvariant
                                                      on a.product_sku=pvariant.sku
                                                      left join `flink-backend.saleor_db.product_product` pproduct
                                                      on pvariant.id=pproduct.id
                                                      left join `flink-backend.saleor_db.product_category` pcategory
                                                      on pproduct.category_id=pcategory.id
                                                      left join `flink-backend.saleor_db.product_category` pcategory_parent
                                                      on pcategory.parent_id=pcategory_parent.id
                                                      left join order_ranks
                                                      on a.order_id=order_ranks.id
                                                      where b.status in ('fulfilled', 'partially fulfilled') and b.created > '2021-02-25'
                                                      --and b.user_email not LIKE '%goflink%' OR b.user_email not LIKE '%pickery%'
                                                      --OR LOWER(b.user_email) not IN
                                                      --('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
                                                      --'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com',
                                                      --'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')
                                      )
                                      group by 1, 2, 3, 4, 5, 6
                        )
                        group by 1, 2, 3, 4, 5, 6, 7
                ),

                top_pair_bundles as
                (

                        select category_names,
                        type,
                        AOV_cat,
                        warehouse,
                        user_order_rank,
                        total_cat_orders,
                        total_rank_orders,
                        count(distinct(order_id)) as cnt_orders
                        from
                        (
                              select
                                      category_name_1 || '//' || category_name_2 as category_names,
                                      'pair_bundle' as type,
                                      AOV_cat,
                                      warehouse,
                                      user_order_rank,
                                      order_id,
                                      count(distinct tempo.order_id) over (partition by AOV_cat) as total_cat_orders,
                                      count(distinct tempo.order_id) over (partition by user_order_rank) as total_rank_orders
                                      from
                                      (
                                              select
                                              a.order_id,
                                              user_order_rank,
                                              pcategory_parent.name as category_name_1,
                                              pcategory_parent_2.name as category_name_2,
                                              case
                                                      when
                                                              (c.total_gross_amount + c.discount_amount) < 10 then 'Less than 10'
                                                      when
                                                              (c.total_gross_amount + c.discount_amount) >= 10 and
                                                              (c.total_gross_amount + c.discount_amount) < 30 then 'Between 10 and 30'

                                                      else 'More than 30' end as AOV_cat,
                                              CASE WHEN JSON_EXTRACT_SCALAR(c.metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
                                              WHEN JSON_EXTRACT_SCALAR(c.metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
                                              ELSE JSON_EXTRACT_SCALAR(c.metadata, '$.warehouse') end as warehouse
                                              from `flink-backend.saleor_db.order_orderline` a,
                                              `flink-backend.saleor_db.order_orderline` b
                                              left join `flink-backend.saleor_db.order_order` c
                                              on a.order_id = c.id
                                              left join `flink-backend.saleor_db.product_productvariant` pvariant
                                              on a.product_sku=pvariant.sku
                                              left join `flink-backend.saleor_db.product_product` pproduct
                                              on pvariant.id=pproduct.id
                                              left join `flink-backend.saleor_db.product_category` pcategory
                                              on pproduct.category_id=pcategory.id
                                              left join `flink-backend.saleor_db.product_category` pcategory_parent
                                              on pcategory.parent_id=pcategory_parent.id
                                              left join `flink-backend.saleor_db.product_productvariant` pvariant_2
                                              on b.product_sku=pvariant_2.sku
                                              left join `flink-backend.saleor_db.product_product` pproduct_2
                                              on pvariant_2.id=pproduct_2.id
                                              left join `flink-backend.saleor_db.product_category` pcategory_2
                                              on pproduct_2.category_id=pcategory_2.id
                                              left join `flink-backend.saleor_db.product_category` pcategory_parent_2
                                              on pcategory_2.parent_id=pcategory_parent_2.id
                                              left join order_ranks
                                              on a.order_id=order_ranks.id
                                              where
                                              a.order_id=b.order_id and
                                              pcategory_parent.id != pcategory_parent_2.id and
                                              pcategory_parent.id < pcategory_parent_2.id and
                                              c.status in ('fulfilled', 'partially fulfilled') and c.created > '2021-02-25'
                                              --and c.user_email not LIKE '%goflink%' OR c.user_email not LIKE '%pickery%'
                                              --OR LOWER(c.user_email) not IN
                                              --('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
                                              --'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com',
                                              --'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')

                                      ) tempo
                                      group by 1, 2, 3, 4, 5, 6
                                      order by 3 desc
                        )
                        group by 1, 2, 3, 4, 5, 6, 7
                ),

                top_triplet_bundles as
                (
                        select category_names,
                        type,
                        AOV_cat,
                        warehouse,
                        user_order_rank,
                        total_cat_orders,
                        total_rank_orders,
                        count(distinct(order_id)) as cnt_orders
                        from (

                                      select
                                      category_name_1 || '//' || category_name_2 || '//' || category_name_3  as category_names,
                                      'triplet_bundle' as type,
                                      AOV_cat,
                                      warehouse,
                                      user_order_rank,
                                      order_id,
                                      count(distinct tempo.order_id) over (partition by AOV_cat) as total_cat_orders,
                                      count(distinct tempo.order_id) over (partition by user_order_rank) as total_rank_orders
                                      from
                                      (
                                              select
                                              a.order_id,
                                              user_order_rank,
                                              pcategory.name as category_name_1,
                                              pcategory_2.name as category_name_2,
                                              pcategory_3.name as category_name_3,
                                              case
                                                      when
                                                              (d.total_gross_amount + d.discount_amount) < 10 then 'Less than 10'
                                                      when
                                                              (d.total_gross_amount + d.discount_amount) >= 10 and
                                                              (d.total_gross_amount + d.discount_amount) < 30 then 'Between 10 and 30'

                                                      else 'More than 30' end as AOV_cat,
                                              CASE WHEN JSON_EXTRACT_SCALAR(d.metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
                                              WHEN JSON_EXTRACT_SCALAR(d.metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
                                              ELSE JSON_EXTRACT_SCALAR(d.metadata, '$.warehouse') end as warehouse
                                              from `flink-backend.saleor_db.order_orderline` a,
                                              `flink-backend.saleor_db.order_orderline` b,
                                              `flink-backend.saleor_db.order_orderline` c
                                              left join `flink-backend.saleor_db.order_order` d
                                              on a.order_id = d.id
                                              left join `flink-backend.saleor_db.product_productvariant` pvariant
                                              on a.product_sku=pvariant.sku
                                              left join `flink-backend.saleor_db.product_product` pproduct
                                              on pvariant.id=pproduct.id
                                              left join `flink-backend.saleor_db.product_category` pcategory
                                              on pproduct.category_id=pcategory.id
                                              left join `flink-backend.saleor_db.product_category` pcategory_parent
                                              on pcategory.parent_id=pcategory_parent.id
                                              left join `flink-backend.saleor_db.product_productvariant` pvariant_2
                                              on b.product_sku=pvariant_2.sku
                                              left join `flink-backend.saleor_db.product_product` pproduct_2
                                              on pvariant_2.id=pproduct_2.id
                                              left join `flink-backend.saleor_db.product_category` pcategory_2
                                              on pproduct_2.category_id=pcategory_2.id
                                              left join `flink-backend.saleor_db.product_category` pcategory_parent_2
                                              on pcategory_2.parent_id=pcategory_parent_2.id
                                              left join `flink-backend.saleor_db.product_productvariant` pvariant_3
                                              on c.product_sku=pvariant_3.sku
                                              left join `flink-backend.saleor_db.product_product` pproduct_3
                                              on pvariant_3.id=pproduct_3.id
                                              left join `flink-backend.saleor_db.product_category` pcategory_3
                                              on pproduct_3.category_id=pcategory_3.id
                                              left join `flink-backend.saleor_db.product_category` pcategory_parent_3
                                              on pcategory_3.parent_id=pcategory_parent_3.id
                                              left join order_ranks
                                              on a.order_id=order_ranks.id
                                              where
                                              a.order_id = b.order_id and
                                              a.order_id = c.order_id and
                                              pcategory_parent.id != pcategory_parent_2.id and
                                              pcategory_parent.id != pcategory_parent_3.id and
                                              pcategory_parent_2.id != pcategory_parent_3.id and
                                              pcategory_parent.id < pcategory_parent_2.id and
                                              pcategory_parent.id < pcategory_parent_3.id and
                                              pcategory_parent_2.id < pcategory_parent_3.id and
                                              d.status in ('fulfilled', 'partially fulfilled') and d.created > '2021-02-25'
                                              --and d.user_email not LIKE '%goflink%' OR d.user_email not LIKE '%pickery%'
                                              --OR LOWER(d.user_email) not IN
                                              --('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com',
                                              --'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com',
                                              --'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')

                                      ) tempo
                                      group by 1, 2, 3, 4, 5, 6
                                      order by 3 desc
                        )
                        group by 1, 2, 3, 4, 5, 6, 7
                )


              select * from top_product
              union all
              select * from top_pair_bundles
              union all
              select * from top_triplet_bundles
      ;;
  }



  dimension: category_names {
    type: string
    sql: ${TABLE}.category_names ;;
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

  dimension: cnt_orders {
    type: number
    sql: ${TABLE}.cnt_orders ;;
  }

  dimension: total_cat_orders {
    type: number
    sql: ${TABLE}.total_cat_orders ;;
  }

  dimension: total_rank_orders {
    type: number
    sql: ${TABLE}.total_rank_orders ;;
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
      category_names,
      bundle_size,
      aov_cat,
      warehouse,
      total_cat_orders,
      total_rank_orders,
      cnt_orders
    ]
  }
}
