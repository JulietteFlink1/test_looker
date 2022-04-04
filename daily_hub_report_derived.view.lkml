view: daily_hub_report_derived {
  derived_table: {
    sql: SELECT
          (daily_hub_performance_v2.order_date ) AS daily_hub_performance_v2_order_date,
          hubs.country  AS hubs_country,
          hubs.city  AS hubs_city,
          hubs.hub_name  AS hubs_hub_name,
              COALESCE(SUM(daily_hub_performance_v2.fulfillment_time_minutes ), 0) / nullif(COALESCE(SUM(daily_hub_performance_v2.number_of_orders), 0), 0) AS daily_hub_performance_v2_avg_fulfillment_time_minutes
      FROM `flink-data-dev.sandbox_nazrin.daily_hub_performance_v2` AS daily_hub_performance_v2
      LEFT JOIN `flink-data-prod.curated.hubs`
           AS hubs ON lower(daily_hub_performance_v2.hub_code) = lower(hubs.hub_code)
      GROUP BY
          1,
          2,
          3,
          4
      ORDER BY
          1 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: daily_hub_performance_v2_order_date {
    type: date
    datatype: date
    sql: ${TABLE}.daily_hub_performance_v2_order_date ;;
  }

  dimension: hubs_country {
    type: string
    sql: ${TABLE}.hubs_country ;;
  }

  dimension: hubs_city {
    type: string
    sql: ${TABLE}.hubs_city ;;
  }

  dimension: hubs_hub_name {
    type: string
    sql: ${TABLE}.hubs_hub_name ;;
  }

  dimension: daily_hub_performance_v2_avg_fulfillment_time_minutes {
    type: number
    sql: ${TABLE}.daily_hub_performance_v2_avg_fulfillment_time_minutes ;;
  }

  set: detail {
    fields: [daily_hub_performance_v2_order_date, hubs_country, hubs_city, hubs_hub_name, daily_hub_performance_v2_avg_fulfillment_time_minutes]
  }
}
