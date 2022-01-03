view: top_5_category_change_type {
  derived_table: {
    sql: with product_category as(select date(inventory_change_timestamp) as inventory_date
          , ic.hub_code
          , ic.country_iso
          , category
          , count(sku) as cnt_sku
      from `flink-data-prod.curated.inventory_changes` ic
      left join `flink-data-prod.curated.products` p
      on p.product_sku = ic.sku
      where change_reason in ('product-damaged', 'product-expired', 'too-good-to-go') and change_type = "outbound"
      group by 1, 2, 3, 4
      ),


      ranked as (select *
          ,   row_number() OVER (PARTITION BY inventory_date, hub_code ORDER BY cnt_sku desc) as category_rank
          from product_category
      )
      select inventory_date
          ,  hub_code
          ,  country_iso
          , category
          , category_rank
          , cnt_sku
          , if(r.category_rank<=5, 1, 0) as is_top_5_outbound_category
          , "outbound" as change_type
      from ranked r
      where category_rank <= 5

      union all

      select *
      from (
              with product_category as(select date(inventory_change_timestamp) as inventory_date
                  , ic.hub_code
                  , ic.country_iso
                  , change_type
                  , change_reason
                  , category
                  , count(sku) as cnt_sku
              from `flink-data-prod.curated.inventory_changes` ic
              left join `flink-data-prod.curated.products` p
              on p.product_sku = ic.sku
              where quantity_change < 0 and change_reason in ('product-damaged', 'product-expired', 'too-good-to-go') and change_type = "correction"
              group by 1, 2, 3, 4, 5, 6
      ),


      ranked as (select *
          ,   row_number() OVER (PARTITION BY inventory_date, hub_code ORDER BY cnt_sku desc) as category_rank
          from product_category
      )

      select inventory_date
          ,  hub_code
          ,  country_iso
          , category
          , category_rank
          , cnt_sku
          , if(r.category_rank<=5, 1, 0) as is_top_5_outbound_category
          , "negative_corrected" as change_type
      from ranked r
      where category_rank <= 5)

      union all

      select *
      from(
              with product_category as(select date(inventory_change_timestamp) as inventory_date
                  , ic.hub_code
                  , ic.country_iso
                  , change_type
                  , change_reason
                  , category
                  , count(sku) as cnt_sku
              from `flink-data-prod.curated.inventory_changes` ic
              left join `flink-data-prod.curated.products` p
              on p.product_sku = ic.sku
              where quantity_change > 0 and change_type = "correction"
              group by 1, 2, 3, 4, 5, 6
      ),


      ranked as (select *
          ,   row_number() OVER (PARTITION BY inventory_date, hub_code ORDER BY cnt_sku desc) as category_rank
          from product_category
      )

      select inventory_date
          ,  hub_code
          ,  country_iso
          , category
          , category_rank
          , cnt_sku
          , if(r.category_rank<=5, 1, 0) as is_top_5_outbound_category
          , "positive_corrected" as change_type
      from ranked r
      where category_rank <= 5)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: uuid {
    type: string
    sql: concat(${TABLE}.hub_code, cast(${TABLE}.inventory_date as string))
      ;;
    primary_key: yes
  }

  dimension: inventory_date {
    type: date
    datatype: date
    sql: ${TABLE}.inventory_date ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: category_rank {
    type: number
    sql: ${TABLE}.category_rank ;;
  }

  dimension: cnt_sku {
    type: number
    sql: ${TABLE}.cnt_sku ;;
  }

  dimension: is_top_5_outbound_category {
    type: number
    sql: ${TABLE}.is_top_5_outbound_category ;;
  }

  dimension: change_reason {
    type: string
    sql: ${TABLE}.change_reason ;;
  }


  measure: sum_sku {
    label: "# Skus"
    description: "The total number of skus involved"
    type: sum
    sql: ${cnt_sku} ;;
  }

  set: detail {
    fields: [
      inventory_date,
      hub_code,
      country_iso,
      category,
      category_rank,
      cnt_sku,
      is_top_5_outbound_category,
      change_reason
    ]
  }
}
