view: stg_out_of_stock_weights {
  sql_table_name: `flink-data-staging.reporting.stg_out_of_stock_weights`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: day_of_week {
    type: number
    sql: ${TABLE}.day_of_week ;;
  }

  dimension: hour_of_day {
    type: number
    sql: ${TABLE}.hour_of_day ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  # =========  Dates   =========
  dimension_group: order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
    group_label: "> Dates & Timestamps"
    hidden: yes
  }

  dimension_group: order_timestamp {
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
    sql: ${TABLE}.order_timestamp ;;
    group_label: "> Dates & Timestamps"
  }


  # =========  IDs   =========
  dimension: table_uuid {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

  # =========  hidden   =========
  dimension: items_sold {
    type: number
    sql: ${TABLE}.items_sold ;;
    group_label: "> Helper Metrics | Pre-Calculations"
    hidden: yes
  }

  dimension: items_sold_per_day_of_week_last_2w {
    type: number
    sql: ${TABLE}.items_sold_per_day_of_week_last_2w ;;
    group_label: "> Helper Metrics | Pre-Calculations"
    hidden: yes
  }

  dimension: items_sold_per_hour_of_day_last_2w {
    type: number
    sql: ${TABLE}.items_sold_per_hour_of_day_last_2w ;;
    group_label: "> Helper Metrics | Pre-Calculations"
    hidden: yes
  }

  dimension: normalized_pct_total_importance {
    type: number
    sql: ${TABLE}.normalized_pct_total_importance ;;
    group_label: "> Helper Metrics | Pre-Calculations"
    hidden: yes
  }

  dimension: pct_importance_day_of_week {
    type: number
    sql: ${TABLE}.pct_importance_day_of_week ;;
    group_label: "> Helper Metrics | Pre-Calculations"
    hidden: yes
  }

  dimension: pct_importance_hour_of_day {
    type: number
    sql: ${TABLE}.pct_importance_hour_of_day ;;
    group_label: "> Helper Metrics | Pre-Calculations"
    hidden: yes
  }

  dimension: pct_total_importance {
    type: number
    sql: ${TABLE}.pct_total_importance ;;
    group_label: "> Helper Metrics | Pre-Calculations"
    hidden: yes
  }

  dimension: total_items_sold_last_2w {
    type: number
    sql: ${TABLE}.total_items_sold_last_2w ;;
    group_label: "> Helper Metrics | Pre-Calculations"
    hidden: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: sku_day_hour_importance_score {
    label: "Day-Hour Importance Score (Range between 1 - 100)"
    type: number
    sql: ${TABLE}.sku_day_hour_importance_score ;;
  }

  measure: avg_sku_day_hour_importance_score {
    label: "AVG Day-Hour Importance Score (Range between 1 - 100)"
    type: average
    sql: ${sku_day_hour_importance_score} ;;
    value_format_name: decimal_1
  }

}
