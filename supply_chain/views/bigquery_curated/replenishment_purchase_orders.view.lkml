
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

  set: cross_references_inventory_changes_daily {
    fields: [
      pct_order_inbounded
    ]
  }

  set: main_fields {
    fields: [
      vendor_id,
      status,
      hub_code,
      sku,
      delivery_date,
      delivery_week,
      delivery_month,
      order_date,
      vendor_location,
      name,
      order_id,
      order_number,
      flink_buyer_id,
      dynamic_delivery_date,
      global_filters_and_parameters.timeframe_picker,

      sum_handling_unit_quantity,
      sum_selling_unit_quantity,
      sum_purchase_price,
      avg_items_per_order,
      cnt_of_orders,
      cnt_of_skus_per_order,
      edi
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

  dimension: dynamic_delivery_date {

    label:       "Dynamic Delivery Date"
    group_label: ">> Dates & Timestamps"

    label_from_parameter: global_filters_and_parameters.timeframe_picker
    sql:
    {% if    global_filters_and_parameters.timeframe_picker._parameter_value == 'Date' %}
        ${delivery_date}

      {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Week' %}
      ${delivery_week}

      {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Month' %}
      ${delivery_month}

      {% else %}
      ${delivery_month}

      {% endif %};;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # =========  __main__   =========

  dimension: vendor_id {

    label:       "Supplier ID"
    description: "The Id of the supplier"
    bypass_suggest_restrictions: yes

    type: string
    sql: ${TABLE}.vendor_id ;;
  }

  dimension: vendor_id_original {

    label:       "Original Supplier ID of PO"
    description: "The original supplier id of the purchase order. This supplier id resembles more a warehouse_id, in case the supplier is a DC"

    type: string
    sql: ${TABLE}.vendor_id_original ;;
  }

  dimension: is_vendor_dc {

    label: "Is Supplier DC"
    description: "This flag indicates, if the purchase order was actually been sent to a DC first, before being send to the hub"

    type: yesno
    sql: ${TABLE}.is_vendor_dc ;;
  }


  dimension: status {
    label: "Order Status"
    description: "The order status defines, whether a purchase order was Sent or NotSent to the vendor"
    type: string
    bypass_suggest_restrictions: yes
    sql: ${TABLE}.status ;;
  }

  dimension: vendor_location {

    label:       "Supplier Location"
    description: "Location of the supplier"
    type: string
    bypass_suggest_restrictions: yes
    sql: ${TABLE}.vendor_location ;;
  }

  dimension: hub_code {
    type: string
    bypass_suggest_restrictions: yes
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
    description: "The promised delivery date of the order according to the replenishment db"
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

    type: string
    bypass_suggest_restrictions: yes
    sql: ${TABLE}.sku ;;
    hidden: no
  }

  dimension: name {

    label:       "Product Name"
    description: "The name of a product"

    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: edi {

    label:       "EDI"
    description: "Unique ID for SKUs to be ordered from supplier"
    # group_label: " >> Line Item Data"

    type: string
    sql: ${TABLE}.edi ;;

  }





  dimension: handling_unit_quantity {

    label:       "Quantity Handling Unit"
    description: "The amount of ordered handling units"
    group_label: " >> Line Item Data"

    type: number
    sql: safe_cast(${TABLE}.handling_unit_quantity as numeric) ;;
    hidden: yes
  }

  dimension: selling_unit_quantity {

    label:       "Quantity Selling Unit"
    description: "The amount of ordered items"
    group_label: " >> Line Item Data"

    type: number
    # sql: ${TABLE}.selling_unit_quantity ;;
    sql: safe_cast(${TABLE}.selling_unit_quantity as numeric) ;;
    hidden: yes

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

    type: string
    sql: safe_cast(${TABLE}.order_number as string) ;;
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

    label:       "# Selling Units (PO)"
    description: "The amount of ordered items"


    type: sum
    sql: ${selling_unit_quantity} ;;
    value_format_name: decimal_0

  }

  measure: sum_handling_unit_quantity {

    label:       "# Handling Units (PO)"
    description: "The amount of ordered handling units"


    type: sum
    sql: ${handling_unit_quantity} ;;
    value_format_name: decimal_0
  }

  measure: pct_order_inbounded {
    label:       "% Fill Rate (PO > Inventory)"
    description: "How many of the ordered items have been inbounded in the hubs on the promised delivery date of the order"


    type: number
    sql: ${inventory_changes_daily.sum_inbound_inventory} / nullif(${sum_selling_unit_quantity} ,0) ;;

    value_format_name: percent_1
    html:
    {% if global_filters_and_parameters.show_info._parameter_value == 'yes' %}
    {{ rendered_value }} ({{ sum_selling_unit_quantity._rendered_value }} ordered items)
    {% else %}
    {{ rendered_value }}
    {% endif %}
    ;;
  }


  measure: cnt_of_orders {

    label:       "# Orders"
    description: "The amount of delivered orders"
    #group_label: " >> Line Item Data"

    type: count_distinct
    sql: ${order_id} ;;
    value_format_name: decimal_0

}

  measure: cnt_of_skus_per_order {

    label:       "# SKUs per orders"
    description: "The amount of skus per orders"
    #group_label: " >> Line Item Data"

    type: count_distinct
    sql: ${sku} ;;
    value_format_name: decimal_0

  }

  measure: avg_items_per_order  {
    label: "AVG # Items per Order"
    description: "AVG Items per Order per SKU"
    sql: safe_divide(${cnt_of_skus_per_order} , ${cnt_of_orders}) ;;

    value_format_name: percent_2

  }

  measure: sum_purchase_price {
    label:       "€ Selling Units (Buying Price)"
    description: "This measure multiplies the supplier price of an item with the number of selling units we ordered and thus provides the cumulative value of the replenished items."

    type: sum
    sql: coalesce((${selling_unit_quantity} * ${erp_buying_prices.vendor_price}),0) ;;
    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${erp_buying_prices.table_uuid}) ;;
  }


  measure: count {
    type: count
    hidden: yes
    drill_fields: [name]
  }

##################################################################################################################################
##################################################################################################################################
#################################################### Demand Planning #############################################################
##################################################################################################################################
##################################################################################################################################

  measure: sum_selling_unit_quantity_next_7_days {

    label:       "# Upcoming Selling Units Next 7 Days (PO) "
    description: "The amount of ordered items to receive in the next 7 days"
    group_label: "Demand Planning"

    type: sum
    sql: ${selling_unit_quantity} ;;
    filters: [delivery_date: "today for 7 days"]
    value_format_name: decimal_0
    hidden: yes

  }



}
