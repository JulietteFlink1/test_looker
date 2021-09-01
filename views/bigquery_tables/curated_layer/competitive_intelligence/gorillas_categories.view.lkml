view: gorillas_categories {
  view_label: "* Gorillas Category Data *"
  sql_table_name: `flink-data-prod.curated.gorillas_categories` ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========

  dimension: gorillas_categories_uuid {
    type: string
    sql: ${TABLE}.gorillas_categories_uuid ;;
    group_label: "> IDs"
  }

  dimension: scrape_id {
    type: string
    sql: ${TABLE}.scrape_id ;;
    group_label: "> IDs"
  }

  dimension_group: time_scraped {
    type: time
    timeframes: [
      raw,
      time,
      day_of_week,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.time_scraped ;;
  }

  dimension_group: partition_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      day_of_week,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
    group_label: "> IDs"
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
    group_label: "> IDs"
  }

  dimension: parent_category_id {
    type: string
    sql: ${TABLE}.parent_category_id ;;
    group_label: "> IDs"
  }

  dimension: parent_category {
    type: string
    sql: ${TABLE}.parent_category ;;
  }

  dimension: subcategory_id {
    type: string
    sql: ${TABLE}.subcategory_id ;;
    group_label: "> IDs"
  }

  dimension: subcategory {
    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: scrape_rank {
    type: number
    sql: ${TABLE}.scrape_rank ;;
  }

}
