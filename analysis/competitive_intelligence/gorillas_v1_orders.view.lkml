view: gorillas_v1_orders {
  sql_table_name: `flink-data-dev.gorillas_v1.orders`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.countryIso ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${lat} ;;
    sql_longitude: ${lon} ;;
  }

  dimension: lat {
    type: number
    sql: ${TABLE}.lat ;;
  }

  dimension: lon {
    type: number
    sql: ${TABLE}.lon ;;
  }

  dimension_group: orders {
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
    sql: ${TABLE}.orders_date ;;
  }

  dimension: store_city {
    type: string
    sql: ${TABLE}.store_city ;;
  }

  dimension: store_name {
    type: string
    sql: ${TABLE}.store_name ;;
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



  dimension: today_order_sequence_number {
    type: number
    label: "Orders"
    sql: ${TABLE}.todayOrderSequenceNumber ;;
  }






  measure: count {
    type: count
    drill_fields: [id, store_name]
  }

  measure: sum_orders {
    type: sum
    sql: ${today_order_sequence_number} ;;
  }
}
