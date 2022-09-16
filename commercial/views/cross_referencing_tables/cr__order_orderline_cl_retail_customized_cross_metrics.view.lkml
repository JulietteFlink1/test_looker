# author: Andreas Stueber
# created date: 2022-09-14
# description: this file defines some metrics specfic to the order_orderline_cl_retail_customized Explore, that are cross-referencing different tables

view: cr__order_orderline_cl_retail_customized_cross_metrics {

  measure: sum_item_price_after_product_discount_gross_dynamic {

    label: "SUM Item Price sold (gross - dynamic)"
    description: "Sum of sold Item prices (incl. VAT) before and after application of discounts (defined by the parameter 'Is After Deduction of Product Discounts')."

    sql:
    {% if erp_buying_prices.is_after_product_discounts._parameter_value == "true" %}
    ${orderline.sum_item_price_after_product_discount_gross}
    {% elsif erp_buying_prices.is_after_product_discounts._parameter_value == "false" %}
    ${orderline.sum_item_price_gross}
    {% endif %}
    ;;
    type: number
    value_format_name: eur
    hidden: yes
  }

  measure: sum_number_of_orders_dynamic {

    label: "# Daily/Weekly/Monthly Orders per Country"
    description: "Count of Orders per order-day/week/month and country. This metric depends on the parameter 'Select Date Granularity' from the orders table"
    group_label: "Gross Profit per Customer/Order"

    sql:
    {% if orders_cl.date_granularity._parameter_value == 'Day' %}
      ${ndt_order_orderline_cl_retail_customized__metrics_per_country_and_order_date.sum_number_of_orders}
    {% elsif orders_cl.date_granularity._parameter_value == 'Week' %}
      ${orders_country_level.sum_number_of_orders}
    {% elsif orders_cl.date_granularity._parameter_value == 'Month' %}
      ${orders_country_level_monthly.sum_number_of_orders}
    {% endif %};;

      type: number
      value_format_name: decimal_0
    }

  measure: sum_number_of_unique_customers_dynamic {

    label: "# Daily/Weekly/Monthly Unique Customers per Country"
    description: "Count of Unique Customers identified via their Customer UUID aggregated per order-day/week/month and country. This metric depends on the parameter 'Select Date Granularity' from the orders table"
    group_label: "Gross Profit per Customer/Order"

    sql:
        {% if orders_cl.date_granularity._parameter_value == 'Day' %}
        ${ndt_order_orderline_cl_retail_customized__metrics_per_country_and_order_date.sum_number_of_unique_customers}
        {% elsif orders_cl.date_granularity._parameter_value == 'Week' %}
        ${orders_country_level.sum_number_of_unique_customers}
        {% elsif orders_cl.date_granularity._parameter_value == 'Month' %}
        ${orders_country_level_monthly.sum_number_of_unique_customers}
        {% endif %};;

      type: number
      value_format_name: decimal_0
  }

  measure: eur_gross_profit_dynamic_per_customer {

    label: "€ Gross Profit per Order (dynamic)"
    description: "The sum of gross profit (before or after deducation of discounts - defined by the parameter 'Is After Deduction of Product Discounts') divided by the number of orders of a given day/week/month (based on parameter 'Select Date Granularity' from the orders table)"
    group_label: "Gross Profit per Customer/Order"

    sql: safe_divide((${sum_item_price_after_product_discount_gross_dynamic}*${erp_buying_prices.pct_total_margin_relative_dynamic}), ${sum_number_of_orders_dynamic}) ;;
    type: number
    value_format_name: eur
  }

  measure: eur_gross_profit_dynamic_per_order {

    label: "€ Gross Profit per Customer (dynamic)"
    description: "The sum of gross profit (before or after deducation of discounts - defined by the parameter 'Is After Deduction of Product Discounts') divided by the number of customers of a given day/week/month (based on parameter 'Select Date Granularity' from the orders table)"
    group_label: "Gross Profit per Customer/Order"

    sql: safe_divide((${sum_item_price_after_product_discount_gross_dynamic}*${erp_buying_prices.pct_total_margin_relative_dynamic}), ${sum_number_of_unique_customers_dynamic}) ;;
    type: number
    value_format_name: eur
  }
}
