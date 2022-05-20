view: matching_inventory_level {
  sql_table_name: `flink-data-prod.curated.matching_inventory_level`
    ;;

#############################################################################
############################### Date Dimensions #############################
#############################################################################


  dimension_group: estimated_delivery {
    label: "Estimated Delivery Date (DESADVS)"
    group_label: "> Date Dimensions <"
    type: time
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
    sql: ${TABLE}.estimated_delivery_date ;;
  }

  dimension_group: inbounded_timestamp {
    group_label: "> Date Dimensions <"
    label: "Inbounded date (DESADVS)"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.inbounded_timestamp ;;
  }

  dimension_group: inbounded_timestamp_adjusted {
    group_label: "> Date Dimensions <"
    label: "Inbounded date Adjusted (Ddvs - Inb)"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.inbounded_timestamp_adjusted ;;
  }

  dimension_group: same_day_inventory_change_timestamp {
    group_label: "> Date Dimensions <"
    label: "Inbound date on same day (Inbound)"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.same_day_inventory_change_timestamp ;;
  }

  dimension_group: whithin_window_matching_inventory_change_timestamp {
    group_label: "> Date Dimensions <"
    label: "Inbound date on time window (Inbound)"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.whithin_window_matching_inventory_change_timestamp ;;
  }

  dimension_group: order {
    group_label: "> Date Dimensions <"
    label: "Order date (PO)"
    type: time
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


  dimension_group: promised_delivery {
    group_label: "> Date Dimensions <"
    label: "Promised Delivery date (PO)"
    type: time
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
    sql: ${TABLE}.promised_delivery_date ;;
  }



#############################################################################
################################ IDs Dimensions #############################
#############################################################################



  dimension: dispatch_notification_id {
    type: string
    sql: ${TABLE}.dispatch_notification_id ;;
    group_label: "> IDs Dimensions <"
    label: "Dispatch Notification ID"
    hidden: yes
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    group_label: "> IDs Dimensions <"
    label: "Hub Code"
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    group_label: "> IDs Dimensions <"
    label: "SKU"
  }

  dimension: vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
    group_label: "> IDs Dimensions <"
    label: "Vendor ID"
  }

  dimension: order_number {
    type: number
    sql: ${TABLE}.order_number ;;
    group_label: "> IDs Dimensions <"
    label: "Order Number"
  }

  dimension: table_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.table_uuid ;;
    group_label: "> IDs Dimensions <"
    label: "Table UUID"
    hidden: yes
  }


#############################################################################
############################## Other Dimensions #############################
#############################################################################

  dimension: inbounding_service {
    type: string
    sql: ${TABLE}.inbounding_service ;;
    group_label: "> Quantity Dimensions <"
    hidden: yes
  }

  dimension: inbounded_quantity {
    type: number
    sql: ${TABLE}.inbounded_quantity ;;
    group_label: "> Quantity Dimensions <"
    label: "Inbounded Sell. U. Quantity (DESADVS)"
  }

  dimension: handling_unit_quantity_purchased {
    type: string
    sql: ${TABLE}.handling_unit_quantity_purchased ;;
    group_label: "> Quantity Dimensions <"
    label: "Purchased Hand. U. Quantity (PO)"

  }

  dimension: selling_unit_quantity_purchased {
    type: string
    sql: ${TABLE}.selling_unit_quantity_purchased ;;
    label: "Purchased Sell. U. Quantity (PO)"
    group_label: "> Quantity Dimensions <"
  }

  dimension: same_day_matching_sum_quantity_change {
    type: number
    sql: ${TABLE}.same_day_matching_sum_quantity_change ;;
    group_label: "> Quantity Dimensions <"
    label: "Inbounded Sell. U. Quantity Strict (Inbound)"
    description: "Inbounded quantity on exact same day (Promised = Inbound Date)"
  }

  dimension: whithin_window_matching_sum_quantity_change {
    type: number
    sql: ${TABLE}.whithin_window_matching_sum_quantity_change ;;
    group_label: "> Quantity Dimensions <"
    label: "Inbounded Sell. U. Quantity Lenient (Inbound)"
    description: "Inbounded quantity on time window (Promised = -12/+6 hs Inbound Date)"
  }

  dimension: total_inbounded_adjusted {
    type: number
    sql: ${TABLE}.total_inbounded_adjusted ;;
    group_label: "> Quantity Dimensions <"
    label: "Inbounded Sell. U. Quantity Adjusted (Inbound)"
    description: "This is the combination between DESADVS and Inbound (Whenever we have DESADVS
    then data from there, othewise from Inbound. And then, in Ibound, whenever is the same day matching,
    the same day otherwise the time window."
  }

  dimension: same_day_matching_sum_quantity_damaged_corrections {
    type: number
    sql: ${TABLE}.same_day_matching_sum_quantity_damaged_corrections ;;
    group_label: "> Quantity Dimensions <"
    label: "Corrected Sell. U. Quantity Damaged (Inbound)"
  }

#############################################################################
################################### Flags ###################################
#############################################################################

dimension: inbounded_on {
  group_label: "> Flags <"
  label: "Delivery Status"
  type: string
  sql: case
          when ${inbounded_timestamp_adjusted_date} > ${promised_delivery_date} then "+6"
          when ${inbounded_timestamp_adjusted_date} < ${promised_delivery_date} then "-12"
          when ${inbounded_timestamp_adjusted_date} = ${promised_delivery_date} then "On time"
          else NULL
       end ;;

}

  measure: over_inbound {
    label: "Over Inbounded"
    group_label: "> Flags <"
    type: yesno
    sql: ${sum_selling_units_inbounded} > ${sum_selling_units_purchased} ;;
  }


#############################################################################
################################## Measures #################################
#############################################################################


  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }

#Order count on time delivered

  measure: count_orders_promised {
    group_label: "> Measures (Order Count) <"
    label: "COUNT Orders Promised"
    type: count_distinct
    sql: ${order_number} ;;
    drill_fields: []
  }

  measure: count_orders_delivered {
    group_label: "> Measures (Order Count) <"
    label: "COUNT Orders Delivered"
    type: count_distinct
    sql: ${order_number} ;;
    filters: [inbounded_timestamp_adjusted_date: "Not Null",
              inbounded_on: "On time"]
  }


  measure: on_time_orders {
    group_label: "> Measures (Order Count) <"
    label: "% On Time Orders"
    type: number
    sql: nullif(${count_orders_delivered},0) / nullif(${count_orders_promised},0) ;;
    value_format: "0.00%"

  }

#Fill rate

  measure: sum_handling_units_purchased{
    group_label: "> Measures (Fill Rate) <"
    label: "SUM Hand. U. Purchased"
    type: sum
    sql: cast(${handling_unit_quantity_purchased} as numeric) ;;

  }

  measure: sum_selling_units_purchased{
    group_label: "> Measures (Fill Rate) <"
    label: "SUM Sell. U. Purchased"
    type: sum
    sql: cast(${selling_unit_quantity_purchased} as integer) ;;

  }

  measure: sum_selling_units_inbounded{
    group_label: "> Measures (Fill Rate) <"
    label: "SUM Sell. U. Inbounded"
    type: sum
    sql: ${total_inbounded_adjusted}  ;;

  }


  measure: fill_rate {
    group_label: "> Measures (Fill Rate) <"
    label: "% Fill Rate"
    type: number
    sql: nullif(${sum_selling_units_inbounded},0) / nullif(${sum_selling_units_purchased},0) ;;
    value_format: "0.00%"

  }

#Corrections

  measure: sum_selling_units_corrected{
    group_label: "> Measures (Corrections) <"
    label: "SUM Sell. U. Corrected"
    type: sum
    sql: cast(${same_day_matching_sum_quantity_damaged_corrections} as integer) * -1 ;;

  }

  measure: damage_rate {
    group_label: "> Measures (Corrections) <"
    label: "% Damage Rate"
    type: number
    sql: ${sum_selling_units_corrected} / nullif(${sum_selling_units_inbounded},0) ;;
    value_format: "0.00%"

  }


#Over-Inbound

  measure: over_inbound_rate {
    group_label: "> Measures (Over Inbound) <"
    label: "Over Inbound Rate"
    type: number
    sql:
     case
    when ${over_inbound} then
    (nullif(${sum_selling_units_inbounded},0) - nullif(${sum_selling_units_purchased},0)) / nullif(${sum_selling_units_purchased},0)
    else 0
    end
    ;;
    value_format: "0.00%"

  }


}
