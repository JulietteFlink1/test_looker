view: picnic_categories {
  sql_table_name: `flink-data-prod.curated.picnic_categories`
    ;;

  dimension: category_id {
    type: number
    sql: ${TABLE}.category_id ;;
  }

  dimension: category_name {
    type: string
    sql: ${TABLE}.category_name ;;
    label: "{% if _view._name == 'category_l0' %} L0 Category Name
            {% elsif _view._name == 'category_l1' %} L1 Category Name
            {% elsif _view._name == 'category_l2' %} L2 Category Name
            {% else %} Category Name {% endif %}"
  }

  dimension: level {
    type: number
    sql: ${TABLE}.level ;;
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

  dimension: picnic_categories_uuid {
    type: string
    sql: ${TABLE}.picnic_categories_uuid ;;
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
    drill_fields: [category_name]
  }
}
