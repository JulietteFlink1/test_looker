view: gorillas_stores {
  derived_table: {
    sql: with stores as (SELECT
          stores.id, stores.label,
          if(label like '% I %',SPLIT(label, ' I ')[OFFSET(0)], SPLIT(label, ' | ')[OFFSET(0)]) as store_name,
          if(label like '% I %',SPLIT(label, ' I ')[OFFSET(1)], SPLIT(label, ' | ')[OFFSET(1)]) as store_city,
          stores.country.name as store_country,
          stores.country.iso as country_iso,
          stores.todayOrderSequenceNumber,
          stores.lat as store_lat, stores.lon as store_lon,
          stores.time_scraped, row_number() over (partition by stores.id order by time_scraped desc) as gorillas_scrape_rank
      FROM `flink-data-dev.competitive_intelligence.gorillas_stores` stores)
      Select * from stores where gorillas_scrape_rank=1
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

   dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: today_order_sequence_number {
    type: number
    sql: ${TABLE}.todayOrderSequenceNumber ;;
  }

  dimension: store_location {
    type: location
    sql_latitude: ${TABLE}.store_lat ;;
    sql_longitude: ${TABLE}.store_lon;;
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
      year,
      hour_of_day
    ]
    sql: ${TABLE}.time_scraped ;;
  }


  dimension: gorillas_scrape_rank {
    type: number
    sql: ${TABLE}.gorillas_scrape_rank ;;
  }

  measure: count_distinct_store_id{
    type: count_distinct
    sql: ${TABLE}.id ;;
  }

  measure: orders {
    type: number
    sql:  ;;
  }

  set: detail {
    fields: [
      id,
      label,
      store_name,
      store_city,
      store_country,
      store_location,
      time_scraped_date,
      gorillas_scrape_rank,
      today_order_sequence_number
    ]
  }
}
