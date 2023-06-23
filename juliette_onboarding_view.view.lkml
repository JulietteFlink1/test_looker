# Owner: Juliette Hampton
# Created: 2023-06-14
# This view was created as part of my onboarding task. It was created from James Davies' table as I don't have access to dbt.
# Link here: https://goflink.atlassian.net/wiki/spaces/DATA/pages/362481154/Onboarding+Task

view: juliette_onboarding_view {

  sql_table_name: flink-data-dev.dbt_jdavies_sandbox.james_onboarding_task ;;

  view_label: "* Juliette Onboarding Task *"
  drill_fields: [core_dimensions*]

  ################################################
  #                DIMENSIONS                    #
  ################################################

  #---------------Core dimensions set---------------------------#

  set: core_dimensions {
    fields: [
      country_iso,
      hub_code,
      order_date,
      number_of_orders,
      number_of_worked_employees,
      number_of_rider_hours,
      avg_total_fulfillment_time_minutes,
      avg_total_fulfillment_time_minutes
    ]
  }

#---------------Main dimensions---------------------------#

  dimension: country_iso {

    label: "Country"
    group_label: "* Geographic Dimensions *"
    description: "Country where order was placed or attempted"

    type: string
    sql: ${TABLE}.country_iso ;;
  }


  dimension: hub_code {

    label: "Hub Code"
    group_label: "* Geographic Dimensions *"
    description: "Hub code where order was placed or attempted"

    type: string
    sql: ${TABLE}.hub_code ;;
  }


  dimension: order_date {

    label: "Order Date"
    group_label: "* Dates and Timestamps *"
    description: "Date when order was placed or attempted"

    type: date
    sql: ${TABLE}.order_date ;;
  }


  dimension: number_of_orders {

    label: "# Orders"
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    description: "Number of orders within given timeframe"

    type: number # should this be a count?
    sql: ${TABLE}.number_of_orders ;;

    value_format_name: decimal_0
  }

  # Question: should the type of number% tables be a count instead of a number?
  dimension: number_of_worked_employees {

    label: "# Riders"
    group_label: "* Operations / Logistics *"
    description: "Number of riders" # assuming that the original query filtered only for riders

    type: number
    sql: ${TABLE}.number_of_worked_employees ;;

    value_format_name: decimal_2
  }


  dimension: number_of_rider_hours {

    label: "# Rider Hours"
    group_label: "* Operations / Logistics *"
    description: "Number of riders hours"

    type: number
    sql: ${TABLE}.number_of_rider_hours ;;

    value_format_name: decimal_2
  }

#---------------Hidden dimensions---------------------------#

  dimension: table_uuid {

    group_label: "* Primary Key *"
    hidden:  yes

    primary_key: yes
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

  # Unsure why the dimension below was in the initial table. Should it be kept? Be hidden?
  dimension: number_of_orders_eligible_fulfillment_time {

    group_label: "* Basic Counts (Orders / Customers etc.) *"
    description: "Number of orders within given timeframe"
    hidden:  yes

    type: number
    sql: ${TABLE}.number_of_orders_eligible_fulfillment_time ;;

    value_format_name: decimal_0
  }


  dimension: total_fulfillment_time_minutes {

    label: "Total Fulfillment Tme in Minutes"
    group_label: "* Operations / Logistics *"
    description: "Total time taken in minutes to deliver to a customer from the moment they placed an order to delivery completion"
    hidden:  yes

    type: number
    sql: ${TABLE}.total_fulfillment_time_minutes ;;

    value_format_name: decimal_0
  }


  dimension: number_of_items_in_basket {

    label: "# Items per Basket"
    group_label: "* Order Dimensions *"
    description: "Number of items per order in the customer's basket"
    hidden:  yes

    type: number
    sql: ${TABLE}.number_of_items_in_basket ;;

    value_format_name: decimal_0
  }

  ################################################
  #                MEASURES                      #
  ################################################

  # is adding an AVG() function correct in the 2 following measures?
  measure: avg_total_fulfillment_time_minutes {

    label: "AVG Fulfillment Time in Minutes"
    description: "Average fulfillment time in minutes per order for a given timeframe and date granularity"

    type: average
    sql: AVG(${TABLE}.total_fulfillment_time_minutes);;

    value_format_name: decimal_2
  }


  # should the value_format_name below be decimal_0?
  measure: avg_number_of_items_in_basket {

    label: "AVG Number of Items per Basket"
    description: "Average items in basket per order for a given timeframe and date granularity"

    type: average
    sql: AVG(${TABLE}.number_of_items_in_basket);;

    value_format_name: decimal_2
  }
}
