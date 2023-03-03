# Owner: Brandon Beckett & Kristina Voloshina
# Created: 2023-02-14

# This view contains the reporting layer data for Flink's published and currently active assortment along with all compteitor product matches that exist & their prices & price differences from Flink.

view: flink_to_competitors_prices {
  view_label: "Flink to Competitor Prices"
  sql_table_name: `flink-data-prod.reporting.flink_to_competitors_prices`
    ;;

# ===========  Metadata  ===========

  dimension: table_uuid {

    label: "Table UUID"
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    group_label: "Metadata"

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

  dimension: min_flink_price {

    label: "Lowest Flink Price"
    description: "Lowest available price of the product before discount (including VAT)."
    group_label: "Flink"

    type: number
    sql: ${TABLE}.min_flink_price ;;
  }

  dimension: max_flink_price {

    label: "Highest Flink Price"
    description: "Highest available price of the product before discount (including VAT)."
    group_label: "Flink"

    type: number
    sql: ${TABLE}.max_flink_price ;;
  }


# ===========  Albert Heijn  ===========

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
    sql: ${TABLE}.min_ah_price ;;
  }

  dimension: max_ah_price {

    label: "Highest Price - AH"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "Albert Heijn"

    type: number
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

  dimension: min_price_dif_ah {

    label: "Lowest Price Delta - AH"
    description: "The difference between Flink's lowest product price and the competitor's lowest product price."
    group_label: "Albert Heijn"

    type: number
    sql: ${TABLE}.min_price_dif_ah ;;
  }

  dimension: max_price_dif_ah {

    label: "Highest Price Delta - AH"
    description: "The difference between Flink's highest product price and the competitor's highest product price."
    group_label: "Albert Heijn"

    type: number
    sql: ${TABLE}.max_price_dif_ah ;;
  }


# ===========  Carrefour City  ===========

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
    sql: ${TABLE}.min_carrefour_city_price ;;
  }

  dimension: max_carrefour_city_price {

    label: "Highest Price - CRF City"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "Carrefour City"

    type: number
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

  dimension: min_price_dif_carrefour_city {

    label: "Lowest Price Delta - CRF City"
    description: "The difference between Flink's lowest product price and the competitor's lowest product price."
    group_label: "Carrefour City"

    type: number
    sql: ${TABLE}.min_price_dif_carrefour_city ;;
  }

  dimension: max_price_dif_carrefour_city {

    label: "Highest Price Delta - CRF City"
    description: "The difference between Flink's highest product price and the competitor's highest product price."
    group_label: "Carrefour City"

    type: number
    sql: ${TABLE}.max_price_dif_carrefour_city ;;
  }


# ===========  Getir  ===========

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
    sql: ${TABLE}.min_getir_price ;;
  }

  dimension: max_getir_price {

    label: "Highest Price - Getir"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "Getir"

    type: number
    sql: ${TABLE}.max_getir_price ;;
  }

  dimension: is_getir_prices_converted {

    label: "Is Price Converted - Getir"
    description: "Yes, if the competitor price has been converted by the price conversion factor."
    group_label: "Getir"

    type: yesno
    sql: ${TABLE}.is_getir_prices_converted ;;
  }

  dimension: min_price_dif_getir {

    label: "Lowest Price Delta - Getir"
    description: "The difference between Flink's lowest product price and the competitor's lowest product price."
    group_label: "Getir"

    type: number
    sql: ${TABLE}.min_price_dif_getir ;;
  }

  dimension: max_price_dif_getir {

    label: "Highest Price Delta - Getir"
    description: "The difference between Flink's highest product price and the competitor's highest product price."
    group_label: "Getir"

    type: number
    sql: ${TABLE}.max_price_dif_getir ;;
  }


# ===========  Gorillas  ===========

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
    sql: ${TABLE}.min_gorillas_price ;;
  }

  dimension: max_gorillas_price {

    label: "Highest Price - Gorillas"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "Gorillas"

    type: number
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

  dimension: min_price_dif_gorillas {

    label: "Lowest Price Delta - Gorillas"
    description: "The difference between Flink's lowest product price and the competitor's lowest product price."
    group_label: "Gorillas"

    type: number
    sql: ${TABLE}.min_price_dif_gorillas ;;
  }

  dimension: max_price_dif_gorillas {

    label: "Highest Price Delta - Gorillas"
    description: "The difference between Flink's highest product price and the competitor's highest product price."
    group_label: "Gorillas"

    type: number
    sql: ${TABLE}.max_price_dif_gorillas ;;
  }


# ===========  REWE  ===========

  dimension: rewe_product_id {

    label: "Product ID - REWE"
    description: "A competitor's unique ID assigned to each product. Similar to Flink's SKU."
    group_label: "REWE"

    type: string
    sql: ${TABLE}.rewe_product_id ;;
  }

  dimension: rewe_product_name {

    label: "Product Name - REWE"
    description: "The product name and unit size provided by the competitor."
    group_label: "REWE"

    type: string
    sql: ${TABLE}.rewe_product_name ;;
  }

  dimension: rewe_match_type {

    label: "Match Type - REWE"
    description: "The type of match between a Flink and a competitor product. Can be a manual match (strongest), EAN or NAN match, or a fuzzy product name match (weakest)."
    group_label: "REWE"

    type: string
    sql: ${TABLE}.rewe_match_type ;;
  }

  dimension: rewe_match_score {

    label: "Match Score - REWE"
    description: "A score ranging from -3.0 to 100.0 to represent the quality of a match between a Flink and a competitor product. Higher score = better match, lower score = worse match."
    group_label: "REWE"

    type: number
    sql: ${TABLE}.rewe_match_score ;;
  }

  dimension: min_rewe_price {

    label: "Lowest Price - REWE"
    description: "Competitor's lowest available price of the product before discount (including VAT)."
    group_label: "REWE"

    type: number
    sql: ${TABLE}.min_rewe_price ;;
  }

  dimension: max_rewe_price {

    label: "Highest Price - REWE"
    description: "Competitor's highest available price of the product before discount (including VAT)."
    group_label: "REWE"

    type: number
    sql: ${TABLE}.max_rewe_price ;;
  }

  dimension: rewe_conversion_factor {

    label: "Conversion Factor - REWE"
    description: "A multiplier to convert a competitor price to represent an equivalent price to Flink's product price based on product unit size differences if they exist."
    group_label: "REWE"

    type: number
    sql: ${TABLE}.rewe_conversion_factor ;;
  }

  dimension: is_rewe_prices_converted {

    label: "Is Price Converted - REWE"
    description: "Yes, if the competitor price has been converted by the price conversion factor."
    group_label: "REWE"

    type: yesno
    sql: ${TABLE}.is_rewe_prices_converted ;;
  }

  dimension: min_price_dif_rewe {

    label: "Lowest Price Delta - REWE"
    description: "The difference between Flink's lowest product price and the competitor's lowest product price."
    group_label: "REWE"

    type: number
    sql: ${TABLE}.min_price_dif_rewe ;;
  }

  dimension: max_price_dif_rewe {

    label: "Highest Price Delta - REWE"
    description: "The difference between Flink's highest product price and the competitor's highest product price."
    group_label: "REWE"

    type: number
    sql: ${TABLE}.max_price_dif_rewe ;;
  }

}
