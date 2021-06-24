view: hourly_historical_stock_levels {
  sql_table_name: `flink-data-dev.sandbox_andreas.hourly_historical_stock_levels`
    ;;

  dimension: count_purchased {
    type: number
    sql: ${TABLE}.count_purchased ;;
  }

  dimension: count_restocked {
    type: number
    sql: ${TABLE}.count_restocked ;;
  }

  dimension: current_quantity {
    type: number
    sql: ${TABLE}.current_quantity ;;
  }

  dimension: current_quantity_per_substitute_group {
    type: number
    sql: ${TABLE}.current_quantity_per_substitute_group ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_is_open {
    type: number
    sql: ${TABLE}.hub_is_open ;;
  }

  dimension: previous_quantity {
    type: number
    sql: ${TABLE}.previous_quantity ;;
  }

  dimension: previous_quantity_per_substitute_group {
    type: number
    sql: ${TABLE}.previous_quantity_per_substitute_group ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension_group: tracking_datetime {
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
    sql: ${TABLE}.tracking_datetime ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
