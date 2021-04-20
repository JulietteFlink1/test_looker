view: competitor_analysis {
  derived_table: {
    sql: with gorillas_skus as (
      select
      gorillas.time_scraped as gorillas_time_scraped,
      gorillas.hub_code as gorillas_hub_code,
      gorillas.id as gorillas_id,
      gorillas.price as gorillas_price,
      gorillas.label as gorillas_label,
      gorillas.category as gorillas_category,
      gorillas.barcodes as gorillas_barcodes,
      gorillas.sku as gorillas_ean,
      row_number() over (partition by hub_code, id order by time_scraped desc) as gorillas_scrape_rank
      from `flink-data-dev.competitive_intelligence.gorillas_items_v1` gorillas
      ),
      gorillas_barcodes_unnested as (
      SELECT *
      FROM gorillas_skus,
      UNNEST (gorillas_skus.gorillas_barcodes) as gorillas_single_barcode
      ),
      gorillas_one_barcode_per_row as (
      select
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
      assortment_master.category as flink_assortment_category
      FROM `flink-backend.saleor_db.product_product` product
      LEFT JOIN `flink-backend.saleor_db.product_productvariant` productvariant ON product.id=productvariant.product_id
      LEFT JOIN `flink-backend.saleor_db.product_category` product_category ON product.category_id=product_category.id
      LEFT JOIN `flink-backend.gsheet_assortment_master.Flink_Sortiment` assortment_master ON productvariant.sku=CAST(assortment_master.sku AS STRING)
      )
      select
      g.*,
      f.price_amount as flink_price,
      f.category_name as flink_category,
      f.product_id as flink_product_id,
      f.product_name as flink_product_name,
      f.flink_assortment_category as flink_assortment_category,
      f.flink_ean as flink_ean
      from gorillas g
      left join flink_assortment f on g.gorillas_ean=CAST(f.flink_ean  AS STRING)
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
