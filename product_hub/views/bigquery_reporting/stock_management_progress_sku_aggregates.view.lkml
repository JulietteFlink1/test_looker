# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-07-14

view: stock_management_progress_sku_aggregates {
  sql_table_name: `flink-data-dev.dbt_falvarez.stock_management_progress_sku_aggregates`
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
    type: string
    sql: ${TABLE}.inventory_movement_id ;;
  }

  dimension: direction {
    type: string
    sql: ${TABLE}.direction ;;
  }

  dimension_group: time_to_cart_created {
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
    sql: ${TABLE}.time_to_cart_created ;;
  }

  dimension_group: time_to_dropping_list_created {
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
    sql: ${TABLE}.time_to_dropping_list_created ;;
  }

  dimension_group: time_to_dropping_list_finished {
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
    sql: ${TABLE}.time_to_dropping_list_finished ;;
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


  ### Hidden Columns ###

  dimension: number_of_item_added_to_cart {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_item_added_to_cart ;;
  }

  dimension: number_of_item_dropped {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_item_dropped ;;
  }

  dimension: number_of_item_removed_from_cart {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_item_removed_from_cart ;;
  }

  dimension: quantity {
    hidden: yes
    type: number
    sql: ${TABLE}.quantity ;;
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Measures.      ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ### Time to metrics ###

  dimension: cart_to_drop_list_seconds {
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list timestamps"
    type: number
    sql: DATETIME_DIFF(time_to_dropping_list_created,time_to_cart_created, SECOND) ;;
  }

  dimension: drop_list_created_to_finished_seconds {
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list_finished timestamps"
    type: number
    sql: DATETIME_DIFF(time_to_dropping_list_finished, time_to_dropping_list_created, SECOND) ;;
  }

  ### Sum and count Metrics ###

  measure: count {
    type: count
    drill_fields: [product_name]
  }

  measure: total_item_added_to_cart {
    group_label: "Total Metrics"
    label: "# Items Added To Cart"
    type: sum
    sql: if(${TABLE}.number_of_item_added_to_cart>0, ${TABLE}.quantity,0) ;;
  }

  measure: total_item_dropped {
    group_label: "Total Metrics"
    label: "# Items Dropped"
    type: sum
    sql: if(${TABLE}.number_of_item_dropped>0, ${TABLE}.quantity,0) ;;
  }

  measure: total_item_removed_from_cart {
    group_label: "Total Metrics"
    label: "# Items Removed From Cart"
    type: sum
    sql: if(${TABLE}.number_of_item_removed_from_cart>0, ${TABLE}.quantity,0) ;;
  }
}
