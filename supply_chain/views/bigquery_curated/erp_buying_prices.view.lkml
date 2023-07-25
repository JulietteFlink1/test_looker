include: "/**/*.view"

view: erp_buying_prices {

  sql_table_name: `flink-data-prod.curated.erp_buying_prices`;;

  required_access_grants: [can_access_pricing_margins]

  view_label: "* ERP Supplier Prices *"




  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~     Sets     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Defined for those margin metrics that substract waste (inventory_changes_daily view) from calculation.
  set: margin_metrics_customized {
    fields: [
      sum_total_margin_abs_after_waste,
      sum_total_margin_abs_after_product_discount_and_waste,
      pct_total_margin_relative_after_waste,
      pct_total_margin_relative_after_product_discount_and_waste
    ]
  }

  # all non-orderline related fields
  set: erp_buying_prices_base {
    fields: [
      erp_vendor_name,
      supplier_site,
      erp_item_name,
      is_price_promotional,
      vendor_price,
      amt_buying_price_net_eur,
      amt_weighted_average_cost_net_eur,
      amt_base_cost_net,
      amt_net_cost_net,
      amt_net_net_cost_net,
      amt_dead_net_net_cost_net,
      amt_pricing_cost_net,
      report_date,
      country_iso,
      erp_vendor_id,
      hub_code,
      sku,
      ctn_skus,
      avg_vendor_price,
      avg_amt_base_cost_net,
      avg_amt_net_cost_net,
      avg_amt_net_net_cost_net,
      avg_amt_dead_net_net_cost_net,
      avg_amt_pricing_cost_net,
      avg_amt_base_cost_net,
      avg_amt_net_cost_net,
      avg_amt_logistic_cost_net,
      avg_amt_net_net_cost_net,
      avg_amt_partner_kickback_permanent_net,
      avg_amt_partner_kickback_temporary_net,
      avg_amt_dead_net_net_cost_net,
      avg_amt_promo_funding_partner_net,
      avg_amt_promo_funding_marketing_net,
      avg_amt_promo_funding_supplier_net,
      avg_amt_pricing_cost_net,
      avg_amt_supplier_invoice_discount_wac_based_net,
      avg_amt_supplier_invoice_discount_net_cost_based_net,
      avg_amt_supplier_kickback_wac_based_net,
      avg_amt_supplier_kickback_net_cost_based_net,
    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  # =========  __main__   =========
  dimension: net_income {
    label: "Net Unit Price"
    description: "The incoming cash defined as net item price"
    type: number
    sql:  if(${vendor_price} is not null,
            coalesce(
              ${orderline.unit_price_gross_amount} / nullif((1 + ${orderline.tax_rate}) ,0),
              ${products.amt_product_price_gross}  / nullif((1 + ${products.tax_rate}), 0)
            ),
            null)
    ;;
    value_format_name: eur
  }

  dimension: net_income_after_product_discount {
    label: "Net Unit Price After Product Discount"
    description: "The incoming cash defined as net item price after deduction of Product Discount"
    type: number
    sql:  if(${vendor_price} is not null,
            coalesce(
              ${orderline.unit_price_after_product_discount_gross} / nullif((1 + ${orderline.tax_rate}) ,0),
              ${products.amt_product_price_gross}  / nullif((1 + ${products.tax_rate}), 0)
            ),
            null)
    ;;
    value_format_name: eur
  }

  dimension: net_income_legacy {
    label: "Net Unit Price"
    description: "The incoming cash defined as net item price"
    type: number
    sql:  coalesce(
            ${orderline.unit_price_gross_amount} / nullif((1 + ${orderline.tax_rate}) ,0),
            ${products.amt_product_price_gross}  / nullif((1 + ${products.tax_rate}), 0)
          )
    ;;
    value_format_name: eur
    hidden: yes
  }

  dimension: net_income_after_product_discount_legacy {
    label: "Net Unit Price After Product Discount"
    description: "The incoming cash defined as net item price after deduction of Product Discount"
    type: number
    sql:  coalesce(
            ${orderline.unit_price_after_product_discount_gross} / nullif((1 + ${orderline.tax_rate}) ,0),
            ${products.amt_product_price_gross}  / nullif((1 + ${products.tax_rate}), 0)
          )
    ;;
    value_format_name: eur
    hidden: yes
  }

  dimension: margin_absolute {
    label: "€ Unit Margin"
    description: "The unit margin defined as Net Unit Price substracted by the Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    type: number
    sql: ${net_income} - ${vendor_price} ;;
    value_format_name: eur
  }

  dimension: margin_absolute_after_product_discount {
    label: "€ Unit Margin After Product Discount"
    description: "The unit margin defined as Net Unit Price after deduction of Product Discount  substracted by the Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    type: number
    sql: ${net_income_after_product_discount} - ${vendor_price} ;;
    value_format_name: eur
  }

  dimension: margin_relative {
    label: "% Unit Margin"
    description: "The relative margin defined as Unit Margin divided by the Net Unit Price"
    type: number
    sql: ${margin_absolute} / nullif(${net_income},0) ;;
    value_format_name: percent_1
  }

  dimension: margin_relative_after_product_discount {
    label: "% Unit Margin After Product Discount"
    description: "The relative margin defined as Unit Margin divided by the Net Unit Price after deduction of Product Discount"
    type: number
    sql: ${margin_absolute_after_product_discount} / nullif(${net_income_after_product_discount},0) ;;
    value_format_name: percent_1
  }

  dimension: erp_vendor_name {
    label: "Supplier Name"
    type: string
    sql: ${TABLE}.erp_vendor_name ;;

    # this field is not part of the refactored table anymore, but can be derived from e.g. erp_product_hub_vendor_assignment_v2
    hidden: no
  }

  dimension: supplier_site {
    label: "Supplier Site"
    type: string
    sql: ${TABLE}.supplier_site ;;
    description: "Site of the supplier/vendor of a product, defined as Supplier Name + Location."
    hidden: no
  }

  dimension: erp_item_name {
    label: "Product Name (ERP)"
    type: string
    sql: ${TABLE}.erp_item_name ;;

    # this field is not part of the refactored table anymore, but can be derived from e.g. erp_product_hub_vendor_assignment_v2
    hidden: yes
  }

  dimension: valid_to {
    label: "Price Valid To"
    type: date
    convert_tz: no
    datatype: date
    sql: ${TABLE}.valid_to ;;
  }

  dimension: valid_from {
    label: "Price Valid From"
    type: date
    convert_tz: no
    datatype: date
    sql: ${TABLE}.valid_from ;;
  }

  dimension: is_price_promotional {
    label: "Is Promotional Price"
    description: "Yes/No: Is the price a special promo price or the regular price"
    type: yesno
    sql: ${TABLE}.is_price_promotional ;;
  }

  dimension: vendor_price {
    label: "Weighted Average Cost (WAC) Net"
    description: "Buying price, that can be used for product sales. It resembles the weighted buying price of the current stock. This is done (in Oracle) to ensure that we value the inventory at any given day with the average value of our current stock (and not with the most recent buying price to place a supplier order). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    type: number
    sql: coalesce(
            ${TABLE}.amt_buying_price_weighted_rolling_average_net_eur,
            ${TABLE}.amt_buying_price_net_eur
            );;
    value_format_name: decimal_4
  }

  dimension: amt_buying_price_net_eur {
    required_access_grants: [can_access_pricing_margins]
    type: number
    sql: ${TABLE}.amt_buying_price_net_eur;;
    hidden: yes
  }

  dimension: amt_weighted_average_cost_net_eur {
    required_access_grants: [can_access_pricing_margins]
    label: "Weighted Average Cost (WAC) (Net)."
    description: "Buying price, that can be used for product sales. It resembles the weighted buying price of the current stock. This is done (in Oracle) to ensure that we value the inventory at any given day with the average value of our current stock (and not with the most recent buying price to place a supplier order). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    group_label: "> Monetary Metrics (P&L)"
    type: number
    sql: ${TABLE}.amt_buying_price_weighted_rolling_average_net_eur ;;
    value_format_name: decimal_4
    hidden: yes
  }


  dimension: amt_base_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Amt Base Cost Net"
    description: "Base cost of the SKU/supplier/country at the given location. This is the same cost that is on the item_supp_country table."
    type: number
    sql: ${TABLE}.amt_base_cost_net ;;
    value_format_name: decimal_4
    hidden: yes
  }


  dimension: amt_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Amt Net Cost Net"
    description: "Net cost of the SKU/supplier/country at the given location. This is the base cost minus any deal components designated as applying to net cost on DEAL_DETAIL."
    type: number
    sql: ${TABLE}.amt_net_cost_net ;;
    value_format_name: decimal_4
    hidden: yes
  }


  dimension: amt_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Amt Net Net Cost Net"
    description: "Net net cost of the SKU/supplier/country at the given location. This is the net cost minus any deal components designated as applying to net net cost on DEAL_DETAIL."
    type: number
    sql: ${TABLE}.amt_net_net_cost_net ;;
    value_format_name: decimal_4
    hidden: yes
  }


  dimension: amt_dead_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Amt Dead Net Net Cost Net"
    description: "Dead net net cost of the SKU/supplier/country at the given location. This is the net net cost minus any deal components designated as applying to dead net net cost on DEAL_DETAIL."
    type: number
    sql: ${TABLE}.amt_dead_net_net_cost_net ;;
    value_format_name: decimal_4
    hidden: yes
  }


  dimension: amt_pricing_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "Amt Pricing Cost Net"
    description: "Cost to be used to in pricing reviews. Pricing cost is the cost that will be interfaced with Oracle Price Management for use in pricing decisions."
    type: number
    sql: ${TABLE}.amt_pricing_cost_net ;;
    value_format_name: decimal_4
    hidden: yes
  }


  dimension: amt_logistic_cost_net {
    label: "Logistic Cost (Net)"
    description: "Logistic cost demanded by the supplier. Calculated as a share of the net cost."
    type: number
    hidden: yes
    sql: ${TABLE}.amt_logistic_cost_net ;;
  }


  dimension: amt_partner_kickback_permanent_net {
    label: "Partner Kickback Permanent (Net)"
    description: "Kickback (refunded) amount from partners (not suppiers) when meeting some sales targets. Either an absolute value or a percentage of the net cost."
    type: number
    hidden: yes
    sql: ${TABLE}.amt_partner_kickback_permanent_net ;;
  }


  dimension: amt_partner_kickback_temporary_net {
    label: "Partner Kickback Temporary (Net)"
    description: "Kickback (refunded) amount from partners (not suppiers) when meeting some sales targets for temporary campaigns.Either an absolute value or a percentage of the net cost."
    type: number
    hidden: yes
    sql: ${TABLE}.amt_partner_kickback_temporary_net ;;
  }


  dimension: amt_promo_funding_partner_net {
    label: "Promo Funding Partner (Net)"
    description: "Promo funding amount accounts for revenues generated from partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost."
    type: number
    hidden: yes
    sql: ${TABLE}.amt_promo_funding_partner_net ;;
  }


  dimension: amt_promo_funding_marketing_net {
    label: "Promo Funding Marketing (Net)"
    description: "Promo funding amount accounts for revenues generated from partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost."
    type: number
    hidden: yes
    sql: ${TABLE}.amt_promo_funding_marketing_net ;;
  }


  dimension: amt_promo_funding_supplier_net {
    label: "Promo Funding Supplier (Net)"
    description: "Promo funding amount accounts for revenues generated from suppliers when offering certain products"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_promo_funding_supplier_net ;;
  }


  dimension: amt_supplier_invoice_discount_wac_based_net {
    label: "Amt Supplier Invoice Discount Wac Based Net"
    description: "The discount on the supplier invoice, that mainly entails a standard refund for missing/wrong goods delivered. This metric is a percentage of the weighted average cost."
    type: number
    hidden: yes
    sql: ${TABLE}.amt_supplier_invoice_discount_wac_based_net ;;
  }


  dimension: amt_supplier_invoice_discount_net_cost_based_net {
    label: "Amt Supplier Invoice Discount Net Cost Based Net"
    description: "The discount on the supplier invoice, that mainly entails a standard refund for missing/wrong goods delivered. This metric is a percentage of the net-cost."
    type: number
    hidden: yes
    sql: ${TABLE}.amt_supplier_invoice_discount_net_cost_based_net ;;
  }


  dimension: amt_supplier_kickback_wac_based_net {
    label: "Amt Supplier Kickback Wac Based Net"
    description: "Contractural refund of a supplier, given certain conditions are met. These conditions are defined in Oracle deals tables. Can either be an absolute value or a percentage of the weighted average cost."
    type: number
    hidden: yes
    sql: ${TABLE}.amt_supplier_kickback_wac_based_net ;;
  }


  dimension: amt_supplier_kickback_net_cost_based_net {
    label: "Amt Supplier Kickback Net Cost Based Net"
    description: "Contractural refund of a supplier, given certain conditions are met. These conditions are defined in Oracle deals tables. Can either be an absolute value or a percentage of the net cost"
    type: number
    hidden: yes
    sql: ${TABLE}.amt_supplier_kickback_net_cost_based_net ;;
  }




  # =========  hidden   =========
  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
    hidden: yes
  }

  dimension_group: ingestion_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.ingestion_timestamp ;;
    hidden: yes
  }

  dimension: report_date {
    type: date
    datatype: date
    sql: ${TABLE}.ingestion_timestamp ;;
    hidden: no
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    # for joining only
    hidden: yes
  }

  dimension: erp_vendor_id {
    label: "Supplier ID"
    type: string
    sql: ${TABLE}.erp_vendor_id ;;
    # for joining only
    hidden: yes
  }

  dimension: erp_warehouse_id {
    type: string
    sql: ${TABLE}.erp_warehouse_id ;;
    # for joining only
    hidden: yes
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    # for joining only
    hidden: yes
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    # for joining only
    hidden: yes
  }

  measure: ctn_skus {

    label: "# Unique SKUs"

    type: count_distinct
    sql: ${sku} ;;
  }

  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: avg_vendor_price {
    label: "AVG Weighted Average Cost (WAC)"
    description: "The simple average of Weighted Average Cost (WAC)s. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    type: average
    sql: ${vendor_price} ;;
    value_format_name: decimal_4
  }

  measure: sum_total_net_income {
    label: "€ Sum Item Prices Sold (Net)"
    description: "The sum of all Net Unit Price multiplied by the sum of Item Quantity Sold"
    type: sum
    sql: (${orderline.quantity} * ${net_income}) ;;
    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${orderline.order_lineitem_uuid}) ;;
  }

  measure: sum_total_net_income_after_product_discount{
    label: "€ Sum Item Prices Sold After Product Discount (Net)"
    description: "The sum of all Net Unit Price after deduction of Product Discount multiplied by the sum of Item Quantity Sold"
    type: sum
    sql: (${orderline.quantity} * ${net_income_after_product_discount}) ;;
    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${orderline.order_lineitem_uuid}) ;;
  }

  measure: sum_total_margin_abs {
    label: "€ Sum Gross Profit"
    description: "The sum of all Unit Margins defined as Net Unit Price minus Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    type: sum
    sql: (${orderline.quantity} * ${margin_absolute}) ;;
    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${orderline.order_lineitem_uuid}) ;;
  }

  measure: sum_total_margin_abs_after_waste {
    label: "€ Sum Gross Profit after Waste"
    description: "The sum of all Unit Margins defined as Net Unit Price minus Weighted Average Cost (WAC) after Waste (Net). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    type: number
    sql: ${sum_total_margin_abs} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net} ;;
    value_format_name: eur
  }

  measure: sum_total_margin_abs_after_product_discount {
    label: "€ Sum Gross Profit After Product Discount"
    description: "The sum of all Unit Margins defined as Net Unit Price after deduction of Product Discount minus Weighted Average Cost (WAC). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    type: sum
    sql: (${orderline.quantity} * ${margin_absolute_after_product_discount}) ;;
    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${orderline.order_lineitem_uuid}) ;;
  }

  measure: sum_total_margin_abs_after_product_discount_and_waste {
    label: "€ Sum Gross Profit After Product Discount and Waste"
    description: "The sum of all Unit Margins defined as Net Unit Price after deduction of Product Discount minus Weighted Average Cost (WAC) and Waste (Net). ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
    type: number
    sql: ${sum_total_margin_abs_after_product_discount} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net} ;;
    value_format_name: eur
  }

  measure: pct_total_margin_relative {
    label: "% Blended Margin"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold (Net)"
    type: number
    sql: ${sum_total_margin_abs} / nullif( ${sum_total_net_income} ,0);;
    value_format_name: percent_1
  }

  measure: pct_total_margin_relative_after_waste {
    label: "% Blended Margin after Waste"
    description: "The sum of Gross Profit minus Waste (Net) divided by the sum of Item Prices Sold (Net)"
    type: number
    sql: (${sum_total_margin_abs} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net})  / nullif( ${sum_total_net_income} ,0);;
    value_format_name: percent_1
  }

  measure: pct_total_margin_relative_after_product_discount {
    label: "% Blended Margin After Product Discount"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold after deduction of Product Discount (Net)"
    type: number
    sql: ${sum_total_margin_abs_after_product_discount} / nullif( ${sum_total_net_income_after_product_discount} ,0);;
    value_format_name: percent_1
  }

  measure: pct_total_margin_relative_after_product_discount_and_waste{
    label: "% Blended Margin After Product Discount and Waste"
    description: "The sum of Gross Profit divided by the sum of Item Prices Sold after deduction of Product Discount (Net) and Waste (Net)"
    type: number
    sql: (${sum_total_margin_abs_after_product_discount} - ${inventory_changes_daily.sum_outbound_waste_per_buying_price_net}) / nullif( ${sum_total_net_income_after_product_discount} ,0);;
    value_format_name: percent_1
  }

  measure: sum_total_cost {
    label: "€ Sum COGS"
    description: "The sum of Item Prices Sold (Net) minus sum of Gross Profit"
    type: number
    sql: ${sum_total_net_income} - ${sum_total_margin_abs} ;;
    value_format_name: eur
  }

  measure: avg_total_cost {
    label: "€ AVG COGS"
    description: ""
    type: number
    sql: (${sum_total_net_income} - ${sum_total_margin_abs}) / ${orderline.count_order_uuid};;
    value_format_name: eur
  }

  measure: sum_total_cost_after_product_discount {
    label: "€ Sum COGS After Product Discounts"
    description: "The sum of Item Prices Sold after deduction of Product Discount (Net) minus sum of Gross Profit"
    type: number
    sql: ${sum_total_net_income_after_product_discount} - ${sum_total_margin_abs_after_product_discount} ;;
    value_format_name: eur
  }

  measure: sum_gross_profit_after_product_discount_gross  {

    label: "€ Gross Profit after Product Discount (Gross)"
    description: "The gross profit after product discounts (gross) for sold products"

    type: number
    sql: ${pct_total_margin_relative_after_product_discount} * ${orderline.sum_item_price_after_product_discount_gross} ;;
    value_format_name: eur
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~     Dynamic Measures & Dimensions     ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: net_income_dynamic {
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
  }

  dimension: margin_absolute_dynamic {
    label: "€ Unit Margin (Dynamic)"
    description: "The unit margin defined as Net Unit Price substracted by the Weighted Average Cost (WAC). To be used together with Is After Deduction of Product Discounts parameter. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
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
  }

  measure: sum_total_net_income_dynamic {
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
    label: "€ Sum Gross Profit (Dynamic)"
    description: "The sum of all Unit Margins defined as Net Unit Price minus Weighted Average Cost (WAC). To be used together with Is After Deduction of Product Discounts parameter. ℹ️ Before 27th. of Jan 2023, this field is using the simple unit cost."
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



  measure: avg_amt_base_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Base Cost (Net)"
    description: "Base cost of the SKU/supplier/country at the given location. This is the same cost that is on the item_supp_country table."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_base_cost_net} ;;
    value_format_name: decimal_4
  }


  measure: avg_amt_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Net Cost (Net)"
    description: "Net cost of the SKU/supplier/country at the given location. This is the base cost minus any deal components designated as applying to net cost on DEAL_DETAIL."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_net_cost_net} ;;
    value_format_name: decimal_4
  }


  measure: avg_amt_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Net Net Cost (Net)"
    description: "Net net cost of the SKU/supplier/country at the given location. This is the net cost minus any deal components designated as applying to net net cost on DEAL_DETAIL."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_net_net_cost_net} ;;
    value_format_name: decimal_4
  }


  measure: avg_amt_dead_net_net_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Dead Net Net Cost (Net)"
    description: "Dead net net cost of the SKU/supplier/country at the given location. This is the net net cost minus any deal components designated as applying to dead net net cost on DEAL_DETAIL."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_dead_net_net_cost_net} ;;
    value_format_name: decimal_4
  }


  measure: avg_amt_pricing_cost_net {
    required_access_grants: [can_access_pricing_margins]
    label: "AVG Pricing Cost (Net)"
    description: "Cost to be used to in pricing reviews. Pricing cost is the cost that will be interfaced with Oracle Price Management for use in pricing decisions."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_pricing_cost_net} ;;
    value_format_name: decimal_4
  }

  measure: avg_amt_logistic_cost_net {
    label: "AVG Logistic Cost (Net)"
    description: "Logistic cost demanded by the supplier. Calculated as a share of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_logistic_cost_net} ;;
    value_format_name: eur
  }

  measure: avg_amt_partner_kickback_permanent_net {
    label: "AVG Partner Kickback Permanent (Net)"
    description: "Kickback (refunded) amount from partners (not suppiers) when meeting some sales targets. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_partner_kickback_permanent_net} ;;
    value_format_name: eur
  }

  measure: avg_amt_partner_kickback_temporary_net {
    label: "AVG Partner Kickback Temporary (Net)"
    description: "Kickback (refunded) amount from partners (not suppiers) when meeting some sales targets for temporary campaigns.Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_partner_kickback_temporary_net} ;;
    value_format_name: eur
  }

  measure: avg_amt_promo_funding_partner_net {
    label: "AVG Promo Funding Partner (Net)"
    description: "Promo funding amount accounts for revenues generated from partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_promo_funding_partner_net} ;;
    value_format_name: eur
  }

  measure: avg_amt_promo_funding_marketing_net {
    label: "AVG Promo Funding Marketing (Net)"
    description: "Promo funding amount accounts for revenues generated from partners (not suppliers) when offering their products in special app positions. Either an absolute value or a percentage of the net cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_promo_funding_marketing_net} ;;
    value_format_name: eur
  }

  measure: avg_amt_promo_funding_supplier_net {
    label: "AVG Promo Funding Supplier (Net)"
    description: "Promo funding amount accounts for revenues generated from suppliers when offering certain products"
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_promo_funding_supplier_net} ;;
    value_format_name: eur
  }

  measure: avg_amt_supplier_invoice_discount_wac_based_net {
    label: "AVG Supplier Invoice Discount Wac Based (Net)"
    description: "The discount on the supplier invoice, that mainly entails a standard refund for missing/wrong goods delivered. This metric is a percentage of the weighted average cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_supplier_invoice_discount_wac_based_net} ;;
    value_format_name: eur
  }


  measure: avg_amt_supplier_invoice_discount_net_cost_based_net {
    label: "AVG Supplier Invoice Discount Net Cost Based (Net)"
    description: "The discount on the supplier invoice, that mainly entails a standard refund for missing/wrong goods delivered. This metric is a percentage of the net-cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_supplier_invoice_discount_net_cost_based_net} ;;
    value_format_name: eur
  }


  measure: avg_amt_supplier_kickback_wac_based_net {
    label: "AVG Supplier Kickback Wac Based (Net)"
    description: "Contractural refund of a supplier, given certain conditions are met. These conditions are defined in Oracle deals tables. Can either be an absolute value or a percentage of the weighted average cost."
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_supplier_kickback_wac_based_net} ;;
    value_format_name: eur
  }


  measure: avg_amt_supplier_kickback_net_cost_based_net {
    label: "AVG Supplier Kickback Net Cost Based (Net)"
    description: "Contractural refund of a supplier, given certain conditions are met. These conditions are defined in Oracle deals tables. Can either be an absolute value or a percentage of the net cost"
    group_label: "> Spot Costs"
    type: average
    sql: ${amt_supplier_kickback_net_cost_based_net} ;;
    value_format_name: eur
  }

}
