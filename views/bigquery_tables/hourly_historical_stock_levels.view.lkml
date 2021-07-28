view: hourly_historical_stock_levels {
  sql_table_name: `flink-data-dev.sandbox.hourly_historical_stock_levels`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
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
      hour,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.tracking_datetime ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures       ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: count_purchased {
    type: sum
    sql: ${TABLE}.count_purchased ;;
    value_format_name: decimal_1
  }
  measure: count_restocked {
    type: sum
    sql: ${TABLE}.count_restocked ;;
    value_format_name: decimal_1
  }
  measure: stock_count_current_hour {
    type: sum
    sql: ${TABLE}.stock_count_current_hour ;;
    value_format_name: decimal_1
  }
  measure: stock_count_current_hour_per_substitute_group {
    type: sum
    sql: ${TABLE}.stock_count_current_hour_per_substitute_group ;;
    value_format_name: decimal_1
  }
  measure: stock_count_previous_hour {
    type: sum
    sql: ${TABLE}.stock_count_previous_hour ;;
    value_format_name: decimal_1
  }
  measure: stock_count_previous_hour_per_substitute_group {
    type: sum
    sql: ${TABLE}.stock_count_previous_hour_per_substitute_group ;;
    value_format_name: decimal_1
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Calculations       ~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Filter         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  filter: is_out_of_stock {
    type: yesno
    sql: ${TABLE}.stock_count_current_hour = 0 ;;
  }

  filter: is_restocked {
    type: yesno
    sql: ${TABLE}.count_restocked > 0 ;;
  }
  filter: hub_is_open {
    type: yesno
    sql: ${TABLE}.hub_is_open = 1 ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Hidden         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
