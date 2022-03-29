view: gorillas_pricing_hist {
  sql_table_name: `flink-data-prod.curated.gorillas_pricing_hist`
    ;;

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: is_price_decrease {
    type: yesno
    sql: ${TABLE}.is_price_decrease ;;
  }

  dimension: is_price_increase {
    type: yesno
    sql: ${TABLE}.is_price_increase ;;
  }

  dimension_group: latest_timestamp {
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
    sql: ${TABLE}.latest_timestamp ;;
  }

  dimension: pct_price_change {
    type: number
    sql: ${TABLE}.pct_price_change ;;
  }

  dimension: previous_price_gross {
    type: number
    sql: ${TABLE}.previous_price_gross ;;
  }

  dimension: price_change {
    type: number
    sql: ${TABLE}.price_change ;;
  }

  dimension: price_gross {
    type: number
    sql: ${TABLE}.price_gross ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: scrape {
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
    sql: ${TABLE}.scrape_date ;;
  }

  dimension: strikethrough_price {
    type: number
    sql: ${TABLE}.strikethrough_price ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
