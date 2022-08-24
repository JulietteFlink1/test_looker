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

  dimension: is_hour_before_now_hour {
    label: "Is Hour Before Now ?"
    type: yesno
    sql: ${start_datetime_hour_of_day} < ${now_hour_of_day} ;;
  }

  dimension: is_date_before_today {
    label: "Is Date Before Today ?"
    type: yesno
    sql: ${start_datetime_date} < ${now_date} ;;
  }

  dimension_group: now {
    group_label: "* Dates and Timestamps *"
    label: "Now"
    description: "Current Date/Time"
    type: time
    timeframes: [
      raw,
      hour_of_day,
      date
    ]
    sql: current_timestamp;;
    datatype: timestamp
    hidden: yes
  }

}
