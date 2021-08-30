view: gorillas_orders {
  sql_table_name: `flink-data-dev.reporting.gorillas_orders`
    ;;

  dimension: gorillas_orders_uuid {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: hub_label {
    type: string
    sql: ${TABLE}.hub_label ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: number_of_orders {
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: number_of_orders_wow {
    type: number
    sql: ${TABLE}.number_of_orders_wow ;;
  }

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
  }

  dimension_group: order_date_wow {
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
    sql: ${TABLE}.order_date_wow ;;
  }

  dimension_group: time_scraped {
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
    sql: ${TABLE}.time_scraped ;;
  }

  dimension: hub_location {
    type: location
    sql_latitude:${TABLE}.latitude ;;
    sql_longitude:${TABLE}.longitude ;;
  }


  dimension: order_data_available {
    type: yesno
    sql: ${number_of_orders} is not null  ;;
    # sql: NOT(is_null(${gorillas_orders_wow.orders}) OR is_null(${gorillas_orders_wow.orders_wow})) ;;
  }

  dimension: data_for_both_days {
    type: yesno
    sql: ${number_of_orders_wow} is not null and ${number_of_orders} is not null  ;;
    # sql: NOT(is_null(${gorillas_orders_wow.orders}) OR is_null(${gorillas_orders_wow.orders_wow})) ;;
  }

  measure: count {
    type: count
    drill_fields: [hub_name]
  }

  measure: sum_orders {
    type: sum
    sql: ${number_of_orders} ;;
  }

  measure: sum_orders_wow {
    type: sum
    sql: ${number_of_orders_wow} ;;
  }


}
