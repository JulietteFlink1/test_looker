view: hist_avg_items_per_category_comparison {
  sql_table_name: `flink-data-dev.competitive_intelligence.hist_avg_items_per_category_comparison`
    ;;

  dimension: unique_id {
    group_label: "* IDs *"
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${date_time_scraped_date}, ${parent_category_id}) ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: date_time_scraped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_time_scraped ;;
  }

  dimension: flink_avg_count_of_products {
    type: number
    sql: ${TABLE}.flink_avg_count_of_products ;;
  }

  dimension: gorillas_product_avg_per_hub {
    type: number
    sql: ${TABLE}.gorillas_product_avg_per_hub ;;
  }

  dimension: parent_category_id {
    type: number
    sql: ${TABLE}.parent_category_id ;;
  }

  dimension: parent_category_name {
    type: string
    sql: ${TABLE}.parent_category_name ;;
  }

  measure: count {
    type: count
    drill_fields: [parent_category_name]
  }
}
