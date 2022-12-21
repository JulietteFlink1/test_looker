
#
# This is a view for reporting status of orders in each of the state over time (i.e. order backlogs)
# Granularity:
#      - Day (order date)
#      - 30-minute time block
#      - Hub (hub_code)
#

view: order_backlog {
  sql_table_name: `flink-data-prod.reporting.order_backlog`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: max_rank {
    label: "Max rank"
    description: "Give value to this field to add limit to rank the hubs."
    type: number
  }

  parameter: metric_selector {
    label: "Choose metric"
    description: "Choose metric to sort Top/Bottom N Hubs based on selected metric. Could be used with the comination of rank function, rank limit dimension and Max rank parameter."
    type: string
    allowed_value: { value: "# Backlog Orders Created Not Offered for Picking (Not Dispatched)" }
    allowed_value: { value: "# Backlog Orders Created (Last Mile) Not Claimed By Riders" }
    allowed_value: { value: "# Backlog Orders Picked (Last Mile) Not Claimed By Riders" }
    allowed_value: { value: "# Backlog Orders Created (Last Mile) Not Picked" }
    allowed_value: { value: "# Backlog Orders Created Not Started Being Picked" }
    allowed_value: { value: "# Backlog Orders Offered (Dispatched) Not Started Being Picked" }
    allowed_value: { value: "# Backlog Orders (Last Mile) Not Offered to Riders" }
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: rank_limit {
    label: "Rank limit"
    description: "Value of the given rank by"
    type: number
    sql: {% parameter max_rank %} ;;
  }

  dimension: table_uuid {
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: start_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    hidden: yes
    sql: ${TABLE}.start_timestamp ;;
  }

  dimension: hub_code {
    type: string
    hidden: yes
    sql: ${TABLE}.hub_code ;;
  }

  dimension: number_of_created_successful_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_created_successful_orders ;;
  }

  dimension: number_of_created_successful_orders_last_mile {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_created_successful_orders_last_mile ;;
  }

  dimension: number_of_orders_not_picked {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders_not_picked ;;
  }

  dimension: number_of_orders_not_offered_for_picking {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders_not_offered_for_picking ;;
  }

  dimension: number_of_orders_not_picked_last_mile {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders_not_picked_last_mile ;;
  }

  dimension: number_of_orders_picking_not_started {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders_picking_not_started ;;
  }

  dimension: number_of_orders_rider_not_claimed_last_mile {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders_rider_not_claimed_last_mile ;;
  }

  dimension: number_of_picked_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_orders ;;
  }

  dimension: number_of_picked_orders_last_mile {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_orders_last_mile ;;
  }

  dimension: number_of_picking_started_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picking_started_orders ;;
  }

  dimension: number_of_rider_claimed_orders_last_mile {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_rider_claimed_orders_last_mile ;;
  }

  dimension: number_of_offered_to_riders_orders_last_mile {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_offered_to_riders_orders_last_mile ;;
  }

  dimension: number_of_orders_not_offered_to_riders_last_mile {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders_not_offered_to_riders_last_mile ;;
  }

  dimension: number_of_orders_not_on_route_last_mile {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders_not_on_route_last_mile ;;
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~      Measures      ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: backlog_orders_created_not_offered_for_picking {
    label: "# Backlog Orders Created Not Offered for Picking (Not Dispatched)"
    description: "Cumulative # of orders created but not offered for picking (not dispatched) during the day."
    type: sum
    sql: ${number_of_orders_not_offered_for_picking} ;;
  }

  measure: backlog_orders_created_rider_not_claimed_last_mile {
    label: "# Backlog Orders Created (Last Mile) Not Claimed By Riders"
    description: "Cumulative # of orders (last mile) created but not claimed by riders during the day."
    type: sum
    sql: ${number_of_orders_rider_not_claimed_last_mile} ;;
  }

  measure: backlog_orders_picked_rider_not_claimed_last_mile {
    label: "# Backlog Orders Picked (Last Mile) Not Claimed By Riders"
    description: "Cumulative # of orders (last mile) picked but not claimed by riders during the day."
    type: sum
    sql: ${number_of_orders_rider_not_claimed_last_mile}-${number_of_orders_not_picked_last_mile} ;;
  }

  measure: backlog_orders_created_not_picked_last_mile {
    label: "# Backlog Orders Created (Last Mile) Not Picked"
    description: "Cumulative # of orders (last mile) created but not finished being picked during the day."
    type: sum
    sql: ${number_of_orders_not_picked_last_mile} ;;
  }

  measure: backlog_orders_picking_not_started {
    label: "# Backlog Orders Created Not Started Being Picked"
    description: "Cumulative # of orders created but not started being picked during the day."
    type: sum
    sql: ${number_of_orders_picking_not_started} ;;
  }

  measure: backlog_orders_offered_picking_not_started {
    label: "# Backlog Orders Offered (Dispatched) Not Started Being Picked"
    description: "Cumulative # of orders created but not started being picked during the day."
    type: sum
    sql: ${number_of_orders_picking_not_started}-${number_of_orders_not_offered_for_picking} ;;
  }

  measure: backlog_orders_not_offered_to_riders_last_mile {
    label: "# Backlog Orders (Last Mile) Not Offered to Riders"
    description: "Cumulative # of orders created but not offered to riders during the day."
    type: sum
    sql: ${number_of_orders_not_offered_to_riders_last_mile} ;;
  }

  measure: max_backlog_orders_created_not_offered_for_picking {
    label: "MAX # Backlog Orders Created Not Offered for Picking (Not Dispatched)"
    description: "Maximum # of cumulative orders created but not offered for picking (not dispatched) during the day."
    type: max
    sql: ${number_of_orders_not_offered_for_picking} ;;
  }

  measure: max_backlog_orders_created_rider_not_claimed_last_mile {
    label: "MAX # Backlog Orders Created (Last Mile) Not Claimed By Riders"
    description: "Maximum # of cumulative orders (last mile) created but not claimed by riders during the day."
    type: max
    sql: ${number_of_orders_rider_not_claimed_last_mile} ;;
  }

  measure: max_backlog_orders_picked_rider_not_claimed_last_mile {
    label: "MAX # Backlog Orders Picked (Last Mile) Not Claimed By Riders"
    description: "Maximum # of cumulative orders (last mile) picked but not claimed by riders during the day."
    type: max
    sql: ${number_of_orders_rider_not_claimed_last_mile}-${number_of_orders_not_picked_last_mile} ;;
  }

  measure: max_backlog_orders_created_not_picked_last_mile {
    label: "MAX # Backlog Orders Created (Last Mile) Not Picked"
    description: "Maximum # of cumulative orders (last mile) created but not finished being picked during the day."
    type: max
    sql: ${number_of_orders_not_picked_last_mile} ;;
  }

  measure: max_backlog_orders_picking_not_started {
    label: "MAX # Backlog Orders Created Not Started Being Picked"
    description: "Maximum # of cumulative orders created but not started being picked during the day."
    type: max
    sql: ${number_of_orders_picking_not_started} ;;
  }

  measure: max_backlog_orders_offered_picking_not_started {
    label: "MAX # Backlog Orders Offered (Dispatched) Not Started Being Picked"
    description: "Maximum # of cumulative orders created but not started being picked during the day."
    type: max
    sql: ${number_of_orders_picking_not_started}-${number_of_orders_not_offered_for_picking} ;;
  }

  measure: max_backlog_orders_not_offered_to_riders_last_mile {
    label: "MAX # Backlog Orders (Last Mile) Not Offered to Riders"
    description: "Maximum # of cumulative orders created but not offered to riders during the day."
    type: max
    sql: ${number_of_orders_not_offered_to_riders_last_mile} ;;
  }

  measure: chosen_backlog_metric {
    label_from_parameter: metric_selector
    description: "Cumulative # of orders based on the chosen metric."
    type: number
    sql:
      case
        when {% parameter metric_selector %} = "# Backlog Orders Created Not Offered for Picking (Not Dispatched)"
          then ${max_backlog_orders_created_not_offered_for_picking}
        when {% parameter metric_selector %} = "# Backlog Orders Created (Last Mile) Not Claimed By Riders"
          then ${max_backlog_orders_created_not_offered_for_picking}
        when {% parameter metric_selector %} = "# Backlog Orders Picked (Last Mile) Not Claimed By Riders"
          then ${max_backlog_orders_picked_rider_not_claimed_last_mile}
        when {% parameter metric_selector %} = "# Backlog Orders Created (Last Mile) Not Picked"
          then ${max_backlog_orders_created_not_picked_last_mile}
        when {% parameter metric_selector %} = "# Backlog Orders Created Not Started Being Picked"
          then ${max_backlog_orders_picking_not_started}
        when {% parameter metric_selector %} = "# Backlog Orders Offered (Dispatched) Not Started Being Picked"
          then ${max_backlog_orders_offered_picking_not_started}
        when {% parameter metric_selector %} = "# Backlog Orders (Last Mile) Not Offered to Riders"
          then ${max_backlog_orders_not_offered_to_riders_last_mile}
      end ;;
  }

}
