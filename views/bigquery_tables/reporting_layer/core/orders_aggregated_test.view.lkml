view: orders_aggregated_test {
  sql_table_name: `flink-data-prod.reporting.orders_aggregated`
    ;;

  dimension: country {
    label: "Country"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city {
    label: "City"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: start_period {
    label: "Start Period"
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
    sql: ${TABLE}.start_period ;;
  }

  dimension_group: end_period{
    label: "End Period"
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
    sql: ${TABLE}.end_period ;;
  }

  dimension: orders {
    hidden: yes
    type: number
    sql: ${TABLE}.orders ;;
  }


  measure: number_of_orders {

    #Users sees description in Looker
    description: "Illustrades all orders in place."
    type: sum
    value_format_name: decimal_0
    #kategorisiert die sachen
    group_label: "Core"
    #Referring to Dimension that is hidden for aggregation purposes
    sql: ${orders} ;;
  }
}
