include: "/**/*.view"

view: +orderline {


  dimension: is_buying_price_defined {
    required_access_grants: [can_access_pricing_margins]
    label: "Is Weighted Average Cost (WAC) Defined"
    description: "Yes, if a sold items could be related to a weighted average cost price from our ERP system. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: yesno
    sql: ${amt_weighted_average_cost_net_eur} is not null ;;
  }

  dimension: amt_net_income_net_eur {
    required_access_grants: [can_access_pricing_margins]
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
    required_access_grants: [can_access_pricing_margins]
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
    required_access_grants: [can_access_pricing_margins]
    label: "Unit Margin (Net)"
    description: "The unit margin defined as Net Unit Price substracted by the Weighted Average Cost (WAC)"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${amt_net_income_net_eur} - ${amt_weighted_average_cost_net_eur} ;;
    value_format_name: eur
    hidden: yes
  }

  dimension: amt_margin_after_product_discount_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "Unit Margin After Product Discount (Net)"
    description: "The unit margin defined as Net Unit Price after deduction of Product Discount  substracted by the Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${amt_net_income_after_product_discount_net_eur} - ${amt_weighted_average_cost_net_eur} ;;
    value_format_name: eur
    hidden: yes
  }




  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # - - - - - - - - - - -   Granular Cost Data Points
  # - - - - - - - - - - - https://goflink.atlassian.net/browse/DATA-5635
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: amt_base_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Base Cost (Net)"
    description: "Base cost of the SKU/supplier/country at the given location. This is the same cost that is on the item_supp_country table - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_base_cost_net_unit_cost ;;
  }

  dimension: amt_base_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Base Cost (Net)"
    description: "Base cost of the SKU/supplier/country at the given location. This is the same cost that is on the item_supp_country table - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_base_cost_net_total_cost ;;
  }

  dimension: amt_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Net Cost (Net)"
    description: "Net cost of the SKU/supplier/country at the given location. This is the base cost minus any deal components designated as applying to net cost on DEAL_DETAIL  - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_net_cost_net_unit_cost ;;
  }

  dimension: amt_net_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Net Cost (Net)"
    description: "Net cost of the SKU/supplier/country at the given location. This is the base cost minus any deal components designated as applying to net cost on DEAL_DETAIL - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_net_cost_net_total_cost ;;
  }


  dimension: amt_supplier_invoice_discount_wac_based_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Amt Supplier Invoice Discount Wac Based Net"
    description: "The discount on the supplier invoice, that mainly entails a standard refund for missing/wrong goods delivered. This metric is a percentage of the weighted average cost - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_supplier_invoice_discount_wac_based_net_unit_cost ;;
  }

  dimension: amt_supplier_invoice_discount_wac_based_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Amt Supplier Invoice Discount Wac Based Net"
    description: "The discount on the supplier invoice, that mainly entails a standard refund for missing/wrong goods delivered. This metric is a percentage of the weighted average cost - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_supplier_invoice_discount_wac_based_net_total_cost ;;
  }

  dimension: amt_supplier_kickback_wac_based_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Amt Supplier Kickback Wac Based Net"
    description: "Contractural refund of a supplier, given certain conditions are met. These conditions are defined in Oracle deals tables. Can either be an absolute value or a percentage of the weighted average cost - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_supplier_kickback_wac_based_net_unit_cost ;;
  }

  dimension: amt_supplier_kickback_wac_based_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Amt Supplier Kickback Wac Based Net"
    description: "Contractural refund of a supplier, given certain conditions are met. These conditions are defined in Oracle deals tables. Can either be an absolute value or a percentage of the weighted average cost - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_supplier_kickback_wac_based_net_total_cost ;;
  }

  dimension: amt_logistic_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Logistic Cost Net Cost Based (Net)"
    description: "Logistic cost demanded by the supplier. Calculated as a share of the net cost. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_logistic_net_cost_based_net_unit_cost ;;
  }

  dimension: amt_logistic_net_cost_based_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Logistic Cost Net Cost Based (Net)"
    description: "Logistic cost demanded by the supplier. Calculated as a share of the net cost. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_logistic_net_cost_based_net_total_cost ;;
  }

  dimension: amt_logistic_wac_based_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Logistic Cost WAC Based (Net)"
    description: "Logistic cost demanded by the supplier. Calculated as a share of the net cost. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_logistic_wac_based_net_unit_cost ;;
  }

  dimension: amt_logistic_wac_based_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Logistic Cost WAC Based (Net)"
    description: "Logistic cost demanded by the supplier. Calculated as a share of the net cost. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_logistic_wac_based_net_total_cost ;;
  }

  dimension: amt_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Net Net Cost (Net)"
    description: "Net net cost of the SKU/supplier/country at the given location. This is the net cost minus any deal components designated as applying to net net cost on DEAL_DETAIL. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_net_net_cost_net_unit_cost ;;
  }

  dimension: amt_net_net_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Net Net Cost (Net)"
    description: "Net net cost of the SKU/supplier/country at the given location. This is the net cost minus any deal components designated as applying to net net cost on DEAL_DETAIL. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_net_net_cost_net_total_cost ;;
  }

  dimension: amt_partner_kickback_permanent_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Partner Kickback Permanent (Net)"
    description: "Kickback (refunded) amount from partners (not suppiers) when meeting some sales targets. Either an absolute value or a percentage of the net cost. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_partner_kickback_permanent_net_unit_cost ;;
  }

  dimension: amt_partner_kickback_permanent_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Partner Kickback Permanent (Net)"
    description: "Kickback (refunded) amount from partners (not suppiers) when meeting some sales targets. Either an absolute value or a percentage of the net cost. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_partner_kickback_permanent_net_total_cost ;;
  }

  dimension: amt_partner_kickback_temporary_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Partner Kickback Temporary (Net)"
    description: "Kickback (refunded) amount from partners (not suppiers) when meeting some sales targets for temporary campaigns. Either an absolute value or a percentage of the net cost. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_partner_kickback_temporary_net_unit_cost ;;
  }

  dimension: amt_partner_kickback_temporary_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Partner Kickback Temporary (Net)"
    description: "Kickback (refunded) amount from partners (not suppiers) when meeting some sales targets for temporary campaigns. Either an absolute value or a percentage of the net cost. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_partner_kickback_temporary_net_total_cost ;;
  }

  dimension: amt_dead_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Dead Net Net Cost (Net)"
    description: "Dead net net cost of the SKU/supplier/country at the given location. This is the net net cost minus any deal components designated as applying to dead net net cost on DEAL_DETAIL. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_dead_net_net_cost_net_unit_cost ;;
  }

  dimension: amt_dead_net_net_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Dead Net Net Cost (Net)"
    description: "Dead net net cost of the SKU/supplier/country at the given location. This is the net net cost minus any deal components designated as applying to dead net net cost on DEAL_DETAIL. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_dead_net_net_cost_net_total_cost ;;
  }

  dimension: amt_promo_funding_partner_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Promo Funding Partner (Net)"
    description: "Promo funding amount accounts for revenues generated by partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_promo_funding_partner_net_unit_cost ;;
  }

  dimension: amt_promo_funding_partner_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Promo Funding Partner (Net)"
    description: "Promo funding amount accounts for revenues generated by partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_promo_funding_partner_net_total_cost ;;
  }

  dimension: amt_promo_funding_marketing_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Promo Funding Marketing (Net)"
    description: "Promo funding amount accounts for revenues generated by partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_promo_funding_marketing_net_unit_cost ;;
  }

  dimension: amt_promo_funding_marketing_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Promo Funding Marketing (Net)"
    description: "Promo funding amount accounts for revenues generated by partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_promo_funding_marketing_net_total_cost ;;
  }

  dimension: amt_promo_funding_supplier_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Promo Funding Supplier (Net)"
    description: "Promo funding amount accounts for revenues generated by suppliers when offering certain products. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_promo_funding_supplier_net_unit_cost ;;
  }

  dimension: amt_promo_funding_supplier_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Promo Funding Supplier (Net)"
    description: "Promo funding amount accounts for revenues generated by suppliers when offering certain products. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_promo_funding_supplier_net_total_cost ;;
  }

  dimension: amt_pricing_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Pricing Cost (Net)"
    description: "Cost to be used to in pricing reviews. Pricing cost is the cost that will be interfaced with Oracle Price Management for use in pricing decisions. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_pricing_cost_net_unit_cost ;;
  }

  dimension: amt_pricing_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Pricing Cost (Net)"
    description: "Cost to be used to in pricing reviews. Pricing cost is the cost that will be interfaced with Oracle Price Management for use in pricing decisions. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_pricing_cost_net_total_cost ;;
  }

  dimension: amt_wac_0_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "WAC0 (Net)"
    description: "Average value of our current stock before any deductions. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_0_net_unit_cost ;;
  }

  dimension: amt_wac_0_net_total_cost  {
    required_access_grants: [can_access_pricing_margins]
    label: "Total WAC0 (Net)"
    description: "Average value of our current stock before any deductions. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_0_net_total_cost ;;
  }

  dimension: amt_wac_1_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "WAC1 (Net)"
    description: "Average value of our current stock with Supplier Invoice Discount deducted. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_1_net_unit_cost ;;
  }

  dimension: amt_wac_1_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total WAC1 (Net)"
    description: "Average value of our current stock with Supplier Invoice Discount deducted. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_1_net_total_cost ;;
  }

  dimension: amt_wac_2_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "WAC2 (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback and Logistic Cost. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_2_net_unit_cost ;;
  }

  dimension: amt_wac_2_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total WAC2 (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback and Logistic Cost. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_2_net_total_cost ;;
  }

  dimension: amt_wac_3_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "WAC3 (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost and Permanent Partner Kickback. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_3_net_unit_cost ;;
  }

  dimension: amt_wac_3_net_total_cost  {
    required_access_grants: [can_access_pricing_margins]
    label: "Total WAC3 (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost and Permanent Partner Kickback. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_3_net_total_cost ;;
  }

  dimension: amt_wac_4_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "WAC4 (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost, Permanent and Temporary Partner Kickback. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_4_net_unit_cost ;;
  }

  dimension: amt_wac_4_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total WAC4 (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost, Permanent and Temporary Partner Kickback. - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_wac_4_net_total_cost ;;
  }

  dimension: amt_full_wac_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Full WAC (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost, Permanent and Temporary Partner Kickback, Supplier Promo Funding, Partner Promo Funding and Marketing Promo Funding. - Per Unit"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_full_wac_net_unit_cost ;;
  }

  dimension: amt_full_wac_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "Total Full WAC (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost, Permanent and Temporary Partner Kickback, Supplier Promo Funding, Partner Promo Funding and Marketing Promo Funding.  - Total cost as result of unit cost * quantity sold"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_full_wac_net_total_cost ;;
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



  measure: avg_amt_weighted_average_cost_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Weighted Average Cost (WAC) (Net)"
    description: "The  sum of COGS divided by the sum of Item Quantity Sold. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: safe_divide(${sum_of_total_cost_net_eur}, ${sum_item_quantity}) ;;
    value_format_name: decimal_4
  }

  measure: sum_of_total_net_income_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "Sum Item Prices Sold (Net)"
    description: "The sum of all Net Unit Price multiplied by the sum of Item Quantity Sold"
    group_label: "> Monetary Metrics (P&L)"
    type: sum
    sql: (${quantity} * ${amt_net_income_net_eur}) ;;
    value_format_name: eur
  }

  measure: sum_of_total_net_income_after_product_discount_net_eur{
    required_access_grants: [can_access_pricing_margins]
    label: "Sum Item Prices Sold After Product Discount (Net)"
    description: "The sum of all Net Unit Price after deduction of Product Discount multiplied by the sum of Item Quantity Sold"
    group_label: "> Monetary Metrics (P&L)"
    type: sum
    sql: (${quantity} * ${amt_net_income_after_product_discount_net_eur}) ;;
    value_format_name: eur
  }

  measure: sum_of_margin_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "Sum Gross Profit (Net)"
    description: "The sum of all Unit Margins defined as Net Unit Price minus Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: sum
    sql: (${quantity} * ${amt_margin_net_eur}) ;;
    value_format_name: eur
  }

  measure: sum_of_margin_after_product_discount_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "Sum Gross Profit After Product Discount (Net)"
    description: "The sum of all Unit Margins defined as Net Unit Price after deduction of Product Discount minus Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: sum
    sql: (${quantity} * ${amt_margin_after_product_discount_net_eur}) ;;
    value_format_name: eur
  }

  # measure: sum_total_margin_abs_after_product_discount_and_waste {
  #   required_access_grants: [can_access_pricing_margins]
  #   label: "Sum Gross Profit After Product Discount and Waste"
  #   description: "The sum of all Unit Margins defined as Net Unit Price after deduction of Product Discount minus Weighted Average Cost (WAC) and Waste (Net). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
  #   type: number
  #   sql: ${sum_total_margin_abs_after_product_discount} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net} ;;
  #   value_format_name: eur
  # }

  measure: share_of_margin_net_eur_with_net_income_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "% Blended Margin (Net)"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold (Net)"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${sum_of_margin_net_eur} / nullif( ${sum_of_total_net_income_net_eur} ,0);;
    value_format_name: percent_1
  }

  # measure: pct_total_margin_relative_after_waste {
  #   required_access_grants: [can_access_pricing_margins]
  #   label: "% Blended Margin after Waste"
  #   description: "The sum of Gross Profit minus Waste (Net) divided by the sum of Item Prices Sold (Net)"
  #   type: number
  #   sql: (${sum_total_margin_abs} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net})  / nullif( ${sum_total_net_income} ,0);;
  #   value_format_name: percent_1
  # }

  measure: share_of_margin_after_product_discount_net_eur_with_net_income_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "% Blended Margin After Product Discount (Net)"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold after deduction of Product Discount (Net)"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${sum_of_margin_after_product_discount_net_eur} / nullif( ${sum_of_total_net_income_after_product_discount_net_eur} ,0);;
    value_format_name: percent_1
  }

  # measure: pct_total_margin_relative_after_product_discount_and_waste{
  #   required_access_grants: [can_access_pricing_margins]
  #   label: "% Blended Margin After Product Discount and Waste"
  #   description: "The sum of Gross Profit divided by the sum of Item Prices Sold after deduction of Product Discount (Net) and Waste (Net)"
  #   type: number
  #   sql: (${sum_total_margin_abs_after_product_discount} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net}) / nullif( ${sum_total_net_income_after_product_discount} ,0);;
  #   value_format_name: percent_1
  # }

  measure: sum_of_total_cost_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "Sum COGS (Net)"
    description: "The sum of Item Prices Sold (Net) minus sum of Gross Profit"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${sum_of_total_net_income_net_eur} - ${sum_of_margin_net_eur} ;;
    value_format_name: eur
  }

  measure: share_of_total_cost_net_eur_with_number_of_orders {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG COGS (Net)"
    description: "The total costs divided by the number of orders"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: (${sum_of_total_net_income_net_eur} - ${sum_of_margin_net_eur}) / ${count_order_uuid};;
    value_format_name: eur
  }

  measure: sum_of_total_cost_after_product_discount_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "Sum COGS After Product Discounts (Net)"
    description: "The sum of Item Prices Sold after deduction of Product Discount (Net) minus sum of Gross Profit"
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${sum_of_total_net_income_after_product_discount_net_eur} - ${sum_of_margin_after_product_discount_net_eur} ;;
    value_format_name: eur
  }

  measure: sum_of_gross_profit_after_product_discount_gross  {
    required_access_grants: [can_access_pricing_margins]
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
    required_access_grants: [can_access_pricing_margins]
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
    required_access_grants: [can_access_pricing_margins]
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
    required_access_grants: [can_access_pricing_margins]
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
    required_access_grants: [can_access_pricing_margins]
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
    required_access_grants: [can_access_pricing_margins]
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
    required_access_grants: [can_access_pricing_margins]
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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - -   Granular Cost Data Points
# - - - - - - - - - - - https://goflink.atlassian.net/browse/DATA-5635
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  measure: avg_amt_base_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Base Cost (Net)"
    description: "Average base cost of the SKU/supplier/country at the given location. This is the same cost that is on the item_supp_country table."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_base_cost_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_base_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Base Cost (Net)"
    description: "Sum of the total base cost of the SKU/supplier/country at the given location. This is the same cost that is on the item_supp_country table."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_base_cost_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Net Cost (Net)"
    description: "Average Net cost of the SKU/supplier/country at the given location. This is the base cost minus any deal components designated as applying to net cost on DEAL_DETAIL."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_net_cost_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_net_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Net Cost (Net)"
    description: "Sum of the total Net cost of the SKU/supplier/country at the given location. This is the base cost minus any deal components designated as applying to net cost on DEAL_DETAIL."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_net_cost_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_supplier_invoice_discount_wac_based_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Supplier Invoice Discount Wac Based (Net)"
    description: "Average discount on the supplier invoice, that mainly entails a standard refund for missing/wrong goods delivered. This metric is a percentage of the weighted average cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_supplier_invoice_discount_wac_based_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_supplier_invoice_discount_wac_based_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Supplier Invoice Discount Wac Based (Net)"
    description: "Sum of the total discount on the supplier invoice, that mainly entails a standard refund for missing/wrong goods delivered. This metric is a percentage of the weighted average cost."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_supplier_invoice_discount_wac_based_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_supplier_kickback_wac_based_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Supplier Kickback Wac Based (Net)"
    description: "Average contractural refund of a supplier, given certain conditions are met. These conditions are defined in Oracle deals tables. Can either be an absolute value or a percentage of the weighted average cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_supplier_kickback_wac_based_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_supplier_kickback_wac_based_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Supplier Kickback Wac Based (Net)"
    description: "Sum of the total contractural refund of a supplier, given certain conditions are met. These conditions are defined in Oracle deals tables. Can either be an absolute value or a percentage of the weighted average cost."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_supplier_kickback_wac_based_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_logistic_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Logistic Cost Net Cost Based (Net)"
    description: "Average of logistic cost demanded by the supplier. Calculated as a share of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_logistic_cost_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_logistic_net_cost_based_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Logistic Cost Net Cost Based (Net)"
    description: "Sum of total logistic cost demanded by the supplier. Calculated as a share of the net cost."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_logistic_net_cost_based_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_logistic_wac_based_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Logistic Cost WAC Based (Net)"
    description: "Average of logistic cost demanded by the supplier. Calculated as a share of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_logistic_wac_based_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_logistic_wac_based_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Logistic Cost WAC Based (Net)"
    description: "Sum of total logistic cost demanded by the supplier. Calculated as a share of the net cost."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_logistic_wac_based_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Net Net Cost (Net)"
    description: "Average of Net net cost of the SKU/supplier/country at the given location. This is the net cost minus any deal components designated as applying to net net cost on DEAL_DETAIL."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_net_net_cost_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_net_net_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Net Net Cost (Net)"
    description: "Sum of total Net net cost of the SKU/supplier/country at the given location. This is the net cost minus any deal components designated as applying to net net cost on DEAL_DETAIL."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_net_net_cost_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_partner_kickback_permanent_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Partner Kickback Permanent (Net)"
    description: "Average of kickback (refunded) amount from partners (not suppiers) when meeting some sales targets. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_partner_kickback_permanent_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_partner_kickback_permanent_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Partner Kickback Permanent (Net)"
    description: "Sum of total kickback (refunded) amount from partners (not suppiers) when meeting some sales targets. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_partner_kickback_permanent_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_partner_kickback_temporary_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Partner Kickback Temporary (Net)"
    description: "Average of kickback (refunded) amount from partners (not suppiers) when meeting some sales targets for temporary campaigns. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_partner_kickback_temporary_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_partner_kickback_temporary_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Partner Kickback Temporary (Net)"
    description: "Sum of total kickback (refunded) amount from partners (not suppiers) when meeting some sales targets for temporary campaigns. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_partner_kickback_temporary_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_dead_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Dead Net Net Cost (Net)"
    description: "Average of Dead net net cost of the SKU/supplier/country at the given location. This is the net net cost minus any deal components designated as applying to dead net net cost on DEAL_DETAIL."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_dead_net_net_cost_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_dead_net_net_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Dead Net Net Cost (Net)"
    description: "Sum of total Dead net net cost of the SKU/supplier/country at the given location. This is the net net cost minus any deal components designated as applying to dead net net cost on DEAL_DETAIL."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_dead_net_net_cost_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_promo_funding_partner_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Promo Funding Partner (Net)"
    description: "Average of promo funding amount accounts for revenues generated by partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_promo_funding_partner_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_promo_funding_partner_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Promo Funding Partner (Net)"
    description: "Sum of total promo funding amount accounts for revenues generated by partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_promo_funding_partner_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_promo_funding_marketing_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Promo Funding Marketing (Net)"
    description: "Average of promo funding amount accounts for revenues generated by partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_promo_funding_marketing_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_promo_funding_marketing_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Promo Funding Marketing (Net)"
    description: "Sum of total promo funding amount accounts for revenues generated by partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_promo_funding_marketing_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_promo_funding_supplier_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Promo Funding Supplier (Net)"
    description: "Average of promo funding amount accounts for revenues generated by suppliers when offering certain products"
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_promo_funding_supplier_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_promo_funding_supplier_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Promo Funding Supplier (Net)"
    description: "Sum of total promo funding amount accounts for revenues generated by suppliers when offering certain products"
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_promo_funding_supplier_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_pricing_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Pricing Cost (Net)"
    description: "Average of cost to be used to in pricing reviews. Pricing cost is the cost that will be interfaced with Oracle Price Management for use in pricing decisions."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_pricing_cost_net} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_pricing_cost_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Pricing Cost (Net)"
    description: "Sum of total cost to be used to in pricing reviews. Pricing cost is the cost that will be interfaced with Oracle Price Management for use in pricing decisions."
    group_label: "> Spot Costs"
    type: sum
    sql: ${amt_pricing_cost_net_total_cost} ;;
    value_format_name: eur
  }


  measure: avg_amt_wac_0_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG WAC0 (Net)"
    description: "Average value of our current stock before any deductions."
    group_label: "> WAC Calculations"
    type: average
    sql: ${amt_wac_0_net_unit_cost} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_wac_0_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total WAC0 (Net)"
    description: "Sum of total value of our current stock before any deductions."
    group_label: "> WAC Calculations"
    type: sum
    sql: ${amt_wac_0_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_wac_1_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG WAC1 (Net)"
    description: "Average value of our current stock with Supplier Invoice Discount deducted."
    group_label: "> WAC Calculations"
    type: average
    sql: ${amt_wac_1_net_unit_cost} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_wac_1_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total WAC1 (Net)"
    description: "Sum of total value of our current stock with Supplier Invoice Discount deducted."
    group_label: "> WAC Calculations"
    type: sum
    sql: ${amt_wac_1_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_wac_2_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG WAC2 (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback and Logistic Cost."
    group_label: "> WAC Calculations"
    type: average
    sql: ${amt_wac_2_net_unit_cost} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_wac_2_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total WAC2 (Net)"
    description: "Sum of total value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback and Logistic Cost."
    group_label: "> WAC Calculations"
    type: sum
    sql: ${amt_wac_2_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_wac_3_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG WAC3 (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost and Permanent Partner Kickback."
    group_label: "> WAC Calculations"
    type: average
    sql: ${amt_wac_3_net_unit_cost} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_wac_3_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total WAC3 (Net)"
    description: "Sum of total value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost and Permanent Partner Kickback."
    group_label: "> WAC Calculations"
    type: sum
    sql: ${amt_wac_3_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_wac_4_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG WAC4 (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost, Permanent and Temporary Partner Kickback."
    group_label: "> WAC Calculations"
    type: average
    sql: ${amt_wac_4_net_unit_cost} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_wac_4_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total WAC4 (Net)"
    description: "Sum of total value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost, Permanent and Temporary Partner Kickback."
    group_label: "> WAC Calculations"
    type: sum
    sql: ${amt_wac_4_net_total_cost} ;;
    value_format_name: eur
  }

  measure: avg_amt_full_wac_net_unit_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Full WAC (Net)"
    description: "Average value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost, Permanent and Temporary Partner Kickback, Supplier Promo Funding, Partner Promo Funding and Marketing Promo Funding."
    group_label: "> WAC Calculations"
    type: average
    sql: ${amt_full_wac_net_unit_cost} ;;
    value_format_name: eur
  }

  measure: sum_of_amt_full_wac_net_total_cost {
    required_access_grants: [can_access_pricing_margins]
    label: "SUM Total Full WAC (Net)"
    description: "Sum of total value of our current stock with the deduction of Supplier Invoice Discount, Supplier Kickback, Logistic Cost, Permanent and Temporary Partner Kickback, Supplier Promo Funding, Partner Promo Funding and Marketing Promo Funding."
    group_label: "> WAC Calculations"
    type: sum
    sql: ${amt_full_wac_net_total_cost} ;;
    value_format_name: eur
  }


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}
