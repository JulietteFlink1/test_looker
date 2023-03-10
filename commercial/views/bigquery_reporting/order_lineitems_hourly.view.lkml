view: order_lineitems_hourly {
  sql_table_name: `flink-data-dev.dbt_astueber_reporting.order_lineitems_hourly`
    ;;


  dimension_group: order {
    label: "Order"
    description: "Date on which the order was placed (local timezone)."
    type: time
    datatype: date
    timeframes: [
      raw,
      date,
      day_of_week,
      week,
      month
    ]
    sql: ${TABLE}.order_date ;;
    hidden: no
  }


  dimension: country_iso {
    label: "Country Iso"
    description: "Country ISO based on 'hub_code'."
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: no
  }


  dimension: hub_code {
    label: "Hub Code"
    description: "Code of a hub identical to back-end source tables."
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: no
  }


  dimension: turf_name {
    label: "Turf Name"
    description: "Name of the turf to which the order was assigned. If a hub has multiple turfs, this reflects the turf which covers the customer location. e.g. core, turf12, turf20"
    type: string
    sql: ${TABLE}.turf_name ;;
    hidden: no
  }


  dimension: sku {
    label: "Sku"
    description: "SKU of the product, as available in the backend."
    type: string
    sql: ${TABLE}.sku ;;
    hidden: no
  }


  dimension: is_external_order {
    label: "Is External Order"
    description: "TRUE if the order was created through an external provider (uber eats, doordash)."
    type: yesno
    sql: ${TABLE}.is_external_order ;;
    hidden: no
  }


  dimension: is_successful_order {
    label: "Is Successful Order"
    description: "TRUE if an order was successful. We consider successful the following:
    For CT: the status of the order is 'Complete'.
    For Saleor: the status of the order is 'Fulfilled' or 'Partially Fulfilled'."
    type: yesno
    sql: ${TABLE}.is_successful_order ;;
    hidden: no
  }


  dimension: has_sold_item_cost_data {
    label: "Has Sold Item Cost Data"
    description: "True, if a transaction can be related to a cost-data point from Oracle"
    type: yesno
    sql: ${TABLE}.has_sold_item_cost_data;;
    hidden: no
  }

  dimension: has_vendor_price{
    type: string
    sql: if(${has_sold_item_cost_data} = True, 'Yes', null) ;;
  }



  dimension: has_sold_item_discounts {
    label: "Has Sold Item Discounts"
    description: "True, if a transaction had discounts included"
    type: yesno
    sql: ${TABLE}.has_sold_item_discounts ;;
    hidden: no
  }


  dimension: number_of_items_sold {
    label: "Number Of Items Sold"
    description: "Quantity of units sold."
    type: number
    sql: ${TABLE}.number_of_items_sold ;;
    hidden: no
  }


  dimension: amt_total_price_gross {
    label: "Sum Amt Total Price Gross"
    description: "Amount of value of items (incl. VAT). It excludes fees (gross), and is before deducting discounts.
    See {here}(https://goflink.atlassian.net/wiki/spaces/DATA/pages/383746384/Financial+KPIs) for more information."
    type: number
    sql: ${TABLE}.sum_amt_total_price_gross ;;
    hidden: no
  }


  dimension: amt_total_price_net {
    label: "Sum Amt Total Price Net"
    description: "Amount of total price items, calculated as unit price per item \* quantity. Used for net AIV calculation."
    type: number
    sql: ${TABLE}.sum_amt_total_price_net ;;
    hidden: no
  }


  dimension: amt_total_cost_net {
    label: "Sum Amt Total Cost Net"
    description: "Aggregated sum of net costs of sold items"
    type: number
    sql: ${TABLE}.sum_amt_total_cost_net ;;
    hidden: no
  }


  dimension: amt_margin_net {
    label: "Sum Amt Margin Net"
    description: "Aggregated sum of product margins"
    type: number
    sql: ${TABLE}.sum_amt_margin_net ;;
    hidden: no
  }


  dimension: pct_unit_margin {
    label: "Avg Pct Unit Margin"
    description: "Aggregated average margin per product unit"
    type: number
    sql: ${TABLE}.avg_pct_unit_margin ;;
    hidden: no
  }


  dimension: amt_total_price_after_product_discount_gross {
    label: "Sum Amt Total Price After Product Discount Gross"
    description: "Amount of value of items (incl. VAT). It excludes fees (gross), and is after deducting product discounts.
    See {here}(https://goflink.atlassian.net/wiki/spaces/DATA/pages/383746384/Financial+KPIs) for more information."
    type: number
    sql: ${TABLE}.sum_amt_total_price_after_product_discount_gross ;;
    hidden: no
  }


  dimension: amt_total_price_after_product_discount_net {
    label: "Sum Amt Total Price After Product Discount Net"
    description: "Amount of value of items (excl. VAT). It excludes fees, and is after deducting product discounts.
    See {here}(https://goflink.atlassian.net/wiki/spaces/DATA/pages/383746384/Financial+KPIs) for more information."
    type: number
    sql: ${TABLE}.sum_amt_total_price_after_product_discount_net ;;
    hidden: no
  }


  dimension: amt_discount_products_gross {
    label: "Sum Amt Discount Products Gross"
    description: "Total Product discount amount applied to the order, Gross."
    type: number
    sql: ${TABLE}.sum_amt_discount_products_gross ;;
    hidden: no
  }


  dimension: amt_discount_products_net {
    label: "Sum Amt Discount Products Net"
    description: "Total Product discount amount applied to the order, Net."
    type: number
    sql: ${TABLE}.sum_amt_discount_products_net ;;
    hidden: no
  }


  dimension: amt_margin_after_product_discount_net {
    label: "Sum Amt Margin After Product Discount Net"
    description: "The sum of product margins, whereby the discounted product prices was used and substracted by the products weighted average unit costs"
    type: number
    sql: ${TABLE}.sum_amt_margin_after_product_discount_net ;;
    hidden: no
  }

  dimension: external_provider {
    label: "External Provider"
    description: "Name of an external provider: uber eats, doordash."
    type: string
    sql: ${TABLE}.external_provider ;;
    hidden: no
  }

  measure: count {
    type: count
    drill_fields: [turf_name]
  }

  measure: sum_amt_discount_products_net {
    type: sum
    sql: ${amt_discount_products_net} ;;
  }

  measure: sum_amt_discount_products_gross {
    type: sum
    sql: ${amt_discount_products_gross} ;;
  }

  measure: sum_amt_margin_net {
    type: sum
    sql: ${amt_margin_net} ;;
  }

  measure: sum_amt_total_price_net {
    type: sum
    sql: ${amt_total_price_net} ;;
  }

  measure: sum_amt_total_price_gross {
    type: sum
    sql: ${amt_total_price_gross} ;;
  }

  measure: sum_amt_total_price_after_product_discount_gross {
    type: sum
    sql: ${amt_total_price_after_product_discount_gross} ;;
  }

  measure: sum_amt_total_price_after_product_discount_net {
    type: sum
    sql: ${amt_total_price_after_product_discount_net} ;;
  }

  measure: sum_number_of_items_sold {
    type: sum
    sql: ${number_of_items_sold} ;;
  }

  measure: sum_amt_total_cost_net {
    type: sum
    sql: ${amt_total_cost_net} ;;
  }

  measure: sum_amt_margin_after_product_discount_net {
    type: sum
    sql: ${amt_margin_after_product_discount_net} ;;
  }

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: date {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${order_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${order_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${order_month}
    {% endif %};;
  }

#        'orders_cl.cnt_orders',
  measure: pct_total_margin_relative {
    label: "% Blended Margin"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold (Net)"
    type: number
    sql: ${sum_amt_margin_net} / nullif( ${sum_amt_total_price_net} ,0);;
    value_format_name: percent_1
  }

}
