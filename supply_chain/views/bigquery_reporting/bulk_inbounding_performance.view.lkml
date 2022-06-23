view: bulk_inbounding_performance {
  sql_table_name: `flink-data-prod.reporting.bulk_inbounding_performance`;;

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
  dimension: dispatch_notification_id {

    label:       "Dispatch Notification ID"
    description: "The indentifier of a dispatch notification / purchase receipt. One dispatch notification contains one ore more bulks / rollies"
    group_label: ">> IDs"

    type: string
    sql: ${TABLE}.dispatch_notification_id ;;
  }

  dimension: provider_name {

    label:       "Vendor Name"
    description: "The vendor name accoring to the dispatch notification"

    type: string
    sql: ${TABLE}.provider_name ;;
  }

  dimension: inbounding_service {

    label:       "Inbounding Service"
    description: "Indicates, whether the inbounding happened through the bulk-inbounding-service or manually item per item"

    type: string
    sql: ${TABLE}.inbounding_service ;;
    hidden: yes
  }


  # =========  Dates / Timestamps   =========
  dimension: estimated_delivery_date {
    type: date
    datatype: date
    sql: ${TABLE}.estimated_delivery_date ;;
  }

  dimension_group: start_150_timestamp {
    type: time
    sql: ${TABLE}.start_150_timestamp ;;
  }

  dimension_group: inbounding_timestamp {

    label:       "Inbounding"
    description: "The datetime, when a SKU was inbounded"

    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.inbounded_timestamp ;;
  }


  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }


  # =========  hidden   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
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

  dimension: delivered_handling_units {
    type: number
    sql: ${TABLE}.delivered_handling_units ;;
    hidden: yes
  }

  dimension: delivered_quantity_per_handling_unit {
    type: number
    sql: ${TABLE}.delivered_quantity_per_handling_unit ;;
    hidden: yes
  }

  dimension: delivered_quantity {
    type: number
    sql: ${TABLE}.delivered_quantity ;;
    hidden: yes
  }

  dimension: inbounded_quantity {
    type: number
    sql: ${TABLE}.inbounded_quantity ;;
    hidden: yes
  }

  dimension: minutes_since_start_150 {
    type: number
    sql: ${TABLE}.minutes_since_start_150 ;;
    hidden: yes
  }

  dimension: delivered_quantity_per_dispatch_notification {
    type: number
    sql: ${TABLE}.delivered_quantity_per_dispatch_notification ;;
    hidden: yes
  }

  dimension: run_sum_inbounded_quantity_per_dispatch_notification {
    type: number
    sql: ${TABLE}.run_sum_inbounded_quantity_per_dispatch_notification ;;
    hidden: yes
  }

  dimension: percent_dispatch_inbounded {
    type: number
    sql: ${TABLE}.percent_dispatch_inbounded ;;
    hidden: yes
  }

  dimension: minutes_90_percent_inbounded {
    type: number
    sql: ${TABLE}.minutes_90_percent_inbounded ;;
    hidden: yes
  }

  dimension: percent_goods_inbounded_same_day {
    type: number
    sql: ${TABLE}.percent_goods_inbounded_same_day ;;
    hidden: yes
  }

  dimension: percent_goods_inbounded_within_2h {
    type: number
    sql: ${TABLE}.percent_goods_inbounded_within_2h ;;
    hidden: yes
  }

  dimension: percent_goods_inbounded_within_3h {
    type: number
    sql: ${TABLE}.percent_goods_inbounded_within_3h ;;
    hidden: yes
  }

  dimension: ninety_pct_inbounded {
    type: yesno
    sql: ${TABLE}.ninety_pct_inbounded ;;
    hidden: yes
  }

  dimension: is_last_booked_in_same_day {
    type: yesno
    sql: ${TABLE}.is_last_booked_in_same_day ;;
    hidden: yes
  }

  dimension: is_2_hours_passed {
    type: yesno
    sql: ${TABLE}.is_2_hours_passed ;;
    hidden: yes
  }

  dimension: is_3_hours_passed {
    type: yesno
    sql: ${TABLE}.is_3_hours_passed ;;
    hidden: yes
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    hidden: yes
  }

  dimension: delivered_quantity_per_dispatch_notification_and_category {
    type: number
    sql: ${TABLE}.delivered_quantity_per_dispatch_notification_and_category ;;
    hidden: yes
  }

  dimension: run_sum_inbounded_quantity_per_dispatch_notification_and_category {
    type: number
    sql: ${TABLE}.run_sum_inbounded_quantity_per_dispatch_notification_and_category ;;
    hidden: yes
  }

  dimension: percent_dispatch_category_inbounded {
    type: number
    sql: ${TABLE}.percent_dispatch_category_inbounded ;;
    hidden: yes
  }

  dimension: percent_goods_inbounded_within_2h_per_category {
    type: number
    sql: ${TABLE}.percent_goods_inbounded_within_2h_per_category ;;
    hidden: yes
  }

  dimension: percent_goods_inbounded_within_3h_per_category {
    type: number
    sql: ${TABLE}.percent_goods_inbounded_within_3h_per_category ;;
    hidden: yes
  }

  dimension: ninety_pct_inbounded_per_cat {
    type: yesno
    sql: ${TABLE}.ninety_pct_inbounded_per_cat ;;
    hidden: yes
  }

  dimension: is_2_hours_passed_per_category {
    type: yesno
    sql: ${TABLE}.is_2_hours_passed_per_category ;;
    hidden: yes
  }

  dimension: is_3_hours_passed_per_category {
    type: yesno
    sql: ${TABLE}.is_3_hours_passed_per_category ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: sum_items_inbounded {

    label:       "# Items Inbounded"
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

    filters: [minutes_since_start_150: "<= 120"]

    value_format_name: decimal_0
  }

  measure: sum_items_inbounded_after_3h {

    label:       "# Items Inbounded after 3h"
    description: "The number of inbounded products within 2 hours since first bulk of dispatch notification inbounded via the bulk-inbounding service"

    type: sum
    sql: ${inbounded_quantity} ;;

    filters: [minutes_since_start_150: "<= 180"]

    value_format_name: decimal_0
  }



  measure: sum_total_handling_units {

    label:       "# Handling Units (Dispatch Notification)"
    description: "The sum of handling units according to the dispatch notification"

    type: sum
    sql: ${delivered_handling_units} ;;

    value_format_name: decimal_0

  }

  measure: sum_total_quantity_delivered {

    label:       "# Selling Units  (Dispatch Notification)"
    description: "The sum of selling units according to the dispatch notification"

    type: sum
    sql: ${delivered_quantity} ;;

    value_format_name: decimal_0
  }



  measure:pct_items_booked_in_same_day {

    # this logic works, as we are joining currently bulks with inboundins from inventory_changes on the inbounding_date
    # thus implicitely, only items, that have the same day as the dispatch notification will be considered

    label:       "% Products Booked-In Same Day"
    description: "The number of products per dispatch notification, that are inbounded in the same (delivery) day"

    type: average
    sql: ${percent_goods_inbounded_same_day} ;;

    value_format_name: percent_1
  }

  measure:pct_items_booked_after_2h {

    # this logic works, as we are joining currently bulks with inboundins from inventory_changes on the inbounding_date
    # thus implicitely, only items, that have the same day as the dispatch notification will be considered

    label:       "% Products Booked-In 2h"
    description: "The number of products per dispatch notification, that are inbounded within the first 2 hours since first 150 items inbounded"

    type: average
    sql: ${percent_goods_inbounded_within_2h} ;;

    value_format_name: percent_1
  }

  measure:pct_items_booked_after_2h_cateogry{

    # this logic works, as we are joining currently bulks with inboundins from inventory_changes on the inbounding_date
    # thus implicitely, only items, that have the same day as the dispatch notification will be considered

    label:       "% Products Booked-In 2h (Category)"
    description: "The number of products per dispatch notification and product category, that are inbounded within the first 2 hours since first 150 items inbounded"

    type: average
    sql: ${percent_goods_inbounded_within_2h_per_category} ;;

    value_format_name: percent_1
  }

  measure:pct_items_booked_after_3h{

    # this logic works, as we are joining currently bulks with inboundins from inventory_changes on the inbounding_date
    # thus implicitely, only items, that have the same day as the dispatch notification will be considered

    label:       "% Products Booked-In 3h"
    description: "The number of products per dispatch notification, that are inbounded within the first 3 hours since first 150 items inbounded"

    type: average
    sql: ${percent_goods_inbounded_within_3h} ;;

    value_format_name: percent_1
  }

  measure:pct_items_booked_after_3h_cateogry{

    # this logic works, as we are joining currently bulks with inboundins from inventory_changes on the inbounding_date
    # thus implicitely, only items, that have the same day as the dispatch notification will be considered

    label:       "% Products Booked-In 3h (Category)"
    description: "The number of products per dispatch notification and product category, that are inbounded within the first 3 hours since first 150 items inbounded"

    type: average
    sql: ${percent_goods_inbounded_within_3h_per_category} ;;

    value_format_name: percent_1
  }


  measure: avg_hours_required_to_book_in_90_percent {

    label:       "AVG Hours Required to Book-In 90%"
    description: "The average number of hours it takes to inbound 90% of the selling units of a dispatch notification "

    type: average
    sql: (${minutes_90_percent_inbounded}/60) ;;

    value_format_name: decimal_1
  }


}
