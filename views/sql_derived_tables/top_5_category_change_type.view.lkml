view: top_5_category_change_type {
  derived_table: {
    sql: with
outbounded_products_raw as(
    select
         inventory_changes_daily.inventory_change_date
        , inventory_changes_daily.hub_code
        , inventory_changes_daily.country_iso
        , products.category
        , sum(abs(inventory_changes_daily.quantity_change)) as quantity_change

    from `flink-data-prod.reporting.inventory_changes_daily` inventory_changes_daily
    left join `flink-data-prod.curated.products` products                 on products.product_sku = inventory_changes_daily.sku

    where
                    change_reason in ('product-damaged', 'product-expired', 'too-good-to-go')
    group by 1, 2, 3, 4
),

outbounded_products_ranked as (
    select
        *
        , row_number() OVER (PARTITION BY inventory_change_date, hub_code
                                ORDER BY quantity_change desc)                  as category_rank

    from outbounded_products_raw
),

positive_corrected_products_raw as(
    select
          inventory_changes_daily.inventory_change_date
        , inventory_changes_daily.hub_code
        , inventory_changes_daily.country_iso
        , products.category
        , sum(abs(inventory_changes_daily.quantity_change)) as quantity_change

    from `flink-data-prod.reporting.inventory_changes_daily` inventory_changes_daily
    left join `flink-data-prod.curated.products` products                 on products.product_sku = inventory_changes_daily.sku

    where
                inventory_correction_increased between 0 and 100 and
                change_reason     = "inventory-correction"
    group by 1, 2, 3, 4
),

 positive_corrected_products_ranked as (
   select
        *
        , row_number() OVER (PARTITION BY inventory_change_date, hub_code
                            ORDER BY quantity_change desc)                          as category_rank

                from positive_corrected_products_raw
),
 negative_corrected_products_raw as(
    select
          inventory_changes_daily.inventory_change_date
        , inventory_changes_daily.hub_code
        , inventory_changes_daily.country_iso
        , products.category
        , sum(abs(inventory_changes_daily.quantity_change)) as quantity_change

    from `flink-data-prod.reporting.inventory_changes_daily` inventory_changes_daily
    left join `flink-data-prod.curated.products` products                 on products.product_sku = inventory_changes_daily.sku

    where
                inventory_correction_reduced between -100 and 0 and
                change_reason     = "inventory-correction"
    group by 1, 2, 3, 4

),

negative_corrected_products_ranked as (
    select
        *
        , row_number() OVER (PARTITION BY inventory_change_date, hub_code
                                ORDER BY quantity_change desc)                  as category_rank
    from negative_corrected_products_raw
),

final as (

    select
        *
        , "outbound"                                                        as change_type

    from outbounded_products_ranked r

            where category_rank <= 5

    union all

    select
        *
        , "negative_corrected"  as change_type

    from  negative_corrected_products_ranked
    where category_rank <= 5

    union all

    select *
        , "positive_corrected"                                                      as change_type

    from positive_corrected_products_ranked

    where category_rank <= 5
)

select
*
from final
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: primary_key {
    type: string
    sql: concat(${TABLE}.inventory_change_date, ${TABLE}.hub_code, ${TABLE}.category)
      ;;
    primary_key: yes
    hidden: yes
  }

  dimension: inventory_change_date {
    type: date
    datatype: date
    sql: ${TABLE}.inventory_change_date ;;
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
    order_by_field: category_rank
  }

  dimension: category_rank {
    type: number
    sql: ${TABLE}.category_rank ;;
  }

  dimension: quantity_change {
    type: number
    sql: ${TABLE}.quantity_change ;;
    value_format_name: decimal_0
  }


  dimension: change_type {
    type: string
    sql: ${TABLE}.change_type ;;
  }

  measure: sum_products {
    label: "# Products"
    description: "The total number of products involved"
    type: sum
    sql: abs(${quantity_change});;
  }


  set: detail {
    fields: [
      inventory_change_date,
      hub_code,
      country_iso,
      category,
      category_rank,
      change_type
    ]
  }
}
