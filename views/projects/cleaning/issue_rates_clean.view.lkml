view: issue_rates_clean {
  derived_table: {
    sql:
        select
          order_date as date,
          hub_code,
          sum(number_of_orders_wrong_order)               as wrong_order,
          sum(number_of_order_lineitems_wrong_product)    as wrong_product,
          sum(number_of_order_lineitems_perished_product) as perished_product,
          sum(number_of_order_lineitems_missing_product)  as missing_product,
          sum(number_of_order_lineitems_damaged_product)  as damaged,
          sum(number_of_orders_with_issues)               as orders_with_issues,
          sum(number_of_orders)                           as orders_total
          from `flink-data-prod`.reporting.hub_level_kpis
          group by 1,2
 ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.date, ${TABLE}.hub_code) ;;
    group_label: "> IDs"
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~  DIMENSIONS ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: date {
    label: "Order Date"
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
    group_label: "> Dates & Timestamps"
  }

  dimension_group: created {
    group_label: "> Dates & Timestamps"
    label: "Issue"
    description: "Issue Date/Time"
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${date} ;;
    datatype: date
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: date_dynamic {
    group_label: "> Dates & Timestamps"
    label: "Date (Dynamic)"
    label_from_parameter: orders_cl.date_granularity
    sql:
    {% if orders_cl.date_granularity._parameter_value == 'Day' %}
      ${created_date}
    {% elsif orders_cl.date_granularity._parameter_value == 'Week' %}
      ${created_week}
    {% elsif orders_cl.date_granularity._parameter_value == 'Month' %}
      ${created_month}
    {% endif %};;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~  Hidden Fields     ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: orders_with_issues {
    type: number
    sql: ${TABLE}.orders_with_issues ;;
    hidden: yes
  }

  dimension: orders_total {
    type: number
    sql: ${TABLE}.orders_total ;;
    hidden: yes
  }

  dimension: wrong_product {
    type: number
    sql: ${TABLE}.wrong_product ;;
    hidden: yes
  }

  dimension: wrong_order {
    type: number
    sql: ${TABLE}.wrong_order ;;
    hidden: yes
  }

  dimension: perished_product {
    type: number
    sql: ${TABLE}.perished_product ;;
    hidden: yes
  }

  dimension: missing_product {
    type: number
    sql: ${TABLE}.missing_product ;;
    hidden: yes
  }

  dimension: damaged {
    type: number
    sql: ${TABLE}.damaged ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~   MEASURES     ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_orders_total {
    label: "# Total Orders"
    description: "The total number of orders"
    type: sum
    sql: ${orders_total} ;;
    group_label: "> Absolute Metrics"
  }

  measure: sum_orders_with_issues {
    label: "# Orders with Issues"
    description: "The sum of orders that have issues (the sum of: Wrong Product, Wrong Order, Perished Product, Missing Product and Damaged Product)"
    type: sum
    sql: ${orders_with_issues} ;;
    group_label: "> Absolute Metrics"
  }


  measure: sum_wrong_product {
    label: "# Wrong Products"
    description: "The number of orders, that have a customer complain with the main reason 'Wrong Product'."
    type: sum
    sql: ${wrong_product} ;;
    group_label: "> Absolute Metrics"
  }

  measure: sum_wrong_order {
    label: "# Wrong Orders"
    description: "The number of orders, that have a customer complain with the main reason 'Wrong Order'."
    type: sum
    sql: ${wrong_order} ;;
    group_label: "> Absolute Metrics"
  }

  measure: sum_perished_product {
    label: "# Perished Products"
    description: "The number of orders, that have a customer complain with the main reason 'Perished Product'."
    type: sum
    sql: ${perished_product} ;;
    group_label: "> Absolute Metrics"
  }

  measure: sum_missing_product {
    label: "# Missing Products"
    description: "The number of orders, that have a customer complain with the main reason 'Missing Product'."
    type: sum
    sql: ${missing_product} ;;
    group_label: "> Absolute Metrics"
  }

  measure: sum_damaged {
    label: "# Damaged Products"
    description: "The number of orders, that have a customer complain with the main reason 'Damaged Product'."
    type: sum
    sql: ${damaged} ;;
    group_label: "> Absolute Metrics"
  }


  measure: pct_orders_with_issues {
    label: "% Issue Rate"
    description: "The number of orders that have issues (the sum of: Wrong Product, Wrong Order, Perished Product, Missing Product and Damaged Product) divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_orders_with_issues}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
    group_label: "> Percentages"
  }


  measure: pct_orders_missing_product {
    label: "% Missing Product Issue Rate"
    description: "The number of orders with missing products divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_missing_product}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
    group_label: "> Percentages"
  }

  measure: pct_orders_wrong_order {
    label: "% Wrong Order Issue Rate"
    description: "The number of orders with completely wrong baskets delivered divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_wrong_order}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
    group_label: "> Percentages"
  }

  measure: pct_orders_perished_product {
    label: "% Perished Product Issue Rate"
    description: "The number of orders with perished products divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_perished_product}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
    group_label: "> Percentages"
  }

  measure: pct_orders_wrong_product {
    label: "% Wrong Product Issue Rate"
    description: "The number of orders with wrong products divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_wrong_product}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
    group_label: "> Percentages"
  }

  measure: pct_orders_damaged_product {
    label: "% Damaged Product Issue Rate"
    description: "The number of orders with damaged products divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_damaged}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
    group_label: "> Percentages"
  }



  set: detail {
    fields: [date, hub_code, orders_with_issues, orders_total]
  }
}
