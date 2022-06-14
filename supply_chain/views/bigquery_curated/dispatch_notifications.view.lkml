view: dispatch_notifications {
  sql_table_name: `flink-data-prod.curated.dispatch_notifications`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set: main_fields {
    fields: [
      dispatch_notification_id,
      # dispatch_advice_number,
      external_sku,
      sscc,
      country_iso,
      city,
      hub_code,
      sku,
      delivery_date,
      loaded_in_truck_timestamp_time,
      loaded_in_truck_timestamp_date,
      order_number,
      product_name,
      sku,
      provider_name,
      sum_handling_units_count,
      sum_total_quantity,
      # sum_total_quantity_po_derived,
    ]
  }

  set: cross_referenced_fields {
    fields: [
      pct_items_inbounded,
      pct_items_inbounded_capped,
      pct_items_inbounded_or_pos_corrected
    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: provider_name {

    label:       "Supplier Name"
    description: "The name of the supplier (accoridng to bulk-inbounding service)"

    type: string
    sql: ${TABLE}.supplier_name ;;

  }

  dimension: provider_id {

    label:        "External Supplier ID"
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.supplier_id ;;
    hidden: yes
  }


  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }



  # =========  Dates & Timestamps   =========
  dimension: delivery_date {

    label:       "Delivery Date"
    description: "The date, when we was Flink think the delivery will arrive based on the Load-On-Truck Date:
    If the Load-On-Truck-Date is before 8 p.m. local time, then we assume the delivery date to be the same as the Load-On-Truck-Date.
    If the Load-On-Truck-Date is after 8 p.m. local time, we assume the delivery to arrive 1 day after the Load-On-Truck-Date"
    group_label: ">> Dates & Timestamps"
    type: date
    datatype: date
    sql: ${TABLE}.delivery_date ;;
  }

  dimension: estimated_delivery_timestamp {

    label:       "Estimated Delivery Time"
    description: "Based on the Delivery Date, the Estimated Delivery Time considers the time as the delivery time, whenever firstly 2% of the DESADV have been inbounded in the hub.
    This rule is covered by the 100% inbounding initiative, that should ensure, all vendor delivery are inbounded immediately and all on the same day as the delivery"
    datatype: timestamp
    sql: ${TABLE}.estimated_delivery_timestamp ;;
  }


  # dimension_group: loaded_in_truck {
  #   type: time
  #   timeframes: [
  #     raw,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   convert_tz: no
  #   datatype: date
  #   sql: ${TABLE}.loaded_in_truck_date ;;
  # }

  dimension_group: loaded_in_truck_timestamp {

    label: "Loaded On Truck"
    group_label: ">> Dates & Timestamps"

    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.loaded_in_truck_timestamp ;;
  }









  # =========  IDs   =========
  dimension: dispatch_notification_id {
    label:       "Dispatch Notification ID"
    description: "The identifier of a delivery. A delivery may contain items from different orders"
    group_label: ">> IDs"
    type: string
    sql: ${TABLE}.dispatch_notification_id ;;
  }

  dimension: sscc {
    label:       "SSCC"
    description: "The identifier of a delivery unit (of a Rolli)"
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.sscc ;;
  }

  dimension: order_number {
    label:       "Order Number"
    description: "The identifier of a order. In this context, the order number defines, to which specific order a product which is part of a delivery (DESADV) belongs to."
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: external_sku {

    label:       "External SKU"
    description: "The identifier of a product based on the specifications of a vendor."
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.external_sku ;;
  }

  dimension: bulk_items_id {

    label:       "Bulk Item ID"
    description: "The identifier of a product within a delivery. Given there is the same product (same SKU) multiple times listed on the DESADV, the bulk item id is the unique identifier of a SKU."
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.bulk_items_id ;;
  }

  dimension: warehouse_number {

    label:       "Warehouse Number"
    description: "The identifier of a vendors warehouse."
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.warehouse_number ;;
  }

  dimension: table_uuid {
    group_label: ">> IDs"

    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: delivery_party_id {
    group_label: ">> IDs"
    type: string
    hidden: yes
    sql: ${TABLE}.delivery_party_id ;;
  }


  # =========  hidden   =========
  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
    hidden: yes
  }

  dimension: quantity_per_handling_unit {
    type: number
    sql: ${TABLE}.quantity_per_handling_unit ;;
    hidden: yes
  }

  dimension: total_quantity {
    type: number
    sql: ${TABLE}.total_quantity ;;
    hidden: yes
  }

  dimension: handling_units_count {
    type: number
    sql: ${TABLE}.handling_units_count ;;
    hidden: yes
  }

  dimension: number_of_bulks_per_dispatch_notification {
    type: number
    sql: ${TABLE}.number_of_bulks_per_dispatch_notification ;;
    hidden: yes
  }

  dimension: purchase_quantity_per_dispatch_notification {
    type: number
    sql: ${TABLE}.purchase_quantity_per_dispatch_notification ;;
    hidden: yes
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: sum_handling_units_count {

    label:       "# Handling Units"
    description: "THe sum of handling units for items defined per dispatch notification"

    type: sum
    sql: ${handling_units_count} ;;

    value_format_name: decimal_0
  }

  measure: avg_number_of_bulks_per_dispatch_notification {

    label:       "AVG Bulks per dispatch notification"
    description: "This field defines, how many bulks were contained in a specific dispatch notification"
    group_label: "Special Use Cases"

    type: average
    sql: ${number_of_bulks_per_dispatch_notification} ;;

    value_format_name: decimal_0
  }

  measure: sum_total_quantity {

    label:       "# Selling Units"
    description: "The sum of all product quantities listed on the DESADV (selling units)"

    type: sum
    sql: ${total_quantity} ;;

    value_format_name: decimal_0
  }

  # measure: sum_total_quantity_po_derived {

  #   label:       "# Corrected Selling Units (PO)"
  #   description: "The sum of all purchase units from products as defined in the latest know Purchase Order. This measure was introduced, due to some parsing problems for certain SKUs in DESADVS, that eventually had incorrect selling units stated (e.g. 1 Banana per DESADV)"

  #   type: sum
  #   sql: ${total_quantity_po_derived};;

  #   value_format_name: decimal_0
  # }

  measure: sum_number_of_bulks {

    label:       "# Bulks"
    description: "The total number of bulks"
    group_label: "Special Use Cases"

    type: count_distinct
    sql: ${sscc} ;;

    value_format_name: decimal_0
  }

  # measure: sum_number_of_bulks_booked_in_same_day {

  #   label:       "# Bulks inbounded on delivery day"
  #   description: "The number of bulks, that were inbounded in the same they of the delivery (more precise: the day of the first inbounding of a bulk within a dispatch notification)"
  #   group_label: "Special Use Cases"

  #   type: count_distinct
  #   sql: ${sscc};;

  #   value_format_name: decimal_0
  # }

  # measure: pct_bulks_inbounded_same_day{

  #   label:       "% Bulks inbounded same day"
  #   description: "The number of bulks that are inbounded on the day of the first inbounding compared to all bulks of a dispatch notification"
  #   group_label: "Special Use Cases"

  #   type: number
  #   sql: safe_divide(${sum_number_of_bulks_booked_in_same_day}, ${sum_number_of_bulks}) ;;

  #   value_format_name: percent_1
  # }

  measure: sum_number_of_dispatch_notifications {

    label:       "# Dispatch Notifications"
    description: "The total number of dispatch notifications"
    group_label: "Special Use Cases"

    type: count_distinct
    sql: ${dispatch_notification_id} ;;

    value_format_name: decimal_0
  }


  # ------------------------------------------------
  # WARNING: Cross-referenced fields
  measure: pct_items_inbounded {

    label:       "% Fill Rate"
    description: "The sum of items that are listed on the DESADV (PO corrected) compared to the number of items, that have been inbounded on the delivery date"

    type: number
    value_format_name: percent_1
    sql: safe_divide(${inventory_changes_daily.sum_inbound_inventory}, ${sum_total_quantity}) ;;
  }

  measure: pct_items_inbounded_capped {

    label:       "% Delivery In Full"
    description: "The sum of items that are listed on the DESADV (PO corrected) compared to the number of items, that have been inbounded on the delivery date. This metric is capped to have at max a value of 100%"

    type: number
    value_format_name: percent_1
    sql:
      case
        when ${inventory_changes_daily.sum_inbound_inventory} > ${sum_total_quantity} -- when more inbouded then on DESADV
        then 1 -- then define as 100%
        else safe_divide(${inventory_changes_daily.sum_inbound_inventory}, ${sum_total_quantity})  -- else take the actual inbounded rate
      end

      ;;
  }

  measure: pct_items_inbounded_or_pos_corrected {

    label:       "% Inbound + pos. Corrected Rate"
    description: "The sum of items that are listed on the DESADV (PO corrected) compared to the number of items, that have been either inbounded or corrected with a positive amount (stock increase) on the delivery date"

    type: number
    value_format_name: percent_1
    sql: safe_divide((${inventory_changes_daily.sum_inbound_inventory} + ${inventory_changes_daily.sum_inventory_correction_increased}), ${sum_total_quantity}) ;;
  }














}
