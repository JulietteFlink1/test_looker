view: gorillas_orders_wow {
  derived_table: {
    sql:
    with orders_data as (
      SELECT
            o.time_scraped,
            o.orders_date,
            o2.orders_date as orders_date_wow,
            o.id as hub_id,
            o.countryIso,
            o.country,
            o.store_name as hub_name,
            o.store_city as hub_city,
            o.label as hub_label,
            o.todayOrderSequenceNumber as orders,
            o2.todayOrderSequenceNumber as orders_wow,
            o.lat as hub_lat,
            o.lon as hub_lon,
            rank() over (partition by o.id, o.orders_date order by o2.time_scraped asc) as rank
        FROM `flink-data-dev.gorillas_v1.orders` o
        left join `flink-data-dev.gorillas_v1.orders` o2
        on o2.id = o.id and o2.orders_date = DATE_SUB(o.orders_date, INTERVAL 1 WEEK)
        WHERE   {% condition orders_date %} o.orders_date {% endcondition %})
      SELECT * FROM orders_data WHERE rank = 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: time_scraped {
    type: time
    sql: ${TABLE}.time_scraped ;;
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

  dimension_group: orders_wow {
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

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.countryIso ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: hub_label {
    type: string
    sql: ${TABLE}.hub_label ;;
  }

  dimension: cnt_orders {
    type: number
    sql: ${TABLE}.orders ;;
  }

  dimension: cnt_orders_wow {
    type: number
    sql: ${TABLE}.orders_wow ;;
  }

  dimension: hub_location {
    type: location
    sql_latitude:${TABLE}.hub_lat ;;
    sql_longitude:${TABLE}.hub_lon ;;
  }

  dimension: data_for_both_days {
    type: yesno
    sql: ${cnt_orders_wow} is not null and ${cnt_orders} is not null  ;;
    # sql: NOT(is_null(${gorillas_orders_wow.orders}) OR is_null(${gorillas_orders_wow.orders_wow})) ;;
  }

  dimension: cnt_orders_available {
    type: yesno
    sql: ${cnt_orders} is not null  ;;
    # sql: NOT(is_null(${gorillas_orders_wow.orders}) OR is_null(${gorillas_orders_wow.orders_wow})) ;;
  }

  measure: sum_orders {
    type: sum
    label: "# Orders"
    sql: ${cnt_orders} ;;
  }

  measure: sum_orders_wow {
    type: sum
    label: "# Orders previous Week"
    sql: ${cnt_orders_wow} ;;
  }



  set: detail {
    fields: [
      time_scraped_time,
      orders_date,
      orders_week,
      orders_wow_date,
      orders_wow_week,
      hub_id,
      country_iso,
      country,
      hub_name,
      hub_city,
      hub_label,
      cnt_orders,
      cnt_orders_wow,
      hub_location
    ]
  }
}
