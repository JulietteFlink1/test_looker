# Owner: Brandon Beckett
# Created: 2022-08-22

# This view contains REWE Products & Prices data that is scraped daily.

view: rewe_products {
  sql_table_name: `flink-data-prod.curated.rewe_products`
    ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ====================     __main__     ====================

# -------------------    Timestamp Data  ------------------

  dimension_group: time_scraped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.time_scraped ;;
  }

# --------------------  Market Information  --------------------



  dimension: market_id {

    label: "Market ID"
    description: "REWE's market ID represents a specific market location that REWE assigns to multiple postcodes where they deliver the orders."
    group_label: "Market Information"

    type: string
    sql: ${TABLE}.market_id ;;
  }

  dimension: postcode {

    label: "Postcode"
    description: "The postcode that was scraped in combination with market_id. These postcodes are chosen by the Pricing team as a representative sample of various low, mid, and high price-tier postcodes."
    group_label: "Market Information"

    type: string
    sql: ${TABLE}.postcode ;;
  }

  dimension: country_iso {

    label: "Country Iso"
    description: "The REWE market country that was scraped."
    group_label: "Market Information"

    type: string
    sql: ${TABLE}.country_iso ;;
  }

# --------------------  Product Information  --------------------

  dimension: category {

    label: "Category"
    description: "The top-level category in which the product is found in the REWE app."
    group_label: "Product Information"

    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: product_id {

    label: "Product ID"
    description: "REWE's Product ID. May be referred to as NAN, EDI, or Product ID."
    group_label: "Product Information"

    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension: nan {

    label: "NAN"
    description: "REWE's national aritcle number. May be referred to as NAN, EDI, or Product ID."
    group_label: "Product Information"

    type: string
    sql: ${TABLE}.nan ;;
  }

  dimension: article_id {

    label: "Article ID"
    description: "REWE's article ID."
    group_label: "Product Information"

    type: string
    sql: ${TABLE}.article_id ;;
  }

  dimension: listing_id {

    label: "Listing ID"
    description: "Product listing ID."
    group_label: "Product Information"

    type: string
    sql: ${TABLE}.listing_id ;;
  }

  dimension: listing_version {

    label: "Listing Version"
    description: "Product listing version."
    group_label: "Product Information"

    type: number
    sql: ${TABLE}.listing_version ;;
  }

  dimension: product_name {

    label: "Product Name"
    description: "Product name and weight."
    group_label: "Product Information"

    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_image_url {

    label: "Product Image"
    description: "Link to the product's image."
    group_label: "Product Information"

    type: string
    sql: ${TABLE}.product_image_url ;;

    html: <img src="{{ value }}" /> ;;
  }

# --------------------   Prices   --------------------

  dimension: amt_product_price {

    label: "Product Price"
    description: "REWE's product price, excluding deposit."
    group_label: "Prices"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price ;;
  }

  dimension: amt_product_price_cents {

    label: "Product Price Cent Amount"
    description: "Product price in cents, excluding deposit."
    group_label: "Prices"

    type: number
    sql: ${TABLE}.amt_product_price_cents ;;
  }

  dimension: lowest_product_price {

    label: "Lowest Product Price"
    description: "The lowest price on a given day for this product across all scraped markets."
    group_label: "Prices"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.lowest_product_price ;;
  }

  dimension: highest_product_price {

    label: "Highest Product Price"
    description: "The highest price on a given day for this product across all scraped markets and postcodes."
    group_label: "Prices"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_product_price ;;
  }

  dimension: is_geographic_price_difference {

    label: "Is Geographic Price"
    description: "Boolean used to filter for products that have different prices across all scraped markets and postcodes"
    group_label: "Prices"

    type: yesno
    sql: ${TABLE}.is_geographic_price_difference ;;
  }

  dimension: price_tier {

    label: "Price Tier"
    description: "If the product has a geographic price difference, then this number represents the rank for this price. 1 always represents the lowest price. The price tier is incremented by 1 for each higher price that exists for this product on a given day."
    group_label: "Prices"

    type: number
    sql: ${TABLE}.price_tier ;;
  }

  dimension: number_of_price_tiers {

    label: "# Price Tiers"
    description: "The highest price tier that exists for a given product. Use this field to determine which rank a givne price falls under."
    group_label: "Prices"

    type: number
    sql: ${TABLE}.number_of_price_tiers ;;
  }

  dimension: unit_pricing_measure {

    label: "Unit Price"
    description: "Unit price, weight, and measure."
    group_label: "Prices"

    type: string
    sql: ${TABLE}.unit_pricing_measure ;;
  }

# -----------------  Discount Price Data  ------------------

  dimension: savings_id {

    label: "Savings ID"
    description: "The discount ID."
    group_label: "Discount Prices"

    type: string
    sql: ${TABLE}.savings_id ;;
  }

  dimension: is_discounted {

    label: "Is Discounted"
    description: "Boolean used to filter for discounted products."
    group_label: "Discount Prices"

    type: yesno
    sql: ${TABLE}.is_discounted ;;
  }

  dimension: amt_discount_value {

    label: "Discount Amount"
    description: "€ amount discounted from the product price."
    group_label: "Discount Prices"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.amt_discount_value ;;
  }

  dimension: pct_discount_value {

    label: "Discount %"
    description: "% amount discoutned from the product price."
    group_label: "Discount Prices"

    type: number
    value_format: "0.00\%"
    sql: ${TABLE}.pct_discount_value ;;
  }

  dimension: amt_strikethrough_price {

    label: "Strikethrough Price"
    description: "The previous product price before the discount was applied."
    group_label: "Discount Prices"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.amt_strikethrough_price ;;
  }

# -----------------  Price Change Data  ------------------

  dimension: is_price_change {

    label: "Is Price Change"
    description: "Boolean used to filter for products that have had a price change since the previous day."
    group_label: "Price Changes"

    type: yesno
    sql: ${TABLE}.is_price_change ;;
  }

  dimension: is_price_decrease {

    label: "Is Price Decrease"
    description: "Boolean used to filter for products with price decreases since the previous day."
    group_label: "Price Changes"

    type: yesno
    sql: ${TABLE}.is_price_decrease ;;
  }

  dimension: is_price_increase {

    label: "Is Price Increase"
    description: "Boolean used to filter for products with price increases since the previous day."
    group_label: "Price Changes"

    type: yesno
    sql: ${TABLE}.is_price_increase ;;
  }

  dimension: previous_amt_product_price {

    label: "Previous Product Price Amount"
    description: "Product price from the previous day."
    group_label: "Price Changes"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.previous_amt_product_price ;;
  }

  dimension: amt_price_change {

    label: "Price Change Amount"
    description: "The price change amount calculated by subtracting the previous day's product price from the product price."
    group_label: "Price Changes"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.amt_price_change ;;
  }

  dimension: pct_price_change {

    label: "Price Change %"
    description: "The % price change calculated by comparing the product price to to the previous day's product price."
    group_label: "Price Changes"

    type: number
    value_format: "0.00\%"
    sql: ${TABLE}.pct_price_change ;;
  }



# ====================      hidden      ====================

  dimension: table_uuid {

    label: "Table UUID"
    description: "Unique ID generated from time_scraped, postcod', category, and nan fields"

    type: string
    sql: ${TABLE}.table_uuid ;;

    hidden: yes
    primary_key: yes
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

}
