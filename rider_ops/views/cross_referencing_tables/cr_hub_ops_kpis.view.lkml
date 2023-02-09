# Author: Victor Breda
# Created date: 2023-02-09
# Description: This view creates a parameter that allows to switch between multiple hub ops KPIs

view: cr_hub_ops_kpis {


  # ######### Parameters

  # parameter: hub_ops_kpis_parameter {
  #   group_label: "> Hub Priority KPIs"
  #   label: "Hub KPI"
  #   type: unquoted
  #   allowed_value: {label: "Ops Associate UTR" value: "ops_associate_utr" }
  #   allowed_value: {label: "Hub Staff UTR" value: "hub_staff_utr" }
  #   allowed_value: {label: "Rider UTR" value: "rider_utr" }
  #   allowed_value: {label: "% Rider Worked Time Spent Idle" value: "rider_idle" }
  #   allowed_value: {label: "% Orders Delayed >30min (Internal Estimate)" value: "orders_delayed_30min" }
  #   allowed_value: {label: "% Orders Issue (Post Delivery Issues)" value: "share_post_issues" }
  #   allowed_value: {label: "% Orders Partial Fulfillment (Pre Delivery Issues)" value: "share_pre_issues" }
  #   allowed_value: {label: "% No Show Rider Hours" value: "no_show_rider" }
  #   allowed_value: {label: "% No Show Ops Associate Hours" value: "no_show_ops_associate" }

  #   default_value: "rider_utr"
  # }

  # # missing
  # # hub staff idle time, UPHx3
  # # Fill rate
  # # % Workforce no show (currently in orders on daily gran -> need to add to staffing -> rider + OA)


  # ######## Dynamic Measures

  # measure: hub_ops_kpis {
  #   group_label: "> Hub Priority KPIs"
  #   label: "Hub KPI (Dynamic)"
  #   label_from_parameter: hub_ops_kpis_parameter
  #   sql:
  #   {% if hub_ops_kpis_parameter._parameter_value == 'ops_associate_utr' %}
  #     ${ops.utr_ops_associate}
  #   {% elsif hub_ops_kpis_parameter._parameter_value == 'hub_staff_utr' %}
  #     ${ops.utr_hub_staff}
  #   {% elsif hub_ops_kpis_parameter._parameter_value == 'rider_utr' %}
  #     ${ops.utr_rider}
  #   {% elsif hub_ops_kpis_parameter._parameter_value == 'rider_idle' %}
  #     ${ops.pct_rider_idle_time}
  #   {% elsif hub_ops_kpis_parameter._parameter_value == 'orders_delayed_30min' %}
  #     ${orders_with_ops_metrics.pct_delayed_over_30_min_internal_estimate}
  #   {% elsif hub_ops_kpis_parameter._parameter_value == 'share_post_issues' %}
  #     ${orders_with_ops_metrics.pct_post_order_issue_rate_per_total_orders}
  #   {% elsif hub_ops_kpis_parameter._parameter_value == 'share_pre_issues' %}
  #     ${orders_with_ops_metrics.pct_pre_order_issue_rate_per_total_orders}
  #   {% elsif hub_ops_kpis_parameter._parameter_value == 'no_show_rider' %}
  #     ${ops.pct_no_show_hours_rider}
  #   {% elsif hub_ops_kpis_parameter._parameter_value == 'no_show_ops_associate' %}
  #     ${ops.pct_no_show_hours_ops_associate}
  #   {% endif %};;
  # }





  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: cr_hub_ops_kpis {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
