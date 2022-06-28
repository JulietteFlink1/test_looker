# This table is based on the vendor_performance explore
# It is intended to calculate some metrics, that can not be calculated through the existing joins, as we faced data errors due to many to many
# ... relationships between the views, that can not be solved on the DIMENSION level (they can be solved on the MEASURE level)

# Thus this table aggregates on the common granularity of date, hub and sku and aggregates the metrics of interest beforehand, so that they resemble their intended DIMENSIONAL value
# Also this NDT table CAN NOT contain data from inventory_changes_daily, bulk_items and purchase_orders at the same time, as so due to the different many-to-x relationships,
# ... the values per hub-date-sku do not match their original values
# thus there is 1 version for DESADV, 1 version for Purchase Orders


include: "vendor_performance.explore.lkml"

view: vendor_performance_ndt_date_hub_sku_metrics_desadv {
  derived_table: {
    explore_source: vendor_performance {
      # joining fields
      column: report_date                                   { field: products_hub_assignment.report_date }
      column: hub_code                                      { field: products_hub_assignment.hub_code }
      column: leading_sku_replenishment_substitute_group    { field: products_hub_assignment.leading_sku_replenishment_substitute_group }
      # measures
      column: inbound_quantity      { field: inventory_changes_daily.sum_inbound_inventory }
      column: desadv_quantity       { field: bulk_items.sum_total_quantity }

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

  dimension: is_completely_inbounded {
    type: yesno
    hidden: yes
    sql:

          ${desadv_quantity}  > 0
      and ${inbound_quantity} > 0
      and ${inbound_quantity} >= ${desadv_quantity}
    ;;
  }

  dimension: is_delivered_but_desadv_zero {

    label: "Is Inbounded but 0 DESADV Selling Units"
    type: yesno
    hidden: yes

    sql:

          ${desadv_quantity} = 0
      and ${inbound_quantity} > 0
      and ${inbound_quantity} >= ${desadv_quantity}
    ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    DESADV metrics
  measure: sum_desadv_quantity {

    hidden: yes
    type: sum
    sql: ${desadv_quantity} ;;
    group_label: "Over-Inbound (DESADV)"
  }

  measure: sum_inbound_quantity {

    hidden: yes
    type: sum
    sql: ${inbound_quantity} ;;
    group_label: "Over-Inbound (DESADV)"
  }



  measure: sum_over_inbound_items_desadv {

    label:       "# Over-Inbounded Items (DESADV)"
    description: "The sum of item quantities, that are higher than their related quantity on the dispatch notification"

    type: sum
    value_format_name: decimal_0
    sql: (${inbound_quantity} - ${desadv_quantity}) ;;
    filters: [is_over_inbound_desadv: "yes"]
  }

  measure: pct_over_inbounded_items_desadv {

    label: "% Over-Inbounded Items (DESADV)"
    description: "The sum of item quantities, that are higher than their related quantity on the dispatch notification compared to all item quantities on the DESADV"

    type: number
    sql: safe_divide(${sum_over_inbound_items_desadv}, ${sum_desadv_quantity}) ;;
    value_format_name: percent_1

    html:
    {% if global_filters_and_parameters.show_info._parameter_value == 'yes' %}
    {{ rendered_value }} ({{ sum_desadv_quantity._rendered_value }} listed items)
    {% else %}
    {{ rendered_value }}
    {% endif %}
    ;;
  }

  # based on Peters comment in JIRA: https://goflink.atlassian.net/browse/DATA-2691?focusedCommentId=68836
  # to handle issues where we falsely calculate the fill-rates (e.g. Banaas as item with highest quantity - delivered 100 bananas and the hub can decided to
  # ... either inbound the bananas as pieces of 1 or as bundles of 5 )
  measure: cnt_skus_in_desadv {
    hidden: yes
    type: count_distinct
    sql:  ${leading_sku_replenishment_substitute_group};;
  }

  measure: cnt_skus_in_desadv_fully_inbounded {
    hidden: yes
    type: count_distinct
    filters: [is_completely_inbounded: "yes"]
    sql: ${leading_sku_replenishment_substitute_group};;
  }

  measure: pct_skus_fully_inbounded {

    label:       "% SKUs In Full (DESADV)"
    description: "This metrics compared the total number of products listed on a dispatch notification (DESADV) with all those products that are fully inbounded (>> how many SKU have been fully inbounded from a DESADV). "

    type: number
    sql: safe_divide(${cnt_skus_in_desadv_fully_inbounded}, ${cnt_skus_in_desadv}) ;;
    value_format_name: percent_1
  }


}
