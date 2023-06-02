# Author: Justine Grammatikas
# Created on: 2023-06-01

view: hub_bottleneck_30min {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `flink-data-dev.dbt_jgrammatikas_curated.hub_bottleneck_30min`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Country Iso" in Explore.

  dimension: country_iso {
    hidden: yes
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: end_timestamp {
    type: time
    hidden:yes
    description: "The end of the 30-min time slot."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.end_timestamp ;;
  }

  dimension_group: event {
    type: time
    description: "Date when an event was triggered."
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
    hidden: yes
    sql: ${TABLE}.event_date ;;
  }

  dimension_group: event_working {
    type: time
    hidden: yes
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
    sql: ${TABLE}.event_working_date ;;
  }

  dimension: hub_code {
    hidden: yes
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: number_of_ordering_bottleneck_minutes {
    hidden: yes
    type: number
    description: "Number of minutes spent with order bottleneck. It means there were not enough orders for the given number of minutes."
    sql: ${TABLE}.number_of_ordering_bottleneck_minutes ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  dimension: number_of_picking_bottleneck_minutes {
    type: number
    hidden: yes
    description: "Number of minutes spent with ops associate bottleneck. It means there were not enough ops associates for the given number of minutes."
    sql: ${TABLE}.number_of_picking_bottleneck_minutes ;;
  }

  dimension: number_of_riding_bottleneck_minutes {
    type: number
    hidden: yes
    description: "Number of minutes spent with rider bottleneck. It means there were not enough riders for the given number of minutes."
    sql: ${TABLE}.number_of_riding_bottleneck_minutes ;;
  }

  dimension_group: start_timestamp {
    hidden: yes
    type: time
    description: "The start of the 30-min time slot."
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      minute30,
      quarter,
      year
    ]
    sql: ${TABLE}.start_timestamp ;;
  }

  dimension: table_uuid {
    primary_key: yes
    hidden: yes
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: timezone {
    hidden: yes
    type: string
    sql: ${TABLE}.timezone ;;
  }

 ####### Measures

  measure: sum_number_of_ordering_bottleneck_minutes {
    label: "SUM Ordering Bottleneck (min)"
    type: sum
    description: "Number of minutes spent with order bottleneck.  It means that not enough orders are coming in to keep riders and pickers busy. More info here: https://api.goflink.com/last-mile/dispatching-ui/dispatching-docs/bottleneck.html"
    sql: ${number_of_ordering_bottleneck_minutes} ;;
    value_format_name: decimal_1
  }

  measure: avg_number_of_ordering_bottleneck_minutes {
    label: "AVG Ordering Bottleneck (min)"
    type: average
    description: "AVG Number of minutes spent with order bottleneck.  It means that not enough orders are coming in to keep riders and pickers busy. More info here: https://api.goflink.com/last-mile/dispatching-ui/dispatching-docs/bottleneck.html
"
    sql: ${number_of_ordering_bottleneck_minutes} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_picking_bottleneck_minutes {
    label: "SUM Picking Bottleneck (min)"
    type: sum
    description: "Number of minutes spent with picking bottleneck. It means that not enough orders get picked to keep the riders busy. More info here: https://api.goflink.com/last-mile/dispatching-ui/dispatching-docs/bottleneck.html"
    sql: ${number_of_picking_bottleneck_minutes} ;;
    value_format_name: decimal_1
  }

  measure: avg_number_of_picking_bottleneck_minutes {
    label: "AVG Picking Bottleneck (min)"
    type: average
    description: "AVG Number of minutes spent with picking bottleneck.It means that not enough orders get picked to keep the riders busy. More info here: https://api.goflink.com/last-mile/dispatching-ui/dispatching-docs/bottleneck.html"
    sql: ${number_of_picking_bottleneck_minutes} ;;
    value_format_name: decimal_1
  }

  measure: sum_number_of_riding_bottleneck_minutes {
    label: "SUM Riding Bottleneck (min)"
    type: sum
    description: "Number of minutes spent with riding bottleneck.  It means that there are not enough riders to deliver the orders. More info here: https://api.goflink.com/last-mile/dispatching-ui/dispatching-docs/bottleneck.html"
    sql: ${number_of_riding_bottleneck_minutes} ;;
    value_format_name: decimal_1
  }

  measure: avg_number_of_riding_bottleneck_minutes {
    label: "AVG Riding Bottleneck (min)"
    type: average
    description: "AVG Number of minutes spent with riding bottleneck.  It means that there are not enough riders to deliver the orders. More info here: https://api.goflink.com/last-mile/dispatching-ui/dispatching-docs/bottleneck.html"
    sql: ${number_of_riding_bottleneck_minutes} ;;
    value_format_name: decimal_1
  }

  measure: share_of_ordering_bottleneck_minutes {
    label: "% Ordering Bottleneck"
    type: number
    description: "Share of total minutes spent with order bottleneck"
    sql: ${sum_number_of_ordering_bottleneck_minutes} / (${sum_number_of_ordering_bottleneck_minutes} + ${sum_number_of_riding_bottleneck_minutes} + ${sum_number_of_picking_bottleneck_minutes}) ;;
    value_format_name: percent_1
  }

  measure: share_of_picking_bottleneck_minutes {
    label: "% Picking Bottleneck"
    type: number
    description: "Share of total minutes spent with picking bottleneck"
    sql: ${sum_number_of_picking_bottleneck_minutes} / (${sum_number_of_ordering_bottleneck_minutes} + ${sum_number_of_riding_bottleneck_minutes} + ${sum_number_of_picking_bottleneck_minutes}) ;;
    value_format_name: percent_1
  }

  measure: share_of_riding_bottleneck_minutes {
    label: "% Riding Bottleneck"
    type: number
    description: "Share of total minutes spent with riding bottleneck"
    sql: ${sum_number_of_riding_bottleneck_minutes} / (${sum_number_of_ordering_bottleneck_minutes} + ${sum_number_of_riding_bottleneck_minutes} + ${sum_number_of_picking_bottleneck_minutes}) ;;
    value_format_name: percent_1
  }

}
