# Owner: Product Analytics, Flavia Alvarez

view: stock_management_movement_ids {
  derived_table: {
    sql:WITH global_filters_and_parameters AS (select TRUE as generic_join_dim)
        SELECT
            (CASE WHEN stock_management_progress_sku_aggregates.is_handling_unit  THEN 'Yes' ELSE 'No' END) AS stock_management_progress_sku_aggregates_is_handling_unit,
                (stock_management_progress_sku_aggregates.event_date ) AS stock_management_progress_sku_aggregates_event_date,
            stock_management_progress_sku_aggregates.country_iso  AS stock_management_progress_sku_aggregates_country_iso,
            stock_management_progress_sku_aggregates.hub_code  AS stock_management_progress_sku_aggregates_hub_code,
            stock_management_progress_sku_aggregates.inventory_movement_id  AS stock_management_progress_sku_aggregates_inventory_movement_id,
            stock_management_progress_sku_aggregates.employee_id  AS stock_management_progress_sku_aggregates_employee_id,
            DATETIME_DIFF(time_to_dropping_list_created,time_to_cart_created, SECOND)  AS stock_management_progress_sku_aggregates_cart_to_drop_list_seconds,
            DATETIME_DIFF(time_to_dropping_list_finished, time_to_dropping_list_created, SECOND)  AS stock_management_progress_sku_aggregates_drop_list_created_to_finished_seconds,
            DATETIME_DIFF(time_to_dropping_list_finished, time_to_cart_created, SECOND)  AS stock_management_progress_sku_aggregates_cart_to_finished_seconds,
            COUNT(DISTINCT if(stock_management_progress_sku_aggregates.number_of_item_added_to_cart>0, stock_management_progress_sku_aggregates.sku,null) ) AS stock_management_progress_sku_aggregates_total_item_added_to_cart,
            COUNT(DISTINCT if(stock_management_progress_sku_aggregates.number_of_item_dropped>0, stock_management_progress_sku_aggregates.sku,null) ) AS stock_management_progress_sku_aggregates_total_item_dropped,
            COUNT(DISTINCT if(stock_management_progress_sku_aggregates.number_of_item_removed_from_cart>0, stock_management_progress_sku_aggregates.sku,null) ) AS stock_management_progress_sku_aggregates_total_item_removed_from_cart,
            COALESCE(SUM(stock_management_progress_sku_aggregates.quantity ), 0) AS stock_management_progress_sku_aggregates_quantity
        FROM `flink-data-dev.dbt_falvarez.stock_management_progress_sku_aggregates`
             AS stock_management_progress_sku_aggregates
        LEFT JOIN global_filters_and_parameters ON global_filters_and_parameters.generic_join_dim = TRUE
        WHERE (stock_management_progress_sku_aggregates.is_ean_available ) and {% condition global_filters_and_parameters.datasource_filter %} stock_management_progress_sku_aggregates.event_date {% endcondition %}
        GROUP BY
            1,2,3,4,5,6,7,8,9;;
  }
  dimension: event_date {
    label: "Stock Management Progress SKU Aggregates  Date"
    description: ""
    type: date
  }
  dimension: country_iso {
    label: "Stock Management Progress SKU Aggregates Country ISO"
    description: ""
  }
  dimension: hub_code {
    description: ""
  }
  dimension: inventory_movement_id {
    description: ""
  }
  dimension: employee_id {
    description: ""
  }
  dimension: cart_to_drop_list_seconds {
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list timestamps"
    type: number
  }
  dimension: drop_list_created_to_finished_seconds {
    description: "Difference in seconds between time_to_dropping_list_created and time_to_dropping_list_finished timestamps"
    type: number
  }
  dimension: cart_to_finished_seconds {
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list_finished timestamps"
    type: number
  }
  dimension: total_item_added_to_cart {
    label: "Stock Management Progress SKU Aggregates # Items Added To Cart"
    description: ""
    type: number
  }
  dimension: total_item_dropped {
    label: "Stock Management Progress SKU Aggregates # Items Dropped"
    description: ""
    type: number
  }
  dimension: total_item_removed_from_cart {
    label: "Stock Management Progress SKU Aggregates # Items Removed From Cart"
    description: ""
    type: number
  }
  dimension: quantity {
    description: ""
    type: number
  }
  dimension: is_handling_unit {
    label: "Stock Management Progress SKU Aggregates Is Handling Unit (Yes / No)"
    description: ""
    type: yesno
  }
}
