# Owner: Product Analytics, Flavia Alvarez

view: stock_management_movement_ids {
  derived_table: {
    sql:WITH global_filters_and_parameters AS (select TRUE as generic_join_dim)
        SELECT
            --(CASE WHEN stock_management_progress_sku_aggregates.is_handling_unit  THEN 'Yes' ELSE 'No' END) AS is_handling_unit,
                (stock_management_progress_sku_aggregates.event_date ) AS event_date,
            stock_management_progress_sku_aggregates.country_iso  AS country_iso,
            stock_management_progress_sku_aggregates.hub_code  AS hub_code,
            stock_management_progress_sku_aggregates.inventory_movement_id  AS inventory_movement_id,
            stock_management_progress_sku_aggregates.employee_id  AS employee_id,
            DATETIME_DIFF(dropping_list_created_time,cart_created_time, SECOND)  AS cart_to_drop_list_seconds,
            DATETIME_DIFF(dropping_list_finished_time, dropping_list_created_time, SECOND)  AS drop_list_created_to_finished_seconds,
            DATETIME_DIFF(dropping_list_finished_time, cart_created_time, SECOND)  AS cart_to_finished_seconds,
            COUNT(DISTINCT if(stock_management_progress_sku_aggregates.number_of_item_added_to_cart>0, concat(stock_management_progress_sku_aggregates.sku, stock_management_progress_sku_aggregates.inventory_movement_id),null) ) AS number_of_item_added_to_cart,
            COUNT(DISTINCT if(stock_management_progress_sku_aggregates.number_of_item_dropped>0, concat(stock_management_progress_sku_aggregates.sku, stock_management_progress_sku_aggregates.inventory_movement_id),null) ) AS number_of_item_dropped,
            COUNT(DISTINCT if(stock_management_progress_sku_aggregates.number_of_item_removed_from_cart>0, concat(stock_management_progress_sku_aggregates.sku, stock_management_progress_sku_aggregates.inventory_movement_id),null) ) AS number_of_item_removed_from_cart,
            COALESCE(SUM(stock_management_progress_sku_aggregates.quantity ), 0) AS quantity
        FROM `flink-data-prod.reporting.stock_management_progress_sku_aggregates`
             AS stock_management_progress_sku_aggregates
        LEFT JOIN global_filters_and_parameters ON global_filters_and_parameters.generic_join_dim = TRUE
        WHERE (stock_management_progress_sku_aggregates.is_ean_available ) and {% condition global_filters_and_parameters.datasource_filter %} stock_management_progress_sku_aggregates.event_date {% endcondition %}
        GROUP BY
            1,2,3,4,5,6,7,8;;
  }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ### Primary Key ###
  dimension: inventory_movement_id {
    primary_key: yes
    description: ""
  }

  ### Dates ###
  dimension: event_date {
    label: "Event Date"
    description: ""
    type: date
    convert_tz: no
  }

  ### Location Atributes ###
  dimension: country_iso {
    group_label: "Location Dimensions"
    label: "Country ISO"
    description: ""
  }
  dimension: hub_code {
    group_label: "Location Dimensions"
    description: ""
  }

  ### Employee Attributes ###

  dimension: employee_id {
    group_label: "Employee Attributes"
    description: ""
  }

  ### Inventory Process Attributes ###
  dimension: cart_to_drop_list_seconds {
    group_label: "Inventory Process Attributes"
    hidden: yes
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list timestamps"
    type: number
  }
  dimension: drop_list_created_to_finished_seconds {
    group_label: "Inventory Process Attributes"
    hidden: yes
    description: "Difference in seconds between time_to_dropping_list_created and time_to_dropping_list_finished timestamps"
    type: number
  }
  dimension: cart_to_finished_seconds {
    group_label: "Inventory Process Attributes"
    hidden: yes
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list_finished timestamps"
    type: number
  }
  dimension: number_of_item_added_to_cart {
    group_label: "Inventory Process Aggregates"
    label: "# Items Added To Cart"
    description: ""
    type: number
  }
  dimension: number_of_item_dropped {
    group_label: "Inventory Process Aggregates"
    label: "# Items Dropped"
    description: ""
    type: number
  }
  dimension: number_of_item_removed_from_cart {
    group_label: "Inventory Process Aggregates"
    label: "# Items Removed From Cart"
    description: ""
    type: number
  }
  dimension: quantity {
    group_label: "Inventory Process Aggregates"
    description: ""
    type: number
  }


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Measures.      ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 ### Product Times ###
  measure: time_to_inbound_quantity {
    label: "Avg time to inbound products"
    group_label: "Inbound Times"
    description: ""
    type: average
    value_format: "0"
    sql: SAFE_DIVIDE(${cart_to_finished_seconds},${quantity}) ;;
  }

  measure: time_to_inbound_items {
    label: "Avg time to inbound skus"
    group_label: "Inbound Times"
    description: ""
    type: average
    value_format: "0"
    sql: SAFE_DIVIDE(${cart_to_finished_seconds},${number_of_item_dropped}) ;;
  }

  measure: avg_cart_to_drop_list_seconds {
    group_label: "Inbound Times"
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list timestamps"
    type: average
    value_format: "0"
    sql: ${TABLE}.cart_to_drop_list_seconds ;;
  }

  measure: avg_drop_list_created_to_finished_seconds {
    group_label: "Inbound Times"
    description: "Difference in seconds between time_to_dropping_list_created and time_to_dropping_list_finished timestamps"
    type: average
    value_format: "0"
    sql: ${TABLE}.drop_list_created_to_finished_seconds ;;
  }

  measure: avg_cart_to_finished_seconds {
    group_label: "Inbound Times"
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list_finished timestamps"
    type: average
    value_format: "0"
    sql: ${TABLE}.cart_to_finished_seconds ;;
  }
  # dimension: is_handling_unit {
  #   label: "Stock Management Progress SKU Aggregates Is Handling Unit (Yes / No)"
  #   description: ""
  #   type: yesno
  # }
}
