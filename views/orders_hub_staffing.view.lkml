view: orders_hub_staffing {

  measure: pct_orders_delivered_by_riders {
    group_label: "* Operations / Logistics *"
    label: "% Orders Delivered by Riders"
    description: "Share of orders delivered by only riders"
    type: number
    sql: ${employee_level_kpis.number_of_delivered_orders_by_riders}/nullif(${orders_cl.cnt_successful_orders},0) ;;
    value_format_name: percent_1
  }

  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    type: unquoted
    allowed_value: { value: "orders" label: "# Orders"}
    allowed_value: { value: "unique_customers" label: "# Unique Customers" }
    allowed_value: { value: "orders_existing_customers" label: "# Orders Existing Customers" }
    allowed_value: { value: "orders_new_customers" label: "# Orders New Customers"}
    allowed_value: { value: "share_of_orders_delivered_in_time" label: "% Orders Delivered In Time"}
    allowed_value: { value: "share_of_orders_delayed_5min" label: "% Orders Delayed >5min"}
    allowed_value: { value: "share_of_orders_delayed_10min" label: "% Orders Delayed >10min"}
    allowed_value: { value: "share_of_orders_delayed_15min" label: "% Orders Delayed >15min"}
    allowed_value: { value: "share_of_orders_fulfilled_over_30min" label: "% Orders Fulfilled >30min"}
    allowed_value: { value: "gmv_gross" label: "GMV (Gross)"}
    allowed_value: { value: "gmv_net" label: "GMV (Net)"}
    allowed_value: { value: "discount_amount" label: "Discount Amount"}
    allowed_value: { value: "AVG_fulfillment_time" label: "AVG Fulfillment Time"}
    allowed_value: { value: "AVG_order_value_gross" label: "AVG Order Value (Gross)"}
    allowed_value: { value: "AVG_order_value_net" label: "AVG Order Value (Net)"}
    allowed_value: { value: "avg_item_value_gross" label: "AVG Item Value (Gross)"}
    allowed_value: { value: "avg_item_value_net" label: "AVG Item Value (Net)"}
    allowed_value: { value: "rider_utr" label: "Rider UTR"}
    allowed_value: { value: "picker_utr" label: "Picker UTR"}
    allowed_value: { value: "picker_hours" label: "# Picker Hours"}
    allowed_value: { value: "rider_hours" label: "# Rider Hours"}
    allowed_value: { value: "pickers" label: "# Pickers"}
    allowed_value: { value: "riders" label: "# Riders"}
    default_value: "orders"
  }


  measure: KPI {
    group_label: "* Dynamic KPI Fields *"
    label: "KPI - Dynamic"
    label_from_parameter: KPI_parameter
    value_format: "#,##0.00"
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'orders' %}
      ${orders_cl.cnt_orders}
    {% elsif KPI_parameter._parameter_value == 'unique_customers' %}
      ${orders_cl.cnt_unique_customers}
    {% elsif KPI_parameter._parameter_value == 'orders_existing_customers' %}
      ${orders_cl.cnt_unique_orders_existing_customers}
    {% elsif KPI_parameter._parameter_value == 'orders_new_customers' %}
      ${orders_cl.cnt_unique_orders_new_customers}
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delivered_in_time' %}
      ${orders_cl.pct_delivery_in_time}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_5min' %}
      ${orders_cl.pct_delivery_late_over_5_min}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_10min' %}
      ${orders_cl.pct_delivery_late_over_10_min}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_15min' %}
      ${orders_cl.pct_delivery_late_over_15_min}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_fulfilled_over_30min' %}
      ${orders_cl.pct_fulfillment_over_30_min}*100
    {% elsif KPI_parameter._parameter_value == 'gmv_gross' %}
      ${orders_cl.sum_gmv_gross}
    {% elsif KPI_parameter._parameter_value == 'gmv_net' %}
      ${orders_cl.sum_gmv_net}
    {% elsif KPI_parameter._parameter_value == 'discount_amount' %}
      ${orders_cl.sum_discount_amt}
    {% elsif KPI_parameter._parameter_value == 'AVG_fulfillment_time' %}
      ${orders_cl.avg_fulfillment_time}
    {% elsif KPI_parameter._parameter_value == 'AVG_order_value_gross' %}
      ${orders_cl.avg_order_value_gross}
    {% elsif KPI_parameter._parameter_value == 'AVG_order_value_net' %}
      ${orders_cl.avg_order_value_net}
    {% elsif KPI_parameter._parameter_value == 'avg_item_value_gross' %}
      ${orders_cl.avg_item_value_gross}
    {% elsif KPI_parameter._parameter_value == 'avg_item_value_net' %}
      ${orders_cl.avg_item_value_net}
    {% elsif KPI_parameter._parameter_value == 'rider_utr' %}
      ${shyftplan_riders_pickers_hours.rider_utr}
    {% elsif KPI_parameter._parameter_value == 'picker_utr' %}
      ${shyftplan_riders_pickers_hours.picker_utr}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${shyftplan_riders_pickers_hours.picker_hours}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${shyftplan_riders_pickers_hours.rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${shyftplan_riders_pickers_hours.pickers}
    {% elsif KPI_parameter._parameter_value == 'riders' %}
      ${shyftplan_riders_pickers_hours.riders}
    {% endif %};;

    html:
          {% if KPI_parameter._parameter_value == 'share_of_orders_delivered_in_time' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_5min' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_10min' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_15min' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'share_of_orders_fulfilled_over_30min' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'share_of_total_orders' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'gmv_gross' %}
            €{{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'gmv_net' %}
            €{{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'discount_amount' %}
            €{{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'AVG_fulfillment_time' %}
            {{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'AVG_order_value_gross' %}
            €{{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'AVG_order_value_net' %}
            €{{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'avg_item_value_gross' %}
            €{{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'avg_item_value_net' %}
            €{{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'rider_utr' %}
            {{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'picker_utr' %}
            {{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
            {{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
            {{ value | round }}
          {% else %}
            {{ value }}
          {% endif %};;

  }

  measure: sum_rider_hours {
    label: "Sum Worked Rider Hours"
    group_label: "* Operations / Logistics *"
    description: "Sum of completed Rider shift Hours"
    type: number
    sql: NULLIF(${shyftplan_riders_pickers_hours.rider_hours},0);;
  }
}
