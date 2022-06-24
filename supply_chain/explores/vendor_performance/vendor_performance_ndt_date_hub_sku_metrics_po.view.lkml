# This table is based on the vendor_performance explore
# It is intended to calculate some metrics, that can not be calculated through the existing joins, as we faced data errors due to many to many
# ... relationships between the views, that can not be solved on the DIMENSION level (they can be solved on the MEASURE level)

# Thus this table aggregates on the common granularity of date, hub and sku and aggregates the metrics of interest beforehand, so that they resemble their intended DIMENSIONAL value
# Also this NDT table CAN NOT contain data from inventory_changes_daily, bulk_items and purchase_orders at the same time, as so due to the different many-to-x relationships,
# ... the values per hub-date-sku do not match their original values
# thus there is 1 version for DESADV, 1 version for Purchase Orders


include: "vendor_performance.explore.lkml"

view: vendor_performance_ndt_date_hub_sku_metrics_po {
  derived_table: {
    explore_source: vendor_performance {
      # joining fields
      column: report_date                                   { field: products_hub_assignment.report_date }
      column: hub_code                                      { field: products_hub_assignment.hub_code }
      column: leading_sku_replenishment_substitute_group    { field: products_hub_assignment.leading_sku_replenishment_substitute_group }
      # measures
      column: inbound_quantity      { field: inventory_changes_daily.sum_inbound_inventory }
      column: po_quantity           { field: purchase_orders.sum_selling_unit_quantity }

      bind_all_filters: yes
    }
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(${report_date}, ${hub_code}, ${leading_sku_replenishment_substitute_group}) ;;
  }
  dimension: report_date {hidden: yes type:date}
  dimension: hub_code    {hidden: yes}
  dimension: leading_sku_replenishment_substitute_group {hidden: yes}

  dimension: inbound_quantity {
    label: "# Inbound Inventory"
    type: number
    hidden: yes
  }
  dimension: po_quantity {
    label: "# Quantity Selling Units (PO)"
    type: number
    hidden: yes
  }

  dimension: is_over_inbound_po {
    type: yesno
    hidden: yes
    sql:
           ${po_quantity} is not null
      and  ${inbound_quantity} is not null
      and ${inbound_quantity} > ${po_quantity}
    ;;
  }

  dimension: is_unplanned_inbound_po {
    type: yesno
    hidden: yes
    sql:
          (${po_quantity} is null or ${po_quantity} = 0)
      and ${inbound_quantity} > 0
    ;;
  }

  dimension: is_completely_inbounded {
    type: yesno
    hidden: yes
    sql:
           ${po_quantity} > 0
      and  ${inbound_quantity} > 0
      and ${inbound_quantity} >= ${po_quantity}
    ;;
  }

  dimension: is_delivered_but_desadv_zero {
    hidden: yes
    label: "Is Inbounded but 0 PO Selling Units"
    type: yesno

    sql:

          ${po_quantity} = 0
      and ${inbound_quantity} > 0
      and ${inbound_quantity} >= ${po_quantity}
    ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    PO metrics

  measure: sum_po_quantity {
    hidden: yes
    type: sum
    sql: ${po_quantity} ;;
  }

  measure: sum_inbound_quantity {
    hidden: yes
    type: sum
    sql: ${inbound_quantity} ;;
  }

  measure: sum_over_inbound_items_po {

    label:       "# Over-Inbounded Items (PO)"
    description: "The sum of item quantities, that are higher than their related quantity on the purchase order"

    type: sum
    value_format_name: decimal_0
    sql: (${inbound_quantity} - ${po_quantity}) ;;
    filters: [is_over_inbound_po: "yes"]
  }

  measure: pct_over_inbounded_items_po {

    label:       "% Over-Inbounded Items (PO)"
    description: "The sum of item quantities, that are higher than their related quantity on the purchase order compared to all item quantities on the purchase order"

    type: number
    sql: safe_divide(${sum_over_inbound_items_po}, ${sum_po_quantity}) ;;
    value_format_name: percent_1
  }


  measure: sum_unplanned_inbounds_po {

    label:       "# Unplanned Items (vs. PO)"
    description: "The sum of item quantities, that are inbounded, but are not listed on a related purchase order"

    type: sum
    value_format_name: decimal_0
    sql: ${inbound_quantity} ;;
    filters: [is_unplanned_inbound_po: "yes"]

  }

  measure: pct_unplanned_inbounds_po {

    label:       "% Unplanned Items (vs. PO)"
    description: "The sum of item quantities, that are inbounded, but are not listed on a related purchase order compared to all item quantities on a purchase order"

    type: number
    value_format_name: percent_1
    sql: safe_divide(${sum_unplanned_inbounds_po}, ${sum_inbound_quantity}) ;;

  }

  # based on Peters comment in JIRA: https://goflink.atlassian.net/browse/DATA-2691?focusedCommentId=68836
  # to handle issues where we falsely calculate the fill-rates (e.g. Banaas as item with highest quantity - delivered 100 bananas and the hub can decided to
  # ... either inbound the bananas as pieces of 1 or as bundles of 5 )
  measure: cnt_skus_in_po {
    hidden: yes
    type: count_distinct
    sql:  ${leading_sku_replenishment_substitute_group};;
  }

  measure: cnt_skus_in_po_fully_inbounded {
    hidden: yes
    type: count_distinct
    filters: [is_completely_inbounded: "yes"]
    sql: ${leading_sku_replenishment_substitute_group};;
  }

  measure: pct_skus_fully_inbounded {

    label:       "% SKUs In Full (PO)"
    description: "This metrics compared the total number of products listed on a purchase order (PO) with all those products that are fully inbounded (>> how many SKU have been fully inbounded from a PO). "

    type: number
    sql: safe_divide(${cnt_skus_in_po_fully_inbounded}, ${cnt_skus_in_po}) ;;
    value_format_name: percent_1
  }



}
