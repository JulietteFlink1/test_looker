view: time_grid {
  sql_table_name: `flink-data-prod.order_forecast.time_grid`
    ;;

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      hour_of_day,
      time_of_day,
      minute30,
      week,
      month,
      quarter,
      year
    ]
    hidden: yes
    convert_tz: yes
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension_group: end_datetime {
    type: time
    timeframes: [
      raw,
      time,
      date,
      hour_of_day,
      time_of_day,
      minute30,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    hidden: yes
    sql: ${TABLE}.end_datetime ;;
  }

  dimension_group: start_datetime {
    label: "Timeslot"
    type: time
    timeframes: [
      raw,
      time,
      date,
      hour_of_day,
      time_of_day,
      minute30,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    sql: ${TABLE}.start_datetime ;;
    hidden: no

  }
}
