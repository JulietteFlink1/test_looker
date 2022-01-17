view: gorillas_hubs_hist {
  sql_table_name: `flink-data-prod.curated.gorillas_hubs_hist`
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

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: delivery_enabled {
    type: yesno
    sql: ${TABLE}.delivery_enabled ;;
  }

  dimension: delivery_fee_multiplier {
    type: number
    sql: ${TABLE}.delivery_fee_multiplier ;;
  }

  dimension: delivery_time_interval {
    type: number
    sql: ${TABLE}.delivery_time_interval ;;
  }

  dimension: effective_delivery_pricing_type {
    type: string
    sql: ${TABLE}.effective_delivery_pricing_type ;;
  }

  dimension: gorillas_hubs_uuid {
    type: string
    sql: ${TABLE}.gorillas_hubs_uuid ;;
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

  dimension: minimum_basket_free_delivery {
    type: number
    value_format: "0.00€"
    sql: ${TABLE}.minimum_basket_free_delivery ;;
  }

  dimension: minimum_order_fee {
    type: number
    value_format: "0.00€"
    sql: ${TABLE}.minimum_order_fee ;;
  }

  dimension: minimum_order_value {
    type: number
    value_format: "0.00€"
    sql: ${TABLE}.minimum_order_value ;;
  }

  dimension: number_of_orders {
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension_group: partition_timestamp {
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
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension: pickup_enabled {
    type: yesno
    sql: ${TABLE}.pickup_enabled ;;
  }

  dimension: store_closed {
    type: yesno
    sql: ${TABLE}.store_closed ;;
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

  measure: count {
    type: count
    drill_fields: [hub_name]
  }
}
