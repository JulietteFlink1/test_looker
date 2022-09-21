view: recipe_skus {
  derived_table: {
    sql: /* Percentage of orders where SKU included in a recipe was bought together with a recipe SKU */
          WITH recipes AS (

                select
                    recipe.country_iso,
                    recipe.recipe_card_sku,
                    recipe.sku

                from `flink-data-prod.google_sheets.recipe_skus` recipe
            ),

            orders AS (

                select
                    recipes.country_iso,
                    recipes.recipe_card_sku,
                    recipes.sku,
                    lineitems.order_uuid

                from recipes

                left join `flink-data-prod.curated.order_lineitems` lineitems on recipes.recipe_card_sku = lineitems.sku and lineitems.country_iso = recipes.country_iso

                where true

                --and DATE(lineitems.order_timestamp) >= current_date - 120

            ),

            lineitems as (

                select
                    orders.country_iso,
                    orders.recipe_card_sku,
                    orders.sku,
                    orders.order_uuid,
                    lineitems.order_uuid as sku_order_uuid

                from orders

                left join `flink-data-prod.curated.order_lineitems` lineitems on lineitems.order_uuid = orders.order_uuid and CAST(lineitems.sku AS INT64) = orders.sku
            )

                select
                    lineitems.country_iso,
                    cast(lineitems.recipe_card_sku AS string) as recipe_card_sku,
                    products2.product_name as recipe_name,
                    cast(lineitems.sku as string) as sku,
                    products.product_name as sku_name,
                    products.category as sku_category,
                    products.subcategory as sku_subcategory,
                    count(lineitems.order_uuid) as number_of_orders_with_recipe_sku,
                    count(lineitems.sku_order_uuid) as number_of_recipe_orders_with_sku

                from lineitems
                left join `flink-data-prod.curated.products` products on products.country_iso = lineitems.country_iso and products.product_sku = CAST(lineitems.sku AS STRING)
                left join `flink-data-prod.curated.products` products2 on products2.country_iso = lineitems.country_iso and products2.product_sku = CAST(lineitems.recipe_card_sku AS STRING)

            group by 1,2,3,4,5,6,7
             ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: recipe_card_sku {
    type: string
    sql: ${TABLE}.recipe_card_sku ;;
  }

  dimension: recipe_name {
    type: string
    sql: ${TABLE}.recipe_name ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: sku_name {
    type: string
    sql: ${TABLE}.sku_name ;;
  }

  dimension: sku_category {
    type: string
    sql: ${TABLE}.sku_category ;;
  }

  dimension: sku_subcategory {
    type: string
    sql: ${TABLE}.sku_subcategory ;;
  }

  dimension: number_of_orders_with_recipe_sku {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders_with_recipe_sku ;;
  }

  dimension: number_of_recipe_orders_with_sku {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_recipe_orders_with_sku ;;
  }

  measure: sum_number_of_orders_with_recipe_sku {
    type: sum
    label: "# Orders with Recipe SKU"
    value_format: "0"
    sql:  ${number_of_orders_with_recipe_sku} ;;
  }

  measure: sum_number_of_recipe_orders_with_sku {
    type: sum
    label: "# Recipe Orders with SKU"
    value_format: "0"
    sql:  ${number_of_recipe_orders_with_sku} ;;
  }

  set: detail {
    fields: [
      country_iso,
      recipe_card_sku,
      recipe_name,
      sku,
      sku_category,
      sku_subcategory,
      number_of_orders_with_recipe_sku,
      number_of_recipe_orders_with_sku
    ]
  }
}
