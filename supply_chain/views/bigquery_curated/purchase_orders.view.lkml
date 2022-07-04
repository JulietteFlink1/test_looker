##This view will replace replenishment_purchase_orders.view

view: purchase_orders {
  sql_table_name: `flink-data-dev.curated.purchase_orders`
    ;;


#Following Sets and Parameter are commented until we join this with vendor perdormance and we use this view to replace
#replenishment_purchase_order.view


#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~
#   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set: join_fields {
    fields: [
      vendor_id,
      sku,
      hub_code,
      promised_delivery_date_date
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
      promised_delivery_date_date,
      promised_delivery_date_week,
      promised_delivery_date_month,
      order_timestamp_date,
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
        ${promised_delivery_date_date}

      {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Week' %}
      ${promised_delivery_date_week}

      {% elsif global_filters_and_parameters.timeframe_picker._parameter_value == 'Month' %}
      ${promised_delivery_date_month}

      {% else %}
      ${promised_delivery_date_month}

      {% endif %};;
  }



########################################################################################################
####################################### Date Dimension #################################################
########################################################################################################

  dimension_group: estimated_delivery_timestamp {
    label: "Estimated Delivery"
    description: "The estimated delivery timestamp of the order based on % inbounded"
    group_label: ">> Dates & Timestamps"
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
    ]
    sql: ${TABLE}.estimated_delivery_timestamp ;;
  }

  dimension_group: order_date {
    type: time
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    hidden: yes
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension_group: order_timestamp {
    alias: [order]
    label:       "Order"
    description: "Date. when the order was created"
    group_label: ">> Dates & Timestamps"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    datatype: datetime
    sql: ${TABLE}.order_timestamp ;;
  }

  dimension_group: promised_delivery_date {
    alias: [delivery]
    label: "Promised Delivery"
    description: "The promised delivery date of the order according to the replenishment db"
    group_label: ">> Dates & Timestamps"
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.promised_delivery_date ;;
  }

########################################################################################################
############################################### Main ###################################################
########################################################################################################


  dimension: vendor_id {
    label:       "Supplier ID"
    description: "The Id of the supplier"
    type: string
    sql: ${TABLE}.vendor_id ;;
  }

# In curated.purchase_order (new model) we don't have vendor_id_original and is_vendor_dc


  dimension: status {
    label: "Order Status"
    description: "The order status defines, whether a purchase order was Sent or NotSent to the vendor"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: vendor_location {
    label:       "Supplier Location"
    description: "Location of the supplier"
    type: string
    sql: ${TABLE}.vendor_location ;;
  }

  dimension: hub_code {
    label: "Hub Code"
    type: string
    sql: ${TABLE}.hub_code ;;
  }


########################################################################################################
############################################# Line-Items ###############################################
########################################################################################################

  dimension: sku {
    label:       "SKU"
    description: "The identified of a product"
    type: string
    sql: ${TABLE}.sku ;;
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
    type: string
    sql: ${TABLE}.edi ;;
  }

########################################################################################################
##################################### Line-Items Q Dimensions ##########################################
########################################################################################################



  dimension: handling_units_count {
    label:       "Quantity Handling Unit"
    description: "The amount of ordered handling units"
    group_label: " >> Line Item Data"
    type: number
    hidden: yes
    sql: safe_cast(${TABLE}.handling_units_count as numeric) ;;
  }


  dimension: total_quantity {
    alias: [selling_unit_quantity]
    label:       "Quantity Selling Unit"
    description: "The amount of ordered items"
    group_label: " >> Line Item Data"
    type: number
    hidden: yes
    sql: safe_cast(${TABLE}.total_quantity as numeric) ;;
  }


  dimension: purchase_quantity_per_order_number {
    type: number
    sql: safe_cast(${TABLE}.purchase_quantity_per_order_number as numeric) ;;
    hidden: yes
  }

  dimension: quantity_per_handling_unit {
    hidden: yes
    type: number
    sql: safe_cast(${TABLE}.quantity_per_handling_unit as numeric) ;;
  }



########################################################################################################
############################################# IDs Dimension ############################################
########################################################################################################

  dimension: table_uuid {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.table_uuid ;;
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




########################################################################################################
################################################ Measures ##############################################
########################################################################################################

  measure: sum_selling_unit_quantity {

    label:       "# Selling Units (PO)"
    description: "The amount of ordered items"
    type: sum
    sql: ${total_quantity} ;;
    value_format_name: decimal_1
  }

  measure: sum_handling_unit_quantity {

    label:       "# Handling Units (PO)"
    description: "The amount of ordered handling units"
    type: sum
    sql: ${handling_units_count} ;;
    value_format_name: decimal_1
  }


  measure: cnt_of_orders {

    label:       "# Orders"
    description: "The amount of delivered orders"
    #group_label: " >> Line Item Data"

    type: count_distinct
    sql: ${order_id} ;;
    value_format_name: decimal_1

  }

  measure: cnt_of_skus_per_order {

    label:       "# SKUs per orders"
    description: "The amount of skus per orders"
    #group_label: " >> Line Item Data"

    type: count_distinct
    sql: ${sku} ;;
    value_format_name: decimal_1

  }

  measure: avg_items_per_order  {
    label: "AVG # Items per Order"
    description: "AVG Items per Order per SKU"
    sql: safe_divide(${cnt_of_skus_per_order}, ${cnt_of_orders}) ;;
    value_format_name: decimal_1

  }

########################################################################################################
########################################################################################################
# Measures that we need to add once we join this table in vendor_performance explore\


  measure: pct_order_inbounded {
    label:       "% Fill Rate (PO > Inventory)"
    description: "How many of the ordered items have been inbounded in the hubs on the promised delivery date of the order"
    type: number
    sql: safe_divide(${inventory_changes_daily.sum_inbound_inventory}, ${sum_selling_unit_quantity}) ;;

    value_format_name: percent_1
    html:
    {% if global_filters_and_parameters.show_info._parameter_value == 'yes' %}
    {{ rendered_value }} ({{ sum_selling_unit_quantity._rendered_value }} ordered items)
    {% else %}
    {{ rendered_value }}
    {% endif %}
    ;;
  }

  measure: sum_purchase_price {
    label:       "€ Selling Units (Buying Price)"
    description: "This measure multiplies the supplier price of an item with the number
                  of selling units we ordered and thus provides the cumulative value of the replenished items."
    type: sum
    sql: coalesce((${total_quantity} * ${erp_buying_prices.vendor_price}),0) ;;
    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${erp_buying_prices.table_uuid}) ;;
  }



  measure: count {
    type: count
    hidden: yes
    drill_fields: [name]
  }
}
