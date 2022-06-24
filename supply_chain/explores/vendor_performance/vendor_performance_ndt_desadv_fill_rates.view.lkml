# If necessary, uncomment the line below to include explore_source.
# include: "vendor_performance.explore.lkml"

view: vendor_performance_ndt_desadv_fill_rates {
  derived_table: {
    explore_source: vendor_performance {

      column: dispatch_notification_id      { field: bulk_items.dispatch_notification_id }
      column: sum_total_quantity            { field: bulk_items.sum_total_quantity }
      column: sum_inbound_inventory         { field: inventory_changes_daily.sum_inbound_inventory }

      bind_all_filters: yes

    }
  }
  dimension: dispatch_notification_id {
    description: "Dispatch Notification ID"
    hidden: yes
    primary_key: yes
  }


  dimension: sum_total_quantity {

    label:       "SUM Selling Units ((per DESADV))"
    description: "The sum of all products listed on the DESADV"
    group_label: "DESADV aggregated"

    value_format: "#,##0"
    type: number
    hidden: yes
  }

  dimension: sum_inbound_inventory {

    label: "SUM Inbounded DESADV Units (per DESADV)"
    description: "The sum of inventory changes based on restockings"
    group_label: "DESADV aggregated"

    value_format: "#,##0"
    type: number
    hidden: yes
  }


  dimension: desadv_fill_rate_po_corrected  {

    label:       "% DESADV inbounded (per DESADV)"
    description: "The percent of selling units (as defined in the latest purchase order of a given SKU in a given hub) of a dispatch notification that are actually been inbounded"
    group_label: "DESADV aggregated"

    sql: safe_divide(${sum_inbound_inventory}, ${sum_total_quantity}) ;;
    type: number

    value_format_name: percent_1
    hidden: yes
  }

  dimension: is_desadv_inbounded_po_corrected {

    label:       "Inbound Status (DESADV)"
    description: "This field classifies DESADVS in how much of their selling units (corrected to take selling units from values from latest purchase orders) are actually inbounded"

    sql: case
            when ${desadv_fill_rate_po_corrected} > 0.8
            then '1) booked in'

      when ${desadv_fill_rate_po_corrected} > 0.25 and ${desadv_fill_rate_po_corrected} <= 0.8
      then '2) less than 80% booked in'

      when ${desadv_fill_rate_po_corrected} <= 0.25
      then '3) less than 25% booked in'

      else '4) not booked in'

      end
      ;;
    type: string
  }

  dimension: is_desadv_delivered_on_day {
    type: yesno
    sql: ${is_desadv_inbounded_po_corrected} != '4) not booked in' ;;
    hidden: yes
  }

  measure: sum_number_of_inbounded_desadvs_on_day {

    label:       "# DESADV Inbounded on Estimated Delivery Date"
    description: "THe number of dispatch notifications, that have been inbounded on their (estimaed) delivery date"

    type: count_distinct
    sql: ${dispatch_notification_id} ;;
    filters: [is_desadv_delivered_on_day: "yes"]

    value_format_name: decimal_0
  }

  measure: sum_number_of_desadvs {
    hidden: yes
    type: count_distinct
    sql: ${dispatch_notification_id} ;;
  }

  measure: pct_desadvs_inbounded_on_day {

    label: "% Orders Delivered on Planned Day (DESADV)"
    description: "The percentage of dispatch notifications, that have actually been delivered on the estimated delivery date"

    type: number
    sql: safe_divide(${sum_number_of_inbounded_desadvs_on_day}, ${sum_number_of_desadvs}) ;;

    value_format_name: percent_1

  }

}
