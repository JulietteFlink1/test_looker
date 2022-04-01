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
      hub_code,
      delivery_date
    ]
  }

  set: cross_references_inventory_daily {
    fields: [

    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter: show_info {
    # this paramter does:
    #  1. replace the SKU with a leading SKU name
    #  2. reduces the data in inventory tables to report only leading SKU level per group

    # this parameter is defined at the products_hub_assignment level, as this view is the base of the Supply Chain explore

    label:       "Show details per metric"
    group_label: "* Parameters & Dynamic Fields *"
    description: "Chose yes, if you want to see more details"

    type: unquoted

    allowed_value: {
      label: "yes"
      value: "yes"
    }

    allowed_value: {
      label: "no"
      value: "no"
    }

    default_value: "no"
  }

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

  dimension: vendor_id_original {

    label:       "Original Vendor ID of PO"
    description: "The original vendor id of the purchase order. This vendor id resembles more a warehouse_id, in case the vendor is a DC"

    type: string
    sql: ${TABLE}.vendor_id_original ;;
  }

  dimension: is_vendor_dc {

    label: "Is Vendor DC"
    description: "This flag indicates, if the purchase order was actually been sent to a DC first, before being send to the hub"

    type: yesno
    sql: ${TABLE}.is_vendor_dc ;;
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

  measure: pct_order_inbounded {
    label:       "% of ERP Order Inbounded"
    description: "How many of the ordered items have been inbounded in the hubs on the promised delivery date of the order"
    group_label: " >> Inbounding-Metrics"

    type: number
    sql: ${inventory_daily.sum_of_total_inbound} / nullif(${sum_selling_unit_quantity} ,0) ;;

    value_format_name: percent_1

    html:

      {% if show_info._parameter_value == 'yes' %}
        {{ rendered_value }} <br><span style="font-size:8px"> {{ inventory_daily.sum_of_total_inbound._rendered_value }} inb /<br>{{ sum_selling_unit_quantity._rendered_value }} ord</span>
      {% else %}
        {{ rendered_value }}
      {% endif %}
        ;;
  }

  measure: cnt_of_orders {

    label:       "# Count of orders"
    description: "The amount of delivered orders"
    #group_label: " >> Line Item Data"

    type: count_distinct
    sql: ${order_id} ;;

}

  measure: cnt_of_skus_per_order {

    label:       "# Count of skus per orders"
    description: "The amount of skus per orders"
    #group_label: " >> Line Item Data"

    type: count_distinct
    sql: ${sku} ;;

  }

  measure: avg_items_per_order  {
    label: "AVG Items per Order"
    description: "AVG Items per Order per SKU"
    sql: round(${cnt_of_skus_per_order}/${cnt_of_orders}, 2) ;;

  }


  measure: count {
    type: count
    hidden: yes
    drill_fields: [name]
  }
}
