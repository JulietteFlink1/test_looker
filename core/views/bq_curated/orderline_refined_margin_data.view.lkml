include: "/**/*.view"

view: +orderline {


  dimension: is_buying_price_defined {
    required_access_grants: [can_view_buying_information]
    label: "Is Weighted Average Cost (WAC) Defined"
    description: "Yes, if a sold items could be related to a weighted average cost price from our ERP system. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: yesno
    sql: ${amt_weighted_average_cost_net_eur} is not null ;;
  }

  dimension: amt_net_income_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Net Unit Price (Net)"
    description: "The net revenue through product sales. This field is only calculated for transactions, that also have a Weighted Average Cost (WAC) associated. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql:  if(${amt_weighted_average_cost_net_eur} is not null,
            coalesce(
              ${unit_price_gross_amount} / nullif((1 + ${tax_rate}) ,0),
              ${products.amt_product_price_gross}  / nullif((1 + ${products.tax_rate}), 0)
            ),
            null)
    ;;
    value_format_name: eur
    hidden: yes
  }

  dimension: amt_net_income_after_product_discount_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Net Unit Price After Product Discount (Net)"
    description: "The incoming cash defined as net item price after deduction of Product Discount"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql:  if(${amt_weighted_average_cost_net_eur} is not null,
            coalesce(
              ${unit_price_after_product_discount_gross} / nullif((1 + ${tax_rate}) ,0),
              ${products.amt_product_price_gross}  / nullif((1 + ${products.tax_rate}), 0)
            ),
            null)
    ;;
    value_format_name: eur
    hidden: yes
  }

  dimension: amt_margin_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Unit Margin (Net)"
    description: "The unit margin defined as Net Unit Price substracted by the Weighted Average Cost (WAC)"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${amt_net_income_net_eur} - ${amt_weighted_average_cost_net_eur} ;;
    value_format_name: eur
    hidden: yes
  }

  dimension: amt_margin_after_product_discount_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Unit Margin After Product Discount (Net)"
    description: "The unit margin defined as Net Unit Price after deduction of Product Discount  substracted by the Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${amt_net_income_after_product_discount_net_eur} - ${amt_weighted_average_cost_net_eur} ;;
    value_format_name: eur
    hidden: yes
  }





  measure: avg_amt_weighted_average_cost_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "AVG Weighted Average Cost (WAC) (Net)"
    description: "The  sum of COGS divided by the sum of Item Quantity Sold. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: safe_divide(${sum_of_total_cost_net_eur}, ${sum_item_quantity}) ;;
    value_format_name: decimal_4
  }

  measure: sum_of_total_net_income_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Sum Item Prices Sold (Net)"
    description: "The sum of all Net Unit Price multiplied by the sum of Item Quantity Sold"
    group_label: "> Monetary Metrics (P&L)"
    type: sum
    sql: (${quantity} * ${amt_net_income_net_eur}) ;;
    value_format_name: eur
  }

  measure: sum_of_total_net_income_after_product_discount_net_eur{
    required_access_grants: [can_view_buying_information]
    label: "Sum Item Prices Sold After Product Discount (Net)"
    description: "The sum of all Net Unit Price after deduction of Product Discount multiplied by the sum of Item Quantity Sold"
    group_label: "> Monetary Metrics (P&L)"
    type: sum
    sql: (${quantity} * ${amt_net_income_after_product_discount_net_eur}) ;;
    value_format_name: eur
  }

  measure: sum_of_margin_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Sum Gross Profit (Net)"
    description: "The sum of all Unit Margins defined as Net Unit Price minus Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: sum
    sql: (${quantity} * ${amt_margin_net_eur}) ;;
    value_format_name: eur
  }

  measure: sum_of_margin_after_product_discount_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Sum Gross Profit After Product Discount (Net)"
    description: "The sum of all Unit Margins defined as Net Unit Price after deduction of Product Discount minus Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: sum
    sql: (${quantity} * ${amt_margin_after_product_discount_net_eur}) ;;
    value_format_name: eur
  }

  # measure: sum_total_margin_abs_after_product_discount_and_waste {
  #   required_access_grants: [can_view_buying_information]
  #   label: "Sum Gross Profit After Product Discount and Waste"
  #   description: "The sum of all Unit Margins defined as Net Unit Price after deduction of Product Discount minus Weighted Average Cost (WAC) and Waste (Net). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
  #   type: number
  #   sql: ${sum_total_margin_abs_after_product_discount} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net} ;;
  #   value_format_name: eur
  # }

  measure: share_of_margin_net_eur_with_net_income_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "% Blended Margin (Net)"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold (Net)"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${sum_of_margin_net_eur} / nullif( ${sum_of_total_net_income_net_eur} ,0);;
    value_format_name: percent_1
  }

  # measure: pct_total_margin_relative_after_waste {
  #   required_access_grants: [can_view_buying_information]
  #   label: "% Blended Margin after Waste"
  #   description: "The sum of Gross Profit minus Waste (Net) divided by the sum of Item Prices Sold (Net)"
  #   type: number
  #   sql: (${sum_total_margin_abs} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net})  / nullif( ${sum_total_net_income} ,0);;
  #   value_format_name: percent_1
  # }

  measure: share_of_margin_after_product_discount_net_eur_with_net_income_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "% Blended Margin After Product Discount (Net)"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold after deduction of Product Discount (Net)"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${sum_of_margin_after_product_discount_net_eur} / nullif( ${sum_of_total_net_income_after_product_discount_net_eur} ,0);;
    value_format_name: percent_1
  }

  # measure: pct_total_margin_relative_after_product_discount_and_waste{
  #   required_access_grants: [can_view_buying_information]
  #   label: "% Blended Margin After Product Discount and Waste"
  #   description: "The sum of Gross Profit divided by the sum of Item Prices Sold after deduction of Product Discount (Net) and Waste (Net)"
  #   type: number
  #   sql: (${sum_total_margin_abs_after_product_discount} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net}) / nullif( ${sum_total_net_income_after_product_discount} ,0);;
  #   value_format_name: percent_1
  # }

  measure: sum_of_total_cost_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Sum COGS (Net)"
    description: "The sum of Item Prices Sold (Net) minus sum of Gross Profit"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${sum_of_total_net_income_net_eur} - ${sum_of_margin_net_eur} ;;
    value_format_name: eur
  }

  measure: share_of_total_cost_net_eur_with_number_of_orders {
    required_access_grants: [can_view_buying_information]
    label: "AVG COGS (Net)"
    description: "The total costs divided by the number of orders"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: (${sum_of_total_net_income_net_eur} - ${sum_of_margin_net_eur}) / ${count_order_uuid};;
    value_format_name: eur
  }

  measure: sum_of_total_cost_after_product_discount_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Sum COGS After Product Discounts (Net)"
    description: "The sum of Item Prices Sold after deduction of Product Discount (Net) minus sum of Gross Profit"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${sum_of_total_net_income_after_product_discount_net_eur} - ${sum_of_margin_after_product_discount_net_eur} ;;
    value_format_name: eur
  }

  measure: sum_of_gross_profit_after_product_discount_gross  {
    required_access_grants: [can_view_buying_information]
    label: "SUM Gross Profit after Product Discount (Gross)"
    description: "The gross profit after product discounts (gross) for sold products"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${sum_of_total_net_income_after_product_discount_net_eur} - ${sum_item_price_after_product_discount_gross} ;;
    value_format_name: eur
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~     Dynamic Measures & Dimensions     ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: amt_net_income_dynamic_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Net Unit Price (Dynamic - Net)"
    description: "The incoming cash defined as net item price. To be used together with Is After Deduction of Product Discounts parameter"
    group_label: "> Monetary Metrics (P&L)"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${amt_net_income_after_product_discount_net_eur}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${amt_net_income_net_eur}
    {% endif %}
    ;;
    hidden: yes
  }

  dimension: amt_margin_absolute_dynamic_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Unit Margin (Dynamic - Net)"
    description: "The unit margin defined as Net Unit Price substracted by the Weighted Average Cost (WAC). To be used together with Is After Deduction of Product Discounts parameter. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${amt_margin_after_product_discount_net_eur}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${amt_margin_net_eur}
    {% endif %}
    ;;
    hidden: yes
  }

  measure: sum_of_total_net_income_dynamic_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Sum Item Prices Sold (Dynamic - Net)"
    description: "The sum of all Net Unit Price multiplied by the sum of Item Quantity Sold. To be used together with Is After Deduction of Product Discounts parameter"
    group_label: "> Monetary Metrics (P&L)"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${sum_of_total_net_income_after_product_discount_net_eur}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${sum_of_total_net_income_net_eur}
    {% endif %}
    ;;
  }

  measure: sum_if_total_margin_abs_dynamic_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Sum Gross Profit (Dynamic - Net)"
    description: "The sum of all Unit Margins defined as Net Unit Price minus Weighted Average Cost (WAC). To be used together with Is After Deduction of Product Discounts parameter. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${sum_of_margin_after_product_discount_net_eur}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${sum_of_margin_net_eur}
    {% endif %}
    ;;
  }

  measure: share_of_margin_net_eur_with_net_income_net_eur_dynamic {
    required_access_grants: [can_view_buying_information]
    label: "% Blended Margin (Dynamic - Net)"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold (Net). To be used together with Is After Deduction of Product Discounts parameter"
    group_label: "> Monetary Metrics (P&L)"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: percent_1
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${share_of_margin_after_product_discount_net_eur_with_net_income_net_eur}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${share_of_margin_net_eur_with_net_income_net_eur}
    {% endif %}
    ;;
  }

  measure: sum_total_cost_dynamic_net_eur {
    required_access_grants: [can_view_buying_information]
    label: "Sum COGS (Dynamic - Net)"
    description: "The sum of Item Prices Sold (Net) minus sum of Gross Profit. To be used together with Is After Deduction of Product Discounts parameter"
    group_label: "> Monetary Metrics (P&L)"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${sum_of_total_cost_after_product_discount_net_eur}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${sum_of_total_cost_net_eur}
    {% endif %}
    ;;
  }
}
