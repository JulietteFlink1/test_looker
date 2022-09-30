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
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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

  dimension: time_inbounding_in_hours {
    type: number
    description: "Total duration of the inbounding process in hours"
    sql: ${TABLE}.time_inbounding_in_hours ;;
    hidden: yes
  }

  dimension: time_inbounding_in_minutes {
    type: number
    description: "Total duration of the inbounding process in minutes"
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
    group_label: "Inbound Speed Metrics"
    description: "Total of hours inbounding per day"
    type: sum
    sql: ${time_inbounding_in_hours} ;;

    value_format_name: decimal_0

  }

  measure: sum_time_inbounding_in_minutes {
    label: "# Minutes Inbounding per day"
    group_label: "Inbound Speed Metrics"
    description: "Total of minutes inbounding per day"
    type: sum
    sql: ${time_inbounding_in_minutes} ;;

    value_format_name: decimal_0

  }

  measure: sum_total_quantity_items_inbounded {
    label: "# Items Inbounded per day"
    group_label: "Inbound Speed Metrics"
    description: "Total amount of items inbounded per day"
    type: sum
    sql: ${total_quantity_items_inbounded} ;;

    value_format_name: decimal_0

  }

  measure: total_items_inbounded_per_hour {
    label: "# Items Inbounded per Hour"
    group_label: "Inbound Speed Metrics"
    description: "Total amount of items inbounded per hour"
    type: number

    sql: safe_divide(${sum_total_quantity_items_inbounded}, ${sum_time_inbounding_in_hours})  ;;

    value_format_name: decimal_2

  }

  measure: total_items_inbounded_per_minute {
    label: "# Items Inbounded per Minute"
    group_label: "Inbound Speed Metrics"
    description: "Total amount of items inbounded per minute"
    type: number

    sql: safe_divide(${sum_total_quantity_items_inbounded}, ${sum_time_inbounding_in_minutes})  ;;

    value_format_name: decimal_2

  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
