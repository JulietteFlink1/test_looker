
view: advanced_supplier_matching {
  sql_table_name: `flink-data-dev.dbt_astueber.advanced_supplier_matching`
    ;;

  dimension: bulk_items_id {
    type: string
    description: "This field refers to the distinct prodcuts on a delivery. Hereby, the same SKU can appear multiple times with different bulk items ids"
    sql: ${TABLE}.bulk_items_id ;;
  }

  dimension_group: delivery_date_desadv {
    type: time
    description: "The date when we expect to receive the delivery, either coming from DESADVs or PO."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivery_date_desadv ;;
  }

  dimension: delivery_party_id {
    type: string
    description: "The GLN number (see ERP) of the warehouse that the item will be delivered to"
    sql: ${TABLE}.delivery_party_id ;;
  }

  dimension: desadvs_uuid {
    type: string
    description: "DESADVs generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.desadvs_uuid ;;
  }

  dimension: dispatch_advice_number {
    type: string
    description: "The unique identifier of a dispatch notification (DESADV) as parsed from the EDI file provide by the supplier"
    sql: ${TABLE}.dispatch_advice_number ;;
  }

  dimension: dispatch_notification_id {
    type: string
    description: "The unique identifier of a dispatch notification (DESADV) as parsed from the EDI file provide by the supplier"
    sql: ${TABLE}.dispatch_notification_id ;;
  }

  dimension: edi {
    type: string
    description: "Transaction codes that correspond to information in business documents between Flink and Suppliers."
    sql: ${TABLE}.edi ;;
  }

  dimension_group: estimated_delivery_timestamp {
    type: time
    description: "This field refers to the DATA-internally calculated timestamp, when we think the delivery arrived at a hub.
    After matching a DESADV/PO and its delivery date with our internally observed inbounds, we define the delivery timestamp to be the one, when 2 % of the items listed on a DESADV/PO have been inbounded"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.estimated_delivery_timestamp ;;
  }

  dimension: external_sku {
    type: string
    description: "The unique identifier of a product, that is provided by the supplier"
    sql: ${TABLE}.external_sku ;;
  }

  dimension: flink_buyer_id {
    type: string
    sql: ${TABLE}.flink_buyer_id ;;
  }

  dimension: flink_hq_gln {
    type: string
    sql: ${TABLE}.flink_hq_gln ;;
  }

  dimension: handling_units_count {
    type: number
    description: "The field shows, how many handling units with products have been delivered to a hub. 1 handling unit contains N selling units. The N is defined in the field quantity_per_handling_unit"
    sql: ${TABLE}.handling_units_count ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: inbounded {
    type: time
    description: "The date when we actually inbounded the items based on the matching logic."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.inbounded_date ;;
  }

  dimension: inbounded_quantity {
    type: number
    description: "Quantity actually inbounded based on the matching logic."
    sql: ${TABLE}.inbounded_quantity ;;
  }

  dimension: internal_sku_array {
    hidden: yes
    sql: ${TABLE}.internal_sku_array ;;
  }

  dimension: is_double_parent_sku {
    type: yesno
    description: "This field indicates, if there are 2 or more parent_skus within the internal_sku_array, that is provided in the raw DESADV data"
    sql: ${TABLE}.is_double_parent_sku ;;
  }

  dimension: is_matched_on_same_date {
    type: yesno
    description: "Flag that indicates if it was inbounded on time"
    sql: ${TABLE}.is_matched_on_same_date ;;
  }

  dimension: is_matched_on_too_early_date {
    type: yesno
    description: "Flag that indicates if it was inbounded early and the units inbounded were the same"
    sql: ${TABLE}.is_matched_on_too_early_date ;;
  }

  dimension: is_matched_on_too_early_date_different_units {
    type: yesno
    description: "Flag that indicates if it was inbounded early and the units inbounded were different"
    sql: ${TABLE}.is_matched_on_too_early_date_different_units ;;
  }

  dimension: is_matched_on_too_late_date {
    type: yesno
    description: "Flag that indicates if it was inbounded late and the units inbounded were the same"
    sql: ${TABLE}.is_matched_on_too_late_date ;;
  }

  dimension: is_matched_on_too_late_date_different_units {
    type: yesno
    description: "Flag that indicates if it was inbounded late and the units inbounded were different"
    sql: ${TABLE}.is_matched_on_too_late_date_different_units ;;
  }

  dimension: is_po_delivered_on_promised_delivery_date {
    type: yesno
    description: "This boolean indicates, if the purchase orders promised delivery date is the same as the delivery date according to the matched DESADV"
    sql: ${TABLE}.is_po_delivered_on_promised_delivery_date ;;
  }

  dimension: is_po_delivered_too_early {
    type: yesno
    description: "This boolean indicates, if the purchase orders promised delivery date is the same as the delivery date according to the matched DESADV"
    sql: ${TABLE}.is_po_delivered_too_early ;;
  }

  dimension: number_of_days_delivered_too_early {
    type: number
    sql: ${TABLE}.number_of_days_delivered_too_early ;;
  }

  dimension: is_po_delivered_too_late {
    type: yesno
    description: "This boolean indicates, if the purchase orders promised delivery date is the same as the delivery date according to the matched DESADV"
    sql: ${TABLE}.is_po_delivered_too_late ;;
  }

  dimension: number_of_days_delivered_too_late {
    type: number
    sql: ${TABLE}.number_of_days_delivered_too_late ;;
  }

  dimension: is_underdelivery {
    type: yesno
    description: "Flag that indicates if it was not inbounded, meaning that we have it on PO/DESADVs but was never received"
    sql: ${TABLE}.is_underdelivery ;;
  }

  dimension: is_unplanned_inbound {
    type: yesno
    description: "Flag that indicates that it was inbounded but not ordered"
    sql: ${TABLE}.is_unplanned_inbound ;;
  }

  dimension_group: loaded_in_truck {
    type: time
    description: "This field refers to the date, when the products were loaded onto the truck and the delivery process to our hub started. Usually, this is also the time, when the DESADV EDI file is been generated and sent to FLink"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.loaded_in_truck_date ;;
  }

  dimension_group: loaded_in_truck_timestamp {
    type: time
    description: "This field refers to the date and time, when the products were loaded onto the truck and the delivery process to our hub started. Usually, this is also the time, when the DESADV EDI file is been generated and sent to FLink"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.loaded_in_truck_timestamp ;;
  }

  dimension_group: max_open_order_lifetime {
    type: time
    description: "Max limit of open order lifetime range - This is the max limit we can match a PO/DESADVs against Inbounds in the past days"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.max_open_order_lifetime ;;
  }

  dimension_group: min_open_order_lifetime {
    type: time
    description: "Min limit of open order lifetime range - This is the min limit we can match a PO/DESADVs against Inbounds in the past days"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.min_open_order_lifetime ;;
  }

  dimension_group: order {
    type: time
    description: "The date when we placed an order to our suppliers."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: order_id {
    type: string
    description: "Unique identifier of an order placed to our suppliers."
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    type: number
    description: "This is the identifier of a purchase order. A purchase order is a document, that is sent to a supplier and indicates, which products Flink wants to buy."
    sql: ${TABLE}.order_number ;;
  }

  dimension_group: order_timestamp {
    type: time
    description: "The date and time when we placed an order to our suppliers."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    datatype: datetime
    sql: ${TABLE}.order_timestamp ;;
  }

  dimension: parent_sku {
    type: string
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    sql: ${TABLE}.parent_sku ;;
  }

  dimension: parent_sku_desadv {
    type: string
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    sql: ${TABLE}.parent_sku_desadv ;;
  }

  dimension: parent_sku_purchase_order {
    type: string
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    sql: ${TABLE}.parent_sku_purchase_order ;;
  }

  dimension: product_name {
    type: string
    description: "The name of the product, as specified in the backend."
    sql: ${TABLE}.product_name ;;
  }

  dimension_group: promised_delivery_date_combined {
    type: time
    description: "The date when we expect to receive the delivery, either coming from DESADVs or PO."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.promised_delivery_date_combined ;;
  }

  dimension_group: promised_delivery_date_purchase_order {
    type: time
    description: "The date when we expect to receive the delivery, originating from a purchase order."
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.promised_delivery_date_purchase_order ;;
  }

  dimension: purchase_order_status {
    type: string
    description: "The status of an order placed to our suppliers - This could be Sent or Not Sent."
    sql: ${TABLE}.purchase_order_status ;;
  }

  dimension: purchase_order_uuid {
    type: string
    description: "Purchase Order generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.purchase_order_uuid ;;
  }

  dimension: quantity_per_handling_unit {
    type: number
    description: "This field indicates, how many selling units are part of 1 handling unit"
    sql: ${TABLE}.quantity_per_handling_unit ;;
  }

  dimension: replenishment_substitute_group_array {
    hidden: yes
    sql: ${TABLE}.replenishment_substitute_group_array ;;
  }

  dimension: sscc {
    type: string
    description: "A delivery is usually delivered on multiple rollies. This field relates to the ID of each rolli."
    sql: ${TABLE}.sscc ;;
  }

  dimension: supplier_id {
    type: string
    description: "The ID of a supplier/vendor as define in our ERP system Lexbizz"
    sql: ${TABLE}.supplier_id ;;
  }

  dimension: supplier_name {
    type: string
    description: "The name of the supplier of a product (e.g. REWE or Carrefour)."
    sql: ${TABLE}.supplier_name ;;
  }

  dimension: table_uuid {
    type: string
    description: "A generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: temperature_zone {
    type: string
    description: "This field refers to the temperature a product needs to have while being delivered and stored in order to be consumable"
    sql: ${TABLE}.temperature_zone ;;
  }

  dimension: total_quantity {
    type: number
    description: "This field shows the number of selling units of a product, that have been delivered/ordered"
    sql: ${TABLE}.total_quantity ;;
  }

  dimension: is_po_desadv_quantity_in_full {
    type: yesno
    sql: ${TABLE}.is_po_desadv_quantity_in_full ;;
  }

  dimension: is_po_desadv_quantity_in_full_limited {
    type: yesno
    sql: ${TABLE}.is_po_desadv_quantity_in_full_limited ;;
  }

  dimension: quantity_filled_po_to_desadv {
    type: number
    sql: ${TABLE}.quantity_filled_po_to_desadv ;;
  }

  dimension: total_quantity_desadv {
    type: number
    description: "This field shows the number of selling units of a product, that have been delivered/ordered (DESADV)"
    sql: ${TABLE}.total_quantity_desadv ;;
  }

  dimension: total_quantity_purchase_order {
    type: number
    description: "This field shows the number of selling units of a product, that have been delivered/ordered (Purchase Order)"
    sql: ${TABLE}.total_quantity_purchase_order ;;
  }

  dimension: vendor_location {
    type: string
    description: "Location from where the Supplier is doing the distribution."
    sql: ${TABLE}.vendor_location ;;
  }

  dimension: warehouse_number {
    type: string
    description: "The identifier of a warehouse according to ERP. Usually, 1 warehouse delviery to exactly 1 hub."
    sql: ${TABLE}.warehouse_number ;;
  }

  dimension: is_po_desadv_quantity_overdelivery {
    type: yesno
    sql: ${TABLE}.is_po_desadv_quantity_overdelivery ;;
  }

  dimension: is_po_desadv_quantity_underdelivery {
    type: yesno
    sql: ${TABLE}.is_po_desadv_quantity_underdelivery ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name, supplier_name]
  }
}
