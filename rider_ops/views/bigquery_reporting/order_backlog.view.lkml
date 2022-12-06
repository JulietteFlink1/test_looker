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


  measure: backlog_orders_created_rider_not_claimed_last_mile {
    label: "# Backlog Orders Created (Last Mile) Not Claimed By Riders"
    description: "Cumulative # of orders (last mile) created but not claimed by riders during the day."
    type: sum
    sql: ${number_of_orders_rider_not_claimed_last_mile} ;;
  }

  measure: backlog_orders_picked_rider_not_claimed_last_mile {
    label: "# Backlog Orders Picked (Last Mile) Not Claimed By Riders"
    description: "Cumulative # of orders (last mile) created but not claimed by riders during the day."
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
}
