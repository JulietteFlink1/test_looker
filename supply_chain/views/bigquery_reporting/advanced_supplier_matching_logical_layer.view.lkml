include: "/supply_chain/views/bigquery_reporting/advanced_supplier_matching.view"

explore: advanced_supplier_matching {
  hidden: yes
  view_label: "TMP - Do NOT use"
}

view: +advanced_supplier_matching {

  dimension: is_purchase_order_row_exists {
    type: yesno
    sql: ${parent_sku_purchase_order} is not null ;;
    hidden: yes
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    PO >> DESADV
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # ----------------     On Time KPIs    ----------------

  measure: cnt_ordered_items_puchase_order {
    label: "# Ordered Items"
    description: "The number of SKUs, that have been ordered"
    group_label: "PO >> DESADV"

    type: count_distinct
    # unique SKUS per PO or DESADV:
    sql: concat(${parent_sku_purchase_order}, ${table_uuid}) ;;
    value_format_name: decimal_0
  }

  measure: cnt_ordered_items_delivered_on_time {
    label: "# Ordered Items Delivered On Time"
    description: "The number of SKUs, that have been ordered and have been delivered at the promised delivery date"
    group_label: "PO >> DESADV"

    type: count_distinct
    # unique SKUS per PO or DESADV:
    sql: concat(${parent_sku_purchase_order}, ${table_uuid}) ;;
    filters: [is_po_delivered_on_promised_delivery_date: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_desadv_on_time_delivery {

    label: "% Delivery On Time (PO > DESADV)"
    description: "Share of on time delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_on_time}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  #   Too Early
  measure: cnt_ordered_items_delivered_too_early {
    label: "# Ordered Items Delivered Too Early"
    group_label: "PO >> DESADV"

    type: count_distinct
    # unique SKUS per PO or DESADV:
    sql: concat(${parent_sku_purchase_order}, ${table_uuid}) ;;
    filters: [is_po_delivered_too_early: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_desadv_delivery_too_early {

    label: "% Delivery Too Early (PO > DESADV)"
    description: "Share of too early delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_too_early}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_days_po_desadv_delivery_too_early {
    label: "AVG Days PO Delivered Too Early"
    description: "Average number of days order lines have been delivered early (PO > DESADV) per early delivered ordered lines"
    group_label: "PO >> DESADV"

    type: average
    sql: ${number_of_days_delivered_too_early} ;;
    value_format_name: decimal_1
  }

  #    Too Late
  measure: cnt_ordered_items_delivered_too_late {
    label: "# Ordered Items Delivered Too Late"
    group_label: "PO >> DESADV"

    type: count_distinct
    # unique SKUS per PO or DESADV:
    sql: concat(${parent_sku_purchase_order}, ${table_uuid}) ;;
    filters: [is_po_delivered_too_late: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_desadv_delivery_too_late {
    label: "% Delivery Too Late (PO > DESADV)"
    description: "Share of too late delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_too_late}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_days_po_desadv_delivery_too_late {
    label: "AVG Days PO Delivered Too Late"
    description: "Average number of days order lines have been delivered late (PO > DESADV) per late delivered ordered lines"
    group_label: "PO >> DESADV"

    type: average
    sql: ${number_of_days_delivered_too_late} ;;
    value_format_name: decimal_1
  }


  # ----------------     In Full KPIs    ----------------
  # In full
  measure: cnt_ordered_items_in_full {
    label: "# In Full delivery (PO > DESADV)"
    group_label: "PO >> DESADV"

    type: count_distinct
    sql: concat(${parent_sku_purchase_order}, ${table_uuid}) ;;
    filters: [is_po_desadv_quantity_in_full: "yes"]
    value_format_name: decimal_0

  }

  measure: pct_ordered_items_in_full {
    label: "% In Full delivery (PO > DESADV)"
    description: "Share of in full delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV"

    type: number
    sql: safe_divide(${cnt_ordered_items_in_full}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: cnt_ordered_items_in_full_limited {
    label: "# In Full delivery lim. (PO > DESADV)"
    group_label: "PO >> DESADV"

    type: count_distinct
    sql: concat(${parent_sku_purchase_order}, ${table_uuid}) ;;
    filters: [is_po_desadv_quantity_in_full_limited: "yes"]
    value_format_name: decimal_0

  }

  measure: pct_ordered_items_in_full_limited {
    label: "% In Full delivery lim. (PO > DESADV)"
    description: "Share of in full delivered order lines (PO > DESADV) compared to all order lines, where an overdelivery counts as an in full delivery"
    group_label: "PO >> DESADV"

    type: number
    sql: safe_divide(${cnt_ordered_items_in_full_limited}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  # Fill Rate
  measure: sum_ordered_items_quantity_po {
    label: "# Total Quantity (PO)"
    group_label: "PO >> DESADV"

    type: sum
    sql: ${total_quantity_purchase_order} ;;
    value_format_name: decimal_0
  }

  measure: sum_ordered_items_quantity_desadv {
    label: "# Filled Quantities (PO > DESADV)"
    group_label: "PO >> DESADV"

    type: sum
    sql: ${total_quantity_desadv} ;;
    filters: [is_purchase_order_row_exists: "yes"]
  }

  measure: pct_ordered_items_quantity_po_desadv_fill_rate {
    label: "% Fill Rate (PO > DESADV)"
    description: "Relative amount of fullfilled quantities (PO > DESADV) compared to overall ordered quantities "
    group_label: "PO >> DESADV"

    type: number
    sql: safe_divide(${sum_ordered_items_quantity_desadv}, ${sum_ordered_items_quantity_po}) ;;
    value_format_name: percent_0
  }

  measure: sum_ordered_items_quantity_desadv_limited {
    label: "# Filled Quantities lim. (PO > DESADV)"
    group_label: "PO >> DESADV"

    type: sum
    sql:  -- limits the sum of quantities on DESADV to be at max as high as the value on the PO
          if(${total_quantity_desadv} > ${total_quantity_purchase_order},
             ${total_quantity_purchase_order},
             ${total_quantity_desadv}
            );;
    filters: [is_purchase_order_row_exists: "yes"]
  }

  measure: pct_ordered_items_quantity_po_desadv_fill_rate_limited {
    label: "% Fill Rate lim. (PO > DESADV)"
    description: "Relative amount of fullfilled quantities (PO > DESADV) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> DESADV"

    type: number
    sql: safe_divide(${sum_ordered_items_quantity_desadv_limited}, ${sum_ordered_items_quantity_po}) ;;
    value_format_name: percent_0
  }

  # Overdeliveries
  measure: cnt_ordered_items_delivered_overdelivered {
    label: "# Overdelivered order lines (PO > DESADV)"
    group_label: "PO >> DESADV"

    type: count_distinct
    sql: concat(${parent_sku_purchase_order}, ${table_uuid}) ;;
    filters: [is_po_desadv_quantity_overdelivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_delivered_overdelivered {
    label: "% Overdelivered order lines (PO > DESADV)"
    description: "Share of overdelivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_overdelivered}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_ordered_items_delivered_quantities_overdelivered {
    label: "AVG Overdelivered quantity (PO > DESADV)"
    description: "Average of overdelivered quantity (PO > DESADV) per overdelivered order line"
    group_label: "PO >> DESADV"

    type: average
    sql: (${total_quantity_desadv} - ${total_quantity_purchase_order}) ;;
    filters: [is_po_desadv_quantity_overdelivery: "yes"]
    value_format_name: decimal_1
  }

  # Underdeliveries
  measure: cnt_ordered_items_delivered_underdelivered {
    label: "# Underdelivered order lines (PO > DESADV)"
    group_label: "PO >> DESADV"

    type: count_distinct
    sql: concat(${parent_sku_purchase_order}, ${table_uuid}) ;;
    filters: [is_po_desadv_quantity_underdelivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_delivered_underdelivered {
    label: "% Underdelivered order lines (PO > DESADV)"
    description: "Share of underdelivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_underdelivered}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_ordered_items_delivered_quantities_underdelivered {
    label: "AVG Underdelivered quantity (PO > DESADV)"
    description: "Average of underdelivered quantity (PO > DESADV) per overdelivered order line"
    group_label: "PO >> DESADV"

    type: average
    sql: (${total_quantity_purchase_order} - ${total_quantity_desadv}) ;;
    filters: [is_po_desadv_quantity_underdelivery: "yes"]
    value_format_name: decimal_1
  }


# # In Full on time
# % OTIF relaxed quantity (PO > DESADV)
# % OTIF strict (PO > DESADV)
# % OTIF strict lim. (PO > DESADV)

# # Not fulfilled PO

# % Not fulfilled POs (PO > DESADV)

# # Unplanned delivery

# % Unplanned delivery (PO > DESADV)
# % Unplanned delivery quantity (PO > DESADV)
}
