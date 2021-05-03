view: gorillas_turfs {
  sql_table_name: `flink-data-dev.competitive_intelligence.gorillas_turfs`
    ;;
  drill_fields: [id]

  filter: filter_scrape_date {

    type: date
  }

  parameter: par_time_scraped {
    type: date
  }

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: color {
    type: string
    sql: ${TABLE}.color ;;
  }

  dimension: gorillas_store_ids {
    hidden: yes
    sql: ${TABLE}.gorillas_store_ids ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: points {
    hidden: yes
    sql: ${TABLE}.points ;;
  }

  dimension: scrape_id {
    type: string
    sql: ${TABLE}.scrape_id ;;
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

  dimension: usage_count {
    type: number
    sql: ${TABLE}.usageCount ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}

view: gorillas_turfs__points {
  dimension: empty {
    type: yesno
    sql: ${TABLE}.empty ;;
  }

  dimension: area_point {
    type: location
    sql_latitude:${TABLE}.lat ;;
    sql_longitude:${TABLE}.lon ;;
  }
}

view: gorillas_turfs__gorillas_store_ids {
  dimension: gorillas_turfs__gorillas_store_ids {
    type: string
    sql: gorillas_turfs__gorillas_store_ids ;;
  }
}
