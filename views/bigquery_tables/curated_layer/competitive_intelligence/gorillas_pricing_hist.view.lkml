view: gorillas_pricing_hist {
  sql_table_name: `flink-data-prod.curated.gorillas_pricing_hist`
    ;;

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: country_iso {
    type:  string
    sql: ${TABLE}.country_iso ;;
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

  dimension: number_of_daily_price_increases {
    type: number
    sql: ${TABLE}.number_of_daily_price_increases ;;
    description: "Number of price increases by date and country"
  }

  dimension: number_of_daily_price_decreases {
    type: number
    sql: ${TABLE}.number_of_daily_price_decreases ;;
    description: "Number of price decreases by date and country"
  }

  dimension: average_product_price {
    type: number
    sql: ${TABLE}.average_product_price ;;
    description: "Average price of this product on a daily granularity"
  }

  dimension: minimum_product_price {
    type: number
    sql: ${TABLE}.minimum_product_price ;;
    description: "Minimum price of this product on a daily granularity"
  }

  dimension: maximum_product_price {
    type: number
    sql: ${TABLE}.maximum_product_price ;;
    description: "Maximum price of this product on a daily granularity"
  }

  dimension: is_geographic_price_difference {
    type: yesno
    sql: ${TABLE}.is_geographic_price_difference ;;
    description: "Value is true if a hub-level price difference exists for this product on a given day"
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
