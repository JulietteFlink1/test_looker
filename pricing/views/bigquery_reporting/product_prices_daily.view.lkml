view: product_prices_daily {
  sql_table_name: `flink-data-prod.reporting.product_prices_daily`
    ;;

  # this view was created by Andreas Stueber
  # it is based on the ticket https://goflink.atlassian.net/browse/DATA-2816
  # ... and aims to provide all pricing data points per hub and sku - historically over time.

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: sku {

    label: "SKU"
    description: "The SKU is the Flink-internal identifier of a specific product"

    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: hub_code {

    label:        "Hub Code"
    description: "A hub is a warehouse, that Flink operates. A hub_code is the identifier of a warehouse"

    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: reporting {

    label:       "Price"
    description: "The date, a given price was set in a given hub"
    type: time
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.reporting_date ;;
  }

  # todo - might need a chane to boolean in dbt level
  dimension: is_discount_live {

    label:       "Is Discount Live"
    description: "A yes-no flag, that indicates, if a given price was discounted"

    type: string
    sql: safe_cast(${TABLE}.is_discount_live as boolean) ;;
  }

  dimension: is_published {

    label: "Is Published"
    description: "A yes-no flag, that indicates, whether the SKU was published in Commercetools (status of the end of the day)"
    type: yesno
    sql: ${TABLE}.is_published ;;
  }

  dimension: product_unit {

    label:       "Product Unit"
    description: "The product unit is the product’s weight or volume of the unit_of_measurement (e.g. 100 for a product that is 100g)"
    group_label: ">> Special Purpose"

    type: string
    sql: ${TABLE}.product_unit ;;
  }

  dimension: base_unit {

    label:       "Base Unit"
    description: "The base unit is the smallest number of a product that can be sold"
    group_label: ">> Special Purpose"

    type: string
    sql: ${TABLE}.base_unit ;;
  }

  dimension: unit_of_measure {

    label: "Unit of Measure"
    description: "The unit of measure refers to the unit, the product is typically valued in, e.g. kg, l, g"
    group_label: ">> Special Purpose"

    type: string
    sql: ${TABLE}.unit_of_measure ;;
  }

  dimension: max_single_order_quantity {
    label:       "MAX Single ORder Qunatity"
    description: "The maximum number of units that can be bought within one order"
    group_label: ">> Special Purpose"

    type: number
    sql: ${TABLE}.max_single_order_quantity ;;
  }



  # =========  hidden   =========

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: amt_deposit_price {
    type: number
    sql: ${TABLE}.amt_deposit_price ;;
    hidden: yes
  }

  dimension: avg_amt_discount_price {
    type: number
    sql: ${TABLE}.avg_amt_discount_price ;;
    hidden: yes
  }

  dimension: avg_amt_product_price_gross {
    type: number
    sql: ${TABLE}.avg_amt_product_price_gross ;;
    hidden: yes
  }

  dimension: buying_price {
    type: number
    sql: ${TABLE}.buying_price ;;
    required_access_grants: [can_view_buying_information]
    hidden: yes
  }

  dimension: max_amt_discount_price {
    type: number
    sql: ${TABLE}.max_amt_discount_price ;;
    hidden: yes
  }

  dimension: max_amt_product_price_gross {
    type: number
    sql: ${TABLE}.max_amt_product_price_gross ;;
    hidden: yes
  }

  dimension: min_amt_discount_price {
    type: number
    sql: ${TABLE}.min_amt_discount_price ;;
    hidden: yes
  }

  dimension: min_amt_product_price_gross {
    type: number
    sql: ${TABLE}.min_amt_product_price_gross ;;
    hidden: yes
  }

  # ------- calculated dimensions
  dimension: avg_amt_selling_price {
    type: number
    sql: coalesce(${avg_amt_discount_price}, ${avg_amt_product_price_gross}) ;;
    hidden: yes
  }

  dimension: min_amt_selling_price {
    type: number
    sql: coalesce(${min_amt_discount_price}, ${min_amt_product_price_gross}) ;;
    hidden: yes
  }

  dimension: max_amt_selling_price {
    type: number
    sql: coalesce(${max_amt_discount_price}, ${max_amt_product_price_gross}) ;;
    hidden: yes
  }


  dimension: avg_amt_margin {
    type: number
    sql: case
            when ${avg_amt_selling_price} is not null
             and ${buying_price} is not null
            then ${avg_amt_selling_price} - ${buying_price}
          end
            ;;
  required_access_grants: [can_view_buying_information]
  hidden: yes
  }



  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: price_id {

    label:       "Price ID"
    description: "The ID of a given price"
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.price_id ;;
  }

  dimension: product_discount_id {

    label:       "Product Discount ID"
    description: "The ID of a given product discount"
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.product_discount_id ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Default Price
  measure: max_max_amt_product_price_gross {

    label:       "MAX Default Product Price Gross"
    description: "The product price gross (the maximum price per day and hub) represents the base or default price of a unit. In case of a discount, it is the price that is shown with strikethrough formatting"
    group_label: "Product Default Price Gross"

    type: max
    sql: ${max_amt_product_price_gross} ;;
    value_format_name: decimal_4
  }

  measure: min_min_amt_product_price_gross {

    label:       "MIN Default Product Price Gross"
    description: "The product price gross (the minimum price per day and hub) represents the base or default price of a unit. In case of a discount, it is the price that is shown with strikethrough formatting"
    group_label: "Product Default Price Gross"

    type: min
    sql: ${min_amt_product_price_gross} ;;
    value_format_name: decimal_4
  }

  measure: avg_avg_amt_product_price_gross {

    label:       "AVG Default Product Price Gross"
    description: "The product price gross (the average price per day and hub) represents the base or default price of a unit. In case of a discount, it is the price that is shown with strikethrough formatting"
    group_label: "Product Default Price Gross"

    type: average
    sql: ${avg_amt_product_price_gross} ;;
    value_format_name: decimal_4
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Selling Price

  measure: max_max_amt_selling_price  {

    label:       "MAX Selling Product Price Gross"
    description: "The price relates to the actual selling price (the maximum price per day and hub) of a product in a given day in time per hub."
    group_label: "Product Selling Price Gross"

    type: max
    sql: ${max_amt_selling_price} ;;
    value_format_name: decimal_4
  }

  measure: avg_avg_amt_selling_price  {

    label:       "AVG Selling Product Price Gross"
    description: "The price relates to the actual selling price (the average price per day and hub) of a product in a given day in time per hub."
    group_label: "Product Selling Price Gross"

    type: average
    sql: ${avg_amt_selling_price} ;;
    value_format_name: decimal_4
  }

  measure: min_min_amt_selling_price  {

    label:       "MIN Selling Product Price Gross"
    description: "The price relates to the actual selling price (the minimum price per day and hub) of a product in a given day in time per hub."
    group_label: "Product Selling Price Gross"

    type: min
    sql: ${min_amt_selling_price} ;;
    value_format_name: decimal_4
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Discounted Price
  measure: max_max_amt_discount_price {

    label:       "MAX Discounted Product Price Gross"
    description: "The discounted product price gross (the maximum price per day and hub) represents the reduced prie of a unit users can see in the app, if Flink offers a discount (below the strikethrough price). IMPORTANT: this field is only set, when a discount was active"
    group_label: "Product Discount Price Gross"

    type: max
    sql: ${max_amt_discount_price} ;;
    value_format_name: decimal_4
  }

  measure: min_min_amt_discount_price {

    label:       "MIN Discounted Product Price Gross"
    description: "The discounted product price gross (the minimum price per day and hub) represents the reduced prie of a unit users can see in the app, if Flink offers a discount (below the strikethrough price). IMPORTANT: this field is only set, when a discount was active"
    group_label: "Product Discount Price Gross"

    type: max
    sql: ${min_amt_discount_price} ;;
    value_format_name: decimal_4
  }

  measure: avg_avg_amt_discount_price {

    label:       "AVG Discounted Product Price Gross"
    description: "The discounted product price gross (the average price per day and hub) represents the reduced prie of a unit users can see in the app, if Flink offers a discount (below the strikethrough price). IMPORTANT: this field is only set, when a discount was active"
    group_label: "Product Discount Price Gross"

    type: max
    sql: ${avg_amt_discount_price} ;;
    value_format_name: decimal_4
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Deposit
  measure:  avg_amt_deposit_price{

    label:       "AVG Deposit"
    description: "The average of all deposit prices. If a product has no deposit, this field is empty and does not contribute to the average"

    type: average
    sql: ${amt_deposit_price} ;;
    value_format_name: decimal_4
  }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Buying Price
  measure:  avg_buying_price{

    label:       "AVG Vendor Price"
    description: "The average buying price of a product, that Flink pays to its vendor"
    required_access_grants: [can_view_buying_information]

    type: average
    sql: ${buying_price} ;;
    value_format_name: decimal_4
  }


}
