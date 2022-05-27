# Owner:  Brandon Beckett
# Created: 2022-04-25

# This view contains curated layer historical pricing data for Gorillas.


view: gorillas_pricing_hist {
  sql_table_name: `flink-data-prod.curated.gorillas_pricing_hist` ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ====================     __main__     ====================

  dimension: country_iso {
    type:  string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_price_decrease {
    type: yesno
    sql: ${TABLE}.is_price_decrease ;;
    description: "Boolean value to identify if there was a price decrease today compared to the previous day"
  }

  dimension: is_price_increase {
    type: yesno
    sql: ${TABLE}.is_price_increase ;;
    description: "Boolean value to identify if there was a price increase today compared to the previous day"
  }

  dimension: pct_price_change {
    type: number
    sql: ${TABLE}.pct_price_change ;;
    description: "The percent increase of decrease of the product price change compared to the previous day"
    value_format: "0.00\%"
  }

  dimension: previous_price_gross {
    type: number
    sql: ${TABLE}.previous_price_gross ;;
    description: "The previous day's price gross"
    value_format: "€0.00"
  }

  dimension: price_change {
    type: number
    sql: ${TABLE}.price_change ;;
    description: "The amount that the product price has changed compared to the previous day"
    value_format: "€0.00"
  }

  dimension: price_gross {
    type: number
    sql: ${TABLE}.price_gross ;;
    description: "The product's gross price"
    value_format: "€0.00"
  }

  dimension: strikethrough_price {
    type: number
    sql: ${TABLE}.strikethrough_price ;;
    description: "The product price before being discounted"
    value_format: "€0.00"
  }

  dimension: number_of_daily_price_increases {
    type: number
    sql: ${TABLE}.number_of_daily_price_increases ;;
    description: "Number of price increases by date and country"
    group_label: "Precalculated Measures"
  }

  dimension: number_of_daily_price_decreases {
    type: number
    sql: ${TABLE}.number_of_daily_price_decreases ;;
    description: "Number of price decreases by date and country"
    group_label: "Precalculated Measures"
  }

  dimension: average_product_price {
    type: number
    sql: ${TABLE}.average_product_price ;;
    description: "Average price of this product on a daily granularity"
    group_label: "Precalculated Measures"
    value_format: "€0.00"
  }

  dimension: minimum_product_price {
    type: number
    sql: ${TABLE}.minimum_product_price ;;
    description: "Minimum price of this product on a daily granularity"
    value_format: "€0.00"
  }

  dimension: maximum_product_price {
    type: number
    sql: ${TABLE}.maximum_product_price ;;
    description: "Maximum price of this product on a daily granularity"
    value_format: "€0.00"
  }

  dimension: is_geographic_price_difference {
    type: yesno
    sql: ${TABLE}.is_geographic_price_difference ;;
    description: "Value is true if a hub-level price difference exists for this product on a given day"
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
    description: "The last timestamp given for the respective scrape date"
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
    description: "The date when the Gorillas data was scraped"
  }

# ====================      hidden      ====================



# ====================       IDs        ====================

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    description: "Unique table ID"
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
    description: "The Gorillas hub ID. Use this field to join Gorillas hub data."
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
    description: "The Gorillas product ID. Use this field to join Gorillas product data."
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: max_number_of_daily_price_decreases {
    type: max
    sql: ${number_of_daily_price_decreases} ;;
    description: "The maximum number of price decreases by date and country."

  }

  measure: max_number_of_daily_price_increases {
    type: max
    sql: ${number_of_daily_price_increases} ;;
    description: "The maximum number of price increases by date and country."
  }

  measure: count {
    type: count
    drill_fields: []
    description: "Generic count measure."
  }
}
