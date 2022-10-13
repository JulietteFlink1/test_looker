view: advanced_supplier_matching {
  sql_table_name: `flink-data-prod.reporting.advanced_supplier_matching`
    ;;


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Main
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    description: "2-letter country code."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: inbound_matched_on {
    type: string
    description: "Buckets, that define, which logic was applied to match Purchase Order/DESADV with Inbounds"
    sql: ${TABLE}.inbound_matched_on ;;
  }

  dimension: parent_sku {
    type: string
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    sql: ${TABLE}.parent_sku_combined ;;
  }

  dimension: product_name {
    type: string
    description: "The name of the product, as specified in the backend."
    sql: ${TABLE}.product_name ;;
  }

  dimension: supplier_name {
    type: string
    description: "The name of the supplier of a product (e.g. REWE or Carrefour)."
    sql: ${TABLE}.supplier_name ;;
  }






  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    IDs
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: table_uuid {
    type: string
    description: "A generic identifier of a table in BigQuery that represent 1 unique row of this table."
    group_label: "IDs"
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: bulk_items_id {
    type: string
    description: "This field refers to the distinct prodcuts on a delivery. Hereby, the same SKU can appear multiple times with different bulk items ids"
    group_label: "IDs"
    sql: ${TABLE}.bulk_items_id ;;
  }

  dimension: delivery_party_id {
    type: string
    description: "The GLN number (see ERP) of the warehouse that the item will be delivered to"
    group_label: "IDs"
    sql: ${TABLE}.delivery_party_id ;;
  }

  dimension: desadvs_uuid {
    type: string
    description: "DESADVs generic identifier of a table in BigQuery that represent 1 unique row of this table."
    group_label: "IDs"
    sql: ${TABLE}.desadvs_uuid ;;
    hidden: yes
  }

  dimension: dispatch_advice_number {
    type: string
    description: "The unique identifier of a dispatch notification (DESADV) as parsed from the EDI file provide by the supplier"
    group_label: "IDs"
    sql: ${TABLE}.dispatch_advice_number ;;
  }

  dimension: dispatch_notification_id {
    type: string
    description: "The unique identifier of a dispatch notification (DESADV) as parsed from the EDI file provide by the supplier"
    group_label: "IDs"
    sql: ${TABLE}.dispatch_notification_id ;;
  }

  dimension: edi {
    type: string
    description: "Transaction codes that correspond to information in business documents between Flink and Suppliers."
    group_label: "IDs"
    sql: ${TABLE}.edi ;;
  }

  dimension: external_sku {
    type: string
    description: "The unique identifier of a product, that is provided by the supplier"
    group_label: "IDs"
    sql: ${TABLE}.external_sku ;;
  }

  dimension: flink_buyer_id {
    type: string
    description: "The buyer ID of Flink as defined in ERP/Lexbizz"
    group_label: "IDs"
    sql: ${TABLE}.flink_buyer_id ;;
  }

  dimension: flink_hq_gln {
    type: string
    description: "The GLN location code of the Flink HQ as defined in ERP/Lexbizz"
    group_label: "IDs"
    sql: ${TABLE}.flink_hq_gln ;;
  }

  dimension: internal_sku_array {
    hidden: yes
    sql: ${TABLE}.internal_sku_array ;;
    group_label: "IDs"
  }

  dimension: order_id {
    type: string
    description: "Unique identifier of an order placed to our suppliers."
    group_label: "IDs"
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    type: number
    description: "This is the identifier of a purchase order. A purchase order is a document, that is sent to a supplier and indicates, which products Flink wants to buy."
    group_label: "IDs"
    sql: ${TABLE}.order_number ;;
  }

  dimension: purchase_order_uuid {
    type: string
    description: "Purchase Order generic identifier of a table in BigQuery that represent 1 unique row of this table."
    group_label: "IDs"
    hidden: yes
    sql: ${TABLE}.purchase_order_uuid ;;
  }

  dimension: sscc {
    type: string
    description: "A delivery is usually delivered on multiple rollies. This field relates to the ID of each rolli."
    group_label: "IDs"
    sql: ${TABLE}.sscc ;;
  }

  dimension: supplier_id {
    type: string
    description: "The ID of a supplier/vendor as define in our ERP system Lexbizz"
    group_label: "IDs"
    sql: ${TABLE}.supplier_id ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Dates & Timestamps
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension_group: delivery_date_desadv {
    type: time
    description: "The date when we expect to receive the delivery, either coming from DESADVs or PO."
    group_label: "Dates & Timestamps"
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivery_date_desadv ;;
  }

  dimension_group: estimated_delivery_timestamp {
    type: time
    description: "This field refers to the DATA-internally calculated timestamp, when we think the delivery arrived at a hub.
    After matching a DESADV/PO and its delivery date with our internally observed inbounds, we define the delivery timestamp to be the one, when 2 % of the items listed on a DESADV/PO have been inbounded"
    group_label: "Dates & Timestamps"
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.estimated_delivery_timestamp ;;
  }

  dimension_group: inbounded {
    type: time
    description: "The date when we actually inbounded the items based on the matching logic."
    group_label: "Dates & Timestamps"
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.inbounded_date ;;
  }

  dimension_group: loaded_in_truck {
    type: time
    description: "This field refers to the date, when the products were loaded onto the truck and the delivery process to our hub started. Usually, this is also the time, when the DESADV EDI file is been generated and sent to FLink"
    group_label: "Dates & Timestamps"
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
    hidden: yes
  }

  dimension_group: loaded_in_truck_timestamp {
    type: time
    description: "This field refers to the date and time, when the products were loaded onto the truck and the delivery process to our hub started. Usually, this is also the time, when the DESADV EDI file is been generated and sent to FLink"
    group_label: "Dates & Timestamps"
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.loaded_in_truck_timestamp ;;
  }

  dimension_group: max_open_order_lifetime {
    type: time
    description: "Max limit of open order lifetime range - This is the max limit we can match a PO/DESADVs against Inbounds in the past days"
    group_label: "Dates & Timestamps"
    timeframes: [
      date,
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.max_open_order_lifetime ;;
  }

  dimension_group: min_open_order_lifetime {
    type: time
    description: "Min limit of open order lifetime range - This is the min limit we can match a PO/DESADVs against Inbounds in the past days"
    group_label: "Dates & Timestamps"
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.min_open_order_lifetime ;;
  }

  dimension_group: promised_delivery_date_combined {
    type: time
    label: "Promised Delivery (Combined with DESADV)"
    description: "The date when we expect to receive the delivery, either coming from DESADVs or PO."
    group_label: "Dates & Timestamps"
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.promised_delivery_date_combined ;;
  }

  dimension_group: promised_delivery_date_purchase_order {
    label: "Purchase Order (PO) Promised Delivery"
    type: time
    description: "The date when we expect to receive the delivery, originating from a purchase order."
    group_label: "Dates & Timestamps"
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.promised_delivery_date_purchase_order ;;
    hidden: no
  }

  dimension_group: order_timestamp {
    type: time
    label: "Purchase Order"
    description: "The date and time when we placed an order to our suppliers."
    group_label: "Dates & Timestamps"
    timeframes: [
      date,
      week,
      month
    ]
    datatype: datetime
    sql: ${TABLE}.order_timestamp ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Booleans
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: is_desadv_inbounded_in_full {
    type: yesno
    description: "This boolean field evaluates to true, if the selling units listed on the DESADV exactly match the inbounded units"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_desadv_inbounded_in_full ;;
  }

  dimension: is_desadv_inbounded_in_full_limited {
    type: yesno
    description: "This boolean field evaluates to true, if the inbounded quantity exactly matches or exceeds the  selling units listed on the DESADV"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_desadv_inbounded_in_full_limited ;;
  }

  dimension: is_desadv_inbounded_overdelivery {
    type: yesno
    description: "This boolean field evaluates to true, if the inbounded quantity is higher than the selling units listed on the DESADV"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_desadv_inbounded_overdelivery ;;
  }

  dimension: is_desadv_inbounded_underdelivery {
    type: yesno
    description: "This boolean field evaluates to true, if the inbounded quantity is lower than the selling units listed on the DESADV"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_desadv_inbounded_underdelivery ;;
  }

  dimension: is_desadv_unfulfilled {
    type: yesno
    description: "This boolean field evaluates to true, if the selling units on the DESADV are greater than 0 and not NULL, but no matching inbounded quantity was found"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_desadv_unfulfilled ;;
  }

  dimension: is_double_parent_sku {
    type: yesno
    description: "This field indicates, if there are 2 or more parent_skus within the internal_sku_array, that is provided in the raw DESADV data"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_double_parent_sku ;;
  }

  dimension: is_matched_on_same_date {
    type: yesno
    description: "Flag that indicates if it was inbounded on time"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_matched_on_same_date ;;
  }

  dimension: is_matched_on_too_early_date {
    type: yesno
    description: "Flag that indicates if it was inbounded early and the units inbounded were the same"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_matched_on_too_early_date ;;
  }

  dimension: is_matched_on_too_late_date {
    type: yesno
    description: "Flag that indicates if it was inbounded late and the units inbounded were the same"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_matched_on_too_late_date ;;
  }

  dimension: is_not_fulfilled_purchase_order {
    type: yesno
    description: "This boolean field evaluates to true, if we expected a delivery defined as a positive selling unit on a purchase order, but did not receive the item as listed on the DESADV"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_not_fulfilled_purchase_order ;;
  }

  dimension: is_po_delivered_on_promised_delivery_date {
    type: yesno
    description: "This boolean indicates, if the purchase orders promised delivery date is the same as the delivery date according to the matched DESADV"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_po_delivered_on_promised_delivery_date ;;
  }

  dimension: is_po_delivered_too_early {
    type: yesno
    description: "This field indicates, that the actual delivery happend before the promised delivery date, that is stated on the purchase order document"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_po_delivered_too_early ;;
  }

  dimension: is_po_delivered_too_late {
    type: yesno
    description: "This field indicates, that the actual delivery happend after the promised delivery date, that is stated on the purchase order document"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_po_delivered_too_late ;;
  }

  dimension: is_po_desadv_quantity_in_full {
    type: yesno
    description: "This boolean field evaluates to true, if the selling quantities on the purchase order and the matched DESADV are exactly the same"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_po_desadv_quantity_in_full ;;
  }

  dimension: is_po_desadv_quantity_in_full_limited {
    type: yesno
    description: "This boolean field evaluates to true, if the selling quantities on the purchase order and the matched DESADV are exactly the same or if the DESADV has a higher quantity"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_po_desadv_quantity_in_full_limited ;;
  }

  dimension: is_po_desadv_quantity_overdelivery {
    type: yesno
    description: "This boolean field evaluates to true, if the selling quantities on the DESADV are higher than the one on the matched purchase order"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_po_desadv_quantity_overdelivery ;;
  }

  dimension: is_po_desadv_quantity_underdelivery {
    type: yesno
    description: "This boolean field evaluates to true, if the selling quantities on the DESADV are lower than the one on the matched purchase order but if they are not NULL"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_po_desadv_quantity_underdelivery ;;
  }

  dimension: is_purchase_order_inbounded_in_full {
    type: yesno
    description: "This boolean field evaluates to true, if the selling units listed on the Purchase Order exactly match the inbounded units"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_purchase_order_inbounded_in_full ;;
  }

  dimension: is_purchase_order_inbounded_in_full_limited {
    type: yesno
    description: "This boolean field evaluates to true, if the inbounded quantity exactly matches or exceeds the  selling units listed on the Purchase Order"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_purchase_order_inbounded_in_full_limited ;;
  }

  dimension: is_purchase_order_inbounded_overdelivery {
    type: yesno
    description: "This boolean field evaluates to true, if the inbounded quantity is higher than the selling units listed on the Purchase Order"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_purchase_order_inbounded_overdelivery ;;
  }

  dimension: is_purchase_order_inbounded_underdelivery {
    type: yesno
    description: "This boolean field evaluates to true, if the inbounded quantity is lower than the selling units listed on the Purchase Order"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_purchase_order_inbounded_underdelivery ;;
  }

  dimension: is_purchase_order_unfulfilled {
    type: yesno
    description: "This boolean field evaluates to true, if the selling units on the Purchase Order are greater than 0 and not NULL, but no matching inbounded quantity was found"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_purchase_order_unfulfilled ;;
  }

  dimension: is_quality_issue {
    type: yesno
    description: "This boolean field evaluates to true, if an inbound had also corrections with the reasons delivery-damaged or delivery-expired"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_quality_issue ;;
  }

  dimension: is_underdelivery {
    type: yesno
    description: "Flag that indicates if it was not inbounded, meaning that we have it on PO/DESADVs but was never received"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_underdelivery ;;
  }

  dimension: is_unplanned_delivery {
    type: yesno
    description: "This boolean field evaluates to true, if an item is only listed on the DESADV but not on the matched purchase order"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_unplanned_delivery ;;
  }

  dimension: is_unplanned_inbound {
    type: yesno
    description: "Flag that indicates that it was inbounded but not ordered"
    group_label: "Boolean Fields"
    sql: ${TABLE}.is_unplanned_inbound ;;
  }





  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Hidden
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: number_of_days_delivered_too_early {
    type: number
    description: "This field defines the difference in days between the delivery date according to the DESADV and the promised delivery date of the purchase order. This field is only calculated, when there is a too early delivery"
    sql: ${TABLE}.number_of_days_delivered_too_early ;;
    hidden: yes
  }

  dimension: number_of_days_delivered_too_late {
    type: number
    description: "This field defines the difference in days between the delivery date according to the DESADV and the promised delivery date of the purchase order. This field is only calculated, when there is a too late delivery"
    sql: ${TABLE}.number_of_days_delivered_too_late ;;
    hidden: yes
  }

  dimension: number_of_days_inbounded_too_early {
    type: number
    description: "This field defines the difference in days between the inbounded date and the estimated delivery date according to the DESADV (if present) or the promised delivery date of the purchase order. This field is only calculated, when there is a too early inbound"
    sql: ${TABLE}.number_of_days_inbounded_too_early ;;
    hidden: yes
  }

  dimension: number_of_days_inbounded_too_late {
    type: number
    description: "This field defines the difference in days between the inbounded date and the estimated delivery date according to the DESADV (if present) or the promised delivery date of the purchase order. This field is only calculated, when there is a too late inbound"
    sql: ${TABLE}.number_of_days_inbounded_too_late ;;
    hidden: yes
  }

  dimension: number_of_delivery_damaged_quality_issues {
    type: number
    description: "This field shows the number of item quantities with stock change reason damaged at delivery"
    sql: ${TABLE}.number_of_delivery_damaged_quality_issues ;;
    hidden: yes
  }

  dimension: number_of_delivery_expired_quality_issues {
    type: number
    description: "This field shows the number of item quantities with stock change reason expired at delivery"
    sql: ${TABLE}.number_of_delivery_expired_quality_issues ;;
    hidden: yes
  }

  dimension: number_of_quality_issues_delivery {
    type: number
    description: "This field shows the number delivery issues (delivery-damaged and delivery-expired) for items, that have an inbound"
    sql: ${TABLE}.number_of_quality_issues_delivery ;;
    hidden: yes
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
    hidden: yes
  }

  dimension: total_quantity {
    type: number
    description: "This field shows the number of selling units of a product, that have been delivered/ordered"
    sql: ${TABLE}.total_quantity_combined ;;
    hidden: yes
  }

  dimension: total_quantity_desadv {
    type: number
    description: "This field shows the number of selling units of a product, that have been delivered/ordered (DESADV)"
    sql: ${TABLE}.total_quantity_desadv ;;
    hidden: yes
  }

  dimension: total_quantity_purchase_order {
    type: number
    description: "This field shows the number of selling units of a product, that have been delivered/ordered (Purchase Order)"
    sql: ${TABLE}.total_quantity_purchase_order ;;
    hidden: yes
  }

  dimension: handling_units_count {
    type: number
    description: "The field shows, how many handling units with products have been delivered to a hub. 1 handling unit contains N selling units. The N is defined in the field quantity_per_handling_unit"
    sql: ${TABLE}.handling_units_count ;;
    hidden: no
  }

  dimension: inbounded_quantity {
    type: number
    description: "Quantity actually inbounded based on the matching logic."
    sql: ${TABLE}.inbounded_quantity ;;
    hidden: yes
  }

  dimension: parent_sku_desadv {
    type: string
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group. (only defined, if the DESADV exists)"
    sql: ${TABLE}.parent_sku_desadv ;;
    hidden: yes
  }

  dimension: parent_sku_purchase_order {
    type: string
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group. (only defined, if the purchase order exists)"
    sql: ${TABLE}.parent_sku_purchase_order ;;
    hidden: yes
  }

  dimension: quantity_per_handling_unit {
    type: number
    label: "Pack Factor"
    description: "This field indicates, how many selling units are part of 1 handling unit"
    sql: ${TABLE}.quantity_per_handling_unit ;;
    hidden: no
  }

  dimension: replenishment_substitute_group_array {
    hidden: yes
    sql: ${TABLE}.replenishment_substitute_group_array ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Monetary Dimension
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension: avg_amt_selling_price_gross {
    type: number
    description: "Average Selling Price"
    group_label: "Price related"
    hidden: yes
    sql: ${TABLE}.avg_amt_selling_price_gross ;;
  }

  dimension: avg_amt_buying_price_net {
    type: number
    description: "Buying Prices"
    group_label: "Price related"
    hidden: yes
    sql: ${TABLE}.avg_amt_buying_price_net ;;

    required_access_grants: [can_view_buying_information]
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Special Use Case (Monetary)
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension: number_of_items_sold {
    type: number
    label: "# Items Sold"
    description: "Quantity of units sold."
    group_label: "Special Use Cases - Price Related"
    hidden: yes
    sql: ${TABLE}.number_of_items_sold ;;
  }

  dimension: amt_total_gmv_gross {
    type: number
    label: "€ Items Sold Gross"
    description: "Total amount sold in Euro."
    group_label: "Special Use Cases - Price Related"
    hidden: yes
    sql: ${TABLE}.amt_total_gmv_gross ;;
  }

  dimension: amt_quantity_ordered_net {
    type: number
    label: "€ Total amount ordered"
    description: "Total amount ordered calculated as total quantity ordered (PO) * buying prices net."
    group_label: "Special Use Cases - Price Related"
    hidden: yes
    sql: ${TABLE}.amt_quantity_ordered_net ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Special Use Case
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: purchase_order_status {
    type: string
    description: "The status of an order placed to our suppliers - This could be Sent or Not Sent."
    group_label: "Special Use Cases"
    sql: ${TABLE}.purchase_order_status ;;
  }

  dimension: temperature_zone {
    type: string
    description: "This field refers to the temperature a product needs to have while being delivered and stored in order to be consumable"
    group_label: "Special Use Cases"
    sql: ${TABLE}.temperature_zone ;;
  }

  dimension: vendor_location {
    type: string
    description: "Location from where the Supplier is doing the distribution."
    group_label: "Special Use Cases"
    sql: ${TABLE}.vendor_location ;;
  }

  dimension: warehouse_number {
    type: string
    description: "The identifier of a warehouse according to ERP. Usually, 1 warehouse delviery to exactly 1 hub."
    group_label: "Special Use Cases"
    sql: ${TABLE}.warehouse_number ;;
  }

  dimension: lead_time_in_days {
    type: string
    label: "Lead Time in Days"
    description: "This is the limit we can match a PO/DESADVs against Inbounds in the past/next days."
    group_label: "Special Use Cases"
    sql: ${TABLE}.lead_time_in_days ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -   Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  measure: avg_unit_buying_price {
    type:  average
    label: "AVG Unit Buying Price Net"
    description: "Average Unit Selling Buying Price"
    group_label: "Price related"

    sql: ${avg_amt_buying_price_net} ;;

    value_format_name: eur

    required_access_grants: [can_view_buying_information]
  }

  measure: amt_total_quantity_ordered_net {
    type:  sum_distinct
    label: "€ Volume Ordered Net (PO)"
    description: "Total amount ordered calculated as total quantity ordered (PO) * buying prices net."
    group_label: "Price related"

    sql: ${amt_quantity_ordered_net} ;;

    value_format_name: eur

    required_access_grants: [can_view_buying_information]

  }

  measure: avg_unit_selling_price_gross {
    type:  average
    label: "AVG Unit Selling Price Gross"
    description: "Average Unit Selling Price"
    group_label: "Price related"

    sql: ${avg_amt_selling_price_gross} ;;

    value_format_name: eur

  }

  measure: sum_total_items_sold {
    type:  sum_distinct
    label: "# Units Sold"
    description: "Sum Items units sold"
    group_label: "Price related"

    sql: ${number_of_items_sold} ;;

  }

  measure: amt_total_quantity_gmv_gross {
    type:  sum_distinct
    label: "€ GMV Gross"
    description: "Total amount Sold in Euro - This will be considered as GMV per supplier depending on the aggregation
                    (Consider that it could happen that we assign sold units to a supplier
                     that is delivering today (promised delivery date)
                     but the units sold belong to another supplier, this although should be an edge case)."
    group_label: "Price related"

    sql: ${amt_total_gmv_gross} ;;

    value_format_name: eur

  }

  measure: avg_lead_time_in_days {
    type: average
    label: "AVG Lead time in days"
    description: "Average of days that an order could be open to be match against inbounds based on its lead time range"

    sql: ${lead_time_in_days} ;;

    value_format_name: decimal_1

  }


  measure: count {
    type: count
    hidden: yes
    drill_fields: [product_name, supplier_name]
  }
}
