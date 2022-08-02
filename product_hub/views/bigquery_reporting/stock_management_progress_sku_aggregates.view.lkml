# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-07-14

view: stock_management_progress_sku_aggregates {
  sql_table_name: `flink-data-prod.reporting.stock_management_progress_sku_aggregates`
    ;;

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ### Primary Key ###

  dimension: table_uuid {
    type: string
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.table_uuid ;;
  }

  ### Dates ###
  dimension_group: event {
    group_label: "Date Dimensions"
    label: ""
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
    sql: ${TABLE}.event_date ;;
  }

  ### Location Atributes ###

  dimension: country_iso {
    group_label: "Location Dimensions"
    label: "Country ISO"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    group_label: "Location Dimensions"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  ### Employee Attributes ###

  dimension: employee_id {
    group_label: "Employee Attributes"
    type: string
    sql: ${TABLE}.employee_id ;;
  }


  ### Inventory Process Attributes ###

  dimension: inventory_movement_id {
    group_label: "Inventory Process Attributes"
    type: string
    sql: ${TABLE}.inventory_movement_id ;;
  }

  dimension: direction {
    group_label: "Inventory Process Attributes"
    type: string
    sql: ${TABLE}.direction ;;
  }

  dimension_group: cart_created_time {
    group_label: "Inventory Process Attributes"
    type: time
    timeframes: [
      raw
    ]
    sql: ${TABLE}.cart_created_time ;;
  }

  dimension_group: dropping_list_created_time {
    group_label: "Inventory Process Attributes"
    type: time
    timeframes: [
      raw
    ]
    sql: ${TABLE}.dropping_list_created_time ;;
  }

  dimension_group: dropping_list_finished_time {
    group_label: "Inventory Process Attributes"
    type: time
    timeframes: [
      raw
    ]
    sql: ${TABLE}.dropping_list_finished_time ;;
  }

  ### Product Attributes ###

  dimension: category {
    group_label: "Product Attributes"
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: units_per_handling_unit {
    group_label: "Product Attributes"
    type: string
    sql: ${TABLE}.units_per_handling_unit ;;
  }

  dimension: is_ean_available {
    group_label: "Product Attributes"
    type: yesno
    sql: ${TABLE}.is_ean_available ;;
  }

  dimension: is_handling_unit {
    group_label: "Product Attributes"
    type: yesno
    sql: ${TABLE}.is_handling_unit ;;
  }

  dimension: is_scanned_item {
    group_label: "Product Attributes"
    type: yesno
    sql: ${TABLE}.is_scanned_item ;;
  }

  dimension: product_name {
    group_label: "Product Attributes"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: sku {
    group_label: "Product Attributes"
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension_group: item_added_to_cart_time {
    group_label: "Product Attributes"
    type: time
    timeframes: [
      raw,
      date,
      hour
    ]
    sql: ${TABLE}.item_added_to_cart_time ;;
  }

  dimension_group: item_dropped_time {
    group_label: "Product Attributes"
    type: time
    timeframes: [
      raw,
      date,
      hour
    ]
    sql: ${TABLE}.item_dropped_time ;;
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Measures.      ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ### Time to metrics ###

  dimension: cart_to_drop_list_seconds {
    group_label: "Inventory Process Attributes"
    description: "Difference in seconds between cart_created_time and dropping_list_created_time timestamps"
    type: number
    value_format: "0"
    sql: DATETIME_DIFF(dropping_list_created_time,cart_created_time, SECOND) ;;
  }

  dimension: drop_list_created_to_finished_seconds {
    group_label: "Inventory Process Attributes"
    description: "Difference in seconds between dropping_list_created_time and dropping_list_finished_time timestamps"
    type: number
    value_format: "0"
    sql: DATETIME_DIFF(dropping_list_finished_time, dropping_list_created_time, SECOND) ;;
  }

  dimension: cart_to_finished_seconds {
    group_label: "Inventory Process Attributes"
    description: "Difference in seconds between cart_created_time and dropping_list_finished_time timestamps"
    type: number
    value_format: "0"
    sql: DATETIME_DIFF(dropping_list_finished_time, cart_created_time, SECOND) ;;
  }

  dimension: cart_to_dropped_seconds {
    group_label: "Product Attributes"
    description: "Difference in seconds between item_added_to_cart_time and item_dropped_time timestamps"
    type: number
    value_format: "0"
    sql: DATETIME_DIFF(item_dropped_time, item_added_to_cart_time, SECOND) ;;
  }

  ### Sum and count Metrics ###

  measure: count {
    type: count
    drill_fields: [product_name]
  }

  measure: quantity {
    type: sum
    group_label: "Total Metrics"
    label: "# Units"
    sql: ${TABLE}.quantity ;;
  }

  measure: total_item_added_to_cart {
    group_label: "Total Metrics"
    label: "# Items Added To Cart"
    type: sum
    sql: if(${TABLE}.number_of_item_added_to_cart>0, ${TABLE}.quantity,null) ;;
  }

  measure: total_item_dropped {
    group_label: "Total Metrics"
    label: "# Items Dropped"
    type: sum
    sql: if(${TABLE}.number_of_item_dropped>0, ${TABLE}.quantity,null) ;;
  }

  measure: total_item_removed_from_cart {
    group_label: "Total Metrics"
    label: "# Items Removed From Cart"
    type: sum
    sql: if(${TABLE}.number_of_item_removed_from_cart>0, ${TABLE}.quantity,null) ;;
  }

  measure: number_of_inventory_movement_ids {
    group_label: "Total Metrics"
    label: "# Inventory Movement Ids"
    type: count_distinct
    sql: ${TABLE}.inventory_movement_id  ;;
  }

  measure: number_of_item_added_to_cart {
    group_label: "Total Metrics"
    label: "# Events Added To Cart"
    type: sum
    sql: ${TABLE}.number_of_item_added_to_cart ;;
  }

  measure: number_of_item_dropped {
    group_label: "Total Metrics"
    label: "# Events item Dropped"
    type: sum
    sql: ${TABLE}.number_of_item_dropped ;;
  }

  measure: number_of_item_removed_from_cart {
    group_label: "Total Metrics"
    label: "# Events Removed To Cart"
    type: sum
    sql: ${TABLE}.number_of_item_removed_from_cart ;;
  }
}
