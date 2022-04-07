# Owner: Nazrin Guliyeva
# Created: 31-03-2022

# This view is created for onboarding task. It dimensionalize the measure

view: derived_table {
  derived_table: {
    sql: SELECT
          (daily_hub_performance_v2.order_date ) AS order_date,
          hubs.country_iso  AS hub_country_iso,
          hubs.city  AS hub_city,
          hubs.hub_name  AS hub_name,
              COALESCE(SUM(daily_hub_performance_v2.fulfillment_time_minutes ), 0) / nullif(COALESCE(SUM(daily_hub_performance_v2.number_of_orders), 0), 0) AS avg_fulfillment_time_minutes
      FROM `flink-data-prod.sandbox_nazrin.daily_hub_performance` AS daily_hub_performance_v2
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

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: order_date {
    label: "Order date"
    description: "Order date"
    hidden: yes
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: hub_country_iso {
    label: "Country ISO"
    description: "Country"
    hidden: yes
    type: string
    sql: ${TABLE}.hub_country_iso ;;
  }

  dimension: hub_city {
    label: "City"
    description: "City"
    hidden: yes
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: hub_name {
    label: "Hub name"
    description: "Hub name"
    hidden: yes
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: avg_fulfillment_time_minutes {
    label: "AVG Fulfillment time"
    description: "AVG Fulfillment time in minutes"
    hidden: yes
    type: number
    sql: ${TABLE}.avg_fulfillment_time_minutes ;;
  }

  dimension: fulfillment_tier {
    label: "AVG fullfillment time tier"
    description: "Bins for AVG fulfillment time"
    type: tier
    tiers: [10,12,14,16,18,20]
    style: relational
    sql: ${avg_fulfillment_time_minutes} ;;
  }
  }
