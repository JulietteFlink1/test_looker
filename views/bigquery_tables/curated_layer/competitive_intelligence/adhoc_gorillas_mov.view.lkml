view: adhoc_gorillas_mov {
  derived_table: {
    sql: with change_dates as (
          SELECT
              CASE
              WHEN  EXTRACT(HOUR FROM time_scraped AT TIME ZONE "Europe/Berlin") < 5
                  Then DATE_SUB(EXTRACT(DATE FROM time_scraped AT TIME ZONE "Europe/Berlin"), INTERVAL 1 DAY)
              ELSE EXTRACT(DATE FROM time_scraped AT TIME ZONE "Europe/Berlin")
          End as date_scraped,
              hub_id,
              minimum_order_value,
              Lag(minimum_order_value, 1) OVER(ORDER BY hub_id, time_scraped ASC) as previous_minimum_order_value,
              minimum_order_value != Lag(minimum_order_value, 1) OVER(ORDER BY hub_id, time_scraped ASC) AS Change
          FROM `flink-data-prod.curated.gorillas_hubs_hist`
          order by 2,1 asc
          )
      Select c.* except (change)
      from change_dates c
      order by date_scraped asc
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date_scraped {
    type: date
    datatype: date
    sql: ${TABLE}.date_scraped ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  measure: minimum_order_value {
    type: number
    sql: ${TABLE}.minimum_order_value ;;
  }

  measure: previous_minimum_order_value {
    type: number
    sql: ${TABLE}.previous_minimum_order_value ;;
  }

  dimension: active_hubs_uuid {
    type: string
    sql: ${TABLE}.active_hubs_uuid ;;
  }

  dimension: provider {
    type: string
    sql: ${TABLE}.provider ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: region_iso {
    type: string
    sql: ${TABLE}.region_iso ;;
  }

  dimension: city_name {
    type: string
    sql: ${TABLE}.city_name ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${TABLE}.latitude ;;
    sql_longitude: ${TABLE}.longitude ;;
  }

  set: detail {
    fields: [
      date_scraped,
      hub_id,
      minimum_order_value,
      previous_minimum_order_value,
      active_hubs_uuid,
      provider,
      longitude,
      latitude,
      hub_name,
      country,
      country_iso,
      region,
      region_iso,
      city_name,
      location
    ]
  }
}
