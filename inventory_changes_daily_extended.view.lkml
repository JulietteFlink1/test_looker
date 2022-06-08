include: "/**/inventory_changes_daily.view"

view: inventory_changes_daily_extended {

  extends: [inventory_changes_daily]


  dimension: in_and_outbounded_items_by_buying_prices {

    label: "Items Value (by Buying Price)"
    description: "In-and-outbounded items value based on buying prices corresponding to the inventory change date."

    type: number
    sql:  ${inventory_changes_daily.quantity_change} * ${product_prices_daily.buying_price};;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur

    hidden: yes
  }

  dimension: in_and_outbounded_items_by_product_price_gross {

    label: "Items Value (by Product Price)"
    description: "In-and-outbounded items value based on average product prices (gross) corresponding to the inventory change date."

    type: number
    sql:  ${inventory_changes_daily.quantity_change} * ${product_prices_daily.avg_amt_product_price_gross};;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur

    hidden: yes
  }

  measure: sum_in_and_outbounded_items_by_buying_prices {

    label: "€ Sum Items Value (by Buying Price)"
    description: "In-and-outbounded items value based on buying prices corresponding to the inventory change date."

    type: sum
    sql:  ${in_and_outbounded_items_by_buying_prices} ;;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur

    hidden: no
  }

  measure: sum_in_and_outbounded_items_by_product_price_gross {

    label: "€ Sum Items Value (by Product Price)"
    description: "In-and-outbounded items value based on average product prices (gross) corresponding to the inventory change date."

    type: sum
    sql:  ${in_and_outbounded_items_by_product_price_gross} ;;
    required_access_grants: [can_view_buying_information]

    value_format_name: eur

    hidden: no
  }

}
