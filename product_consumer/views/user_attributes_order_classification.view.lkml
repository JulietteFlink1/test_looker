view: user_attributes_order_classification {
  sql_table_name: `flink-data-prod.curated.user_attributes_order_classification`
    ;;

  dimension: order_classification {
    type: string
    description: "The classification given to the order"
    sql: ${TABLE}.order_classification ;;
  }

  dimension_group: order_timestamp {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_timestamp ;;
  }

  dimension: order_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.order_uuid ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
