# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-11-08
# Last Modified: 2022-11-28

view: adoption_rate_hub_one {
  sql_table_name: `flink-data-prod.reporting.adoption_rate_hub_one`
    ;;

  # This is a table from the reporting layer that calculates adoption rates for the flow migrated to hubOne

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Sets          ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  IDs   =========

  dimension: table_uuid {
    primary_key: yes
    hidden: yes
    type: string
    description: "Concatenation of date and hub_code."
    sql: ${TABLE}.table_uuid ;;
  }

    # =========  Location Dimensions   =========

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  # =========  Dates and Timestamps   =========

  dimension_group: event {
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Picking Flow   =========

  measure: number_of_orders {
    type: sum
    group_label: "Picking Flow"
    label: "# of Orders"
    description: "Count of orders from order table."
    sql: ${TABLE}.number_of_orders ;;
  }

  measure: hub_one_orders {
    type: sum
    group_label: "Picking Flow"
    label: "# of HubOne Orders"
    description: "Count of orders from hub one."
    sql: ${TABLE}.hub_one_orders ;;
  }

  measure: picker_app_orders {
    type: sum
    group_label: "Picking Flow"
    label: "# of Picker App Orders"
    description: "Count of orders from picker app."
    sql: ${TABLE}.picker_app_orders ;;
  }

  measure: picking_adoption_rate {
    type: number
    group_label: "Picking Flow"
    value_format: "0.00%"
    description: "Percentage of HubOne Orders over Total Orders."
    sql: ${hub_one_orders}/${number_of_orders} ;;
  }

  # =========  Inventory Checks Flow   =========

  measure: number_of_checks {
    type: sum
    group_label: "Inventory Checks Flow"
    label: "# of Checks"
    description: "Count of checks from smart_inventory_checks table with status in (done, open and skipped)."
    sql: ${TABLE}.number_of_checks ;;
  }

  measure: number_of_checks_smart_inventory {
    type: sum
    group_label: "Inventory Checks Flow"
    label: "# of Checks Smart Inventory"
    description: "Count of check_id from the old service backend (smart_inventory)."
    sql: ${TABLE}.number_of_checks_smart_inventory ;;
  }

  measure: number_of_checks_hub_task {
    type: sum
    group_label: "Inventory Checks Flow"
    label: "# of Checks Hub Task"
    description: "  Count of check_id from the new service backend (hub_task)."
    sql: ${TABLE}.number_of_checks_hub_task ;;
  }
  measure: number_of_completed_checks {
    type: sum
    group_label: "Inventory Checks Flow"
    label: "# of Completed Checks"
    description: "Count of checks from smart_inventory_checks table with status=done."
    sql: ${TABLE}.number_of_completed_checks ;;
  }

  measure: number_of_completed_checks_smart_inventory {
    type: sum
    group_label: "Inventory Checks Flow"
    label: "# of Completed Checks Smart Inventory"
    description: "Count of check_id with status = done from the old service backend (smart_inventory)."
    sql: ${TABLE}.number_of_completed_checks_smart_inventory ;;
  }

  measure: number_of_completed_checks_hub_task {
    type: sum
    group_label: "Inventory Checks Flow"
    label: "# of Completed Checks Hub Task"
    description: "Count of check_id with status = done from the new service backend (hub_task)."
    sql: ${TABLE}.number_of_completed_checks_hub_task ;;
  }

  measure: hub_one_completed_checks {
    type: sum
    group_label: "Inventory Checks Flow"
    label: "# of HubOne Completed Checks"
    description: "Count of completed checks from hub one."
    sql: ${TABLE}.hub_one_completed_checks ;;
  }

  measure: inventory_checks_adoption_rate {
    type: number
    group_label: "Inventory Checks Flow"
    value_format: "0.00%"
    description: "Percentage of HubOne Completed Checks over Total Completed Checks."
    sql: ${hub_one_completed_checks}/if(${number_of_completed_checks}=0, null,${number_of_completed_checks})  ;;
  }

  # =========  Inbounding Flow   =========

  measure: legacy_quantity_manual {
    type: sum
    group_label: "Inbounding Flow"
    label: "Quantity Inbounded Manual"
    description: "Sum of quantity inbounded from manual inbounding."
    sql: ${TABLE}.legacy_quantity_dropped ;;
  }

  measure: legacy_quantity_dropped {
    type: sum
    group_label: "Inbounding Flow"
    label: "Quantity Dropped Legacy"
    description: "Sum of quantity inbounded from legacy dropping list."
    sql: ${TABLE}.legacy_quantity_dropped ;;
  }

  measure: hub_one_quantity_dropped {
    type: sum
    group_label: "Inbounding Flow"
    label: "Quantity Dropped Hub One"
    description: "Sum of quantity inbounded from hub one."
    sql: ${TABLE}.hub_one_quantity_dropped ;;
  }

  measure: inbounding_adoption_rate {
    type: number
    group_label: "Inbounding Flow"
    value_format: "0.00%"
    description: "Percentage of HubOne Quantity Dropped over Total Quantity Inbounded (Quantity Inbounded Manual + Quantity Dropped Legacy + Quantity Dropped Hub One)."
    sql: SAFE_DIVIDE(${hub_one_quantity_dropped},${legacy_quantity_manual}+${legacy_quantity_dropped}+${hub_one_quantity_dropped})  ;;
  }
}
