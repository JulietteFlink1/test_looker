# If necessary, uncomment the line below to include explore_source.
# include: "vendor_performance.explore.lkml"

view: vendor_performance_ndt_po_fill_rate {
  derived_table: {
    explore_source: vendor_performance {

      column: order_number           { field: purchase_orders.order_number }
      column: sum_total_quantity     { field: purchase_orders.sum_selling_unit_quantity }
      column: sum_inbound_inventory  { field: inventory_changes_daily.sum_inbound_inventory }

      bind_all_filters: yes

    }
  }
  dimension: order_number {
    description: "Order Number"
    hidden: yes
    primary_key: yes
  }


  dimension: sum_total_quantity {
    type: number
    hidden: yes
  }

  dimension: sum_inbound_inventory {
    type: number
    hidden: yes
  }


  dimension: po_fill_rate  {

    label:       "% PO inbounded (per PO)"
    description: "The percent of selling unitson a purchase order that are actually been inbounded"

    sql: safe_divide(${sum_inbound_inventory}, ${sum_total_quantity}) ;;
    type: number

    value_format_name: percent_1
    hidden: yes
  }

  dimension: is_po_inbounded_po_corrected {

    label:       "Inbound Status (PO)"
    description: "This field classifies purchase orders in how much of their selling units are actually inbounded"

    sql: case
            when ${po_fill_rate} > 0.8
            then '1) booked in'

      when ${po_fill_rate} > 0.25 and ${po_fill_rate} <= 0.8
      then '2) less than 80% booked in'

      when ${po_fill_rate} > 0 and ${po_fill_rate} <= 0.25
      then '3) less than 25% booked in'

      else '4) not booked in'

      end
      ;;
    type: string
  }

  dimension: is_po_delivered_on_day {
    type: yesno
    sql: ${is_po_inbounded_po_corrected} != '4) not booked in' ;;
    hidden: yes
  }

  measure: sum_number_of_inbounded_po_on_day {

    label:       "# PO Inbounded on Promised Delivery Date"
    description: "the number of purchase orders, that have been inbounded on their (estimaed) delivery date"
    group_label: "PO aggregated"

    type: count_distinct
    sql: ${order_number} ;;
    filters: [is_po_delivered_on_day: "yes"]

    value_format_name: decimal_0
    hidden: yes
  }

  measure: sum_number_of_po {
    hidden: yes
    type: count_distinct
    sql: ${order_number} ;;
  }

  measure: pct_po_inbounded_on_day {

    label: "% Orders Delivered on Planned Day (PO)"
    description: "The percentage of purchase orders, that have actually been delivered on the promised delivery date"

    type: number
    sql: safe_divide(${sum_number_of_inbounded_po_on_day}, ${sum_number_of_po}) ;;

    value_format_name: percent_1

    html:
    {% if global_filters_and_parameters.show_info._parameter_value == 'yes' %}
    {{ rendered_value }} ({{ sum_number_of_po._rendered_value }} orders)
    {% else %}
    {{ rendered_value }}
    {% endif %}
    ;;

  }

}
