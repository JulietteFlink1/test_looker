view: replenishment_purchase_orders {
  sql_table_name: `flink-data-prod.curated.replenishment_purchase_orders`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set: join_fields {
    fields: [
      vendor_id,
      sku,
      hub_code
    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: vendor_id {

    label:       "Vendor ID"
    description: "The Id of the supplier"

    type: string
    sql: ${TABLE}.vendor_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: vendor_location {

    label:       "Vendor Location"
    description: "Location of the supplier"
    type: string
    sql: ${TABLE}.vendor_location ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: no
  }


  # =========  Dates   =========
  dimension_group: purchase_order_timestamp {

    label:       "Record Creation"
    description: "Timestamp, when the record was created in the replenishment database"
    group_label: ">> Dates & Timestamps"

    type: time
    timeframes: [
      time,
      date
    ]
    datatype: datetime
    sql: ${TABLE}.purchase_order_timestamp ;;
    hidden: no
  }

  dimension_group: order {

    label:       "Order"
    description: "Date. when the order was created"
    group_label: ">> Dates & Timestamps"

    type: time
    timeframes: [
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

  dimension_group: delivery {

    label: "Delivery"
    description: "The delivery date of the order according to the replenishment db"
    group_label: ">> Dates & Timestamps"

    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivery_date ;;
  }


  # =========  line-items   =========
  dimension: sku {

    label:       "SKU"
    description: "The identified of a product"
    group_label: " >> Line Item Data"

    type: string
    sql: ${TABLE}.sku ;;
    hidden: no
  }

  dimension: name {

    label:       "Product Name"
    description: "The name of a product"
    group_label: " >> Line Item Data"

    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: edi {

    label:       "EDI"
    description: "Unique ID for SKUs to be ordered from supplier"
    group_label: " >> Line Item Data"

    type: string
    sql: ${TABLE}.edi ;;

  }

  dimension: selling_unit_quantity {

    label:       "Quantity Selling Unit"
    description: "The amount of ordered items"
    group_label: " >> Line Item Data"

    type: number
    sql: ${TABLE}.selling_unit_quantity ;;

  }

  dimension: handling_unit_quantity {

    label:       "Quantity Handling Unit"
    description: "The amount of ordered handling units"
    group_label: " >> Line Item Data"

    type: number
    sql: ${TABLE}.handling_unit_quantity ;;
  }



  # =========  hidden   =========






  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: order_id {

    label:       "Order ID"
    description: "Order ID for orders placed by Flink to it's suppliers"
    group_label: " >> IDs "

    type: string
    sql: ${TABLE}.order_id ;;

  }

  dimension: order_number {

    label:       "Order Number"
    description: "Order Number for orders placed by Flink to it's suppliers"
    group_label: " >> IDs "

    type: number
    sql: ${TABLE}.order_number ;;
  }

  dimension: flink_buyer_id {

    label:       "Buyer ID"
    description: "Buyer ID of the purchase order"
    group_label: " >> IDs "

    type: string
    sql: ${TABLE}.flink_buyer_id ;;

  }

  dimension: flink_hq_gln {

    type: string
    sql: ${TABLE}.flink_hq_gln ;;
    hidden: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: sum_selling_unit_quantity {

    label:       "# Quantity Selling Unit"
    description: "The amount of ordered items"
    group_label: " >> Line Item Data"

    type: sum
    sql: safe_cast(${TABLE}.selling_unit_quantity as int64) ;;

  }

  measure: sum_handling_unit_quantity {

    label:       "# Quantity Handling Unit"
    description: "The amount of ordered handling units"
    group_label: " >> Line Item Data"

    type: sum
    sql: safe_cast(${TABLE}.handling_unit_quantity as int64) ;;
  }


  measure: count {
    type: count
    drill_fields: [name]
  }
}
