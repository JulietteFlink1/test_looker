view: gorillas_turfs {
  derived_table: {
    sql: with gorillas_turfs as (
          SELECT
          turfs.id,
          turfs.gorillas_store_ids,
          turfs.label,
          turfs.points,
          turfs.time_scraped,
          row_number() over (partition by id order by time_scraped desc) as scrape_rank
          FROM `flink-data-dev.competitive_intelligence.gorillas_turfs` turfs
          WHERE DATE(time_scraped) = DATE( date_sub(current_timestamp(), INTERVAL 1 DAY))
      )
      select * from gorillas_turfs where scrape_rank=1
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: unique_id {
    group_label: "* IDs *"
    primary_key: yes
    type: string
    sql: concat(${id},${time_scraped_date}) ;;
  }

  dimension: gorillas_store_ids {
    type: string
    sql: ${TABLE}.gorillas_store_ids ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: points {
    type: string
    sql: ${TABLE}.points ;;
  }

  dimension_group: time_scraped {
    type: time
    sql: ${TABLE}.time_scraped ;;
  }

  dimension: scrape_rank {
    type: number
    sql: ${TABLE}.scrape_rank ;;
  }

  set: detail {
    fields: [
      id,
      gorillas_store_ids,
      label,
      points,
      time_scraped_time,
      scrape_rank
    ]
  }
}
