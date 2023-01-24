#Owner: James Davies
#Created: 2023-01-19


#This view is the onboarding task for new joiners


view: james_onboarding_task {
  sql_table_name: `flink-data-dev.dbt_jdavies_sandbox.james_onboarding_task`
    ;;
  view_label: "Order and Rider ouput last 30 days"

  dimension: country_iso {
    label: "Country ISO"
    description: "Country Code"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    label: "Hub Code"
    description: "Code for a given hub"
    type: string
    sql: ${TABLE}.hub_code ;;
  }


  dimension_group: order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: table_uuid {
    label: "Table UUID"
    description: "Unique identifier for each row of the table"
    type: string
    sql: ${TABLE}.table_uuid ;;
  }





  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: count {
    type: count
    drill_fields: []
  }


  measure: number_of_items {
  label: "# of Items"
  description: "The quantity of items sold"
  type: sum
  sql: ${TABLE}.number_of_items ;;

}


  measure: number_of_worked_employees {
    label: "# of Worked Employees"
    description: "Number of riders working"
    type: sum
    sql: ${TABLE}.number_of_worked_employees ;;

  }


measure: number_of_rider_hours {
  label: "# Rider Hours"
  description: "The sum of all the hours worked by all the riders working"
  type: sum
  sql: ${TABLE}.number_of_rider_hours ;;
  value_format_name: decimal_2

}

measure: number_of_orders {
  label: "# Orders"
  description: "# successful orders"
  type: sum
  sql: ${TABLE}.number_of_orders ;;

}

measure: number_of_orders_eligible_fulfillment_time {
  label: "# Orders eligibile fulfillment time"
  description: "Number of orders with a non null delivery time"
  type: sum
  sql: ${TABLE}.number_of_orders_eligible_fulfillment_time ;;
  hidden: yes
}

measure: total_fulfillment_time_minutes {
  label: "Total Fulfillment Time"
  description: "Total Fulfillment Time considering order placement to delivery (rider at customer). Outliers excluded (<3min or >210min)."
  type: sum
  sql: ${TABLE}.total_fulfillment_time_minutes ;;

}

measure: average_fulfillment_time_minutes {
  label: "AVG Fullfilment Time"
  description: "Average Fulfillment Time considering order placement to delivery (rider at customer). Outliers excluded (<3min or >210min). Decimal format."
  type:  number
  sql:  ${total_fulfillment_time_minutes}/${number_of_orders_eligible_fulfillment_time};;
  value_format_name: decimal_2

}

  measure: avg_fulfillment_time_mm_ss {
    label: "AVG Fulfillment Time (HH:MM:SS)"
    description: "Average Fulfillment Time considering order placement to delivery (rider at customer). Outliers excluded (<3min or >210min). HH:MM:SS format."
    type: number
    sql: ${total_fulfillment_time_minutes}/${number_of_orders_eligible_fulfillment_time} * 60 / 86400.0;;
    value_format: "hh:mm:ss"
  }


measure: average_number_of_items_per_order {
  label: "AVG Items per Order"
  description: "The average number of items per single order"
  type:  number
  sql:  ${number_of_items}/${number_of_orders} ;;
  value_format_name: decimal_2

 }

}
