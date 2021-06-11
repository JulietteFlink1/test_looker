view: gorillas_items_hist {
  sql_table_name: `flink-data-dev.competitive_intelligence.gorillas_items_hist`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: collection {
    type: string
    sql: ${TABLE}.collection ;;
  }

  dimension_group: first_seen {
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
    sql: ${TABLE}.first_seen ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension_group: last_seen {
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
    sql: ${TABLE}.last_seen ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }


  dimension: days_since_last_seen {
    type: number
    sql: date_diff(current_date(), date(${TABLE}.last_seen),  day) ;;
  }

  dimension: days_since_first_seen {
    type: number
    sql: date_diff(current_date(), date(${TABLE}.first_seen),  day) ;;
  }

  measure: max_days_since_first_seen {
    type: number
    sql: max(${days_since_first_seen});;
  }

  measure: max_days_since_last_seen {
    type: number
    sql: max(${days_since_last_seen});;
  }

  measure: min_days_since_first_seen {
    type: number
    sql: min(${days_since_first_seen});;
  }

  measure: min_days_since_last_seen {
    type: number
    sql: min(${days_since_last_seen});;
  }



  # measure: days_since_first_seen {
  #   type: number
  #   sql:  diff_days(${first_seen_date},now());;
  # }
}
