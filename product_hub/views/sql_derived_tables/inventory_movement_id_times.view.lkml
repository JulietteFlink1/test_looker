# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-09-12

view: inventory_movement_id_times {
  derived_table: {
    sql: WITH global_filters_and_parameters AS (select TRUE as generic_join_dim)
    SELECT
            daily_stock_management_events.inventory_movement_id  AS inventory_movement_id
            , max(if(action in ('cart_created'), event_timestamp, null)) as cart_created_time
            , max(if(action in ('dropping_list_created'), event_timestamp, null)) as dropping_list_created_time
            , max(if(action in ('dropping_list_finished'), event_timestamp, null)) as dropping_list_finished_time
            , DATETIME_DIFF(max(if(action in ('dropping_list_created'), event_timestamp, null))
              ,max(if(action in ('cart_created'), event_timestamp, null)), SECOND)  AS cart_to_drop_list_seconds
            , DATETIME_DIFF(max(if(action in ('dropping_list_finished'), event_timestamp, null))
              , max(if(action in ('dropping_list_created'), event_timestamp, null)), SECOND)  AS drop_list_created_to_finished_seconds
            , DATETIME_DIFF(max(if(action in ('dropping_list_finished'), event_timestamp, null))
              , max(if(action in ('cart_created'), event_timestamp, null)), SECOND)  AS cart_to_finished_seconds
        FROM `flink-data-prod.curated.daily_stock_management_events`
             AS daily_stock_management_events
        LEFT JOIN global_filters_and_parameters ON global_filters_and_parameters.generic_join_dim = TRUE
        where
        event_name in ('inventory_state_updated')
          and inventory_movement_id is not null
         and {% condition global_filters_and_parameters.datasource_filter %} date(daily_stock_management_events.event_timestamp) {% endcondition %}
        GROUP BY
            1 ;;
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: inventory_movement_id {
    primary_key: yes
    label: "Daily Stock Management Events Inventory Movement Id"
    description: "A unique identifier generated by back-end when an inventory movement is started (inbound, outbound or correction)."
  }
  dimension: cart_created_time {
    description: "Timestamp for when the cart has been created."
    type: number
  }
  dimension: dropping_list_created_time {
    description: "Timestamp for when the dropping list has been created."
    type: number
  }
  dimension: dropping_list_finished_time {
    description: "Timestamp for when the dropping list has been finished."
    type: number
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

  dimension: event_timestamp_date {
    hidden: yes
    label: "Event Date"
    description: "Timestamp of when an event happened"
    type: date
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # Note that for this measures to be accurate we need to use sum_distinct with sql_distinct_key = order_id
  # This is because this view is being joined to daily_events and if we use a normal sum it will be suming
  # duplicate values

  measure: avg_cart_to_drop_list_seconds {
    label: "Avg Cart To Drop List seconds"
    description: "Avg cart_to_drop_list time in seconds."
    type: average_distinct
    value_format: "0"
    sql_distinct_key: ${inventory_movement_id} ;;
    sql: ${cart_to_drop_list_seconds} ;;
  }

  measure: avg_drop_list_created_to_finished_seconds {
    label: "Avg Drop List Created to Finished seconds"
    description: "Avg drop_list_created_to_finished time in seconds."
    type: average_distinct
    value_format: "0"
    sql_distinct_key: ${inventory_movement_id} ;;
    sql: ${drop_list_created_to_finished_seconds} ;;
  }

  measure: avg_cart_to_finished_seconds {
    label: "Avg Cart to Finished seconds"
    description: "Avg cart_to_finished time in seconds."
    type: average_distinct
    value_format: "0.#"
    sql_distinct_key: ${inventory_movement_id} ;;
    sql: ${cart_to_finished_seconds} ;;
  }

  measure: sum_cart_to_finished_seconds {
    label: "Sum Cart to Finished seconds"
    description: "Sum cart_to_finished time in seconds."
    type: sum_distinct
    value_format: "0.#"
    sql_distinct_key: ${inventory_movement_id} ;;
    sql: ${cart_to_finished_seconds} ;;
  }

  # measure: avg_of_cart_to_drop_list_minutes {
  #   label: "Cart To Drop List minutes"
  #   description: "Avg cart_to_drop_list time in minutes."
  #   type: average_distinct
  #   value_format: "0"
  #   sql: ${avg_cart_to_drop_list_seconds}/60 ;;
  # }

  # measure: avg_drop_list_created_to_finished_minutes {
  #   label: "Drop List Created to Finished minutes"
  #   description: "Avg drop_list_created_to_finished time in minutes."
  #   type: average_distinct
  #   value_format: "0"
  #   sql: ${avg_drop_list_created_to_finished_seconds}/60 ;;
  # }

  # measure: sum_of_cart_to_finished_seconds {
  #   label: "Cart to Finished seconds"
  #   description: "Avg cart_to_finished time in seconds."
  #   type: average_distinct
  #   value_format: "0.#"
  #   sql_distinct_key: ${inventory_movement_id} ;;
  #   sql: ${cart_to_finished_seconds} ;;
  # }
}
