view: bulk_inbounding_performance {
  sql_table_name: `flink-data-prod.reporting.bulk_inbounding_performance`
    ;;

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


  dimension: provider_name {

    label:       "Vendor Name"
    description: "The vendor name accoring to the dispatch notification"

    type: string
    sql: ${TABLE}.provider_name ;;
  }

  dimension: hours_inbounding_start_to_item_inbounded {

    label:       "# Hours Bulk Inbounded"
    description: "The duration in hours between bulk-inbounding process started (first bulk inbounded) and sku inbounding time"

    type: number
    sql: ${TABLE}.minutes_inbounding_start_to_item_inbounded / 60 ;;

    value_format_name: decimal_2
    hidden: yes
  }

  dimension: percent_dispatch_category_inbounded {

    label: "% of Category inbounded"
    description: "The percent of items of a category (in the scope of a dispatch notification) that are inbounded compared to the total number of items of a category per dispatch notification"

    type: number
    sql: ${TABLE}.percent_dispatch_category_inbounded ;;

    value_format_name: percent_0

    hidden: yes
  }

  dimension: percent_dispatch_inbounded {

    label: "% of Dispatch Notification inbounded"
    description: "The percent of items, that are inbounded compared to all items of a dispatch notification"

    type: number
    sql: ${TABLE}.percent_dispatch_inbounded ;;

    value_format_name: percent_0

    hidden: yes
  }







  # =========  dates / timestamps   =========
  dimension_group: inbounding_timestamp {

    label:       "Inbounding"
    description: "The datetime, when a SKU was inbounded"

    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.inbounding_timestamp ;;
  }

  dimension: first_bulk_inbounding_date {

    label: "Dispatch Notification Date"
    type: date
    datatype: date
    sql: ${TABLE}.first_bulk_inbounding_date ;;
    hidden: no
  }


  # =========  join / filter fields   =========
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    hidden: yes
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    hidden: yes
  }

  dimension: parent_cateogory {
    type: string
    sql: ${TABLE}.parent_cateogory ;;
    hidden: yes
  }

  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }


  dimension: dispatch_notification_id {

    label: "Dispatch Notification ID"
    description: "The indentifier of a dispatch notification / purchase receipt. One dispatch notification contains one ore more bulks / rollies"
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.dispatch_notification_id ;;

  }








  # =========  hidden   =========


  dimension: delivered_handling_units_count {
    type: number
    sql: ${TABLE}.delivered_handling_units_count ;;
    hidden: yes
  }

  dimension: delivered_total_quantity {
    type: number
    sql: ${TABLE}.delivered_total_quantity ;;
    hidden: yes
  }

  dimension: delivered_quantity_per_handling_unit {
    type: number
    sql: ${TABLE}.delivered_quantity_per_handling_unit ;;
    hidden: yes
  }

  dimension: delivered_total_quantity_per_dispatch_notification {
    type: number
    sql: ${TABLE}.delivered_total_quantity_per_dispatch_notification ;;
    hidden: yes
  }

  dimension: delivered_total_quantity_per_dispatch_notification_and_category {
    type: number
    sql: ${TABLE}.delivered_total_quantity_per_dispatch_notification_and_category ;;
    hidden: yes
  }

  dimension: run_sum_inbounded_quantity_per_dispatch_notification {
    type: number
    sql: ${TABLE}.run_sum_inbounded_quantity_per_dispatch_notification ;;
    hidden: yes
  }

  dimension: run_sum_inbounded_quantity_per_dispatch_notification_and_category {
    type: number
    sql: ${TABLE}.run_sum_inbounded_quantity_per_dispatch_notification_and_category ;;
    hidden: yes
  }

  dimension: inbounded_quantity {
    type: number
    sql: ${TABLE}.inbounded_quantity ;;
    hidden: yes
  }

  dimension: ninety_pct_inbounded {
    type: yesno
    sql: ${TABLE}.ninety_pct_inbounded ;;
    hidden: yes
  }

  dimension: ninety_pct_inbounded_per_cat {
    type: yesno
    sql: ${TABLE}.ninety_pct_inbounded_per_cat ;;
    hidden: yes
  }

  dimension: is_90_percent_inbounded_timestamp {

    type: yesno
    sql: ${TABLE}.is_90_percent_inbounded_timestamp ;;
    hidden: yes
  }






  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: sum_items_inbounded {

    label: "# Items Inbounded"
    description: "The number of inbounded products via the bulk-inbounding service"

    type: sum
    sql: ${inbounded_quantity} ;;

    value_format_name: decimal_0
  }

  measure: sum_items_inbounded_after_2h {

    label:       "# Items Inbounded after 2h"
    description: "The number of inbounded products within 2 hours since first bulk of dispatch notification inbounded via the bulk-inbounding service"

    type: sum
    sql: ${inbounded_quantity} ;;

    filters: [hours_inbounding_start_to_item_inbounded: "<= 2"]

    value_format_name: decimal_0
  }

  measure: sum_items_inbounded_after_3h {

    label:       "# Items Inbounded after 3h"
    description: "The number of inbounded products within 2 hours since first bulk of dispatch notification inbounded via the bulk-inbounding service"

    type: sum
    sql: ${inbounded_quantity} ;;

    filters: [hours_inbounding_start_to_item_inbounded: "<= 3"]

    value_format_name: decimal_0
  }



  measure: sum_total_handling_units {

    label:       "# Handling Units (Dispatch Notification)"
    description: "The sum of handling units according to the dispatch notification"

    type: sum
    sql: ${delivered_handling_units_count} ;;

    value_format_name: decimal_0

  }

  measure: sum_total_quantity_delivered {

    label: "# Selling Units  (Dispatch Notification)"
    description: "The sum of selling units according to the dispatch notification"

    type: sum
    sql: ${delivered_total_quantity} ;;

    value_format_name: decimal_0
  }




  measure:pct_items_booked_in_same_day {

    # this logic works, as we are joining currently bulks with inboundins from inventory_changes on the inbounding_date
    # thus implicitely, only items, that have the same day as the dispatch notification will be considered

    label:       "% Products Booked-In Same Day"
    description: "The number of products per dispatch notification, that are inbounded in the same (delivery) day"

    type: number
    sql: safe_divide(${sum_items_inbounded}, ${sum_total_quantity_delivered}) ;;

    value_format_name: percent_0
  }

  measure:pct_items_booked_after_2h{

    # this logic works, as we are joining currently bulks with inboundins from inventory_changes on the inbounding_date
    # thus implicitely, only items, that have the same day as the dispatch notification will be considered

    label:       "% Products Booked-In 2h"
    description: "The number of products per dispatch notification, that are inbounded within the first 2 hours since first bulk-item of dispatch notification inbounded"

    type: number
    sql: safe_divide(${sum_items_inbounded_after_2h}, ${sum_total_quantity_delivered}) ;;

    value_format_name: percent_0
  }

  measure:pct_items_booked_after_3h{

    # this logic works, as we are joining currently bulks with inboundins from inventory_changes on the inbounding_date
    # thus implicitely, only items, that have the same day as the dispatch notification will be considered

    label:       "% Products Booked-In 3h"
    description: "The number of products per dispatch notification, that are inbounded within the first 3 hours since first bulk-item of dispatch notification inbounded"

    type: number
    sql: safe_divide(${sum_items_inbounded_after_3h}, ${sum_total_quantity_delivered}) ;;

    value_format_name: percent_0
  }


  measure: avg_hours_required_to_book_in_90_percent {

    label:       "AVG Hours Required to Book-In 90%"
    description: "The average number of hours it takes to inbound 90% of the selling units of a dispatch notification "

    type: average
    sql: ${hours_inbounding_start_to_item_inbounded} ;;
    filters: [is_90_percent_inbounded_timestamp: "yes"]

    value_format_name: decimal_1
  }


  measure: count {
    type: count
    drill_fields: [provider_name]
  }
}
