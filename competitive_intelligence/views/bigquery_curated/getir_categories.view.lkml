view: getir_categories {
  sql_table_name: `flink-data-prod.curated.getir_categories`
    ;;

  dimension: getir_categories_uuid {
    type: string
    sql: ${TABLE}.getir_categories_uuid ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: parent_category {
    type: string
    sql: ${TABLE}.parent_category ;;
  }

  dimension: parent_category_id {
    type: string
    sql: ${TABLE}.parent_category_id ;;
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

  dimension: scrape_rank {
    type: number
    sql: ${TABLE}.scrape_rank ;;
  }

  dimension: subcategory_id {
    type: string
    sql: ${TABLE}.subcategory_id ;;
  }

  dimension: subcategory_name {
    type: string
    sql: ${TABLE}.subcategory_name ;;
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
    drill_fields: [subcategory_name]
  }
}
