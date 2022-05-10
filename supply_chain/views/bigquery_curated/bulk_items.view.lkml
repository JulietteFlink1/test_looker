# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view

# explore: bulk_items {
#   hidden: yes

#   join: bulk_items__internal_sku_array {
#     view_label: "Bulk Items: Internal Sku Array"
#     sql: LEFT JOIN UNNEST(${bulk_items.internal_sku_array}) as bulk_items__internal_sku_array ;;
#     relationship: one_to_many
#   }

#   join: bulk_items__replenishment_substitute_group_array {
#     view_label: "Bulk Items: Replenishment Substitute Group Array"
#     sql: LEFT JOIN UNNEST(${bulk_items.replenishment_substitute_group_array}) as bulk_items__replenishment_substitute_group_array ;;
#     relationship: one_to_many
#   }
# }

view: bulk_items {
  sql_table_name: `flink-data-prod.curated.bulk_items`
    ;;
  drill_fields: [bulk_items_id]


    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;

  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }




  # =========  __main__   =========
  dimension: bulk_inbounding_rank {

    label:       "Bulk Inboundong Rank"
    description: "The rank, when a specific bulk/rollie within a dispatch notification was scanned (with 1 beeing the first scanned bulk)."

    type: number
    sql: ${TABLE}.bulk_inbounding_rank ;;

    value_format_name: decimal_0

  }

  dimension: number_of_bulks_per_dispatch_notification {

    label:       "Bulks per dispatch notification"
    description: "This field defines, how many bulks were contained in a specific dispatch notification"

    type: number
    sql: ${TABLE}.number_of_bulks_per_dispatch_notification ;;

    value_format_name: decimal_0
  }

  dimension: sku_mapping_status {

    label:       "Mapping Status"
    description: "This fields indicates, if a certain SKU was automatically matched with the external SKU, if there were manual checks needed or whether no match was found"

    type: string
    sql: ${TABLE}.sku_mapping_status ;;
  }

  dimension: inbound_status {

    label:       "Inbounding Status"
    description: "This field indicates, if the bulks of the dispatch notification were inbounded through the hub-tech inbounding service"

    type: string
    sql: ${TABLE}.inbound_status ;;
  }


  dimension: is_first_inbounded_bulk {

    label:       "Is First Inbounded Bulk"
    description: "This field indicates, if a bulk is the first inbounded per dispatch notification"

    type: yesno
    sql: ${TABLE}.is_first_inbounded_bulk ;;
  }

  dimension: provider_name {

    label:       "Supplier Name"
    description: "The name of the supplier (accoridng to bulk-inbounding service)"

    type: string
    sql: ${TABLE}.provider_name ;;
  }


  # =========  New dimension added on 6-5-2022   =========


  dimension: dispatch_advice_number {

    label:       "Dispatch Advice Number"
    type: string
    sql: ${TABLE}.dispatch_advice_number ;;
  }


  dimension: sscc {

    label:       "SSCC"
    type: string
    sql: ${TABLE}.sscc ;;
  }


  dimension: warehouse_number {

    label:       "Warehouse Number"
    type: string
    sql: ${TABLE}.warehouse_number ;;
  }

  dimension: warehouse_number_array {

    label:       "All Possible Warehouse Numbers"
    type: string
    sql: ${TABLE}.all_possible_warehouse_numbers ;;
  }


  dimension: order_number {

    label:       "Order Number"
    type: string
    sql: ${TABLE}.order_number ;;
  }


  dimension: order_number_array {

    label:       "All Possible Order Numbers"
    type: string
    sql: ${TABLE}.all_possible_order_numbers ;;
  }



  dimension_group: loaded_in_truck_timestamp {

    label:       "Loaded in truck"
    description: "The datetime, when the everything was loaded in the truck (comes from suppliers)"

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
    sql: ${TABLE}.loaded_in_truck_timestamp ;;
  }



  # =========  timestamps   =========
  dimension_group: first_bulk_inbounding_timestamp {

    label:       "First Bulk Inbounding"
    description: "The datetime, when the first bulk within a dispatch notification was inbounded"

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
    sql: ${TABLE}.first_bulk_inbounding_timestamp ;;
  }

  dimension_group: inbounded_timestamp {

    label:       "Bulk Inbounding"
    description: "The datetime, when a specific bulk was inbounded"

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

  dimension_group: inbounding_duration {

    label:       "Inbounding Duration since first Bulk-Inbound"
    description: "This field defines the time between the first inbounding time of a bulk compared to the actual inbounded bulk within the scope of a dispatch notification"

    type: duration
    intervals: [minute, hour, day]

    sql_start: ${TABLE}.first_bulk_inbounding_timestamp ;;
    sql_end: ${TABLE}.inbounded_timestamp ;;
  }

  dimension: days_between {

    type: number
    sql: date_diff(${first_bulk_inbounding_timestamp_date}, ${first_bulk_inbounding_timestamp_date}, day) ;;
  }


  # =========  hidden   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: no
    primary_key: yes
  }

  dimension: replenishment_substitute_group_array {
    hidden: no
    sql: ${TABLE}.replenishment_substitute_group_array ;;
  }

  dimension: internal_sku_array {
    hidden: no
    sql: ${TABLE}.internal_sku_array ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    hidden: no
  }

  dimension: handling_units_count {
    type: number
    sql: ${TABLE}.handling_units_count ;;
    hidden: no
  }

  dimension: quantity_per_handling_unit {
    type: number
    sql: ${TABLE}.quantity_per_handling_unit ;;
    hidden: no
  }


  dimension: total_quantity {
    type: number
    sql: ${TABLE}.total_quantity ;;
    hidden: no
  }




  # =========  IDs   =========
  dimension: dispatch_notification_id {

    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.dispatch_notification_id ;;
  }

  dimension: bulk_id {

    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.bulk_id ;;

  }

  dimension: bulk_items_id {

    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.bulk_items_id ;;

  }

  dimension: external_sku {

    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.external_sku ;;

  }

  dimension: provider_id {

    label:        "External Supplier ID"
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.provider_id ;;
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

    type: average
    sql: ${number_of_bulks_per_dispatch_notification} ;;

    value_format_name: decimal_0
  }

  measure: sum_total_quantity {

    label:       "# Selling Units"
    description: "The sum of all products (selling units)"

    type: sum
    sql: ${total_quantity} ;;

    value_format_name: decimal_0
  }

  measure: sum_number_of_bulks {

    label:       "# Bulks"
    description: "The total number of bulks"

    type: count_distinct
    sql: ${bulk_id} ;;

    value_format_name: decimal_0
  }

  measure: sum_number_of_bulks_booked_in_same_day {

    label:       "# Bulks inbounded on delivery day"
    description: "The number of bulks, that were inbounded in the same they of the delivery (more precise: the day of the first inbounding of a bulk within a dispatch notification)"

    type: count_distinct
    sql: ${bulk_id};;
    filters: [days_inbounding_duration: "0"]

    value_format_name: decimal_0
  }

  measure: pct_bulks_inbounded_same_day{

    label:       "% Bulks inbounded same day"
    description: "The number of bulks that are inbounded on the day of the first inbounding compared to all bulks of a dispatch notification"

    type: number
    sql: safe_divide(${sum_number_of_bulks_booked_in_same_day}, ${sum_number_of_bulks}) ;;

    value_format_name: percent_1
  }

 # measure: sum_number_of_bulks_FV_booked_in_2h {

#    label:       "# Bulks F&V inbounded within 2h"
#    description: "The number of bulks, that contain fruits and vegetables and were inbounded within 2 hours."
#
#    type: count_distinct
#    sql: ${bulk_id};;
#    filters: [minutes_inbounding_duration: "-500", products.category: "Obst & Gemüse"]
#
#    value_format_name: decimal_0
#  }
#
#  measure: sum_number_of_bulks_FV {
#
#    label:       "# Bulks F&V"
#    description: "The number of bulks, that contain fruits and vegetables"
#
#    type: count_distinct
#    sql: ${bulk_id};;
#    filters: [products.category: "Obst & Gemüse"]
#
#    value_format_name: decimal_0
#  }
#
#
  measure: sum_number_of_dispatch_notifications {

    label:       "# Dispatch Notifications"
    description: "The total number of dispatch notifications"

    type: count_distinct
    sql: ${dispatch_notification_id} ;;

    value_format_name: decimal_0
  }

  measure: count {
    type: count
    drill_fields: [bulk_items_id, product_name, provider_name]
  }
}
