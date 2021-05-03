view: gorillas_stores {
  derived_table: {
    sql: with gorillas_stores as(
      SELECT
          stores.id, stores.label,
          split(stores.label, ' ')[offset (0)] as store_name,
          split(stores.label, ' ')[offset (2)] as store_city,
          stores.country.name as store_country,
          stores.lat as store_lat, stores.lon as store_lon,
          stores.time_scraped, row_number() over (partition by stores.id order by time_scraped desc) as gorillas_scrape_rank
      FROM `flink-data-dev.competitive_intelligence.gorillas_stores` stores)
      Select * from gorillas_stores where gorillas_scrape_rank = 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: string
    group_label: "* IDs *"
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: store_name {
    type: string
    sql: ${TABLE}.store_name ;;
  }

  dimension: store_city {
    type: string
    sql: ${TABLE}.store_city ;;
  }

  dimension: store_country {
    type: string
    sql: ${TABLE}.store_country ;;
  }

  dimension: store_location {
    type: location
    sql_latitude: ${TABLE}.store_lat ;;
    sql_longitude: ${TABLE}.store_lon;;
  }

  dimension_group: time_scraped {
    type: time
    sql: ${TABLE}.time_scraped ;;
  }

  dimension: gorillas_scrape_rank {
    type: number
    sql: ${TABLE}.gorillas_scrape_rank ;;
  }

  set: detail {
    fields: [
      id,
      label,
      store_name,
      store_city,
      store_country,
      store_location,
      time_scraped_time,
      gorillas_scrape_rank
    ]
  }
}
