view: avg_delivery_fee {
  derived_table: {
    explore_source: orders_cl {
      column: order_uuid {field:orders_cl.order_uuid}
      column: order_date {field:orders_cl.order_date}
      column: shipping_price_gross_amount {field:orders_cl.shipping_price_gross_amount}
      column: shipping_price_net_amount {field:orders_cl.shipping_price_net_amount}
    }
  }

  dimension: order_uuid {
    type: string
    group_label: "* IDs *"
    label: "Order UUID"
    primary_key: yes
    hidden: no
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: order_date {
    group_label: "* Dates and Timestamps *"
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
    hidden: no
  }

  dimension: shipping_price_gross_amount {
    type: number
    label: "Delivery Fee (Gross)"
    hidden: no
    sql: ${TABLE}.amt_delivery_fee_gross ;;
  }

  dimension: shipping_price_net_amount {
    type: number
    label: "Delivery Fee (Net)"
    hidden: no
    sql: ${TABLE}.amt_delivery_fee_net ;;
  }

  measure: avg_delivery_fee_gross {
    group_label: "* Monetary Values *"
    label: "AVG Delivery Fee (Gross)"
    description: "Average value of Delivery Fees (Gross)"
    hidden:  no
    type: average
    sql: coalesce(${shipping_price_gross_amount});;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_delivery_fee_net {
    group_label: "* Monetary Values *"
    label: "AVG Delivery Fee (Net)"
    description: "Average value of Delivery Fees (Net)"
    hidden:  no
    type: average
    sql: ${shipping_price_net_amount};;
    value_format_name: euro_accounting_2_precision
  }






   }
