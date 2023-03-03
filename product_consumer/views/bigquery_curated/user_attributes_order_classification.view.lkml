# Owner: Galina Larina
# Created: 2023-03-01

# This view contains classification of each order based on a set of rules. It is used to understand what jobs customers are using Flink for.

view: user_attributes_order_classification {
  sql_table_name: `flink-data-prod.curated.user_attributes_order_classification`;;
  view_label: "JTBD Order Classification"


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


  dimension: order_uuid {
    type: string
    description: "Unique identifier generated by back-end when an order is placed. It consists of a 'country_iso' prefix and the actual 'order_id'.
    This field appears within product data under \"event_order_placed\" and \"daily_user_aggregates\" models as well as back-end based data models such as \"orders\" and \"order_lineitems\"."
    primary_key: yes
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_local_order {
    type: yesno
    hidden: yes
    description: "If an order contans items that is available only in that one city. Local orders have been defined only for DE and AT market"
    sql: ${TABLE}.is_local_order ;;
  }

  dimension: order_classification {
    type: string
    group_label: "* Order Dimensions *"
    label: "Order Classification - Job to be Done"
    description: "Order classification based upon customer use cases of Flink (Breakfast, Part time, etc.). Currently, classification is based on a set of rules"
    sql: ${TABLE}.order_classification ;;
  }

 # ======= Dates / Timestamps ======= #
  dimension_group: order_timestamp {
    label: "Order Timestamp"
    description: "Timestamp of when an order was placed"
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      hour_of_day,
      quarter
    ]
    sql: ${TABLE}.order_timestamp ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Measures    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  measure: orders {
    label: "# Orders"
    description: "Number of placed orders"
    type: count_distinct
    sql: ${TABLE}.order_uuid ;;
  }

}
