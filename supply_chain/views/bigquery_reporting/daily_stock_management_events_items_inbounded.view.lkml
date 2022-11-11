# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
# - Hub-Ops team
#
# Questions that can be answered
# - All questions around stock management events (Inbounds)
# - questions concerning how well Flink inbounds


# The name of this view in Looker is "Daily Stock Management Events Items Inbounded"
view: daily_stock_management_events_items_inbounded {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `flink-data-prod.reporting.daily_stock_management_events_items_inbounded`
    ;;

  ####################################
  ############# Sets #################
  ####################################

  set: to_include_product {
    fields: [
      inbounding_time_hours,
      inbounding_time_minutes,
      avg_inbounding_time_minutes,
      dropping_time_hours,
      dropping_time_minutes,
      avg_dropping_time_minutes,
      populating_cart_time_hours,
      populating_cart_time_minutes,
      avg_populating_cart_time_minutes
    ]
    }

  set: to_include_vendor_performance {
    fields: [
      employee_id,
      event_date,
      event_week,
      sum_time_inbounding_in_hours,
      sum_time_inbounding_in_minutes,
      sum_total_quantity_items_inbounded,
      total_items_inbounded_per_hour,
      total_items_inbounded_per_minute,
      cnt_picker
    ]

  }

  ####################################
  ############# IDs ##################
  ####################################

  dimension: table_uuid {
    type: string
    description: "A generic identifier of a table in BigQuery that represent 1 unique row of this table."
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: employee_id {
    type: string
    description: "Unique identifier per hub employee"
    sql: ${TABLE}.employee_id ;;
  }

  dimension: inventory_movement_id {
    type: string
    description: "A unique identifier generated by back-end when an inventory movement is started (inbound, outbound or correction)."
    sql: ${TABLE}.inventory_movement_id ;;
    hidden: yes
  }


  ####################################
  ############# Dates ################
  ####################################

  dimension_group: cart_created {
    type: time
    description: "Timestamp when cart is created, meaning the time when we start the inbounding process"
    timeframes: [
      time,
      date,
      week
    ]
    sql: ${TABLE}.cart_created_at ;;
    hidden: yes
  }

  dimension_group: dropping_list_created {
    type: time
    description: "Timestamp when the dropping list is created, meaning the time when we start the dropping process."
    timeframes: [
      time,
      date,
      week
    ]
    sql: ${TABLE}.dropping_list_created_at ;;
    hidden: yes
  }

  dimension_group: dropping_list_finished {
    type: time
    description: "Timestamp when the dropping list is finished, meaning the time when we finish the inbounding process"
    timeframes: [
      time,
      date,
      week
    ]
    sql: ${TABLE}.dropping_list_finished_at ;;
    hidden: yes
  }

  dimension_group: event {
    type: time
    description: "Date when an event was triggered."
    label: "Report"
    timeframes: [
      date,
      week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  ####################################
  ############# Dimension ############
  ####################################

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Country Iso" in Explore.


  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
    group_label: "Geographic Data"
    hidden: yes
  }

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
    group_label: "Geographic Data"
    hidden: yes
  }

  dimension: event_definition {
    type: string
    description: "The actual inventory movement, could be Inbound/Outbound/Corrections etc"
    sql: ${TABLE}.event_definition ;;
    hidden: yes
  }

#Inbounding times

  dimension: time_populating_cart_in_hours {
    type: number
    description: "Time spent populating the cart during inbounding process in hours."
    sql: ${TABLE}.time_populating_cart_in_hours ;;
    hidden: yes
  }

  dimension: time_populating_cart_in_minutes {
    type: number
    description: "Time spent populating the cart during inbounding process in minutes."
    sql: ${TABLE}.time_populating_cart_in_minutes ;;
    hidden: yes
  }

  dimension: time_dropping_in_hours {
    type: number
    description: "Time spent dropping products on shelf during inbounding process in hours."
    sql: ${TABLE}.time_dropping_in_hours ;;
    hidden: yes
  }

  dimension: time_dropping_in_minutes {
    type: number
    description: "Time spent dropping products on shelf during inbounding process in minutes."
    sql: ${TABLE}.time_dropping_in_minutes ;;
    hidden: yes
  }

  dimension: time_inbounding_in_hours {
    type: number
    description: "Total duration of the inbounding process in hours."
    sql: ${TABLE}.time_inbounding_in_hours ;;
    hidden: yes
  }

  dimension: time_inbounding_in_minutes {
    type: number
    description: "Total duration of the inbounding process in minutes."
    sql: ${TABLE}.time_inbounding_in_minutes ;;
    hidden: yes
  }

# SKUs and Items Inbounded

  dimension: total_distinct_skus_inbounded {
    type: number
    description: "Total amount of distinct skus inbounded during the inbounding process"
    sql: ${TABLE}.total_distinct_skus_inbounded ;;
    hidden: yes
  }

  dimension: total_quantity_items_inbounded {
    type: number
    description: "Total amount of items inbounded during the inbounding process"
    sql: ${TABLE}.total_quantity_items_inbounded ;;
    hidden: yes
  }


  ####################################
  ############# Measures #############
  ####################################

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.


  measure: sum_time_inbounding_in_hours {
    label: "# Hours Inbounding per day"
    description: "Total of hours inbounding per day"
    type: sum
    sql: ${time_inbounding_in_hours} ;;

    value_format_name: decimal_0
  }

  measure: sum_time_inbounding_in_minutes {
    label: "# Minutes Inbounding per day"
    description: "Total of minutes inbounding per day"
    type: sum
    sql: ${time_inbounding_in_minutes} ;;

    value_format_name: decimal_0
  }

  measure: sum_total_quantity_items_inbounded {
    label: "# Items Inbounded per day"
    description: "Total amount of items inbounded per day"
    type: sum
    sql: ${total_quantity_items_inbounded} ;;

    value_format_name: decimal_0
  }

  measure: total_items_inbounded_per_hour {
    label: "# Items Inbounded per Hour"
    description: "Total amount of items inbounded per hour"
    type: number

    sql: safe_divide(${sum_total_quantity_items_inbounded}, ${sum_time_inbounding_in_hours})  ;;

    value_format_name: decimal_2
  }

  measure: total_items_inbounded_per_minute {
    label: "# Items Inbounded per Minute"
    description: "Total amount of items inbounded per minute"
    type: number

    sql: safe_divide(${sum_total_quantity_items_inbounded}, ${sum_time_inbounding_in_minutes})  ;;

    value_format_name: decimal_2
  }

  measure: cnt_picker {
    label: "# Unique Picker"
    description: "The number of unique picker (based on unique employee-ID)"

    type: count_distinct
    sql: ${employee_id} ;;
    value_format_name: decimal_0
  }

  ####################################
  ####### Product Measures ###########
  ####################################
  #Everything will be unified when migrate to hubOne

  measure: inbounding_time_hours {
    label: "# Hours Inbounding"
    description: "Total duration of the inbounding process in hours (from cart_created to dropping_list_finished)."
    type: sum_distinct
    sql: ${time_inbounding_in_hours} ;;

    value_format_name: decimal_0
  }

  measure: inbounding_time_minutes {
    label: "# Minutes Inbounding"
    description: "Total duration of the inbounding process in hours (from cart_created to dropping_list_finished)."
    type: sum_distinct
    sql: ${time_inbounding_in_minutes} ;;

    value_format_name: decimal_0
  }

  measure: avg_inbounding_time_minutes {
    label: "Avg Minutes Inbounding"
    description: "Avg duration of the inbounding process in hours (from cart_created to dropping_list_finished)."
    type: average_distinct
    sql: ${time_inbounding_in_minutes} ;;

    value_format_name: decimal_2
  }

  measure: dropping_time_hours {
    label: "# Hours Dropping"
    description: "Total duration of the inbounding process in hours (from cart_created to dropping_list_finished)."
    type: sum_distinct
    sql: ${time_dropping_in_hours} ;;

    value_format_name: decimal_0
  }

  measure: dropping_time_minutes {
    label: "# Minutes Dropping"
    description: "Total time spent dropping products on shelf during inbounding process in minutes (from dropping_list_started to dropping_list_finished)."
    type: sum_distinct
    sql: ${time_dropping_in_minutes} ;;

    value_format_name: decimal_0
  }

  measure: avg_dropping_time_minutes {
    label: "Avg Minutes Dropping"
    description: "Avg time spent dropping products on shelf during inbounding process in minutes (from dropping_list_started to dropping_list_finished)."
    type: average_distinct
    sql: ${time_dropping_in_minutes} ;;

    value_format_name: decimal_2
  }

  measure: populating_cart_time_hours {
    label: "# Hours Populating Cart"
    description: "Total time spent populating the cart during inbounding process in hours (from cart_created to dropping_list_started)."
    type: sum_distinct
    sql: ${time_populating_cart_in_hours} ;;

    value_format_name: decimal_0
  }

  measure: populating_cart_time_minutes {
    label: "# Minutes Populating Cart"
    description: "Total time spent populating the cart during inbounding process in minutes (from cart_created to dropping_list_started)."
    type: sum_distinct
    sql: ${time_populating_cart_in_minutes} ;;

    value_format_name: decimal_0
  }

  measure: avg_populating_cart_time_minutes {
    label: "Avg Minutes Populating Cart"
    description: "Avg time spent populating the cart during inbounding process in minutes (from cart_created to dropping_list_started)."
    type: average_distinct
    sql: ${time_populating_cart_in_minutes} ;;

    value_format_name: decimal_2
  }
}
