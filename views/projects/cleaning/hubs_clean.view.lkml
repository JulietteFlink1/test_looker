view: hubs_clean {
  sql_table_name: `flink-data-prod.google_sheets.hub_metadata`
    ;;
  view_label: "* Hubs *"

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: cluster {
    type: string
    sql: ${TABLE}.cluster ;;
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

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_code_lowercase {
    type: string
    sql: lower(${TABLE}.hub_code) ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: live {
    type: number
    sql: ${TABLE}.live ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: hub_location  {
    group_label: "* Hub Dimensions *"
    type: location
    sql_latitude: ${latitude};;
    sql_longitude: ${longitude};;
  }

  dimension: start_date {
    type: date
    sql: CAST(${TABLE}.start_date AS TIMESTAMP);;
  }

  dimension_group: time_between_hub_launch_and_today {
    type: duration
    sql_start: timestamp(${TABLE}.start_date) ;;
    sql_end: current_timestamp ;;
  }

  dimension: city_manager {
    type: string
    sql: ${TABLE}.city_manager ;;
  }

  ############### Cross Referenced Dimensions

  dimension: delivery_distance_m {
    group_label: "* Operations / Logistics *"
    type: distance
    units: meters
    start_location_field: hub_location
    end_location_field: base_orders.customer_location
  }

  dimension: delivery_distance_km {
    group_label: "* Operations / Logistics *"
    type: distance
    units: kilometers
    start_location_field: hub_location
    end_location_field: base_orders.customer_location
  }

  dimension: delivery_distance_tier {
    group_label: "* Operations / Logistics *"
    type: tier
    tiers: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0]
    style: interval
    sql: ${delivery_distance_km} ;;
  }

  dimension: is_delivery_distance_over_10km {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: IF(${delivery_distance_km} > 10, TRUE, FALSE);;
  }

  measure: avg_delivery_distance_km {
    group_label: "* Operations / Logistics *"
    label: "AVG Delivery Distance (km)"
    description: "Average distance between hub and customer dropoff (most direct path / straight line)"
    hidden:  no
    type: average
    sql: ${delivery_distance_km};;
    value_format: "0.00"
    filters: [is_delivery_distance_over_10km: "no"]
  }



  measure: count {
    type: count
    drill_fields: [hub_name]
  }
}
