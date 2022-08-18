view: rewe_products {
  sql_table_name: `flink-data-prod.curated.rewe_products`
    ;;

  dimension: amt_discount_value {
    type: number
    sql: ${TABLE}.amt_discount_value ;;
  }

  dimension: amt_product_price {
    type: number
    sql: ${TABLE}.amt_product_price ;;
  }

  dimension: amt_product_price_cents {
    type: number
    sql: ${TABLE}.amt_product_price_cents ;;
  }

  dimension: amt_strikethrough_price {
    type: number
    sql: ${TABLE}.amt_strikethrough_price ;;
  }

  dimension: article_id {
    type: string
    sql: ${TABLE}.article_id ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension_group: date_scraped {
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
    sql: ${TABLE}.date_scraped ;;
  }

  dimension: is_discounted {
    type: yesno
    sql: ${TABLE}.is_discounted ;;
  }

  dimension: is_geographic_price_difference {
    type: yesno
    sql: ${TABLE}.is_geographic_price_difference ;;
  }

  dimension: lowest_product_price {
    type: number
    sql: ${TABLE}.lowest_product_price ;;
  }

  dimension: highest_product_price {
    type: number
    sql: ${TABLE}.highest_product_price ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_price_change {
    type: yesno
    sql: ${TABLE}.is_price_change ;;
  }

  dimension: is_price_decrease {
    type: yesno
    sql: ${TABLE}.is_price_decrease ;;
  }

  dimension: is_price_increase {
    type: yesno
    sql: ${TABLE}.is_price_increase ;;
  }

  dimension: listing_id {
    type: string
    sql: ${TABLE}.listing_id ;;
  }

  dimension: listing_version {
    type: number
    sql: ${TABLE}.listing_version ;;
  }

  dimension: market_id {
    type: string
    sql: ${TABLE}.market_id ;;
  }

  dimension: nan {
    type: string
    sql: ${TABLE}.nan ;;
    primary_key: yes
  }

  dimension: number_of_price_tiers {
    type: number
    sql: ${TABLE}.number_of_price_tiers ;;
  }

  dimension: pct_discount_value {
    type: number
    sql: ${TABLE}.pct_discount_value ;;
  }

  dimension: pct_price_change {
    type: number
    sql: ${TABLE}.pct_price_change ;;
  }

  dimension: postcode {
    type: string
    sql: ${TABLE}.postcode ;;
  }

  dimension: previous_amt_product_price {
    type: number
    sql: ${TABLE}.previous_amt_product_price ;;
  }

  dimension: amt_price_change {
    type: number
    sql: ${TABLE}.amt_price_change ;;
  }

  dimension: price_tier {
    type: number
    sql: ${TABLE}.price_tier ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_image_url {
    type: string
    sql: ${TABLE}.product_image_url ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: savings_id {
    type: string
    sql: ${TABLE}.savings_id ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
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

  dimension: unit_pricing_measure {
    type: string
    sql: ${TABLE}.unit_pricing_measure ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name]
  }
}
