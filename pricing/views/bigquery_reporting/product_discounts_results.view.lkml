view: product_discounts_results {
  sql_table_name: `flink-data-prod.reporting.product_discounts_results`
  ;;
  # this view was created by Bruno Wolfram - July.23
  # it is based on the ticket https://goflink.atlassian.net/browse/DATA-6001
  # ... and aims to make it easier to check and compare for promotion performance

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: country_iso {
    label: "Country"
    description: "Geographic Dimensions"
    type: string
    sql: ${TABLE}.country_iso;;
  }

  dimension: hub_code {
    label: "Hub Code"
    description: "A hub is a warehouse, that Flink operates. A hub_code is the identifier of a warehouse"
    type: string
    sql: ${TABLE}.hub_code;;
  }

  dimension: sku {
    label: "SKU"
    description: "The SKU is the Flink-internal identifier of a specific product"
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: product_discount_name {
    label: "Product discount name"
    group_label: ">Discount dimensions"
    description: "The name given to the discount"
    type: string
    sql: ${TABLE}.product_discount_name;;
  }

  dimension: product_discount_type {
    label: "Product discount type"
    group_label: ">Discount dimensions"
    description: "If the discount has relative(%) or absolut(€) discount"
    type: string
    sql: ${TABLE}.product_discount_type;;
  }

  dimension: amt_relative_product_discount_percent {
    label: "Relative product discount percentage"
    group_label: ">Discount dimensions"
    description: "If the discount has relative discount, it indicates the percentage"
    type: string
    sql: ${TABLE}.amt_relative_product_discount_percent;;
  }

  dimension: amt_absolute_product_discount {
    label: "Absolut product discount amount"
    group_label: ">Discount dimensions"
    description: "If the discount has absolute discount, it indicates the amount"
    type: string
    sql: ${TABLE}.amt_absolute_product_discount;;
  }

  dimension: valid_from {
    label: "Discount starting date"
    group_label: ">Dates"
    description: "Date the discount started"
    type: date
    datatype: date
    sql:  ${TABLE}.valid_from;;
  }

  dimension: valid_until {
    label: "Discount ending date"
    group_label: ">Dates"
    description: "Date the discount ended"
    type: date
    datatype: date
    sql:  ${TABLE}.valid_until;;
  }

  dimension: valid_from_bef_1tf {
    label: "Starting date - 1 timeframe before"
    group_label: ">Dates"
    description: "Starting date of the controle timeframe, 1 timeframe before"
    type: date
    datatype: date
    sql:  ${TABLE}.valid_from_bef_1tf;;
  }

  dimension: valid_until_bef_1tf {
    label: "Ending date - 1 timeframe before"
    group_label: ">Dates"
    description: "Ending date of the controle timeframe, 1 timeframe before"
    type: date
    datatype: date
    sql:  ${TABLE}.valid_until_bef_1tf;;
  }

  dimension: valid_from_bef_2tf {
    label: "Starting date - 2 timeframes before"
    group_label: ">Dates"
    description: "Starting date of the controle timeframe, 2 timeframes before"
    type: date
    datatype: date
    sql:  ${TABLE}.valid_from_bef_2tf;;
  }

  dimension: valid_until_bef_2tf {
    label: "Ending date - 2 timeframes before"
    group_label: ">Dates"
    description: "Ending date of the controle timeframe, 2 timeframes before"
    type: date
    datatype: date
    sql:  ${TABLE}.valid_until_bef_2tf;;
  }

  dimension: valid_from_bef_3tf {
    label: "Starting date - 3 timeframes before"
    group_label: ">Dates"
    description: "Starting date of the controle timeframe, 3 timeframes before"
    type: date
    datatype: date
    sql:  ${TABLE}.valid_from_bef_3tf;;
  }

  dimension: valid_until_bef_3tf {
    label: "Ending date - 3 timeframes before"
    group_label: ">Dates"
    description: "Ending date of the controle timeframe, 3 timeframes before"
    type: date
    datatype: date
    sql: ${TABLE}.valid_until_bef_3tf;;
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


 # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     Sales     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 # ~~~~~~~~~~~~~~~ Data regarding sales (quantity, revenue, profit, margin)

  measure: quantity {
    group_label: "1. Promo timeframe - Sales"
    label: "Quantity Sold"
    description: "Fulfilled Quantity"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.quantity ;;
  }

  measure: quantity_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    label: "Quantity Sold - 1 timeframe before"
    description: "Fulfilled Quantity - 1 timeframe before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.quantity_bef_1tf ;;
  }

  measure: quantity_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    label: "Quantity Sold - 2 timeframes before"
    description: "Fulfilled Quantity - 2 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.quantity_bef_2tf ;;
  }

  measure: quantity_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    label: "Quantity Sold - 3 timeframes before"
    description: "Fulfilled Quantity - 3 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.quantity_bef_3tf ;;
  }



  measure: amt_total_price_gross {
    group_label: "1. Promo timeframe - Sales"
    label: "Total Price Gross"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_gross ;;
  }

  measure: amt_total_price_gross_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    label: "Total Price Gross - 1 timeframe before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_gross_bef_1tf ;;
  }

  measure: amt_total_price_gross_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    label: "Total Price Gross - 2 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_gross_bef_2tf ;;
  }

  measure: amt_total_price_gross_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    label: "Total Price Gross - 3 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_gross_bef_3tf ;;
  }



  measure: amt_total_price_net {
    group_label: "1. Promo timeframe - Sales"
    label: "Total Price Net"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_net ;;
  }

  measure: amt_total_price_net_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    label: "Total Price Net - 1 timeframe before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_net_bef_1tf ;;
  }

  measure: amt_total_price_net_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    label: "Total Price Net - 2 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_net_bef_2tf ;;
  }

  measure: amt_total_price_net_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    label: "Total Price Net - 3 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_net_bef_3tf ;;
  }



  measure: amt_total_price_after_product_discount_gross {
    group_label: "1. Promo timeframe - Sales"
    label: "Total Price Gross (After Product Discount)"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_gross ;;
  }

  measure: amt_total_price_after_product_discount_gross_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    label: "Total Price Gross (After Product Discount) - 1 timeframe before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_gross_bef_1tf ;;
  }

  measure: amt_total_price_after_product_discount_gross_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    label: "Total Price Gross (After Product Discount) - 2 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_gross_bef_2tf ;;
  }

  measure: amt_total_price_after_product_discount_gross_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    label: "Total Price Gross (After Product Discount) - 3 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_gross_bef_3tf ;;
  }



  measure: amt_total_price_after_product_discount_net {
    group_label: "1. Promo timeframe - Sales"
    label: "Total Price Net (After Product Discount)"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_net ;;
  }

  measure: amt_total_price_after_product_discount_net_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    label: "Total Price Net (After Product Discount) - 1 timeframe before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_net_bef_1tf ;;
  }

  measure: amt_total_price_after_product_discount_net_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    label: "Total Price Net (After Product Discount) - 2 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_net_bef_2tf ;;
  }

  measure: amt_total_price_after_product_discount_net_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    label: "Total Price Net (After Product Discount) - 3 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_net_bef_3tf ;;
  }



  measure: amt_pricing_cost_weighted_rolling_avg_net {
    group_label: "1. Promo timeframe - Sales"
    label: "Buying Price (Net)"
    description: "Buying price, that can be used for product sales. It resembles the weighted buying price of the current stock. This is done (in Oracle) to ensure that we value the inventory at any given day with the average value of our current stock (and not with the most recent buying price to place a supplier order). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_pricing_cost_weighted_rolling_avg_net ;;
  }

  measure: amt_pricing_cost_weighted_rolling_avg_net_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    label: "Buying Price (Net) - 1 timeframe before"
    value_format_name: euro_accounting_2_precision
   type: sum
    sql: ${TABLE}.amt_pricing_cost_weighted_rolling_avg_net_bef_1tf ;;
  }

  measure: amt_pricing_cost_weighted_rolling_avg_net_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    label: "Buying Price (Net) - 2 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_pricing_cost_weighted_rolling_avg_net_bef_2tf ;;
  }

  measure: amt_pricing_cost_weighted_rolling_avg_net_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    label: "Buying Price (Net) - 3 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_pricing_cost_weighted_rolling_avg_net_bef_3tf ;;
  }


 # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     OoS     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 # ~~~~~~~~~~~~~~~ Data regarding the orders the sku contains, to calculate AIV, quantity per order

  measure: number_of_hours_oos {
    group_label: "1. Promo timeframe - OoS"
    label: "Number of hours Out of Stock"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_hours_oos ;;
  }

  measure: number_of_hours_open {
    group_label: "1. Promo timeframe - OoS"
    label: "Number of hours Open"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_hours_open ;;
  }

  measure: number_of_hours_oos_bef_1tf {
    group_label: "2. One timeframe before promo - OoS"
    label: "Number of hours Out of Stock - 1 timeframe before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_hours_oos_bef_1tf ;;
  }

  measure: number_of_hours_open_1tf {
    group_label: "2. One timeframe before promo - OoS"
    label: "Number of hours Open - 1 timeframe before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_hours_open_1tf ;;
  }

  measure: number_of_hours_oos_bef_2tf {
    group_label: "3. Two timeframes before promo - OoS"
    label: "Number of hours Out of Stock - 2 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_hours_oos_bef_2tf ;;
  }

  measure: number_of_hours_open_2tf {
    group_label: "3. Two timeframes before promo - OoS"
    label: "Number of hours Open - 2 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_hours_open_2tf ;;
  }

  measure: number_of_hours_oos_bef_3tf {
    group_label: "4. Three timeframes before promo - OoS"
    label: "Number of hours Out of Stock - 3 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_hours_oos_bef_3tf ;;
  }

  measure: number_of_hours_open_3tf {
    group_label: "4. Three timeframes before promo - OoS"
    label: "Number of hours Open - 3 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_hours_open_3tf ;;
  }


 # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     Orders Including     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 # ~~~~~~~~~~~~~~~ Data regarding the orders the sku contains, to calculate AIV, quantity per order

  measure: number_of_items_aiv {
    group_label: "1. Promo timeframe - Orders including"
    label: "Number of items in orders"
    description: "Number of items in orders containing the filtered condition - if more than one SKU is filtered, orders can be considered more than once"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_items_aiv ;;
  }

  measure: number_of_items_aiv_bef_1tf {
    group_label: "2. One timeframe before promo - Orders including"
    label: "Number of items in orders - 1 timeframe before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_items_aiv_bef_1tf ;;
  }

  measure: number_of_items_aiv_bef_2tf {
    group_label: "3. Two timeframes before promo - Orders including"
    label: "Number of items in orders - 2 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_items_aiv_bef_2tf ;;
  }

  measure: number_of_items_aiv_bef_3tf {
    group_label: "4. Three timeframes before promo - Orders including"
    label: "Number of items in orders - 3 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_items_aiv_bef_3tf ;;
  }



  measure: amt_gmv_gross_aiv {
    group_label: "1. Promo timeframe - Orders including"
    label: "GMV from orders"
    description: "GMV from orders containing the filtered condition - if more than one SKU is filtered, orders can be considered more than once"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_gmv_gross_aiv ;;
  }

  measure: amt_gmv_gross_aiv_bef_1tf {
    group_label: "2. One timeframe before promo - Orders including"
    label: "GMV from orders - 1 timeframe before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_gmv_gross_aiv_bef_1tf ;;
  }

  measure: amt_gmv_gross_aiv_bef_2tf {
    group_label: "3. Two timeframes before promo - Orders including"
    label: "GMV from orders - 2 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_gmv_gross_aiv_bef_2tf ;;
  }

  measure: amt_gmv_gross_aiv_bef_3tf {
    group_label: "4. Three timeframes before promo - Orders including"
    label: "GMV from orders - 3 timeframes before"
    value_format_name: euro_accounting_2_precision
    type: sum
    sql: ${TABLE}.amt_gmv_gross_aiv_bef_3tf ;;
  }



  measure: count_order_aiv {
    group_label: "1. Promo timeframe - Orders including"
    label: "Number of orders"
    description: "Number of orders containing the filtered condition - if more than one SKU is filtered, orders can be considered more than once"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.count_order_aiv ;;
  }

  measure: count_order_aiv_bef_1tf {
    group_label: "2. One timeframe before promo - Orders including"
    label: "Number of orders - 1 timeframe before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.count_order_aiv_bef_1tf ;;
  }

  measure: count_order_aiv_bef_2tf {
    group_label: "3. Two timeframes before promo - Orders including"
    label: "Number of orders - 2 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.count_order_aiv_bef_2tf ;;
  }

  measure: count_order_aiv_bef_3tf {
    group_label: "4. Three timeframes before promo - Orders including"
    label: "Number of orders - 3 timeframes before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.count_order_aiv_bef_3tf ;;
  }


 # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     CVR     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 # ~~~~~~~~~~~~~~~ Data regarding impressions, for us to calculate CVR for added to cart and orderd

  measure: number_of_product_impressions {
    group_label: "1. Promo timeframe - CVR"
    label: "Number of impressions"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_product_impressions ;;
  }

  measure: number_of_product_impressions_bef_1tf {
    group_label: "2. One timeframe before promo - CVR"
    label: "Number of impressions - 1 timeframe  before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_product_impressions_bef_1tf ;;
  }

  measure: number_of_product_impressions_bef_2tf {
    group_label: "3. Two timeframes before promo - CVR"
    label: "Number of impressions - 2 timeframes  before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_product_impressions_bef_2tf ;;
  }

  measure: number_of_product_impressions_bef_3tf {
    group_label: "4. Three timeframes before promo - CVR"
    label: "Number of impressions - 3 timeframes  before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_product_impressions_bef_3tf ;;
  }



  measure: number_of_product_add_to_carts {
    group_label: "1. Promo timeframe - CVR"
    label: "Number of add to cart events"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_product_add_to_carts ;;
  }

  measure: number_of_product_add_to_carts_bef_1tf {
    group_label: "2. One timeframe before promo - CVR"
    label: "Number of add to cart events - 1 timeframe  before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_product_add_to_carts_bef_1tf ;;
  }

  measure: number_of_product_add_to_carts_bef_2tf {
    group_label: "3. Two timeframes before promo - CVR"
    label: "Number of add to cart events - 2 timeframes  before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_product_add_to_carts_bef_2tf ;;
  }

  measure: number_of_product_add_to_carts_bef_3tf {
    group_label: "4. Three timeframes before promo - CVR"
    label: "Number of add to cart events - 3 timeframes  before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_product_add_to_carts_bef_3tf ;;
  }



  measure: number_of_orders_placed {
    group_label: "1. Promo timeframe - CVR"
    label: "Number of orders placed"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_orders_placed ;;
  }

  measure: number_of_orders_placed_bef_1tf {
    group_label: "2. One timeframe before promo - CVR"
    label: "Number of orders placed - 1 timeframe  before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_orders_placed_bef_1tf ;;
  }

  measure: number_of_orders_placed_bef_2tf {
    group_label: "3. Two timeframes before promo - CVR"
    label: "Number of orders placed - 2 timeframes  before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_orders_placed_bef_2tf ;;
  }

  measure: number_of_orders_placed_bef_3tf {
    group_label: "4. Three timeframes before promo - CVR"
    label: "Number of orders placed - 3 timeframes  before"
    value_format_name: "decimal_0"
    type: sum
    sql: ${TABLE}.number_of_orders_placed_bef_3tf ;;
  }



}
