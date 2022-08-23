include: "/**/inventory_changes_daily.view"

view: inventory_changes_daily_extended {

  extends: [inventory_changes_daily]



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Dimensions - HIDDEN
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: in_and_outbounded_items_by_buying_prices_net {

    alias: [in_and_outbounded_items_by_buying_prices]

    label: "€ Items Value (by Buying Price Net)"
    description: "In-and-outbounded items value based on buying prices corresponding to the inventory change date."

    type: number
    sql:  ${quantity_change} * ${product_prices_daily.buying_price};;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur

    hidden: yes
  }

  dimension: in_and_outbounded_items_by_buying_prices_gross {

    label: "€ Items Value (by Buying Price Gross)"
    description: "In-and-outbounded items value based on buying prices corresponding to the inventory change date and converted to a gross buying price."

    type: number
    sql:  ${quantity_change} * ${product_prices_daily.buying_price} * ( 1 + ${products.tax_rate}) ;;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur

    hidden: yes
  }

  dimension: in_and_outbounded_items_by_product_price_gross {

    label: "€ Items Value (by Product Price Gross)"
    description: "In-and-outbounded items value based on average product prices (gross) corresponding to the inventory change date."

    type: number
    sql:  ${quantity_change} * ${product_prices_daily.avg_amt_product_price_gross};;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur

    hidden: yes
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  measure: sum_in_and_outbounded_items_by_buying_prices_net {

    alias: [sum_in_and_outbounded_items_by_buying_prices]

    label:       "€ Item Value (Buying Price Net)"
    description: "In-and-outbounded items value based on net buying prices corresponding to the inventory change date."

    type: sum
    sql:  ${in_and_outbounded_items_by_buying_prices_net} ;;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur
  }

  measure: sum_in_and_outbounded_items_by_buying_prices_gross {

    alias: [sum_in_and_outbounded_items_by_buying_prices]

    label:       "€ Item Value (Buying Price Gross)"
    description: "In-and-outbounded items value based on gross buying prices corresponding to the inventory change date."

    type: sum
    sql:  ${in_and_outbounded_items_by_buying_prices_gross} ;;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur
  }

  measure: sum_in_and_outbounded_items_by_product_price_gross {

    label: "€ Item Value (Selling Price)"
    description: "In-and-outbounded items value based on average product prices (gross) corresponding to the inventory change date."

    type: sum
    sql:  ${in_and_outbounded_items_by_product_price_gross} ;;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur
  }

  measure: sum_outbound_waste_per_buying_price_net {

    label:       "€ Outbounded Items (Waste - per Buying Price Net)"
    description: "The quantity '# Outbound (Waste)' multiplied by the net buying price of the product"
    group_label: ">> Waste Metrics"

    type: sum
    sql: abs(${quantity_change}) * ${product_prices_daily.buying_price};;
    required_access_grants: [can_view_buying_information]
    filters: [is_outbound_waste: "Yes"]
    value_format_name: eur
  }

  measure: sum_outbound_waste_per_buying_price_gross {

    ## IMPORTANT: for a few

    label:       "€ Outbounded Items (Waste - per Buying Price Gross)"
    description: "The quantity '# Outbound (Waste)' multiplied by the gross buying price of the product"
    group_label: ">> Waste Metrics"

    type: sum
    sql: abs(${quantity_change}) * ${product_prices_daily.buying_price} * ( 1 + ${products.tax_rate});;
    required_access_grants: [can_view_buying_information]
    filters: [is_outbound_waste: "Yes"]
    value_format_name: eur
  }

}
