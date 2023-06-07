include: "/**/orders_cl.explore"
include: "/**/orders.view"
include: "/**/orders_using_hubs.view"
include: "/**/shyftplan_riders_pickers_hours_clean.view"
include: "/**/hubs_ct.view"
include: "/**/nps_after_order_cl.view"
include: "/**/hub_monthly_orders.view"
include: "/**/global_filters_and_parameters.view"
include: "/commercial/views/bigquery_curated/hub_demographics.view"
include: "/**/shipping_methods_ct.view"
include: "/**/hub_attributes.view"
include: "/**/cr_dynamic_orders_cl_metrics.view"
include: "/product_consumer/views/bigquery_curated/user_attributes_order_classification.view"
include: "/**/discounts.view"
include: "/*/**/vat_order.view.lkml"

explore: orders_cl {
  from: orders_using_hubs
  view_name: orders_cl  # needs to be set in order that the base_explore can be extended and referenced properly
  hidden: no

  group_label: "01) Performance"
  label: "Orders"
  description: "General Business Performance - Orders, Revenue, etc."

  view_label: "Orders"

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${orders_cl.created_date} {% endcondition %} ;;

  always_filter: {
    filters:  [
      orders_cl.is_successful_order: "yes",
      global_filters_and_parameters.datasource_filter: "last 7 days",
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }
  access_filter: {
    field: orders_cl.country_iso
    user_attribute: country_iso

    }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: hubs {
    from: hubs_ct
    view_label: "Hubs"
    sql_on: lower(${orders_cl.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  # Hub Attributes
  join: hub_attributes {
    from: hub_attributes
    view_label: "Hubs"
    sql_on:
    lower(${orders_cl.hub_code}) = lower(${hub_attributes.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

  join: hub_demographics {
    view_label: "Hubs"
    sql_on: ${hubs.hub_code} = ${hub_demographics.hub_code} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: "Shifts"
    sql_on: ${orders_cl.created_date} = ${shyftplan_riders_pickers_hours.shift_date} and
      ${hubs.hub_code}          = lower(${shyftplan_riders_pickers_hours.hub_name});;
    relationship: many_to_many
    type: left_outer
  }

    # To get cleaned UTRs (based on Orders delivered just by riders)

  join: employee_level_kpis {
    from: employee_level_kpis
    view_label: ""
    sql_on: ${orders_cl.created_date} = ${employee_level_kpis.shift_date} and
      ${hubs.hub_code}          = lower(${employee_level_kpis.hub_code});;
    relationship: many_to_many
    type: left_outer
  }

  join: nps_after_order {
    from: nps_after_order_cl
    view_label: "NPS"
      sql_on: ${orders_cl.country_iso}   = ${nps_after_order.country_iso} AND
        ${orders_cl.order_number}  =       ${nps_after_order.order_number} ;;
      relationship: one_to_many
      type: left_outer
    }

  join: orderline_issue_rate_core_kpis {
    from: orderline
    view_label: "Orders"
    sql_on: ${orderline_issue_rate_core_kpis.country_iso} = ${orders_cl.country_iso} AND
        ${orderline_issue_rate_core_kpis.order_uuid}    = ${orders_cl.order_uuid} AND
        {% condition global_filters_and_parameters.datasource_filter %} ${orderline_issue_rate_core_kpis.created_date} {% endcondition %}
      ;;
    relationship: one_to_many
    type: left_outer
    fields: [orderline_issue_rate_core_kpis.orders_core_fields*]
  }

  join: orders_hub_staffing {
    sql:  ;;
    relationship: one_to_one
    view_label: "Orders"
  }

  join: hub_monthly_orders {
    view_label: "Hubs"
    sql_on:
      ${orders_cl.hub_code} = ${hub_monthly_orders.hub_code} and
      date_trunc(${orders_cl.order_date},month) = ${hub_monthly_orders.created_month} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: shipping_methods_ct {
    view_label: "Orders"
    sql_on:
      ${orders_cl.shipping_method_id} = ${shipping_methods_ct.shipping_method_id} and
      ${orders_cl.country_iso} = ${shipping_methods_ct.country_iso} ;;
    relationship: many_to_many
    type: left_outer
    fields: [shipping_methods_ct.orders_df_fields*]
  }

  join: order_classification {
    from: user_attributes_order_classification
    view_label: "Orders"
    sql_on: ${orders_cl.order_uuid} = ${order_classification.order_uuid}
        AND {% condition global_filters_and_parameters.datasource_filter %} ${order_classification.order_timestamp_date} {% endcondition %};;
    relationship: one_to_one
    type: left_outer
    fields: [order_classification.order_classifications*, order_classification.jtbd_orders*]
  }

  join: discounts {
    view_label: "Discounts"
    sql_on:
        -- For T1 the discount id is null and we join only on the discount code.
        ${orders_cl.discount_code} = ${discounts.discount_code}
        and coalesce(${orders_cl.voucher_id},'') = coalesce(${discounts.discount_id},'')
    ;;
    type: left_outer
    relationship: many_to_one
  }

  join: influencer_vouchers_input {
    view_label: "Discounts"
    sql_on: ${orders_cl.country_iso} = ${influencer_vouchers_input.country_iso} AND
      ${orders_cl.discount_code} = ${influencer_vouchers_input.voucher_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: vat_order {
    view_label: "VAT Measures"
    sql_on: ${orders_cl.order_uuid} = ${vat_order.order_uuid} ;;
    relationship: one_to_one
    type: left_outer
    fields: [vat_order.sum_vat_discount_amount_total,vat_order.sum_discount_amount_net]
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Cross-Referenced Metrics
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  join: cr_dynamic_orders_cl_metrics {
    view_label: "Orders"
    relationship: one_to_one
    type: left_outer
    sql:  ;;
  }

}
