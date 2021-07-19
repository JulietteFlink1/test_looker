view: hubs {
  sql_table_name: `flink-backend.gsheet_store_metadata.hubs`
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
    primary_key: yes
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

  dimension: start_date {
    type: date
    sql: CAST(${TABLE}.start_date AS TIMESTAMP);;
  }

  dimension_group: time_between_hub_launch_and_today {
    type: duration
    sql_start: timestamp(${TABLE}.start_date) ;;
    sql_end: current_timestamp ;;
  }

  dimension: hub_location {
    type: location
    sql_latitude: ${latitude};;
    sql_longitude: ${longitude};;
  }

  dimension: city_manager {
    type: string
    sql: ${TABLE}.city_manager ;;
  }


  measure: count {
    type: count
    drill_fields: [hub_name]
  }
}
