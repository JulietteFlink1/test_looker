view: basket_composition_sku_date {
    derived_table: {
      sql: with cross_sku_categ as
        (

        SELECT
        cast(a.order_timestamp as date) order_date,
        a.country_iso,
        hub.country,
        COALESCE(prod_a.substitute_group, prod_a.product_name) AS product_substitute_group,
        prod_b.category,
        count (distinct a.order_uuid) as orders,
        sum (b.amt_total_price_gross) as sum_item_value,
        sum (b.quantity) as sum_quantity

        FROM `flink-data-prod.curated.order_lineitems` a
        left join `flink-data-prod.curated.order_lineitems` b
        on a.order_uuid = b.order_uuid
        left join `flink-data-prod.curated.products` prod_a
        on a.sku = prod_a.product_sku
        left join `flink-data-prod.curated.products` prod_b
        on b.sku = prod_b.product_sku
        left join `flink-data-prod.curated.hubs` hub
        on a.country_iso = hub.country_iso
        WHERE DATE(a.partition_timestamp) >= "2021-07-01"
        and DATE(b.partition_timestamp) >= "2021-07-01"
        and COALESCE(prod_a.substitute_group, prod_a.product_name) <> COALESCE(prod_b.substitute_group, prod_b.product_name)
        and a.country_iso = "DE"
        group by 1,2,3,4,5
        ),


        f2 as
        (

        SELECT
        cast(a.order_timestamp as date) AS order_date,
        a.country_iso,
        COALESCE(b.substitute_group, b.product_name) as product_substitute_group,
        count(distinct order_uuid) as orders

        FROM `flink-data-prod.curated.order_lineitems` a
        LEFT JOIN `flink-data-prod.curated.products` b
           on a.sku= b.product_sku
        WHERE DATE(a.partition_timestamp) >= "2021-07-01"

        group by 1,2,3
        order by 4 desc

        )


        select

        cross_sku_categ.order_date,
        cross_sku_categ.country as country_iso,
        cross_sku_categ.product_substitute_group,
        cross_sku_categ.category,
        cross_sku_categ.orders as sum_orders_category,
        cross_sku_categ.sum_item_value as sum_item_value_category,
        cross_sku_categ.sum_quantity as sum_quantity_category,
        f2.orders as sum_total_orders_product_substitute_group

        from cross_sku_categ
        left join f2
        on cross_sku_categ.order_date = f2.order_date
        and cross_sku_categ.product_substitute_group = f2.product_substitute_group
        and cross_sku_categ.country_iso = f2.country_iso
               ;;
    }



    measure: sum_orders_category {
      type: sum
      sql: ${TABLE}.sum_orders_category ;;

    }

    measure: sum_item_value_category {
      type: sum
      value_format_name: decimal_2
      sql: ${TABLE}.sum_item_value_category ;;
    }

    measure: sum_quantity_category {
      type: sum
      sql: ${TABLE}.sum_quantity_category ;;
    }

    measure: sum_total_orders_product_substitute_group {
      type: sum
      sql: ${TABLE}.sum_total_orders_product_substitute_group ;;
    }

    measure: item_value_per_order {
      type: number
      description: "Item Value per category divided by total number of orders"
      value_format_name: decimal_2
      sql: ${sum_item_value_category}/nullif(${sum_orders_category},0) ;;

    }

    measure: items_per_basket {
      type: number
      description: "Items per category in the orders they are present"
      value_format_name: decimal_2
      sql: ${sum_quantity_category}/ nullif(${sum_orders_category},0) ;;

    }

    measure: presence_in_basket {
      type: number
      #value_format: "0%"
      description: "Percentage of baskets that have an item of the category"
      value_format_name: percent_0
      sql: ${sum_orders_category}/nullif(${sum_total_orders_product_substitute_group},0) ;;

    }

    dimension: order_date {
      type: string
      sql: ${TABLE}.order_date ;;
    }

    dimension: country_iso {
      label: "country"
      type: string
      sql: ${TABLE}.country_iso ;;
    }

    dimension: category {
      type: string
      sql: ${TABLE}.category ;;
    }

    dimension: product_substitute_group {
      type: string
      sql: ${TABLE}.product_substitute_group ;;
    }


    set: detail {
      fields: [country_iso, category, product_substitute_group]
    }

    }
