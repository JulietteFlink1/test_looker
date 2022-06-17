# If necessary, uncomment the line below to include explore_source.
# include: "vendor_performance.explore.lkml"

view: vendor_performance_ndt_desadv_fill_rates {
  derived_table: {
    explore_source: vendor_performance {

      column: dispatch_notification_id      { field: bulk_items.dispatch_notification_id }
      column: sum_total_quantity            { field: bulk_items.sum_total_quantity }
      column: sum_inbound_inventory         { field: inventory_changes_daily.sum_inbound_inventory }

    }
  }
  dimension: dispatch_notification_id {
    description: "Dispatch Notification ID"
    hidden: yes
    primary_key: yes
  }


  dimension: sum_total_quantity {

    label:       "SUM Selling Units ((per DESADV))"
    description: "The sum of all products of the DESADV multiplied by the selling units derived from the latest purchase order containing the given SKU in a given hub"
    group_label: "DESADV aggregated"

    value_format: "#,##0"
    type: number
    hidden: no
  }

  dimension: sum_inbound_inventory {

    label: "SUM Inbounded DESADV Units (per DESADV)"
    description: "The sum of inventory changes based on restockings"
    group_label: "DESADV aggregated"

    value_format: "#,##0"
    type: number
    hidden: no
  }


  dimension: desadv_fill_rate_po_corrected  {

    label:       "% DESADV inbounded (per DESADV)"
    description: "The percent of selling units (as defined in the latest purchase order of a given SKU in a given hub) of a dispatch notification that are actually been inbounded"
    group_label: "DESADV aggregated"

    sql: safe_divide(${sum_inbound_inventory}, ${sum_total_quantity}) ;;
    type: number

    value_format_name: percent_1
    hidden: no
  }

  dimension: is_desadv_inbounded_po_corrected {

    label:       "DESADV Inbounded Status"
    description: "This field classifies DESADVS in how much of their selling units (corrected to take selling units from values from latest purchase orders) are actually inbounded"
    group_label: "DESADV aggregated"

    sql: case
            when ${desadv_fill_rate_po_corrected} > 0.8
            then 'booked in'

      when ${desadv_fill_rate_po_corrected} > 0.25 and ${desadv_fill_rate_po_corrected} <= 0.8
      then 'less than 80% booked in'

      when ${desadv_fill_rate_po_corrected} <= 0.25
      then 'less than 25% booked in'
      end
      ;;
    type: string
  }

}
