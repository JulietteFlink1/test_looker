# Author: Victor Breda
# Created 2023-02-15
# This cross referenced view allows to create measures that reference multiple views from the orders_cl explore

view: cr_dynamic_orders_cl_metrics {

  measure: dynamic_kpi {
    type: number
    group_label: "> Dynamic KPIs"
    label: "OKR Level 1 KPIs (Dynamic)"
    description: "Make use of this dynamic KPI to switch between multiple measures that are considered to be OKR Level 1 by Ops."
    label_from_parameter: dynamic_kpi_parameter
    sql:
    {% if dynamic_kpi_parameter._parameter_value == 'partial_fulfillment_pre' %}
      ${orderline_issue_rate_core_kpis.pct_pre_order_issue_rate_per_total_orders}
    {% elsif dynamic_kpi_parameter._parameter_value == 'post_issue' %}
      ${orderline_issue_rate_core_kpis.pct_post_order_issue_rate_per_total_orders}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_fulfillment_over_30_min' %}
      ${orders_cl.pct_fulfillment_over_30_min}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_delivery_in_time_time_estimate' %}
      ${orders_cl.pct_delivery_in_time_time_estimate}
    {% elsif dynamic_kpi_parameter._parameter_value == 'sum_avg_waiting_time' %}
      ${orders_cl.sum_avg_waiting_time}
    {% elsif dynamic_kpi_parameter._parameter_value == 'avg_rider_handling_time' %}
      ${orders_cl.avg_rider_handling_time}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_external_hours_rider_picker' %}
      ${shyftplan_riders_pickers_hours.pct_external_hours_rider_picker}
    {% endif %};;

    html:
    {% if dynamic_kpi_parameter._parameter_value ==  'partial_fulfillment_pre' %}
      {{orderline_issue_rate_core_kpis.pct_pre_order_issue_rate_per_total_orders._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'post_issue' %}
      {{orderline_issue_rate_core_kpis.pct_post_order_issue_rate_per_total_orders._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_fulfillment_over_30_min' %}
      {{orders_cl.pct_fulfillment_over_30_min._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_delivery_in_time_time_estimate' %}
      {{orders_cl.pct_delivery_in_time_time_estimate._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'sum_avg_waiting_time' %}
      {{orders_cl.sum_avg_waiting_time._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'avg_rider_handling_time' %}
      {{orders_cl.avg_rider_handling_time._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'pct_external_hours_rider_picker' %}
      {{shyftplan_riders_pickers_hours.pct_external_hours_rider_picker._rendered_value }}
    {% endif %}
      ;;
  }

  ######### Parameters

  parameter: dynamic_kpi_parameter {
    group_label: "> Dynamic KPIs"
    label: "OKR Level 1 KPIs (Dynamic)"
    type: unquoted
    allowed_value: {label: "% Orders Partial Fulfillment (Pre Delivery Issues)" value: "partial_fulfillment_pre" }
    allowed_value: {label: "% Orders Issue (Post Delivery Issue)" value: "post_issue" }
    allowed_value: {label: "% Orders Fulfilled >30min" value: "pct_fulfillment_over_30_min" }
    allowed_value: {label: "% Orders Delivered in Time (targeted estimate)" value: "pct_delivery_in_time_time_estimate" }
    allowed_value: {label: "AVG Waiting For Picker Time + Waiting for Rider Time" value: "sum_avg_waiting_time" }
    allowed_value: {label: "AVG Rider Handling Time" value: "avg_rider_handling_time" }
    allowed_value: {label: "% External Hours Rider + Picker" value: "pct_external_hours_rider_picker" }

    default_value: "partial_fulfillment_pre"
  }

}
