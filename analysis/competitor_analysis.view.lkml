view: competitor_analysis {
  derived_table: {
    sql: with gorillas_stores as(
      SELECT DISTINCT
      stores.countryIso AS country_iso,
      stores.id,
      stores.label,
      split(stores.label, ' ')[offset (0)] as store_name,
      split(stores.label, ' ')[offset (2)] as store_city,
      stores.country.name as store_country,
      stores.lat as store_lat,
      stores.lon as store_lon
      FROM `flink-data-dev.competitive_intelligence.gorillas_stores` stores
    ),
     gorillas_skus as (
      select
      gorillas_stores.country_iso,
      gorillas_stores.store_city,
      gorillas_stores.store_name,
      gorillas.time_scraped as gorillas_time_scraped,
      gorillas.hub_code as gorillas_hub_code,
      gorillas.id as gorillas_id,
      gorillas.price as gorillas_price,
      gorillas.label as gorillas_label,
      gorillas.category as gorillas_category,
      gorillas.barcodes as gorillas_barcodes,
      gorillas.sku as gorillas_ean,
      row_number() over (partition by hub_code, gorillas.id order by time_scraped desc) as gorillas_scrape_rank
      from `flink-data-dev.competitive_intelligence.gorillas_items_v1` gorillas
      left join gorillas_stores gorillas_stores ON gorillas.hub_code=gorillas_stores.id

      where timestamp(gorillas.time_scraped) > timestamp('2021-04-24T01:00:00.000Z')
      ),
      gorillas_barcodes_unnested as (
      SELECT *
      FROM gorillas_skus,
      UNNEST (gorillas_skus.gorillas_barcodes) as gorillas_single_barcode
      ),
      gorillas_one_barcode_per_row as (
      select
      gorillas_barcodes_unnested.country_iso,
      gorillas_barcodes_unnested.store_city,
      gorillas_barcodes_unnested.store_name,
      gorillas_barcodes_unnested.gorillas_time_scraped as gorillas_time_scraped,
      gorillas_barcodes_unnested.gorillas_hub_code as gorillas_hub_code,
      gorillas_barcodes_unnested.gorillas_id as gorillas_id,
      gorillas_barcodes_unnested.gorillas_price as gorillas_price,
      gorillas_barcodes_unnested.gorillas_label as gorillas_label,
      gorillas_barcodes_unnested.gorillas_category as gorillas_category,
      gorillas_barcodes_unnested.gorillas_scrape_rank as gorillas_scrape_rank,
      gorillas_barcodes_unnested.gorillas_single_barcode as gorillas_ean
      from gorillas_barcodes_unnested),
      gorillas as(
      select * from gorillas_one_barcode_per_row
      union all
      select
      country_iso,
      store_city,
      store_name,
      gorillas_time_scraped,
      gorillas_hub_code,
      gorillas_id,
      gorillas_price,
      gorillas_label,
      gorillas_category,
      gorillas_scrape_rank,
      gorillas_ean
      from gorillas_skus
      order by 1 desc, 2, 3
      ),
      flink_assortment as (
      SELECT
      product.country_iso,
      product_category.id AS category_id,
      product_category.name AS category_name,
      product.id AS product_id,
      product.name AS product_name,
      product.publication_date,
      product.is_published,
      product.visible_in_listings,
      product.available_for_purchase,
      productvariant.id AS productvariant_id,
      productvariant.name AS productvariant_name,
      productvariant.price_amount,
      productvariant.sku,
      assortment_master.ean_stueck,
      assortment_master.ean_stueck__nu as flink_ean,
      assortment_master.ean_versand,
      assortment_master.category as flink_assortment_category,
      sku_mapping.sku_g
      FROM `flink-backend.saleor_db_global.product_product` product
      LEFT JOIN `flink-backend.saleor_db_global.product_productvariant` productvariant ON product.id=productvariant.product_id
      LEFT JOIN `flink-backend.saleor_db_global.product_category` product_category ON product.category_id=product_category.id
      LEFT JOIN `flink-backend.gsheet_assortment_master.Flink_Sortiment` assortment_master ON productvariant.sku=CAST(assortment_master.sku AS STRING)
      LEFT JOIN `flink-backend.sandbox_nima.gsheet_flink_gorillas_sku_mapping_v2` sku_mapping ON productvariant.sku=CAST(sku_mapping.sku_f AS STRING)
      ),
      flink_sku_sales as
      (
      SELECT
      order_order.country_iso,
      order_orderline.product_sku,
      SUM(order_orderline.quantity) AS quantity_sold_30d

      FROM `flink-backend.saleor_db_global.order_order`
              AS order_order
      LEFT JOIN `flink-backend.saleor_db_global.order_orderline`
              AS order_orderline ON order_orderline.country_iso = order_order.country_iso AND order_orderline.order_id = order_order.id
      WHERE date(order_order.created) >= DATE_SUB(current_date(), INTERVAL 30 Day)
      group by 1,2
)
      select
      g.*,
      coalesce(f.price_amount, f_2.price_amount) as flink_price,
      coalesce(f.category_name, f_2.category_name) as flink_category,
      coalesce(f.product_id, f_2.product_id) as flink_product_id,
      coalesce(f.sku, f_2.sku) as flink_sku,
      coalesce(f.product_name, f_2.product_name) as flink_product_name,
      coalesce(f.flink_assortment_category, f_2.flink_assortment_category) as flink_assortment_category,
      coalesce(f.flink_ean, f_2.flink_ean) as flink_ean,
      CASE WHEN f.price_amount is not null THEN 'ean_matching' WHEN f_2.price_amount is not null THEN 'manual_matching' ELSE 'no_match' END AS match_type,
      flink_sales.quantity_sold_30d
      from gorillas g
      left join flink_assortment f on g.country_iso=f.country_iso AND g.gorillas_ean=CAST(f.flink_ean AS STRING)
      left join flink_assortment f_2 on g.country_iso=f_2.country_iso AND g.gorillas_ean=CAST(f_2.sku_g AS STRING)
      left join flink_sku_sales flink_sales on coalesce(f.country_iso, f_2.country_iso)=flink_sales.country_iso and coalesce(f.sku, f_2.sku)=flink_sales.product_sku
      where g.gorillas_scrape_rank=1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: gorillas_time_scraped {
    type: time
    sql: ${TABLE}.gorillas_time_scraped ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_key {
    type: string
    primary_key: yes
    sql: CONCAT(${TABLE}.gorillas_hub_code, ${TABLE}.gorillas_ean) ;;
  }


  dimension: match_type {
    type: string
    sql: ${TABLE}.match_type ;;
  }

  dimension: store_city {
    type: string
    sql: ${TABLE}.store_city ;;
  }

  dimension: store_name {
    type: string
    sql: ${TABLE}.store_name ;;
  }


  dimension: relative_price_diff {
    type: number
    value_format: "0.0%"
    sql: ( ${TABLE}.flink_price - ${TABLE}.gorillas_price ) / NULLIF(${TABLE}.gorillas_price, 0);;
  }

  dimension: weighted_relative_price_diff {
    type: number
    sql: ${relative_price_diff} * ${quantity_sold_30d} ;;
  }

  dimension: absolute_price_diff {
    type: number
    value_format: "0.00€"
    sql: ( ${TABLE}.flink_price - ${TABLE}.gorillas_price );;
  }

  dimension: is_relative_price_diff_over_50_pct {
    type: yesno
    sql: ${match_type} <> "manual_matching" AND ABS(${relative_price_diff}) > 0.5;;
  }

  dimension: gorillas_hub_code {
    type: string
    sql: ${TABLE}.gorillas_hub_code ;;
  }

  dimension: gorillas_id {
    type: string
    sql: ${TABLE}.gorillas_id ;;
  }

  dimension: gorillas_price {
    type: number
    sql: ${TABLE}.gorillas_price ;;
  }

  dimension: gorillas_label {
    type: string
    sql: ${TABLE}.gorillas_label ;;
  }

  dimension: gorillas_category {
    type: string
    sql: ${TABLE}.gorillas_category ;;
  }

  dimension: gorillas_scrape_rank {
    type: number
    sql: ${TABLE}.gorillas_scrape_rank ;;
  }

  dimension: gorillas_ean {
    type: string
    sql: ${TABLE}.gorillas_ean ;;
  }

  dimension: flink_price {
    type: number
    sql: ${TABLE}.flink_price ;;
  }

  dimension: flink_category {
    type: string
    sql: ${TABLE}.flink_category ;;
  }

  dimension: flink_product_id {
    type: string
    # value_format: "0"
    sql: ${TABLE}.flink_product_id ;;
  }

  dimension: flink_sku {
    type: string
    # value_format: "0"
    sql: ${TABLE}.flink_sku ;;
  }

  dimension: flink_product_name {
    type: string
    sql: ${TABLE}.flink_product_name ;;
  }

  dimension: flink_assortment_category {
    type: string
    sql: ${TABLE}.flink_assortment_category ;;
  }

  dimension: flink_ean {
    type: number
    value_format: "0"
    sql: ${TABLE}.flink_ean ;;
  }

  dimension: quantity_sold_30d {
    type: number
    value_format: "0"
    sql: ${TABLE}.quantity_sold_30d ;;
  }

  measure: avg_relative_price_diff {
    type: average
    value_format: "0.0%"
    sql: ${relative_price_diff};;
  }

  measure: sum_quantity_sold_30d {
    type: sum_distinct
    value_format: "0"
    sql_distinct_key: ${flink_sku} ;;
    sql: ${quantity_sold_30d};;

  }

  measure: weighted_avg_relative_price_diff {
    type: number
    value_format: "0.0%"
    sql: sum(${weighted_relative_price_diff}) / sum(${quantity_sold_30d});;
  }

  measure: cnt_matched_sku {
    type: count_distinct
    sql_distinct_key: ${flink_sku} ;;
    sql: ${flink_sku} ;;

  }




  set: detail {
    fields: [
      gorillas_time_scraped_time,
      gorillas_hub_code,
      gorillas_id,
      gorillas_price,
      gorillas_label,
      gorillas_category,
      gorillas_scrape_rank,
      gorillas_ean,
      flink_price,
      flink_category,
      flink_product_id,
      flink_product_name,
      flink_assortment_category,
      flink_ean
    ]
  }
}
