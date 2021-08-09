view: top_50_selling_products_custom {
  derived_table: {
    sql: WITH product_lvl_gmv AS (
          SELECT sku,
              product_name,
              o.country_iso,
              CASE WHEN product_subcategory_erp IN ('Obst', 'Gemüse','Eier') THEN product_substitute_group
                  ELSE product_name
                END as substitute_group,
              SUM(quantity*amt_unit_price_gross) AS product_gmv
      FROM `flink-data-prod.curated.orderline_ct` ol
      LEFT JOIN  `flink-data-prod.curated.orders_ct` o ON o.order_uuid = ol.order_uuid
      WHERE TRUE
      AND o.country_iso = "DE"
      GROUP BY 1,2,3,4
      ORDER BY 4 desc
      ),
      substitute_lvl_gmv AS (
        SELECT substitute_group,
             SUM(product_gmv) as gmv_substitute_group
            FROM product_lvl_gmv
            GROUP BY 1
      ),
      gmv_ranked_substitute AS(
          SELECT substitute_group,
                 RANK() OVER (ORDER BY gmv_substitute_group DESC) AS rk
          FROM substitute_lvl_gmv
      )
      SELECT sku,
            product_name,
            country_iso,
            substitute_group AS custom_substitute_group,
            rk as custom_substitute_group_rk
      FROM product_lvl_gmv
      LEFT JOIN gmv_ranked_substitute USING (substitute_group)
      WHERE rk is not null
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: sku {
    primary_key:  yes
    type: number
    sql: ${TABLE}.sku ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: custom_substitute_group {
    type: string
    sql: ${TABLE}.custom_substitute_group ;;
  }

  dimension: custom_substitute_group_rk {
    type: number
    sql: ${TABLE}.custom_substitute_group_rk ;;
  }

  set: detail {
    fields: [sku, product_name, custom_substitute_group, custom_substitute_group_rk]
  }

}
