view: order_sku_count {
    derived_table: {
      datagroup_trigger: flink_default_datagroup
      sql:
          SELECT
            country_iso,
            order_id,
            sum_quantity_fulfilled,
            no_distinct_skus
          FROM (
              SELECT
                  country_iso,
                  order_id,
                  SUM(quantity_fulfilled) as sum_quantity_fulfilled,
                  COUNT(DISTINCT product_sku) as no_distinct_skus
              FROM `flink-backend.saleor_db_global.order_orderline`
              GROUP BY 1,2
          )
       ;;
    }

    dimension: country_iso {
      type: string
      hidden: yes
      sql: ${TABLE}.country_iso ;;
    }

    dimension: order_id {
      type: number
      hidden: yes
      sql: ${TABLE}.order_id ;;
    }

    dimension: unique_id {
      primary_key: yes
      hidden: yes
      type: string
      sql: concat(${country_iso}, ${order_id}) ;;
    }

    dimension: sum_quantity_fulfilled {
      type: number
      label: "# Items in Order"
      description: "Quantity of Items in Order"
      hidden:  no
      sql: ${TABLE}.sum_quantity_fulfilled;;
      value_format: "0"
    }

    dimension: no_distinct_skus {
      type: number
      label: "# Distinct SKUs in Order"
      description: "# Distinct SKUs in Order"
      hidden:  no
      sql: ${TABLE}.no_distinct_skus;;
      value_format: "0"
    }


  }
