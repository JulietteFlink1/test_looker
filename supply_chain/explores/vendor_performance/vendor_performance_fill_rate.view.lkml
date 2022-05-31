# If necessary, uncomment the line below to include explore_source.
# include: "vendor_performance.explore.lkml"

view: vendor_performance_fill_rate {
  derived_table: {
    explore_source: vendor_performance {

      column: dispatch_notification_id { field: bulk_items.dispatch_notification_id }
      column: sum_total_quantity       { field: bulk_items.sum_total_quantity }
      column: sum_inbound_inventory    { field: inventory_changes_daily.sum_inbound_inventory }

      filters: {
        field: bulk_items.product_name
        value: "-\"PFAND 0,25 EINWEGPFAND V-MWST\""
      }

      bind_all_filters: yes

    }
  }
  dimension: dispatch_notification_id {
    description: "Dispatch Notification ID"
    hidden: yes
    primary_key: yes
  }

  dimension: sum_total_quantity {

    label:       "SUM DESADV Selling Units"
    description: "The sum of all products (selling units)"
    group_label: "DESADV aggregated"

    value_format: "#,##0"
    type: number
  }

  dimension: sum_inbound_inventory {

    label: "SUM Inbounded DESADV Units"
    description: "The sum of inventory changes based on restockings"
    group_label: "DESADV aggregated"

    value_format: "#,##0"
    type: number
  }

  dimension: desadv_fill_rate  {

    label:       "% DESADV inbounded"
    description: "The percent of selling units of a dispatch notification, that are actually been inbounded"
    group_label: "DESADV aggregated"

    sql: safe_divide(${sum_inbound_inventory}, ${sum_total_quantity}) ;;
    type: number

    value_format_name: percent_1
  }

  dimension: is_desadv_inbounded {

    label:       "DESADV Inbounded Status"
    description: "This field classifies DESADVS in how much of their selling units are actually inbounded"
    group_label: "DESADV aggregated"

    sql: case
            when ${desadv_fill_rate} > 0.8
            then 'booked in'

            when ${desadv_fill_rate} > 0.25 and ${desadv_fill_rate} <= 0.8
            then 'less than 80% booked in'

            when ${desadv_fill_rate} <= 0.25
            then 'less than 25% booked in'
        end
    ;;
    type: string
  }

  measure: avg_desadv_fill_rate {

    label: "AVG DESADV Fill Rate"
    description: "This measure calculates the mean accross all DESADV fill rates"
    group_label: "DESADV aggregated"

    sql: ${desadv_fill_rate} ;;
    type: average
    value_format_name: percent_1
  }

}
