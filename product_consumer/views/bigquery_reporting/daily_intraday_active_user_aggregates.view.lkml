# Owner: Galina Larina
# Created: 2022-12-13

# This view contains aggregated data on a product sku and product placements levels


view: daily_intraday_active_user_aggregates {
  sql_table_name: `flink-data-prod.reporting.daily_intraday_active_user_aggregates`;;
  view_label: "Daily Intraday Active User Aggregates"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Sets    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  set: dimensions {
    fields: [
      intraday_uuid,
      country_iso,
      hub_code,
      platform
    ]
  }

  set: time_dimensions {
    fields: [
      event_hour
    ]
  }

  set: user_measures {
    fields: [
      hourly_active_users,
      hourly_users_with_order
    ]
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= Dimensions ======= #

  dimension: intraday_uuid {
    group_label: "Dimensions"
    label: "Intraday UUID"
    type: string
    primary_key: yes
    hidden: yes
    description: "A unique identifier of event."
    sql: ${TABLE}.intraday_uuid ;;
  }

  dimension: country_iso {
    group_label: "Dimensions"
    label: "Country ISO"
    type: string
    hidden: no
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    label: "Hub Code"
    group_label: "Dimensions"
    type: string
    hidden: no
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: platform {
    label: "Platform"
    group_label: "Dimensions"
    type: string
    hidden: no
    description: "Platform which user used, can be 'web', 'android' or 'ios'."
    sql: ${TABLE}.platform ;;
  }

  # ======= Time Dimensions ======= #

  dimension_group: event_date {
    group_label: "Time Dimensions"
    label: "Event Date"
    type: time
    timeframes: [
      date
    ]
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension: event_hour {
    group_label: "Time Dimensions"
    label: "Event Hour"
    type: number
    sql: ${TABLE}.event_hour ;;
  }

  # =======  User Measures ======= #

  dimension: hourly_active_users {
    group_label: "Hourly Active Users"
    label: "Count of unique active users per."
    type: number
    description: "Total number of active users per hour"
    sql: ${TABLE}.hourly_active_users ;;
  }

  dimension: hourly_users_with_order {
    group_label: "Hourly Users with Order"
    label: "Count of unique users with order per hour."
    type: number
    description: "Total number of users who placed an order per hour."
    sql: ${TABLE}.hourly_users_with_order ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures    ~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


  ######## * Percentages * ########

  measure: pct_active_users_with_order {
    group_label: "* Percentages *"
    label: "% Active Users Ordering per Hour"
    description: "% Active Users who placed an order per hour."
    type: number
    sql: {hourly_users_with_order} / NULLIF(${hourly_active_users}, 0) ;;
    value_format_name: percent_1
  }
}
