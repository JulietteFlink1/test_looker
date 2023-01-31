include: "/**/*.view"

view: +orderline {

  dimension: vendor_price {
    required_access_grants: [can_view_buying_information]
    label: "Buying Price"
    type: number
    sql: ${TABLE}.amt_buying_price_net_eur ;;
    value_format_name: decimal_4
    hidden: yes
  }

  dimension: net_income {
    required_access_grants: [can_view_buying_information]
    label: "Net Unit Price"
    description: "The incoming cash defined as net item price"
    type: number
    sql:  if(${vendor_price} is not null,
            coalesce(
              ${unit_price_gross_amount} / nullif((1 + ${tax_rate}) ,0),
              ${products.amt_product_price_gross}  / nullif((1 + ${products.tax_rate}), 0)
            ),
            null)
    ;;
    value_format_name: eur
    hidden: yes
  }

  dimension: net_income_after_product_discount {
    required_access_grants: [can_view_buying_information]
    label: "Net Unit Price After Product Discount"
    description: "The incoming cash defined as net item price after deduction of Product Discount"
    type: number
    sql:  if(${vendor_price} is not null,
            coalesce(
              ${unit_price_after_product_discount_gross} / nullif((1 + ${tax_rate}) ,0),
              ${products.amt_product_price_gross}  / nullif((1 + ${products.tax_rate}), 0)
            ),
            null)
    ;;
    value_format_name: eur
    hidden: yes
  }

  dimension: margin_absolute {
    required_access_grants: [can_view_buying_information]
    label: "€ Unit Margin"
    description: "The unit margin defined as Net Unit Price substracted by the Buying Price"
    type: number
    sql: ${net_income} - ${vendor_price} ;;
    value_format_name: eur
    hidden: yes
  }

  dimension: margin_absolute_after_product_discount {
    required_access_grants: [can_view_buying_information]
    label: "€ Unit Margin After Product Discount"
    description: "The unit margin defined as Net Unit Price after deduction of Product Discount  substracted by the Buying Price"
    type: number
    sql: ${net_income_after_product_discount} - ${vendor_price} ;;
    value_format_name: eur
    hidden: yes
  }





  measure: avg_vendor_price {
    required_access_grants: [can_view_buying_information]
    label: "AVG Buying Price"
    description: "The  sum of COGS divided by the sum of Item Quantity Sold"
    type: average
    sql: ${vendor_price} ;;
    value_format_name: decimal_4
  }

  measure: sum_total_net_income {
    required_access_grants: [can_view_buying_information]
    label: "€ Sum Item Prices Sold (Net)"
    description: "The sum of all Net Unit Price multiplied by the sum of Item Quantity Sold"
    type: sum
    sql: (${quantity} * ${net_income}) ;;
    value_format_name: eur
  }

  measure: sum_total_net_income_after_product_discount{
    required_access_grants: [can_view_buying_information]
    label: "€ Sum Item Prices Sold After Product Discount (Net)"
    description: "The sum of all Net Unit Price after deduction of Product Discount multiplied by the sum of Item Quantity Sold"
    type: sum
    sql: (${quantity} * ${net_income_after_product_discount}) ;;
    value_format_name: eur
  }

  measure: sum_total_margin_abs {
    required_access_grants: [can_view_buying_information]
    label: "€ Sum Gross Profit"
    description: "The sum of all Unit Margins defined as Net Unit Price minus Buying Price"
    type: sum
    sql: (${quantity} * ${margin_absolute}) ;;
    value_format_name: eur
  }

  measure: sum_total_margin_abs_after_product_discount {
    required_access_grants: [can_view_buying_information]
    label: "€ Sum Gross Profit After Product Discount"
    description: "The sum of all Unit Margins defined as Net Unit Price after deduction of Product Discount minus Buying Price"
    type: sum
    sql: (${quantity} * ${margin_absolute_after_product_discount}) ;;
    value_format_name: eur
  }

  # measure: sum_total_margin_abs_after_product_discount_and_waste {
  #   required_access_grants: [can_view_buying_information]
  #   label: "€ Sum Gross Profit After Product Discount and Waste"
  #   description: "The sum of all Unit Margins defined as Net Unit Price after deduction of Product Discount minus Buying Price and Waste (Net)"
  #   type: number
  #   sql: ${sum_total_margin_abs_after_product_discount} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net} ;;
  #   value_format_name: eur
  # }

  measure: pct_total_margin_relative {
    required_access_grants: [can_view_buying_information]
    label: "% Blended Margin"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold (Net)"
    type: number
    sql: ${sum_total_margin_abs} / nullif( ${sum_total_net_income} ,0);;
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

  measure: pct_total_margin_relative_after_product_discount {
    required_access_grants: [can_view_buying_information]
    label: "% Blended Margin After Product Discount"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold after deduction of Product Discount (Net)"
    type: number
    sql: ${sum_total_margin_abs_after_product_discount} / nullif( ${sum_total_net_income_after_product_discount} ,0);;
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

  measure: sum_total_cost {
    required_access_grants: [can_view_buying_information]
    label: "€ Sum COGS"
    description: "The sum of Item Prices Sold (Net) minus sum of Gross Profit"
    type: number
    sql: ${sum_total_net_income} - ${sum_total_margin_abs} ;;
    value_format_name: eur
  }

  measure: avg_total_cost {
    required_access_grants: [can_view_buying_information]
    label: "€ AVG COGS"
    description: ""
    type: number
    sql: (${sum_total_net_income} - ${sum_total_margin_abs}) / ${count_order_uuid};;
    value_format_name: eur
  }

  measure: sum_total_cost_after_product_discount {
    required_access_grants: [can_view_buying_information]
    label: "€ Sum COGS After Product Discounts"
    description: "The sum of Item Prices Sold after deduction of Product Discount (Net) minus sum of Gross Profit"
    type: number
    sql: ${sum_total_net_income_after_product_discount} - ${sum_total_margin_abs_after_product_discount} ;;
    value_format_name: eur
  }

  measure: sum_gross_profit_after_product_discount_gross  {
    required_access_grants: [can_view_buying_information]
    label: "€ Gross Profit after Product Discount (Gross)"
    description: "The gross profit after product discounts (gross) for sold products"
    type: number
    sql: ${pct_total_margin_relative_after_product_discount} * ${sum_item_price_after_product_discount_gross} ;;
    value_format_name: eur
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~     Dynamic Measures & Dimensions     ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: net_income_dynamic {
    required_access_grants: [can_view_buying_information]
    label: "Net Unit Price (Dynamic)"
    description: "The incoming cash defined as net item price. To be used together with Is After Deduction of Product Discounts parameter"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${net_income_after_product_discount}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${net_income}
    {% endif %}
    ;;
    hidden: yes
  }

  dimension: margin_absolute_dynamic {
    required_access_grants: [can_view_buying_information]
    label: "€ Unit Margin (Dynamic)"
    description: "The unit margin defined as Net Unit Price substracted by the Buying Price. To be used together with Is After Deduction of Product Discounts parameter"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${margin_absolute_after_product_discount}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${margin_absolute}
    {% endif %}
    ;;
    hidden: yes
  }

  measure: sum_total_net_income_dynamic {
    required_access_grants: [can_view_buying_information]
    label: "€ Sum Item Prices Sold (Net) (Dynamic)"
    description: "The sum of all Net Unit Price multiplied by the sum of Item Quantity Sold. To be used together with Is After Deduction of Product Discounts parameter"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${sum_total_net_income_after_product_discount}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${sum_total_net_income}
    {% endif %}
    ;;
  }

  measure: sum_total_margin_abs_dynamic {
    required_access_grants: [can_view_buying_information]
    label: "€ Sum Gross Profit (Dynamic)"
    description: "The sum of all Unit Margins defined as Net Unit Price minus Buying Price. To be used together with Is After Deduction of Product Discounts parameter"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${sum_total_margin_abs_after_product_discount}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${sum_total_margin_abs}
    {% endif %}
    ;;
  }

  measure: pct_total_margin_relative_dynamic {
    required_access_grants: [can_view_buying_information]
    label: "% Blended Margin (Dynamic)"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold (Net). To be used together with Is After Deduction of Product Discounts parameter"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: percent_1
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${pct_total_margin_relative_after_product_discount}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${pct_total_margin_relative}
    {% endif %}
    ;;
  }

  measure: sum_total_cost_dynamic {
    required_access_grants: [can_view_buying_information]
    label: "€ Sum COGS (Dynamic)"
    description: "The sum of Item Prices Sold (Net) minus sum of Gross Profit. To be used together with Is After Deduction of Product Discounts parameter"
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == "true" %}
    ${sum_total_cost_after_product_discount}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == "false" %}
    ${sum_total_cost}
    {% endif %}
    ;;
  }
}
