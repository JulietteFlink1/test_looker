view: avg_delivery_fee {
    derived_table: {
      explore_source: order_lineitems_margins {
        column: created_month { field: orders_cl.created_month }
        column: created_date { field: orders_cl.created_date }
        column: country_iso { field: orders_cl.country_iso }
        column: avg_delivery_fee_gross { field: orders_cl.avg_delivery_fee_gross }
        column: avg_delivery_fee_net { field: orders_cl.avg_delivery_fee_net }
        filters: {
          field: orders_cl.is_successful_order
          value: "Yes"
        }
        filters: {
          field: global_filters_and_parameters.datasource_filter
          value: ""
        }
        filters: {
          field: hubs.hub_name
          value: ""
        }
        filters: {
          field: hubs.country
          value: ""
        }
      }
    }

    dimension: created_month {
      label: "* Orders * Order Month"
      description: "Order Placement Time/Date"
      type: date_month
      hidden: yes
    }

    dimension: created_date {
      label: "* Orders * Order Date"
      description: "Order Placement Time/Date"
      type: date
      hidden: yes
    }

  dimension: country_iso {
    label: "* Hubs * Country Iso"
    description: ""
    hidden: yes
  }

    dimension: avg_delivery_fee_gross {
      label: "* Orders * AVG Delivery Fee (Gross)"
      description: "Average value of Delivery Fees (Gross)"
      value_format_name: euro_accounting_2_precision
      type: number
      hidden: yes
    }

    dimension: avg_delivery_fee_net {
      label: "* Orders * AVG Delivery Fee (Net)"
      description: "Average value of Delivery Fees (Net)"
      value_format_name: euro_accounting_2_precision
      type: number
      hidden: yes
    }

    measure: avg_delivery_fee_gross_measure {
      label: "AVG Delivery Fee (Gross)"
      description: "Average value of Delivery Fees (Gross)"
      hidden:  no
      type: average
      sql: (${avg_delivery_fee_gross});;
      value_format_name: euro_accounting_2_precision
      sql_distinct_key: concat (${created_date},${country_iso} ) ;;
    }

    measure: avg_delivery_fee_net_measure {
      label: "AVG Delivery Fee (Net)"
      description: "Average value of Delivery Fees (Net)"
      hidden:  no
      type: average
      sql: ${avg_delivery_fee_net};;
      value_format_name: euro_accounting_2_precision
      sql_distinct_key: concat (${created_date},${country_iso} ) ;;
    }

  }
