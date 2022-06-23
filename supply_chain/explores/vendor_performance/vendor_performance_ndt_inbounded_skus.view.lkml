# If necessary, uncomment the line below to include explore_source.
include: "vendor_performance.explore.lkml"

view: vendor_performance_ndt_inbounded_skus {
  derived_table: {
    explore_source: vendor_performance {
      column: dispatch_notification_id { field: bulk_items.dispatch_notification_id }
      column: sku { field: bulk_items.sku }
      column: sum_inbound_inventory { field: inventory_changes.sum_inbound_inventory }
      column: max_inbounding_time { field: inventory_changes.max_inbounding_time }
      column: min_inbounding_time { field: inventory_changes.min_inbounding_time }

      derived_column: run_sum_inbound_inventory {
        sql: sum(sum_inbound_inventory) over (partition by dispatch_notification_id order by max_inbounding_time, sku) ;;
      }

      bind_all_filters: yes

      filters: {
        field: inventory_changes.is_inbound
        value: "Yes"
      }
    }
  }
  dimension: dispatch_notification_id {
    label: "* DESADVs * Dispatch Notification ID"
    description: "The identifier of a delivery. A delivery may contain items from different orders"
    hidden: yes
  }
  dimension: sku {
    label: "* DESADVs * SKU"
    description: ""
    hidden: yes
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(${dispatch_notification_id}, ${sku}) ;;
  }



  dimension: sum_inbound_inventory {
    label: "# Total Inbound Inventory (per DESADV & SKU)"
    description: "The sum of inventory changes based on restockings"
    group_label: "DESADV + SKU aggregated"
    value_format: "#,##0"

    type: number
  }
  dimension: max_inbounding_time {
    label: "MAX Inbound Time (per DESADV & SKU)"
    description: "The last timestamp, the SKU was inbounded given the dimension choosen in a Look"
    group_label: "DESADV + SKU aggregated"

    type: date_time
  }
  dimension: min_inbounding_time {
    label: "MIN Inbound Time (per DESADV & SKU)"
    description: "The first timestamp, the SKU was inbounded given the dimension choosen in a Look"
    group_label: "DESADV + SKU aggregated"

    type: date_time
  }

  dimension: run_sum_inbound_inventory {

    label: "RUN-SUM Inbound Inventory (per DESADV & SKU)"
    description: "This is a helper dimension. For every DESADV and SKU, calculate the running sum of inbounded SKUs based on the inbounding timestamp."
    group_label: "DESADV + SKU aggregated"

    type: number
    value_format_name: decimal_0

  }
}
