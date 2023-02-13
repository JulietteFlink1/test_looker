# Author: Victor Breda
# 2023-01-13
# This ndt creates a dynamic measure that allows one to switch between
# different KPIs that are from multiple views

include: "/**/orders_cl.explore.lkml"

view: ndt_dynamic_ops_kpis {

  derived_table: {

    explore_source: orders_cl {

      column: order_uuid                                  { field: orders_cl.order_uuid }
      column: pct_pre_order_issue_rate_per_total_orders   { field: orderline_issue_rate_core_kpis.pct_pre_order_issue_rate_per_total_orders }
      column: pct_post_order_issue_rate_per_total_orders  { field: orderline_issue_rate_core_kpis.pct_post_order_issue_rate_per_total_orders }
      column: pct_delayed_over_30_min_internal_estimate   { field: orders_cl.pct_delayed_over_30_min_internal_estimate }

    }
  }

  dimension: order_uuid {
    hidden: yes
    type:  string
  }

  ######## Dynamic Measures

  measure: hub_ops_kpis {
    type: number
    group_label: "> Hub Priority KPIs"
    label: "Hub KPI (Dynamic)"
    label_from_parameter: hub_ops_kpis_parameter
    sql:
    {% if hub_ops_kpis_parameter._parameter_value == 'partial_fulfillment_pre' %}
      ${orderline_issue_rate_core_kpis.pct_pre_order_issue_rate_per_total_orders}
    {% elsif hub_ops_kpis_parameter._parameter_value == 'post_issue' %}
      ${orderline_issue_rate_core_kpis.pct_post_order_issue_rate_per_total_orders}
    {% elsif hub_ops_kpis_parameter._parameter_value == 'delay_30min' %}
      ${orders_cl.pct_delayed_over_30_min_internal_estimate}
    {% endif %};;

    html:
          {% if hub_ops_kpis_parameter._parameter_value ==  'partial_fulfillment_pre' %}
              {{orderline_issue_rate_core_kpis.pct_pre_order_issue_rate_per_total_orders._rendered_value }}
          {% elsif hub_ops_kpis_parameter._parameter_value == 'post_issue' %}
              {{orderline_issue_rate_core_kpis.pct_post_order_issue_rate_per_total_orders._rendered_value }}
          {% elsif hub_ops_kpis_parameter._parameter_value == 'delay_30min' %}
              {{orders_cl.pct_delayed_over_30_min_internal_estimate._rendered_value }}
          {% endif %}
          ;;
  }

  ######### Parameters

  parameter: hub_ops_kpis_parameter {
    group_label: "> Hub Priority KPIs"
    label: "Hub KPI"
    type: unquoted
    allowed_value: {label: "% Orders Partial Fulfillment (Pre Delivery Issues)" value: "partial_fulfillment_pre" }
    allowed_value: {label: "% Orders Issue (Post Delivery Issue)" value: "post_issue" }
    allowed_value: {label: "% Orders Delayed >30min (Internal Estimate)" value: "delay_30min" }

    default_value: "partial_fulfillment_pre"
  }
}
