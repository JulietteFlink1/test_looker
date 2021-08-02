view: hub_order_facts_clean {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql:with hubs as
          (
          SELECT
                  order_order.country_iso,
                  CASE WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
                        WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
                        ELSE JSON_EXTRACT_SCALAR(metadata, '$.warehouse')
                  END AS warehouse_name
                  , MIN(created) AS first_order
                  , MAX(created) AS latest_order
                  , COUNT(DISTINCT FORMAT_TIMESTAMP('%Y%w', created)) AS number_of_distinct_weeks_with_orders
                  , COUNT(DISTINCT FORMAT_TIMESTAMP('%Y%m', created)) AS number_of_distinct_months_with_orders
                FROM `flink-data-prod.saleor_prod_global.order_order` order_order
                WHERE order_order.status IN ('fulfilled', 'partially fulfilled')
                GROUP BY country_iso, warehouse_name
          )

          select
          hubs.country_iso,
          hubs.warehouse_name,
          hubs.first_order,
          hubs.latest_order,
          hubs.number_of_distinct_weeks_with_orders,
          hubs.number_of_distinct_months_with_orders
          from hubs
       ;;
  }

  dimension: warehouse_name {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.warehouse_name ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension: is_hubs_first_order {
    type: yesno
    sql: ${first_order_date} IS NOT NULL ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  dimension: number_of_distinct_weeks_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_weeks_with_orders ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  ################## CROSS-REFERENCE

  dimension_group: time_between_hub_launch_and_order {
      group_label: "* Hub Dimensions *"
      type: duration
      sql_start: ${first_order_raw} ;;
      sql_end: ${base_orders.created_raw} ;;
    }


####### Measures ########


}
