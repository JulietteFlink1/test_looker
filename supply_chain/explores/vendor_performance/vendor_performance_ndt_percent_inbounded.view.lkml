include: "vendor_performance.explore.lkml"

view: vendor_performance_ndt_percent_inbounded {

  derived_table: {
    explore_source: vendor_performance {
      column: dispatch_notification_id        { field: bulk_items.dispatch_notification_id }
      column: sku_desadv                      { field: bulk_items.sku }
      column: sum_total_quantity              { field: bulk_items.sum_total_quantity }
      column: estimated_delivery_timestamp    { field: bulk_items.estimated_delivery_timestamp }
      column: sum_inbound_inventory           { field: inventory_changes.sum_inbound_inventory }
      column: inventory_change_timestamp_time { field: inventory_changes.inventory_change_timestamp_time }
      column: sku_inventory                   { field: inventory_changes.sku }

      derived_column: total_selling_units_per_desadv {
        sql:
          sum(sum_total_quantity) over (partition by dispatch_notification_id)
        ;;
      }

      derived_column: run_sum_inbounded_units_per_desadv {
        sql:
          sum(sum_inbound_inventory) over (partition by dispatch_notification_id order by inventory_change_timestamp_time)
        ;;
      }

    }
  }

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension_group: delivery_to_inbound {

    type: duration
    intervals: [hour, minute]
    sql_start: timestamp(${estimated_delivery_timestamp}) ;;
    sql_end: timestamp(${inventory_change_timestamp_time});;
  }

  # =========  IDs   =========
  dimension: primary_key {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(${dispatch_notification_id}, ${sku_desadv}, ${sku_inventory}, ${inventory_change_timestamp_time}) ;;
  }

  dimension: dispatch_notification_id {
    label: "* DESADVs * Dispatch Notification ID"
    description: "The identifier of a delivery. A delivery may contain items from different orders"
    hidden: yes
  }

  dimension: sku_desadv {
    label: "* DESADVs * SKU"
    description: ""
    hidden: yes
  }

  dimension: sku_inventory {
    label: "* Inventory Changes * SKU"
    description: ""
    hidden: yes
  }


  # =========  hidden   =========
  dimension: sum_total_quantity {
    label: "* DESADVs * # Selling Units"
    description: "The sum of all product quantities listed on the DESADV (selling units)"
    value_format: "#,##0"
    type: number
    hidden: yes
  }

  dimension: estimated_delivery_timestamp {
    label: "* DESADVs * Estimated Delivery Time"
    description: "Based on the Delivery Date, the Estimated Delivery Time considers the time as the delivery time, whenever firstly 2% of the DESADV have been inbounded in the hub.
    This rule is covered by the 100% inbounding initiative, that should ensure, all vendor delivery are inbounded immediately and all on the same day as the delivery"
    type: string
    #datatype: timestamp
    hidden: yes
  }

  dimension: inventory_change_timestamp_time {
    label: "* Inventory Changes * Inventory Change Time"
    description: "The time, when a inventory change was recorded"
    type: string
    #datatype: timestamp
    hidden: yes
  }


  dimension: sum_inbound_inventory {
    label: "* Inventory Changes * # Inbound Inventory"
    description: "The sum of inventory changes based on restockings"
    value_format: "#,##0"
    type: number
    hidden: yes
  }

  dimension: total_selling_units_per_desadv {hidden:yes}

  dimension: run_sum_inbounded_units_per_desadv {hidden:yes}

  dimension: percent_inbounded {

    label: "% Inbounded per DESADV at inbounding time"
    group_label: "DESADV metrics"
    description: "This is a field, that calculates the percent of all SKUs of a DESADV compared with the running sum of related inbounded SKUs on their inbounding time"

    sql:  safe_divide(${run_sum_inbounded_units_per_desadv}, ${total_selling_units_per_desadv});;
    type: number
    value_format_name: percent_1

  }

  dimension: percent_inbounded_tiers {

    group_label: "DESADV aggregated"
    type: tier
    tiers: [0.5, 0.7, 0.8, 0.9, 1]
    sql: ${percent_inbounded} ;;
    hidden:yes
  }


  dimension: is_inbounded_within_first_2_hours {

    group_label: "DESADV metrics"

    type: yesno
    sql: if(${minutes_delivery_to_inbound} <= 120, true, false) ;;
  }

  dimension: is_inbounded_within_first_3_hours {

    group_label: "DESADV metrics"

    type: yesno
    sql: if(${minutes_delivery_to_inbound} <= 180, true, false) ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~














}
