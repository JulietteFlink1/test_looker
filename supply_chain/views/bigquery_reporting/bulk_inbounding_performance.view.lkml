view: bulk_inbounding_performance {
  sql_table_name: `flink-data-dev.reporting.bulk_inbounding_performance`
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
  dimension: sku_mapping_status {

    label:       "SKU Mapping Status"
    description: "Defines, whether the inbounding service could match an external SKU with our internal SKU, if there is manual decision needed or no match found at all."
    type: string
    sql: ${TABLE}.sku_mapping_status ;;
  }

  dimension: provider_name {

    label:       "Vendor Name"
    description: "The vendor name accoring to the dispatch notification"

    type: string
    sql: ${TABLE}.provider_name ;;
  }

  dimension: minutes_inbounding_start_to_item_inbounded {

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

  dimension: is_first_inbounded_bulk {

    label: "Is First Inbounded Bulk"
    description: "Boolean, that defines whether a inbounded item of a bulk was the first inbounded bulk per dispatch notification"

    type: yesno
    sql: ${TABLE}.is_first_inbounded_bulk ;;

  }

  dimension: number_of_bulks_per_dispatch_notification {

    label: "# Bulks per Dispatch Notification"
    description: "Defines the total number of bulks/rollies per dispatch notification"

    type: number
    sql: ${TABLE}.number_of_bulks_per_dispatch_notification ;;

    value_format_name: decimal_0

    hidden: yes

  }





  # =========  dates / timestamps   =========
  dimension_group: first_bulk_inbounding_timestamp {

    label: "First Bulk Inbounding"

    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.first_bulk_inbounding_timestamp ;;
  }

  dimension_group: inventory_change_timestamp {

    label:       "Inbounding"
    description: "The datetime, when a SKU was inbounded"

    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.inventory_change_timestamp ;;
  }

  dimension: inbounding_date {

    label: "Dispatch Notification Date"
    type: date
    datatype: date
    sql: ${TABLE}.inbounding_date ;;
    hidden: yes
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
  dimension: bulk_inbounding_rank {
    type: number
    sql: ${TABLE}.bulk_inbounding_rank ;;
    hidden: yes
  }

  dimension: total_handling_units {
    type: number
    sql: ${TABLE}.total_handling_units ;;
    hidden: yes
  }

  dimension: total_quantity_delivered {
    type: number
    sql: ${TABLE}.total_quantity_delivered ;;
    hidden: yes
  }

  dimension: total_quantity_per_handling_unit {
    type: number
    sql: ${TABLE}.total_quantity_per_handling_unit ;;
    hidden: yes
  }

  dimension: total_quantity_delivered_per_dispatch_notification {
    type: number
    sql: ${TABLE}.total_quantity_delivered_per_dispatch_notification ;;
    hidden: yes
  }

  dimension: total_quantity_delivered_per_dispatch_notification_category {
    type: number
    sql: ${TABLE}.total_quantity_delivered_per_dispatch_notification_category ;;
    hidden: yes
  }

  dimension: run_sum_items_inbounded_per_dispatch_notification {
    type: number
    sql: ${TABLE}.run_sum_items_inbounded_per_dispatch_notification ;;
    hidden: yes
  }

  dimension: run_sum_items_inbounded_per_dispatch_notification_category {
    type: number
    sql: ${TABLE}.run_sum_items_inbounded_per_dispatch_notification_category ;;
    hidden: yes
  }

  dimension: items_inbounded {
    type: number
    sql: ${TABLE}.items_inbounded ;;
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






  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  measure: avg_bulk_inbounding_rank {

    label:       "AVG Inbounding Rank (Dispatch Notification)"
    description: "Defines, on which order a certain rollie of a dispatch notification was inbounded"

    type: average
    sql: ${bulk_inbounding_rank} ;;

    value_format_name: decimal_0
  }

  measure: sum_items_inbounded {

    label: "# Items Inbounded"
    description: "The number of inbounded products via the bulk-inbounding service"

    type: sum
    sql: ${items_inbounded} ;;

    value_format_name: decimal_0
  }

  measure: sum_items_inbounded_after_2h {

    label:       "# Items Inbounded after 2h"
    description: "The number of inbounded products within 2 hours since first bulk of dispatch notification inbounded via the bulk-inbounding service"

    type: sum
    sql: ${items_inbounded} ;;

    filters: [minutes_inbounding_start_to_item_inbounded: "<= 2"]

    value_format_name: decimal_0
  }

  measure: avg_number_of_bulks_per_dispatch_notification {

    label: "AVG # Bulks per Dispatch Notification"
    description: "Defines the total number of bulks/rollies per dispatch notification"

    type: average
    sql: ${number_of_bulks_per_dispatch_notification} ;;

    value_format_name: decimal_0

  }

  measure: sum_total_handling_units {

    label:       "# Handling Units (Dispatch Notification)"
    description: "The sum of handling units according to the dispatch notification"

    type: sum
    sql: ${total_handling_units} ;;

    value_format_name: decimal_0

  }

  measure: sum_total_quantity_delivered {

    label: "# Selling Units  (Dispatch Notification)"
    description: "The sum of selling units according to the dispatch notification"

    type: sum
    sql: ${total_quantity_delivered} ;;

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


  measure: avg_hours_required_to_book_in_90_percent {

    label:       "AVG Hours Required to Book-In 90%"
    description: "The average number of hours it takes to inbound 90% of the selling units of a dispatch notification "

    type: average
    sql: ${minutes_inbounding_start_to_item_inbounded} ;;
    filters: [ninety_pct_inbounded: "yes"]

    value_format_name: decimal_1
  }


  measure: count {
    type: count
    drill_fields: [provider_name]
  }
}
