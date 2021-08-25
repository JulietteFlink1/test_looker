view: inventory_stock_count_hourly {
  sql_table_name: `flink-data-prod.reporting.inventory_stock_count_hourly`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    type: string
    primary_key:  yes
    sql: CONCAT(${TABLE}.country_iso,${TABLE}.hub_code,${TABLE}.sku ,CAST(${TABLE}.partition_timestamp AS STRING) ) ;;
  }

  dimension: current_quantity {
    type: number
    sql: ${TABLE}.current_quantity ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_opening_hours_day {
    type: number
    sql: ${TABLE}.hub_opening_hours_day ;;
  }

  dimension: is_hup_opening_timestamp {
    type: number
    sql: ${TABLE}.is_hup_opening_timestamp ;;
  }

  dimension: is_leading_product {
    type: string
    sql: ${TABLE}.is_leading_product ;;
  }

  dimension: is_noos_product {
    type: string
    sql: ${TABLE}.is_noos_product ;;
  }

  dimension_group: partition_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension: previous_quantity {
    type: number
    sql: ${TABLE}.previous_quantity ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: stock_inventory_uuid {
    type: string
    sql: ${TABLE}.stock_inventory_uuid ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_current_quantity {
    label: "# Quantity On Stock"
    description: "Sum of Available items on stock"
    hidden:  no
    type: sum
    sql: ${TABLE}.current_quantity;;
  }
}
