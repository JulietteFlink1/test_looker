view: comparison_current_ids_per_category {
  derived_table: {
    sql: WITH gorillas_current_assortment AS (
          SELECT distinct
              date(gorillas.time_scraped) as date_time_scraped,
              stores.countryIso as country_iso,
              gorillas.hub_code,
              stores.label,
              gorillas.category as gorillas_category_name,
              COUNT(DISTINCT gorillas.id) AS count_of_id
          FROM `flink-data-dev.competitive_intelligence.gorillas_items` gorillas
          left join `flink-data-dev.competitive_intelligence.gorillas_stores` stores on gorillas.hub_code = stores.id
          WHERE DATE(gorillas.time_scraped) > DATE_Sub(Date(current_date()), INTERVAL 2 DAY)
          group by 1,2,3,4,5
            ),
      gorillas_count_per_country_category_hub as (
          select
              g.date_time_scraped,
              g.country_iso,
              m.flink_category_id,
              g.gorillas_category_name,
              g.hub_code,
              # m.flink_category_name,
              # category,
              sum(g.count_of_id) as gorillas_product_count_per_hub
              from gorillas_current_assortment g
              left  join `flink-data-dev.competitive_intelligence.category_matching` m on m.gorillas_category_name = g.gorillas_category_name
              group by 1,2,3,4,5
      ), gorillas_avg_count_category_hub as (
          select
              date_time_scraped,
              country_iso,
              flink_category_id,
              gorillas_category_name,
              # g.hub_code,
              # m.flink_category_name,
              # category,
              avg(gorillas_product_count_per_hub) as gorillas_product_avg_per_hub
              from gorillas_count_per_country_category_hub
              group by 1,2,3,4
      ),
      flink_avg_per_country_category_hub as (
       with flink_assortment as (
          SELECT
              product_product.country_iso  AS country_iso,
              product_category_parent.id as parent_category_id,
              product_category_parent.name as parent_category_name,
              warehouse_warehouse.slug  AS warehouse_slug,
              count(distinct product_product.id) AS count_product_ids,
          FROM `flink-backend.saleor_db_global.product_product`
              AS product_product
          LEFT JOIN `flink-backend.saleor_db_global.product_productvariant`
              AS product_productvariant ON product_productvariant.country_iso = product_product.country_iso AND
                      product_productvariant.product_id = product_product.id
          LEFT JOIN `flink-backend.saleor_db_global.product_category`
              AS product_category ON product_category.country_iso = product_product.country_iso AND
                      product_category.id = product_product.category_id
          LEFT JOIN `flink-backend.saleor_db_global.warehouse_stock`
              AS warehouse_stock ON warehouse_stock.country_iso = product_productvariant.country_iso AND
                      warehouse_stock.product_variant_id = product_productvariant.id
          LEFT JOIN `flink-backend.saleor_db_global.warehouse_warehouse`
              AS warehouse_warehouse ON warehouse_warehouse.country_iso = warehouse_stock.country_iso AND
                      warehouse_warehouse.id = warehouse_stock.warehouse_id
          left join `flink-backend.saleor_db.product_category` product_category_parent
                              on product_category.parent_id=product_category_parent.id
          WHERE product_product.is_published
          and product_category.country_iso = "DE"
          GROUP BY
              1, 2, 3, 4
      )
      select
          f.country_iso,
          f.parent_category_id,
          f.parent_category_name,
          avg(f.count_product_ids) as flink_avg_count_of_products
      from flink_assortment f
      group by 1,2,3
      )
      select
          g.date_time_scraped,
          if(f.country_iso is null, g.country_iso, f.country_iso) as country_iso,
          f.parent_category_id,
          f.parent_category_name,
          if(f.flink_avg_count_of_products is null, g.gorillas_category_name, 'aggregated on parent level') as gorillas_category_name,
          avg(f.flink_avg_count_of_products) as flink_avg_count_of_products,
          sum(g.gorillas_product_avg_per_hub)  as gorillas_product_avg_per_hub,
      from flink_avg_per_country_category_hub f
      full outer join
          gorillas_avg_count_category_hub g on f.parent_category_id = g.flink_category_id and f.country_iso = g.country_iso
      group by 1,2,3,4,5
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date_time_scraped {
    type: date
    datatype: date
    sql: ${TABLE}.date_time_scraped ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: parent_category_id {
    label: "category id"
    type: number
    sql: ${TABLE}.parent_category_id ;;
  }

  dimension: parent_category_name {
    label: "category name"
    type: string
    sql: ${TABLE}.parent_category_name ;;
  }

  dimension: gorillas_category_name {
    label: "gorillas category name"
    type: string
    sql: ${TABLE}.gorillas_category_name ;;
  }

  dimension: flink_avg_count_of_products {
    label: "flink avg"
    type: number
    sql: ${TABLE}.flink_avg_count_of_products ;;
  }

  dimension: gorillas_product_avg_per_hub {
    label: "gorillas avg"
    type: number
    sql: ${TABLE}.gorillas_product_avg_per_hub ;;
  }

  set: detail {
    fields: [
      date_time_scraped,
      country_iso,
      parent_category_id,
      parent_category_name,
      gorillas_category_name,
      flink_avg_count_of_products,
      gorillas_product_avg_per_hub
    ]
  }
}
