view: product_discounts_results {
  sql_table_name: `flink-data-prod.reporting.product_discounts_results`
  ;;
  # this view was created by Bruno Wolfram
  # it is based on the ticket https://goflink.atlassian.net/browse/DATA-6001
  # ... and aims to make it easier to check and compare for promotion performance

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: product_discount_name {
    type: string
    sql: ${TABLE}.product_discount_name;;
  }

  dimension: product_discount_type {
    type: string
    sql: ${TABLE}.product_discount_type;;
  }

  dimension: amt_relative_product_discount_percent {
    type: string
    sql: ${TABLE}.amt_relative_product_discount_percent;;
  }

  dimension: amt_absolute_product_discount {
    type: string
    sql: ${TABLE}.amt_absolute_product_discount;;
  }

  dimension: valid_from {
    type: date
    datatype: date
    sql:  ${TABLE}.valid_from;;
  }

  dimension: valid_until {
    type: date
    datatype: date
    sql:  ${TABLE}.valid_until;;
  }

  dimension: valid_from_bef_1tf {
    type: date
    datatype: date
    sql:  ${TABLE}.valid_from_bef_1tf;;
  }

  dimension: valid_until_bef_1tf {
    type: date
    datatype: date
    sql:  ${TABLE}.valid_until_bef_1tf;;
  }

  dimension: valid_from_bef_2tf {
    type: date
    datatype: date
    sql:  ${TABLE}.valid_from_bef_2tf;;
  }

  dimension: valid_until_bef_2tf {
    type: date
    datatype: date
    sql:  ${TABLE}.valid_until_bef_2tf;;
  }

  dimension: valid_from_bef_3tf {
    type: date
    datatype: date
    sql:  ${TABLE}.valid_from_bef_3tf;;
  }

  dimension: valid_until_bef_3tf {
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
    type: sum
    sql: ${TABLE}.quantity ;;
  }

  measure: quantity_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    type: sum
    sql: ${TABLE}.quantity_bef_1tf ;;
  }

  measure: quantity_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.quantity_bef_2tf ;;
  }

  measure: quantity_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.quantity_bef_3tf ;;
  }



  measure: amt_total_price_gross {
    group_label: "1. Promo timeframe - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_gross ;;
  }

  measure: amt_total_price_gross_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_gross_bef_1tf ;;
  }

  measure: amt_total_price_gross_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_gross_bef_2tf ;;
  }

  measure: amt_total_price_gross_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_gross_bef_3tf ;;
  }



  measure: amt_total_price_net {
    group_label: "1. Promo timeframe - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_net ;;
  }

  measure: amt_total_price_net_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_net_bef_1tf ;;
  }

  measure: amt_total_price_net_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_net_bef_2tf ;;
  }

  measure: amt_total_price_net_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_net_bef_3tf ;;
  }



  measure: amt_total_price_after_product_discount_gross {
    group_label: "1. Promo timeframe - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_gross ;;
  }

  measure: amt_total_price_after_product_discount_gross_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_gross_bef_1tf ;;
  }

  measure: amt_total_price_after_product_discount_gross_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_gross_bef_2tf ;;
  }

  measure: amt_total_price_after_product_discount_gross_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_gross_bef_3tf ;;
  }



  measure: amt_total_price_after_product_discount_net {
    group_label: "1. Promo timeframe - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_net ;;
  }

  measure: amt_total_price_after_product_discount_net_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_net_bef_1tf ;;
  }

  measure: amt_total_price_after_product_discount_net_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_net_bef_2tf ;;
  }

  measure: amt_total_price_after_product_discount_net_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_total_price_after_product_discount_net_bef_3tf ;;
  }



  measure: amt_pricing_cost_weighted_rolling_avg_net {
    group_label: "1. Promo timeframe - Sales"
    type: sum
    sql: ${TABLE}.amt_pricing_cost_weighted_rolling_avg_net ;;
  }

  measure: amt_pricing_cost_weighted_rolling_avg_net_bef_1tf {
    group_label: "2. One timeframe before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_pricing_cost_weighted_rolling_avg_net_bef_1tf ;;
  }

  measure: amt_pricing_cost_weighted_rolling_avg_net_bef_2tf {
    group_label: "3. Two timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_pricing_cost_weighted_rolling_avg_net_bef_2tf ;;
  }

  measure: amt_pricing_cost_weighted_rolling_avg_net_bef_3tf {
    group_label: "4. Three timeframes before promo - Sales"
    type: sum
    sql: ${TABLE}.amt_pricing_cost_weighted_rolling_avg_net_bef_3tf ;;
  }


 # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     OoS     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 # ~~~~~~~~~~~~~~~ Data regarding the orders the sku contains, to calculate AIV, quantity per order

  measure: number_of_hours_oos {
    group_label: "1. Promo timeframe - OoS"
    type: sum
    sql: ${TABLE}.number_of_hours_oos ;;
  }

  measure: number_of_hours_open {
    group_label: "1. Promo timeframe - OoS"
    type: sum
    sql: ${TABLE}.number_of_hours_open ;;
  }

  measure: number_of_hours_oos_bef_1tf {
    group_label: "2. One timeframe before promo - OoS"
    type: sum
    sql: ${TABLE}.number_of_hours_oos_bef_1tf ;;
  }

  measure: number_of_hours_open_1tf {
    group_label: "2. One timeframe before promo - OoS"
    type: sum
    sql: ${TABLE}.number_of_hours_open_1tf ;;
  }

  measure: number_of_hours_oos_bef_2tf {
    group_label: "3. Two timeframes before promo - OoS"
    type: sum
    sql: ${TABLE}.number_of_hours_oos_bef_2tf ;;
  }

  measure: number_of_hours_open_2tf {
    group_label: "3. Two timeframes before promo - OoS"
    type: sum
    sql: ${TABLE}.number_of_hours_open_2tf ;;
  }

  measure: number_of_hours_oos_bef_3tf {
    group_label: "4. Three timeframes before promo - OoS"
    type: sum
    sql: ${TABLE}.number_of_hours_oos_bef_3tf ;;
  }

  measure: number_of_hours_open_3tf {
    group_label: "4. Three timeframes before promo - OoS"
    type: sum
    sql: ${TABLE}.number_of_hours_open_3tf ;;
  }


 # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     Orders Including     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 # ~~~~~~~~~~~~~~~ Data regarding the orders the sku contains, to calculate AIV, quantity per order

  measure: number_of_items_aiv {
    group_label: "1. Promo timeframe - Orders including"
    type: sum
    sql: ${TABLE}.number_of_items_aiv ;;
  }

  measure: number_of_items_aiv_bef_1tf {
    group_label: "2. One timeframe before promo - Orders including"
    type: sum
    sql: ${TABLE}.number_of_items_aiv_bef_1tf ;;
  }

  measure: number_of_items_aiv_bef_2tf {
    group_label: "3. Two timeframes before promo - Orders including"
    type: sum
    sql: ${TABLE}.number_of_items_aiv_bef_2tf ;;
  }

  measure: number_of_items_aiv_bef_3tf {
    group_label: "4. Three timeframes before promo - Orders including"
    type: sum
    sql: ${TABLE}.number_of_items_aiv_bef_3tf ;;
  }



  measure: amt_gmv_gross_aiv {
    group_label: "1. Promo timeframe - Orders including"
    type: sum
    sql: ${TABLE}.amt_gmv_gross_aiv ;;
  }

  measure: amt_gmv_gross_aiv_bef_1tf {
    group_label: "2. One timeframe before promo - Orders including"
    type: sum
    sql: ${TABLE}.amt_gmv_gross_aiv_bef_1tf ;;
  }

  measure: amt_gmv_gross_aiv_bef_2tf {
    group_label: "3. Two timeframes before promo - Orders including"
    type: sum
    sql: ${TABLE}.amt_gmv_gross_aiv_bef_2tf ;;
  }

  measure: amt_gmv_gross_aiv_bef_3tf {
    group_label: "4. Three timeframes before promo - Orders including"
    type: sum
    sql: ${TABLE}.amt_gmv_gross_aiv_bef_3tf ;;
  }



  measure: count_order_aiv {
    group_label: "1. Promo timeframe - Orders including"
    type: sum
    sql: ${TABLE}.count_order_aiv ;;
  }

  measure: count_order_aiv_bef_1tf {
    group_label: "2. One timeframe before promo - Orders including"
    type: sum
    sql: ${TABLE}.count_order_aiv_bef_1tf ;;
  }

  measure: count_order_aiv_bef_2tf {
    group_label: "3. Two timeframes before promo - Orders including"
    type: sum
    sql: ${TABLE}.count_order_aiv_bef_2tf ;;
  }

  measure: count_order_aiv_bef_3tf {
    group_label: "4. Three timeframes before promo - Orders including"
    type: sum
    sql: ${TABLE}.count_order_aiv_bef_3tf ;;
  }


 # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     CVR     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 # ~~~~~~~~~~~~~~~ Data regarding impressions, for us to calculate CVR for added to cart and orderd

  measure: number_of_product_impressions {
    group_label: "1. Promo timeframe - CVR"
    type: sum
    sql: ${TABLE}.number_of_product_impressions ;;
  }

  measure: number_of_product_impressions_bef_1tf {
    group_label: "2. One timeframe before promo - CVR"
    type: sum
    sql: ${TABLE}.number_of_product_impressions_bef_1tf ;;
  }

  measure: number_of_product_impressions_bef_2tf {
    group_label: "3. Two timeframes before promo - CVR"
    type: sum
    sql: ${TABLE}.number_of_product_impressions_bef_2tf ;;
  }

  measure: number_of_product_impressions_bef_3tf {
    group_label: "4. Three timeframes before promo - CVR"
    type: sum
    sql: ${TABLE}.number_of_product_impressions_bef_3tf ;;
  }



  measure: number_of_product_add_to_carts {
    group_label: "1. Promo timeframe - CVR"
    type: sum
    sql: ${TABLE}.number_of_product_add_to_carts ;;
  }

  measure: number_of_product_add_to_carts_bef_1tf {
    group_label: "2. One timeframe before promo - CVR"
    type: sum
    sql: ${TABLE}.number_of_product_add_to_carts_bef_1tf ;;
  }

  measure: number_of_product_add_to_carts_bef_2tf {
    group_label: "3. Two timeframes before promo - CVR"
    type: sum
    sql: ${TABLE}.number_of_product_add_to_carts_bef_2tf ;;
  }

  measure: number_of_product_add_to_carts_bef_3tf {
    group_label: "4. Three timeframes before promo - CVR"
    type: sum
    sql: ${TABLE}.number_of_product_add_to_carts_bef_3tf ;;
  }



  measure: number_of_orders_placed {
    group_label: "1. Promo timeframe - CVR"
    type: sum
    sql: ${TABLE}.number_of_orders_placed ;;
  }

  measure: number_of_orders_placed_bef_1tf {
    group_label: "2. One timeframe before promo - CVR"
    type: sum
    sql: ${TABLE}.number_of_orders_placed_bef_1tf ;;
  }

  measure: number_of_orders_placed_bef_2tf {
    group_label: "3. Two timeframes before promo - CVR"
    type: sum
    sql: ${TABLE}.number_of_orders_placed_bef_2tf ;;
  }

  measure: number_of_orders_placed_bef_3tf {
    group_label: "4. Three timeframes before promo - CVR"
    type: sum
    sql: ${TABLE}.number_of_orders_placed_bef_3tf ;;
  }



}
