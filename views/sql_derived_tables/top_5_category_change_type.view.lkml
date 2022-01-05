view: top_5_category_change_type {
  derived_table: {
    sql: with
outbounded_products_raw as(
    select
        inventory_change_timestamp
        , date(inventory_change_timestamp)                                as inventory_date
        , inventory_changes.hub_code
        , inventory_changes.country_iso
        , concat(product_sku, " - ", product_name)                        as product_sku_name
        , category
        , amt_product_price_gross
        , quantity_change
        , sum(abs(quantity_change)) as total_product

    from `flink-data-prod.curated.inventory_changes` inventory_changes
    left join `flink-data-prod.curated.products` products                 on products.product_sku = inventory_changes.sku

    where
                    change_reason in ('product-damaged', 'product-expired', 'too-good-to-go')       and
                    change_type             = "outbound"

    group by 1, 2, 3, 4, 5, 6, 7, 8
),

outbounded_products_ranked as (
    select
        *
        , row_number() OVER (PARTITION BY inventory_date, hub_code
                                ORDER BY total_product desc)                  as category_rank

    from outbounded_products_raw
),

positive_corrected_products_raw as(
    select
        inventory_change_timestamp
    , date(inventory_change_timestamp) as inventory_date
    , inventory_changes.hub_code
    , inventory_changes.country_iso
    , concat(product_sku, " - ", product_name)                              as product_sku_name
    , category
    , amt_product_price_gross
    , quantity_change
    , sum(abs(quantity_change)) as total_product

    from `flink-data-prod.curated.inventory_changes` inventory_changes
    left join `flink-data-prod.curated.products` products                 on products.product_sku = inventory_changes.sku

    where quantity_change > 0 and
            change_type     = "correction"
    group by 1, 2, 3, 4, 5, 6, 7, 8
),

 positive_corrected_products_ranked as (
                select
                    *
                    , row_number() OVER (PARTITION BY inventory_date, hub_code
                                        ORDER BY total_product desc)                          as category_rank

                from positive_corrected_products_raw
),
 negative_corrected_products_raw as(
    select
              inventory_change_timestamp
            ,  date(inventory_change_timestamp)                  as inventory_date
            , inventory_changes.hub_code
            , inventory_changes.country_iso
            , concat(product_sku, " - ", product_name)          as product_sku_name
            , category
            , amt_product_price_gross
            , quantity_change
            , sum(abs(quantity_change)) as total_product

    from `flink-data-prod.curated.inventory_changes` inventory_changes
    left join `flink-data-prod.curated.products` products               on products.product_sku = inventory_changes.sku

    where
            quantity_change < 0 and
            --change_reason   in    ('product-damaged', 'product-expired', 'too-good-to-go') and
            change_type     = "correction"

    group by 1, 2, 3, 4, 5, 6, 7, 8
),

negative_corrected_products_ranked as (
    select
        *
        , row_number() OVER (PARTITION BY inventory_date, hub_code
                                ORDER BY total_product desc)                  as category_rank
    from outbounded_products_raw
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
    sql: concat(${TABLE}.hub_code, '_', cast(${TABLE}.inventory_change_timestamp as string))
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

  dimension: product_sku_name {
    type: string
    sql: ${TABLE}.product_sku_name ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
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

  dimension: total_product {
    type: number
    sql: ${TABLE}.total_product ;;
  }

  dimension: price_gross {
    type: number
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  dimension: is_top_5_category {
    description: "Boolean dimension. Takes the value yes if the category is in top 5."
    type: yesno
    sql: case when category_rank <= 5 then True else False end;;
  }

  dimension: cnt_is_top_5_category {
    type: number
    sql: case when ${is_top_5_category} then 1 else 0 end;;
  }

  dimension: change_type {
    type: string
    sql: ${TABLE}.change_type ;;
  }

  measure: sum_products {
    label: "# Products"
    description: "The total number of products involved"
    type: sum
    sql: abs(${quantity_change}) ;;
  }

  measure: avg_amt_product_price_gross{
    label: "AVG Amt Product Price Gross"
    group_label: "* Price Stats *"
    type: average
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }


  measure: sum_outbound_waste_eur {
    label: "€ Outbound"
    description: "The quantity '# Outbound (Waste)' multiplied by the latest product price (gross)"
    type: sum
    sql: abs(${quantity_change}) * ${price_gross};;
    value_format_name: eur
  }



  set: detail {
    fields: [
      inventory_date,
      hub_code,
      country_iso,
      product_sku_name,
      category,
      category_rank,
      total_product,
      is_top_5_category,
      change_type
    ]
  }
}
