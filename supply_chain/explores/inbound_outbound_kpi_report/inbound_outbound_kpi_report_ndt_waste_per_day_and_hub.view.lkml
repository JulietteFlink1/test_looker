include: "inbound_outbound_kpi_report.explore.lkml"

view: inbound_outbound_kpi_report_ndt_waste_per_day_and_hub {

  # only users that have access to buying prices can see the content of this view
  required_access_grants: [can_view_buying_information]

  derived_table: {

      # datagroup_trigger: flink_daily_datagroup
      # partition_keys: ["inventory_change_date"]
      # cluster_keys: ["hub_code"]

    explore_source: inbound_outbound_kpi_report {

      column: inventory_change_date                 { field: inventory_changes_daily.inventory_change_date }
      column: hub_code                              { field: inventory_changes_daily.hub_code }
      column: outbound_waste_per_buying_price_gross { field: inventory_changes_daily.sum_outbound_waste_per_buying_price_gross }
      column: outbound_waste_per_buying_price_net   { field: inventory_changes_daily.sum_outbound_waste_per_buying_price_net }

      filters: [
        global_filters_and_parameters.datasource_filter: "after 2022-01-01"
      ]

    }
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Dimensions - HIDDEN
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: concat(${TABLE}.inventory_change_date, ${TABLE}.hub_code) ;;
  }
  dimension: inventory_change_date {
    type: date
    hidden: yes
  }
  dimension: hub_code {
    type: string
    hidden: yes
  }
  dimension: outbound_waste_per_buying_price_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.outbound_waste_per_buying_price_gross ;;
  }
  dimension: outbound_waste_per_buying_price_net {
    type: number
    hidden: yes
    sql: ${TABLE}.outbound_waste_per_buying_price_net ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  measure: sum_waste_per_buying_price_net {

    label:       "€ Total Waste (Buying Price Net)"
    description: "The sum of wasted items valued by the net buying price."
    group_label: "Waste Metrics"

    type: sum
    sql:  - ${outbound_waste_per_buying_price_net};;
    value_format_name: eur
    hidden: yes
  }

  measure: sum_waste_per_buying_price_gross {

    label:       "€ Total Waste (Buying Price Gross)"
    description: "The sum of wasted items valued by the gross buying price."
    group_label: "Waste Metrics"

    type: sum
    sql:  - ${outbound_waste_per_buying_price_gross};;
    value_format_name: eur
    hidden: yes
  }

  measure: avg_waste_per_order_per_buying_price_net {

    label:       "€ AVG Waste per Order (Buying Price Net)"
    description: "The sum of wasted items valued by the net buying price divided by the number of orders."
    group_label: "Waste Metrics"

    type: number
    sql:  safe_divide(${sum_waste_per_buying_price_net}, ${orders_cl.cnt_orders}) ;;
    value_format_name: eur
  }

  measure: avg_waste_per_order_per_buying_price_gross {

    label:       "€ AVG Waste per Order (Buying Price Gross)"
    description: "The sum of wasted items valued by the gross buying price divided by the number of orders."
    group_label: "Waste Metrics"

    type: number
    sql: safe_divide(${sum_waste_per_buying_price_gross}, ${orders_cl.cnt_orders}) ;;
    value_format_name: eur
  }

  measure: avg_aiv_profit_net {

    label:       "AIV Net Profit (dynamic)"
    description: "The AVG Item Value (dynamically pre or post discounts) multiplied by the AVG Margin. All values are net."
    group_label: "* Monetary Values *"

    type: number
    sql:  (${orders_cl.avg_item_value_net_dynamic} * ${erp_buying_prices.pct_total_margin_relative_dynamic})
          ;;
    value_format_name: eur
  }

  measure: avg_aiv_profit_gross {

    label:       "AIV Gross Profit (dynamic)"
    description: "The AVG Item Value (dynamically pre or post discounts) multiplied by the AVG Margin. All values are gross."
    group_label: "* Monetary Values *"

    type: number
    sql:  (${orders_cl.avg_item_value_gross_dynamic} * ${erp_buying_prices.pct_total_margin_relative_dynamic})
          ;;
    value_format_name: eur
  }




  measure: avg_aiv_proft_after_waste_gross {

    label:       "AIV Gross Profit after Waste (dynamic)"
    description: "The AVG Item Value (dynamically pre or post discounts) multiplied by the AVG Margin plus by the total fees (containing the delivery and storage fees) deducted by the value of the waste generated per order. All values are gross."
    group_label: "* Monetary Values *"

    type: number
    sql:    ${avg_aiv_profit_gross}
          + ${orders_cl.avg_total_fees_gross}
          + ${inbound_outbound_kpi_report_ndt_waste_per_day_and_hub.avg_waste_per_order_per_buying_price_gross}
          ;;
    value_format_name: eur
  }

  measure: avg_aiv_proft_after_waste_net {

    label:       "AIV Net Profit after Waste (dynamic)"
    description: "The AVG Item Value (dynamically pre or post discounts) multiplied by the AVG Margin plus by the total fees (containing the delivery and storage fees) deducted by the value of the waste generated per order. All values are net."
    group_label: "* Monetary Values *"

    type: number
    sql:    ${avg_aiv_profit_net}
          + ${orders_cl.avg_total_fees_net}
          + ${inbound_outbound_kpi_report_ndt_waste_per_day_and_hub.avg_waste_per_order_per_buying_price_net}
          ;;
    value_format_name: eur
  }




}
