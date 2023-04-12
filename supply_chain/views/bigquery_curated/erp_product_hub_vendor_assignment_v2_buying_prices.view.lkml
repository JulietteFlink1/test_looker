include: "/**/erp_product_hub_vendor_assignment.view"

view: +erp_product_hub_vendor_assignment {

  set: pricing_fields_refined {
    fields: [
      net_income,
      margin_absolute,
      margin_relative,
      avg_vendor_price,
      sum_total_net_income,
      sum_total_margin_abs,
      sum_vendor_price,
      pct_total_margin_relative
    ]
  }

  required_access_grants: [can_access_pricing_margins]

  dimension: net_income {

    label: "Net Income"
    description: "The incoming cash defined as net item-price"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: number
    sql:  ${order_lineitems.unit_price_gross_amount} / nullif((1 + ${order_lineitems.tax_rate}) ,0);;

    value_format_name: eur

    hidden: yes
  }

  dimension: margin_absolute {

    label: "Margin (absolute)"
    description: "The absolute margin defined as Net Income substracted by the Buying Price"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: number
    sql: ${net_income} - ${vendor_price} ;;

    value_format_name: eur

    hidden: yes
  }

  dimension: margin_relative {

    label: "Margin (%)"
    description: "The relative margin defined as the Margin (absolute) divided by the Net Income"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: number
    sql: ${margin_absolute} / nullif(${net_income},0) ;;

    value_format_name: percent_1

    hidden: yes
  }

  measure: avg_vendor_price {

    label: "AVG Buying Price"
    description: "The average buying price"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: average
    sql: ${vendor_price} ;;

    value_format_name: decimal_4

    hidden: yes
  }

  measure: sum_total_net_income {

    label: "€ Total Net Income"
    description: "The sum of all unit_prices multiplied by the quantity of products sold"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: sum
    sql: (${order_lineitems.quantity} * ${net_income}) ;;

    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${order_lineitems.order_lineitem_uuid}) ;;

    hidden: yes
  }

  measure: sum_vendor_price {

    label: "€ Total Buying Cost for Items Sold"
    description: "The sum of buying costs multiplied by the number of sold items"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: sum
    sql: (${order_lineitems.quantity} * ${vendor_price}) ;;

    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${order_lineitems.order_lineitem_uuid}) ;;

    hidden: yes


  }

  measure: sum_total_margin_abs {

    label: "€ Total Margin"
    description: "The sum of all margins defined as Net Income minus Buying Price"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: sum
    sql: (${order_lineitems.quantity} * ${margin_absolute}) ;;

    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${order_lineitems.order_lineitem_uuid}) ;;

    hidden: yes
  }

  measure: pct_total_margin_relative {

    label: "% Total Margin"
    description: "The € Total Margin divided by the € Total Net Income"
    group_label: "> Buying Prices (CONFIDENTIAL)"

    type: number
    sql: ${sum_total_margin_abs} / nullif( ${sum_total_net_income} ,0);;

    value_format_name: percent_1

    hidden: yes
  }

}
