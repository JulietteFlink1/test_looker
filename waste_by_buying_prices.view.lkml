view: waste_by_buying_prices {
    derived_table: {
      explore_source: supply_chain {
        column: report_month { field: products_hub_assignment.report_month }
        column: report_date { field: products_hub_assignment.report_date }
        column: country_iso { field: products_hub_assignment.country_iso }
        column: sum_total_net_income { field: erp_buying_prices.sum_total_net_income }
        column: is_outbound_waste { field: inventory_changes_daily.is_outbound_waste }
        column: count_order_uuid { field: order_lineitems.count_order_uuid }
        bind_all_filters: yes
      }
    }

  dimension: report_month {
    label: "01 Products Hub Assignment Report Month"
    description: ""
    type: date_month
    hidden: yes
  }
  dimension: report_date {
    label: "01 Products Hub Assignment Report Date"
    description: ""
    type: date
    hidden: yes
  }

  dimension: country_iso {
    label: "01 Products Hub Assignment Country Iso"
    description: ""
    hidden: yes
  }

    dimension: sum_total_net_income {
      label: "11 ERP Vendor Prices * € Sum Item Prices Sold (Net)"
      description: "The sum of all Net Unit Price multiplied by the sum of Item Quantity Sold"
      value_format_name: euro_accounting_2_precision
      type: number
      hidden: yes
    }

    dimension: is_outbound_waste {
      label: "04 Inventory Changes Daily Is Outbound (Waste) (Yes / No)"
      description: "Boolean - indicates, if a inventory chqnge is based on waste - determined by the reasons 'product-damaged' ('delivery damaged'), 'product-expired' ('delivery-expired') or 'too-good-to-go'"
      type: yesno
      hidden: yes
    }

    dimension: count_order_uuid {
      label: "07 Order Lineitems Count Order"
      description: ""
      value_format: "0"
      type: number
      hidden: yes
    }

    measure: sum_item_price_sold {
      label: "€ Waste by bying price"
      description: "Amount of waste based on  Sum Item Prices Sold (Net). The filter Is Outbound Waste (Yes) is applied by default."
      hidden:  no
      type: sum
      sql:${sum_total_net_income} * (-1);;
      filters: [is_outbound_waste: "yes"]
      value_format_name: euro_accounting_2_precision
      sql_distinct_key: concat (${report_date},${country_iso} ) ;;

  }

  measure: sum_orders {
    label: "# Count of orders (waste)"
    description: "Count of Orders with waste"
    hidden:  no
    type: sum
    sql:${count_order_uuid};;
    filters: [is_outbound_waste: "yes"]
    value_format: "0"
    sql_distinct_key:concat (${report_date},${country_iso} ) ;;

  }

  measure: waste_per_order {
    label: "€ Waste per order"
    description: "Total amount of waste (€) divided by total number of orders with waste"
    type: number
    sql:${sum_item_price_sold} / ${sum_orders} ;;
    value_format_name: euro_accounting_2_precision
    #sql_distinct_key:concat (${report_date},${country_iso}) ;;

  }

}
