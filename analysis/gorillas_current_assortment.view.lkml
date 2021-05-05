view: gorillas_current_assortment {
  derived_table: {
    sql: with gorillas_items as (
          SELECT
          gorillas.time_scraped,
          gorillas.hub_code,
          gorillas.sku,
          gorillas.id,
          gorillas.price,
          gorillas.label,
          gorillas.category,
          row_number() over (partition by hub_code, id order by time_scraped desc) as scrape_rank
          FROM `flink-data-dev.competitive_intelligence.gorillas_items` gorillas
          WHERE DATE(time_scraped) = DATE( date_sub(current_timestamp(), INTERVAL 1 DAY))
      )
      select * from gorillas_items where scrape_rank=1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: unique_id {
    group_label: "* IDs *"
    primary_key: yes
    type: string
    sql: concat(${id}, ${hub_code},${time_scraped_date}) ;;
  }

  dimension_group: time_scraped {
    label: "Scrape Date"
    type: time
    sql: ${TABLE}.time_scraped ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: scrape_rank {
    type: number
    sql: ${TABLE}.scrape_rank ;;
  }

  set: detail {
    fields: [
      time_scraped_time,
      hub_code,
      sku,
      id,
      price,
      label,
      category,
      scrape_rank
    ]
  }
}
