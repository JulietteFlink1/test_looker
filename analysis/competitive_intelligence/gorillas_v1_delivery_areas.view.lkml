view: gorillas_v1_delivery_areas {
  sql_table_name: `flink-data-dev.gorillas_v1.delivery_areas`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension_group: time_scraped {
    type: time
    description: "bq-datetime"
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

  measure: first_seen {
    type: date
    sql: MIN(${TABLE}.time_scraped) ;;
    convert_tz: no
  }

  measure: count {
    type: count
    drill_fields: [hub_name]
  }


}
