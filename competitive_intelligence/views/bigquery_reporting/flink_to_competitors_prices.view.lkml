# Owner: Brandon Beckett & Kristina Voloshina
# Created: 2023-02-14

# This view contains the reporting layer data for Flink's published and currently active assortment along with all compteitor product matches that exist & their prices & price differences from Flink.

view: flink_to_competitors_prices {
  view_label: "Flink to Competitor Prices"
  sql_table_name: `flink-data-dev.dbt_bbeckett_reporting.flink_to_competitors_prices` ;;


# ===========  Metadata  =====================================================================

  dimension: table_uuid {

    label: "Table UUID"
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    group_label: "Metadata"

    primary_key: yes
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

  dimension_group: reporting {

    label: "Reporting"
    description: "The date when the record was generated."
    timeframes: [
      date
    ]
    convert_tz: no
    group_label: "Metadata"

    type: time
    datatype: date
    sql: ${TABLE}.reporting_date ;;
  }


# ===========  Flink  ===========

  dimension: country_iso {

    label: "Country ISO"
    description: "Country ISO based on 'hub_code'."
    group_label: "Flink"

    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: flink_product_sku {

    label: "SKU"
    description: "SKU of the product, as available in the backend."
    group_label: "Flink"

    type: string
    sql: ${TABLE}.flink_product_sku ;;
  }

  dimension: product_name {

    label: "Product Name"
    description: "Name of the product, as specified in the backend."
    group_label: "Flink"

    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: category {

    label: "Category"
    description: "Name of the category to which product was assigned (not ERP category)."
    group_label: "Flink"

    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: subcategory {

    label: "Subcategory"
    description: "Name of the subcategory to which product was assigned (not ERP subcategory)."
    group_label: "Flink"

    type: string
    sql: ${TABLE}.subcategory ;;
  }

  dimension: low_flink_price {

    label: "Low Flink Price"
    description: "Flink's low tier price of the product before discount (including VAT)."
    group_label: "Flink"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_flink_price ;;
  }

  dimension: mid_flink_price {

    label: "Mid Flink Price"
    description: "Flink's mid tier price of the product before discount (including VAT)."
    group_label: "Flink"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_flink_price ;;
  }

  dimension: high_flink_price {

    label: "High Flink Price"
    description: "Flink's high tier price of the product before discount (including VAT)."
    group_label: "Flink"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_flink_price ;;
  }

  dimension: highest_flink_price {

    label: "Highest Flink Price"
    description: "Flink's highest tier price of the product before discount (including VAT)."
    group_label: "Flink"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_flink_price ;;
  }

  dimension: number_of_unique_skus_by_country {

    label: "Number of Unique SKUs by Country"
    description: "Total number of active SKUs based on the country."
    group_label: "Flink"

    type: number
    sql: ${TABLE}.number_of_unique_skus_by_country ;;
  }

  dimension: quantity_sold {

    label: "Number of Quantity Sold - Last 30 days"
    description: "The product's sum of the quantity sold."
    group_label: "Flink"

    type: number
    sql: ${TABLE}.quantity_sold ;;
  }

  dimension: low_quantity_sold {

    label: "Number of Quantity Sold in Low Hub Price Tiers - Last 30 days"
    description: "The product's sum of the quantity sold in low hub price tiers in the last 30 days."
    group_label: "Flink"

    type: number
    sql: ${TABLE}.low_quantity_sold ;;
  }

  dimension: mid_quantity_sold {

    label: "Number of Quantity Sold in Mid Hub Price Tiers - Last 30 days"
    description: "The product's sum of the quantity sold in mid hub price tiers in the last 30 days."
    group_label: "Flink"

    type: number
    sql: ${TABLE}.mid_quantity_sold ;;
  }

  dimension: high_quantity_sold {

    label: "Number of Quantity Sold in High Hub Price Tiers - Last 30 days"
    description: "The product's sum of the quantity sold in high hub price tiers in the last 30 days."
    group_label: "Flink"

    type: number
    sql: ${TABLE}.high_quantity_sold ;;
  }

  dimension: highest_quantity_sold {

    label: "Number of Quantity Sold in Highest Hub Price Tiers - Last 30 days"
    description: "The product's sum of the quantity sold in highest hub price tiers in the last 30 days."
    group_label: "Flink"

    type: number
    sql: ${TABLE}.highest_quantity_sold ;;
  }

  dimension: share_of_product_revenue {

    label: "% Share of Product Revenue"
    description: "The percent share of the product price gross sold over the last 30 days."
    group_label: "Flink"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.share_of_product_revenue ;;
  }

  dimension: share_of_product_quantity_sold {

    label: "% Share of Product Quantity Sold"
    description: "The percent share of the product quantity sold over the last 30 days."
    group_label: "Flink"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.share_of_product_quantity_sold ;;
  }

  dimension: is_kvi {

    label: "Is KVI"
    description: "True if an SKU is considered a key value item."
    group_label: "Flink"

    type: yesno
    sql: ${TABLE}.is_kvi ;;
  }


# ===========  Albert Heijn  ================================================================

  dimension: albert_heijn_product_id {

    label: "Product ID - AH"
    description: "A competitor's unique ID assigned to each product. Similar to Flink's SKU."
    group_label: "Albert Heijn"

    type: string
    sql: ${TABLE}.albert_heijn_product_id ;;
  }

  dimension: ah_product_name {

    label: "Product Name - AH"
    description: "The product name and unit size provided by the competitor."
    group_label: "Albert Heijn"

    type: string
    sql: ${TABLE}.ah_product_name ;;
  }

  dimension: ah_match_type {

    label: "Match Type - AH"
    description: "The type of match between a Flink and a competitor product. Can be a manual match (strongest), EAN or NAN match, or a fuzzy product name match (weakest)."
    group_label: "Albert Heijn"

    type: string
    sql: ${TABLE}.ah_match_type ;;
  }

  dimension: ah_match_score {

    label: "Match Score - AH"
    description: "A score ranging from -3.0 to 100.0 to represent the quality of a match between a Flink and a competitor product. Higher score = better match, lower score = worse match."
    group_label: "Albert Heijn"

    type: number
    sql: ${TABLE}.ah_match_score ;;
  }

  dimension: min_ah_price {

    label: "Lowest Price - AH"
    description: "Competitor's lowest available price of the product before discount (including VAT)."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.min_ah_price ;;
  }

  dimension: avg_ah_price {

    label: "Average Price - AH"
    description: "Competitor's average price of the product before discount (including VAT)."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.avg_ah_price ;;
  }

  dimension: max_ah_price {

    label: "Highest Price - AH"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.max_ah_price ;;
  }

  dimension: ah_conversion_factor {

    label: "Conversion Factor - AH"
    description: "A multiplier to convert a competitor price to represent an equivalent price to Flink's product price based on product unit size differences if they exist."
    group_label: "Albert Heijn"

    type: number
    sql: ${TABLE}.ah_conversion_factor ;;
  }

  dimension: is_ah_prices_converted {

    label: "Is Price Converted - AH"
    description: "Yes, if the competitor price has been converted by the price conversion factor."
    group_label: "Albert Heijn"

    type: yesno
    sql: ${TABLE}.is_ah_prices_converted ;;
  }

  dimension: low_price_delta_with_ah_min_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - AH Min"
    description: "Flink's low price tier delta with the competitor's lowest product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_ah_min_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_ah_avg_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - AH Avg"
    description: "Flink's low price tier delta with the competitor's average product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_ah_avg_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_ah_max_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - AH Max"
    description: "Flink's low price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_ah_max_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_ah_min_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - AH Min"
    description: "Flink's mid price tier delta with the competitor's midest product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_ah_min_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_ah_avg_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - AH Avg"
    description: "Flink's mid price tier delta with the competitor's average product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_ah_avg_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_ah_max_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - AH Max"
    description: "Flink's mid price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_ah_max_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_ah_min_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - AH Min"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_ah_min_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_ah_avg_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - AH Avg"
    description: "Flink's high price tier delta with the competitor's average product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_ah_avg_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_ah_max_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - AH Max"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_ah_max_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_ah_min_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - AH Min"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_ah_min_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_ah_avg_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - AH Avg"
    description: "Flink's highest price tier delta with the competitor's average product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_ah_avg_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_ah_max_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - AH Max"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Albert Heijn"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_ah_max_by_quantity_sold ;;
  }

  dimension: pct_low_price_delta_with_ah_min {

    label: "% Low Tier Price Delta - Ah Min"
    description: "The percent difference between Flink's Low Tier product price and the competitor's lowest product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_ah_min ;;
  }

  dimension: pct_low_price_delta_with_ah_avg {

    label: "% Low Tier Price Delta - Ah Avg"
    description: "The percent difference between Flink's Low Tier product price and the competitor's average product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_ah_avg ;;
  }

  dimension: pct_low_price_delta_with_ah_max {

    label: "% Low Tier Price Delta - Ah Max"
    description: "The percent difference between Flink's Low Tier product price and the competitor's highest product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_ah_max ;;
  }

  dimension: pct_mid_price_delta_with_ah_min {

    label: "% Mid Tier Price Delta - Ah Min"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's lowest product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_ah_min ;;
  }

  dimension: pct_mid_price_delta_with_ah_avg {

    label: "% Mid Tier Price Delta - Ah Avg"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's average product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_ah_avg ;;
  }

  dimension: pct_mid_price_delta_with_ah_max {

    label: "% Mid Tier Price Delta - Ah Max"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's highest product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_ah_max ;;
  }

  dimension: pct_high_price_delta_with_ah_min {

    label: "% High Tier Price Delta - Ah Min"
    description: "The percent difference between Flink's High Tier product price and the competitor's lowest product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_ah_min ;;
  }

  dimension: pct_high_price_delta_with_ah_avg {

    label: "% High Tier Price Delta - Ah Avg"
    description: "The percent difference between Flink's High Tier product price and the competitor's average product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_ah_avg ;;
  }

  dimension: pct_high_price_delta_with_ah_max {

    label: "% High Tier Price Delta - Ah Max"
    description: "The percent difference between Flink's High Tier product price and the competitor's highest product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_ah_max ;;
  }

  dimension: pct_highest_price_delta_with_ah_min {

    label: "% Highest Tier Price Delta - Ah Min"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's lowest product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_ah_min ;;
  }

  dimension: pct_highest_price_delta_with_ah_avg {

    label: "% Highest Tier Price Delta - Ah Avg"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's average product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_ah_avg ;;
  }

  dimension: pct_highest_price_delta_with_ah_max {

    label: "% Highest Tier Price Delta - Ah Max"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's highest product price."
    group_label:  "Albert Heijn"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_ah_max ;;
  }


# ===========  Carrefour City  ==============================================================

  dimension: carrefour_city_product_id {

    label: "Product ID - CRF City"
    description: "A competitor's unique ID assigned to each product. Similar to Flink's SKU."
    group_label: "Carrefour City"

    type: string
    sql: ${TABLE}.carrefour_city_product_id ;;
  }

  dimension: carrefour_city_product_name {

    label: "Product Name - CRF City"
    description: "The product name and unit size provided by the competitor."
    group_label: "Carrefour City"

    type: string
    sql: ${TABLE}.carrefour_city_product_name ;;
  }

  dimension: carrefour_city_match_type {

    label: "Match Type - CRF City"
    description: "The type of match between a Flink and a competitor product. Can be a manual match (strongest), EAN or NAN match, or a fuzzy product name match (weakest)."
    group_label: "Carrefour City"

    type: string
    sql: ${TABLE}.carrefour_city_match_type ;;
  }

  dimension: carrefour_city_match_score {

    label: "Match Score - CRF City"
    description: "A score ranging from -3.0 to 100.0 to represent the quality of a match between a Flink and a competitor product. Higher score = better match, lower score = worse match."
    group_label: "Carrefour City"

    type: number
    sql: ${TABLE}.carrefour_city_match_score ;;
  }

  dimension: min_carrefour_city_price {

    label: "Lowest Price - CRF City"
    description: "Competitor's lowest available price of the product before discount (including VAT)."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.min_carrefour_city_price ;;
  }

  dimension: avg_carrefour_city_price {

    label: "Average Price - CRF City"
    description: "Competitor's average price of the product before discount (including VAT)."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.avg_carrefour_city_price ;;
  }

  dimension: max_carrefour_city_price {

    label: "Highest Price - CRF City"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.max_carrefour_city_price ;;
  }

  dimension: carrefour_city_conversion_factor {

    label: "Conversion Factor - CRF City"
    description: "A multiplier to convert a competitor price to represent an equivalent price to Flink's product price based on product unit size differences if they exist."
    group_label: "Carrefour City"

    type: number
    sql: ${TABLE}.carrefour_city_conversion_factor ;;
  }

  dimension: is_carrefour_city_prices_converted {

    label: "Is Price Converted - CRF City"
    description: "Yes, if the competitor price has been converted by the price conversion factor."
    group_label: "Carrefour City"

    type: yesno
    sql: ${TABLE}.is_carrefour_city_prices_converted ;;
  }

  dimension: low_price_delta_with_carrefour_city_min_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - CRF City Min"
    description: "Flink's low price tier delta with the competitor's lowest product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_carrefour_city_min_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_carrefour_city_avg_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - CRF City Avg"
    description: "Flink's low price tier delta with the competitor's average product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_carrefour_city_avg_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_carrefour_city_max_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - CRF City Max"
    description: "Flink's low price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_carrefour_city_max_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_carrefour_city_min_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - CRF City Min"
    description: "Flink's mid price tier delta with the competitor's midest product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_carrefour_city_min_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_carrefour_city_avg_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - CRF City Avg"
    description: "Flink's mid price tier delta with the competitor's average product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_carrefour_city_avg_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_carrefour_city_max_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - CRF City Max"
    description: "Flink's mid price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_carrefour_city_max_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_carrefour_city_min_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - CRF City Min"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_carrefour_city_min_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_carrefour_city_avg_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - CRF City Avg"
    description: "Flink's high price tier delta with the competitor's average product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_carrefour_city_avg_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_carrefour_city_max_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - CRF City Max"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_carrefour_city_max_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_carrefour_city_min_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - CRF City Min"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_carrefour_city_min_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_carrefour_city_avg_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - CRF City Avg"
    description: "Flink's highest price tier delta with the competitor's average product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_carrefour_city_avg_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_carrefour_city_max_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - CRF City Max"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Carrefour City"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_carrefour_city_max_by_quantity_sold ;;
  }

  dimension: pct_low_price_delta_with_carrefour_city_min {

    label: "% Low Tier Price Delta - Carrefour CityMin"
    description: "The percent difference between Flink's Low Tier product price and the competitor's lowest product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_carrefour_city_min ;;
  }

  dimension: pct_low_price_delta_with_carrefour_city_avg {

    label: "% Low Tier Price Delta - Carrefour CityAvg"
    description: "The percent difference between Flink's Low Tier product price and the competitor's average product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_carrefour_city_avg ;;
  }

  dimension: pct_low_price_delta_with_carrefour_city_max {

    label: "% Low Tier Price Delta - Carrefour CityMax"
    description: "The percent difference between Flink's Low Tier product price and the competitor's highest product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_carrefour_city_max ;;
  }

  dimension: pct_mid_price_delta_with_carrefour_city_min {

    label: "% Mid Tier Price Delta - Carrefour CityMin"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's lowest product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_carrefour_city_min ;;
  }

  dimension: pct_mid_price_delta_with_carrefour_city_avg {

    label: "% Mid Tier Price Delta - Carrefour CityAvg"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's average product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_carrefour_city_avg ;;
  }

  dimension: pct_mid_price_delta_with_carrefour_city_max {

    label: "% Mid Tier Price Delta - Carrefour CityMax"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's highest product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_carrefour_city_max ;;
  }

  dimension: pct_high_price_delta_with_carrefour_city_min {

    label: "% High Tier Price Delta - Carrefour CityMin"
    description: "The percent difference between Flink's High Tier product price and the competitor's lowest product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_carrefour_city_min ;;
  }

  dimension: pct_high_price_delta_with_carrefour_city_avg {

    label: "% High Tier Price Delta - Carrefour CityAvg"
    description: "The percent difference between Flink's High Tier product price and the competitor's average product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_carrefour_city_avg ;;
  }

  dimension: pct_high_price_delta_with_carrefour_city_max {

    label: "% High Tier Price Delta - Carrefour CityMax"
    description: "The percent difference between Flink's High Tier product price and the competitor's highest product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_carrefour_city_max ;;
  }

  dimension: pct_highest_price_delta_with_carrefour_city_min {

    label: "% Highest Tier Price Delta - Carrefour CityMin"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's lowest product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_carrefour_city_min ;;
  }

  dimension: pct_highest_price_delta_with_carrefour_city_avg {

    label: "% Highest Tier Price Delta - Carrefour CityAvg"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's average product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_carrefour_city_avg ;;
  }

  dimension: pct_highest_price_delta_with_carrefour_city_max {

    label: "% Highest Tier Price Delta - Carrefour CityMax"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's highest product price."
    group_label: "Carrefour City"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_carrefour_city_max ;;
  }


# ===========  Getir  ======================================================================

  dimension: getir_product_id {

    label: "Product ID - Getir"
    description: "A competitor's unique ID assigned to each product. Similar to Flink's SKU."
    group_label: "Getir"

    type: string
    sql: ${TABLE}.getir_product_id ;;
  }

  dimension: getir_product_name {

    label: "Product Name - Getir"
    description: "The product name and unit size provided by the competitor."
    group_label: "Getir"

    type: string
    sql: ${TABLE}.getir_product_name ;;
  }

  dimension: getir_match_type {

    label: "Match Type - Getir"
    description: "The type of match between a Flink and a competitor product. Can be a manual match (strongest), EAN or NAN match, or a fuzzy product name match (weakest)."
    group_label: "Getir"

    type: string
    sql: ${TABLE}.getir_match_type ;;
  }

  dimension: getir_match_score {

    label: "Match Score - Getir"
    description: "A score ranging from -3.0 to 100.0 to represent the quality of a match between a Flink and a competitor product. Higher score = better match, lower score = worse match."
    group_label: "Getir"

    type: number
    sql: ${TABLE}.getir_match_score ;;
  }

  dimension: getir_conversion_factor {

    label: "Conversion Factor - Getir"
    description: "A multiplier to convert a competitor price to represent an equivalent price to Flink's product price based on product unit size differences if they exist."
    group_label: "Getir"

    type: number
    sql: ${TABLE}.getir_conversion_factor ;;
  }

  dimension: min_getir_price {

    label: "Lowest Price - Getir"
    description: "Competitor's lowest available price of the product before discount (including VAT)."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.min_getir_price ;;
  }

  dimension: avg_getir_price {

    label: "Average Price - Getir"
    description: "Competitor's average price of the product before discount (including VAT)."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.avg_getir_price ;;
  }

  dimension: max_getir_price {

    label: "Highest Price - Getir"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.max_getir_price ;;
  }

  dimension: is_getir_prices_converted {

    label: "Is Price Converted - Getir"
    description: "Yes, if the competitor price has been converted by the price conversion factor."
    group_label: "Getir"

    type: yesno
    sql: ${TABLE}.is_getir_prices_converted ;;
  }

  dimension: low_price_delta_with_getir_min_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - Getir Min"
    description: "Flink's low price tier delta with the competitor's lowest product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_getir_min_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_getir_avg_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - Getir Avg"
    description: "Flink's low price tier delta with the competitor's average product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_getir_avg_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_getir_max_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - Getir Max"
    description: "Flink's low price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_getir_max_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_getir_min_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - Getir Min"
    description: "Flink's mid price tier delta with the competitor's midest product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_getir_min_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_getir_avg_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - Getir Avg"
    description: "Flink's mid price tier delta with the competitor's average product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_getir_avg_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_getir_max_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - Getir Max"
    description: "Flink's mid price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_getir_max_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_getir_min_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - Getir Min"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_getir_min_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_getir_avg_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - Getir Avg"
    description: "Flink's high price tier delta with the competitor's average product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_getir_avg_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_getir_max_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - Getir Max"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_getir_max_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_getir_min_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - Getir Min"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_getir_min_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_getir_avg_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - Getir Avg"
    description: "Flink's highest price tier delta with the competitor's average product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_getir_avg_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_getir_max_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - Getir Max"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Getir"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_getir_max_by_quantity_sold ;;
  }

  dimension: pct_low_price_delta_with_getir_min {

    label: "% Low Tier Price Delta - Getir Min"
    description: "The percent difference between Flink's Low Tier product price and the competitor's lowest product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_getir_min ;;
  }

  dimension: pct_low_price_delta_with_getir_avg {

    label: "% Low Tier Price Delta - Getir Avg"
    description: "The percent difference between Flink's Low Tier product price and the competitor's average product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_getir_avg ;;
  }

  dimension: pct_low_price_delta_with_getir_max {

    label: "% Low Tier Price Delta - Getir Max"
    description: "The percent difference between Flink's Low Tier product price and the competitor's highest product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_getir_max ;;
  }

  dimension: pct_mid_price_delta_with_getir_min {

    label: "% Mid Tier Price Delta - Getir Min"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's lowest product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_getir_min ;;
  }

  dimension: pct_mid_price_delta_with_getir_avg {

    label: "% Mid Tier Price Delta - Getir Avg"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's average product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_getir_avg ;;
  }

  dimension: pct_mid_price_delta_with_getir_max {

    label: "% Mid Tier Price Delta - Getir Max"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's highest product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_getir_max ;;
  }

  dimension: pct_high_price_delta_with_getir_min {

    label: "% High Tier Price Delta - Getir Min"
    description: "The percent difference between Flink's High Tier product price and the competitor's lowest product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_getir_min ;;
  }

  dimension: pct_high_price_delta_with_getir_avg {

    label: "% High Tier Price Delta - Getir Avg"
    description: "The percent difference between Flink's High Tier product price and the competitor's average product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_getir_avg ;;
  }

  dimension: pct_high_price_delta_with_getir_max {

    label: "% High Tier Price Delta - Getir Max"
    description: "The percent difference between Flink's High Tier product price and the competitor's highest product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_getir_max ;;
  }

  dimension: pct_highest_price_delta_with_getir_min {

    label: "% Highest Tier Price Delta - Getir Min"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's lowest product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_getir_min ;;
  }

  dimension: pct_highest_price_delta_with_getir_avg {

    label: "% Highest Tier Price Delta - Getir Avg"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's average product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_getir_avg ;;
  }

  dimension: pct_highest_price_delta_with_getir_max {

    label: "% Highest Tier Price Delta - Getir Max"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's highest product price."
    group_label: "Getir"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_getir_max ;;
  }


# ===========  Gorillas  ===============================================================

  dimension: gorillas_product_id {

    label: "Product ID - Gorillas"
    description: "A competitor's unique ID assigned to each product. Similar to Flink's SKU."
    group_label: "Gorillas"

    type: string
    sql: ${TABLE}.gorillas_product_id ;;
  }

  dimension: gorillas_product_name {

    label: "Product Name - Gorillas"
    description: "The product name and unit size provided by the competitor."
    group_label: "Gorillas"

    type: string
    sql: ${TABLE}.gorillas_product_name ;;
  }

  dimension: gorillas_match_type {

    label: "Match Type - Gorillas"
    description: "The type of match between a Flink and a competitor product. Can be a manual match (strongest), EAN or NAN match, or a fuzzy product name match (weakest)."
    group_label: "Gorillas"

    type: string
    sql: ${TABLE}.gorillas_match_type ;;
  }

  dimension: gorillas_match_score {

    label: "Match Score - Gorillas"
    description: "A score ranging from -3.0 to 100.0 to represent the quality of a match between a Flink and a competitor product. Higher score = better match, lower score = worse match."
    group_label: "Gorillas"

    type: number
    sql: ${TABLE}.gorillas_match_score ;;
  }

  dimension: min_gorillas_price {

    label: "Lowest Price - Gorillas"
    description: "Competitor's lowest available price of the product before discount (including VAT)."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.min_gorillas_price ;;
  }

  dimension: avg_gorillas_price {

    label: "Average Price - Gorillas"
    description: "Competitor's average price of the product before discount (including VAT)."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.min_gorillas_price ;;
  }

  dimension: max_gorillas_price {

    label: "Highest Price - Gorillas"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.max_gorillas_price ;;
  }

  dimension: gorillas_conversion_factor {

    label: "Conversion Factor - Gorillas"
    description: "A multiplier to convert a competitor price to represent an equivalent price to Flink's product price based on product unit size differences if they exist."
    group_label: "Gorillas"

    type: number
    sql: ${TABLE}.gorillas_conversion_factor ;;
  }

  dimension: is_gorillas_prices_converted {

    label: "Is Price Converted - Gorillas"
    description: "Yes, if the competitor price has been converted by the price conversion factor."
    group_label: "Gorillas"

    type: yesno
    sql: ${TABLE}.is_gorillas_prices_converted ;;
  }

  dimension: low_price_delta_with_gorillas_min_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - Gorillas Min"
    description: "Flink's low price tier delta with the competitor's lowest product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_gorillas_min_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_gorillas_avg_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - Gorillas Avg"
    description: "Flink's low price tier delta with the competitor's average product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_gorillas_avg_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_gorillas_max_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - Gorillas Max"
    description: "Flink's low price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_gorillas_max_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_gorillas_min_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - Gorillas Min"
    description: "Flink's mid price tier delta with the competitor's midest product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_gorillas_min_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_gorillas_avg_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - Gorillas Avg"
    description: "Flink's mid price tier delta with the competitor's average product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_gorillas_avg_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_gorillas_max_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - Gorillas Max"
    description: "Flink's mid price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_gorillas_max_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_gorillas_min_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - Gorillas Min"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_gorillas_min_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_gorillas_avg_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - Gorillas Avg"
    description: "Flink's high price tier delta with the competitor's average product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_gorillas_avg_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_gorillas_max_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - Gorillas Max"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_gorillas_max_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_gorillas_min_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - Gorillas Min"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_gorillas_min_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_gorillas_avg_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - Gorillas Avg"
    description: "Flink's highest price tier delta with the competitor's average product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_gorillas_avg_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_gorillas_max_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - Gorillas Max"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Gorillas"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_gorillas_max_by_quantity_sold ;;
  }

  dimension: pct_low_price_delta_with_gorillas_min {

    label: "% Low Tier Price Delta - Gorillas Min"
    description: "The percent difference between Flink's Low Tier product price and the competitor's lowest product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_gorillas_min ;;
  }

  dimension: pct_low_price_delta_with_gorillas_avg {

    label: "% Low Tier Price Delta - Gorillas Avg"
    description: "The percent difference between Flink's Low Tier product price and the competitor's average product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_gorillas_avg ;;
  }

  dimension: pct_low_price_delta_with_gorillas_max {

    label: "% Low Tier Price Delta - Gorillas Max"
    description: "The percent difference between Flink's Low Tier product price and the competitor's highest product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_gorillas_max ;;
  }

  dimension: pct_mid_price_delta_with_gorillas_min {

    label: "% Mid Tier Price Delta - Gorillas Min"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's lowest product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_gorillas_min ;;
  }

  dimension: pct_mid_price_delta_with_gorillas_avg {

    label: "% Mid Tier Price Delta - Gorillas Avg"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's average product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_gorillas_avg ;;
  }

  dimension: pct_mid_price_delta_with_gorillas_max {

    label: "% Mid Tier Price Delta - Gorillas Max"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's highest product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_gorillas_max ;;
  }

  dimension: pct_high_price_delta_with_gorillas_min {

    label: "% High Tier Price Delta - Gorillas Min"
    description: "The percent difference between Flink's High Tier product price and the competitor's lowest product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_gorillas_min ;;
  }

  dimension: pct_high_price_delta_with_gorillas_avg {

    label: "% High Tier Price Delta - Gorillas Avg"
    description: "The percent difference between Flink's High Tier product price and the competitor's average product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_gorillas_avg ;;
  }

  dimension: pct_high_price_delta_with_gorillas_max {

    label: "% High Tier Price Delta - Gorillas Max"
    description: "The percent difference between Flink's High Tier product price and the competitor's highest product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_gorillas_max ;;
  }

  dimension: pct_highest_price_delta_with_gorillas_min {

    label: "% Highest Tier Price Delta - Gorillas Min"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's lowest product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_gorillas_min ;;
  }

  dimension: pct_highest_price_delta_with_gorillas_avg {

    label: "% Highest Tier Price Delta - Gorillas Avg"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's average product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_gorillas_avg ;;
  }

  dimension: pct_highest_price_delta_with_gorillas_max {

    label: "% Highest Tier Price Delta - Gorillas Max"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's highest product price."
    group_label: "Gorillas"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_gorillas_max ;;
  }


# ===========  REWE  ==============================================================

  dimension: rewe_product_id {

    label: "Product ID - Rewe"
    description: "A competitor's unique ID assigned to each product. Similar to Flink's SKU."
    group_label: "Rewe"

    type: string
    sql: ${TABLE}.rewe_product_id ;;
  }

  dimension: rewe_product_name {

    label: "Product Name - Rewe"
    description: "The product name and unit size provided by the competitor."
    group_label: "Rewe"

    type: string
    sql: ${TABLE}.rewe_product_name ;;
  }

  dimension: rewe_match_type {

    label: "Match Type - Rewe"
    description: "The type of match between a Flink and a competitor product. Can be a manual match (strongest), EAN or NAN match, or a fuzzy product name match (weakest)."
    group_label: "Rewe"

    type: string
    sql: ${TABLE}.rewe_match_type ;;
  }

  dimension: rewe_match_score {

    label: "Match Score - Rewe"
    description: "A score ranging from -3.0 to 100.0 to represent the quality of a match between a Flink and a competitor product. Higher score = better match, lower score = worse match."
    group_label: "Rewe"

    type: number
    sql: ${TABLE}.rewe_match_score ;;
  }

  dimension: min_rewe_price {

    label: "Lowest Price - Rewe"
    description: "Competitor's lowest available price of the product before discount (including VAT)."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.min_rewe_price ;;
  }

  dimension: avg_rewe_price {

    label: "Average Price - Rewe"
    description: "Competitor's average price of the product before discount (including VAT)."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.avg_rewe_price ;;
  }

  dimension: max_rewe_price {

    label: "Highest Price - Rewe"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.max_rewe_price ;;
  }

  dimension: rewe_conversion_factor {

    label: "Conversion Factor - Rewe"
    description: "A multiplier to convert a competitor price to represent an equivalent price to Flink's product price based on product unit size differences if they exist."
    group_label: "Rewe"

    type: number
    sql: ${TABLE}.rewe_conversion_factor ;;
  }

  dimension: is_rewe_prices_converted {

    label: "Is Price Converted - Rewe"
    description: "Yes, if the competitor price has been converted by the price conversion factor."
    group_label: "Rewe"

    type: yesno
    sql: ${TABLE}.is_rewe_prices_converted ;;
  }

  dimension: low_price_delta_with_rewe_min_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - Rewe Min"
    description: "Flink's low price tier delta with the competitor's lowest product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_rewe_min_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_rewe_avg_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - Rewe Avg"
    description: "Flink's low price tier delta with the competitor's average product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_rewe_avg_by_quantity_sold ;;
  }

  dimension: low_price_delta_with_rewe_max_by_quantity_sold {

    label: "Low Tier Price Delta by Quantity Sold - Rewe Max"
    description: "Flink's low price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.low_price_delta_with_rewe_max_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_rewe_min_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - Rewe Min"
    description: "Flink's mid price tier delta with the competitor's midest product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_rewe_min_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_rewe_avg_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - Rewe Avg"
    description: "Flink's mid price tier delta with the competitor's average product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_rewe_avg_by_quantity_sold ;;
  }

  dimension: mid_price_delta_with_rewe_max_by_quantity_sold {

    label: "Mid Tier Price Delta by Quantity Sold - Rewe Max"
    description: "Flink's mid price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.mid_price_delta_with_rewe_max_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_rewe_min_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - Rewe Min"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_rewe_min_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_rewe_avg_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - Rewe Avg"
    description: "Flink's high price tier delta with the competitor's average product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_rewe_avg_by_quantity_sold ;;
  }

  dimension: high_price_delta_with_rewe_max_by_quantity_sold {

    label: "High Tier Price Delta by Quantity Sold - Rewe Max"
    description: "Flink's high price tier delta with the competitor's highest product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.high_price_delta_with_rewe_max_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_rewe_min_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - Rewe Min"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_rewe_min_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_rewe_avg_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - Rewe Avg"
    description: "Flink's highest price tier delta with the competitor's average product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_rewe_avg_by_quantity_sold ;;
  }

  dimension: highest_price_delta_with_rewe_max_by_quantity_sold {

    label: "Highest Tier Price Delta by Quantity Sold - Rewe Max"
    description: "Flink's highest price tier delta with the competitor's highestest product price by quantity sold."
    group_label: "Rewe"

    type: number
    value_format: "€0.00"
    sql: ${TABLE}.highest_price_delta_with_rewe_max_by_quantity_sold ;;
  }

  dimension: pct_low_price_delta_with_rewe_min {

    label: "% Low Tier Price Delta - Rewe Min"
    description: "The percent difference between Flink's Low Tier product price and the competitor's lowest product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_rewe_min ;;
  }

  dimension: pct_low_price_delta_with_rewe_avg {

    label: "% Low Tier Price Delta - Rewe Avg"
    description: "The percent difference between Flink's Low Tier product price and the competitor's average product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_rewe_avg ;;
  }

  dimension: pct_low_price_delta_with_rewe_max {

    label: "% Low Tier Price Delta - Rewe Max"
    description: "The percent difference between Flink's Low Tier product price and the competitor's highest product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_low_price_delta_with_rewe_max ;;
  }

  dimension: pct_mid_price_delta_with_rewe_min {

    label: "% Mid Tier Price Delta - Rewe Min"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's lowest product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_rewe_min ;;
  }

  dimension: pct_mid_price_delta_with_rewe_avg {

    label: "% Mid Tier Price Delta - Rewe Avg"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's average product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_rewe_avg ;;
  }

  dimension: pct_mid_price_delta_with_rewe_max {

    label: "% Mid Tier Price Delta - Rewe Max"
    description: "The percent difference between Flink's Mid Tier product price and the competitor's highest product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_mid_price_delta_with_rewe_max ;;
  }

  dimension: pct_high_price_delta_with_rewe_min {

    label: "% High Tier Price Delta - Rewe Min"
    description: "The percent difference between Flink's High Tier product price and the competitor's lowest product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_rewe_min ;;
  }

  dimension: pct_high_price_delta_with_rewe_avg {

    label: "% High Tier Price Delta - Rewe Avg"
    description: "The percent difference between Flink's High Tier product price and the competitor's average product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_rewe_avg ;;
  }

  dimension: pct_high_price_delta_with_rewe_max {

    label: "% High Tier Price Delta - Rewe Max"
    description: "The percent difference between Flink's High Tier product price and the competitor's highest product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_high_price_delta_with_rewe_max ;;
  }

  dimension: pct_highest_price_delta_with_rewe_min {

    label: "% Highest Tier Price Delta - Rewe Min"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's lowest product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_rewe_min ;;
  }

  dimension: pct_highest_price_delta_with_rewe_avg {

    label: "% Highest Tier Price Delta - Rewe Avg"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's average product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_rewe_avg ;;
  }

  dimension: pct_highest_price_delta_with_rewe_max {

    label: "% Highest Tier Price Delta - Rewe Max"
    description: "The percent difference between Flink's Highest Tier product price and the competitor's highest product price."
    group_label: "Rewe"

    type: number
    value_format: "0.0%"
    sql: ${TABLE}.pct_highest_price_delta_with_rewe_max ;;
  }

# ================ Measures ========================================================================================================

# ================ Dynamic Measure Settings ========================================================================================

  parameter: competitor_price_value {
    type: unquoted
    allowed_value: {
      label: "Lowest Price"
      value: "min"
    }
    allowed_value: {
      label: "Average Price"
      value: "avg"
    }
    allowed_value: {
      label: "Highest Price"
      value: "max"
    }
  }

  parameter: competitor {
    type: unquoted
    allowed_value: {
      label: "Albert Heijn"
      value: "ah"
    }
    allowed_value: {
      label: "Carrefour City"
      value: "carrefour_city"
    }
    allowed_value: {
      label: "Getir"
      value: "getir"
    }
    allowed_value: {
      label: "Gorillas"
      value: "gorillas"
    }
    allowed_value: {
      label: "Rewe"
      value: "rewe"
    }
  }

  # ================ Dynamic Measures ===============================================================================================

  measure: average_low_price_delta_with_competitor{

    label: "Average Low Price Tier Delta with Competitor (Dynamic)"
    description: "Average of all Flink low tier product price deltas with the competitor."
    group_label: "Dynamic Measures"

    type: average
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_low_price_delta_with_ah_min}
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_low_price_delta_with_ah_avg}
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_low_price_delta_with_ah_max}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_low_price_delta_with_carrefour_city_min}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_low_price_delta_with_carrefour_city_avg}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_low_price_delta_with_carrefour_city_max}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_low_price_delta_with_getir_min}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_low_price_delta_with_getir_avg}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_low_price_delta_with_getir_max}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_low_price_delta_with_gorillas_min}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_low_price_delta_with_gorillas_avg}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_low_price_delta_with_gorillas_max}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_low_price_delta_with_rewe_min}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_low_price_delta_with_rewe_avg}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_low_price_delta_with_rewe_max}
    {% endif %};;
  }

  measure: average_mid_price_delta_with_competitor{

    label: "Average Mid Price Tier Delta with Competitor (Dynamic)"
    description: "Average of all Flink mid tier product price deltas with the competitor."
    group_label: "Dynamic Measures"

    type: average
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_mid_price_delta_with_ah_min}
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_mid_price_delta_with_ah_avg}
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_mid_price_delta_with_ah_max}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_mid_price_delta_with_carrefour_city_min}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_mid_price_delta_with_carrefour_city_avg}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_mid_price_delta_with_carrefour_city_max}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_mid_price_delta_with_getir_min}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_mid_price_delta_with_getir_avg}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_mid_price_delta_with_getir_max}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_mid_price_delta_with_gorillas_min}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_mid_price_delta_with_gorillas_avg}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_mid_price_delta_with_gorillas_max}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_mid_price_delta_with_rewe_min}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_mid_price_delta_with_rewe_avg}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_mid_price_delta_with_rewe_max}
    {% endif %};;
  }

  measure: average_high_price_delta_with_competitor{

    label: "Average High Price Tier Delta with Competitor (Dynamic)"
    description: "Average of all Flink high tier product price deltas with the competitor."
    group_label: "Dynamic Measures"

    type: average
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_high_price_delta_with_ah_min}
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_high_price_delta_with_ah_avg}
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_high_price_delta_with_ah_max}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_high_price_delta_with_carrefour_city_min}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_high_price_delta_with_carrefour_city_avg}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_high_price_delta_with_carrefour_city_max}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_high_price_delta_with_getir_min}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_high_price_delta_with_getir_avg}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_high_price_delta_with_getir_max}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_high_price_delta_with_gorillas_min}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_high_price_delta_with_gorillas_avg}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_high_price_delta_with_gorillas_max}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_high_price_delta_with_rewe_min}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_high_price_delta_with_rewe_avg}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_high_price_delta_with_rewe_max}
    {% endif %};;
  }

  measure: average_highest_price_delta_with_competitor{

    label: "Average Highest Price Tier Delta with Competitor (Dynamic)"
    description: "Average of all Flink highest tier product price deltas with the competitor."
    group_label: "Dynamic Measures"

    type: average
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_highest_price_delta_with_ah_min}
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_highest_price_delta_with_ah_avg}
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_highest_price_delta_with_ah_max}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_highest_price_delta_with_carrefour_city_min}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_highest_price_delta_with_carrefour_city_avg}
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_highest_price_delta_with_carrefour_city_max}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_highest_price_delta_with_getir_min}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_highest_price_delta_with_getir_avg}
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_highest_price_delta_with_getir_max}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_highest_price_delta_with_gorillas_min}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_highest_price_delta_with_gorillas_avg}
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_highest_price_delta_with_gorillas_max}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
      ${pct_highest_price_delta_with_rewe_min}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
      ${pct_highest_price_delta_with_rewe_avg}
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
      ${pct_highest_price_delta_with_rewe_max}
    {% endif %};;
  }

  measure: average_total_price_delta_with_competitor{

    label: "Average Total Price Tier Delta with Competitor (Dynamic)"
    description: "Average of all Flink's price tier's product price deltas with the competitor."
    group_label: "Dynamic Measures"

    type: average
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
        (${pct_low_price_delta_with_ah_min}
        +${pct_mid_price_delta_with_ah_min}
        +${pct_high_price_delta_with_ah_min}
        +${pct_highest_price_delta_with_ah_min}
        ) / 4
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
        (${pct_low_price_delta_with_ah_avg}
        +${pct_mid_price_delta_with_ah_avg}
        +${pct_high_price_delta_with_ah_avg}
        +${pct_highest_price_delta_with_ah_avg}
        ) / 4
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
        (${pct_low_price_delta_with_ah_max}
        +${pct_mid_price_delta_with_ah_max}
        +${pct_high_price_delta_with_ah_max}
        +${pct_highest_price_delta_with_ah_max}
        ) / 4
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
        (${pct_low_price_delta_with_carrefour_city_min}
        +${pct_mid_price_delta_with_carrefour_city_min}
        +${pct_high_price_delta_with_carrefour_city_min}
        +${pct_highest_price_delta_with_carrefour_city_min}
        ) / 4
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
        (${pct_low_price_delta_with_carrefour_city_avg}
        +${pct_mid_price_delta_with_carrefour_city_avg}
        +${pct_high_price_delta_with_carrefour_city_avg}
        +${pct_highest_price_delta_with_carrefour_city_avg}
        ) / 4
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
        (${pct_low_price_delta_with_carrefour_city_max}
        +${pct_mid_price_delta_with_carrefour_city_max}
        +${pct_high_price_delta_with_carrefour_city_max}
        +${pct_highest_price_delta_with_carrefour_city_max}
        ) / 4
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
        (${pct_low_price_delta_with_getir_min}
        +${pct_mid_price_delta_with_getir_min}
        +${pct_high_price_delta_with_getir_min}
        +${pct_highest_price_delta_with_getir_min}
        ) / 4
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
        (${pct_low_price_delta_with_getir_avg}
        +${pct_mid_price_delta_with_getir_avg}
        +${pct_high_price_delta_with_getir_avg}
        +${pct_highest_price_delta_with_getir_avg}
        ) / 4
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
        (${pct_low_price_delta_with_getir_max}
        +${pct_mid_price_delta_with_getir_max}
        +${pct_high_price_delta_with_getir_max}
        +${pct_highest_price_delta_with_getir_max}
        ) / 4
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
        (${pct_low_price_delta_with_gorillas_min}
        +${pct_mid_price_delta_with_gorillas_min}
        +${pct_high_price_delta_with_gorillas_min}
        +${pct_highest_price_delta_with_gorillas_min}
        ) / 4
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
        (${pct_low_price_delta_with_gorillas_avg}
        +${pct_mid_price_delta_with_gorillas_avg}
        +${pct_high_price_delta_with_gorillas_avg}
        +${pct_highest_price_delta_with_gorillas_avg}
        ) / 4
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
        (${pct_low_price_delta_with_gorillas_max}
        +${pct_mid_price_delta_with_gorillas_max}
        +${pct_high_price_delta_with_gorillas_max}
        +${pct_highest_price_delta_with_gorillas_max}
        ) / 4
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
        (${pct_low_price_delta_with_rewe_min}
        +${pct_mid_price_delta_with_rewe_min}
        +${pct_high_price_delta_with_rewe_min}
        +${pct_highest_price_delta_with_rewe_min}
        ) / 4
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
        (${pct_low_price_delta_with_rewe_avg}
        +${pct_mid_price_delta_with_rewe_avg}
        +${pct_high_price_delta_with_rewe_avg}
        +${pct_highest_price_delta_with_rewe_avg}
        ) / 4
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
        (${pct_low_price_delta_with_rewe_max}
        +${pct_mid_price_delta_with_rewe_max}
        +${pct_high_price_delta_with_rewe_max}
        +${pct_highest_price_delta_with_rewe_max}
        ) / 4
    {% endif %};;
  }

  measure: low_price_delta_with_competitor_weighted_by_quantity_sold{

    label: "Weighted Low Price Tier Delta with Competitor (Dynamic)"
    description: "Flink's Low Price Tier Delta with Competitor Weighted by Quantity Sold."
    group_label: "Dynamic Measures"

    type: number
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${low_price_delta_with_ah_min_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${low_price_delta_with_ah_avg_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${low_price_delta_with_ah_max_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${low_price_delta_with_carrefour_city_min_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${low_price_delta_with_carrefour_city_avg_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${low_price_delta_with_carrefour_city_max_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${low_price_delta_with_getir_min_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${low_price_delta_with_getir_avg_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${low_price_delta_with_getir_max_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${low_price_delta_with_gorillas_min_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${low_price_delta_with_gorillas_avg_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${low_price_delta_with_gorillas_max_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${low_price_delta_with_rewe_min_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${low_price_delta_with_rewe_avg_by_quantity_sold})/sum(${low_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${low_price_delta_with_rewe_max_by_quantity_sold})/sum(${low_quantity_sold})
    {% endif %};;
  }

  measure: mid_price_delta_with_competitor_weighted_by_quantity_sold{

    label: "Weighted Mid Price Tier Delta with Competitor (Dynamic)"
    description: "Flink's Mid Price Tier Delta with Competitor Weighted by Quantity Sold."
    group_label: "Dynamic Measures"

    type: number
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${mid_price_delta_with_ah_min_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${mid_price_delta_with_ah_avg_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${mid_price_delta_with_ah_max_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${mid_price_delta_with_carrefour_city_min_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${mid_price_delta_with_carrefour_city_avg_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${mid_price_delta_with_carrefour_city_max_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${mid_price_delta_with_getir_min_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${mid_price_delta_with_getir_avg_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${mid_price_delta_with_getir_max_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${mid_price_delta_with_gorillas_min_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${mid_price_delta_with_gorillas_avg_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${mid_price_delta_with_gorillas_max_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${mid_price_delta_with_rewe_min_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${mid_price_delta_with_rewe_avg_by_quantity_sold})/sum(${mid_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${mid_price_delta_with_rewe_max_by_quantity_sold})/sum(${mid_quantity_sold})
    {% endif %};;
  }

  measure: high_price_delta_with_competitor_weighted_by_quantity_sold{

    label: "Weighted High Price Tier Delta with Competitor (Dynamic)"
    description: "Flink's High Price Tier Delta with Competitor Weighted by Quantity Sold."
    group_label: "Dynamic Measures"

    type: number
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${high_price_delta_with_ah_min_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${high_price_delta_with_ah_avg_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${high_price_delta_with_ah_max_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${high_price_delta_with_carrefour_city_min_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${high_price_delta_with_carrefour_city_avg_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${high_price_delta_with_carrefour_city_max_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${high_price_delta_with_getir_min_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${high_price_delta_with_getir_avg_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${high_price_delta_with_getir_max_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${high_price_delta_with_gorillas_min_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${high_price_delta_with_gorillas_avg_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${high_price_delta_with_gorillas_max_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${high_price_delta_with_rewe_min_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${high_price_delta_with_rewe_avg_by_quantity_sold})/sum(${high_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${high_price_delta_with_rewe_max_by_quantity_sold})/sum(${high_quantity_sold})
    {% endif %};;
  }

  measure: highest_price_delta_with_competitor_weighted_by_quantity_sold{

    label: "Weighted Highest Price Tier Delta with Competitor (Dynamic)"
    description: "Flink's Highest Price Tier Delta with Competitor Weighted by Quantity Sold."
    group_label: "Dynamic Measures"

    type: number
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${highest_price_delta_with_ah_min_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${highest_price_delta_with_ah_avg_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${highest_price_delta_with_ah_max_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${highest_price_delta_with_carrefour_city_min_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${highest_price_delta_with_carrefour_city_avg_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${highest_price_delta_with_carrefour_city_max_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${highest_price_delta_with_getir_min_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${highest_price_delta_with_getir_avg_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${highest_price_delta_with_getir_max_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${highest_price_delta_with_gorillas_min_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${highest_price_delta_with_gorillas_avg_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${highest_price_delta_with_gorillas_max_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
        sum(${highest_price_delta_with_rewe_min_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
        sum(${highest_price_delta_with_rewe_avg_by_quantity_sold})/sum(${highest_quantity_sold})
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
        sum(${highest_price_delta_with_rewe_max_by_quantity_sold})/sum(${highest_quantity_sold})
    {% endif %};;
  }

  measure: average_price_delta_with_competitor_weighted_by_quantity_sold{

    label: "Weighted Total Price Tier Delta with Competitor (Dynamic)"
    description: "Flink's Average Price Delta with Competitor Weighted by Quantity Sold."
    group_label: "Dynamic Measures"

    type: number
    value_format: "0.0%"
    sql:
    {% if competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'min' %}
        ((sum(${low_price_delta_with_ah_min_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_ah_min_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_ah_min_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_ah_min_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'avg' %}
        ((sum(${low_price_delta_with_ah_avg_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_ah_avg_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_ah_avg_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_ah_avg_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'ah'
       and competitor_price_value._parameter_value == 'max' %}
        ((sum(${low_price_delta_with_ah_max_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_ah_max_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_ah_max_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_ah_max_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'min' %}
        ((sum(${low_price_delta_with_carrefour_city_min_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_carrefour_city_min_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_carrefour_city_min_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_carrefour_city_min_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'avg' %}
        ((sum(${low_price_delta_with_carrefour_city_avg_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_carrefour_city_avg_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_carrefour_city_avg_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_carrefour_city_avg_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'carrefour_city'
       and competitor_price_value._parameter_value == 'max' %}
        ((sum(${low_price_delta_with_carrefour_city_max_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_carrefour_city_max_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_carrefour_city_max_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_carrefour_city_max_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'min' %}
        ((sum(${low_price_delta_with_getir_min_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_getir_min_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_getir_min_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_getir_min_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'avg' %}
        ((sum(${low_price_delta_with_getir_avg_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_getir_avg_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_getir_avg_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_getir_avg_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'getir'
       and competitor_price_value._parameter_value == 'max' %}
        ((sum(${low_price_delta_with_getir_max_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_getir_max_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_getir_max_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_getir_max_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'min' %}
        ((sum(${low_price_delta_with_gorillas_min_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_gorillas_min_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_gorillas_min_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_gorillas_min_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'avg' %}
        ((sum(${low_price_delta_with_gorillas_avg_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_gorillas_avg_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_gorillas_avg_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_gorillas_avg_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'gorillas'
       and competitor_price_value._parameter_value == 'max' %}
        ((sum(${low_price_delta_with_gorillas_max_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_gorillas_max_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_gorillas_max_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_gorillas_max_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'min' %}
        ((sum(${low_price_delta_with_rewe_min_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_rewe_min_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_rewe_min_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_rewe_min_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'avg' %}
        ((sum(${low_price_delta_with_rewe_avg_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_rewe_avg_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_rewe_avg_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_rewe_avg_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% elsif competitor._parameter_value == 'rewe'
       and competitor_price_value._parameter_value == 'max' %}
        ((sum(${low_price_delta_with_rewe_max_by_quantity_sold})/sum(${low_quantity_sold}))
        +(sum(${mid_price_delta_with_rewe_max_by_quantity_sold})/sum(${mid_quantity_sold}))
        +(sum(${high_price_delta_with_rewe_max_by_quantity_sold})/sum(${high_quantity_sold}))
        +(sum(${highest_price_delta_with_rewe_max_by_quantity_sold})/sum(${highest_quantity_sold}))
        ) / 4
    {% endif %};;
  }

}
