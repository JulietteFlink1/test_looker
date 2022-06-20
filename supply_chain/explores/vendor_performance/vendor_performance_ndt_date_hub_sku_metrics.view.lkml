# This table is based on the vendor_performance explore
# It is intended to calculate some metrics, that can not be calculated through the existing joins, as we faced data errors due to many to many
# ... relationships between the views, that can not be solved on the DIMENSION level (they can be solved on the MEASURE level)

# Thus this table aggregates on the common granularity of date, hub and sku and aggregates the metrics of interest beforehand, so that they resemble their intended DIMENSIONAL value

# If necessary, uncomment the line below to include explore_source.
include: "vendor_performance.explore.lkml"

view: vendor_performance_ndt_date_hub_sku_metrics {
  derived_table: {
    explore_source: vendor_performance {
      # joining fields
      column: report_date               { field: products_hub_assignment.report_date }
      column: hub_code                  { field: products_hub_assignment.hub_code }
      column: sku                       { field: products_hub_assignment.sku }
      # measures
      column: inbound_quantity      { field: inventory_changes_daily.sum_inbound_inventory }
      column: po_quantity           { field: purchase_orders.sum_selling_unit_quantity }
      column: desadv_quantity       { field: bulk_items.sum_total_quantity }
      filters: {
        field: global_filters_and_parameters.datasource_filter
        value: "4 days ago for 4 days"
      }
    }
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(${report_date}, ${hub_code}, ${sku}) ;;
  }
  dimension: report_date {hidden: yes type:date}
  dimension: hub_code    {hidden: yes}
  dimension: sku {hidden: yes}

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
  dimension: desadv_quantity {
    label: "# Quantity Selling Units (DESADV)"
    type: number
    hidden: yes
  }

  dimension: is_over_inbound_desadv {
    type: yesno
    hidden: yes
    sql:
           ${desadv_quantity} is not null
      and  ${inbound_quantity} is not null
      and ${inbound_quantity} > ${desadv_quantity}
    ;;
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

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    DESADV metrics
  measure: sum_desadv_quantity {

    hidden: yes
    type: sum
    sql: ${desadv_quantity} ;;
  }

  measure: sum_over_inbound_items_desadv {

    label:       "# Over-Inbounded Items (DESADV)"
    description: "The sum of item quantities, that are higher than their related quantity on the dispatch notification"
    group_label: "Over-Inbound"

    type: sum
    value_format_name: decimal_0
    sql: (${inbound_quantity} - ${desadv_quantity}) ;;
    filters: [is_over_inbound_desadv: "yes"]
  }

  measure: pct_over_inbounded_items_desadv {

    label: "% Over-Inbounded Items (DESADV)"
    description: "The sum of item quantities, that are higher than their related quantity on the dispatch notification compared to all item quantities on the DESADV"
    group_label: "Over-Inbound"

    type: number
    sql: safe_divide(${sum_over_inbound_items_desadv}, ${sum_desadv_quantity}) ;;
    value_format_name: percent_1
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    PO metrics

  measure: sum_po_quantity {

    hidden: yes
    type: sum
    sql: ${po_quantity} ;;
  }

  measure: sum_over_inbound_items_po {

    label:       "# Over-Inbounded Items (PO)"
    description: "The sum of item quantities, that are higher than their related quantity on the purchase order"
    group_label: "Over-Inbound"

    type: sum
    value_format_name: decimal_0
    sql: (${inbound_quantity} - ${po_quantity}) ;;
    filters: [is_over_inbound_po: "yes"]
  }

  measure: pct_over_inbounded_items_po {

    label:       "% Over-Inbounded Items (PO)"
    description: "The sum of item quantities, that are higher than their related quantity on the purchase order compared to all item quantities on the purchase order"
    group_label: "Over-Inbound"

    type: number
    sql: safe_divide(${sum_over_inbound_items_po}, ${sum_desadv_quantity}) ;;
    value_format_name: percent_1
  }


  measure: sum_unplanned_inbounds_po {

    label:       "# Unplanned Items (vs. PO)"
    description: "The sum of item quantities, that are inbounded, but are not listed on a related purchase order"
    group_label: "Unplanned Inbound"

    type: sum
    value_format_name: decimal_0
    sql: ${inbound_quantity} ;;
    filters: [is_unplanned_inbound_po: "yes"]

  }

  measure: pct_unplanned_inbounds_po {

    label:       "% Unplanned Items (vs. PO)"
    description: "The sum of item quantities, that are inbounded, but are not listed on a related purchase order compared to all item quantities on a purchase order"
    group_label: "Unplanned Inbound"

    type: number
    value_format_name: percent_1
    sql: safe_divide(${sum_unplanned_inbounds_po}, ${sum_po_quantity}) ;;

  }


}
