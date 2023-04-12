explore: advanced_supplier_matching {
  hidden: yes
  view_label: "TMP - Do NOT use"
}


include: "/supply_chain/views/bigquery_reporting/advanced_supplier_matching.view"

view: +advanced_supplier_matching {

  dimension: is_purchase_order_row_exists {
    type: yesno
    sql: ${parent_sku_purchase_order} is not null ;;
    hidden: yes
  }

  dimension: is_desadv_row_exists {
    type: yesno
    sql: ${parent_sku_desadv} is not null ;;
    hidden: yes
  }

  dimension: purchase_order_order_lineitems {
    description: "The unique identifier of a product in a purchase order"
    type: string
    sql: concat(${parent_sku_purchase_order}, ${table_uuid}) ;;
    hidden: yes
  }

  dimension: desadv_order_lineitems {
    description: "The unique identifier of a product in a dispatch notification"
    type: string
    sql: concat(${parent_sku_desadv}, ${table_uuid}) ;;
    hidden: yes
  }

  measure: cnt_ordered_items_puchase_order {
    label: "# Ordered Items (PO)"
    description: "The number of SKUs, that have been ordered"

    type: count_distinct
    # unique SKUS per PO or DESADV:
    sql: ${purchase_order_order_lineitems} ;;
    value_format_name: decimal_0
  }

  measure: sum_ordered_items_quantity_po {
    label: "# Total Quantity (PO)"

    # using this approach to also show NULL values and surpress the default coalesce(metric, 0) behavior of Looker
    type: number
    sql: sum(${total_quantity_purchase_order}) ;;
    value_format_name: decimal_0
  }

  measure: sum_of_ordered_items_quantity_po_hu_flex {
    label: "# Total Quantity in HU flex. (PO)"
    group_label: "Quantity in Handling Units"
    description: "Total item quantity PO in Handling Units allowing decimals."
    # using this approach to also show NULL values and surpress the default coalesce(metric, 0) behavior of Looker
    type: sum
    sql: ${total_quantity_purchase_order_hu} ;;
    value_format_name: decimal_2
  }

  measure: sum_of_ordered_items_quantity_po_hu_strict {
    label: "# Total Quantity in HU strict (PO)"
    group_label: "Quantity in Handling Units"
    description: "Total item quantity PO in Handling Units not allowing decimals."
    # using this approach to also show NULL values and surpress the default coalesce(metric, 0) behavior of Looker
    type: sum
    sql: floor(${total_quantity_purchase_order_hu}) ;;
    value_format_name: decimal_0
  }

  measure: sum_ordered_items_quantity_desadv {
    label: "# Total Quantity (DESADV)"

    type: sum
    sql: ${total_quantity_desadv} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_ordered_items_quantity_desadv_hu_flex {
    label: "# Total Quantity in HU flex. (DESADV)"
    group_label: "Quantity in Handling Units"
    description: "Total item quantity DESADVs in Handling Units allowing decimals."
    type: sum
    sql: ${total_quantity_desadv_hu} ;;
    value_format_name: decimal_2
  }

  measure: sum_of_ordered_items_quantity_desadv_hu_strict {
    label: "# Total Quantity in HU strict (DESADV)"
    group_label: "Quantity in Handling Units"
    description: "Total item quantity DESADVs in Handling Units not allowing decimals."
    type: sum
    sql: floor(${total_quantity_desadv_hu}) ;;
    value_format_name: decimal_0
  }

  measure: cnt_ordered_items_desadv {
    label: "# Delivered Items (DESADV)"
    description: "The number of SKUs, that have been delivered according to the dispatch notification (DESADV)"

    type: count_distinct
    # unique SKUS per PO or DESADV:
    sql: ${desadv_order_lineitems} ;;
    value_format_name: decimal_0
  }

  measure: cnt_items_inbounded {
    label: "# Inbounded Items"
    description: "The unique number of inbounded items"

    type: count_distinct
    sql: concat(${table_uuid}, ${parent_sku}) ;;
    filters: [inbounded_quantity: ">0"]
    value_format_name: decimal_0
  }

  measure: sum_items_inbounded {
    label: "# Total Quantity Inbounded"
    description: "The total item quantity, that was inbounded"

    type: sum
    sql: ${inbounded_quantity} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_items_inbounded_hu_flex {
    label: "# Total Quantity Inbounded in HU flex."
    group_label: "Quantity in Handling Units"
    description: "Total item quantity inbounded in Handling Units allowing decimals."
    type: sum
    sql: ${inbounded_quantity_hu} ;;
    value_format_name: decimal_2
  }

  measure: sum_of_items_inbounded_hu_strict {
    label: "# Total Quantity Inbounded in HU Strict"
    group_label: "Quantity in Handling Units"
    description: "Total item quantity inbounded in Handling Units not allowing decimals."
    type: sum
    sql: floor(${inbounded_quantity_hu}) ;;
    value_format_name: decimal_0
  }

  dimension: is_matched_purchase_order_specifc {
    # this is a logic requested to Marcel to compare the PO separately with inbounds in order for their on-time PO >> Inbound metrics (ONLY!)
    type: string
    sql:
      case
        when date_diff(${inbounded_date}, ${promised_delivery_date_purchase_order_date}, day) = 0
        then 'same_day'
        when date_diff(${inbounded_date}, ${promised_delivery_date_purchase_order_date}, day) > 0
        then 'too_late'
        when date_diff(${inbounded_date}, ${promised_delivery_date_purchase_order_date}, day) < 0
        then 'too_early'
      end
    ;;
    hidden: yes
  }

  dimension: number_of_days_inbounded_too_late_purchase_order {
    # this is a logic requested to Marcel to compare the PO separately with inbounds in order for their on-time PO >> Inbound metrics (ONLY!)
    type: number
    sql:
      if(
            date_diff(${inbounded_date}, ${promised_delivery_date_purchase_order_date}, day) > 0,
            date_diff(${inbounded_date}, ${promised_delivery_date_purchase_order_date}, day),
            null
            ) ;;
    hidden: yes
  }

  dimension: number_of_days_inbounded_too_early_purchase_order {
    # this is a logic requested to Marcel to compare the PO separately with inbounds in order for their on-time PO >> Inbound metrics (ONLY!)
    type: number
    sql:
      if(
            date_diff(${inbounded_date}, ${promised_delivery_date_purchase_order_date}, day) < 0,
            date_diff(${inbounded_date}, ${promised_delivery_date_purchase_order_date}, day),
            null
            ) ;;
    hidden: yes
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    PO >> DESADV
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # ----------------     On Time KPIs    ----------------



  measure: cnt_ordered_items_delivered_on_time {
    label: "# On Time Delivery (PO > DESADV)"
    description: "The number of SKUs, that have been ordered and have been delivered at the promised delivery date"
    group_label: "PO >> DESADV | On Time"

    type: count_distinct
    # unique SKUS per PO or DESADV:
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_po_delivered_on_promised_delivery_date: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_desadv_on_time_delivery {

    label: "% On Time Delivery (PO > DESADV)"
    description: "Share of on time delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | On Time"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_on_time}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  #### Too Early
  measure: cnt_ordered_items_delivered_too_early {
    label: "# Too Early Delivered (PO > DESADV)"
    group_label: "PO >> DESADV | On Time"

    type: count_distinct
    # unique SKUS per PO or DESADV:
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_po_delivered_too_early: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_desadv_delivery_too_early {

    label: "% Too Early Delivery (PO > DESADV)"
    description: "Share of too early delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | On Time"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_too_early}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_days_po_desadv_delivery_too_early {
    label: "AVG Days Too Early Delivered (PO > DESADV)"
    description: "Average number of days order lines have been delivered early (PO > DESADV) per early delivered ordered lines"
    group_label: "PO >> DESADV | On Time"

    type: average
    sql: ${number_of_days_delivered_too_early} ;;
    value_format_name: decimal_1
  }

  #### Too Late
  measure: cnt_ordered_items_delivered_too_late {
    label: "# Too Late Delivery (PO > DESADV)"
    group_label: "PO >> DESADV | On Time"

    type: count_distinct
    # unique SKUS per PO or DESADV:
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_po_delivered_too_late: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_desadv_delivery_too_late {
    label: "% Too Late Delivery (PO > DESADV)"
    description: "Share of too late delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | On Time"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_too_late}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_days_po_desadv_delivery_too_late {
    label: "AVG Days Too Late Delivered (PO > DESADV)"
    description: "Average number of days order lines have been delivered late (PO > DESADV) per late delivered ordered lines"
    group_label: "PO >> DESADV | On Time"

    type: average
    sql: ${number_of_days_delivered_too_late} ;;
    value_format_name: decimal_1
  }





  # ----------------     In Full    ----------------
  #### In full
  measure: cnt_ordered_items_in_full {
    label: "# In Full delivery (PO > DESADV)"
    description: "Number of in full delivered order lines (PO > DESADV)"
    group_label: "PO >> DESADV | In Full"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_po_desadv_quantity_in_full: "yes"]
    value_format_name: decimal_0

  }

  measure: pct_ordered_items_in_full {
    label: "% In Full strict (PO > DESADV)"
    description: "Share of in full delivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | In Full"

    type: number
    sql: safe_divide(${cnt_ordered_items_in_full}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: cnt_ordered_items_in_full_limited {
    label: "# In Full delivery lim. (PO > DESADV)"
    description: "Number of in full delivered order lines (PO > DESADV), where an overdelivery counts as an in full delivery"
    group_label: "PO >> DESADV | In Full"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_po_desadv_quantity_in_full_limited: "yes"]
    value_format_name: decimal_0

  }

  measure: pct_ordered_items_in_full_limited {
    label: "% In Full strict lim. (PO > DESADV)"
    description: "Share of in full delivered order lines (PO > DESADV) compared to all order lines, where an overdelivery counts as an in full delivery"
    group_label: "PO >> DESADV | In Full"

    type: number
    sql: safe_divide(${cnt_ordered_items_in_full_limited}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  #### Fill Rate
  measure: sum_ordered_items_quantity_desadv_with_po {
    label: "# Filled Quantities (PO > DESADV)"
    description: "Sum of fullfilled quantities (PO > DESADV)"
    group_label: "PO >> DESADV | In Full"

    type: sum
    sql: ${total_quantity_desadv} ;;
    filters: [is_purchase_order_row_exists: "yes"]
  }

  measure: pct_ordered_items_quantity_po_desadv_fill_rate {
    label: "% In Full relaxed (PO > DESADV)"
    description: "Relative amount of fullfilled quantities (PO > DESADV) compared to overall ordered quantities "
    group_label: "PO >> DESADV | In Full"

    type: number
    sql: safe_divide(${sum_ordered_items_quantity_desadv_with_po}, ${sum_ordered_items_quantity_po}) ;;
    value_format_name: percent_0
  }

  measure: sum_ordered_items_quantity_desadv_limited {
    label: "# Filled Quantities lim. (PO > DESADV)"
    description: "Sum of fullfilled quantities (PO > DESADV) , where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> DESADV | In Full"

    type: sum
    sql:  -- limits the sum of quantities on DESADV to be at max as high as the value on the PO
          if(${total_quantity_desadv} > ${total_quantity_purchase_order},
             ${total_quantity_purchase_order},
             ${total_quantity_desadv}
            );;
    filters: [is_purchase_order_row_exists: "yes"]
  }

  measure: pct_ordered_items_quantity_po_desadv_fill_rate_limited {
    label: "% In Full relaxed lim. (PO > DESADV)"
    description: "Relative amount of fullfilled quantities (PO > DESADV) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> DESADV | In Full"

    type: number
    sql: safe_divide(${sum_ordered_items_quantity_desadv_limited}, ${sum_ordered_items_quantity_po}) ;;
    value_format_name: percent_0
  }

  #### Overdeliveries
  measure: cnt_ordered_items_delivered_overdelivered {
    label: "# Overdelivered order lines (PO > DESADV)"
    description: "Number of overdelivered order lines (PO > DESADV)"
    group_label: "PO >> DESADV | In Full"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_po_desadv_quantity_overdelivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_delivered_overdelivered {
    label: "% Overdelivered order lines (PO > DESADV)"
    description: "Share of overdelivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | In Full"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_overdelivered}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_ordered_items_delivered_quantities_overdelivered {
    label: "AVG Overdelivered quantity (PO > DESADV)"
    description: "Average of overdelivered quantity (PO > DESADV) per overdelivered order line"
    group_label: "PO >> DESADV | In Full"

    type: average
    sql: (${total_quantity_desadv} - ${total_quantity_purchase_order}) ;;
    filters: [is_po_desadv_quantity_overdelivery: "yes"]
    value_format_name: decimal_1
  }

  #### Underdeliveries
  measure: cnt_ordered_items_delivered_underdelivered {
    label: "# Underdelivered order lines (PO > DESADV)"
    description: "Number of underdelivered order lines (PO > DESADV)"
    group_label: "PO >> DESADV | In Full"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_po_desadv_quantity_underdelivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_delivered_underdelivered {
    label: "% Underdelivered order lines (PO > DESADV)"
    description: "Share of underdelivered order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | In Full"

    type: number
    sql: safe_divide(${cnt_ordered_items_delivered_underdelivered}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_ordered_items_delivered_quantities_underdelivered {
    label: "AVG Underdelivered quantity (PO > DESADV)"
    description: "Average of underdelivered quantity (PO > DESADV) per overdelivered order line"
    group_label: "PO >> DESADV | In Full"

    type: average
    sql: (${total_quantity_purchase_order} - ${total_quantity_desadv}) ;;
    filters: [is_po_desadv_quantity_underdelivery: "yes"]
    value_format_name: decimal_1
  }





  # ----------------     On-Time In-Full    ----------------
  measure: sum_ordered_items_quantity_desadv_on_time {
    label: "# OTIF relaxed quantity (PO > DESADV)"
    description: "Sum of on time fulfilled quantities (PO > DESADV)"
    group_label: "PO >> DESADV | OTIF"

    type: sum
    sql: ${total_quantity_desadv} ;;
    filters: [is_purchase_order_row_exists: "yes",
              is_po_delivered_on_promised_delivery_date: "yes"
      ]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_quantity_desadv_on_time_in_full {
    label: "% OTIF relaxed quantity (PO > DESADV)"
    description: "Relative amount of on time fulfilled quantities (PO > DESADV) compared to overall ordered quantities "
    group_label: "PO >> DESADV | OTIF"

    type: number
    sql: safe_divide(${sum_ordered_items_quantity_desadv_on_time}, ${sum_ordered_items_quantity_po}) ;;
    value_format_name: percent_0
  }

  measure: sum_ordered_items_quantity_desadv_on_time_limited {
    label: "# OTIF relaxed quantity lim. (PO > DESADV)"
    description: "Total amount of on time fulfilled quantities (PO > DESADV), where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> DESADV | OTIF"

    type: sum
    sql: if(
              ${total_quantity_desadv} > ${total_quantity_purchase_order}
            , ${total_quantity_purchase_order}
            , ${total_quantity_desadv}
            );;
    filters: [is_purchase_order_row_exists: "yes",
      is_po_delivered_on_promised_delivery_date: "yes"
    ]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_quantity_desadv_on_time_in_full_limited {
    label: "% OTIF relaxed quantity lim. (PO > DESADV)"
    description: "Relative amount of on time fulfilled quantities (PO > DESADV) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> DESADV | OTIF"

    type: number
    sql: safe_divide(${sum_ordered_items_quantity_desadv_on_time_limited}, ${sum_ordered_items_quantity_po}) ;;
    value_format_name: percent_0
  }

  measure: cnt_ordered_items_on_time_in_full {
    label: "# OTIF strict (PO > DESADV)"
    description: "Number of on time and in full order lines (PO > DESADV)"
    group_label: "PO >> DESADV | OTIF"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_po_desadv_quantity_in_full: "yes",
              is_po_delivered_on_promised_delivery_date: "yes"
             ]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_on_time_in_full {
    label: "% OTIF strict (PO > DESADV)"
    description: "Share of on time and in full order lines (PO > DESADV) compared to all order lines "
    group_label: "PO >> DESADV | OTIF"

    type: number
    sql: safe_divide(${cnt_ordered_items_on_time_in_full}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: cnt_ordered_items_on_time_in_full_limited {
    label: "# OTIF strict lim. (PO > DESADV)"
    description: "Number of on time and in full order lines (PO > DESADV), where an overdelivery counts as an in full delivery"
    group_label: "PO >> DESADV | OTIF"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_po_desadv_quantity_in_full_limited: "yes",
      is_po_delivered_on_promised_delivery_date: "yes"
    ]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_on_time_in_full_limited {
    label: "% OTIF strict lim. (PO > DESADV)"
    description: "Share of on time and in full order lines (PO > DESADV) compared to all order lines , where an overdelivery counts as an in full delivery"
    group_label: "PO >> DESADV | OTIF"

    type: number
    sql: safe_divide(${cnt_ordered_items_on_time_in_full_limited}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }



  # ----------------     Not-Fulfilled or Unplanned    ----------------
  measure: cnt_ordered_items_po_not_fulfilled {
    label: "# Not fulfilled POs (PO > DESADV)"
    description: "Number of not fulfilled order lines (PO > DESADV)"
    group_label: "PO >> DESADV | Unplanned or Not Fulfilled"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_not_fulfilled_purchase_order: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_po_not_fulfilled {
    label: "% Not fulfilled POs (PO > DESADV)"
    description: "Share of not fulfilled order lines (PO > DESADV) compared to all order lines"
    group_label: "PO >> DESADV | Unplanned or Not Fulfilled"

    type: number
    sql: safe_divide(${cnt_ordered_items_po_not_fulfilled}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_1
  }

  measure: cnt_ordered_items_po_unplanned {
    label: "# Unplanned delivery (PO > DESADV)"
    group_label: "PO >> DESADV | Unplanned or Not Fulfilled"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_unplanned_delivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_po_unplanned {
    label: "% Unplanned delivery (PO > DESADV)"
    description: "Share of unplanned DESADV lines (PO > DESADV) compared to all DESADV lines"
    group_label: "PO >> DESADV | Unplanned or Not Fulfilled"

    type: number
    sql: safe_divide(${cnt_ordered_items_po_unplanned}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_1
  }

  measure: sum_ordered_items_quantity_po_unplanned {
    label: "# Unplanned delivery quantity (PO > DESADV)"
    group_label: "PO >> DESADV | Unplanned or Not Fulfilled"

    type: sum
    sql: ${total_quantity_desadv} ;;
    filters: [is_unplanned_delivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_ordered_items_quantity_po_unplanned {
    label: "% Unplanned delivery quantity (PO > DESADV)"
    description: "Relative amount of unplanned delivery quantities (PO > DESADV) compared to all DESADV quantities"
    group_label: "PO >> DESADV | Unplanned or Not Fulfilled"

    type: number
    sql: safe_divide(${sum_ordered_items_quantity_po_unplanned}, ${sum_ordered_items_quantity_desadv}) ;;
    value_format_name: percent_1
  }




  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -   DESADV >> Inbound
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  # ----------------     On Time    ----------------

  measure: cnt_desadv_inbounded_items_on_time {
    label: "# On Time delivery (DESADV > Inbound)"
    description: "Number of on time delivered DESADV lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | On Time"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_matched_on_same_date: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_inbounded_items_on_time {
    label: "% On Time delivery (DESADV > Inbound)"
    description: "Share of on time delivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | On Time"

    type: number
    sql: safe_divide(${cnt_desadv_inbounded_items_on_time}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: cnt_desadv_inbounded_items_too_early {
    label: "# Too Early Delivery (DESADV > Inbound)"
    description: "Number of too early delivered DESADV lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | On Time"

    type: count_distinct
    sql:  ${desadv_order_lineitems};;
    filters: [is_matched_on_too_early_date: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_inbounded_items_too_early {
    label: "% Too Early Delivery (DESADV > Inbound)"
    description: "Share of too early delivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | On Time"

    type: number
    sql: safe_divide(${cnt_desadv_inbounded_items_too_early}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: avg_days_desadv_inbounded_items_too_early {
    label: "AVG Days Too Early Delivery (DESADV > Inbound)"
    description: "Average number of days order lines have been delivered early (DESADV > Inbound) per early delivered ordered lines"
    group_label: "DESADV >> Inbound | On Time"

    type: average
    sql: ${number_of_days_inbounded_too_early} ;;
    value_format_name: decimal_1
  }


  measure: cnt_desadv_inbounded_items_too_late {
    label: "# Too Late Delivery (DESADV > Inbound)"
    description: "Number of too late delivered DESADV lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | On Time"

    type: count_distinct
    sql:  ${desadv_order_lineitems};;
    filters: [is_matched_on_too_late_date: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_inbounded_items_too_late {
    label: "% Too Late Delivery (DESADV > Inbound)"
    description: "Share of too late delivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | On Time"

    type: number
    sql: safe_divide(${cnt_desadv_inbounded_items_too_late}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: avg_days_desadv_inbounded_items_too_late {
    label: "AVG Days Too Late Delivery (DESADV > Inbound)"
    description: "Average number of days order lines have been delivered late (DESADV > Inbound) per late delivered ordered lines"
    group_label: "DESADV >> Inbound | On Time"

    type: average
    sql: ${number_of_days_inbounded_too_late} ;;
    value_format_name: decimal_1
  }



  # ----------------     In Full    ----------------
  measure: cnt_desadv_inbounded_in_full {
    label: "# In Full delivery (DESADV > Inbound)"
    description: "Number of in full delivered DESADV lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | In Full"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_desadv_inbounded_in_full: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_inbounded_in_full {
    label: "% In Full strict (DESADV > Inbound)"
    description: "Share of in full delivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | In Full"

    type: number
    sql: safe_divide(${cnt_desadv_inbounded_in_full}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: cnt_desadv_inbounded_in_full_lim {
    label: "# In Full delivery lim. (DESADV > Inbound)"
    description: "Number of in full delivered DESADV lines (DESADV > Inbound) where an overdelivery counts as an in full delivery"
    group_label: "DESADV >> Inbound | In Full"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_desadv_inbounded_in_full_limited: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_inbounded_in_full_lim {
    label: "% In Full strict lim. (DESADV > Inbound)"
    description: "Share of in full delivered DESADV lines (DESADV > Inbound) compared to all DESADV lines, where an overdelivery counts as an in full delivery"
    group_label: "DESADV >> Inbound | In Full"

    type: number
    sql: safe_divide(${cnt_desadv_inbounded_in_full_lim}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: sum_desadv_quantity_inbounded {
    label: "# Quantity Inbounded (DESADV > Inbound)"
    description: "Total amount of fullfilled quantities (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | In Full"

    type: sum
    sql: if(${dispatch_notification_id} is not null,${inbounded_quantity},0) ;;
    #filters: [is_desadv_row_exists: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_fill_rate {
    label: "% In Full relaxed (DESADV > Inbound)"
    description: "Relative amount of fullfilled quantities (DESADV > Inbound) compared to overall DESADV quantities "
    group_label: "DESADV >> Inbound | In Full"

    type: number
    sql: safe_divide(${sum_desadv_quantity_inbounded}, ${sum_ordered_items_quantity_desadv}) ;;
    value_format_name: percent_0
  }

  measure: sum_desadv_quantity_inbounded_lim {
    label: "# Quantity Inbounded lim. (DESADV > Inbound)"
    description: "Total amount of fullfilled quantities (DESADV > Inbound), where an overdelivered quantity is limited to the DESADV quantity"
    group_label: "DESADV >> Inbound | In Full"

    type: sum
    sql:
         -- limit the inbounded quantities to be at max as high as the related sellibg units on the DESADV
        case
          when ${dispatch_notification_id} is null
            then 0
          when ${dispatch_notification_id} is not null and ${inbounded_quantity} > ${total_quantity_desadv}
            then ${total_quantity_desadv}
          else ${inbounded_quantity}
        end ;;
    #filters: [is_desadv_row_exists: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_fill_rate_lim {
    label: "% In Full relaxed lim. (DESADV > Inbound)"
    description: "Relative amount of fullfilled quantities (DESADV > Inbound) compared to overall DESADV quantities, where an overdelivered quantity is limited to the DESADV quantity"
    group_label: "DESADV >> Inbound | In Full"

    type: number
    sql: safe_divide(${sum_desadv_quantity_inbounded_lim}, ${sum_ordered_items_quantity_desadv}) ;;
    value_format_name: percent_0
  }

  measure: cnt_desadv_inbounded_overdelivery {
    label: "# Overdelivered order lines (DESADV > Inbound)"
    description: "Number of overdelivered DESADV lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | In Full"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_desadv_inbounded_overdelivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_inbounded_overdelivery {
    label: "% Overdelivered order lines (DESADV > Inbound)"
    description: "Share of overdelivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | In Full"

    type: number
    sql: safe_divide(${cnt_desadv_inbounded_overdelivery}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: avg_desadv_inbounded_quantity_overdelivery {
    label: "AVG Overdelivered quantity (DESADV > Inbound)"
    description: "Average of overdelivered quantity (DESADV > Inbound) per overdelivered order line"
    group_label: "DESADV >> Inbound | In Full"

    type: average
    sql: (${inbounded_quantity} - ${total_quantity_desadv}) ;;
    filters: [is_desadv_inbounded_overdelivery: "yes"]
    value_format_name: decimal_1
  }

  measure: cnt_desadv_inbounded_underdelivery {
    label: "# Underdelivered order lines (DESADV > Inbound)"
    description: "Number of underdelivered DESADV lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | In Full"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_desadv_inbounded_underdelivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_inbounded_underdelivery {
    label: "% Underdelivered order lines (DESADV > Inbound)"
    description: "Share of underdelivered DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | In Full"

    type: number
    sql: safe_divide(${cnt_desadv_inbounded_underdelivery}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: avg_desadv_inbounded_quantity_underdelivery {
    label: "AVG Underdelivered quantity (DESADV > Inbound)"
    description: "Average of underdelivered quantity (DESADV > Inbound) per underdelivered order line"
    group_label: "DESADV >> Inbound | In Full"

    type: average
    sql: (${total_quantity_desadv} - ${inbounded_quantity}) ;;
    filters: [is_desadv_inbounded_underdelivery: "yes"]
    value_format_name: decimal_1
  }


  # ----------------   OTIF    ----------------

  measure: sum_desadv_otif_relaxed {
    label: "# OTIF relaxed quantity (DESADV > Inbound)"
    description: "Total amount of on time fulfilled quantities (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | OTIF"

    type: sum
    sql: ${inbounded_quantity} ;;
    filters: [is_desadv_row_exists: "yes",
              is_matched_on_same_date: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_otif_relaxed {
    label: "% OTIF relaxed quantity (DESADV > Inbound)"
    description: "Relative amount of on time fulfilled quantities (DESADV > Inbound) compared to overall DESADV quantities "
    group_label: "DESADV >> Inbound | OTIF"

    type: number
    sql: safe_divide(${sum_desadv_otif_relaxed}, ${sum_ordered_items_quantity_desadv}) ;;
    value_format_name: percent_0
  }

  measure: sum_desadv_otif_relaxed_limited {
    label: "# OTIF relaxed quantity lim. (DESADV > Inbound)"
    description: "Total amount of on time fulfilled quantities (DESADV > Inbound), where an overdelivered quantity is limited to the DESADV quantity"
    group_label: "DESADV >> Inbound | OTIF"

    type: sum
    sql: if(
              ${inbounded_quantity} > ${total_quantity_desadv}
            , ${total_quantity_desadv}
            , ${inbounded_quantity}
            );;
    filters: [is_desadv_row_exists: "yes",
              is_matched_on_same_date: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_otif_relaxed_limited {
    label: "% OTIF relaxed quantity lim. (DESADV > Inbound)"
    description: "Relative amount of on time fulfilled quantities (DESADV > Inbound) compared to overall DESADV quantities, where an overdelivered quantity is limited to the DESADV quantity"
    group_label: "DESADV >> Inbound | OTIF"

    type: number
    sql: safe_divide(${sum_desadv_otif_relaxed_limited}, ${sum_ordered_items_quantity_desadv}) ;;
    value_format_name: percent_0
  }


  measure: cnt_desadv_otif_strict {
    label: "# OTIF strict (DESADV > Inbound)"
    description: "Number of on time, in full DESADV lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | OTIF"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_matched_on_same_date: "yes",
              is_desadv_inbounded_in_full: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_otif_strict {
    label: "% OTIF strict (DESADV > Inbound)"
    description: "Share of on time, in full DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | OTIF"

    type: number
    sql: safe_divide(${cnt_desadv_otif_strict}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: cnt_desadv_otif_strict_limited {
    label: "# OTIF strict lim. (DESADV > Inbound)"
    description: "Total of on time, in full DESADV lines (DESADV > Inbound), where an overdelivery counts as an in full delivery"
    group_label: "DESADV >> Inbound | OTIF"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_matched_on_same_date: "yes",
              is_desadv_inbounded_in_full_limited: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_otif_strict_limited {
    label: "% OTIF strict lim. (DESADV > Inbound)"
    description: "Share of on time, in full DESADV lines (DESADV > Inbound) compared to all DESADV lines, where an overdelivery counts as an in full delivery"
    group_label: "DESADV >> Inbound | OTIF"

    type: number
    sql: safe_divide(${cnt_desadv_otif_strict_limited}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }


  # ----------------     IQ & OTIFIQ    ----------------
  measure: sum_desadv_items_inbounded_in_quality {
    label: "# Items Inbounded In Quality (DESADV > Inbound)"
    description: "Share of in quality delivered order lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | In Quality"

    type: sum
    sql: ${inbounded_quantity} ;;
    filters: [is_desadv_row_exists: "yes", is_quality_issue: "no"]
    value_format_name: decimal_0
  }

  measure:  pct_desadv_items_inbounded_in_quality {
    label: "% In Quality (DESADV > Inbound)"
    description: "Share of in quality delivered order lines (DESADV > Inbound) compared to all inbounded order lines "
    group_label: "DESADV >> Inbound | In Quality"

    type: number
    sql: safe_divide(${sum_desadv_items_inbounded_in_quality}, ${sum_desadv_quantity_inbounded}) ;;
    value_format_name: percent_0
  }

  measure: sum_desadv_otifiq_relaxed {
    label: "# OTIFIQ relaxed quantity (DESADV > Inbound)"
    description: "Total amount of on time and in quality fulfilled quantities (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: sum
    sql: ${inbounded_quantity} ;;
    filters: [is_desadv_row_exists: "yes",
              is_quality_issue: "no",
              is_matched_on_same_date: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_otifiq_relaxed {
    label: "% OTIFIQ relaxed quantity (DESADV > Inbound)"
    description: "Relative amount of on time and in quality fulfilled quantities (DESADV > Inbound) compared to overall DESADV quantities "
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${sum_desadv_otifiq_relaxed}, ${sum_ordered_items_quantity_desadv}) ;;
    value_format_name: percent_0
  }

  measure: sum_desadv_otifiq_relaxed_limited {
    label: "# OTIFIQ relaxed quantity lim. (DESADV > Inbound)"
    description: "Total amount of on time and in quality fulfilled quantities (DESADV > Inbound), where an overdelivered quantity is limited to the DESADV quantity"
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: sum
    sql: if(
              ${inbounded_quantity} > ${total_quantity_desadv}
            , ${total_quantity_desadv}
            , ${inbounded_quantity}
            );;
    filters: [is_desadv_row_exists: "yes",
      is_quality_issue: "no",
      is_matched_on_same_date: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_otifiq_relaxed_limited {
    label: "% OTIFIQ relaxed quantity lim. (DESADV > Inbound)"
    description: "Relative amount of on time and in quality fulfilled quantities (DESADV > Inbound) compared to overall DESADV quantities, where an overdelivered quantity is limited to the DESADV quantity"
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${sum_desadv_otifiq_relaxed_limited}, ${sum_ordered_items_quantity_desadv}) ;;
    value_format_name: percent_0
  }

  measure: cnt_desadv_otifiq_stric {
    label: "# OTIFIQ strict (DESADV > Inbound)"
    description: "Number of on time, in full and in quality DESADV lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_quality_issue: "no",
              is_matched_on_same_date: "yes",
              is_desadv_inbounded_in_full: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_otifiq_stric {
    label: "% OTIFIQ strict (DESADV > Inbound)"
    description: "Share of on time, in full and in quality DESADV lines (DESADV > Inbound) compared to all DESADV lines "
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${cnt_desadv_otifiq_stric}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: cnt_desadv_otifiq_stric_limited {
    label: "# OTIFIQ strict lim. (DESADV > Inbound)"
    description: "Total of on time, in full and in quality DESADV lines (DESADV > Inbound), where an overdelivery counts as an in full delivery"
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_quality_issue: "no", is_matched_on_same_date: "yes", is_desadv_inbounded_in_full_limited: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_otifiq_stric_limited {
    label: "% OTIFIQ strict lim. (DESADV > Inbound)"
    description: "Share of on time, in full and in quality DESADV lines (DESADV > Inbound) compared to all DESADV lines, where an overdelivery counts as an in full delivery"
    group_label: "DESADV >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${cnt_desadv_otifiq_stric_limited}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }


  # ----------------     Not-Fulfilled or Unplanned    ----------------
  measure: cnt_desadv_ordered_items_unfulfilled {
    label: "# Not fulfilled DESADVs (DESADV > Inbound)"
    description: "Number of not fulfilled DESADV lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | Unplanned or Not Fulfilled"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_desadv_unfulfilled: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_ordered_items_unfulfilled {
    label: "% Not fulfilled DESADVs (DESADV > Inbound)"
    description: "Share of not fulfilled DESADV lines (DESADV > Inbound) compared to all DESADV lines"
    group_label: "DESADV >> Inbound | Unplanned or Not Fulfilled"

    type: number
    sql: safe_divide(${cnt_desadv_ordered_items_unfulfilled}, ${cnt_ordered_items_desadv}) ;;
    value_format_name: percent_0
  }

  measure: cnt_desadv_items_unplanned {
    label: "# Unplanned inbound (DESADV > Inbound)"
    description: "Number of unplanned inbound lines (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | Unplanned or Not Fulfilled"

    type: count_distinct
    sql: ${desadv_order_lineitems} ;;
    filters: [is_unplanned_inbound: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_items_unplanned {
    label: "% Unplanned inbound (DESADV > Inbound)"
    description: "Share of unplanned inbound lines (DESADV > Inbound) compared to all inbound lines"
    group_label: "DESADV >> Inbound | Unplanned or Not Fulfilled"

    type: number
    sql: safe_divide(${cnt_desadv_items_unplanned}, ${cnt_items_inbounded}) ;;
    value_format_name: percent_0
  }

  measure: sum_desadv_items_quantity_unplanned {
    label: "# Unplanned inbound quantity (DESADV > Inbound)"
    description: "Total amount of unplanned inbounded quantities (DESADV > Inbound)"
    group_label: "DESADV >> Inbound | Unplanned or Not Fulfilled"

    type: sum
    sql: ${inbounded_quantity} ;;
    filters: [is_unplanned_inbound: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_desadv_items_quantity_unplanned {
    label: "% Unplanned inbound quantity (DESADV > Inbound)"
    description: "Relative amount of unplanned inbounded quantities (DESADV > Inbound) compared to all inbounded quantities"
    group_label: "DESADV >> Inbound | Unplanned or Not Fulfilled"

    type: number
    sql: safe_divide(${sum_desadv_items_quantity_unplanned}, ${sum_items_inbounded}) ;;
    value_format_name: percent_0
  }










  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -   PO >> Inbound
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  measure: cnt_po_inbounded_items_on_time {
    label: "# On Time delivery (PO > Inbound)"
    description: "Total of on time delivered order lines (PO > Inbound)"
    group_label: "PO >> Inbound | On Time"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_matched_purchase_order_specifc: "same_day"]
    value_format_name: decimal_0
  }

  measure: pct_po_inbounded_items_on_time {
    label: "% On Time delivery (PO > Inbound)"
    description: "Share of on time delivered order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | On Time"

    type: number
    sql: safe_divide(${cnt_po_inbounded_items_on_time}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: cnt_po_inbounded_items_too_early {
    label: "# Too Early Delivery (PO > Inbound)"
    description: "Number of too early delivered order lines (PO > Inbound)"
    group_label: "PO >> Inbound | On Time"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_matched_purchase_order_specifc: "too_early"]
    value_format_name: decimal_0
  }

  measure: pct_po_inbounded_items_too_early {
    label: "% Too Early Delivery (PO > Inbound)"
    description: "Share of too early delivered order lines (PO > Inbound) compared to all order lines"
    group_label: "PO >> Inbound | On Time"

    type: number
    sql: safe_divide(${cnt_po_inbounded_items_too_early}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_days_po_inbounded_items_too_early {
    label: "AVG Days Too Early Delivery (PO > Inbound)"
    description: "Average number of days order lines have been delivered early (PO > Inbound) per early delivered ordered lines"
    group_label: "PO >> Inbound | On Time"

    type: average
    sql: ${number_of_days_inbounded_too_early_purchase_order};;
    value_format_name: decimal_1
  }

  measure: cnt_po_inbounded_items_too_late {
    label: "# Too Late Delivery (PO > Inbound)"
    description: "Number of too late delivered order lines (PO > Inbound)"
    group_label: "PO >> Inbound | On Time"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_matched_purchase_order_specifc: "too_late"]
  value_format_name: decimal_0
  }

  measure: pct_po_inbounded_items_too_late {
    label: "% Too Late Delivery (PO > Inbound)"
    description: "Share of too late delivered order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | On Time"

    type: number
    sql: safe_divide(${cnt_po_inbounded_items_too_late}, ${cnt_ordered_items_puchase_order});;
    value_format_name: percent_0
  }

  measure: avg_days_po_inbounded_items_too_late {
    label: "AVG Days Too Late Delivery (PO > Inbound)"
    description: "Average number of days order lines have been delivered late (PO > Inbound) per late delivered ordered lines"
    group_label: "PO >> Inbound | On Time"

    type: average
    sql: ${number_of_days_inbounded_too_late_purchase_order};;
    value_format_name: decimal_1
  }



  # ----------------     In Full    ----------------
  measure: cnt_po_inbounded_in_full {
    label: "# In Full delivery (PO > Inbound)"
    description: "Number of in full delivered order lines (PO > Inbound)"
    group_label: "PO >> Inbound | In Full"

    type: count_distinct
    sql: ${purchase_order_order_lineitems};;
    filters: [is_purchase_order_inbounded_in_full: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_inbounded_in_full {
    label: "% In Full strict (PO > Inbound)"
    description: "Share of in full delivered order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | In Full"

    type: number
    sql: safe_divide(${cnt_po_inbounded_in_full}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: cnt_po_inbounded_in_full_lim {
    label: "# In Full delivery lim. (PO > Inbound)"
    description: "Number of in full delivered order lines (PO > Inbound), where an overdelivery counts as an in full delivery"
    group_label: "PO >> Inbound | In Full"

    type: count_distinct
    sql: ${purchase_order_order_lineitems};;
    filters: [is_purchase_order_inbounded_in_full_limited: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_inbounded_in_full_lim {
    label: "% In Full strict lim. (PO > Inbound)"
    description: "Share of in full delivered order lines (PO > Inbound) compared to all order lines, where an overdelivery counts as an in full delivery"
    group_label: "PO >> Inbound | In Full"

    type: number
    sql: safe_divide(${cnt_po_inbounded_in_full_lim}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: sum_po_quantity_inbounded {
    label: "# Filled Quantity (PO > Inbound)"
    description: "Total amount of fullfilled quantities (PO > Inbound)"
    group_label: "PO >> Inbound | In Full"

    type: sum
    sql: ${inbounded_quantity};;
    filters: [is_purchase_order_row_exists: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_fill_rate {
    label: "% In Full relaxed (PO > Inbound)"
    description: "Relative amount of fullfilled quantities (PO > Inbound) compared to overall ordered quantities "
    group_label: "PO >> Inbound | In Full"

    type: number
    sql: safe_divide(${sum_po_quantity_inbounded} , ${sum_ordered_items_quantity_po});;
    value_format_name: percent_0
  }

  measure: sum_po_quantity_inbounded_lim {
    label: "# Filled Quantity lim. (PO > Inbound)"
    description: "Total amount of fullfilled quantities (PO > Inbound), where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> Inbound | In Full"

    type: sum
    sql:
        -- limit the inbounded quantity to be at max as high as the selling units on the purchase order
        if(
          ${inbounded_quantity} > ${total_quantity_purchase_order},
          ${total_quantity_purchase_order},
          ${inbounded_quantity}
        );;
    filters: [is_purchase_order_row_exists: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_fill_rate_lim {
    label: "% In Full relaxed lim. (PO > Inbound)"
    description: "Relative amount of fullfilled quantities (PO > Inbound) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> Inbound | In Full"

    type: number
    sql: safe_divide(${sum_po_quantity_inbounded_lim}, ${sum_ordered_items_quantity_po});;
    value_format_name: percent_0
  }

  measure: cnt_po_inbounded_overdelivery {
    label: "# Overdelivered order lines (PO > Inbound)"
    description: "Number of overdelivered order lines (PO > Inbound)"
    group_label: "PO >> Inbound | In Full"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_purchase_order_inbounded_overdelivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_inbounded_overdelivery {
    label: "% Overdelivered order lines (PO > Inbound)"
    description: "Share of overdelivered order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | In Full"

    type: number
    sql: safe_divide(${cnt_po_inbounded_overdelivery}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_po_inbounded_quantity_overdelivery {
    label: "AVG Overdelivered quantity (PO > Inbound)"
    description: "Average of overdelivered quantity (PO > Inbound) per overdelivered order line"
    group_label: "PO >> Inbound | In Full"

    type: average
    sql: (${inbounded_quantity} - ${total_quantity_purchase_order}) ;;
    filters: [is_purchase_order_inbounded_overdelivery: "yes"]
    value_format_name: decimal_1
  }

  measure: cnt_po_inbounded_underdelivery {
    label: "# Underdelivered order lines (PO > Inbound)"
    description: "Number of underdelivered order lines (PO > Inbound)"
    group_label: "PO >> Inbound | In Full"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_purchase_order_inbounded_underdelivery: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_inbounded_underdelivery {
    label: "% Underdelivered order lines (PO > Inbound)"
    description: "Share of underdelivered order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | In Full"

    type: number
    sql: safe_divide(${cnt_po_inbounded_underdelivery}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: avg_po_inbounded_quantity_underdelivery {
    label: "AVG Underdelivered quantity (PO > Inbound)"
    description: "Average of underdelivered quantity (PO > Inbound) per underdelivered order line"
    group_label: "PO >> Inbound | In Full"

    type: average
    sql: (${total_quantity_purchase_order} - ${inbounded_quantity}) ;;
    filters: [is_purchase_order_inbounded_underdelivery: "yes"]
    value_format_name: decimal_1
  }

  # ----------------   OTIF   ----------------

  measure: sum_po_otif_relaxed {
    label: "# OTIF relaxed quantity (PO > Inbound)"
    description: "Total amount of on time fulfilled quantities (PO > Inbound)"
    group_label: "PO >> Inbound | OTIF"

    type: sum
    sql: ${inbounded_quantity} ;;
    filters: [is_purchase_order_row_exists: "yes",
              is_matched_purchase_order_specifc: "same_day"]
    value_format_name: decimal_0
  }

  measure: pct_po_otif_relaxed {
    label: "% OTIF relaxed quantity (PO > Inbound)"
    description: "Relative amount of on time fulfilled quantities (PO > Inbound) compared to overall ordered quantities "
    group_label: "PO >> Inbound | OTIF"

    type: number
    sql: safe_divide(${sum_po_otif_relaxed}, ${sum_ordered_items_quantity_po});;
    value_format_name: percent_0
  }

  measure: sum_po_otif_relaxed_limited {
    label: "# OTIF relaxed quantity lim. (PO > Inbound)"
    description: "Total amount of on time fulfilled quantities (PO > Inbound), where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> Inbound | OTIF"

    type: sum
    sql: if(
              ${inbounded_quantity} > ${total_quantity_purchase_order}
            , ${total_quantity_purchase_order}
            , ${inbounded_quantity}
            );;
    filters: [is_purchase_order_row_exists: "yes",
              is_matched_purchase_order_specifc: "same_day"]
    value_format_name: decimal_0
  }

  measure: pct_po_otif_relaxed_limited {
    label: "% OTIF relaxed quantity lim. (PO > Inbound)"
    description: "Relative amount of on time fulfilled quantities (PO > Inbound) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> Inbound | OTIF"

    type: number
    sql: safe_divide(${sum_po_otif_relaxed_limited}, ${sum_ordered_items_quantity_po});;
    value_format_name: percent_0
  }

  measure: cnt_po_otif_strict {
    label: "# OTIF strict (PO > Inbound)"
    description: "Number of on time, in full order lines (PO > Inbound)"
    group_label: "PO >> Inbound | OTIF"

    type: count_distinct
    sql: ${purchase_order_order_lineitems};;
    filters: [is_matched_purchase_order_specifc: "same_day",
              is_purchase_order_inbounded_in_full: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_otif_strict {
    label: "% OTIF strict (PO > Inbound)"
    description: "Share of on time, in full order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | OTIF"

    type: number
    sql: safe_divide(${cnt_po_otif_strict}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: cnt_po_otif_strict_limited {
    label: "# OTIF strict lim. (PO > Inbound)"
    description: "Number of on time, in full order lines (PO > Inbound), where an overdelivery counts as an in full delivery"
    group_label: "PO >> Inbound | OTIF"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_matched_purchase_order_specifc: "same_day",
              is_purchase_order_inbounded_in_full_limited: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_otifiq_strict_limited {
    label: "% OTIF strict lim. (PO > Inbound)"
    description: "Share of on time, in full order lines (PO > Inbound) compared to all order lines, where an overdelivery counts as an in full delivery"
    group_label: "PO >> Inbound | OTIF"

    type: number
    sql: safe_divide(${cnt_po_otif_strict_limited}, ${cnt_ordered_items_puchase_order});;
    value_format_name: percent_0
  }


  # ----------------     IQ & OTIFIQ    ----------------
  measure: sum_po_items_inbounded_in_quality {
    label: "# In Quality (PO > Inbound)"
    description: "Number of in quality delivered order lines (PO > Inbound)"
    group_label: "PO >> Inbound | In Quality"

    type: sum
    sql: ${inbounded_quantity} ;;
    filters: [is_purchase_order_row_exists: "yes",
              is_quality_issue: "no"]
    value_format_name: decimal_0
  }

  measure:  pct_po_items_inbounded_in_quality {
    label: "% In Quality (PO > Inbound)"
    description: "Share of in quality delivered order lines (PO > Inbound) compared to all inbounded order lines"
    group_label: "PO >> Inbound | In Quality"

    type: number
    sql: safe_divide(${sum_po_items_inbounded_in_quality}, ${sum_po_quantity_inbounded}) ;;
    value_format_name: percent_0
  }

  measure: sum_po_otifiq_relaxed {
    label: "# OTIFIQ relaxed quantity (PO > Inbound)"
    description: "Total amount of on time and in quality fulfilled quantities (PO > Inbound)"
    group_label: "PO >> Inbound | OTIFIQ"

    type: sum
    sql: ${inbounded_quantity} ;;
    filters: [is_purchase_order_row_exists: "yes",
              is_quality_issue: "no",
              is_matched_purchase_order_specifc: "same_day"]
    value_format_name: decimal_0
  }

  measure: pct_po_otifiq_relaxed {
    label: "% OTIFIQ relaxed quantity (PO > Inbound)"
    description: "Relative amount of on time and in quality fulfilled quantities (PO > Inbound) compared to overall ordered quantities "
    group_label: "PO >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${sum_po_otifiq_relaxed}, ${sum_ordered_items_quantity_po});;
    value_format_name: percent_0
  }

  measure: sum_po_otifiq_relaxed_limited {
    label: "# OTIFIQ relaxed quantity lim. (PO > Inbound)"
    description: "Total amount of on time and in quality fulfilled quantities (PO > Inbound), where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> Inbound | OTIFIQ"

    type: sum
    sql: if(
              ${inbounded_quantity} > ${total_quantity_purchase_order}
            , ${total_quantity_purchase_order}
            , ${inbounded_quantity}
            );;
    filters: [is_purchase_order_row_exists: "yes",
      is_quality_issue: "no",
      is_matched_purchase_order_specifc: "same_day"]
    value_format_name: decimal_0
  }

  measure: pct_po_otifiq_relaxed_limited {
    label: "% OTIFIQ relaxed quantity lim. (PO > Inbound)"
    description: "Relative amount of on time and in quality fulfilled quantities (PO > Inbound) compared to overall ordered quantities, where an overdelivered quantity is limited to the PO quantity"
    group_label: "PO >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${sum_po_otifiq_relaxed_limited}, ${sum_ordered_items_quantity_po});;
    value_format_name: percent_0
  }

  measure: cnt_po_otifiq_stric {
    label: "# OTIFIQ strict (PO > Inbound)"
    description: "Number of on time, in full and in quality order lines (PO > Inbound)"
    group_label: "PO >> Inbound | OTIFIQ"

    type: count_distinct
    sql: ${purchase_order_order_lineitems};;
    filters: [is_quality_issue: "no",
               is_matched_purchase_order_specifc: "same_day",
              is_purchase_order_inbounded_in_full: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_otifiq_stric {
    label: "% OTIFIQ strict (PO > Inbound)"
    description: "Share of on time, in full and in quality order lines (PO > Inbound) compared to all order lines "
    group_label: "PO >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${cnt_po_otifiq_stric}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: cnt_po_otifiq_stric_limited {
    label: "# OTIFIQ strict lim. (PO > Inbound)"
    description: "Number of on time, in full and in quality order lines (PO > Inbound), where an overdelivery counts as an in full delivery"
    group_label: "PO >> Inbound | OTIFIQ"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_quality_issue: "no",
              is_matched_purchase_order_specifc: "same_day",
              is_purchase_order_inbounded_in_full_limited: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_otifiq_stric_limited {
    label: "% OTIFIQ strict lim. (PO > Inbound)"
    description: "Share of on time, in full and in quality order lines (PO > Inbound) compared to all order lines, where an overdelivery counts as an in full delivery"
    group_label: "PO >> Inbound | OTIFIQ"

    type: number
    sql: safe_divide(${cnt_po_otifiq_stric_limited}, ${cnt_ordered_items_puchase_order});;
    value_format_name: percent_0
  }


  # ----------------     Not-Fulfilled or Unplanned    ----------------
  measure: cnt_po_ordered_items_unfulfilled {
    label: "# Not fulfilled POs (PO > Inbound)"
    description: "Number of not fulfilled order lines (PO > Inbound)"
    group_label: "PO >> Inbound | Unplanned or Not Fulfilled"

    type: count_distinct
    sql: ${purchase_order_order_lineitems} ;;
    filters: [is_purchase_order_unfulfilled: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_ordered_items_unfulfilled {
    label: "% Not fulfilled POs (PO > Inbound)"
    description: "Share of not fulfilled order lines (PO > Inbound) compared to all order lines"
    group_label: "PO >> Inbound | Unplanned or Not Fulfilled"

    type: number
    sql: safe_divide(${cnt_po_ordered_items_unfulfilled}, ${cnt_ordered_items_puchase_order}) ;;
    value_format_name: percent_0
  }

  measure: cnt_po_items_unplanned {
    label: "# Unplanned inbound (PO > Inbound)"
    description: "Number of unplanned inbound lines (PO > Inbound)"
    group_label: "PO >> Inbound | Unplanned or Not Fulfilled"

    type: count_distinct
    sql: ${table_uuid} ;;
    filters: [is_unplanned_inbound: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_items_unplanned {
    label: "% Unplanned inbound (PO > Inbound)"
    description: "Share of unplanned inbound lines (PO > Inbound) compared to all inbound lines"
    group_label: "PO >> Inbound | Unplanned or Not Fulfilled"

    type: number
    sql: safe_divide(${cnt_po_items_unplanned}, ${cnt_items_inbounded});;
    value_format_name: percent_0
  }

  measure: sum_po_items_quantity_unplanned {
    label: "# Unplanned inbound quantity (PO > Inbound)"
    description: "Total amount of unplanned inbounded quantities (PO > Inbound)"
    group_label: "PO >> Inbound | Unplanned or Not Fulfilled"

    type: sum
    sql: ${inbounded_quantity};;
    filters: [is_unplanned_inbound: "yes"]
    value_format_name: decimal_0
  }

  measure: pct_po_items_quantity_unplanned {
    label: "% Unplanned inbound quantity (PO > Inbound)"
    description: "Relative amount of unplanned inbounded quantities (PO > Inbound) compared to all inbounded quantities"
    group_label: "PO >> Inbound | Unplanned or Not Fulfilled"

    type: number
    sql: safe_divide(${sum_po_items_quantity_unplanned},${sum_items_inbounded}) ;;
    value_format_name: percent_0
  }




  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -  Inbound Related
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  measure: sum_inbound_delivery_damaged {
    label: "# Damaged quantity"
    description: "Total amount of inbounded damaged quantities"
    group_label: "Inbound related"

    type: sum
    sql: ${number_of_delivery_damaged_quality_issues} ;;
    value_format_name: decimal_0
  }

  measure: pct_inbound_delivery_damaged {
    label: "% Damaged quantity"
    description: "Relative amount of inbounded damaged quantities compared to all inbounded quantities "
    group_label: "Inbound related"

    type: number
    sql: safe_divide(${sum_inbound_delivery_damaged}, ${sum_items_inbounded}) ;;
    value_format_name: percent_0
  }

  measure: sum_inbound_delivery_expired {
    label: "# Expired quantity"
    description: "Relative amount of inbounded expired quantities"
    group_label: "Inbound related"

    type: sum
    sql: ${number_of_delivery_expired_quality_issues} ;;
    value_format_name: decimal_0
  }

  measure: pct_inbound_delivery_expired {
    label: "% Expired quantity"
    description: "Relative amount of inbounded expired quantities compared to all inbounded quantities"
    group_label: "Inbound related"

    type: number
    sql: safe_divide(${sum_inbound_delivery_expired}, ${sum_items_inbounded}) ;;
    value_format_name: percent_0
  }

}
