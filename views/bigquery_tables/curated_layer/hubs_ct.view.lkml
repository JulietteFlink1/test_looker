view: hubs_ct {
  sql_table_name: `flink-data-prod.curated.hubs_ct`
    ;;

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_manager {
    type: string
    sql: ${TABLE}.city_manager ;;
  }

  dimension: city_tier {
    type: string
    sql: ${TABLE}.city_tier ;;
  }

  dimension: cluster {
    type: string
    sql: ${TABLE}.cluster ;;
  }

  dimension: cost_center {
    type: string
    sql: ${TABLE}.cost_center ;;
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

  dimension: distribution_channel_id {
    type: string
    sql: ${TABLE}.distribution_channel_id ;;
  }

  dimension: email_list {
    type: string
    sql: ${TABLE}.email_list ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
    primary_key: yes
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: languages {
    type: string
    sql: ${TABLE}.languages ;;
  }

  dimension_group: last_modified {
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
    sql: ${TABLE}.last_modified_at ;;
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

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: region_iso {
    type: string
    sql: ${TABLE}.region_iso ;;
  }

  dimension: regional_cluster {
    type: string
    sql: ${TABLE}.regional_cluster ;;
  }

  dimension: start_date {
    type: date
    sql: CAST(${TABLE}.start_date AS TIMESTAMP);;
  }

  dimension: supply_channel_id {
    type: string
    sql: ${TABLE}.supply_channel_id ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
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

  measure: count {
    type: count
    drill_fields: [hub_name]
  }
}
