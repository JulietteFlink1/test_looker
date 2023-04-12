include: "/**/sku_performance_base.view"

view: +sku_performance_base {


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures Reporting Period     ~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_item_revenue_gross_corrected {

    label:       "€ Item Revenue (Gross) [L4W]"
    description: "The GMV generated by a product"
    group_label: "Report Period"

    type: sum
    sql: ${item_revenue_gross_corrected} ;;

    value_format_name: decimal_0

  }

  measure: sum_item_revenue_net_corrected {

    label:       "€ Item Revenue (Net) [L4W]"
    description: "The GMV generated by a product"
    group_label: "Report Period"

    type: sum
    sql: ${item_revenue_net_corrected} ;;

    value_format_name: decimal_0

  }

  measure: pct_item_revenue_gross_corrected_vs_total {

    label:       "% Item Revenue vs. Total [L4W]"
    description: "The item revenue of the SKU compared with the total revenu per hub in the reporting period"
    group_label: "Report Period"

    type: average
    sql: ${item_revenue_gross_corrected} / nullif(${total_item_revenue_gross_corrected} ,0) ;;

    value_format_name: percent_4
  }

  measure: sum_number_of_connections {

    label:       "# Item-Connections [L4W]"
    description: "The number of items, that were in the same baskets than the SKU of interest, given that the 2 items were ordered together at least 5 times (per hub in reporting period)"
    group_label: "Report Period"

    type: sum
    sql: ${number_of_connections} ;;

    value_format_name: decimal_0

    hidden: yes

  }

  measure: avg_number_of_connections {

    label:       "AVG Item-Connections [L4W]"
    description: "The number of items, that were in the same baskets than the SKU of interest, given that the 2 items were ordered together at least 5 times (per hub in reporting period)"
    group_label: "Report Period"

    type: average
    sql: ${number_of_connections} ;;

    value_format_name: decimal_0

  }

  measure: sum_number_of_orders_corrected {

    label:       "# Orders [L4W]"
    description: "The number of orders, given the SKU is included"
    group_label: "Report Period"

    type: sum
    sql: ${number_of_orders_corrected} ;;

    value_format_name: decimal_0

  }

  measure: pct_number_of_orders_corrected_vs_total {

    label:       "% Orders vs. Total [L4W]"
    description: "The number of orders with the SKU compared with the total number of orders per hub in the reporting period"
    group_label: "Report Period"

    type: average
    sql: ${number_of_orders_corrected} / nullif( ${total_number_of_orders_corrected} ,0) ;;

    value_format_name: percent_4
  }


  measure: avg_order_value_gross_corrected {

    label:       "€ AVG Order Value [L4W]"
    description: "The average order value, given that the specific SKU is part of the basket"
    group_label: "Report Period"

    type: average
    sql: ${order_value_gross_corrected} ;;

    value_format_name: eur

  }

  measure:pct_order_value_gross_corrected_vs_total  {

    label:       "% AVG Order Value vs Total [L4W]"
    description: "The AOV of the SKU compared with the average AOV of any SKU per hub in the reporting period"
    group_label: "Report Period"

    type: average
    sql: ${order_value_gross_corrected} / nullif( ${total_avg_order_value_gross_corrected} ,0) - 1;;

    value_format_name: percent_0
  }

  measure: sum_quantity_sold_corrected {

    label:       "# Items Sold [L4W]"
    description: "The number of items, that have been sold"
    group_label: "Report Period"

    type: sum
    sql: ${quantity_sold_corrected} ;;

    value_format_name: decimal_0
  }

  measure: pct_quantity_sold_corrected_vs_total {

    label:       "% Items Sold vs. Total [L4W]"
    description: "The number of items sold compared to the total number of items sold per hub in the reporting period"
    group_label: "Report Period"

    type: average
    sql: ${quantity_sold_corrected} / nullif(${total_quantity_sold_corrected} ,0) ;;

    value_format_name: percent_4
  }

  measure: sum_share_of_hours_oos {

    label:       "# Hours Out-Of-Stock [L4W]"
    description: "The number of hours, a SKU was out of stock"
    group_label: "Report Period"

    type: sum
    sql: ${share_of_hours_oos} ;;

    value_format_name: decimal_0

  }

  measure: sum_share_of_hours_open {

    label:       "# Hours Hub Open [L4W]"
    description: "The numeber of hours, a hub was open, that offered the SKU"
    group_label: "Report Period"

    type: sum
    sql: ${share_of_hours_open} ;;

    value_format_name: decimal_0

  }

  measure: pct_oos {

    label:       "% out-of-stock [L4W]"
    description: "The out-of-stock rate based on comparing open hours and out-of-stock hours"
    group_label: "Report Period"

    type: number
    sql:  ${sum_share_of_hours_oos} / nullif(${sum_share_of_hours_open} ,0);;

    value_format_name: percent_0
  }

  measure: sum_waste_damaged {

    label:       "# Items Damaged [L4W]"
    description: "The number of items, that are being remove from the inventory due to products being damaged"
    group_label: "Report Period"

    type: sum
    sql: ${waste_damaged} ;;

    value_format_name: decimal_0
  }


  measure: sum_waste_expired {

    label:      "# Items Expired [L4W]"
    description: "The number of items, that are being remove from the inventory due to products being expired"
    group_label: "Report Period"

    type: sum
    sql: ${waste_expired} ;;

    value_format_name: decimal_0

  }

  measure: sum_number_of_customers_corrected {

    label:      "# Customers [L4W]"
    description: "The number of customers, have ordered in the current period"
    group_label: "Report Period"

    type: sum
    sql:  ${number_of_customers_corrected};;

    value_format_name: decimal_0

  }

  measure: pct_buying_frequency {

    label:       "Buying Frequency [L4W]"
    description: "The number of orders divided by the number of custoemrs in the current period"
    group_label: "Report Period"

    type: number
    sql: safe_divide(${sum_number_of_orders_corrected}, ${sum_number_of_customers_corrected}) ;;

    value_format_name: decimal_2

  }


  measure: pct_waste {

    label:      "% Waste [L4W]"
    description: "The percentage of how many items were either expireed or damaged compared with all orders corrected by out-of-stock"
    group_label: "Report Period"

    type: number
    sql: (${sum_waste_damaged} + ${sum_waste_expired}) / nullif( ${sum_quantity_sold_corrected} ,0) ;;

    value_format_name: percent_2

  }

  measure: pct_waste_damaged_vs_total  {

    label:       "% Items Damaged vs. Total [L4W]"
    description: "The number of items of an sku that are removed from inventory due to being damaged compared to all damaged items in a hub in the reporting period"
    group_label: "Report Period"

    type: average
    sql: ${waste_damaged} / nullif(${total_waste_damaged} ,0) ;;

    value_format_name: percent_4
  }

  measure: pct_waste_expired_vs_total  {

    label:       "% Items Expired vs. Total [L4W]"
    description: "The number of items of an sku that are removed from inventory due to being expired compared to all damaged items in a hub in the reporting period"
    group_label: "Report Period"

    type: average
    sql: ${waste_expired} / nullif(${total_waste_expired} ,0) ;;

    value_format_name: percent_4
  }




  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures PoP Period           ~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_pop_item_revenue_gross_corrected {

    label:       "€ Item Revenue (Gross) [PoP]"
    description: "The GMV generated by a product"
    group_label: "PoP Period"

    type: sum
    sql: ${pop_item_revenue_gross_corrected} ;;

    value_format_name: eur

  }

  measure: sum_pop_item_revenue_net_corrected {

    label:       "€ Item Revenue (Net) [PoP]"
    description: "The GMV generated by a product"
    group_label: "PoP Period"

    type: sum
    sql: ${pop_item_revenue_net_corrected} ;;

    value_format_name: eur

  }

  measure: pct_sum_pop_item_revenue_gross_corrected_vs_total {

    label:       "% Item Revenue vs. Total [PoP]"
    description: "The item revenue of the SKU compared with the total revenu per hub in the pop period"
    group_label: "PoP Period"

    type: average
    sql: ${pop_item_revenue_gross_corrected} / nullif(${pop_total_item_revenue_gross_corrected} ,0) ;;

    value_format_name: percent_4
  }

  measure: sum_pop_number_of_orders_corrected {

    label:       "# Orders [PoP]"
    description: "The number of orders, given the SKU is included"
    group_label: "PoP Period"

    type: sum
    sql: ${pop_number_of_orders_corrected} ;;

    value_format_name: decimal_0
  }

  measure: pct_pop_number_of_orders_corrected_vs_total {

    label:       "% Orders vs. Total [PoP]"
    description: "The number of orders with the SKU compared with the total number of orders per hub in the pop period"
    group_label: "PoP Period"

    type: average
    sql: ${pop_number_of_orders_corrected} / nullif( ${pop_total_number_of_orders_corrected} ,0) ;;

    value_format_name: percent_4
  }


  measure: sum_pop_order_value_gross_corrected {

    label:       "€ AVG Order Value [PoP]"
    description: "The average order value, given that the specific SKU is part of the basket"
    group_label: "PoP Period"

    type: average
    sql: ${pop_order_value_gross_corrected} ;;

    value_format_name: eur

  }

  measure:pct_pop_order_value_gross_corrected_vs_total  {

    label:       "% AVG Order Value vs Total [PoP]"
    description: "The AOV of the SKU compared with the average AOV of any SKU per hub in the pop period"
    group_label: "PoP Period"

    type: average
    sql: ${pop_order_value_gross_corrected} / nullif( ${pop_total_avg_order_value_gross_corrected} ,0) - 1;;

    value_format_name: percent_0
  }

  measure: sum_pop_quantity_sold_corrected {

    label:       "# Items Sold [PoP]"
    description: "The number of items, that have been sold"
    group_label: "PoP Period"

    type: sum
    sql: ${pop_quantity_sold_corrected} ;;

    value_format_name: decimal_0

  }

  measure: pct_pop_quantity_sold_corrected_vs_total {

    label:       "% Items Sold vs. Total [PoP]"
    description: "The number of items sold compared to the total number of items sold per hub in the pop period"
    group_label: "PoP Period"

    type: average
    sql: ${pop_quantity_sold_corrected} / nullif(${pop_total_quantity_sold_corrected} ,0) ;;

    value_format_name: percent_4
  }

  measure: sum_pop_share_of_hours_oos {

    label:       "# Hours Out-Of-Stock [PoP]"
    description: "The number of hours, a SKU was out of stock"
    group_label: "PoP Period"

    type: sum
    sql: ${pop_share_of_hours_oos} ;;

    value_format_name: decimal_0

  }

  measure: sum_pop_share_of_hours_open {

    label:       "# Hours Hub Open [PoP]"
    description: "The numeber of hours, a hub was open, that offered the SKU"
    group_label: "PoP Period"

    type: sum
    sql: ${pop_share_of_hours_open} ;;

    value_format_name: decimal_0

  }

  measure: sum_pop_number_of_customers_corrected {

    label:      "# Customers [PoP]"
    description: "The number of customers, have ordered in the previous period"
    group_label: "PoP Period"

    type: sum
    sql:  ${pop_number_of_customers_corrected};;

    value_format_name: decimal_0

  }

  measure: pct_pop_buying_frequency {

    label:       "Buying Frequency [PoP]"
    description: "The number of orders divided by the number of custoemrs in the previous period"
    group_label: "PoP Period"

    type: number
    sql: safe_divide(${sum_pop_number_of_orders_corrected}, ${sum_pop_number_of_customers_corrected}) ;;

    value_format_name: decimal_2

  }

  measure: pct_pop_oos {

    label:       "% out-of-stock [PoP]"
    description: "The out-of-stock rate based on comparing open hours and out-of-stock hours"
    group_label: "PoP Period"

    type: number
    sql:  ${sum_pop_share_of_hours_oos} / nullif(${sum_pop_share_of_hours_open} ,0);;

    value_format_name: percent_0
  }

  measure: sum_pop_waste_damaged {

    label:       "# Items Damaged [PoP]"
    description: "The number of items, that are being remove from the inventory due to products being damaged"
    group_label: "PoP Period"

    type: sum
    sql: ${pop_waste_damaged} ;;

    value_format_name: decimal_0

  }

  measure: sum_pop_waste_expired {

    label:       "# Items Expired [PoP]"
    description: "The number of items, that are being remove from the inventory due to products being expired"
    group_label: "PoP Period"

    type: sum
    sql: ${pop_waste_expired} ;;

    value_format_name: decimal_0

  }

  measure: pct_pop_waste {

    label:      "% Waste [PoP]"
    description: "The percentage of how many items were either expireed or damaged compared with all orders corrected by out-of-stock"
    group_label: "PoP Period"

    type: number
    sql: (${sum_pop_waste_damaged} + ${sum_pop_waste_expired}) / nullif( ${sum_pop_number_of_orders_corrected} ,0) ;;

    value_format_name: percent_2

  }

  measure: pct_pop_waste_damaged_vs_total  {

    label:       "% Items Damaged vs. Total [PoP]"
    description: "The number of items of an sku that are removed from inventory due to being damaged compared to all damaged items in a hub in the pop period"
    group_label: "PoP Period"

    type: average
    sql: ${pop_waste_damaged} / nullif(${pop_total_waste_damaged} ,0) ;;

    value_format_name: percent_4
  }

  measure: pct_pop_waste_expired_vs_total  {

    label:       "% Items Expired vs. Total [PoP]"
    description: "The number of items of an sku that are removed from inventory due to being expired compared to all damaged items in a hub in the pop period"
    group_label: "PoP Period"

    type: average
    sql: ${pop_waste_expired} / nullif(${pop_total_waste_expired} ,0) ;;

    value_format_name: percent_4
  }





  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures Marigns              ~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: avg_selling_price_gross {

    label:       "AVG Selling Price (Gross) - Reporting Period"
    description: "The average selling price in the reporting period"
    group_label: "Margin Metrics"

    type: average
    sql: ${unit_price_gross} ;;

    value_format_name: eur
  }

  measure: avg_selling_price_net {

    label:       "AVG Selling Price (Net) - Reporting Period"
    description: "The average selling price in the reporting period"
    group_label: "Margin Metrics"

    type: average
    sql: ${unit_price_net} ;;

    value_format_name: eur
  }

  measure: avg_pop_selling_price {

    label:       "AVG Selling Price (Gross) - PoP Period"
    description: "The average selling price in the pop period"
    group_label: "Margin Metrics"

    type: average
    sql: ${pop_unit_price_gross} ;;

    value_format_name: eur
  }

  measure: avg_buying_price {

    required_access_grants: [can_access_pricing_margins]

    label:       "AVG Buying Price"
    description: "The average buying prive from ERP"
    group_label: "Margin Metrics"

    type: average
    sql: ${buying_price} ;;

    value_format_name: eur
  }

  measure: sum_total_margin {

    required_access_grants: [can_access_pricing_margins]

    label:       "€ Margin - Reporting Period"
    description: "The total absolute margin in € in the reporting period"
    group_label: "Margin Metrics"

    type: sum
    # sql: ${avg_selling_price_net} - ${avg_buying_price} ;;
    sql: ${total_margin} ;;

    value_format_name: eur
  }

  measure: sum_pop_total_margin {

    required_access_grants: [can_access_pricing_margins]

    label:       "€ Margin - PoP Period"
    description: "The total absolute margin in € in the pop period"
    group_label: "Margin Metrics"

    type: number
    # sql: ${avg_pop_selling_price} - ${avg_buying_price} ;;
    sql: ${pop_total_margin} ;;

    value_format_name: eur
  }

  measure: sum_item_buying_price {

    required_access_grants: [can_access_pricing_margins]

    type: sum
    sql: ${quantity_sold_corrected} * ${buying_price} ;;
    hidden: yes

  }

  measure: pct_margin {

    required_access_grants: [can_access_pricing_margins]

    label:       "% Margin - Reporting Period"
    description: "The absolute margin of the reporting period compared to the selling price per unit"
    group_label: "Margin Metrics"

    type: number
    sql: safe_divide( ${sum_item_revenue_net_corrected} - ${sum_item_buying_price}, ${sum_item_revenue_net_corrected}) ;;

    value_format_name: percent_0

  }

  # measure: pct_pop_margin {

  #   required_access_grants: [can_access_pricing_margins]

  #   label:       "% Margin - PoP Period"
  #   description: "The absolute margin of the pop period compared to the selling price per unit"
  #   group_label: "Margin Metrics"

  #   type: number
  #   sql: ${abs_pop_margin} / nullif( ${avg_pop_selling_price} ,0) ;;

  #   value_format_name: percent_0

  # }




  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Main Decision Metrics         ~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_total_assortment_size {

    label: "AVG Assortment (Unique SKUs)"
    description: "The average assortment of an hub - thus the number of unique SKUs, that is assigned to a hub"
    group_label: "Proposed Decision Metrics"

    type: average
    sql: ${total_assortment_size} ;;

    value_format_name: decimal_0
  }

  measure: main_pct_margin {

    required_access_grants: [can_access_pricing_margins]

    label:       "% Margin - Reporting Period"
    description: "The absolute margin of the reporting period compared to the selling price per unit"
    group_label: "Proposed Decision Metrics"

    type: number
    sql: ${pct_margin} ;;

    value_format_name: percent_0
  }

  measure: direct_sku_performance {

    label:       "Direct SKU Contribution"
    description: "The direct comtribution of an SKU towards the company success measured as:
                    take the higher value of
                     - % Items Sold vs. Total
                     - % Item Revenue vs. Total  "
    group_label: "Proposed Decision Metrics"

    type: number
    sql: (if(
            ${pct_item_revenue_gross_corrected_vs_total} > ${pct_quantity_sold_corrected_vs_total},
            ${pct_item_revenue_gross_corrected_vs_total},
            ${pct_quantity_sold_corrected_vs_total}
            )) * 10000 ;;

    value_format_name: percent_2

  }

  measure: indirect_sku_performance {

    label:       "Indirect SKU Contribution"
    description: "The indirect contribution of an SKU defined by its cross-selling potential. The KPI is defined as

                  (# Item-Connections) / (# Unique SKUs) * 10.000 for better interpretability"
    group_label: "Proposed Decision Metrics"

    type: number
    sql: (${avg_number_of_connections} / nullif(${avg_total_assortment_size} ,0) ) ;;

    value_format_name: percent_2
  }








}
