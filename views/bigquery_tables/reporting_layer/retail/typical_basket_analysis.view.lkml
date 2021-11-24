view: typical_basket_analysis {
  sql_table_name: `flink-data-prod.reporting.typical_basket_analysis`
    ;;

  dimension: category_a {
    type: string
    sql: ${TABLE}.category_A ;;
  }

  dimension: category_a_ordered {
    type: string
    sql: ${TABLE}.category_A ;;
    order_by_field: support
    hidden:yes
  }

  dimension: category_b {
    type: string
    sql: ${TABLE}.category_B ;;
  }

  dimension: category_c {
    type: string
    sql: ${TABLE}.category_C ;;
  }

  dimension: occurrences {
    type: number
    sql: ${TABLE}.occurrences ;;
  }

  dimension: size {
    type: number
    sql: ${TABLE}.size ;;
  }

  dimension: confidence {
    type: number
    sql: ${TABLE}.confidence ;;
  }

  dimension: granularity {
    type: string
    sql: ${TABLE}.granularity ;;
  }

  dimension: avg_orders_per_month_num {
    type: number
    hidden: yes
    sql: ${TABLE}.avg_orders_per_month ;;
  }

  dimension: avg_orders_per_month {
    type: string
    order_by_field: avg_orders_per_month_num
    sql: CASE WHEN ${avg_orders_per_month_num} = 1 then   concat('[',cast(${avg_orders_per_month_num}-1 as string),'-',cast(${avg_orders_per_month_num} as string),']')
              WHEN ${avg_orders_per_month_num} <= 10 and ${avg_orders_per_month_num}>= 1  then concat(']',cast(${avg_orders_per_month_num}-1 as string),'-',cast(${avg_orders_per_month_num} as string),']')
              WHEN ${avg_orders_per_month_num} = 11 THEN ']10,10+['
              WHEN ${avg_orders_per_month_num} is null then 'All' END ;;
  }

  dimension: int64_field_0 {
    hidden: yes
    type: number
    sql: ${TABLE}.int64_field_0 ;;
  }

  dimension: lift {
    type: number
    sql: ${TABLE}.lift ;;
  }

  dimension: support {
    type: number
    sql: ${TABLE}.support ;;
    value_format: "0.00%"
  }

  measure: measure_support {
    type: sum
    sql: ${support} ;;
    value_format: "0.00%"
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso  ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
